package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

func masterSetOptionMethod(L *lua.LState) int {
	master, _ := checkMaster(L)
	optionName := L.CheckString(2) /* obj, name, ... */
	if master.Options == nil {
		master.Options = map[string]lua.LValue{}
	}
	master.Options[optionName] = L.Get(3)
	return 0
}
