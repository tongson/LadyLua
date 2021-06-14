package ll

import (
	"github.com/yuin/gopher-lua"
	"math"
)

// From: https://golang.org/doc/play/pi.go
func globalPi(L *lua.LState) int {
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
