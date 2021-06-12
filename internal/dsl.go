// +build dsl
package ll

import (
	"embed"
	"fmt"
	"github.com/yuin/gopher-lua"
)

//go:embed dsl/*
var dslSrc embed.FS

func DslLoader(L *lua.LState, mod string) {
	src, _ := dslSrc.ReadFile(fmt.Sprintf("dsl/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.PCall(0, 0, nil)
}