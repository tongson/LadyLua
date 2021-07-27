package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func masterBindMethod(L *lua.LState) int {
	master, _ := checkMaster(L)
	master.BindAddr = L.CheckString(2)
	master.BindPort = L.Get(3)
	L.Push(lua.LNumber(1))
	return 1
}
