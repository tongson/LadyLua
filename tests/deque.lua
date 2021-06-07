local included = pcall(debug.getlocal, 4, 1)
local deque = require("deque")
local T = require("test")
local expect = T.expect
local func = T.is_function
local tbl = T.is_table
local trve = T.is_true
local nope = T.is_false
--# = deque
--# :toc:
--# :toc-placement!:
--#
--# Double-ended queue implementation.
--#
--# toc::[]
--#
--# == *deque.new*() -> _Table_
--# Create a new queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Queue
--# |===
--#
local new = function()
	func(deque.new)
	local q = deque.new()
	tbl(q)
end
--#
--# == *:push_left*(_Value_)
--# Push to beginning of queue.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
--#
--# == *:length*() -> _Number_
--# Count items in queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Count
--# |===
--#
--# == *:contents*() -> _Table_
--# Array representation of queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Array
--# |===
local push_left = function()
	local q = deque.new()
	func(q.push_left)
	q:push_left("3")
	q:push_left("2")
	q:push_left("1")
	q:push_left("2")
	expect(4)(q:length())
	local t = q:contents()
	expect("2")(t[1])
	expect("1")(t[2])
	expect("2")(t[3])
	expect("3")(t[4])
end
--#
--# == *:push_right*(_Value_)
--# Push to end of queue.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local push_right = function()
	local q = deque.new()
	func(q.push_right)
	q:push_right(true)
	q:push_right(false)
	q:push_right(true)
	q:push_right(false)
	expect(4)(q:length())
	local t = q:contents()
	expect(true)(t[1])
	expect(false)(t[2])
	expect(true)(t[3])
	expect(false)(t[4])
end
--#
--# == *:pop_left*() -> _Value_
--# Pop value from beginning of queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pop_left = function()
	local q = deque.new()
	func(q.pop_left)
	q:push_right({ "1" })
	q:push_right({ "2" })
	q:push_right({ "3" })
	q:push_right({ "4" })
	expect(4)(q:length())
	local t1 = q:pop_left()
	expect("1")(t1[1])
	local t2 = q:pop_left()
	expect("2")(t2[1])
	local t3 = q:pop_left()
	expect("3")(t3[1])
	local t4 = q:pop_left()
	expect("4")(t4[1])
	expect(0)(q:length())
end
--#
--# == *:pop_right*() -> _Value_
--# Pop value from end of queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pop_right = function()
	local q = deque.new()
	func(q.pop_right)
	q:push_right(1)
	q:push_right(2)
	q:push_right(3)
	q:push_right(4)
	expect(4)(q:length())
	expect(4)(q:pop_right())
	expect(3)(q:pop_right())
	expect(2)(q:pop_right())
	expect(1)(q:pop_right())
	expect(0)(q:length())
end
--#
--# == *:peek_left*() -> _Value_
--# Return first value in the queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local peek_left = function()
	local q = deque.new()
	func(q.peek_left)
	q:push_right({ "1" })
	q:push_right({ "2" })
	q:push_right({ "3" })
	q:push_right({ "4" })
	expect(4)(q:length())
	local t1 = q:peek_left()
	expect("1")(t1[1])
	expect(4)(q:length())
end
--#
--# == *:peek_right*() -> _Value_
--# Return last value in queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local peek_right = function()
	local q = deque.new()
	func(q.peek_right)
	q:push_right(1)
	q:push_right(2)
	q:push_right(3)
	q:push_right(4)
	expect(4)(q:length())
	expect(4)(q:peek_right())
	expect(4)(q:length())
end
--#
--# == *:remove_left*(_Value_) -> _Boolean_
--# Remove first matching value from beginning of queue.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Value to remove
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if removed, `false` otherwise
--# |===
local remove_left = function()
	local q = deque.new()
	func(q.remove_left)
	q:push_right(1)
	q:push_right(2)
	q:push_right(2)
	q:push_right(4)
	q:push_right(2)
	expect(5)(q:length())
	local b = q:remove_left(2)
	expect(true)(b)
	expect(4)(q:length())
	local t = q:contents()
	expect(1)(t[1])
	expect(2)(t[2])
	expect(4)(t[3])
	expect(2)(t[4])
end
--#
--# == *:remove_right*(_Value_) -> _Boolean_
--# Remove first matching value from end of queue.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |Value to remove
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if removed, `false` otherwise
--# |===
local remove_right = function()
	local q = deque.new()
	func(q.remove_right)
	q:push_right(1)
	q:push_right(2)
	q:push_right(2)
	q:push_right(4)
	q:push_right(2)
	expect(5)(q:length())
	local b = q:remove_right(2)
	expect(true)(b)
	expect(4)(q:length())
	local t = q:contents()
	expect(1)(t[1])
	expect(2)(t[2])
	expect(2)(t[3])
	expect(4)(t[4])
end
--#
--# == *:is_empty*() -> _Boolean_
--# Check if queue has length of 0.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if empty, `false` otherwise
--# |===
local is_empty = function()
	local q = deque.new()
	func(q.is_empty)
	expect(true)(q:is_empty())
	q:push_right("x")
	expect(false)(q:is_empty())
end
--#
--# == *:iter_left*()
--# Iterate from start of queue.
local iter_left = function()
	local q = deque.new()
	func(q.iter_left)
	q:push_right(1)
	q:push_right(true)
	q:push_right({})
	local t = {}
	for x in q:iter_left() do
		t[#t+1] = x
	end
	expect(1)(t[1])
	expect(true)(t[2])
	tbl(t[3])
end
--#
--# == *:iter_right*()
--# Iterate from end of queue.
local iter_right = function()
	local q = deque.new()
	func(q.iter_right)
	q:push_right(1)
	q:push_right(true)
	q:push_right({})
	local t = {}
	for x in q:iter_right() do
		t[#t+1] = x
	end
	tbl(t[1])
	expect(true)(t[2])
	expect(1)(t[3])
end
--#
--# == *:rotate_left*([_Number_])
--# Rotate queue from beginning. Argument is number of steps to rotate, defaults to 1.
--#
--# === Example
--# [options="header",width="72%"]
--# |===
--# |Step|v1|v2|v3
--# |Initial|4|2|3
--# |1|2|3|4
--# |2|3|4|2
--# |3|4|2|3
--# |4|2|3|4
--# |===
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Rotation steps
--# |===
local rotate_left = function()
	local q = deque.new()
	func(q.rotate_left)
	q:push_right(4)
	q:push_right(2)
	q:push_right(3)
	q:rotate_left()
	local t = q:contents()
	expect(2)(t[1])
	expect(3)(t[2])
	expect(4)(t[3])
	q:rotate_left(3)
	local y = q:contents()
	expect(2)(y[1])
	expect(3)(y[2])
	expect(4)(y[3])
end
--#
--# == *:rotate_right*([_Number_])
--# Rotate queue from end. Argument is number of steps to rotate, defaults to 1.
--#
--# === Example
--# [options="header",width="72%"]
--# |===
--# |Step|v1|v2|v3
--# |Initial|2|3|3
--# |1|4|2|3
--# |2|3|4|2
--# |===
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Rotation steps
--# |===
local rotate_right = function()
	local q = deque.new()
	func(q.rotate_right)
	q:push_right(2)
	q:push_right(3)
	q:push_right(4)
	q:rotate_right()
	local t = q:contents()
	expect(4)(t[1])
	expect(2)(t[2])
	expect(3)(t[3])
	q:rotate_right(1)
	local y = q:contents()
	expect(3)(y[1])
	expect(4)(y[2])
	expect(2)(y[3])
end
if included then
	return function()
		T["push_left"] = push_left
		T["push_right"] = push_right
		T["pop_left"] = pop_left
		T["pop_right"] = pop_right
		T["peek_left"] = peek_left
		T["peek_right"] = peek_right
		T["remove_left"] = remove_left
		T["remove_right"] = remove_right
		T["is_empty"] = is_empty
		T["iter_left"] = iter_left
		T["iter_right"] = iter_right
		T["rotate_left"] = rotate_left
		T["rotate_right"] = rotate_right
	end
else
	T["push_left"] = push_left
	T["push_right"] = push_right
	T["pop_left"] = pop_left
	T["pop_right"] = pop_right
	T["peek_left"] = peek_left
	T["peek_right"] = peek_right
	T["remove_left"] = remove_left
	T["remove_right"] = remove_right
	T["is_empty"] = is_empty
	T["iter_left"] = iter_left
	T["iter_right"] = iter_right
	T["rotate_left"] = rotate_left
	T["rotate_right"] = rotate_right
	local queue = deque.new()
	local round = 0
	local push_mean = 0
	local pop_mean = 0
	local round = round + 1
	io.write("-- performance, round:" .. round)
	io.write("\n")
	max_count = 1000 * 1000 * 10
	o = os.clock()
	for i = 50, max_count + 50, 1 do
		queue:push_left(i)
	end
	t = os.clock() - o
	push_mean = push_mean + t
	print("push " .. max_count .. " cost " .. t)
	o = os.clock()
	while queue:length() > 0 do
		queue:remove_right()
	end
	t = os.clock() - o
	pop_mean = pop_mean + t
	print("pop  " .. max_count .. " cost " .. t)
end
