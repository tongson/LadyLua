local included = pcall(debug.getlocal, 4, 1)
local fmt = require("fmt")
local T = require("test")
--# = fmt
--# :toc:
--# :toc-placement!:
--#
--# Format string variants that wraps `string.format`. +
--#
--# toc::[]
--#
--# == *fmt.print*(_String_, _..._)
--# Print formatted string to io.stdout.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Format string
--# |...| Values for the format string
--# |===
local fmt_print = function()
	T.is_function(fmt.print)
	local x = "prints to STDOUT"
	if not included then
		fmt.print("%s\n", x)
	end
end
--#
--# == *fmt.warn*(_String_, _..._)
--# Print formatted string to io.stderr.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Format string
--# |...| Values for the format string
--# |===
local fmt_warn = function()
	T.is_function(fmt.warn)
	local x = "prints to STDERR"
	if not included then
		fmt.warn("%s\n", x)
	end
end
--#
--# == *fmt.error*(_String_, _..._) -> _Nil_, _String_
--# Shortcut for following the Lua convention of returning `nil` and `string` during error conditions.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Format string
--# |...| Values for the format string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |nil| nil
--# |string| Error message
--# |===
local fmt_error = function()
	T.is_function(fmt.warn)
	local x, y = fmt.error("%s", "message")
	T.is_nil(x)
	T.equal(y, "message")
end
--#
--# == *fmt.panic*(_String_, _..._)
--# Print formatted string to io.stderr and exit immediately with code 1.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Format string
--# |...| Values for the format string
--# |===
local fmt_panic = function()
	T.is_function(fmt.panic)
	local x = "prints to STDERR and exit with code 1"
	if not included then
		fmt.panic("%s\n", x)
	end
end
--#
--# == *fmt.assert*(_Value_, _String_, _..._)
--# Print formatted string to io.stderr and exit immediately with code 1 if argument #1 is falsy(nil or false).
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |value| Any Lua type that can return nil or false
--# |string| Format string
--# |...| Values for the format string
--# |===
local fmt_assert = function()
	T.is_function(fmt.assert)
	local x = "prints to STDERR when argument #1 is falsy"
	if not included then
		fmt.assert(false, "%s\n", x)
	end
end
if included then
	return function()
		T["fmt.print"] = fmt_print
		T["fmt.warn"] = fmt_warn
		T["fmt.error"] = fmt_error
		T["fmt.panic"] = fmt_panic
		T["fmt.assert"] = fmt_assert
	end
else -- ran
	fmt_print()
	fmt_warn()
	fmt_error()
	fmt_panic()
	fmt_assert()
end
