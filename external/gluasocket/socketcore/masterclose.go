package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func masterCloseMethod(L *lua.LState) int {
	master, _ := checkMaster(L)
	master.Listener.Close()
	return 0
}
