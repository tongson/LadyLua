package gluacrypto

import (
	crypto "github.com/tengattack/gluacrypto/crypto"
	"github.com/yuin/gopher-lua"
)

func Preload(L *lua.LState) {
	L.PreloadModule("crypto", crypto.Loader)
}
