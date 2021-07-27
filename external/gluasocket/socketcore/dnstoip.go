package gluasocket_socketcore

import (
	"net"
	"strings"

	"github.com/yuin/gopher-lua"
)

func dnsToIp(L *lua.LState) int {
	host := L.ToString(1)
	if addrs, err := net.LookupHost(host); err != nil {
		L.RaiseError(err.Error())
		return 0
	} else {
		if len(addrs) < 1 {
			L.Push(lua.LNil)
			return 1
		}
		for _, addr := range addrs {
			if !strings.Contains(addr, ":") {
				L.Push(lua.LString(addr))
				return 1
			}
		}
		L.Push(lua.LString(addrs[0]))
		return 1
	}
}
