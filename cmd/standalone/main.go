package main

import (
	"embed"
	"fmt"
	"github.com/cjoudrey/gluahttp"
	gluacrypto "github.com/tengattack/gluacrypto/crypto"
	mysql "github.com/tengattack/gluasql/mysql"
	"github.com/yuin/gopher-lua"
	ljson "layeh.com/gopher-json"
	"layeh.com/gopher-lfs"
	"ll/internal"
	"os"
	"runtime"
)

//go:embed src/*
var mainSrc embed.FS

func main() {
	runtime.MemProfileRate = 0
	defer ll.RecoverPanic()
	L := lua.NewState()
	defer L.Close()
	nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
	L.SetGlobal("fs", nsFs)
	L.SetField(nsFs, "isdir", L.NewFunction(ll.FsIsdir))
	L.SetField(nsFs, "isfile", L.NewFunction(ll.FsIsfile))
	L.SetField(nsFs, "read", L.NewFunction(ll.FsRead))
	L.SetField(nsFs, "write", L.NewFunction(ll.FsWrite))
	nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
	L.SetField(nsOs, "hostname", L.NewFunction(ll.OsHostname))
	L.SetField(nsOs, "outbound_ip", L.NewFunction(ll.OsOutboundIP))
	L.SetField(nsOs, "sleep", L.NewFunction(ll.OsSleep))
	L.SetGlobal("pi", L.NewFunction(ll.GlobalPi))
	L.PreloadModule("http", gluahttp.Xloader)
	L.PreloadModule("ll_json", ljson.Loader)
	L.PreloadModule("crypto", gluacrypto.Loader)
	L.PreloadModule("ksuid", ll.KsuidLoader)
	L.PreloadModule("mysql", mysql.Loader)
	L.PreloadModule("lz4", ll.Lz4Loader)
	L.PreloadModule("telegram", ll.TelegramLoader)
	L.PreloadModule("pushover", ll.PushoverLoader)
	L.PreloadModule("slack", ll.SlackLoader)
	L.PreloadModule("logger", ll.LoggerLoader)
	L.PreloadModule("fsnotify", ll.FsnLoader)
	L.PreloadModule("bitcask", ll.BitcaskLoader)
	L.PreloadModule("refmt", ll.RefmtLoader)
	L.PreloadModule("rr", ll.RrLoader)
	L.PreloadModule("uuid", ll.UuidLoader)
	L.PreloadModule("ulid", ll.UlidLoader)
	L.SetGlobal("exec", L.NewTable())
	nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
	L.SetField(nsExec, "command", L.NewFunction(ll.ExecCommand))
	ll.PatchLoader(L, "exec")
	ll.PatchLoader(L, "table")
	ll.PatchLoader(L, "string")
	ll.GlobalLoader(L, "fmt")
	L.PreloadModule("redis", ll.RedisLoader)
	preload := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "preload")
	L.SetField(preload, "kapow", ll.LuaLoader(L, "kapow"))
	L.SetField(preload, "util", ll.LuaLoader(L, "util"))
	L.SetField(preload, "test", ll.LuaLoader(L, "test"))
	L.SetField(preload, "template", ll.LuaLoader(L, "template"))
	L.SetField(preload, "json", ll.LuaLoader(L, "json"))
	L.SetField(preload, "list", ll.LuaLoader(L, "list"))
	L.SetField(preload, "guard", ll.LuaLoader(L, "guard"))
	L.SetField(preload, "deque", ll.LuaLoader(L, "deque"))
	L.SetField(preload, "bimap", ll.LuaLoader(L, "bimap"))
	L.SetField(preload, "tuple", ll.LuaLoader(L, "tuple"))
	argtb := L.NewTable()
	for i := 0; i < len(os.Args); i++ {
		L.RawSet(argtb, lua.LNumber(i), lua.LString(os.Args[i]))
	}
	L.SetGlobal("arg", argtb)
	src, _ := mainSrc.ReadFile("src/main.lua")
	if err := L.DoString(string(src)); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	os.Exit(0)
}
