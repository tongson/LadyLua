package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func udpFn(L *lua.LState) int {
	L.RaiseError("socket.udp() not implemented yet")
	return 0
}
