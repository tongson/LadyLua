package ll

import (
	"embed"
	"fmt"
	"os"

	gluacrypto "github.com/tongson/LadyLua/external/gluacrypto/crypto"
	"github.com/tongson/LadyLua/external/gluahttp"
	mysql "github.com/tongson/LadyLua/external/gluasql/mysql"
	ljson "github.com/tongson/LadyLua/external/gopher-json"
	"github.com/tongson/LadyLua/external/gopher-lfs"
	"github.com/yuin/gopher-lua"
	"github.com/tongson/LadyLua/internal"
)

//go:embed internal/lua/*
var luaSrc embed.FS

//# = loader.go
//# :toc:
//# :toc-placement!:
//#
//# Module loaders.
//#
//# toc::[]
//#
//# == *ll.Preload*(*lua.LState)
//# Add `package.loaders` entry for loading plain Lua modules from `internal/lua`. +
//# This allows Lua code to `require()` these modules.
func Preload(L *lua.LState) {
	embedLoader := func(l *lua.LState) int {
		name := l.CheckString(1)
		src, _ := luaSrc.ReadFile(fmt.Sprintf("internal/lua/%s.lua", name))
		fn, _ := l.LoadString(string(src))
		l.Push(fn)
		return 1
	}
	loaders := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "loaders")
	if ltb, ok := loaders.(*lua.LTable); ok {
		ltb.RawSetInt(3, L.NewFunction(embedLoader))
	}
	rloaders := L.GetField(L.Get(lua.RegistryIndex), "_LOADERS")
	if rtb, ok := rloaders.(*lua.LTable); ok {
		rtb.RawSetInt(3, L.NewFunction(embedLoader))
	}
}

//#
//# == *ll.LoadPatch*(*lua.LState, string)
//# For monkey-patching Lua values.
//#
//# [NOTE]
//# ====
//# Severely degrades VM start up time.
//# ====
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Basename of Lua source in `internal/lua`
//# |===
func LoadPatch(L *lua.LState, mod string) {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("internal/lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

//#
//# == *ll.LoadGlobalLua*(*lua.LState, string)
//# For adding Lua values into the global `_G` environment.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Basename of Lua source in `internal/lua`
//# |===
func LoadGlobalLua(L *lua.LState, mod string) {
	L.SetGlobal(mod, L.NewTable())
	src, _ := luaSrc.ReadFile(fmt.Sprintf("internal/lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

//#
//# == *ll.Main*(*lua.LState, string)
//# The entrypoint(main) Lua code for standalone projects.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Lua source code
//# |===
func Main(L *lua.LState, src string) error {
	return L.DoString(src)
}

//#
//# == *ll.PreloadModule*(*lua.LState, string, string)
//# Load plain Lua modules into `package.preload`. Useful for your own Lua modules loaded from standalone projects.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Name of the module
//# |string |Lua source code
//# |===
func PreloadModule(L *lua.LState, name string, src string) {
	fn, err := L.LoadString(string(src))
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	preload := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "preload")
	L.SetField(preload, name, fn)
}

//#
//# == *ll.LoadGlobalGo*(*lua.LState, string)
//# Load gopher-lua (Go) module into the global `_G` environment. +
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Name of the module
//# |===
func LoadGlobalGo(L *lua.LState, name string) {
	if name == "exec" {
		L.SetGlobal("exec", L.NewTable())
		nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
		L.SetField(nsExec, "command", L.NewFunction(ll.ExecCommand))
		L.SetField(nsExec, "ctx", L.NewFunction(ll.ExecCtx))
		return
	}
	if name == "fs" {
		nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
		L.SetGlobal("fs", nsFs)
		L.SetField(nsFs, "isdir", L.NewFunction(ll.FsIsdir))
		L.SetField(nsFs, "isfile", L.NewFunction(ll.FsIsfile))
		L.SetField(nsFs, "read", L.NewFunction(ll.FsRead))
		L.SetField(nsFs, "write", L.NewFunction(ll.FsWrite))
		return
	}
	if name == "os" {
		nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
		L.SetField(nsOs, "hostname", L.NewFunction(ll.OsHostname))
		L.SetField(nsOs, "outbound_ip", L.NewFunction(ll.OsOutboundIP))
		L.SetField(nsOs, "sleep", L.NewFunction(ll.OsSleep))
		return
	}
	if name == "extend" {
		L.SetGlobal("extend", L.NewFunction(ll.Extend))
		return
	}
	L.RaiseError("Unknown module.")
}

//#
//# == *ll.PreloadGo*(*lua.LState, string)
//# Load gopher-lua (Go) module into `package.preload`. +
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Name of the module
//# |===
func PreloadGo(L *lua.LState, name string) {
	switch name {
	case "json":
		L.PreloadModule("json", ljson.Loader)
	case "http":
		L.PreloadModule("http", gluahttp.Xloader)
	case "mysql":
		L.PreloadModule("mysql", mysql.Loader)
	case "crypto":
		L.PreloadModule("crypto", gluacrypto.Loader)
	case "ksuid":
		L.PreloadModule("ksuid", ll.KsuidLoader)
	case "lz4":
		L.PreloadModule("lz4", ll.Lz4Loader)
	case "telegram":
		L.PreloadModule("telegram", ll.TelegramLoader)
	case "pushover":
		L.PreloadModule("pushover", ll.PushoverLoader)
	case "slack":
		L.PreloadModule("slack", ll.SlackLoader)
	case "logger":
		L.PreloadModule("logger", ll.LoggerLoader)
	case "fsnotify":
		L.PreloadModule("fsnotify", ll.FsnLoader)
	case "bitcask":
		L.PreloadModule("bitcask", ll.BitcaskLoader)
	case "refmt":
		L.PreloadModule("refmt", ll.RefmtLoader)
	case "rr":
		L.PreloadModule("rr", ll.RrLoader)
	case "uuid":
		L.PreloadModule("uuid", ll.UuidLoader)
	case "ulid":
		L.PreloadModule("ulid", ll.UlidLoader)
	case "redis":
		L.PreloadModule("redis", ll.RedisLoader)
	case "ssh_config":
		L.PreloadModule("ssh_config", ll.SSHconfigLoader)
	default:
		L.RaiseError("Unknown module.")
	}
}
