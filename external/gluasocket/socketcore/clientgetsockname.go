package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientGetSockNameMethod(L *lua.LState) int {
	L.RaiseError("client:getsockname() not implemented yet")
	return 0
}
