package gluasql_mysql

import (
	"database/sql"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/yuin/gopher-lua"
)

const (
	CLIENT_TYPENAME = "mysql{client}"
)

// Client mysql
type Client struct {
	DB      *sql.DB
	Timeout time.Duration
}

var clientMethods = map[string]lua.LGFunction{
	"connect":       clientConnectMethod,
	"set_timeout":   clientSetTimeoutMethod,
	"set_keepalive": clientSetKeepaliveMethod,
	"close":         clientCloseMethod,
	"query":         clientQueryMethod,
}

func checkClient(L *lua.LState) *Client {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*Client); ok {
		return v
	}
	L.ArgError(1, "client expected")
	return nil
}

func clientCloseMethod(L *lua.LState) int {
	client := checkClient(L)

	if client.DB == nil {
		L.Push(lua.LBool(true))
		return 1
	}

	err := client.DB.Close()
	// always clean
	client.DB = nil
	if err != nil {
		L.Push(lua.LBool(false))
		L.Push(lua.LString(err.Error()))
		return 2
	}

	L.Push(lua.LBool(true))
	return 1
}

func clientSetKeepaliveMethod(L *lua.LState) int {
	client := checkClient(L)
	idleTimeout := L.ToInt64(2) // timeout (in ms)
	poolSize := L.ToInt(3)

	if client.DB == nil {
		L.Push(lua.LBool(true))
		L.Push(lua.LString("connect required"))
		return 2
	}

	client.DB.SetConnMaxLifetime(time.Millisecond * time.Duration(idleTimeout))
	client.DB.SetMaxIdleConns(poolSize)

	L.Push(lua.LBool(true))
	return 1
}
