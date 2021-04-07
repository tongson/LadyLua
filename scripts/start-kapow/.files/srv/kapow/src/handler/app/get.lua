
local Kapow = require 'kapow'
local Ok = Kapow.ok
local Warn = Kapow.warn
local Fail = Kapow.fail
local Redirect = Kapow.redirect
local Forbid = Kapow.forbid
local Not_Allowed = Kapow.not_allowed
local No_Content = Kapow.no_content

local default = function()
  return Ok('hello')
end
local ok = function()
  return Ok('Sending OK(200).')
end
local warn = function()
  return Warn('Sending WARN(202).')
end
local fail = function()
  return Fail('Sending FAIL(500).')
end
local redirect = function()
  return Redirect('http://0.0.0.69:60080')
end
local forbid = function()
  return Forbid('Sending FORBID(403).')
end
local not_allowed = function()
  return Not_Allowed()
end
local no_content = function()
  return No_Content()
end
return {
  __DEFAULT = default;
  ok = ok;
  warn = warn;
  fail = fail;
  redirect = redirect;
  forbid = forbid;
  not_allowed = not_allowed;
  no_content = no_content;
}
