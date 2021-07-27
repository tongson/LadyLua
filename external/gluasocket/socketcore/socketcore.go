package gluasocket_socketcore

import (
	"github.com/yuin/gopher-lua"
)

const (
	AF_UNSPEC = 0
	AF_INET   = 2
	AF_INET6  = 23
)

// ----------------------------------------------------------------------------

var exports = map[string]lua.LGFunction{
	"connect": connectFn,
	"gettime": gettimeFn,
	"select":  selectFn,
	"skip":    skipFn,
	"sleep":   sleepFn,
	"tcp":     tcpFn,
	"tcp4":    tcp4Fn,
	"tcp6":    tcp6Fn,
	"udp":     udpFn,
}

// ----------------------------------------------------------------------------

func Loader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), exports)
	L.Push(mod)

	L.SetField(mod, "_DEBUG", lua.LBool(false))
	L.SetField(mod, "_VERSION", lua.LString("0.0.0")) // TODO

	registerClientType(L)
	registerMasterType(L)

	registerDNSTable(L, mod)

	return 1
}

// ----------------------------------------------------------------------------

func registerClientType(L *lua.LState) {
	mt := L.NewTypeMetatable(CLIENT_TYPENAME)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), clientMethods))
}

// ----------------------------------------------------------------------------

func registerDNSTable(L *lua.LState, mod *lua.LTable) {
	table := L.NewTable()
	L.SetFuncs(table, dnsMethods)
	L.SetField(mod, "dns", table)
}

// ----------------------------------------------------------------------------

func registerMasterType(L *lua.LState) {
	mt := L.NewTypeMetatable(MASTER_TYPENAME)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), masterMethods))
}
