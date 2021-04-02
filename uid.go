package main

import (
	"github.com/segmentio/ksuid"
	"github.com/yuin/gopher-lua"
)

func uidNew(L *lua.LState) int {
	L.Push(lua.LString(ksuid.New().String()))
	return 1
}

func uidLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, api)
	L.Push(t)
	return 1
}

var api = map[string]lua.LGFunction{
	"new": uidNew,
}
