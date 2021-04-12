package gluasql_mysql

import (
	"github.com/yuin/gopher-lua"
)

var exports = map[string]lua.LGFunction{
	"new":    newFn,
	"escape": escapeFn,
}

func Loader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), exports)
	L.Push(mod)

	L.SetField(mod, "_DEBUG", lua.LBool(false))
	L.SetField(mod, "_VERSION", lua.LString("0.0.0"))

	registerClientType(L)

	return 1
}

func registerClientType(L *lua.LState) {
	mt := L.NewTypeMetatable(CLIENT_TYPENAME)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), clientMethods))
}

func newFn(L *lua.LState) int {
	client := &Client{}
	ud := L.NewUserData()
	ud.Value = client
	L.SetMetatable(ud, L.GetTypeMetatable(CLIENT_TYPENAME))
	L.Push(ud)
	return 1
}

func escape(source string) string {
	var j int = 0
	if len(source) == 0 {
		return ""
	}
	tempStr := source[:]
	desc := make([]byte, len(tempStr)*2)
	for i := 0; i < len(tempStr); i++ {
		flag := false
		var escape byte
		switch tempStr[i] {
		case '\r':
			flag = true
			escape = 'r'
			break
		case '\n':
			flag = true
			escape = 'n'
			break
		case '\\':
			flag = true
			escape = '\\'
			break
		case '\'':
			flag = true
			escape = '\''
			break
		case '"':
			flag = true
			escape = '"'
			break
		case '\032':
			flag = true
			escape = 'Z'
			break
		default:
		}
		if flag {
			desc[j] = '\\'
			desc[j+1] = escape
			j = j + 2
		} else {
			desc[j] = tempStr[i]
			j = j + 1
		}
	}
	return string(desc[0:j])
}

func escapeFn(L *lua.LState) int {
	s := L.ToString(1)
	L.Push(lua.LString(escape(s)))
	return 1
}
