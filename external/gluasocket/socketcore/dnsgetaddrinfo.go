package gluasocket_socketcore

import (
	"net"

	"github.com/yuin/gopher-lua"
)

func dnsGetAddrInfo(L *lua.LState) int {

	// Read arguments
	host := L.CheckString(1)

	// Handle
	if host == "" {
		return 0
	}
	addrs, err := net.LookupHost(host)
	if err != nil {
		L.RaiseError(err.Error())
		return 0
	}
	result := &lua.LTable{}
	for _, addr := range addrs {
		if addr == "::1" {
			// best guess, according to https://stackoverflow.com/questions/5956516/getaddrinfo-and-ipv6
			continue
		}
		t := &lua.LTable{}
		t.RawSetString("family", lua.LString("inet"))
		t.RawSetString("addr", lua.LString(addr))
		result.Append(t)
	}

	L.Push(result)
	return 1
}
