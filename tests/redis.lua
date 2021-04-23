local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local redis = require("redis")
local rdb = redis.client()
--# = redis
--# :toc:
--# :toc-placement!:
--#
--# Access Redis and run Redis commands.
--#
--# toc::[]
--#
--# == *redis.client*([_String_][, _String_][, _Number_]) -> _Userdata_
--# Create a new Redis client connection. The return value is an object for performing redis commands.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Address and port of Redis, default: 127.0.0.1:6379
--# |string |Password, default: ""
--# |number |Database, default: 0
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |userdata |Object that you can index into to perform commands
--# |===
--#
--# === Example
--# ----
--# local redis = require 'redis'
--# local rdb = redis.client()
--# rdb:get('key')
--# ...
--# ----
--#
--# == *:close*()
--# Close redis client connection.
local redis_client = function()
	T.is_function(redis.client)
	T.is_userdata(rdb)
end
--#
--# == *:del*(_String_) -> _Number_
--# Removes the specified keys. A key is ignored if it does not exist.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |Number |The number of keys that were removed, 1 if successful, 0 otherwise
--# |===
local redis_del = function()
	T.is_function(rdb.del)
	local dr, ds = rdb:del("absent")
	T.is_nil(ds)
	T.equal(dr, 0)
end
--#
--# == *:set*(_String_, _String_) -> _Boolean_
--# Set key to hold the string value. If key already holds a value, it is overwritten, regardless of its type. Any previous time to live associated with the key is discarded on successful SET operation.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |string |Value
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |If successful, `true`
--# |===
local redis_set = function()
	T.is_function(rdb.set)
	local sr, ss = rdb:set("ll_set", "dummy")
	T.is_nil(ss)
	T.is_true(sr)
	T.equal(rdb:del("ll_set"), 1)
end
--#
--# == *:get*(_String_, _String_) -> _String_
--# Get the value of key.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Value
--# |===
local redis_get = function()
	T.is_function(rdb.get)
	local sr, ss = rdb:set("ll_get", "dummy")
	T.is_true(sr)
	local gr, gs = rdb:get("ll_get")
	T.is_nil(gs)
	T.equal(gr, "dummy")
	T.equal(rdb:del("ll_get"), 1)
	T.is_nil(rdb:get("absent"))
end
--#
--# == *:incr*(_String) -> _Number_
--# Increments the number stored at key by one. If the key does not exist, it is set to 0 before performing the operation.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Value of key after the increment
--# |===
local redis_incr = function()
	T.is_function(rdb.incr)
	--r.del('ll_incr1')
	--r.del('ll_dummy')
	local sr1 = rdb:set("ll_incr1", "1")
	T.is_true(sr1)
	local ir1 = rdb:incr("ll_incr1")
	T.equal(ir1, 2)
	local gr1 = rdb:get("ll_incr1")
	T.equal(gr1, "2")
	T.equal(rdb:del("ll_incr1"), 1)
	local xr, xs = rdb:incr("ll_dummy")
	T.equal(xr, 1)
	T.equal(rdb:del("ll_dummy"), 1)
end
--#
--# == *:hset*(_String_, _Table_) -> _Boolean_
--# Sets field in the hash stored at key to value from a table(map). If key does not exist, a new key holding a hash is created. If field already exists in the hash, it is overwritten.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |table |Map of fields and values
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |If successful, `true`
--# |===
local redis_hset = function()
	T.is_function(rdb.hset)
	local t = { field = "dummy" }
	local sr, ss = rdb:hset("ll_hset", t)
	T.is_nil(ss)
	T.is_true(sr)
	T.equal(rdb:del("ll_hset"), 1)
end
--#
--# == *:hget*(_String_, _String_) -> _String_
--# Returns the value associated with field in the hash stored at key.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |string |Field
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Value
--# |===
local redis_hget = function()
	T.is_function(rdb.hget)
	local t = {
		field = "dummy",
		another = "useless",
	}
	local sr, ss = rdb:hset("ll_hget", t)
	T.is_nil(ss)
	T.is_true(sr)
	local gr, gs = rdb:hget("ll_hget", "another")
	T.is_nil(gs)
	T.equal(gr, "useless")
	T.equal(rdb:del("ll_hget"), 1)
end
--#
--# == *hdel*(_String_, _String_) -> _Number_
--# Removes the specified fields from the hash stored at key. Specified fields that do not exist within this hash are ignored. If key does not exist, it is treated as an empty hash and this command returns 0.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |string |Field
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Fields deleted
--# |===
local redis_hdel = function()
	T.is_function(rdb.hdel)
	local t = {
		field = "dummy",
		another = "useless",
	}
	local sr, ss = rdb:hset("ll_hdel", t)
	T.is_nil(ss)
	T.is_true(sr)
	local gr, gs = rdb:hdel("ll_hdel", "another")
	T.is_nil(gs)
	T.equal(gr, 1)
	local dr, ds = rdb:hget("ll_hdel", "another")
	T.is_nil(dr)
	T.equal(ds, "redis.hget: Field does not exist.")
	T.equal(rdb:del("ll_hdel"), 1)
end
if included then
	return function()
		T["redis.client"] = redis_client
		T["del"] = redis_del
		T["set"] = redis_set
		T["get"] = redis_get
		T["incr"] = redis_incr
		T["hset"] = redis_hset
		T["hget"] = redis_hget
		T["hdel"] = redis_hdel
	end
else
	T["redis.client"] = redis_client
	T["del"] = redis_del
	T["set"] = redis_set
	T["get"] = redis_get
	T["incr"] = redis_incr
	T["hset"] = redis_hset
	T["hget"] = redis_hget
	T["hdel"] = redis_hdel
end
