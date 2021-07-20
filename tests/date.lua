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
--#
--# == *date*(_Number_)
--# Represents the number of seconds in Universal Coordinated Time between the specified value and the System epoch.
--#
--# == *date*(_Table_) or *date*(_Vararg_)
--# year - an integer, the full year, for example, 1969. Required if month and day is given
--# month - a parsable month value. Required if year and day is given
--# day - an integer, the day of month from 1 to 31. Required if year and month is given
--# hour - Optional, a number, hours value, from 0 to 23, indicating the number of hours since midnight. (default = 0)
--# min - Optional, a number, minutes value, from 0 to 59. (default = 0)
--# sec - Optional, a number, seconds value, from 0 to 59. (default = 0)
--# NOTE: Time (hour or min or sec or msec) must be supplied if date (year and month and day) is not given, vice versa.
--#
--# == *date*(_Boolean_)
--# false - returns the current local date and time
--# true - returns the current UTC date and time
local date_object = function()
	T.is_table(date)
	T.is_function(date.__call)
	local a = date(2006, 8, 13)
	expect(date("Sun Aug 13 2006"))(a)
	local b = date("Jun 13 1999")
	expect(date(1999, 6, 13))(b)
	local d = date({year=2009, month=11, day=13, min=6})
        expect(date("Nov 13 2009 00:06:00"))(d)
	local e = date()
	T.is_not_nil(e)
	local f = date(true)
	T.is_not_nil(f)
end
if included then
	return function()
		T["date.diff"] = date_diff
		T["date.epoch"] = date_epoch
		T["date.isleapyear"] = date_isleapyear
		T["date"] = date_object
	end
else
	T["date.diff"] = date_diff
	T["date.epoch"] = date_epoch
	T["date.isleapyear"] = date_isleapyear
	T["date"] = date_object
end
