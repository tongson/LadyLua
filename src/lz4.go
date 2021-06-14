package ll

import (
	"bytes"
	"github.com/pierrec/lz4"
	"github.com/yuin/gopher-lua"
	"io"
	"strings"
)

func lz4Compress(L *lua.LState) int {
	s := L.CheckString(1)
	r := strings.NewReader(s)
	pr, pw := io.Pipe()
	zw := lz4.NewWriter(pw)
	go func() {
		_, _ = io.Copy(zw, r)
		_ = zw.Close()
		_ = pw.Close()
	}()
	if b, err := io.ReadAll(pr); err == nil {
		L.Push(lua.LString(b))
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString("Unable to compress."))
		return 2
	}
}

func lz4Decompress(L *lua.LState) int {
	s := L.CheckString(1)
	r := strings.NewReader(s)
	var out bytes.Buffer
	zr := lz4.NewReader(r)
	_, err := io.Copy(&out, zr)
	if err == nil {
		L.Push(lua.LString(out.String()))
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString("Unable to decompress."))
		return 2
	}
}

func lz4Loader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, lz4Api)
	L.Push(t)
	return 1
}

var lz4Api = map[string]lua.LGFunction{
	"compress":   lz4Compress,
	"decompress": lz4Decompress,
}
