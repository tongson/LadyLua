package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

type DNS struct {
}

var dnsMethods = map[string]lua.LGFunction{
	"getaddrinfo": dnsGetAddrInfo,
	"gethostname": dnsGetHostName,
	"tohostname":  dnsToHostName,
	"toip":        dnsToIp,
}
