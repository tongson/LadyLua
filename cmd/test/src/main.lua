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
T["built-in => fmt"] = dofile("tests/fmt.lua")
T["built-in => exec"] = dofile("tests/exec.lua")
T["internal => lua"] = dofile("tests/lua.lua")
T["extension => table"] = dofile("tests/extension_table.lua")
T["extension => string"] = dofile("tests/extension_string.lua")
T["extension => exec"] = dofile("tests/extension_exec.lua")
T["module => list"] = dofile("tests/list.lua")
T["module => guard"] = dofile("tests/guard.lua")
T["module => queue"] = dofile("tests/queue.lua")
T["module => map"] = dofile("tests/map.lua")
T["module => tuple"] = dofile("tests/tuple.lua")
T["module => graph"] = dofile("tests/graph.lua")
T["module => object"] = dofile("tests/object.lua")
T["module => date"] = dofile("tests/date.lua")
T["module => csv"] = dofile("tests/csv.lua")
T["module => ssh_config"] = dofile("tests/ssh_config.lua")
T["module => ulid"] = dofile("tests/ulid.lua")
T["module => refmt"] = dofile("tests/refmt.lua")
T["module => bitcask"] = dofile("tests/bitcask.lua")
T["module => fsnotify"] = dofile("tests/fsnotify.lua")
T["module => logger"] = dofile("tests/logger.lua")
T["module => lz4"] = dofile("tests/lz4.lua")
if all then
	T["module => slack"] = dofile("tests/slack.lua")
	T["module => pushover"] = dofile("tests/pushover.lua")
	T["module => telegram"] = dofile("tests/telegram.lua")
	T["module => mysql"] = dofile("tests/mysql.lua")
	T["module => redis"] = dofile("tests/redis.lua")
end
T["module => ksuid"] = dofile("tests/ksuid.lua")
T["module => tengattack/gluacrypto"] = dofile("tests/crypto.lua")
T["module => leafo/etlua"] = dofile("tests/template.lua")
T["module => layeh/gopher-json"] = dofile("tests/json.lua")
T["extension => json"] = dofile("tests/extension_json.lua")
T["module => cjoudrey/gluahttp"] = dofile("tests/http.lua")
T["module => luarocks/argparse"] = dofile("tests/argparse.lua")
T["global => extend"] = function()
	T.is_function(extend)
end
T["module => UIdalov/u-test"] = function()
	T.is_function(T.is_function)
end
T["built-in => fs"] = dofile("tests/fs.lua")
T.summary()
