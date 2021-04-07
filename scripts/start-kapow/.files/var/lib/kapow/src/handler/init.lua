return function()
  local Get = require 'kapow'.get
  local MD = Get '/request/method'
  local DO = Get '/request/form/__do' or Get '/request/params/do' or '__DEFAULT'
  local TO = Get '/request/form/__to' or Get '/request/params/to' or '__DEFAULT'
  local WB = {
    GET  = require 'handler.app.get';
    POST = require 'handler.app.post';
  }
  return WB[MD][DO](TO)
end
