package main

import (
	"embed"
	"fmt"
	"github.com/yuin/gopher-lua"
)

//go:embed lua/*
var luaSrc embed.FS

func luaLoader(L *lua.LState, mod string) lua.LValue {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	return fn
}

func patchLoader(L *lua.LState, mod string) {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

func globalLoader(L *lua.LState, mod string) {
	L.SetGlobal(mod, L.NewTable())
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}
