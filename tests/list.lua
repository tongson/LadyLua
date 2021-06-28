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
--# == *:push_front*(_Value_)
--# Push to beginning of list.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local push_front_string = function()
	local l = list.new()
	func(l.push_front)
	l:push_front("1")
	l:push_front("2")
	local x = l:pop_back()
	expect("1")(x)
end
local push_front_number = function()
	local l = list.new()
	l:push_front(1)
	l:push_front(2)
	local x = l:pop_back()
	expect(1)(x)
end
local push_front_boolean = function()
	local l = list.new()
	l:push_front(false)
	l:push_front(true)
	local x = l:pop_back()
	expect(false)(x)
end
local push_front_table = function()
	local l = list.new()
	local one = {
		one = 1,
	}
	local two = {
		two = 2,
	}
	l:push_front(one)
	l:push_front(two)
	local x = l:pop_back()
	tbl(x)
	expect(1)(x.one)
end
--#
--# == *:push_back*(_Value_)
--# Push to end of list.
--# 
--# Alias: `:push`
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local push_back_string = function()
	local l = list.new()
	func(l.push_back)
	l:push_back("1")
	l:push_back("2")
	local x = l:pop_back()
	expect("2")(x)
end
local push_alias = function()
	local l = list.new()
	func(l.push)
	l:push("1")
	l:push("2")
	local x = l:pop_back()
	expect("2")(x)
end
local push_back_number = function()
	local l = list.new()
	l:push_back(1)
	l:push_back(2)
	local x = l:pop_back()
	expect(2)(x)
end
local push_back_boolean = function()
	local l = list.new()
	l:push_back(false)
	l:push_back(true)
	local x = l:pop_back()
	expect(true)(x)
end
local push_back_table = function()
	local l = list.new()
	local one = {
		one = 1,
	}
	local two = {
		two = 2,
	}
	l:push_back(one)
	l:push_back(two)
	local x = l:pop_back()
	tbl(x)
	expect(2)(x.two)
end
--#
--# == *:pop_front*() -> _Value_
--# Pop value from beginning of list.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pop_front = function()
	local l = list.new()
	func(l.pop_front)
	l:push_back("1")
	l:push_back("2")
	local x = l:pop_front()
	expect("1")(x)
end
--#
--# == *:pop_back*() -> _Value_
--# Pop value from end of list.
--#
--# Alias: `:pop`
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pop_back = function()
	local l = list.new()
	func(l.pop_back)
	l:push_back("1")
	l:push_back("2")
	local x = l:pop_back()
	expect("2")(x)
end
local pop_alias = function()
	local l = list.new()
	func(l.pop)
	l:push_back("1")
	l:push_back("2")
	local x = l:pop()
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
	l:push_back("1")
	l:push_back(2)
	l:push_back(false)
	trve(l:contains("1"))
	trve(l:contains(2))
	trve(l:contains(false))
	nope(l:contains())
	nope(l:contains(5))
end
--#
--# == *:size*() -> _Number_
--# Count items in list.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Count
--# |===
local size = function()
	local l = list.new()
	func(l.size)
	l:push_back("1")
	l:push_back(2)
	l:push_back(false)
	expect(3)(l:size())
	l:pop_back()
	expect(2)(l:size())
end
local dup = function()
	local l = list.new()
	l:push_front(3)
	l:push_front(3)
	l:push_back("a")
	l:push_front("a")
	expect(2)(l:size())
end
--#
--# == *:front*() -> _Value_
--# Return first value in the list. Does not pop() the value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Value
--# |===
local front = function()
	local l = list.new()
	func(l.size)
	l:push_back("1")
	l:push_back(2)
	l:push_back(false)
	expect("1")(l:front())
	expect(3)(l:size())
end
--#
--# == *:back*() -> _Value_
--# Return last value in the list. Does not pop() the value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Value
--# |===
local back back= function()
	local l = list.new()
	func(l.size)
	l:push_back("1")
	l:push_back(2)
	expect(2)(l:back())
	expect(2)(l:size())
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
	l:push_back("1")
	l:push_back(2)
	l:push_back(false)
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
	l:push_back("1")
	l:push_back(2)
	l:push_back(false)
	l:push_back({})
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
	do
		local s = list.new()
		s:push_back("a")
		s:push_back("b")
		s:push_back("c")
		expect("abc")(table.concat(s:range(1, s:size()), ""))
	end
end
if included then
	return function()
		T["new"] = new
		T["push_front_string"] = push_front_string
		T["push alias"] = push_alias
		T["push_front_number"] = push_front_number
		T["push_front_boolean"] = push_front_boolean
		T["push_front_number"] = push_front_number
		T["push front table"] = push_front_table
		T["push_back_string"] = push_back_string
		T["push_back_number"] = push_back_number
		T["push_back_boolean"] = push_back_boolean
		T["push_back_number"] = push_back_number
		T["push back table"] = push_back_table
		T["pop_front"] = pop_front
		T["pop_back"] = pop_back
		T["pop alias"] = pop_alias
		T["contains"] = contains
		T["size"] = count
		T["front"] = front
		T["back"] = back
		T["walk"] = walk
		T["range"] = range
		T["dup"] = dup
	end
else
	T["new"] = new
	T["push_front_string"] = push_front_string
	T["push alias"] = push_alias
	T["push_front_number"] = push_front_number
	T["push_front_boolean"] = push_front_boolean
	T["push_front_number"] = push_front_number
	T["push front table"] = push_front_table
	T["push_back_string"] = push_back_string
	T["push_back_number"] = push_back_number
	T["push_back_boolean"] = push_back_boolean
	T["push_back_number"] = push_back_number
	T["push back table"] = push_back_table
	T["pop_front"] = pop_front
	T["pop_back"] = pop_back
	T["pop alias"] = pop_alias
	T["contains"] = contains
	T["size"] = size
	T["front"] = front
	T["back"] = back
	T["walk"] = walk
	T["range"] = range
	T["dup"] = dup
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
		lst:push_front(i)
	end
	t = os.clock() - o
	push_mean = push_mean + t
	print("push " .. max_count .. " cost " .. t)
	o = os.clock()
	while lst:size() > 0 do
		lst:pop_back()
	end
	t = os.clock() - o
	pop_mean = pop_mean + t
	print("pop  " .. max_count .. " cost " .. t)
end
