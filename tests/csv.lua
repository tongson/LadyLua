local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local expect = T.expect
local csv = require("csv")
--# = csv
--# :toc:
--# :toc-placement!:
--#
--# Parse and encode CSV.
--#
--# toc::[]
--#
--# == *csv.parse*(_String_) -> _Table_
--# Decode a CSV into a table.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |CSV
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Table
--# |===
local bom = [[
a,b,c
1,2,3
4,5,ʤ
]]
local csv_parse = function()
	T.is_function(csv.parse)
	local t = csv.parse("a,b,c\napple,banana,carrot", ",")
	expect("apple")(t[1].a)
	expect("banana")(t[1].b)
	expect("carrot")(t[1].c)
	local b = csv.parse(bom, ",")
	expect("1")(b[1].a)
	expect("2")(b[1].b)
	expect("3")(b[1].c)
	expect("4")(b[2].a)
	expect("5")(b[2].b)
	expect("ʤ")(b[2].c)
	local c = csv.parse("a,b,c\r\napple,banana,carrot", ",")
	expect("apple")(c[1].a)
	expect("banana")(c[1].b)
	expect("carrot")(c[1].c)
	local d = csv.parse("a,b,c\rapple,banana,carrot", ",")
	expect("apple")(d[1].a)
	expect("banana")(d[1].b)
	expect("carrot")(d[1].c)
	local e = csv.parse('"a","b","c"\n"apple","banana","carrot"', ",")
	expect("apple")(e[1].a)
	expect("banana")(e[1].b)
	expect("carrot")(e[1].c)
	local f = csv.parse('"a","b","c"\n"""apple""","""banana""","""carrot"""', ",")
	expect([["apple"]])(f[1].a)
	expect([["banana"]])(f[1].b)
	expect([["carrot"]])(f[1].c)
	local g = csv.parse('"a","b","c"\n"""apple""","banana","""carrot"""', ",")
	expect([["apple"]])(g[1].a)
	expect([[banana]])(g[1].b)
	expect([["carrot"]])(g[1].c)
	local h = csv.parse('a;b;c\n"A""B""""C";"A""""B""C";"A""""""B""""C"', ";")
	expect([[A"B""C]])(h[1].a)
	expect([[A""B"C]])(h[1].b)
	expect([[A"""B""C]])(h[1].c)
	local i = csv.parse("a,b,c\r\napple,banana,carrot", ",", {rename={["a"] = "d"}})
	expect([[apple]])(i[1].d)
	expect([[banana]])(i[1].b)
	expect([[carrot]])(i[1].c)
	local j = csv.parse("a,b,c\r\napple,banana,carrot", ",", {rename={["a"] = "d", ["b"] = "e", ["c"] = "f"}})
	expect([[apple]])(j[1].d)
	expect([[banana]])(j[1].e)
	expect([[carrot]])(j[1].f)
end
--#
--# == *csv.encode*(_Table_) -> _String_
--# Encode table into CSV string.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Table
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |CSV
--# |===
local csv_encode = function()
	T.is_function(csv.encode)
end
if included then
	return function()
		T["csv.parse"] = csv_parse
	end
else
	T["csv.parse"] = csv_parse
end
