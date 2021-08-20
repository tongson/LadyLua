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
	local t1 = csv.parse("a,b,c\napple,banana,carrot", ",")
	expect("apple")(t1[1].a)
	expect("banana")(t1[1].b)
	expect("carrot")(t1[1].c)
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
	local _, k = csv.parse("a,b,c\r\napple,banana,carrot", ",", {rename={["a"] = "d", ["b"] = "e", ["c"] = "f"}})
	expect("d")(k[1])
	expect("e")(k[2])
	expect("f")(k[3])
	local l = csv.parse("a,b,c\r\napple,banana,carrot", ",", {rename={["a"] = "d", ["b"] = "e", ["c"] = "e"}})
	expect("apple")(l[1].d)
	expect("carrot")(l[1].e)
	local m = csv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", {rename={["a"] = "d", ["b"] = "e", ["c"] = "e"}})
	expect("apple")(m[1].d)
	expect("carrot")(m[1].e)
	local n = csv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", {fieldsToKeep={"a","b"}})
	expect("apple")(n[1].a)
	expect("banana")(n[1].b)
	local o = csv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", {fieldsToKeep={"a","b"}, rename={["c"] = "b"}})
	expect("apple")(o[1].a)
	expect("carrot")(o[1].b)
	local p = csv.parse("a,b,c\r\napple,banana,carrot\r\n", ",", {fieldsToKeep={"a","f"}, rename={["c"] = "f"}})
	expect("apple")(p[1].a)
	expect("carrot")(p[1].f)
	local q = csv.parse("apple>banana>carrot\ndiamond>emerald>pearl", ">", {headers = false})
	expect("apple")(q[1][1])
	expect("banana")(q[1][2])
	expect("carrot")(q[1][3])
	expect("diamond")(q[2][1])
	expect("emerald")(q[2][2])
	expect("pearl")(q[2][3])
	local r = csv.parse("apple>banana>carrot", ">", {headers = false})
	expect("apple")(r[1][1])
	expect("banana")(r[1][2])
	expect("carrot")(r[1][3])
	local s = csv.parse('"apple">"banana">"carrot"', ">", {headers = false})
	expect("apple")(s[1][1])
	expect("banana")(s[1][2])
	expect("carrot")(s[1][3])
	local t = csv.parse('"apple">"banana">"carrot"\n"diamond">"emerald">"pearl"', ">", {headers = false})
	expect("apple")(t[1][1])
	expect("banana")(t[1][2])
	expect("carrot")(t[1][3])
	expect("diamond")(t[2][1])
	expect("emerald")(t[2][2])
	expect("pearl")(t[2][3])
	local u = csv.parse("apple>banana>carrot\n", ">", {headers = false})
	expect("apple")(u[1][1])
	expect("banana")(u[1][2])
	expect("carrot")(u[1][3])
	local v = csv.parse("apple>banana>carrot\r\n", ">", {headers = false})
	expect("apple")(v[1][1])
	expect("banana")(v[1][2])
	expect("carrot")(v[1][3])
	local w = csv.parse("apple>banana>carrot\r", ">", {headers = false})
	expect("apple")(w[1][1])
	expect("banana")(w[1][2])
	expect("carrot")(w[1][3])
	local x = csv.parse("apple>banana>carrot\ndiamond>emerald>pearl", ">", {headers=false, rename={"a","b","c"}})
	expect("apple")(x[1].a)
	expect("banana")(x[1].b)
	expect("carrot")(x[1].c)
	expect("diamond")(x[2].a)
	expect("emerald")(x[2].b)
	expect("pearl")(x[2].c)
	local yo = {headers=false, rename={"a","b","c"}, fieldsToKeep={"a","b"}}
	local y = csv.parse("apple>banana>carrot\ndiamond>emerald>pearl", ">", yo)
	expect("apple")(y[1].a)
	expect("banana")(y[1].b)
	expect("diamond")(y[2].a)
	expect("emerald")(y[2].b)
	local zo = {headers=false, rename={"a","b"}, fieldsToKeep={"a","b"}}
	local z = csv.parse("apple>banana>carrot\ndiamond>emerald>pearl", ">", zo)
	expect("apple")(z[1].a)
	expect("banana")(z[1].b)
	expect("diamond")(z[2].a)
	expect("emerald")(z[2].b)
	local a = csv.parse("a,b,c\napple,banana,carrot", ",", {headerFunc=string.upper})
	expect("apple")(a[1].A)
	expect("banana")(a[1].B)
	expect("carrot")(a[1].C)
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
