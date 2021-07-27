package gluacrypto_crypto

import (
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/yuin/gopher-lua"
)

// xor
// xor two numbers
// (number, number) -> (number)
func xorFn(L *lua.LState) int {
	i := L.CheckNumber(1)
	x := L.CheckNumber(2)
	L.Push(lua.LNumber(uint8(i) ^ uint8(x)))
	return 1
}

// htos
// Hexadecimal string to string
// (string) -> string
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

// stoh
// String to Hexadecimal string
// (string) -> string
func strtohexFn(L *lua.LState) int {
	h := L.CheckString(1)
	encodedString := hex.EncodeToString([]byte(h))
	L.Push(lua.LString(encodedString))
	return 1
}

// htoi
// Hexadecimal string to int
// (string) -> number
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

// htot
// Hexadecimal string to int array
// (string) -> table[number]
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
		t.Append(lua.LNumber(element))
	}
	L.Push(t)
	return 1
}

// hexor
// XOR two hex strings
// (string, string) -> string, table[number]
func hexorFn(L *lua.LState) int {
	a := L.CheckString(1)
	b := L.CheckString(2)
	aa, err := hex.DecodeString(a)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	ba, err := hex.DecodeString(b)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	hexa := strings.Builder{}
	var ax *[]byte
	var bx *[]byte
	var sz int
	la := len(aa)
	lb := len(ba)
	switch la > lb {
	case true:
		ax = &aa
		bx = &ba
		sz = lb - 1
	case false:
		ax = &ba
		bx = &aa
		sz = la - 1
	}
	t := L.NewTable()
	var r int = 0
	var v uint8
	for _, element := range *ax {
		v = element ^ (*bx)[r]
		hexa.WriteString(fmt.Sprintf("%02x", v))
		t.Append(lua.LNumber(v))
		if r < sz {
			r++
		} else {
			r = 0
		}
	}
	L.Push(lua.LString(hexa.String()))
	L.Push(t)
	return 2
}

// ord
func ordFn(L *lua.LState) int {
	s := L.CheckString(1)
	r, _ := utf8.DecodeRuneInString(s)
	L.Push(lua.LNumber(r))
	return 1
}

// char
func charFn(L *lua.LState) int {
	L.Push(lua.LString(string(int32(L.CheckNumber(1)))))
	return 1
}
