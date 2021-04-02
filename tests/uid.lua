return function()
  local T = require 'test'
  local U = require 'uid'
  T['uid.new'] = function()
    local s = U.new()
    T.is_string(s)
    T.equal(tonumber(#s), 27)
  end
end
