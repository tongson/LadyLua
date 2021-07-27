package gluasocket_socketcore

import (
	"time"

	"github.com/yuin/gopher-lua"
)

func gettimeFn(l *lua.LState) int {
	now := time.Now()
	l.Push(lua.LNumber(float64(now.UnixNano()) / 1.0e9))
	return 1
}
