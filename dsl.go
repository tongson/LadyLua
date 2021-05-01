// +build dsl
package main

import (
	"embed"
	"fmt"
	"github.com/yuin/gopher-lua"
)

//go:embed dsl/*
var dslSRC embed.FS

func dslLoader(L *lua.LState, mod string) lua.LValue {
	src, _ := luaSrc.ReadFile(fmt.Sprintf("dsl/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	return fn
}
