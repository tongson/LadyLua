local included = pcall(debug.getlocal, 4, 1)
local graph = require("graph")
local G = graph.new()
local T = require("test")
local expect = T.expect

local one = function()
	G:add("a", "b")
	G:add("b", "c")
	G:add("0", "a")
	local t1 = G:sort()
	expect("0")(t1[1])
	expect("a")(t1[2])
	expect("b")(t1[3])
	expect("c")(t1[4])
end
local two = function()
	G:add("1", "2", "3", "a")
	local t2 = G:sort()
	expect("0")(t2[1])
	expect("1")(t2[2])
	expect("2")(t2[3])
	expect("3")(t2[4])
	expect("a")(t2[5])
	expect("b")(t2[6])
	expect("c")(t2[7])
end
local three = function()
	G:add({ "1", "1.5" })
	G:add({ "1.5", "a" })
	local t3 = G:sort()
	expect("0")(t3[1])
	expect("1")(t3[2])
	expect("2")(t3[3])
	expect("3")(t3[4])
	expect("1.5")(t3[5])
	expect("a")(t3[6])
	expect("b")(t3[7])
	expect("c")(t3[8])
end
local fail = function()
	G:add("first", "second")
	G:add("second", "third", "first")
	local sorted, err = G:sort()
	expect(nil)(sorted)
	expect("There is a circular dependency in the graph. It is not possible to derive a topological sort.")(err)
end
if included then
	return function()
		T["graph #1"] = one
		T["graph #2"] = two
		T["graph #3"] = three
		T["graph fail"] = fail
	end
else
	T["graph #1"] = one
	T["graph #2"] = two
	T["graph #3"] = three
	T["graph fail"] = fail
end
