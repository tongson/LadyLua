package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientDirtyMethod(L *lua.LState) int {
	L.Push(lua.LBool(false))
	return 1
}
