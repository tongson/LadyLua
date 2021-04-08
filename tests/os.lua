local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
--# = os
--# :toc:
--# :toc-placement!:
--#
--# Extensions to the `os` namespace.
--#
--# toc::[]
--#
--# == *os.hostname*() -> _String_
--# Get current hostname.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Hostname
--# |===
local os_hostname = function()
  T.is_function(os.hostname)
  T.is_string(os.hostname())
end
if included then
  return function()
    T["os.hostname"] = os_hostname
  end
else
  T["os.hostname"] = os_hostname
end
