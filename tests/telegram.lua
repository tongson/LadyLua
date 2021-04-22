local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local telegram = require("telegram")
local bot
--# = telegram
--# :toc:
--# :toc-placement!:
--#
--# Send Telegram messages via the Bot API.
--#
--# toc::[]
--#
--# == *telegram.new*()
--#
--# Initialize object to access methods below. Requires a valid BOT token in the environment variable `TELEGRAM_TOKEN`.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |userdata| Userdata containing methods below
--# |===
local telegram_new = function()
	T.is_function(telegram.new)
	bot = telegram.new()
	T.is_userdata(bot)
end
--#
--# == *:channel*(_String_, _String_)
--#
--# Post a channel message.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string| channel id e.g. "-12312313"
--# |string| message
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean| true
--# |===
--#
local telegram_channel = function()
	T.is_function(bot.channel)
end
--#
--# == *:message*(_String_, _String_)
--#
--# Send a message to Telegram user.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number| user id e.g. 9348484
--# |string| message
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean| true
--# |===
local telegram_message = function()
	T.is_function(bot.message)
end
if included then
	return function()
		T["telegram.new"] = telegram_new
		T[":channel"] = telegram_channel
		T[":message"] = telegram_message
	end
else
	T["telegram.new"] = telegram_new
	T[":channel"] = telegram_channel
	T[":message"] = telegram_message
end
