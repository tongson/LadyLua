package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func tcp4Fn(L *lua.LState) int {
	master := &Master{Family: AF_INET}
	ud := L.NewUserData()
	ud.Value = master
	L.SetMetatable(ud, L.GetTypeMetatable(MASTER_TYPENAME))
	L.Push(ud)
	return 1
}
