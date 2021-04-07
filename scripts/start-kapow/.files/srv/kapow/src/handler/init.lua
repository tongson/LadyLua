return function()
  local Get = require 'kapow'.get
  local MD = Get '/request/method'
  local WB = {
    GET  = require 'handler.app.get';
    POST = require 'handler.app.post';
  }
  local r = string.sub(Get('/request/path'), 2)
  if #r < 1 then
    r = '__DEFAULT'
  end
  return WB[MD][r]()
end
