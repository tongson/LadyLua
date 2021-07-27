package gluasocket_socketcore

import (
	"bufio"
	"fmt"
	"net"

	"github.com/yuin/gopher-lua"
)

func connectFn(L *lua.LState) int {
	hostname := L.ToString(1)
	port := L.ToInt(2)

	conn, err := net.Dial("tcp", fmt.Sprintf("%s:%d", hostname, port))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	reader := bufio.NewReader(conn)
	client := &Client{Conn: conn, Reader: reader}
	ud := L.NewUserData()
	ud.Value = client
	L.SetMetatable(ud, L.GetTypeMetatable(CLIENT_TYPENAME))
	L.Push(ud)
	return 1
}
