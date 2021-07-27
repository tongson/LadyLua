package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientCloseMethod(L *lua.LState) int {
	client := checkClient(L)
	if err := client.Conn.Close(); err != nil {
		L.RaiseError(err.Error())
	}
	return 0
}
