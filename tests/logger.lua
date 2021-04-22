local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local logger = require("logger")
local api
--# = logger
--# :toc:
--# :toc-placement!:
--#
--# Structured logging to STDERR, STDOUT, or file.
--# A https://github.com/rs/zerolog[zerolog] wrapper.
--#
--# toc::[]
--#
--# == *logger.new*()
--#
--# Initialize object to access methods below.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |`stdout`, `stderr`, or path to a file, default is `stderr`
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |userdata| Userdata with methods below
--# |===
local logger_new = function()
	T.is_function(logger.new)
	api = logger.new()
	T.is_userdata(api)
end
--#
--# == *:{info, debug, warn, error}* (_String_, _Table_)
--#
--# Log to specified log level.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string| message
--# |table | key-value map
--# |===
local logger_info = function()
	T.is_function(api.info)
end
local logger_debug = function()
	T.is_function(api.debug)
end
local logger_warn = function()
	T.is_function(api.warn)
end
local logger_error = function()
	T.is_function(api.error)
end
local logger_try = function()
	local l = logger.new("/tmp/logger_try")
	local json = require("json")
	l:info("test", { one = "a", two = "b" })
	local s = fs.read("/tmp/logger_try")
	local t = json.decode(s)
	T.equal(t.one, "a")
	T.equal(t.two, "b")
	T.equal(t.message, "test")
	T.equal(t.level, "info")
	T.is_string(t.time)
	os.remove("/tmp/logger_try")
end
if included then
	return function()
		T["logger.new"] = logger_new
		T[":info"] = logger_info
		T[":debug"] = logger_debug
		T[":warn"] = logger_warn
		T[":error"] = logger_error
		T["file"] = logger_try
	end
else
	T["logger.new"] = logger_new
	T[":info"] = logger_info
	T[":debug"] = logger_debug
	T[":warn"] = logger_warn
	T[":error"] = logger_error
	T["file"] = logger_try
end
