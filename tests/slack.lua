local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local slack = require("slack")
--# = slack
--# :toc:
--# :toc-placement!:
--#
--# Wrapper for the Slack API.
--#
--# toc::[]
--#
--# == *slack.message*(_String_) -> _Boolean_
--# Send webhook text. Requires the string after the `https://hooks.slack.com/services/` URL in the `SLACK_WEBHOOK` environment variable.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Message
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean| `true` if successful
--# |===
local slack_message = function()
	T.is_function(slack.message)
end
--# == *slack.attachment*(_Table_) -> _Boolean_
--# Send webhook attachment containing values from the argument. Requires the string after the `https://hooks.slack.com/services/` URL in the `SLACK_WEBHOOK` environment variable.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |See valid values from https://github.com/slack-go/slack[repo]
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean| `true` if successful
--# |===
local slack_attachment = function()
	T.is_function(slack.attachment)
end
if included then
	return function()
		T["slack.message"] = slack_message
		T["slack.attachment"] = slack_attachment
	end
else
	T["slack.message"] = slack_message
	T["slack.attachment"] = slack_attachment
end
