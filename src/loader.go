package ll

import (
	"embed"
	"fmt"
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
		li := ltb.Len()
		ltb.RawSetInt(li, L.NewFunction(embedLoader))
	}
}

func ModuleLoader(L *lua.LState, esrc embed.FS, dir string) {
	embedLoader := func(l *lua.LState) int {
		name := l.CheckString(1)
		src, _ := esrc.ReadFile(fmt.Sprintf("%s/%s.lua", dir, name))
		fn, _ := l.LoadString(string(src))
		l.Push(fn)
		return 1
	}
	loaders := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "loaders")
	if ltb, ok := loaders.(*lua.LTable); ok {
		li := ltb.Len()
		ltb.RawSetInt(li, L.NewFunction(embedLoader))
	}
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

func MainLoader(L *lua.LState, src []byte) {
	if err := L.DoString(string(src)); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
}
