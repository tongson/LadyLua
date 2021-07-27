package gluasocket_socketcore

import (
	"time"

	"github.com/yuin/gopher-lua"
)

func selectFn(L *lua.LState) int {

	// Read arguments
	recvt := L.Get(1)
	sendt := L.Get(2)
	timeout := L.Get(3)

	// Handle select(nil, nil, timeout)
	if recvt.Type() == lua.LTNil && sendt.Type() == lua.LTNil {
		timeoutVal, ok := timeout.(lua.LNumber)
		if !ok {
			L.RaiseError("Malformed timeout in call to socket.select(?,?,timeout)")
			return 0
		}
		timeoutDuration := time.Duration(timeoutVal * 1.0e9)
		time.Sleep(timeoutDuration)
		L.Push(lua.LString("timeout"))
		return 1
	}

	// TODO Handle socket select
	L.RaiseError("socket.select(recvt,sendt,timeout) not implemented yet")
	return 0
}
