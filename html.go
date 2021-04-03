package main

import (
	"github.com/microcosm-cc/bluemonday"
	"github.com/yuin/gopher-lua"
)

func htmlSanitize(L *lua.LState) int {
	str := L.CheckString(1)
	p := bluemonday.UGCPolicy()
	L.Push(lua.LString(p.Sanitize(str)))
	return 1
}

func htmlLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, htmlApi)
	L.Push(t)
	return 1
}

var htmlApi = map[string]lua.LGFunction{
	"sanitize": htmlSanitize,
}
