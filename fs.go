package main

import (
	"github.com/yuin/gopher-lua"
)

//var exportFs = map[string]lua.LGFunction{
//    "isdir": fsIsdir,
//}

func fsIsdir(L *lua.LState) int {
	dir := L.CheckString(1)
	is := StatPath("directory")
	if is(dir) {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LFalse)
	}
	return 1
}

func fsIsfile(L *lua.LState) int {
	f := L.CheckString(1)
	is := StatPath("")
	if is(f) {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LFalse)
	}
	return 1
}

func fsRead(L *lua.LState) int {
	f := L.CheckString(1)
	L.Push(lua.LString(FileRead(f)))
	return 1
}
