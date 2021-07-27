package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func clientSetStatsMethod(L *lua.LState) int {
	L.RaiseError("client:setstats() not implemented yet")
	return 0
}
