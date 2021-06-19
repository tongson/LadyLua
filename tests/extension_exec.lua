local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
--require("xexec")()
extend("exec")

local D = "/tmp/exec.command"
local F = "/tmp/exec.command/file"
--# = xexec
--# :toc:
--# :toc-placement!:
--#
--# Additional functions for the exec namespace.
--#
--# To load and patch global `exec` namespace:
--# ----
--# require("xexec")()
--# ----
--#
--# toc::[]
--#
--# == *exec.cmd*(_String_) -> _Function_
--# Execute program under a context. Difference with `exec.ctx` is this takes two additional settings; `errexit` and `error`. When `errexit` is set to `true`, the programs exits immediately when an error is encountered. The `error` setting takes a string to show when `errexit` is triggered. +
--# The returned function's also accepts a format string OR a table(list) for building the argument.
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
--# |errexit |Exit immediately when an error is encountered
--# |error |Custom error message when errexit is triggered
--# |===
--#
--# === Example
--# ----
--# local ls = exec.cmd'/bin/ls'
--# ls.env = {'LC_ALL=C'}
--# local tmp = '/tmp'
--# local dev = '/dev'
--# local r, o = ls('%s %s', tmp, dev)
--# ----
local exec_cmd = function()
	T.is_true(fs.mkdir(D))
	local touch = exec.cmd("/bin/touch")
	local one = "/tmp/exec.command/one"
	local two = "/tmp/exec.command/two"
	local t = touch("%s %s", one, two)
	T.is_true(t)
	T.is_true(fs.isfile(one))
	T.is_true(fs.isfile(two))
	local rm = exec.cmd("/usr/bin/rm")
	local r = rm("%s %s", one, two)
	T.is_true(r)
	T.is_nil(fs.isfile(one))
	T.is_nil(fs.isfile(two))
	T.is_true(fs.rmdir(D))
end
local exec_cmd_list = function()
	T.is_true(fs.mkdir(D))
	local touch = exec.cmd("/bin/touch")
	local one = "/tmp/exec.command/one"
	local two = "/tmp/exec.command/two"
	local t = touch({ one, two })
	T.is_true(t)
	T.is_true(fs.isfile(one))
	T.is_true(fs.isfile(two))
	local rm = exec.cmd("/usr/bin/rm")
	local r = rm({ one, two })
	T.is_true(r)
	T.is_nil(fs.isfile(one))
	T.is_nil(fs.isfile(two))
	T.is_true(fs.rmdir(D))
end
--#
--# == *exec.run*(_String_) -> _Function_
--# A quick way run programs if you only need to set arguments.
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
--# |function| A function that can be called; the function also returns the same values as `exec.command`
--# |===
--#
--# === Example
--# ----
--# local rm = exec.run 'rm'
--# rm'/tmp/test'
--# ----
local exec_run = function()
	T.is_true(fs.mkdir(D))
	local t = exec.run.touch(F)
	T.is_true(t)
	T.is_true(fs.isfile(F))
	local r = exec.run.rm(F)
	T.is_true(r)
	T.is_nil(fs.isfile(F))
	T.is_true(fs.rmdir(D))
end
local exec
if included then
	return function()
		T["exec.cmd"] = exec_cmd
		T["exec.cmd list"] = exec_cmd_list
		T["exec.run"] = exec_run
	end
else
	T["exec.cmd"] = exec_cmd
	T["exec.cmd list"] = exec_cmd_list
	T["exec.run"] = exec_run
end
