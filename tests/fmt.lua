local fmt_print = function()
  local x = 'prints to STDOUT'
  fmt.print('%s\n', x)
end
local fmt_warn = function()
  local x = 'prints to STDERR'
  fmt.warn('%s\n', x)
end
local fmt_assert = function()
  local x = 'prints to STDERR when argument #1 is falsy'
  fmt.assert(false, '%s\n', x)
end
local fmt_panic = function()
  local x = 'prints to STDERR and exit with code 1'
  fmt.panic('%s\n', x)
end
if pcall(debug.getlocal, 4, 1) then
  return function()
    local T = require 'test'
    --#
    --# === *fmt.print*(_String_, _..._)
    --# Print formatted string to io.stdout.
    --#
    --# === Arguments
    --# [width="72%"]
    --# |===
    --# |string| Format string
    --# |varargs| Values for the format string
    --# |===
    T['fmt.print'] = function()
      T.is_function(fmt.print)
    end
    --#
    --# === *fmt.warn*(_String_, _..._)
    --# Print formatted string to io.stderr.
    --#
    --# === Arguments
    --# [width="72%"]
    --# |===
    --# |string| Format string
    --# |varargs| Values for the format string
    --# |===
    T['fmt.warn'] = function()
      T.is_function(fmt.warn)
    end
    --#
    --# === *fmt.error*(_String_, _..._) -> _Nil_, _String_
    --# Shortcut for following the Lua convention of returning `nil` and `string` during error conditions.
    --#
    --# === Arguments
    --# [width="72%"]
    --# |===
    --# |string| Format string
    --# |varargs| Values for the format string
    --# |===
    --#
    --# === Returns
    --# [width="72%"]
    --# |===
    --# |nil| nil
    --# |string| Error message
    --# |===
    T['fmt.error'] = function()
      T.is_function(fmt.warn)
      local x, y = fmt.error('%s', 'message')
      T.is_nil(x)
      T.equal(y, 'message')
    end
    --#
    --# === *fmt.panic*(_String_, _..._)
    --# Print formatted string to io.stderr and exit immediately with code 1.
    --#
    --# === Arguments
    --# [width="72%"]
    --# |===
    --# |string| Format string
    --# |varargs| Values for the format string
    --# |===
    T['fmt.panic'] = function()
      T.is_function(fmt.panic)
    end
    --#
    --# === *fmt.assert*(_Value_, _..._)
    --# Print formatted string to io.stderr and exit immediately with code 1 if argument #1 is falsy(nil or false).
    --#
    --# === Arguments
    --# [width="72%"]
    --# |===
    --# |value| Any Lua type that can return nil or false
    --# |string| Format string
    --# |varargs| Values for the format string
    --# |===
    T['fmt.assert'] = function()
      T.is_function(fmt.assert)
    end
  end
else
  fmt_print()
  fmt_warn()
  fmt_assert()
  fmt_panic()
end
