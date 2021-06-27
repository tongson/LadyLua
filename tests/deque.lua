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
--# == *:push_front*(_Value_)
--# Push to beginning of queue.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
--#
--# == *:size*() -> _Number_
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
local push_front = function()
	local q = deque.new()
	func(q.push_front)
	q:push_front("3")
	q:push_front("2")
	q:push_front("1")
	q:push_front("2")
	expect(4)(q:size())
	local t = q:contents()
	expect("2")(t[1])
	expect("1")(t[2])
	expect("2")(t[3])
	expect("3")(t[4])
end
--#
--# == *:push_back*(_Value_)
--# Push to end of queue.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local push_back = function()
	local q = deque.new()
	func(q.push_back)
	q:push_back(true)
	q:push_back(false)
	q:push(true)
	q:push_back(false)
	expect(4)(q:size())
	local t = q:contents()
	expect(true)(t[1])
	expect(false)(t[2])
	expect(true)(t[3])
	expect(false)(t[4])
end
--#
--# == *:pop_front*() -> _Value_
--# Pop value from beginning of queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pop_front = function()
	local q = deque.new()
	func(q.pop_front)
	q:push_back({ "1" })
	q:push_back({ "2" })
	q:push_back({ "3" })
	q:push_back({ "4" })
	expect(4)(q:size())
	local t1 = q:pop_front()
	expect("1")(t1[1])
	local t2 = q:pop_front()
	expect("2")(t2[1])
	local t3 = q:pop_front()
	expect("3")(t3[1])
	local t4 = q:pop_front()
	expect("4")(t4[1])
	expect(0)(q:size())
end
--#
--# == *:pop_back*() -> _Value_
--# Pop value from end of queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local pop_back = function()
	local q = deque.new()
	func(q.pop_back)
	q:push_back(1)
	q:push_back(2)
	q:push_back(3)
	q:push_back(4)
	expect(4)(q:size())
	expect(4)(q:pop_back())
	expect(3)(q:pop())
	expect(2)(q:pop_back())
	expect(1)(q:pop_back())
	expect(0)(q:size())
end
--#
--# == *:peek_front*() -> _Value_
--# Return first value in the queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local peek_front = function()
	local q = deque.new()
	func(q.peek_front)
	q:push_back({ "1" })
	q:push_back({ "2" })
	q:push_back({ "3" })
	q:push_back({ "4" })
	expect(4)(q:size())
	local t1 = q:peek_front()
	expect("1")(t1[1])
	expect(4)(q:size())
end
--#
--# == *:peek_back*() -> _Value_
--# Return last value in queue.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |value |String, Boolean, Number, or Table
--# |===
local peek_back = function()
	local q = deque.new()
	func(q.peek_back)
	q:push_back(1)
	q:push_back(2)
	q:push_back(3)
	q:push_back(4)
	expect(4)(q:size())
	expect(4)(q:peek_back())
	expect(4)(q:size())
end
--#
--# == *:remove_front*(_Value_) -> _Boolean_
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
local remove_front = function()
	local q = deque.new()
	func(q.remove_front)
	q:push_back(1)
	q:push_back(2)
	q:push_back(2)
	q:push_back(4)
	q:push_back(2)
	expect(5)(q:size())
	local b = q:remove_front(2)
	expect(true)(b)
	expect(4)(q:size())
	local t = q:contents()
	expect(1)(t[1])
	expect(2)(t[2])
	expect(4)(t[3])
	expect(2)(t[4])
end
--#
--# == *:remove_back*(_Value_) -> _Boolean_
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
local remove_back = function()
	local q = deque.new()
	func(q.remove_back)
	q:push_back(1)
	q:push_back(2)
	q:push_back(2)
	q:push_back(4)
	q:push_back(2)
	expect(5)(q:size())
	local b = q:remove_back(2)
	expect(true)(b)
	expect(4)(q:size())
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
	q:push_back("x")
	expect(false)(q:is_empty())
end
--#
--# == *:iter_front*()
--# Iterate from start of queue.
local iter_front = function()
	local q = deque.new()
	func(q.iter_front)
	q:push_back(1)
	q:push_back(true)
	q:push_back({})
	local t = {}
	for x in q:iter_front() do
		t[#t+1] = x
	end
	expect(1)(t[1])
	expect(true)(t[2])
	tbl(t[3])
end
--#
--# == *:iter_back*()
--# Iterate from end of queue.
local iter_back = function()
	local q = deque.new()
	func(q.iter_back)
	q:push_back(1)
	q:push_back(true)
	q:push_back({})
	local t = {}
	for x in q:iter_back() do
		t[#t+1] = x
	end
	tbl(t[1])
	expect(true)(t[2])
	expect(1)(t[3])
end
--#
--# == *:rotate_front*([_Number_])
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
local rotate_front = function()
	local q = deque.new()
	func(q.rotate_front)
	q:push_back(4)
	q:push_back(2)
	q:push_back(3)
	q:rotate_front()
	local t = q:contents()
	expect(2)(t[1])
	expect(3)(t[2])
	expect(4)(t[3])
	q:rotate_front(3)
	local y = q:contents()
	expect(2)(y[1])
	expect(3)(y[2])
	expect(4)(y[3])
end
--#
--# == *:rotate_back*([_Number_])
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
local rotate_back = function()
	local q = deque.new()
	func(q.rotate_back)
	q:push_back(2)
	q:push_back(3)
	q:push_back(4)
	q:rotate_back()
	local t = q:contents()
	expect(4)(t[1])
	expect(2)(t[2])
	expect(3)(t[3])
	q:rotate_back(1)
	local y = q:contents()
	expect(3)(y[1])
	expect(4)(y[2])
	expect(2)(y[3])
end
if included then
	return function()
		T["push_front"] = push_front
		T["push_back"] = push_back
		T["pop_front"] = pop_front
		T["pop_back"] = pop_back
		T["peek_front"] = peek_front
		T["peek_back"] = peek_back
		T["remove_front"] = remove_front
		T["remove_back"] = remove_back
		T["is_empty"] = is_empty
		T["iter_front"] = iter_front
		T["iter_back"] = iter_back
		T["rotate_front"] = rotate_front
		T["rotate_back"] = rotate_back
	end
else
	T["push_front"] = push_front
	T["push_back"] = push_back
	T["pop_front"] = pop_front
	T["pop_back"] = pop_back
	T["peek_front"] = peek_front
	T["peek_back"] = peek_back
	T["remove_front"] = remove_front
	T["remove_back"] = remove_back
	T["is_empty"] = is_empty
	T["iter_front"] = iter_front
	T["iter_back"] = iter_back
	T["rotate_front"] = rotate_front
	T["rotate_back"] = rotate_back
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
		queue:push_front(i)
	end
	t = os.clock() - o
	push_mean = push_mean + t
	print("push " .. max_count .. " cost " .. t)
	o = os.clock()
	while queue:size() > 0 do
		queue:remove_back()
	end
	t = os.clock() - o
	pop_mean = pop_mean + t
	print("pop  " .. max_count .. " cost " .. t)
end
