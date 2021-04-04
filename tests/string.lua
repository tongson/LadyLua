local not_main = pcall(debug.getlocal, 4, 1)
local T = require 'test'
--#
--# === *string.append*(_String_, _String_) -> _String_
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
local string_append = function()
  T.is_function(string.append)
  local x = "one"
  local y = "two"
  local z = string.append(x, y)
  T.equal(z, "one\ntwo")
end
--#
--# === *string.line_to_list*(_String_) -> _Table_
--# Create a new table(list) where each line of argument #1 is a value in the list.
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
local string_line_to_list = function()
  T.is_function(string.line_to_list)
  local x = [[
    line 1
    line 2
  ]]
  local z = string.line_to_list(x)
  T.is_table(z)
  T.equal(z[1], '    line 1')
  T.equal(z[2], '    line 2')
end
--#
--# === *string.word_to_list*(_String_) -> _Table_
--# Create a new table(list) where each word of argument #1 is a value in the list.
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
local string_word_to_list = function()
  T.is_function(string.word_to_list)
  local x = [[one two three
    four]]
  local y = string.word_to_list(x)
  T.is_table(y)
  T.equal(y[1], 'one')
  T.equal(y[2], 'two')
  T.equal(y[3], 'three')
  T.equal(y[4], 'four')
end
--#
--# === *string.to_list*(_String_) -> _Table_
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
local string_to_list = function()
  T.is_function(string.to_list)
  local x = [[five2342 s2324
    sdfs %s%s six]]
  local y = string.format(x, string.char(2), string.char(21))
  local z = string.to_list(y)
  T.is_table(z)
  T.equal(z[1], 'five2342')
  T.equal(z[2], 's2324')
  T.equal(z[3], 'sdfs')
  T.equal(z[4], string.char(2)..string.char(21))
  T.equal(z[5], 'six')
end
if not_main then
  return function()
    T['string.append'] = string_append
    T['string.line_to_list'] = string_line_to_list
    T['string.word_to_list'] = string_word_to_list
    T['string.to_list'] = string_to_list
  end
else
  T['string.append'] = string_append
  T['string.line_to_list'] = string_line_to_list
  T['string.word_to_list'] = string_word_to_list
  T['string.to_list'] = string_to_list
end