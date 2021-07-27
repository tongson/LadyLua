package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientSendMethod(L *lua.LState) int {
	client := checkClient(L)
	data := L.ToString(2)
	i := L.OptInt(3, 1)
	j := L.OptInt(4, len(data)+1)

	dataBytes := []byte(data)
	if bytesSent, err := client.Conn.Write(dataBytes[i-1 : j-1]); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LNumber(bytesSent))
		return 1
	}
}
