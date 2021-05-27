#!./ll
local T = require("test")
local errstr = function(tested, str, ...)
	local n, s = tested(...)
	if n ~= nil then
		return false, "First return value is not nil."
	end
	if nil == (string.find(s, str, 1, true)) then
		return false, string.format('Not found in error string: "%s".', str)
	end
	return true
end
T.register_assert("error", errstr)

T["built-in => os.hostname"] = dofile("tests/os.lua")
T["built-in => table"] = dofile("tests/table.lua")
T["built-in => string"] = dofile("tests/string.lua")
T["built-in => fmt"] = dofile("tests/fmt.lua")
T["built-in => exec"] = dofile("tests/exec.lua")
T["module => uuid"] = dofile("tests/uuid.lua")
T["module => ulid"] = dofile("tests/ulid.lua")
T["module => rr"] = dofile("tests/rr.lua")
T["module => refmt"] = dofile("tests/refmt.lua")
T["module => bitcask"] = dofile("tests/bitcask.lua")
T["module => fsnotify"] = dofile("tests/fsnotify.lua")
T["module => logger"] = dofile("tests/logger.lua")
T["module => slack"] = dofile("tests/slack.lua")
T["module => pushover"] = dofile("tests/pushover.lua")
T["module => telegram"] = dofile("tests/telegram.lua")
T["module => lz4"] = dofile("tests/lz4.lua")
T["module => mysql"] = dofile("tests/mysql.lua")
T["module => redis"] = dofile("tests/redis.lua")
T["module => kapow"] = dofile("tests/kapow.lua")
T["module => html"] = dofile("tests/html.lua")
T["module => ksuid"] = dofile("tests/ksuid.lua")
T["module => tengattack/gluacrypto"] = dofile("tests/crypto.lua")
T["module => leafo/etlua"] = dofile("tests/template.lua")
T["module => layeh/gopher-json"] = dofile("tests/json.lua")
T["module => cjoudrey/gluahttp"] = dofile("tests/http.lua")
T["global => pi"] = function()
	T.is_function(pi)
	T.is_number(pi(300))
end
T["module => UIdalov/u-test"] = function()
	T.is_function(T.is_function)
end
T["built-in => fs"] = dofile("tests/fs.lua")
T.summary()
