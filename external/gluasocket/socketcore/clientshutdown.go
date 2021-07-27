package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientShutdownMethod(L *lua.LState) int {
	L.RaiseError("client:shutdown() not implemented yet")
	return 0
}
