local included = pcall(debug.getlocal, 4, 1)
local tuple = require("tuple")
local T = require("test")
local expect = T.expect
local func = T.is_function
local tbl = T.is_table
local bool = T.is_boolean
local num = T.is_number
local error_raised = T.error_raised
--# = tuple
--# :toc:
--# :toc-placement!:
--#
--# Implementation of ordered n-tuples.
--#
--# toc::[]
--#
--# == *tuple([...])* -> _Table_
--# Create a new tuple.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Tuple
--# |===
local types = function()
	local f = tuple(function() end)
	func(f[1])
	local t = tuple({})
	tbl(t[1])
	local b = tuple(false)
	bool(b[1])
	local n = tuple(1)
	num(n[1])
	local z = tuple()
	expect(nil)(z[1])
end
local table_test = function()
	local o = {1}
	local t = tuple(o)
	local x = t[1]
	expect(1)(x[1])
	t[1][1] = 0
	local y = t[1]
	expect(0)(y[1])
	expect(1)(o[1]) -- immutable because table was cloned.
end
local printing = function()
	local tup = tuple('a', true, 1)
	expect("(a, true, 1)")(tostring(tup))
end
local slicing = function()
	local f = {1}
	local tup = tuple('a', 'b', 'c', 'd', 'e', f)
	local new_tup = tup(2,4)
	expect("b")(new_tup[1])
	expect("c")(new_tup[2])
	expect("d")(new_tup[3])
	local xtup = tup(5)
	expect("e")(xtup[1])
	local t = xtup[2]
	expect(1)(t[1])
	xtup[2][1] = 0
	expect(0)(t[1])
	expect(1)(f[1])
end
--#
--# == *:elements()*
--# Iterator function to traverse a tuple. Returns a count and a value at each step of iteration, until nil value is encountered or the end of the tuple was reached.
local elements = function()
	local tup = tuple(1, 2, {}, "z")
	local t = {}
	for i, element in tup:elements() do
		t[#t+1] = element
	end
	expect(1)(t[1])
	expect(2)(t[2])
	tbl(t[3])
	expect("z")(t[4])
end
--#
--# == *:includes(_Table_)* -> _Boolean_
--# Returns `true` if the tuple argument is included in the tuple, i.e when all elements found in tuple argument were found in the original tuple. Otherwise, returns `false`.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Tuple
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |Result
--# |===
local includes = function()
	local tup = tuple('a', 'b', 'c')
	expect(true)(tup:includes(tuple('a')))
	expect(true)(tup:includes(tuple('a', 'b')))
	expect(true)(tup:includes(tuple('a', 'b', 'c')))
	expect(false)(tup:includes(tuple('d')))
end
--#
--# == *:has(_Table_)* -> _Boolean_
--# Returns `true` when the given value was found in the tuple. Otherwhise, returns `false`.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Any valid value for comparison
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |Result
--# |===
local has = function()
	local tup = tuple(0, false, '3')
	expect(false)(tup:has(true))
	expect(true)(tup:has('3'))
end
--#
--# == *:size(_Table_)* -> _Number_
--# Returns the size (the count of values) of the tuple.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Size of tuple
--# |===
local size = function()
	local tup = tuple(0, false, '3')
	expect(3)(tup:size())
	expect(3)(#tup)
end
--#
--# == *:contents(_Table_)* -> _Table_
--# Converts the tuple contents to a simple array.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Tuple
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |New table
--# |===
local array = function()
	local o = { 1 }
	local tup = tuple(0, false, '3', o)
	local arr = tup:contents()
	expect(0)(arr[1])
	expect(false)(arr[2])
	expect("3")(arr[3])
	expect(1)(arr[4][1])
	arr[4][1] = 0
	expect(0)(arr[4][1])
	expect(1)(tup[4][1])
	expect(1)(o[1])
end
local comparison = function()
	local tupA = tuple(1, true)
	local tupB = tuple(1, true)
	expect(true)(tupA == tupB)
	local tupC = tuple(1, false)
	expect(false)(tupA == tupC)
	expect(true)(tupA ~= tupC)
	expect(true)(not(tupA == tupC))
	local tupD = tuple(1, 2, 3)
	local tupE = tuple(1, 2)
	expect(true)(tupA == tupB)
end
local less_than = function()
	local tupA = tuple(1,2)
	local tupB = tuple(2,3)
	expect(true)(tupA < tupB)
	expect(false)(tupB < tupA)
	expect(true)(tupB > tupA)
	expect(false)(tupA > tupB)
end
local lte = function()
	do
		local tupA = tuple(1,2)
		local tupB = tuple(1,3)
		expect(true)(tupA <= tupB)
		expect(false)(tupB <= tupA)
	end
	do
		local tupA = tuple(1,2,3)
		local tupB = tuple(2,2)
		expect(true)(tupA <= tupB)
		expect(false)(tupB <= tupA)
	end
end
local mutate = function()
	local tup = tuple(1, 2)
	tup[1] = 2
	expect(2)(tup[1])
	expect(2)(tup[2])
end
local newindex = function()
	local tup = tuple(1, 2)
	local fn = function()
		tup[3] = 3
	end
	error_raised(fn)
end
if included then
	return function()
		T["Valid types"] = types
		T["Tables passed"] = table_test
		T["__tostring"] = printing
		T["Slicing"] = slicing
		T[":elements()"] = elements
		T[":includes()"] = includes
		T[":has()"] = has
		T[":size()"] = size
		T[":contents()"] = array
		T["Addition"] = addition
		T["Comparison"] = comparison
		T["Multiplication"] = multiplication
		T["<"] = less_than
		T["<="] = lte
		T["mutate"] = mutate
		T["newindex"] = newindex
	end
else
	T["Valid types"] = types
	T["Tables passed"] = table_test
	T["__tostring"] = printing
	T["Slicing"] = slicing
	T[":elements()"] = elements
	T[":includes()"] = includes
	T[":has()"] = has
	T[":size()"] = size
	T[":contents()"] = array
	T["Addition"] = addition
	T["Comparison"] = comparison
	T["Multiplication"] = multiplication
	T["<"] = less_than
	T["<="] = lte
	T["mutate"] = mutate
	T["newindex"] = newindex
end
