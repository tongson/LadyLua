package ll

import (
	cryptorand "crypto/rand"
	"github.com/oklog/ulid/v2"
	"github.com/yuin/gopher-lua"
	mathrand "math/rand"
	"time"
)

func ulidNew(L *lua.LState) int {
	entropy := cryptorand.Reader
	seed := time.Now().UnixNano()
	source := mathrand.NewSource(seed)
	entropy = mathrand.New(source)
	id, err := ulid.New(ulid.Timestamp(time.Now()), entropy)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(id.String()))
	return 1
}

func ulidLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, ulidApi)
	L.Push(t)
	return 1
}

var ulidApi = map[string]lua.LGFunction{
	"new": ulidNew,
}
