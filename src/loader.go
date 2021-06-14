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
		L.SetField(nsExec, "command", L.NewFunction(execCommand))
		return
	}
	if name == "fs" {
		nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
		L.SetGlobal("fs", nsFs)
		L.SetField(nsFs, "isdir", L.NewFunction(fsIsdir))
		L.SetField(nsFs, "isfile", L.NewFunction(fsIsfile))
		L.SetField(nsFs, "read", L.NewFunction(fsRead))
		L.SetField(nsFs, "write", L.NewFunction(fsWrite))
		return
	}
	if name == "os" {
		nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
		L.SetField(nsOs, "hostname", L.NewFunction(osHostname))
		L.SetField(nsOs, "outbound_ip", L.NewFunction(osOutboundIP))
		L.SetField(nsOs, "sleep", L.NewFunction(osSleep))
		return
	}
	if name == "pi" {
		L.SetGlobal("pi", L.NewFunction(globalPi))
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
		L.PreloadModule("ksuid", ksuidLoader)
	case "lz4":
		L.PreloadModule("lz4", lz4Loader)
	case "telegram":
		L.PreloadModule("telegram", telegramLoader)
	case "pushover":
		L.PreloadModule("pushover", pushoverLoader)
	case "slack":
		L.PreloadModule("slack", slackLoader)
	case "logger":
		L.PreloadModule("logger", loggerLoader)
	case "fsnotify":
		L.PreloadModule("fsnotify", fsnLoader)
	case "bitcask":
		L.PreloadModule("bitcask", bitcaskLoader)
	case "refmt":
		L.PreloadModule("refmt", refmtLoader)
	case "rr":
		L.PreloadModule("rr", rrLoader)
	case "uuid":
		L.PreloadModule("uuid", uuidLoader)
	case "ulid":
		L.PreloadModule("ulid", ulidLoader)
	case "redis":
		L.PreloadModule("redis", redisLoader)
	default:
		L.RaiseError("Unknown module.")
	}
}
