package ll

import (
	"github.com/prologic/bitcask"
	"github.com/yuin/gopher-lua"
)

const (
	BITCASK_TYPE = "bitcask{api}"
)

var bitcaskApi = map[string]lua.LGFunction{}

func bitcaskCheck(L *lua.LState) *bitcask.Bitcask {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*bitcask.Bitcask); ok {
		return v
	} else {
		return nil
	}
}

func bitcaskClose(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.close: Invalid lock."))
		return 2
	}
	err := bc.Close()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func bitcaskSync(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.sync: Invalid lock."))
		return 2
	}
	err := bc.Sync()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func bitcaskPut(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.put: Unable to open database."))
		return 2
	}
	key := L.CheckString(2)
	value := L.CheckString(3)
	err := bc.Put([]byte(key), []byte(value))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func bitcaskGet(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.get: Unable to open database."))
		return 2
	}
	key := L.CheckString(2)
	value, err := bc.Get([]byte(key))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LString(value))
		return 1
	}
}

func bitcaskKeys(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.get: Unable to open database."))
		return 2
	}
	keys := bc.Keys()
	kt := L.NewTable()
	for k := range keys {
		kt.Append(lua.LString(k))
	}
	L.Push(kt)
	return 1
}

func bitcaskHas(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.has: Unable to open database."))
		return 2
	}
	key := L.CheckString(2)
	found := bc.Has([]byte(key))
	if found {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LNil)
	}
	return 1
}

func bitcaskDelete(L *lua.LState) int {
	bc := bitcaskCheck(L)
	if bc == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("bitcask.delete: Unable to open database."))
		return 2
	}
	key := L.CheckString(2)
	err := bc.Delete([]byte(key))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

var bitcaskMethods = map[string]lua.LGFunction{
	"put":    bitcaskPut,
	"get":    bitcaskGet,
	"keys":   bitcaskKeys,
	"has":    bitcaskHas,
	"delete": bitcaskDelete,
	"close":  bitcaskClose,
	"sync":   bitcaskSync,
}

var bitcaskExports = map[string]lua.LGFunction{
	"open": bitcaskOpen,
}

func bitcaskLoader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), bitcaskExports)
	L.Push(mod)
	bitcaskRegister(L)
	return 1
}

func bitcaskRegister(L *lua.LState) {
	mt := L.NewTypeMetatable(BITCASK_TYPE)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), bitcaskMethods))
}

func bitcaskOpen(L *lua.LState) int {
	f := L.CheckString(1)
	db, _ := bitcask.Open(f)
	ud := L.NewUserData()
	ud.Value = db
	L.SetMetatable(ud, L.GetTypeMetatable(BITCASK_TYPE))
	L.Push(ud)
	return 1
}
