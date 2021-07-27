package gluasocket_socketcore

import (
	"bufio"

	"github.com/yuin/gopher-lua"
)

func masterAcceptMethod(L *lua.LState) int {
	master, ud := checkMaster(L)
	conn, err := master.Listener.Accept()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	reader := bufio.NewReader(conn)
	client := &Client{Conn: conn, Reader: reader, Timeout: master.Timeout}
	ud.Value = client
	L.SetMetatable(ud, L.GetTypeMetatable(CLIENT_TYPENAME))
	L.Push(ud)
	return 1
}
