local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local date = require("date")
local expect = T.expect
--# = date
--# :toc:
--# :toc-placement!:
--#
--# Date and time operations.
--#
--# toc::[]
--#
--# == *date.diff*(_Object_, _Object_) -> _Object_
--# Subtract the date and time value of two `date` objects.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |object|date object
--# |===
local date_diff = function()
	T.is_function(date.diff)
	local d = date.diff("Jan 7 1563", date(1563, 1, 2))
	expect(5)(d:spandays())
end
--#
--# == *date.epoch* -> _Object_
--# OS epoch.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |object|date object
--# |===
local date_epoch = function()
	T.is_function(date.epoch)
	--TZ discrepancy
	--local d = date.epoch()
	--expect(date("jan 1 1970"))(d)
end
--#
--# == *date.isleapyear*(_Number_) -> _Boolean_
--# Check if given year is a leap year.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean|Boolean
--# |===
local date_isleapyear = function()
	T.is_function(date.isleapyear)
	expect(true)(date.isleapyear(1776))
	local d = date(1776, 1, 1)
	expect(true)(date.isleapyear(d:getyear()))
end
if included then
	return function()
		T["date.diff"] = date_diff
		T["date.epoch"] = date_epoch
		T["date.isleapyear"] = date_isleapyear
	end
else
	T["date.diff"] = date_diff
	T["date.epoch"] = date_epoch
	T["date.isleapyear"] = date_isleapyear
end
