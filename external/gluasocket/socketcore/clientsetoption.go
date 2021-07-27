package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientSetOptionMethod(L *lua.LState) int {
	L.RaiseError("client:setoption() not implemented yet")
	return 0
}
