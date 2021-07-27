package gluasocket_socketcore

import (
	"time"

	"github.com/yuin/gopher-lua"
)

func sleepFn(L *lua.LState) int {

	// Read arguments
	timeout := L.Get(1)

	// Handle
	timeoutVal, ok := timeout.(lua.LNumber)
	if !ok {
		L.RaiseError("Malformed timeout in call to socket.sleep(time)")
		return 0
	}
	timeoutDuration := time.Duration(timeoutVal * 1.0e9)
	time.Sleep(timeoutDuration)

	return 0
}
