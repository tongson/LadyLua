package gluacrypto_crypto

import (
	"encoding/base64"

	lua "github.com/yuin/gopher-lua"
)

func base64EncodeFn(L *lua.LState) int {
	s := lua.LVAsString(L.Get(1))
	result := base64.StdEncoding.EncodeToString([]byte(s))
	L.Push(lua.LString(result))
	return 1
}

func base64DecodeFn(L *lua.LState) int {
	s := lua.LVAsString(L.Get(1))
	result, err := base64.StdEncoding.DecodeString(s)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(result))
	return 1
}
