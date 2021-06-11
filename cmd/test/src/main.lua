local all = false
if arg[1] == "all" then
	all = true
end
os.setenv("MYSQL_PASSWORD", "irbj0O3Bn1j8Ezja21NdfcMzj7ZFd2lz")
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
T["internal => lua"] = dofile("tests/lua.lua")
T["module => list"] = dofile("tests/list.lua")
T["module => guard"] = dofile("tests/guard.lua")
T["module => deque"] = dofile("tests/deque.lua")
T["module => bimap"] = dofile("tests/bimap.lua")
T["module => tuple"] = dofile("tests/tuple.lua")
T["module => ulid"] = dofile("tests/ulid.lua")
T["module => rr"] = dofile("tests/rr.lua")
T["module => refmt"] = dofile("tests/refmt.lua")
T["module => bitcask"] = dofile("tests/bitcask.lua")
T["module => fsnotify"] = dofile("tests/fsnotify.lua")
T["module => logger"] = dofile("tests/logger.lua")
T["module => slack"] = all and dofile("tests/slack.lua")
T["module => pushover"] = all and dofile("tests/pushover.lua")
T["module => telegram"] = all and dofile("tests/telegram.lua")
T["module => lz4"] = dofile("tests/lz4.lua")
T["module => mysql"] = all and dofile("tests/mysql.lua")
T["module => redis"] = all and dofile("tests/redis.lua")
T["module => kapow"] = all and dofile("tests/kapow.lua")
T["module => ksuid"] = dofile("tests/ksuid.lua")
T["module => tengattack/gluacrypto"] = dofile("tests/crypto.lua")
T["module => leafo/etlua"] = dofile("tests/template.lua")
T["module => layeh/gopher-json"] = dofile("tests/json.lua")
T["module => cjoudrey/gluahttp"] = all and dofile("tests/http.lua")
T["global => pi"] = function()
	T.is_function(pi)
	T.is_number(pi(300))
end
T["module => UIdalov/u-test"] = function()
	T.is_function(T.is_function)
end
T["built-in => fs"] = dofile("tests/fs.lua")
T.summary()
