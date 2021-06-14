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
	"os"
)

//go:embed lua/*
var luaSrc embed.FS

func EmbedLoader(L *lua.LState) {
	embedLoader := func(l *lua.LState) int {
		name := l.CheckString(1)
		src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", name))
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

func PatchLoader(L *lua.LState, mod string) {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

func LuaGlobalLoader(L *lua.LState, mod string) {
	L.SetGlobal(mod, L.NewTable())
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

func MainLoader(L *lua.LState, src string) {
	if err := L.DoString(src); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
}

func ModuleLoader(L *lua.LState, name string, src string) {
	fn, err := L.LoadString(string(src))
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	preload := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "preload")
	L.SetField(preload, name, fn)
}

func GlobalLoader(L *lua.LState, name string) {
	if name == "exec" {
		L.SetGlobal("exec", L.NewTable())
		nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
		L.SetField(nsExec, "command", L.NewFunction(ExecCommand))
		return
	}
	if name == "fs" {
		nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
		L.SetGlobal("fs", nsFs)
		L.SetField(nsFs, "isdir", L.NewFunction(FsIsdir))
		L.SetField(nsFs, "isfile", L.NewFunction(FsIsfile))
		L.SetField(nsFs, "read", L.NewFunction(FsRead))
		L.SetField(nsFs, "write", L.NewFunction(FsWrite))
		return
	}
	if name == "os" {
		nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
		L.SetField(nsOs, "hostname", L.NewFunction(OsHostname))
		L.SetField(nsOs, "outbound_ip", L.NewFunction(OsOutboundIP))
		L.SetField(nsOs, "sleep", L.NewFunction(OsSleep))
		return
	}
	if name == "pi" {
		L.SetGlobal("pi", L.NewFunction(GlobalPi))
		return
	}
}

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
		L.PreloadModule("ksuid", KsuidLoader)
	case "lz4":
		L.PreloadModule("lz4", Lz4Loader)
	case "telegram":
		L.PreloadModule("telegram", TelegramLoader)
	case "pushover":
		L.PreloadModule("pushover", PushoverLoader)
	case "slack":
		L.PreloadModule("slack", SlackLoader)
	case "logger":
		L.PreloadModule("logger", LoggerLoader)
	case "fsnotify":
		L.PreloadModule("fsnotify", FsnLoader)
	case "bitcask":
		L.PreloadModule("bitcask", BitcaskLoader)
	case "refmt":
		L.PreloadModule("refmt", RefmtLoader)
	case "rr":
		L.PreloadModule("rr", RrLoader)
	case "uuid":
		L.PreloadModule("uuid", UuidLoader)
	case "ulid":
		L.PreloadModule("ulid", UlidLoader)
	case "redis":
		L.PreloadModule("redis", RedisLoader)
	default:
		L.RaiseError("Unknown module.")
	}
}
