package main

import (
	"github.com/gregdel/pushover"
	"github.com/yuin/gopher-lua"
	"os"
)

const (
	PUSHOVER_TYPE = "pushover{api}"
)

func pushoverCheck(L *lua.LState) *pushover.Pushover {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*pushover.Pushover); ok {
		return v
	} else {
		return nil
	}
}

func pushoverMessage(L *lua.LState) int {
	p := pushoverCheck(L)
	if p == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("Initializing with Pushover token failed."))
		return 2
	}
	r := L.CheckString(2)
	m := L.CheckString(3)
	recipient := pushover.NewRecipient(r)
	message := pushover.NewMessage(m)
	response, err := p.SendMessage(message, recipient)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(response.String()))
	return 1
}

var pushoverMethods = map[string]lua.LGFunction{
	"message": pushoverMessage,
}

var pushoverExports = map[string]lua.LGFunction{
	"new": pushoverNew,
}

func pushoverLoader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), pushoverExports)
	L.Push(mod)
	L.SetField(mod, "_DEBUG", lua.LBool(false))
	L.SetField(mod, "_VERSION", lua.LString("0.0.0"))
	pushoverRegister(L)
	return 1
}

func pushoverRegister(L *lua.LState) {
	mt := L.NewTypeMetatable(PUSHOVER_TYPE)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), pushoverMethods))
}

func pushoverNew(L *lua.LState) int {
	token := os.Getenv("PUSHOVER_TOKEN")
	ud := L.NewUserData()
	p := pushover.New(token)
	ud.Value = p
	L.SetMetatable(ud, L.GetTypeMetatable(PUSHOVER_TYPE))
	L.Push(ud)
	return 1
}
