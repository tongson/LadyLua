package ll

import (
	"github.com/yuin/gopher-lua"
	"net"
	"os"
	"time"
)

func osHostname(L *lua.LState) int {
	name, err := os.Hostname()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(name))
	return 1
}

func osSleep(L *lua.LState) int {
	n := L.CheckNumber(1)
	time.Sleep(time.Duration(n) * time.Millisecond)
	L.Push(lua.LTrue)
	return 1
}

func osOutboundIP(L *lua.LState) int {
	conn, err := net.Dial("udp", "1.1.1.1:53")
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	defer conn.Close()
	localAddr := conn.LocalAddr().(*net.UDPAddr)
	L.Push(lua.LString(localAddr.IP.String()))
	return 1
}
