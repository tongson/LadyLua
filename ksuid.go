package main

import (
	"github.com/segmentio/ksuid"
	"github.com/yuin/gopher-lua"
)

func ksuidNew(L *lua.LState) int {
	L.Push(lua.LString(ksuid.New().String()))
	return 1
}

func ksuidLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, ksuidApi)
	L.Push(t)
	return 1
}

var ksuidApi = map[string]lua.LGFunction{
	"new": ksuidNew,
}
