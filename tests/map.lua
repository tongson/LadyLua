local included = pcall(debug.getlocal, 4, 1)
local bimap = require("map")
local T = require("test")
local expect = T.expect
local func = T.is_function
local tbl = T.is_table
--# = bimap
--# :toc:
--# :toc-placement!:
--#
--# Bidirectional map implementation.
--#
--# toc::[]
--#
--# == *bimap.new*() -> _Table_, _Table_
--# Create a new map.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Array side
--# |table |Map side
--# |===
local new = function()
	func(bimap.new)
	local l, r = bimap.new()
	tbl(l)
	tbl(r)
end
local raw = function()
	local l, r = bimap.new()
	l.test = true
	l.nope = false
	local left = l("raw")
	local right = r("raw")
	expect(true)(left["test"])
	expect(false)(left["nope"])
	expect("test")(right[true])
	expect("nope")(right[false])
end
local len = function()
	local t = { 1 }
	expect(1)(#t)
	local l, r = bimap.new()
	l.test = 1
	l.nope = 2
	expect(0)(l("len"))
	expect(2)(r("len"))
end
local testing = function(l, r)
	expect(2)(l.bar)
	expect("bar")(r[2])
	local r1 = r("raw")
	expect("foo")(r1[1])
	expect("bar")(r1[2])
	expect("baz")(r1[3])
	local t1 = l("raw")
	expect(1)(t1.foo)
	expect(2)(t1.bar)
	expect(3)(t1.baz)
	expect(3)(r("len"))
	l.baz = nil
	expect(2)(#(r("raw")))
	r[r("len")] = nil
	local r2 = r("raw")
	expect("foo")(r2[1])
	local l1 = l("raw")
	expect(1)(l1.foo)
	expect(1)(r("len"))
	l.spam = "eggs"
	r.eggs = "chunky"
	l["chunky"] = "bacon"
	expect("bacon")(l["chunky"])
	expect("chunky")(r["bacon"])
	expect(nil)(l["spam"])
	expect(nil)(r["eggs"])
	local r3 = r("raw")
	local l2 = l("raw")
	expect("foo")(r3[1])
	expect("chunky")(r3.bacon)
	expect(1)(l2.foo)
	expect("bacon")(l2.chunky)
	local fn = function()
		l.evil = 1
	end
	T.error_raised(
		fn,
		'cannot assign value "1" to key "evil": ' .. 'already assigned to key "foo"'
	)
end
local left = function()
	local l, r = bimap.new()
	l.foo = 1
	l.bar = 2
	l.baz = 3
	testing(l, r)
end
local right = function()
	local l, r = bimap.new{"foo", "bar", "baz"}
	testing(r, l)
end
local iter = function()
	local l, r = bimap.new{"foo", "bar", "baz"}
	local t = {}
	local x = l("raw")
	for n = 1, l("len") do
		t[n] = x[n]
	end
	expect("foo")(t[1])
	expect("bar")(t[2])
	expect("baz")(t[3])
end
if included then
	return function()
		T["new"] = new
		T["raw argument"] = raw
		T["len argument"] = len
		T["left"] = left
		T["right"] = right
		T["iteration"] = iter
	end
else
	T["new"] = new
	T["raw argument"] = raw
	T["len argument"] = len
	T["left"] = left
	T["right"] = right
	T["iteration"] = iter
end
