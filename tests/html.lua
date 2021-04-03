return function()
  local T = require 'test'
  local H = require 'html'
  T['html.sanitize'] = function()
    local s = H.sanitize[[Hello <STYLE>.XSS{background-image:url("javascript:alert('XSS')");}</STYLE><A CLASS=XSS></A>World]]
    T.equal(s, 'Hello World')
  end
end
