// +build main

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
	"os"
	"runtime"
)

//go:embed main/*
var mainSrc embed.FS

func main() {
	runtime.MemProfileRate = 0
	defer RecoverPanic()
	L := lua.NewState()
	defer L.Close()
	nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
	L.SetGlobal("fs", nsFs)
	L.SetField(nsFs, "isdir", L.NewFunction(fsIsdir))
	L.SetField(nsFs, "isfile", L.NewFunction(fsIsfile))
	L.SetField(nsFs, "read", L.NewFunction(fsRead))
	L.SetField(nsFs, "write", L.NewFunction(fsWrite))
	nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
	L.SetField(nsOs, "hostname", L.NewFunction(osHostname))
	L.SetField(nsOs, "outbound_ip", L.NewFunction(osOutboundIP))
	L.SetField(nsOs, "sleep", L.NewFunction(osSleep))
	L.SetGlobal("pi", L.NewFunction(globalPi))
	L.PreloadModule("http", gluahttp.Xloader)
	L.PreloadModule("ll_json", ljson.Loader)
	L.PreloadModule("crypto", gluacrypto.Loader)
	L.PreloadModule("ksuid", ksuidLoader)
	L.PreloadModule("mysql", mysql.Loader)
	L.PreloadModule("lz4", lz4Loader)
	L.PreloadModule("telegram", telegramLoader)
	L.PreloadModule("pushover", pushoverLoader)
	L.PreloadModule("slack", slackLoader)
	L.PreloadModule("logger", loggerLoader)
	L.PreloadModule("fsnotify", fsnLoader)
	L.PreloadModule("bitcask", bitcaskLoader)
	L.PreloadModule("refmt", refmtLoader)
	L.PreloadModule("rr", rrLoader)
	L.PreloadModule("uuid", uuidLoader)
	L.PreloadModule("ulid", ulidLoader)
	L.SetGlobal("exec", L.NewTable())
	nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
	L.SetField(nsExec, "command", L.NewFunction(execCommand))
	patchLoader(L, "exec")
	patchLoader(L, "table")
	patchLoader(L, "string")
	globalLoader(L, "fmt")
	L.PreloadModule("redis", redisLoader)
	preload := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "preload")
	L.SetField(preload, "kapow", luaLoader(L, "kapow"))
	L.SetField(preload, "util", luaLoader(L, "util"))
	L.SetField(preload, "test", luaLoader(L, "test"))
	L.SetField(preload, "template", luaLoader(L, "template"))
	L.SetField(preload, "json", luaLoader(L, "json"))
	L.SetField(preload, "list", luaLoader(L, "list"))
	L.SetField(preload, "guard", luaLoader(L, "guard"))
	L.SetField(preload, "deque", luaLoader(L, "deque"))
	L.SetField(preload, "bimap", luaLoader(L, "bimap"))
	L.SetField(preload, "tuple", luaLoader(L, "tuple"))
	argtb := L.NewTable()
	for i := 0; i < len(os.Args); i++ {
		L.RawSet(argtb, lua.LNumber(i), lua.LString(os.Args[i]))
	}
	L.SetGlobal("arg", argtb)
	src, _ := mainSrc.ReadFile("main/main.lua")
	if err := L.DoString(string(src)); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	os.Exit(0)
}
