package gluacrypto_crypto

import (
	lua "github.com/yuin/gopher-lua"
)

var exports = map[string]lua.LGFunction{
	"base64_encode": base64EncodeFn,
	"base64_decode": base64DecodeFn,
	"crc32":         crc32Fn,
	"md5":           md5Fn,
	"sha1":          sha1Fn,
	"sha256":        sha256Fn,
	"sha512":        sha512Fn,
	"hmac":          hmacFn,
	"encrypt":       encryptFn,
	"decrypt":       decryptFn,
}

func Loader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), exports)
	L.Push(mod)

	L.SetField(mod, "_DEBUG", lua.LBool(false))
	L.SetField(mod, "_VERSION", lua.LString("0.0.0"))

	// consts
	L.SetField(mod, "RAW_DATA", lua.LNumber(1))
	L.SetField(mod, "ZERO_PADDING", lua.LNumber(2))

	return 1
}
