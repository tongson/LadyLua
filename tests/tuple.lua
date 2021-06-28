local included = pcall(debug.getlocal, 4, 1)
local tuple = require("tuple")
local T = require("test")
local expect = T.expect
local func = T.is_function
local tbl = T.is_table
local bool = T.is_boolean
local num = T.is_number
local error_raised = T.error_raised
local not_eq = T.not_equal
--# = tuple
--# :toc:
--# :toc-placement!:
--#
--# Implementation of ordered n-tuples.
--#
--# Tuples are fixed sized and may contain `nil`. Values can be changed for existing keys. Tables passed are copied.
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
	local x = tuple(1, nil, 2)
	expect(3)(x:size())
end
local table_test = function()
	local o = { 1 }
	local t = tuple(o)
	local x = t[1]
	expect(1)(x[1])
	t[1][1] = 0
	local y = t[1]
	expect(0)(y[1])
	expect(1)(o[1]) -- immutable because table was cloned.
end
local metatable = function()
	local list = require("list")
	local l = list.new()
	local one = {
		one = 1,
	}
	local two = {
		two = 2,
	}
	l:push(one)
	l:push(two)
	local tup = tuple(l)
	local t = tup[1]
	local x = t:pop()
	tbl(x)
	expect(2)(x.two)
	local a = tostring(l)
	local b = tostring(t)
	not_eq(a, b)
end
local printing = function()
	local tup = tuple("a", true, 1)
	expect("(a, true, 1)")(tostring(tup))
end
local printing_nil = function()
	local nup = tuple(1, nil, 2)
	expect("(1, nil, 2)")(tostring(nup))
end
local slicing = function()
	local f = { 1 }
	local tup = tuple("a", "b", "c", "d", "e", f)
	local new_tup = tup(2, 4)
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
local slicing_nil = function()
	local nup = tuple(2, nil, 3)
	local nnup = nup(2)
	expect(nil)(nnup[1])
	expect(3)(nnup[2])
	local xup = tuple(2, nil, 3)
	local xxup = xup(1, 2)
	expect(2)(xxup[1])
	expect(nil)(xxup[2])
end
--#
--# == *:iterator()*
--# Iterator function to traverse a tuple. Returns a count and a value at each step of iteration, until the end of the tuple is reached.
--#
--# Use this instead of `ipairs` since the tuple may contain `nil`.
local iterator = function()
	local tup = tuple(1, nil, 2, {}, "z")
	local t = {}
	for i, element in tup:iterator() do
		t[i] = element
	end
	expect(1)(t[1])
	expect(nil)(t[2])
	expect(2)(t[3])
	tbl(t[4])
	expect("z")(t[5])
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
	local tup = tuple("a", "b", "c")
	expect(true)(tup:includes(tuple("a")))
	expect(true)(tup:includes(tuple("a", "b")))
	expect(true)(tup:includes(tuple("a", "b", "c")))
	expect(false)(tup:includes(tuple("d")))
end
local includes_nil = function()
	local tup = tuple(1, nil, 3)
	expect(true)(tup:includes(tuple(nil)))
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
	local tup = tuple(0, false, "3")
	expect(false)(tup:has(true))
	expect(true)(tup:has("3"))
end
local has_nil = function()
	local tup = tuple(0, nil, 1)
	expect(true)(tup:has(nil))
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
	local tup = tuple(0, false, "3")
	expect(3)(tup:size())
	expect(3)(#tup)
end
--#
--# == *:contents(_Table_)* -> _Table_
--# Converts the tuple contents to a read-only array.
--#
--# [NOTE]
--# ====
--# Lower level tables can be modified.
--# ====
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
	local tup = tuple(0, false, "3", o)
	local arr = tup:contents()
	expect(0)(arr[1])
	expect(false)(arr[2])
	expect("3")(arr[3])
	expect(1)(arr[4][1])
	arr[4][1] = 0
	expect(0)(arr[4][1])
	expect(1)(tup[4][1])
	expect(1)(o[1])
	-- Test read-only effect
	local fn = function()
		arr[4] = nil
	end
	error_raised(fn)
end
local array_nil = function()
	local tup = tuple(0, nil, 1)
	local arr = tup:contents()
	expect(0)(arr[1])
	expect(nil)(arr[2])
	expect(1)(arr[3])
end
local addition = function()
	local x = tuple(1) + tuple(2)
	expect(1)(x[1])
	expect(2)(x[2])
	local y = tuple(3, 4) + tuple("a", false)
	expect(3)(y[1])
	expect(4)(y[2])
	expect("a")(y[3])
	expect(false)(y[4])
end
local addition_nil = function()
	local x = tuple(1, nil) + tuple(nil, 2)
	expect(1)(x[1])
	expect(nil)(x[2])
	expect(nil)(x[3])
	expect(2)(x[4])
end
local comparison = function()
	local tupA = tuple(1, true)
	local tupB = tuple(1, true)
	expect(true)(tupA == tupB)
	local tupC = tuple(1, false)
	expect(false)(tupA == tupC)
	expect(true)(tupA ~= tupC)
	expect(true)(not (tupA == tupC))
	local tupD = tuple(1, 2, 3)
	local tupE = tuple(1, 2)
	expect(true)(tupA == tupB)
end
local comparison_nil = function()
	local tupA = tuple(1, nil)
	local tupB = tuple(1, nil)
	expect(true)(tupA == tupB)
	local tupC = tuple(1)
	local tupD = tuple(1, nil)
	expect(false)(tupC == tupD)
end
local multiplication = function()
	local t1 = tuple("a", "z") * 2
	expect("a")(t1[1])
	expect("z")(t1[2])
	expect("a")(t1[3])
	expect("z")(t1[4])
	local t2 = tuple(1) * 3
	expect(1)(t2[1])
	expect(1)(t2[2])
	expect(1)(t2[3])
	local t3 = 2 * tuple(2)
	expect(2)(t3[1])
	expect(2)(t3[2])
	local t4 = tuple() * 0
	expect(nil)(t4)
end
local less_than = function()
	local tupA = tuple(1, 2)
	local tupB = tuple(2, 3)
	expect(true)(tupA < tupB)
	expect(false)(tupB < tupA)
	expect(true)(tupB > tupA)
	expect(false)(tupA > tupB)
end
local lte = function()
	do
		local tupA = tuple(1, 2)
		local tupB = tuple(1, 3)
		expect(true)(tupA <= tupB)
		expect(false)(tupB <= tupA)
	end
	do
		local tupA = tuple(1, 2, 3)
		local tupB = tuple(2, 2)
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
local iterate = function()
	local tup = tuple(1, 2)
	local t = {}
	for x, y in ipairs(tup) do
		t[x] = y
	end
	expect(1)(t[1])
	expect(2)(t[2])
	local p = {}
	for x, y in pairs(tup) do
		p[x] = y
	end
	expect(1)(p[1])
	expect(2)(p[2])
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
		T["metatable"] = metatable
		T["__tostring"] = printing
		T["__tostring nil"] = printing_nil
		T["Slicing"] = slicing
		T["Slicing with nil"] = slicing_nil
		T[":iterator()"] = iterator
		T[":includes()"] = includes
		T[":includes nil"] = includes_nil
		T[":has()"] = has
		T[":has(nil)"] = has_nil
		T[":size()"] = size
		T[":contents()"] = array
		T[":contents with nil"] = array_nil
		T["Addition"] = addition
		T["Addition with nil"] = addition_nil
		T["Comparison"] = comparison
		T["Comparison with nil"] = comparison_nil
		T["Multiplication"] = multiplication
		T["<"] = less_than
		T["<="] = lte
		T["mutate"] = mutate
		T["iterate"] = iterate
		T["newindex"] = newindex
	end
else
	T["Valid types"] = types
	T["Tables passed"] = table_test
	T["metatable"] = metatable
	T["__tostring"] = printing
	T["__tostring nil"] = printing_nil
	T["Slicing"] = slicing
	T["Slicing with nil"] = slicing_nil
	T[":iterator()"] = iterator
	T[":includes()"] = includes
	T[":includes nil"] = includes_nil
	T[":has()"] = has
	T[":has(nil)"] = has_nil
	T[":size()"] = size
	T[":contents()"] = array
	T[":contents with nil"] = array_nil
	T["Addition"] = addition
	T["Addition with nil"] = addition_nil
	T["Comparison"] = comparison
	T["Comparison with nil"] = comparison_nil
	T["Multiplication"] = multiplication
	T["<"] = less_than
	T["<="] = lte
	T["mutate"] = mutate
	T["iterate"] = iterate
	T["newindex"] = newindex
end
