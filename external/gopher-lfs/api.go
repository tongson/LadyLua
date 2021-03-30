package lfs

import (
	"os"
	"time"

	"github.com/yuin/gopher-lua"
)

var Api = map[string]lua.LGFunction{
	"attributes":        apiAttributes,
	"chdir":             apiChdir,
	"lock_dir":          apiLockdir,
	"currentdir":        apiCurrentdir,
	"dir":               apiDir,
	"lock":              apiLock,
	"link":              apiLink,
	"mkdir":             apiMkdir,
	"rmdir":             apiRmdir,
	"setmode":           apiSetmode,
	"symlinkattributes": apiSymlinkattributes,
	"touch":             apiTouch,
	"unlock":            apiUnlock,
}

func apiAttributes(L *lua.LState) int {
	return attributes(L, os.Stat)
}

func apiChdir(L *lua.LState) int {
	dir := L.CheckString(1)

	err := os.Chdir(dir)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func apiLockdir(L *lua.LState) int {
	L.RaiseError("unimplemented function")
	return 0
}

func apiCurrentdir(L *lua.LState) int {
	dir, err := os.Getwd()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(dir))
	return 1
}

func apiDir(L *lua.LState) int {
	path := L.CheckString(1)

	f, err := os.Open(path)
	if err != nil {
		L.RaiseError("%s", err)
		return 0
	}
	stat, err := f.Stat()
	if err != nil {
		L.RaiseError("%s", err)
		return 0
	}
	if !stat.IsDir() {
		L.RaiseError("not a directory")
		return 0
	}
	L.Push(L.NewFunction(dirItr))
	ud := L.NewUserData()
	ud.Value = f
	L.Push(ud)
	return 2
}

func apiLock(L *lua.LState) int {
	L.RaiseError("unimplemented function")
	return 0
}

func apiLink(L *lua.LState) int {
	old := L.CheckString(1)
	new := L.CheckString(2)
	symlink := L.OptBool(3, false)

	var err error
	if symlink {
		err = os.Symlink(old, new)
	} else {
		err = os.Link(old, new)
	}
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func apiMkdir(L *lua.LState) int {
	dir := L.CheckString(1)

	err := os.Mkdir(dir, 0755)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func apiRmdir(L *lua.LState) int {
	dir := L.CheckString(1)

	stat, err := os.Stat(dir)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	if !stat.IsDir() {
		L.Push(lua.LNil)
		L.Push(lua.LString("not a directory"))
		return 2
	}
	err = os.Remove(dir)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func apiSetmode(L *lua.LState) int {
	L.RaiseError("unimplemented function")
	return 0
}

func apiSymlinkattributes(L *lua.LState) int {
	return attributes(L, os.Lstat)
}

func apiTouch(L *lua.LState) int {
	filepath := L.CheckString(1)
	atime := L.OptInt64(2, time.Now().Unix())
	mtime := L.OptInt64(3, atime)

	err := os.Chtimes(filepath, time.Unix(atime, 0), time.Unix(mtime, 0))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func apiUnlock(L *lua.LState) int {
	L.RaiseError("unimplemented function")
	return 0
}
