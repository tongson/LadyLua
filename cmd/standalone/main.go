package main

import (
	"embed"
	"github.com/tongson/LadyLua"
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
	ll.LoadGlobalGo(L, "fs")
	ll.LoadGlobalGo(L, "os")
	ll.LoadGlobalGo(L, "pi")
	ll.LoadGlobalGo(L, "extend")
	ll.LoadGlobalGo(L, "exec")
	ll.PreloadGo(L, "http")
	ll.PreloadGo(L, "json")
	ll.PreloadGo(L, "crypto")
	ll.PreloadGo(L, "ksuid")
	ll.PreloadGo(L, "mysql")
	ll.PreloadGo(L, "lz4")
	ll.PreloadGo(L, "telegram")
	ll.PreloadGo(L, "pushover")
	ll.PreloadGo(L, "slack")
	ll.PreloadGo(L, "logger")
	ll.PreloadGo(L, "fsnotify")
	ll.PreloadGo(L, "bitcask")
	ll.PreloadGo(L, "refmt")
	ll.PreloadGo(L, "rr")
	ll.PreloadGo(L, "uuid")
	ll.PreloadGo(L, "ulid")
	ll.PreloadGo(L, "redis")
	ll.Preload(L)
	ll.FillArg(L, os.Args)
	ll.Main(L, ll.ReadFile(mainSrc, "src/main.lua"))
	os.Exit(0)
}
