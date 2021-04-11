local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
local redis = require 'redis'
local redis_functions = function()
  T.is_function(redis.close)
  T.is_function(redis.client)
  T.is_function(redis.get)
  T.is_function(redis.set)
  T.is_function(redis.del)
  T.is_function(redis.incr)
  T.is_function(redis.hset)
  T.is_function(redis.hget)
end
--# = redis
--# :toc:
--# :toc-placement!:
--#
--# Access Redis and run Redis commands.
--#
--# toc::[]
--#
--# == *redis.new*([_String_][, _String_][, _Number_]) -> _Table_
--# Create a new Redis client connection.
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
--# |table |Object that you can index into to perform commands
--# |===
--#
--# === Example
--# ----
--# local redis = require 'redis'
--# local rdb = redis.new()
--# ...
--# ----
local redis_new = function()
  T.is_function(redis.new)
  local r = redis.new('127.0.0.1:6379', '', 0)
  T.is_table(r)
  r.close()
end
--#
--# == *redis.del*(_String_) -> _Number_
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
  local r = redis.new()
  T.is_function(r.del)
  local dr, ds = r.del('absent')
  T.is_nil(ds)
  T.equal(dr, 0)
  r.close()
end
--#
--# == *redis.set*(_String_, _String_) -> _Boolean_
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
  local r = redis.new()
  T.is_function(r.set)
  local sr, ss = r.set('ll_set', 'dummy')
  T.is_nil(ss)
  T.is_true(sr)
  T.equal(r.del('ll_set'), 1)
  r.close()
end
--#
--# == *redis.get*(_String_, _String_) -> _String_
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
  local r = redis.new()
  T.is_function(r.get)
  local sr, ss = r.set('ll_get', 'dummy')
  T.is_true(sr)
  local gr, gs = r.get('ll_get')
  T.is_nil(gs)
  T.equal(gr, 'dummy')
  T.equal(r.del('ll_get'), 1)
  T.is_nil(r.get('absent'))
  r.close()
end
--#
--# == *redis.incr*(_String) -> _Number_
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
  local r = redis.new()
  T.is_function(r.get)
  --r.del('ll_incr1')
  --r.del('ll_dummy')
  local sr1 = r.set('ll_incr1', '1')
  T.is_true(sr1)
  local ir1 = r.incr('ll_incr1')
  T.equal(ir1, 2)
  local gr1 = r.get('ll_incr1')
  T.equal(gr1, '2')
  T.equal(r.del('ll_incr1'), 1)
  local xr, xs = r.incr('ll_dummy')
  T.equal(xr, 1)
  T.equal(r.del('ll_dummy'), 1)
  r.close()
end
--#
--# == *redis.hset*(_String_, _String_, _String_) -> _Boolean_
--# Sets field in the hash stored at key to value. If key does not exist, a new key holding a hash is created. If field already exists in the hash, it is overwritten.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Key
--# |string |Field
--# |string |Value
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |If successful, `true`
--# |===
local redis_hset = function()
  local r = redis.new()
  T.is_function(r.hset)
  local t = { field = 'dummy' }
  local sr, ss = r.hset('ll_hset', t)
  T.is_nil(ss)
  T.is_true(sr)
  T.equal(r.del('ll_hset'), 1)
  r.close()
end
if included then
  return function()
    T['redis internal functions'] = redis_functions
    T['redis.new'] = redis_new
    T['redis.del'] = redis_del
    T['redis.set'] = redis_set
    T['redis.get'] = redis_get
    T['redis.incr'] = redis_incr
    T['redis.hset'] = redis_hset
  end
else
  T['redis internal functions'] = redis_functions
  T['redis.new'] = redis_new
  T['redis.del'] = redis_del
  T['redis.set'] = redis_set
  T['redis.get'] = redis_get
  T['redis.incr'] = redis_incr
  T['redis.hset'] = redis_hset
end
