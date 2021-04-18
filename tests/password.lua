local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local password = require("password")
--# = password
--# :toc:
--# :toc-placement!:
--#
--# Generate random passwords with requirements. Wraps https://github.com/sethvargo/go-password[go-password].
--#
--# toc::[]
--#
--# == *password.generate*(_Number_, _Number_, _Number_, _Boolean_, _Boolean_) -> _String_
--# Generate password.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Total number of characters generated
--# |number |Total number of digits in the password
--# |number |Total number of symbols in the password
--# |boolean |If `true`, only lowercase
--# |boolean |If `true`, allow repeating characters
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Password
--# |===
local password_generate = function()
	T.is_function(password.generate)
	local p = password.generate(5, 1, 1, true, true)
	T.is_string(p)
	T.equal(string.len(p), 5)
	local n = string.find(p, "%d")
	T.is_true((n > 0))
	local s = string.find(p, "%p")
	T.is_true((s > 0))
	local u = string.find(p, "%u")
	T.is_nil(u)
end
if included then
	return function()
		T["password.generate"] = password_generate
	end
else
	T["password.generate"] = password_generate
end
