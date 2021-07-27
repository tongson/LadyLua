package gluasocket_socketcore

import (
	"net"
	"time"

	"github.com/yuin/gopher-lua"
)

const (
	MASTER_TYPENAME = "tcp{master}"
)

type Master struct {
	Listener net.Listener
	BindAddr string
	BindPort lua.LValue
	Timeout  time.Duration
	Family   int
	Options  map[string]lua.LValue
}

var masterMethods = map[string]lua.LGFunction{
	"accept":     masterAcceptMethod,
	"bind":       masterBindMethod,
	"close":      masterCloseMethod,
	"connect":    masterConnectMethod,
	"listen":     masterListenMethod,
	"setoption":  masterSetOptionMethod,
	"settimeout": masterSetTimeoutMethod,
}

// ----------------------------------------------------------------------------

func checkMaster(L *lua.LState) (*Master, *lua.LUserData) {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*Master); ok {
		return v, ud
	}
	L.ArgError(1, "master expected")
	return nil, nil
}
