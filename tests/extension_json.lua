local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local J = require("json")
extend("json")
local expect = T.expect
--# = extension: json
--# :toc:
--# :toc-placement!:
--#
--# Additional functions for the `json` module.
--#
--# To load and patch `json` namespace:
--# ----
--# extend("json")
--# ----
--#
--# toc::[]
--#
--# == *json.array*(_String_)
--# JSON array iterator
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
local json_array = function()
	T.is_function(J.array)
	local t = {
		"one",
		"two",
		"three",
	}
	local e = {}
	for x, y in J.array(J.encode(t)) do
		e[x] = y
	end
	expect(t[1])(e[1])
	expect(t[2])(e[2])
	expect(t[3])(e[3])
end
--#
--# == *json.object*(_String_)
--# JSON object iterator.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
local json_object = function()
	T.is_function(J.object)
	local t = {
		one = 1,
		two = 2,
		three = 3,
	}
	local e = {}
	for x, y in J.object(J.encode(t)) do
		e[x] = y
	end
	expect(t.one)(e.one)
	expect(t.two)(e.two)
	expect(t.three)(e.three)
end
if included then
	return function()
		T["json array iterator"] = json_array
		T["json object iterator"] = json_object
	end
else
	T["json array iterator"] = json_array
	T["json object iterator"] = json_object
end
