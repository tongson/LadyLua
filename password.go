package main

import (
	"github.com/sethvargo/go-password/password"
	"github.com/yuin/gopher-lua"
)

func passwordGenerate(L *lua.LState) int {
	length := L.CheckNumber(1)
	digits := L.CheckNumber(2)
	symbols := L.CheckNumber(3)
	singlecase := L.CheckBool(4)
	repeat := L.CheckBool(5)
	res, err := password.Generate(int(length), int(digits), int(symbols), singlecase, repeat)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("password.generate: Unable to generate password."))
		return 2
	} else {
		L.Push(lua.LString(res))
		return 1
	}
}

func passwordLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, passwordApi)
	L.Push(t)
	return 1
}

var passwordApi = map[string]lua.LGFunction{
	"generate": passwordGenerate,
}
