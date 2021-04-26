local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
--# = ulid
--# :toc:
--# :toc-placement!:
--#
--# Generate random strings in ULID format.
--# This is a https://github.com/oklog/ulid/[ulid] wrapper.
--#
--# toc::[]
--#
--# == *ulid.new*() -> _String_
--# Generate an ID.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |ULID string
--# |===
local ulid_new = function()
	local U = require("ulid")
	T.is_function(U.new)
	local s = U.new()
	local n = U.new()
	T.is_string(s)
	T.equal(tonumber(#s), 26)
	T.not_equal(s, n)
end
if included then
	return function()
		T["ulid.new"] = ulid_new
	end
else
	T["ulid.new"] = ulid_new
end
