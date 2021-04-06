local I = require 'inspect'

local s = {'ine','t'}
local meta = function(t)
  setmetatable(t, {__index = {
    find = function(self, e, p)
      return table.find(self, e, p)
    end,
  }})
end
meta(s)
assert(true==s:find('ine'))
assert(nil==s:find('tt'))


