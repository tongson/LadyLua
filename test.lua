#!./ll
local T = require 'test'
local errstr = function(tested, str, ...)
  local n, s = tested(...)
  if n ~= nil then
    return false, 'First return value is not nil.'
  end
  if nil == (string.find(s, str, 1, true)) then
    return false, string.format('Not found in error string: "%s".', str)
  end
  return true
end

T.register_assert("error", errstr)

local Tjson = dofile'tests/json.lua'
T['built-in => json'] = Tjson
T["global => pi"] = function()
  T.is_function(pi)
  T.is_number(pi(300))
end
T["module => UIdalov/u-test"] = function()
  T.is_function(T.is_function)
end
T["module => kikito/inspect"] = function()
  local inspect = require 'inspect'
  local t = { 1, 2 }
  T.is_function(inspect.inspect)
  T.equal(inspect(t), '{ 1, 2 }')
end
T["fs.isdir"] = function()
  T.is_function(fs.isdir)
  T.is_true(fs.isdir('/etc'))
  T.is_false(fs.isdir('/dev/null'))
end
T["fs.isfile"] = function()
  T.is_function(fs.isfile)
  T.is_true(fs.isfile('/etc/passwd'))
  T.is_false(fs.isfile('/dev'))
end
T["os.hostname"] = function()
  T.is_function(os.hostname)
  T.is_string(os.hostname())
end



T.summary()
