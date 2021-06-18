local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local D = "/tmp/exec.command"
local F = "/tmp/exec.command/file"
--# = exec
--# :toc:
--# :toc-placement!:
--#
--# Execute external programs.
--#
--# toc::[]
--#
--# == *exec.command*(_String_[, _Table_][, _Table_][, _Table_][, _String_][, _String_]) -> _Boolean_, _String_, _String_, _String_
--# Execute a program. Base function of the the other functions in this module.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Executable
--# |table |Arguments
--# |table |Environment
--# |string |Working directory
--# |string |STDIN
--# |number |Timeout in seconds
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if no errors encountered, `false` otherwise
--# |string  |STDOUT output from program
--# |string  |STDERR output from program
--# |string  |Error from Go
--# |===
local exec_command__SIMPLE = function()
	T.is_function(exec.command)
	T.is_true(fs.mkdir(D))
	T.is_true(exec.command("/bin/touch", { F }))
	T.is_true(fs.isfile(F))
	T.is_true(exec.command("/usr/bin/rm", { F }))
	T.is_nil(fs.isfile(F))
	T.is_true(fs.rmdir(D))
end
local exec_command__CWD = function()
	T.is_true(fs.mkdir(D))
	T.is_true(exec.command("/bin/touch", { "file" }, nil, D))
	T.is_true(fs.isfile(F))
	T.is_true(exec.command("/usr/bin/rm", { F }))
	T.is_nil(fs.isfile(F))
	T.is_true(fs.rmdir(D))
end
local exec_command__ENV = function()
	local r, o = exec.command("/usr/bin/env", nil, { "EXEC=ok" })
	T.is_true(r)
	local s = string.find(o, "EXEC=ok", 1, true)
	T.is_number(s)
end
local exec_command__STDIN = function()
	local r, o = exec.command("/usr/bin/sed", { "s|ss|gg|" }, nil, nil, "ss")
	T.is_true(r)
	local s = string.find(o, "gg", 1, true)
	T.is_number(s)
end
local exec_command__TIMEOUT = function()
	local start = os.clock()
	local r, so, se, e = exec.command("/usr/bin/sleep", { "5" }, nil, nil, nil, 2)
	local s = string.find(e, "signal: killed", 1, true)
	T.is_number(s)
	local elapsed = os.clock() - start
	T.is_true(elapsed > 2 and 3 > elapsed)
end
--#
--# == *exec.ctx*(_String_) -> _Function_
--# Execute program under a context. The returned function takes a table(list) for arguments.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Executable
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |function| A function that can be called and set values; the function also returns the same values as `exec.command`
--# |===
--#
--# === Map
--# [options="header",width="72%"]
--# |===
--# |Value |Description
--# |env |Environment
--# |cwd |Working directory
--# |stdin |STDIN
--# |timeout |Timeout in seconds
--# |===
--#
--# === Example
--# ----
--# local ls = exec.ctx'/bin/ls'
--# ls.env = {'LC_ALL=C'}
--# local r, o = ls{'/tmp', '/dev'}
--# ----
local exec_ctx__SIMPLE = function()
	T.is_true(fs.mkdir(D))
	local touch = exec.ctx("/bin/touch")
	local t = touch({ F })
	T.is_true(t)
	T.is_true(fs.isfile(F))
	local rm = exec.ctx("/usr/bin/rm")
	local r = rm({ F })
	T.is_true(r)
	T.is_nil(fs.isfile(F))
	T.is_true(fs.rmdir(D))
end
local exec_ctx__CWD = function()
	T.is_true(fs.mkdir(D))
	local touch = exec.ctx("/bin/touch")
	touch.cwd = D
	local t = touch({ "file" })
	T.is_true(t)
	T.is_true(fs.isfile(F))
	local rm = exec.ctx("/usr/bin/rm")
	local r = rm({ F })
	T.is_true(r)
	T.is_nil(fs.isfile(F))
	T.is_true(fs.rmdir(D))
end
local exec_ctx__CWD_error = function()
	local ls = exec.ctx("ls")
	ls.cwd = "/sdfsfsfd"
	local r, so, se, e = ls({ "/" })
	T.equal(e:find("no such file or directory", 1, true), 18)
end
local exec_ctx__exit_code = function()
	local ls = exec.ctx("ls")
	local r, so, se, e = ls({ "/sdfshhdgf" })
	T.equal(e:find("exit status 2", 1, true), 1)
end
local exec_ctx__ENV = function()
	local env = exec.ctx("/usr/bin/env")
	env.env = { "EXEC=ok" }
	local r, o = env()
	T.is_true(r)
	local s = string.find(o, "EXEC=ok", 1, true)
	T.is_number(s)
end
local exec_ctx__STDIN = function()
	local sed = exec.ctx("/usr/bin/sed")
	sed.stdin = "ss"
	local r, o = sed({ "s|ss|gg|" })
	T.is_true(r)
	local s = string.find(o, "gg", 1, true)
	T.is_number(s)
end
local exec_ctx__TIMEOUT = function()
	local sleep = exec.ctx("sleep")
	sleep.timeout = 2
	local start = os.clock()
	local r, so, se, e = sleep({"5"})
	local s = string.find(e, "signal: killed", 1, true)
	T.is_number(s)
	local elapsed = os.clock() - start
	T.is_true(elapsed > 2 and 3 > elapsed)
end
local exec
if included then
	return function()
		T["exec.command simple"] = exec_command__SIMPLE
		T["exec.command cwd"] = exec_command__CWD
		T["exec.command env"] = exec_command__ENV
		T["exec.command stdin"] = exec_command__STDIN
		T["exec.command timeout"] = exec_command__TIMEOUT
		T["exec.ctx simple"] = exec_ctx__SIMPLE
		T["exec.ctx cwd"] = exec_ctx__CWD
		T["exec.ctx cwd"] = exec_ctx__CWD_error
		T["exec.ctx cwd"] = exec_ctx__exit_code
		T["exec.ctx env"] = exec_ctx__ENV
		T["exec.ctx stdin"] = exec_ctx__STDIN
	end
else
	T["exec.command simple"] = exec_command__SIMPLE
	T["exec.command cwd"] = exec_command__CWD
	T["exec.command env"] = exec_command__ENV
	T["exec.command stdin"] = exec_command__STDIN
	T["exec.command timeout"] = exec_command__TIMEOUT
	T["exec.ctx simple"] = exec_ctx__SIMPLE
	T["exec.ctx cwd"] = exec_ctx__CWD
	T["exec.ctx cwd"] = exec_ctx__CWD_error
	T["exec.ctx cwd"] = exec_ctx__exit_code
	T["exec.ctx env"] = exec_ctx__ENV
	T["exec.ctx stdin"] = exec_ctx__STDIN
	T["exec.ctx timeout"] = exec_ctx__TIMEOUT
end
