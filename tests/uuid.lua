local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
--# = uuid
--# :toc:
--# :toc-placement!:
--#
--# Generate random strings in UUID format.
--# This is a https://github.com/hashicorp/go-uuid[go-uuid] wrapper.
--#
--# toc::[]
--#
--# == *uuid.new*() -> _String_
--# Generate an ID.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |uuid string
--# |===
local uuid_new = function()
	local U = require("uuid")
	T.is_function(U.new)
	local s = U.new()
	local n = U.new()
	T.is_string(s)
	T.equal(tonumber(#s), 36)
	T.not_equal(s, n)
end
if included then
	return function()
		T["uuid.new"] = uuid_new
	end
else
	T["uuid.new"] = uuid_new
end
