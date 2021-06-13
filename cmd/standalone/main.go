package main

import (
	"embed"
	"fmt"
	gluacrypto "github.com/tongson/LadyLua/external/gluacrypto/crypto"
	"github.com/tongson/LadyLua/external/gluahttp"
	mysql "github.com/tongson/LadyLua/external/gluasql/mysql"
	ljson "github.com/tongson/LadyLua/external/gopher-json"
	"github.com/tongson/LadyLua/external/gopher-lfs"
	"github.com/tongson/LadyLua/src"
	"github.com/tongson/gl"
	"github.com/yuin/gopher-lua"
	"os"
	"runtime"
)

//go:embed src/*
var mainSrc embed.FS

func main() {
	runtime.MemProfileRate = 0
	defer gl.RecoverPanic()
	L := lua.NewState()
	defer L.Close()
	// fs
	nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
	L.SetGlobal("fs", nsFs)
	L.SetField(nsFs, "isdir", L.NewFunction(ll.FsIsdir))
	L.SetField(nsFs, "isfile", L.NewFunction(ll.FsIsfile))
	L.SetField(nsFs, "read", L.NewFunction(ll.FsRead))
	L.SetField(nsFs, "write", L.NewFunction(ll.FsWrite))
	// fs
	// os
	nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
	L.SetField(nsOs, "hostname", L.NewFunction(ll.OsHostname))
	L.SetField(nsOs, "outbound_ip", L.NewFunction(ll.OsOutboundIP))
	L.SetField(nsOs, "sleep", L.NewFunction(ll.OsSleep))
	// os
	// pi
	L.SetGlobal("pi", L.NewFunction(ll.GlobalPi))
	// pi
	// exec
	L.SetGlobal("exec", L.NewTable())
	nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
	L.SetField(nsExec, "command", L.NewFunction(ll.ExecCommand))
	ll.PatchLoader(L, "exec")
	// exec
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
	L.PreloadModule("redis", ll.RedisLoader)
	ll.PatchLoader(L, "table")
	ll.PatchLoader(L, "string")
	ll.EmbedLoader(L)
	ll.FillArg(L, os.Args)
	if err := L.DoString(ll.ReadFile(mainSrc, "src/main.lua")); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	os.Exit(0)
}
