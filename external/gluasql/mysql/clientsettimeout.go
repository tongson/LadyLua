package gluasql_mysql

import (
	"time"

	"github.com/yuin/gopher-lua"
)

func clientSetTimeoutMethod(L *lua.LState) int {
	client := checkClient(L)
	timeout := L.ToInt64(2) // timeout (in ms)

	client.Timeout = time.Millisecond * time.Duration(timeout)
	return 0
}
