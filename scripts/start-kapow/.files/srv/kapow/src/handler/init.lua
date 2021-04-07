return function(r)
  local Get = require 'kapow'.get
  local MD = Get '/request/method'
  local WB = {
    GET  = require 'handler.app.get';
    POST = require 'handler.app.post';
  }
  r = r or '__DEFAULT'
  return WB[MD][r]
end
