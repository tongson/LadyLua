package main

import (
	"context"
	"github.com/go-redis/redis/v8"
	"github.com/yuin/gopher-lua"
	"time"
)

var ctx = context.Background()

const (
	REDIS_TYPE = "redis{client}"
)

var redisApi = map[string]lua.LGFunction{}

func redisCheck(L *lua.LState) *redis.Client {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*redis.Client); ok {
		return v
	} else {
		return nil
	}
}

func redisSet(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.set: Invalid Redis client."))
		return 2
	}
	key := L.CheckString(2)
	value := L.CheckString(3)
	expiration := time.Duration(L.OptNumber(4, 0))
	err := rdb.Set(ctx, key, value, expiration).Err()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.set: Unable to set key."))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func redisGet(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.get: Invalid Redis client."))
		return 2
	}
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

func redisDel(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.del: Invalid Redis client."))
		return 2
	}
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

func redisIncr(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.incr: Invalid Redis client."))
		return 2
	}
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

func redisHSet(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hset: Invalid Redis client."))
		return 2
	}
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

func redisHGet(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hget: Invalid Redis client."))
		return 2
	}
	key := L.CheckString(2)
	field := L.CheckString(3)
	v, err := rdb.HGet(ctx, key, field).Result()
	if err == redis.Nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hget: Field does not exist."))
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

func redisHDel(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hdel: Invalid Redis client."))
		return 2
	}
	key := L.CheckString(2)
	field := L.CheckString(3)
	n, err := rdb.HDel(ctx, key, field).Result()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.hdel: Error deleting key."))
		return 2
	} else {
		L.Push(lua.LNumber(n))
		return 1
	}
}

func redisClose(L *lua.LState) int {
	rdb := redisCheck(L)
	if rdb == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("redis.close: Invalid Redis client."))
		return 2
	}
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

var redisMethods = map[string]lua.LGFunction{
	"set":   redisSet,
	"get":   redisGet,
	"del":   redisDel,
	"incr":  redisIncr,
	"hset":  redisHSet,
	"hget":  redisHGet,
	"hdel":  redisHDel,
	"close": redisClose,
}

var redisExports = map[string]lua.LGFunction{
	"client": redisClient,
}

func redisLoader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), redisExports)
	L.Push(mod)
	redisRegister(L)
	return 1
}

func redisRegister(L *lua.LState) {
	mt := L.NewTypeMetatable(REDIS_TYPE)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), redisMethods))
}

func redisClient(L *lua.LState) int {
	addr := L.OptString(1, "127.0.0.1:6379")
	pass := L.OptString(2, "")
	db := int(L.OptNumber(3, 0))
	rdb := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: pass,
		DB:       db,
	})
	ud := L.NewUserData()
	ud.Value = rdb
	L.SetMetatable(ud, L.GetTypeMetatable(REDIS_TYPE))
	L.Push(ud)
	return 1
}
