package main

import (
	"embed"
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
	ll.GlobalLoader(L, "fs")
	ll.GlobalLoader(L, "os")
	ll.GlobalLoader(L, "pi")
	ll.GlobalLoader(L, "exec")
	ll.PatchLoader(L, "exec")
	ll.PatchLoader(L, "table")
	ll.PatchLoader(L, "string")
	ll.GoLoader(L, "http")
	ll.GoLoader(L, "json")
	ll.GoLoader(L, "crypto")
	ll.GoLoader(L, "ksuid")
	ll.GoLoader(L, "mysql")
	ll.GoLoader(L, "lz4")
	ll.GoLoader(L, "telegram")
	ll.GoLoader(L, "pushover")
	ll.GoLoader(L, "slack")
	ll.GoLoader(L, "logger")
	ll.GoLoader(L, "fsnotify")
	ll.GoLoader(L, "bitcask")
	ll.GoLoader(L, "refmt")
	ll.GoLoader(L, "rr")
	ll.GoLoader(L, "uuid")
	ll.GoLoader(L, "ulid")
	ll.GoLoader(L, "redis")
	ll.EmbedLoader(L)
	ll.FillArg(L, os.Args)
	ll.MainLoader(L, ll.ReadFile(mainSrc, "src/main.lua"))
	os.Exit(0)
}
