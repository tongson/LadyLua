package ll

import (
	"bytes"
	"github.com/oklog/ulid/v2"
	"github.com/yuin/gopher-lua"
	"hash/maphash"
	"strconv"
	"time"
)

func ulidNew(L *lua.LState) int {
	b := []byte(strconv.FormatUint(new(maphash.Hash).Sum64(), 10))
	e := bytes.NewReader(b)
	id, err := ulid.New(ulid.Timestamp(time.Now()), e)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(id.String()))
	return 1
}

func UlidLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, ulidApi)
	L.Push(t)
	return 1
}

var ulidApi = map[string]lua.LGFunction{
	"new": ulidNew,
}
