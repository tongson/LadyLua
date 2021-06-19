package ll

import (
	"fmt"
	"math"

	"github.com/yuin/gopher-lua"
)

// From: https://golang.org/doc/play/pi.go
func GlobalPi(L *lua.LState) int {
	n := L.ToInt(1)
	ch := make(chan float64)
	for k := 0; k <= n; k++ {
		go globalPiTerm(ch, float64(k))
	}
	f := 0.0
	for k := 0; k <= n; k++ {
		f += <-ch
	}
	L.Push(lua.LNumber(f))
	return 1
}

func globalPiTerm(ch chan float64, k float64) {
	ch <- 4 * math.Pow(-1, k) / (2*k + 1)
}

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
