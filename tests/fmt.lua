local fmt_print = function()
  local x = 'x'
  fmt.print('%s\n', x)
end
if pcall(debug.getlocal, 4, 1) then
  return function()
    local T = require 'test'
    --# === *fmt.print*(_S_, _..._) -> _S_
    --# Print formatted string to io.stdout.
    --# +
    --# === Arguments
    --# [width="72%"]
    --# |===
    --# |string| Format string
    --# |varargs| Values for the format string
    --# |===
    T['fmt.print'] = function()
      T.is_function(fmt.print)
      fmt_print()
    end
  end
else
  fmt_print()
end
