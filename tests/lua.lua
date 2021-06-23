local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local expect = T.expect
local multiple_assignment = function()
	local x = function()
		return 0
	end
	local t = { 9 }
	local z = { z = 8 }
	local a, b, c, d, e = 1, t[1], x(), z.z, 4
	expect(1)(a)
	expect(9)(b)
	expect(0)(c)
	expect(8)(d)
	expect(4)(e)
end
local complex_multi_assign = function()
	local a = {}
	local d = "e"
	local f = 1
	f, a.d = f, d
	expect("e")(a.d)
	expect(false)(f == 1) -- bug
end
local map_overwrite = function()
	local t = {
		[1] = 1,
		"2"
	}
	expect(1)(#t)
end
if included then
	return function()
		T["simple multiple assignment"] = multiple_assignment
		T["complex multi assign #315"] = complex_multi_assign
		T["map vs list"] = map_overwrite
	end
else
	T["simple multiple assignment"] = multiple_assignment
	T["complex multi assign #315"] = complex_multi_assign
	T["map vs list"] = map_overwrite
end
