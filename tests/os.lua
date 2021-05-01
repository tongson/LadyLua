local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
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
--#
--# == *os.outbound_ip*() -> _String_
--# Get IP used for outbound connections.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |IP
--# |===
local os_outbound_ip = function()
	T.is_function(os.outbound_ip)
	T.is_string(os.outbound_ip())
end
if included then
	return function()
		T["os.hostname"] = os_hostname
		T["os.outbound_ip"] = os_outbound_ip
	end
else
	T["os.hostname"] = os_hostname
	T["os.outbound_ip"] = os_outbound_ip
end
