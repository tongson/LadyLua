package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func skipFn(L *lua.LState) int {
	d := L.ToInt(1)
	for i := 0; i <= d; i++ {
		L.Remove(1)
	}
	return L.GetTop()
}
