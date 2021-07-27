package gluasocket_socketcore

import (
	"time"

	"github.com/yuin/gopher-lua"
)

func clientSetTimeoutMethod(L *lua.LState) int {
	client := checkClient(L)
	timeout := L.CheckNumber(2)
	client.Timeout = time.Duration(timeout * 1.0e9)
	L.Push(lua.LNumber(1))
	return 1
}
