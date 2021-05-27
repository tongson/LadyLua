local included = pcall(debug.getlocal, 4, 1)
local I = require("iterator")
local json = require("json")
local T = require("test")
local expect = T.expect
--# = iterator
--# :toc:
--# :toc-placement!:
--#
--# Iterator and generators.
--#
--# toc::[]
--#
--# == *iterator.array*(_String_)
--# For JSON arrays.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
local iterator_array = function()
	T.is_function(I.array)
	local t = {
		"one",
		"two",
		"three",
	}
	local e = {}
	for x, y in I.array(json.encode(t)) do
		e[x] = y
	end
	expect(t[1])(e[1])
	expect(t[2])(e[2])
	expect(t[3])(e[3])
end
--#
--# == *iterator.object*(_String_)
--# For JSON objects.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
local iterator_object = function()
	T.is_function(I.array)
	local t = {
		one = 1,
		two = 2,
		three = 3,
	}
	local e = {}
	for x, y in I.object(json.encode(t)) do
		e[x] = y
	end
	expect(t.one)(e.one)
	expect(t.two)(e.two)
	expect(t.three)(e.three)
end
if included then
	return function()
		T["iterator.array"] = iterator_array
		T["iterator.object"] = iterator_object
	end
else
	T["iterator.array"] = iterator_array
	T["iterator.object"] = iterator_object
end
