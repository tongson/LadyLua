package gluacrypto_crypto

import (
	"encoding/hex"
	"strconv"

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

func hextointFn(L *lua.LState) int {
	h := L.CheckString(1)
	value, err := strconv.ParseInt(h, 16, 64)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LNumber(value))
	return 1
}

func hextotblFn(L *lua.LState) int {
	h := L.CheckString(1)
	decodedByteArray, err := hex.DecodeString(h)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	t := L.NewTable()
	for _, element := range decodedByteArray {
		t.Append(lua.LNumber(uint8(element)))
	}
	L.Push(t)
	return 1
}
