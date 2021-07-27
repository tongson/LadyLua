package gluasocket_socketcore

import (
	"fmt"
	"net"

	"github.com/yuin/gopher-lua"
)

func masterListenMethod(L *lua.LState) int {
	master, _ := checkMaster(L)
	//backlog := L.CheckNumber(1)

	listener, err := net.Listen("tcp", fmt.Sprintf("%s:%s", master.BindAddr, master.BindPort))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	master.Listener = listener
	L.Push(lua.LNumber(1))
	return 1
}
