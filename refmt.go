package main

import (
	gyaml "github.com/ghodss/yaml"
	"github.com/yuin/gopher-lua"
)

func refmtToYAML(L *lua.LState) int {
	j := L.CheckString(1)
	y, err := gyaml.JSONToYAML([]byte(j))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LString(y))
		return 1
	}
}

func refmtToJSON(L *lua.LState) int {
	y := L.CheckString(1)
	j, err := gyaml.YAMLToJSON([]byte(y))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LString(j))
		return 1
	}
}

func refmtLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, refmtApi)
	L.Push(t)
	return 1
}

var refmtApi = map[string]lua.LGFunction{
	"json": refmtToJSON,
	"yaml": refmtToYAML,
}
