package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientGetPeerNameMethod(L *lua.LState) int {
	L.RaiseError("client:getpeername() not implemented yet")
	return 0
}
