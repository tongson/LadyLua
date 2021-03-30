package main

import (
	"github.com/yuin/gopher-lua"
	"os"
)

func osHostname(L *lua.LState) int {
	name, err := os.Hostname()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(name))
	return 1
}
