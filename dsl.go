// +build dsl
package ll

import (
	"embed"
	"fmt"

	"github.com/yuin/gopher-lua"
)

//go:embed internal/dsl/*
var dslSrc embed.FS

func DslLoader(L *lua.LState, mod string) {
	src, _ := dslSrc.ReadFile(fmt.Sprintf("internal/dsl/%s.lua", mod))
	fn, _ := L.LoadString(string(src))
	L.Push(fn)
	L.Call(0, 0)
}
