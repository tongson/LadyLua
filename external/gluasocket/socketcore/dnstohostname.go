package gluasocket_socketcore

import (
	"net"

	"github.com/yuin/gopher-lua"
)

func dnsToHostName(L *lua.LState) int {
	ip := L.ToString(1)
	host, err := net.LookupAddr(ip)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	// Generally only one result is returned by LookupAddr, so we just assume this is the case
	// TODO: Return a table containing all hostnames mapping to the address
	if len(host) > 0 {
		L.Push(lua.LString(host[0]))
	} else {
		L.Push(lua.LNil)
	}
	L.Push(lua.LNil)
	return 2
}
