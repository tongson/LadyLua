extend("exec")
local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local bitcask = require("bitcask")
local db
--# = bitcask
--# :toc:
--# :toc-placement!:
--#
--# Wrapper to https://github.com/prologic/bitcask[Bitcask].
--#
--# [NOTE]
--# ====
--# Maximum key size is *64* bytes +
--# Default maximum value size is *64* KiB
--# ====
--#
--# toc::[]
--#
--# == *bitcask.open*(_String_[, _Number_]) -> _Userdata_
--# Open a database. Creates a new database if it does not exists.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Path for directory hierarchy
--# |number |Maximum value size in bytes; default 64KiB
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |userdata |Database lock
--# |===
local bitcask_open = function()
	T.is_function(bitcask.open)
	db = bitcask.open("/tmp/bitcask", 256000)
	T.is_userdata(db)
	T.is_true(fs.isdir("/tmp/bitcask"))
end
--#
--# == *:put*(_String_, _String_) -> _Boolean_
--# Write key-value to database.
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
--# |boolean |`true` if succesful
--# |===
local bitcask_put = function()
	T.is_function(db.put)
	T.is_true(db:put("one", "uno"))
end
--#
--# == *:keys*() -> _Table_
--# List of keys in database.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |List of keys
--# |===
local bitcask_keys = function()
	T.is_function(db.keys)
	T.is_true(db:put("xxx", "1"))
	T.is_true(db:put("yyy", "2"))
	local keys = db:keys()
	T.equal(keys[1], "xxx")
	T.equal(keys[2], "yyy")
	T.is_true(db:delete("xxx"))
	T.is_true(db:delete("yyy"))
end
--#
--# == *:get*(_String_) -> _String_
--# Fetch value with matching key.
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
local bitcask_get = function()
	T.is_function(db.get)
	local got = db:get("one")
	T.equal(got, "uno")
end
--#
--# == *:has*(_String_) -> _Boolean_
--# Returns true if the key exists in the database, false otherwise.
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
--# |boolean |`true` if found, `false` otherwise
--# |===
local bitcask_has = function()
	T.is_function(db.has)
	T.is_true(db:has("one"))
end
--#
--# == *:delete*(_String_) -> _Boolean_
--# Delete key and value from database.
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
--# |boolean |`true` if successful
--# |===
local bitcask_delete = function()
	T.is_function(db.delete)
	T.is_true(db:delete("one"))
	T.is_nil(db:has("one"))
end
--#
--# == *:sync*() -> _Boolean_
--# Flush buffers to disk ensuring all data is written
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if successful
--# |===
local bitcask_sync = function()
	T.is_function(db.sync)
	T.is_true(db:sync())
end
local binary_values = function()
	local C = require("crypto")
	local bin = fs.read("/usr/bin/ls")
	local hash = C.sha256(bin)
	T.is_true(db:put("binary", bin))
	local value = db:get("binary")
	local got = C.sha256(value)
	T.equal(hash, got)
end
--#
--# == *:close*() -> _Boolean_
--# Release database lock.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if successful
--# |===
local bitcask_close = function()
	T.is_function(db.close)
	T.is_true(db:close())
end
if included then
	return function()
		T["bitcask.open"] = bitcask_open
		T["bitcask.put"] = bitcask_put
		T["bitcask.get"] = bitcask_get
		T["bitcask.has"] = bitcask_has
		T["bitcask.delete"] = bitcask_delete
		T["bitcask.keys"] = bitcask_keys
		T["bitcask.sync"] = bitcask_sync
		T["bitcask binary values"] = binary_values
		T["bitcask.close"] = bitcask_close
		exec.run.rm("-r", "-f", "/tmp/bitcask")
	end
else
	T["bitcask.open"] = bitcask_open
	T["bitcask.put"] = bitcask_put
	T["bitcask.get"] = bitcask_get
	T["bitcask.has"] = bitcask_has
	T["bitcask.delete"] = bitcask_delete
	T["bitcask.keys"] = bitcask_keys
	T["bitcask.sync"] = bitcask_sync
	T["bitcask binary values"] = binary_values
	T["bitcask.close"] = bitcask_close
	exec.run.rm("-r", "-f", "/tmp/bitcask")
end
