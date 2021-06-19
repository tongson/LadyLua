package ll

import (
	"fmt"

	"github.com/yuin/gopher-lua"
)

// Prettier equivalent of `require("xstring")()` --> `extend("string")`
func Extend(L *lua.LState) int {
	mod := L.CheckString(1)
	req := L.GetField(L.Get(lua.GlobalsIndex), "require").(*lua.LFunction)
	L.Push(req)
	L.Push(lua.LString(fmt.Sprintf("x%s", mod)))
	L.Call(1, 1)
	L.Call(0, 0)
	return 0
}
