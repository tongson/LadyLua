package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientGetStatsMethod(L *lua.LState) int {
	L.RaiseError("client:getstats() not implemented yet")
	return 0
}
