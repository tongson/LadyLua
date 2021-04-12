package gluasql_mysql

import (
	"database/sql"
	"fmt"
	"net/url"

	util "github.com/tengattack/gluasql/util"
	"github.com/yuin/gopher-lua"
)

func clientConnectMethod(L *lua.LState) int {
	client := checkClient(L)
	tb := util.GetValue(L, 2)
	options, ok := tb.(map[string]interface{})

	if tb == nil || !ok {
		L.ArgError(2, "options excepted")
		return 0
	}

	host, _ := options["host"].(string)
	if host == "" {
		host = "127.0.0.1"
	}
	port, _ := options["port"].(int)
	if port == 0 {
		port = 3306
	}
	database, _ := options["database"].(string)
	user, _ := options["user"].(string)
	password, _ := options["password"].(string)
	charset, _ := options["charset"].(string)

	// current support tcp connection only
	dsn := fmt.Sprintf("tcp(%s:%d)/%s", host, port, database)
	if user != "" {
		if password != "" {
			dsn = fmt.Sprintf("%s:%s@", user, password) + dsn
		} else {
			dsn = fmt.Sprintf("%s@", user) + dsn
		}
	}

	query := url.Values{}
	if charset != "" {
		query.Set("charset", charset)
	}
	if client.Timeout > 0 {
		stimeout := client.Timeout.String()
		query.Set("readTimeout", stimeout)
		query.Set("writeTimeout", stimeout)
	}

	s := query.Encode()
	if s != "" {
		dsn += "?" + s
	}

	var err error
	client.DB, err = sql.Open("mysql", dsn)
	if err != nil {
		L.Push(lua.LBool(false))
		L.Push(lua.LString(err.Error()))
		return 2
	}

	L.Push(lua.LBool(true))
	return 1
}
