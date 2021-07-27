package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func tcpFn(L *lua.LState) int {
	master := &Master{Family: AF_UNSPEC}
	ud := L.NewUserData()
	ud.Value = master
	L.SetMetatable(ud, L.GetTypeMetatable(MASTER_TYPENAME))
	L.Push(ud)
	return 1
}
