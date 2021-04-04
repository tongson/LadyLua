package main

import (
	"github.com/yuin/gopher-lua"
	"io"
	"os"
)

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
	path := L.CheckString(1)
	isFile := StatPath("file")
	if isFile(path) {
		file, err := os.Open(path)
		defer func() {
			_ = file.Close()
		}()
		if err != nil {
			L.Push(lua.LNil)
			L.Push(lua.LString(err.Error()))
			return 2
		}
		if str, err := io.ReadAll(file); err != nil {
			L.Push(lua.LNil)
			L.Push(lua.LString(err.Error()))
			return 2
		} else {
			L.Push(lua.LString(string(str)))
			return 1
		}
	} else {
		L.Push(lua.LFalse)
		return 1
	}
}

func fsWrite(L *lua.LState) int {
	f := L.CheckString(1)
	s := L.CheckString(2)
	err := StringToFile(f, s)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}
