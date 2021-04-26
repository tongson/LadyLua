package main

import (
	"github.com/hashicorp/go-uuid"
	"github.com/yuin/gopher-lua"
)

func uuidNew(L *lua.LState) int {
	id, err := uuid.GenerateUUID()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(id))
	return 1
}

func uuidLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, uuidApi)
	L.Push(t)
	return 1
}

var uuidApi = map[string]lua.LGFunction{
	"new": uuidNew,
}
