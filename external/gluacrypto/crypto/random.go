package gluacrypto_crypto

import (
	"crypto/rand"
	"fmt"
	"io"

	lua "github.com/yuin/gopher-lua"
)

func randomFn(L *lua.LState) int {
	size := int(L.OptNumber(1, 8))
	buf := make([]byte, size)
	if _, err := io.ReadFull(rand.Reader, buf); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("Failed to read bytes."))
		return 2
	}
	L.Push(lua.LString(fmt.Sprintf("%x", buf[0:size])))
	return 1
}
