local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
--# = html
--# :toc:
--# :toc-placement!:
--#
--# Utilities for HTML output.
--#
--# toc::[]
--#
--# == *html.sanitize*(_String_) -> _String_
--# Wrapper to https://github.com/microcosm-cc/bluemonday[bluemonday] for sanitizing HTML.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |HTML
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Cleaned HTML
--# |===
local html_sanitize = function()
  local H = require 'html'
  T.is_function(H.sanitize)
  local s = H.sanitize[[Hello <STYLE>.XSS{background-image:url("javascript:alert('XSS')");}</STYLE><A CLASS=XSS></A>World]]
    T.equal(s, 'Hello World')
end
if included then
  return function()
    T['html.sanitize'] = html_sanitize
  end
else
  T['html.sanitize'] = html_sanitize
end
