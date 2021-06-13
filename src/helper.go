package ll

import (
	"github.com/yuin/gopher-lua"
)

func FillArg(L *lua.LState, args []string) {
	argtb := L.NewTable()
	for i := 0; i < len(args); i++ {
		L.RawSet(argtb, lua.LNumber(i), lua.LString(args[i]))
	}
	L.SetGlobal("arg", argtb)
}
