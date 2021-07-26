package gluacrypto_crypto

import (
	"encoding/hex"

	"github.com/yuin/gopher-lua"
)

func xorFn(L *lua.LState) int {
	i := L.CheckNumber(1)
	x := L.CheckNumber(2)
	L.Push(lua.LNumber(uint8(i) ^ uint8(x)))
	return 1
}

func hextostrFn(L *lua.LState) int {
	h := L.CheckString(1)
	decodedByteArray, err := hex.DecodeString(h)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(string(decodedByteArray)))
	return 1
}

func strtohexFn(L *lua.LState) int {
	h := L.CheckString(1)
	encodedString := hex.EncodeToString([]byte(h))
	L.Push(lua.LString(encodedString))
	return 1
}
