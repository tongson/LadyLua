local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local G = require("guard")
local expect = T.expect
--# = guard
--# :toc:
--# :toc-placement!:
--#
--# Elixir-style guards. One way to avoid nested conditionals.
--#
--# toc::[]
--#
--# == *guard*() -> _Table_
--# Returns new guard factory.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Guardian table
--# |===
local guard = function()
	T.is_table(G)
	local tbl = G()
	T.is_table(tbl)
end
--#
--# == *.any*(_function_)
--# Fallthrough for a guard chain.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |type |description
--# |function |Default case function
--# |===
local any = function()
	local tbl = G()
	local f = function()
		return "default"
	end
	local f2 = function()
		return "new_any"
	end
	local g = tbl.any(f)
	expect("default")(g())
	g.any(f2)
	expect("new_any")(g())
end
--#
--# == *.when*(_function_, _function_)
--# Expects two functions arguments: the first one being a filter function, and the second one being a function to be evaluated. the filter function should return a boolean. if it returns `true`, the second function argument is evaluated and the guard returns itself right after.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |type |description
--# |function |filter
--# |function |main function
--# |===
local when = function()
	local tbl = G()
	T.is_function(tbl.when)
	local x = tbl.when(function()
	end, function()
	end)
	T.is_table(x)
	T.is_nil(x())
	local is_odd = function(n)
		return n % 2 ~= 0
	end
	local double = function(n)
		return n * 2
	end
	local g = G().when(is_odd, double)
	expect(6)(g(3))
	T.is_nil(g(2))
	g.any(function()
		return "default case"
	end)
	expect("default case")(g(2))
end
local chain = function()
	local g = G()
	local truthy = function()
		return true
	end
	local falsy = function()
		return false
	end
	local f_one = function()
		return 1
	end
	local f_two = function()
		return 2
	end
	local f_three = function()
		return 3
	end
	local f_four = function()
		return 4
	end
	g.when(falsy, f_one).when(truthy, f_two).when(f_three).when(f_four)
	local h = G().when(falsy, f_one).when(falsy, f_two).when(falsy, f_three)
	expect(2)(g())
	T.not_equal(1, g()) --falsy
	T.not_equal(3, g()) --falsy
	T.not_equal(4, g()) --FIFO
	T.is_nil(h())
	h.any(f_four)
	expect(4)(h())
end
if included then
	return function()
		T["guard"] = guard
		T["any"] = any
		T["when"] = when
		T["chain"] = chain
	end
else
	T["guard"] = guard
	T["any"] = any
	T["when"] = when
	T["chain"] = chain
end
