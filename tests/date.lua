local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local date = require("date")
local expect = T.expect
local equal = T.equal
--# = date
--# :toc:
--# :toc-placement!:
--#
--# Date and time operations.
--#
--# toc::[]
--#
--# == *date.diff*(_Object_, _Object_) -> _Table_
--# Subtract the date and time value of two `date` objects.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table|date object
--# |===
local date_diff = function()
	T.is_function(date.diff)
	local d = date.diff("Jan 7 1563", date(1563, 1, 2))
	expect(5)(d:spandays())
end
--#
--# == *date.epoch* -> _Table_
--# OS epoch.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table|date object
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
--# == *date.setcenturyflip*(_Number_)
--# Sets the global value for centuryflip.
--#
--# Century flip determines how 2-digit years are interpreted when parsing string values. Any value smaller than centuryflip will be considered 20xx, and values greater or equal will become 19xx. The default value is 0, so all 2 digit years are considered 19xx.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Flip
--# |===
local date_setcenturyflip = function()
	date.setcenturyflip(0)
	equal(date("01-01-00"), date(1900,01,01))
	equal(date("01-01-50"), date(1950,01,01))
	equal(date("01-01-99"), date(1999,01,01))
	date.setcenturyflip(100)
	equal(date("01-01-00"), date(2000,01,01))
	equal(date("01-01-50"), date(2050,01,01))
	equal(date("01-01-99"), date(2099,01,01))
	date.setcenturyflip(50)
	equal(date("01-01-00"), date(2000,01,01))
	equal(date("01-01-49"), date(2049,01,01))
	equal(date("01-01-50"), date(1950,01,01))
	equal(date("01-01-99"), date(1999,01,01))
	date.setcenturyflip(0)
end
--#
--# == *date.getcenturyflip*() -> _Number_[
--# Get the global value of centuryflip setting.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Flip
--# |===
local date_getcenturyflip = function()
	expect(0)(date.getcenturyflip())
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
--#
--# == *:adddays*(_Number_)
--# Add days to date object.
local adddays = function()
	local a = date(2000,12,30)
	local b = date(a):adddays(3)
	local c = date.diff(b,a)
	expect(3)(c:spandays())
end
--#
--# == *:addhours*(_Number_)
--# Add hours to date object.
local addhours = function()
	local a = date(2000,12,30)
	local b = date(a):addhours(3)
	local c = date.diff(b,a)
	expect(3)(c:spanhours())
end
--#
--# == *:addminutes*(_Number_)
--# Add minutes to date object.
local addminutes = function()
	local a = date(2000,12,30)
	local b = date(a):addminutes(3)
	local c = date.diff(b,a)
	expect(3)(c:spanminutes())
end
--#
--# == *:addmonths*(_Number_)
--# Add months to date object.
local addmonths = function()
	local a = date(2000,12,30)
	local b = date(a):addmonths(3)
	expect(3)(b:getmonth())
end
--#
--# == *:addseconds*(_Number_)
--# Add seconds to date object.
local addseconds = function()
	local a = date(2000,12,30)
	local b = date(a):addseconds(3)
	local c = date.diff(b,a)
	expect(3)(c:spanseconds())
end
--#
--# == *:addticks*(_Number_)
--# Add ticks to date object.
local addticks = function()
	local a = date(2000,12,30)
	local b = date(a):addticks(3)
	local c = date.diff(b,a)
	expect(3)(c:spanticks())
end
--#
--# == *:addyears*(_Number_)
--# Add years to date object.
local addyears = function()
	local a = date(2000,12,30)
	local b = date(a):addyears(3)
	expect(2000+3)(b:getyear())
end
--#
--# == *:copy*()
--# Copy date object.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table|date object
--# |===
local copy = function()
	local a = date(2000,12,30)
	local b = a:copy()
	equal(a, b)
end
--#
--# == *:fmt*(_String_) -> _String_
--# Return a formatted version of date object.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string|Formatted string
--# |===
local fmt = function()
	local d = date(1582,10,5)
	equal(d:fmt('%D'), d:fmt("%m/%d/%y"))        -- month/day/year from 01/01/00 (12/02/79)
	equal(d:fmt('%F'), d:fmt("%Y-%m-%d"))        -- year-month-day (1979-12-02)
	equal(d:fmt('%h'), d:fmt("%b"))              -- same as %b (Dec)
	equal(d:fmt('%r'), d:fmt("%I:%M:%S %p"))     -- 12-hour time, from 01:00:00 AM (06:55:15 AM)
	equal(d:fmt('%T'), d:fmt("%H:%M:%S"))        -- 24-hour time, from 00:00:00 (06:55:15)
	equal(d:fmt('%a %A %b %B'), "Tue Tuesday Oct October")
	equal(d:fmt('%C %d'), "15 05")
end
--#
--# == *:getdate*() -> _Number_, _Number_, _Number_
--# Return year, month, day from date object.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Year
--# |number|Month
--# |number|Day
--# |===
local getdate = function()
	local a = date(1970, 1, 1)
	local y, m, d = a:getdate()
	expect(1970)(y)
	expect(1)(m)
	expect(1)(d)
end
--#
--# == *:getday*() -> _Number_
--# Get day of month.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Day
--# |===
local getday = function()
	local d = date(1966, 'sep', 6)
	expect(6)(d:getday())
end
--#
--# == *:getfracsec*() -> _Number_
--# Get seconds after the minute (fractional) value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Seconds
--# |===
local getfracsec = function()
	local d = date("Wed Apr 04 2181 11:51:06.996 UTC")
	expect(6.996)(d:getfracsec())
end
--#
--# == *:gethours*() -> _Number_
--# Get hours value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Hour
--# |===
local gethours = function()
	local d = date("Wed Apr 04 2181 11:51:06 UTC")
	expect(11)(d:gethours())
end
--#
--# == *:getisoweekday*() -> _Number_
--# Get the day of week (sunday=7, monday=1, ...saturday=6).
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Day
--# |===
local getisoweekday = function()
	local d = date(1970, 1, 1)
	expect(4)(d:getisoweekday())
end
--#
--# == *:getisoweeknumber*() -> _Number_
--# Get the ISO 8601 week number (01 to 53). Using the Year-WeekOfYear-DayOfWeek date system.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Week
--# |===
local getisoweeknumber = function()
	local d = date(1975, 12, 29)
	expect(1)(d:getisoweeknumber())
	expect(1976)(d:getisoyear())
	expect(1)(d:getisoweekday())
	local e = date(1977, 1, 2)
	expect(53)(e:getisoweeknumber())
	expect(1976)(e:getisoyear())
	expect(7)(e:getisoweekday())
end
--#
--# == *:getisoyear() -> _Number_
--# Get the ISO 8601 year in a dateObject. Using the Year-WeekOfYear-DayOfWeek date system.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Year
--# |===
local getisoyear = function()
	local d = date(1996, 12, 30)
	expect(1997)(d:getisoyear())
	local e = date(1997, 01, 05)
	expect(1997)(d:getisoyear())
end
--#
--# == *:getminutes*() -> _Number_
--# Get the minutes after the hour value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Minutes
--# |===
local getminutes = function()
	local d = date("Wed Apr 04 2181 11:51:06 UTC")
	expect(51)(d:getminutes())
end

--#
--# == *:getmonth*() -> _Number_
--# Get the month value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Month
--# |===
local getmonth = function()
	local d = date(1966, 'sep', 6)
	expect(9)(d:getmonth())
end
--#
--# == *:getseconds*() -> _Number_
--# Get the seconds after the minute value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Seconds
--# |===
local getseconds = function()
	local d = date("Wed Apr 04 2181 11:51:06.123 UTC")
	expect(6)(d:getseconds())
end
--#
--# == *:getticks*() -> _Number_
--# Get the ticks after the seconds value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Ticks
--# |===
local getticks = function()
	local d = date("Wed Apr 04 2181 11:51:06.123 UTC")
	expect(123000)(d:getticks())
end

--#
--# == *:gettime() -> _Number_, _Number_, _Number_
--# Get the hours, minutes, seconds and ticks value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Hours
--# |number|Minutes
--# |number|Seconds
--# |number|Ticks
--# |===
local gettime = function()
	local a = date({hour=5,sec=.5,min=59})
	local h, m, s, t = a:gettime()
	expect(500000)(t)
	expect(0)(s)
	expect(59)(m)
	expect(5)(h)
end
--#
--# == *:getweekday*() -> _Number_
--# Get the day of week (sunday=1, monday=2, ...saturday=7).
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Week
--# |===
local getweekday = function()
	local d = date(1970, 1, 1)
	expect(5)(d:getweekday())
end
--#
--# == *:getweeknumber*([_Number_]) -> _Number_
--# Get the week number.
--#
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Optional, week base
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Week
--# |===
local getweeknumber = function()
	local a = date("12/31/1972")
	local b,c = a:getweeknumber(), a:getweeknumber(2)
	expect(53)(b)
	expect(52)(c)
end
--#
--# == *:getyear*() -> _Number_
--# Return year value.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Year
--# |===
local getyear = function()
	local d = date(1965, 'jan', 0)
	-- XXX -- 1964?
	expect(1965)(d:getyear())
end
--#
--# == *:getyearday*() -> _Number_
--# Get the day of year (1-366)
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Day
--# |===
local getyearday = function()
	local d = date(2181, 1, 12)
	expect(12)(d:getyearday())
end
--#
--# == *:setday*(_Number_)
--# Set the day of month value.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number|Month day
--# |===
local setday = function()
	local d = date(1966, 'july', 6)
	d:setday(1)
	expect(date("1966 july 1"))(d)
end
local metamethods = function()
	local a = date(1521,5,2)
	local b = a:copy():addseconds(0.001)
	local D = a - b
	expect(-0.001)(D:spanseconds())
	expect(a + b)(b + a)
	expect(b - date("00:00:00.001"))(a)
	expect(a + date("00:00:00.001"))(b)
	b:addseconds(-0.01)
	expect(true)(a >  b and b <  a)
	expect(true)(a >= b and b <= a)
	expect(true)(a ~= b and (not(a == b)))
	a = b:copy()
	expect(false)(a >  b and b <  a)
	expect(true)(a >= b and b <= a)
	expect(true)(a == b and (not(a ~= b)))
	expect(a .. 565369)(b .. 565369)
	expect(a .. "????")(b .. "????")
end
if included then
	return function()
		T["date.diff"] = date_diff
		T["date.epoch"] = date_epoch
		T["date.isleapyear"] = date_isleapyear
		T["date.setcenturyflip"] = date_setcenturyflip
		T["date.getcenturyflip"] = date_getcenturyflip
		T["date"] = date_object
		T[":adddays"] = adddays
		T[":addhours"] = addhours
		T[":addminutes"] = addminutes
		T[":addmonths"] = addmonths
		T[":addseconds"] = addseconds
		T[":addticks"] = addticks
		T[":addyears"] = addyears
		T[":copy"] = copy
		T[":fmt"] = fmt
		T[":getdate"] = getdate
		T[":getday"] = getday
		T[":getfracsec"] = getfracsec
		T[":gethours"] = gethours
		T[":getisoweekday"] = getisoweekday
		T[":getisoweeknumber"] = getisoweeknumber
		T[":getisoyear"] = getisoyear
		T[":getminutes"] = getminutes
		T[":getmonth"] = getmonth
		T[":getticks"] = getticks
		T[":gettime"] = gettime
		T[":getweekday"] = getweekday
		T[":getweeknumber"] = getweeknumber
		T[":getyear"] = getyear
		T[":getyearday"] = getyearday
		T[":setday"] = setday
		T["metamethods"] = metamethods
	end
else
	T["date.diff"] = date_diff
	T["date.epoch"] = date_epoch
	T["date.isleapyear"] = date_isleapyear
	T["date.setcenturyflip"] = date_setcenturyflip
	T["date.getcenturyflip"] = date_getcenturyflip
	T["date"] = date_object
	T[":adddays"] = adddays
	T[":addhours"] = addhours
	T[":addminutes"] = addminutes
	T[":addmonths"] = addmonths
	T[":addseconds"] = addseconds
	T[":addticks"] = addticks
	T[":addyears"] = addyears
	T[":copy"] = copy
	T[":fmt"] = fmt
	T[":getdate"] = getdate
	T[":getday"] = getday
	T[":getfracsec"] = getfracsec
	T[":gethours"] = gethours
	T[":getisoweekday"] = getisoweekday
	T[":getisoweeknumber"] = getisoweeknumber
	T[":getisoyear"] = getisoyear
	T[":getminutes"] = getminutes
	T[":getmonth"] = getmonth
	T[":getticks"] = getticks
	T[":gettime"] = gettime
	T[":getweekday"] = getweekday
	T[":getweeknumber"] = getweeknumber
	T[":getyear"] = getyear
	T[":getyearday"] = getyearday
	T[":setday"] = setday
	T["metamethods"] = metamethods
end
