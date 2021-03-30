package lfs

import (
	"os"
	"path/filepath"

	"github.com/yuin/gopher-lua"
)

func attributes(L *lua.LState, statFunc func(string) (os.FileInfo, error)) int {
	fp := L.CheckString(1)

	stat, err := statFunc(fp)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	table := L.NewTable()
	if err := attributesFill(table, stat); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	if table.RawGetString("mode").String() == "link" {
		if path, err := filepath.EvalSymlinks(fp); err == nil {
			table.RawSetString("target", lua.LString(path))
		}
	}
	if L.GetTop() > 1 {
		requestName := L.CheckString(2)
		L.Push(table.RawGetString(requestName))
		return 1
	}
	L.Push(table)
	return 1
}

func dirItr(L *lua.LState) int {
	ud := L.CheckUserData(1)

	f, ok := ud.Value.(*os.File)
	if !ok {
		return 0
	}
	names, err := f.Readdirnames(1)
	if err != nil {
		return 0
	}
	L.Push(lua.LString(names[0]))
	return 1
}
