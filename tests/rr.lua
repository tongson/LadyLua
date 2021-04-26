local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local rr = require("rr")
local ctx
local cwd = fs.currentdir()
--# = rr
--# :toc:
--# :toc-placement!:
--#
--# Run scripts in a rr directory hierarchy.
--# See the upstream project https://github.com/tongson/rr[rr].
--#
--# toc::[]
--#
--# == *rr.ctx*([_String_],[ _String_]) -> _Table_
--#
--# Initialize hostname and directory.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |hostname, default `localhost`
--# |string |directory of scripts, default `.`
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table| Metatable with methods below
--# |===
local rr_ctx = function()
	T.is_function(rr.ctx)
	ctx = rr.ctx("local", "tests/rr")
	T.is_table(ctx)
end
--#
--# == *:run*(_String_, _String_[, _Table_][, _Table_]) -> _String_, _String_, _String_, _String_
--#
--# Run namespace(#1), script(#2).
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string| Namespace
--# |string| Script
--# |table | Optional, arguments to script
--# |table | Optional, environment variables
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string| Generated shell script, a "truthy" value
--# |string| STDOUT
--# |string| STDERR
--# |string| Any error from the side of the Go execution
--# |===
local rr_run = function()
	T.is_function(ctx.run)
	local sc, so, se, _ = ctx:run("ll", "test", { "one", "two" }, { "VAR=three" })
	T.is_string(sc)
	local expected = [[one
two
one two
three
]]
	T.equal(so, expected)
	T.equal(#se, 0)
	T.not_equal(fs.currentdir(), cwd)
end
--#
--# == *:done*() -> _Boolean_
--#
--# rr.ctx() may change the current directory. This method reverts the directory.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if successful
--# |===
local rr_done = function()
	T.is_function(ctx.done)
	T.is_true(ctx:done())
	T.equal(fs.currentdir(), cwd)
end
if included then
	return function()
		T["rr.ctx"] = rr_ctx
		T["rr.run"] = rr_run
		T["rr.done"] = rr_done
	end
else
	T["rr.ctx"] = rr_ctx
	T["rr.run"] = rr_run
	T["rr.done"] = rr_done
end
