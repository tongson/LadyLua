package gluacrypto_crypto

import (
	"crypto/hmac"
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/sha512"
	"encoding/hex"
	"hash"

	lua "github.com/yuin/gopher-lua"
)

func hmacFn(L *lua.LState) int {
	algorithm := lua.LVAsString(L.Get(1))
	s := lua.LVAsString(L.Get(2))
	key := lua.LVAsString(L.Get(3))
	raw := lua.LVAsBool(L.Get(4))

	var h hash.Hash
	switch algorithm {
	case "md5":
		h = hmac.New(md5.New, []byte(key))
	case "sha1":
		h = hmac.New(sha1.New, []byte(key))
	case "sha256":
		h = hmac.New(sha256.New, []byte(key))
	case "sha512":
		h = hmac.New(sha512.New, []byte(key))
	default:
		L.Push(lua.LNil)
		L.Push(lua.LString("unsupported algorithm"))
		return 2
	}

	_, err := h.Write([]byte(s))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	var result string
	if !raw {
		result = hex.EncodeToString(h.Sum(nil))
	} else {
		result = string(h.Sum(nil))
	}
	L.Push(lua.LString(result))
	return 1
}

func validHmacFn(L *lua.LState) int {
	algorithm := L.CheckString(1)
	message := L.CheckString(2)
	key := L.CheckString(3)
	mmac := L.CheckString(4)
	var mac hash.Hash
	switch algorithm {
	case "md5":
		mac = hmac.New(md5.New, []byte(key))
	case "sha1":
		mac = hmac.New(sha1.New, []byte(key))
	case "sha256":
		mac = hmac.New(sha256.New, []byte(key))
	case "sha512":
		mac = hmac.New(sha512.New, []byte(key))
	default:
		L.Push(lua.LNil)
		L.Push(lua.LString("unsupported algorithm"))
		return 2
	}
	mac.Write([]byte(message))
	expectedMAC := mac.Sum(nil)
	if hmac.Equal([]byte(mmac), expectedMAC) {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LFalse)
	}
	return 1
}
