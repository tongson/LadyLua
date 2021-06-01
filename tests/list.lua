local included = pcall(debug.getlocal, 4, 1)
local list = require("list")
local T = require("test")
local expect = T.expect
local func = T.is_function
local tbl = T.is_table
local trve = T.is_true
local nope = T.is_false
--# = list
--# :toc:
--# :toc-placement!:
--#
--# Doubly linked list data structures. Stores one instance of a value. Push tables for more leeway.
--#
--# toc::[]
--#
--# == *list.new*() -> _Table_
--# Create a new list.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |List
--# |===
--#
local new = function()
	func(list.new)
	local l = list.new()
	tbl(l)
end
--#
--# == *:pushf*(_Value_)
--# Push to beginning of list.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pushf_string = function()
	local l = list.new()
	func(l.pushf)
	l:pushf("1")
	l:pushf("2")
	local x = l:popl()
	expect("1")(x)
end
local pushf_number = function()
	local l = list.new()
	l:pushf(1)
	l:pushf(2)
	local x = l:popl()
	expect(1)(x)
end
local pushf_boolean = function()
	local l = list.new()
	l:pushf(false)
	l:pushf(true)
	local x = l:popl()
	expect(false)(x)
end
local pushf_table = function()
	local l = list.new()
	local one = {
		one = 1,
	}
	local two = {
		two = 2,
	}
	l:pushf(one)
	l:pushf(two)
	local x = l:popl()
	tbl(x)
	expect(1)(x.one)
end
--#
--# == *:pushl*(_Value_)
--# Push to end of list.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pushl_string = function()
	local l = list.new()
	func(l.pushl)
	l:pushl("1")
	l:pushl("2")
	local x = l:popl()
	expect("2")(x)
end
local pushl_number = function()
	local l = list.new()
	l:pushl(1)
	l:pushl(2)
	local x = l:popl()
	expect(2)(x)
end
local pushl_boolean = function()
	local l = list.new()
	l:pushl(false)
	l:pushl(true)
	local x = l:popl()
	expect(true)(x)
end
local pushl_table = function()
	local l = list.new()
	local one = {
		one = 1,
	}
	local two = {
		two = 2,
	}
	l:pushl(one)
	l:pushl(two)
	local x = l:popl()
	tbl(x)
	expect(2)(x.two)
end
--#
--# == *:popf*() -> _Value_
--# Pop value from beginning of list.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local popf = function()
	local l = list.new()
	func(l.popf)
	l:pushl("1")
	l:pushl("2")
	local x = l:popf()
	expect("1")(x)
end
--#
--# == *:popl*() -> _Value_
--# Pop value from end of list.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local popl = function()
	local l = list.new()
	func(l.popl)
	l:pushl("1")
	l:pushl("2")
	local x = l:popl()
	expect("2")(x)
end
--#
--# == *:contains*() -> _Boolean_
--# Check if list contains an instance of number, string, or boolean
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if value is found, `false` otherwise
--# |===
local contains = function()
	local l = list.new()
	func(l.contains)
	l:pushl("1")
	l:pushl(2)
	l:pushl(false)
	trve(l:contains("1"))
	trve(l:contains(2))
	trve(l:contains(false))
	nope(l:contains())
	nope(l:contains(5))
end
--#
--# == *:count*() -> _Number_
--# Count items in list.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Count
--# |===
local count = function()
	local l = list.new()
	func(l.count)
	l:pushl("1")
	l:pushl(2)
	l:pushl(false)
	expect(3)(l:count())
	l:popl()
	expect(2)(l:count())
end
--#
--# == *:first*() -> _Value_
--# Return first value in the list. Does not pop() the value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Value
--# |===
local first= function()
	local l = list.new()
	func(l.count)
	l:pushl("1")
	l:pushl(2)
	l:pushl(false)
	expect("1")(l:first())
	expect(3)(l:count())
end
--#
--# == *:last*() -> _Value_
--# Return last value in the list. Does not pop() the value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Value
--# |===
local last = function()
	local l = list.new()
	func(l.count)
	l:pushl("1")
	l:pushl(2)
	expect(2)(l:last())
	expect(2)(l:count())
end
--#
--# == *:walk*([_Boolean_]) -> _Iterator_
--# Iterate over list.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |if `false`, does a reverse iteration
--# |===
local walk = function()
	local l = list.new()
	func(l.walk)
	l:pushl("1")
	l:pushl(2)
	l:pushl(false)
	for x, y in l:walk() do
		if x == 1 then
			expect("1")(y)
		end
		if x == 2 then
			expect(2)(y)
		end
		if x == 3 then
			nope(y)
		end
	end
	local n = 4
	for x, y in l:walk(false) do
		n = n - 1
		expect(n)(x)
	end
end
--#
--# == *:range*(_Number_, _Number_) -> _Table_
--# Return a table for ranged iteration.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Index start
--# |number |Index end
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Table with values
--# |===
local range = function()
	local l = list.new()
	func(l.range)
	l:pushl("1")
	l:pushl(2)
	l:pushl(false)
	l:pushl({})
	for x, y in ipairs(l:range(2, 3)) do
		if x == 1 then
			expect(2)(y)
		end
		if x == 2 then
			nope(y)
		end
	end
	for x, y in ipairs(l:range(4,3)) do
		if x == 1 then
			tbl(y)
		end
		if x == 2 then
			nope(y)
		end
	end
end
if included then
	return function()
		T["new"] = new
		T["pushf_string"] = pushf_string
		T["pushf_number"] = pushf_number
		T["pushf_boolean"] = pushf_boolean
		T["pushf_number"] = pushf_number
		T["pushl_string"] = pushl_string
		T["pushl_number"] = pushl_number
		T["pushl_boolean"] = pushl_boolean
		T["pushl_number"] = pushl_number
		T["popf"] = popf
		T["popl"] = popl
		T["contains"] = contains
		T["count"] = count
		T["first"] = first
		T["last"] = last
		T["walk"] = walk
		T["range"] = range
	end
else
	T["new"] = new
	T["pushf_string"] = pushf_string
	T["pushf_number"] = pushf_number
	T["pushf_boolean"] = pushf_boolean
	T["pushf_number"] = pushf_number
	T["pushl_string"] = pushl_string
	T["pushl_number"] = pushl_number
	T["pushl_boolean"] = pushl_boolean
	T["pushl_number"] = pushl_number
	T["popf"] = popf
	T["popl"] = popl
	T["contains"] = contains
	T["count"] = count
	T["first"] = first
	T["last"] = last
	T["walk"] = walk
	T["range"] = range
	local lst = list.new()
	local round = 0
	local push_mean = 0
	local pop_mean = 0
	local round = round + 1
	io.write("-- performance, round:" .. round)
	io.write("\n")
	max_count = 1000 * 1000 * 10
	o = os.clock()
	for i = 50, max_count + 50, 1 do
		lst:pushf(i)
	end
	t = os.clock() - o
	push_mean = push_mean + t
	print("push " .. max_count .. " cost " .. t)
	o = os.clock()
	while lst:count() > 0 do
		lst:popl()
	end
	t = os.clock() - o
	pop_mean = pop_mean + t
	print("pop  " .. max_count .. " cost " .. t)
end
