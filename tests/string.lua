local not_main = pcall(debug.getlocal, 4, 1)
local T = require("test")
require("xstring")()
--# = string
--# :toc:
--# :toc-placement!:
--#
--# Functions added to the global `string` namespace.
--#
--# toc::[]
--#
--# == *string.trim_start*(_String_[, _String_]) -> _String_
--# Trim characters to the left of input string(#1).
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Input string
--# |string| Optional pattern, defaults to the space pattern `%s`
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |New string
--# |===
local string_trim_start = function()
	T.is_function(string.trim_start)
	local a = "  ssaa   "
	T.equal(a:trim_start(), "ssaa   ")
	local b = "///ssss///"
	T.equal(b:trim_start("/"), "ssss///")
end
--# == *string.trim_end*(_String_[, _String_]) -> _String_
--# Trim characters to the right of input string(#1).
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Input string
--# |string| Optional pattern, defaults to the space pattern `%s`
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |New string
--# |===
local string_trim_end = function()
	T.is_function(string.trim_end)
	local a = "ssaa   "
	T.equal(a:trim_end(), "ssaa")
	local b = "ssss///"
	T.equal(b:trim_end("/"), "ssss")
end
--# == *string.split*(_String_, _String_, _Boolean_, _Number_) -> _Table_
--# Split string into a list(table) separated by a delimeter.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Input string
--# |string| Optional delimeter, defaults to the space pattern `%s+`
--# |boolean| If truthy, ignores Lua patterns
--# |number| Maximum number of elements from input string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table| List of elements
--# |===
local string_split = function()
	T.is_function(string.split)
	local a = "a b c"
	local b = a:split()
	T.equal(b[1], "a")
	T.equal(b[2], "b")
	T.equal(b[3], "c")
	local x = "x/y/z"
	local y = x:split("/")
	T.equal(y[1], "x")
	T.equal(y[2], "y")
	T.equal(y[3], "z")
end
--#
--# == *string.splitv*(_String_, _String_, _Boolean_, _Number_) -> _Table_
--# Split string into a number of return values separated by a delimeter.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Input string
--# |string| Optional delimeter, defaults to the space pattern `%s+`
--# |boolean| If truthy, ignores Lua patterns
--# |number| Maximum number of elements from input string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |...| Values
--# |===
local string_splitv = function()
	T.is_function(string.splitv)
	local x = "a b c"
	local a, b, c = x:splitv()
	T.equal(a, "a")
	T.equal(b, "b")
	T.equal(c, "c")
end
--# == *string.contains*(_String_, _String_) -> _Number_, _Number_
--# Look for string(#2) in string(#1) without activating any pattern matching operations.
--# A shortcut for `string.find(str, str, 1, true)`.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| String to search into
--# |string| String to look for
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |number| Starting index where the string is found
--# |number| Ending index where the string is found
--# |===
local string_contains = function()
	T.is_function(string.contains)
	local x = "otwone"
	local y = "two"
	local a, b, c = x:contains(y)
	T.equal(a, 2)
	T.equal(b, 4)
end
--# == *string.append*(_String_, _String_) -> _String_
--# Append newline plus argument #2 string to argument #1 string.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Original string
--# |string| String to append
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string| New string
--# |===
--#
--# === Example
--# ----
--# local s = 'one'
--# local x = s:append'two'
--# assert(x=='one\ntwo')
--# ----
local string_append = function()
	T.is_function(string.append)
	local x = "one"
	local y = "two"
	local z = string.append(x, y)
	T.equal(z, "one\ntwo")
	local a = x:append(y)
	T.equal(a, z)
end
--#
--# == *string.word_to_list*(_String_) -> _Table_
--# Create a new table(list) where each alphanumeric sequence of argument #1 is a value in the list.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Source string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table| New table
--# |===
--#
--# === Example
--# ----
--# local n = '1# 2! 3.'
--# local nt = n:word_to_list()
--# -- nt will contain { "1", "2", "3" }
--# ----
local string_word_to_list = function()
	T.is_function(string.word_to_list)
	local x = [[one. #two three
    four]]
	local y = string.word_to_list(x)
	T.is_table(y)
	T.equal(y[1], "one")
	T.equal(y[2], "two")
	T.equal(y[3], "three")
	T.equal(y[4], "four")
end
--#
--# == *string.to_list*(_String_) -> _Table_
--# Create a new table(list) where each non-space(%S) character of argument #1 is a value in the list.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Source string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table| New table
--# |===
--#
--# === Example
--# ----
--# local z = 'one\ttwo'
--# local zt = z:to_list()
--# -- zt will contain {"one", "two"}
--# ----
local string_to_list = function()
	T.is_function(string.to_list)
	local x = [[five2342 s2324
    sdfs %s%s six]]
	local y = string.format(x, string.char(2), string.char(21))
	local z = string.to_list(y)
	T.is_table(z)
	T.equal(z[1], "five2342")
	T.equal(z[2], "s2324")
	T.equal(z[3], "sdfs")
	T.equal(z[4], string.char(2) .. string.char(21))
	T.equal(z[5], "six")
end
--#
--# == *string.to_map*(_String_, _Value_) -> _Table_
--# Create a new table(map) where each non-space(%S) character of argument #1 is a key in the map. The second argument is any value to assign to each key, defaults to boolean `true`.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Source string
--# |any |Value
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table| New table
--# |===
local string_to_map = function()
	T.is_function(string.to_map)
	local x = [[five2342 s2324
    sdfs %s%s six]]
	local y = string.format(x, string.char(2), string.char(21))
	local z = y:to_map()
	T.is_table(z)
	T.equal(z["five2342"], true)
	T.equal(z["s2324"], true)
	T.equal(z["sdfs"], true)
	T.equal(z[string.char(2) .. string.char(21)], true)
	T.equal(z["six"], true)
end
if not_main then
	return function()
		T["string.trim_start"] = string_trim_start
		T["string.trim_end"] = string_trim_end
		T["string.split"] = string_split
		T["string.splitv"] = string_splitv
		T["string.contains"] = string_contains
		T["string.append"] = string_append
		T["string.word_to_list"] = string_word_to_list
		T["string.to_list"] = string_to_list
		T["string.to_map"] = string_to_map
	end
else
	T["string.trim_start"] = string_trim_start
	T["string.trim_end"] = string_trim_end
	T["string.split"] = string_split
	T["string.splitv"] = string_splitv
	T["string.contains"] = string_contains
	T["string.append"] = string_append
	T["string.word_to_list"] = string_word_to_list
	T["string.to_list"] = string_to_list
	T["string.to_map"] = string_to_map
end
