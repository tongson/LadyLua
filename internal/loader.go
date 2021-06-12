package ll

import (
	"embed"
	"fmt"
	"github.com/yuin/gopher-lua"
)

//go:embed lua/*
var luaSrc embed.FS

func EmbedLoader(L *lua.LState) int {
	name := L.CheckString(1)
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", name))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	return 1
}

func LuaLoader(L *lua.LState, mod string) lua.LValue {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, err := L.LoadString(string(src))
	if err != nil {
		L.RaiseError(err.Error())
	}
	return fn
}

func PatchLoader(L *lua.LState, mod string) {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}

func GlobalLoader(L *lua.LState, mod string) {
	L.SetGlobal(mod, L.NewTable())
	src, _ := luaSrc.ReadFile(fmt.Sprintf("lua/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}
