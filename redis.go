package main

import (
	"context"
	"github.com/go-redis/redis/v8"
	"github.com/yuin/gopher-lua"
	"time"
)

var ctx = context.Background()

func rdbClient(L *lua.LState) int {
	addr := L.CheckString(1)
	pass := L.CheckString(2)
	db := int(L.CheckNumber(3))
	rdb := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: pass,
		DB:       db,
	})
	client := L.NewUserData()
	client.Value = rdb
	L.Push(client)
	return 1
}

func rdbSet(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	key := L.CheckString(2)
	v := L.CheckAny(3)
	expiration := time.Duration(L.CheckNumber(4))
	var err error
  if strv, ok := v.(lua.LString); ok {
	  err = rdb.Set(ctx, key, string(strv), expiration).Err()
  } else if intv, ok := v.(lua.LNumber); ok {
	  err = rdb.Set(ctx, key, int(intv), expiration).Err()
  }
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.set: Unable to set key."))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func rdbGet(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	key := L.CheckString(2)
	value, err := rdb.Get(ctx, key).Result()
	if err == redis.Nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.get: Key does not exist."))
		return 2
	} else if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.get: Error getting key."))
		return 2
	} else {
		L.Push(lua.LString(value))
		return 1
	}
}

func rdbDel(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	key := L.CheckString(2)
	n, err := rdb.Del(ctx, key).Result()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.del: Error deleting key."))
		return 2
	} else {
		L.Push(lua.LNumber(n))
		return 1
	}
}

func rdbIncr(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	key := L.CheckString(2)
	n, err := rdb.Incr(ctx, key).Result()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.incr: Error incrementing key."))
		return 2
	} else {
		L.Push(lua.LNumber(n))
		return 1
	}
}

func rdbHSet(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	key := L.CheckString(2)
	t := L.CheckTable(3)
	fv := make(map[string]interface{})
	t.ForEach(func(field, value lua.LValue) {
		fv[lua.LVAsString(field)] = lua.LVAsString(value)
	})
	err := rdb.HSet(ctx, key, fv).Err()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hset: Error setting key."))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func rdbHGet(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	key := L.CheckString(2)
	field := L.CheckString(3)
	v, err := rdb.HGet(ctx, key, field).Result()
	if err == redis.Nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hget: Key does not exist."))
		return 2
	} else if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hget: Error fetching key."))
		return 2
	} else {
		L.Push(lua.LString(v))
		return 1
	}
}

func rdbClose(L *lua.LState) int {
	ud := L.CheckUserData(1)
	rdb := ud.Value.(*redis.Client)
	err := rdb.Close()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.close: Error closing connection."))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func redisLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, redisApi)
	L.Push(t)
	return 1
}

var redisApi = map[string]lua.LGFunction{
	"client": rdbClient,
	"set":    rdbSet,
	"get":    rdbGet,
	"del":    rdbDel,
	"incr":   rdbIncr,
	"hset":   rdbHSet,
	"hget":   rdbHGet,
	"close":  rdbClose,
}
