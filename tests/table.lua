local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
require("xtable")()
local expect = T.expect
--# = table
--# :toc:
--# :toc-placement!:
--#
--# Functions added to the global `table` namespace.
--#
--# toc::[]
--#
--# === *table.unique*(_Table_, _Any_) -> _Table_
--# Remove duplicate values(argument #2) from table(argument #1).
--#
--# Returns a new table(list). The keys from a map are discarded.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table |Table
--# |any |Any value except tables
--# |===
local table_unique = function()
	T.is_function(table.unique)
	local t = {
		"found",
		"x",
		"y",
		nil,
		"found",
		nil,
		"two",
	}
	local nt = table.unique(t)
	T.equal(nt[1], "found")
	T.equal(nt[4], "two")
	local xt = {}
	xt.one = "mfound"
	xt.two = "mfound"
	xt.three = nil
	xt.four = "four"
	local xnt = table.unique(xt)
	T.equal(xnt[1], "mfound")
	T.equal(xnt[2], "four")
end
--#
--# === *table.count*(_Table_, _Any_) -> _Number_
--# Count the number of values(argument #2) in table(argument #1).
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table |Table
--# |any |Any value except tables
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |number| Count
--# |===
local table_count = function()
	T.is_function(table.count)
	local t = {
		"found",
		"x",
		"y",
		nil,
		"found",
		nil,
		"two",
	}
	t.one = "found"
	T.equal(table.count(t, "found"), 3)
end
--#
--# === *table.size*(_Table_) -> _Number_
--# Count the number of non-nil values in a table(map or list).
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table| Table
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |number| Count
--# |===
local table_size = function()
	T.is_function(table.size)
	local t = {
		"one",
		nil,
		"three",
		nil,
		"five",
	}
	t.map = 0
	t.xy = nil
	local r1 = table.size(t)
	local r2 = table.size(t, 3)
	T.is_number(r1)
	T.is_number(r2)
	T.equal(#t, 1)
	T.equal(r1, 4)
	T.equal(r2, 3)
end
--# === *table.auto*([_Table_])
--# Create or convert optional table(#1) into Perl-style[1] automagic tables (also called autovivication). An automagic table creates subtables on demand.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table| Optional
--# |===
local table_auto = function()
	T.is_function(table.auto)
	local t = table.auto()
	t.x.y.z = 1
	table.insert(t.x.y, "list1")
	table.insert(t.x.y, "list2")
	local nt = {
		"one",
		"two",
	}
	T.equal(t.x.y.z, 1)
	T.equal(t.x.y[1], "list1")
	T.equal(t.x.y[2], "list2")
	table.insert_if(t.x.y, nt, nt, 1)
	T.equal(t.x.y[1], "one")
	T.equal(t.x.y[2], "two")
	T.equal(t.x.y[3], "list1")
	T.equal(t.x.y[4], "list2")
	T.is_table(t.x.a)
end
--#
--# === *table.insert_if*(_Any_, _Table_, _Any_[, _Number_])
--# Insert value(#3) into list(#2) at position(#4) if argument #1 is not false or nil.
--#
--# Position argument is optional, it defaults to -1 which is at the end of the list. Wraps `table.insert`.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |any |Any value
--# |table| List
--# |any |Any value to insert, can be a table
--# |number |Table position to insert into
--# |===
--#
local table_insert_if = function()
	T.is_function(table.insert_if)
	local t = {
		"one",
		"two",
	}
	local x = 0
	table.insert_if(t, x, "1.5", 2)
	T.equal(t[2], "1.5")
	table.insert_if(t, true, "three")
	T.equal(t[4], "three")
	local nt = {
		"four",
		"five",
	}
	table.insert_if(t, nt, nt)
	T.equal(t[5], "four")
	T.equal(t[6], "five")
	local xt = {
		"alpha",
		"omega",
	}
	table.insert_if(t, xt, xt, 1)
	T.equal(t[1], "alpha")
	T.equal(t[2], "omega")
	T.equal(t[#t], "five")
end
--#
--# === *table.filter*(_Table_, _String_[, _Boolean_])
--# Remove values from a sequence(list without holes).
--#
--# The second argument is a fixed string. The optional third argument turns *on* Lua pattern matching.
--#
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table |List
--# |string |Fixed string to filter
--# |boolean |Optional, if `true`, turn on pattern matching
--# |===
local table_filter = function()
	T.is_function(table.filter)
	local t = {
		"one",
		"two",
		"xxx",
	}
	table.filter(t, "two")
	T.equal(t[2], "xxx")
	T.is_nil(t[3])
	local n = {
		"nine",
		"ten",
	}
	table.filter(n, "^t.*", true)
	T.equal(#n, 1)
	T.equal(n[1], "nine")
end
--#
--# === *table.to_list*(_Table_) -> _Table_
--# Convert a table(map) to a list.
--#
--# The keys from the map are used as values in the new table(list). The values from the map are discarded.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table| Map
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table| New table(list)
--# |===
local table_to_list = function()
	T.is_function(table.to_list)
	local t = {
		first = "one",
		x = "nil",
		second = "two",
	}
	local nt = table.to_list(t)
	T.equal(nt[1], "first")
	T.equal(nt[2], "x")
	T.equal(nt[3], "second")
end
--#
--# === *table.to_map*(_Table_[, _Any_][, _Boolean_]) -> _Table_
--# Convert a table(list) to a map.
--#
--# The values from the original list are used as keys in the new table(map). The optional second argument will be the value for each key. It defaults to boolean `true`. The optional third argument when set to `true` allows a list with holes(nil values) in it.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table| List
--# |any| Optional, defaults to `true`
--# |boolean| Optional, if `true`, allow holes in the list
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table| New table(map)
--# |===
local table_to_map = function()
	T.is_function(table.to_map)
	local t = {
		"one",
		"two",
	}
	local nt = table.to_map(t)
	T.is_table(nt)
	T.equal(nt.one, true)
	T.equal(nt.two, true)
	local dt = table.to_map(t, "x")
	T.is_table(dt)
	T.equal(dt.one, "x")
	T.equal(dt.two, "x")
	local xt = {
		"three",
		nil,
		"five",
	}
	local zt = table.to_map(xt, nil, true)
	T.is_table(zt)
	T.equal(zt.three, true)
	T.equal(zt.five, true)
end
--#
--# === *table.find*(_Table_, _String_[, _Boolean_]) -> _Boolean_, _String_
--# For each value in a table look for a fixed string (argument #2). The optional third argument turns *on* Lua pattern matching.
--#
--# Immediately return `true` if a match is found.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table| List or map to traverse
--# |string| Fixed string or pattern
--# |boolean| Optional, turn on pattern matching
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if string is found, `nil` and an error message, otherwise
--# |string | Key of matching value if the type is string
--# |===
local table_find = function()
	T.is_function(table.find)
	local t = {
		"one",
		"two",
	}
	T.is_true(table.find(t, "one"))
	local r, e = table.find(t, "x")
	T.is_nil(r)
	T.is_true(table.find(t, "^o.*", true))
	local xt = {
		yt = {
			zt = {
				one = "xyz"
			}
		}
	}
	local x, y = table.find(xt, "xyz")
	T.is_true(x)
	T.equal(y, "one")
	local aa = {
		ab = {
			ac = {
				one = 1
			}
		}
	}
	local g, h = table.find(aa, 1)
	T.is_true(g)
	T.equal(h, "one")
end
--#
--# === *table.clone*(_Table_) -> _Table_
--# Deep copy of table.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table|Table to clone
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table|New table
--# |===
local table_clone = function()
	T.is_function(table.clone)
	local o = { 1 }
	local x = table.clone(o)
	expect(1)(x[1])
	x[1] = 0
	expect(0)(x[1])
	expect(1)(o[1])
end
--#
--# === *table.read_only*(_Table_) -> _Table_
--# Use a proxy table to mimic read-only tables.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |table|Table
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table|New table
--# |===
local table_read_only = function()
	T.is_function(table.read_only)
	local t = table.read_only({ 1, 2 })
	T.error_raised(function() t[1] = 0 end)
	expect(2)(t[2])
	expect(1)(t[1])
end
if included then
	return function()
		T["table.find"] = table_find
		T["table.to_map"] = table_to_map
		T["table.to_list"] = table_to_list
		T["table.filter"] = table_filter
		T["table.insert_if"] = table_insert_if
		T["table.auto"] = table_auto
		T["table.size"] = table_size
		T["table.count"] = table_count
		T["table.unique"] = table_unique
		T["table.clone"] = table_clone
		T["table.read_only"] = table_read_only
	end
else
	T["table.find"] = table_find
	T["table.to_map"] = table_to_map
	T["table.to_list"] = table_to_list
	T["table.filter"] = table_filter
	T["table.insert_if"] = table_insert_if
	T["table.auto"] = table_auto
	T["table.size"] = table_size
	T["table.count"] = table_count
	T["table.unique"] = table_unique
	T["table.clone"] = table_clone
	T["table.read_only"] = table_read_only
end
