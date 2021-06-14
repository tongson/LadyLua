package ll

import (
	"embed"
	"fmt"
	gluacrypto "github.com/tongson/LadyLua/external/gluacrypto/crypto"
	"github.com/tongson/LadyLua/external/gluahttp"
	mysql "github.com/tongson/LadyLua/external/gluasql/mysql"
	ljson "github.com/tongson/LadyLua/external/gopher-json"
	"github.com/tongson/LadyLua/external/gopher-lfs"
	"github.com/yuin/gopher-lua"
	"github.com/tongson/LadyLua/internal"
	"os"
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
//# == *ll.EmbedLoader*(*lua.LState)
//# Add `package.loaders` entry for loading plain Lua modules from `internal/src/lua`. +
//# This allows Lua code to `require()` these modules.
func EmbedLoader(L *lua.LState) {
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
//# == *ll.PatchLoader*(*lua.LState, string)
//# For monkey-patching Lua values. +
//# One example is in `internal/src/lua/table.lua`. It adds custom functions to the global `table` value.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Basename of Lua source in `internal/src/lua`
//# |===
func PatchLoader(L *lua.LState, mod string) {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("internal/lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

//#
//# == *ll.LuaGlobalLoader*(*lua.LState, string)
//# For adding Lua values into the global `_G` environment.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Basename of Lua source in `internal/src/lua`
//# |===
func LuaGlobalLoader(L *lua.LState, mod string) {
	L.SetGlobal(mod, L.NewTable())
	src, _ := luaSrc.ReadFile(fmt.Sprintf("internal/lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

//#
//# == *ll.MainLoader*(*lua.LState, string)
//# The entrypoint(main) Lua code for standalone projects.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Lua source code
//# |===
func MainLoader(L *lua.LState, src string) {
	if err := L.DoString(src); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
}

//#
//# == *ll.ModuleLoader*(*lua.LState, string, string)
//# Load plain Lua modules into `package.preload`. Useful for your own Lua modules loaded from standalone projects.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Name of the module
//# |string |Lua source code
//# |===
func ModuleLoader(L *lua.LState, name string, src string) {
	fn, err := L.LoadString(string(src))
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	preload := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "preload")
	L.SetField(preload, name, fn)
}

//#
//# == *ll.GLobalLoader*(*lua.LState, string)
//# Load gopher-lua (Go) module into the global `_G` environment. +
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Name of the module
//# |===
func GlobalLoader(L *lua.LState, name string) {
	if name == "exec" {
		L.SetGlobal("exec", L.NewTable())
		nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
		L.SetField(nsExec, "command", L.NewFunction(ll.ExecCommand))
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
	if name == "pi" {
		L.SetGlobal("pi", L.NewFunction(ll.GlobalPi))
		return
	}
	L.RaiseError("Unknown module.")
}

//#
//# == *ll.GoLoader*(*lua.LState, string)
//# Load gopher-lua (Go) module into `package.preload`. +
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |string |Name of the module
//# |===
func GoLoader(L *lua.LState, name string) {
	switch name {
	case "json":
		L.PreloadModule("ll_json", ljson.Loader)
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
	default:
		L.RaiseError("Unknown module.")
	}
}
