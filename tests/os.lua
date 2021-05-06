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
--#
--# == *os.sleep(_Number_) -> _Boolean_
--# Sleep for a number of milliseconds.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |number |Milliseconds
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean |`true`
--# |===
local os_sleep = function()
	T.is_function(os.sleep)
	T.is_true(os.sleep(500))
end
--#
--# == *os.setenv*(_String_, _String_) -> _Boolean_
--# Set environment variable.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Variable
--# |string |Value
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean |`true` if successful
--# |===
local os_setenv = function()
	T.is_function(os.setenv)
	T.is_true(os.setenv("TESTLADYLUAOSSETENV", "1"))
	local e = os.getenv("TESTLADYLUAOSSETENV")
	T.equal(e, "1")
end
if included then
	return function()
		T["os.hostname"] = os_hostname
		T["os.outbound_ip"] = os_outbound_ip
		T["os.sleep"] = os_sleep
		T["os.setenv"] = os_setenv
	end
else
	T["os.hostname"] = os_hostname
	T["os.outbound_ip"] = os_outbound_ip
	T["os.sleep"] = os_sleep
	T["os.setenv"] = os_setenv
end
