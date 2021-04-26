local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
--# = ksuid
--# :toc:
--# :toc-placement!:
--#
--# Generate unique IDs. This is a https://github.com/segmentio/ksuid[ksuid] wrapper.
--#
--# toc::[]
--#
--# == *ksuid.new*() -> _String_
--# Generate an ID.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |ksuid string
--# |===
local ksuid_new = function()
	local U = require("ksuid")
	T.is_function(U.new)
	local s = U.new()
	local n = U.new()
	T.is_string(s)
	T.equal(tonumber(#s), 27)
	T.not_equal(s, n)
end
if included then
	return function()
		T["ksuid.new"] = ksuid_new
	end
else
	T["ksuid.new"] = ksuid_new
end
