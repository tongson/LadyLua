local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local pushover = require("pushover")
local api
--# = pushover
--# :toc:
--# :toc-placement!:
--#
--# Send Pushover messages via the API.
--#
--# toc::[]
--#
--# == *pushover.new*()
--#
--# Initialize object to access methods below. Requires a valid token in the environment variable `PUSHOVER_TOKEN`.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |userdata| Userdata with methods below
--# |===
local pushover_new = function()
	T.is_function(pushover.new)
	api = pushover.new()
	T.is_userdata(api)
end
--#
--# == *:message*(_String_, _String_)
--#
--# Send a message to device.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string| Device ID
--# |string| message
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string| Response from API
--# |===
local pushover_message = function()
	T.is_function(api.message)
end
if included then
	return function()
		T["pushover.new"] = pushover_new
		T[":message"] = pushover_message
	end
else
	T["pushover.new"] = pushover_new
	T[":message"] = pushover_message
end
