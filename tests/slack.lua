local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
local slack = require("slack")
--# = slack
--# :toc:
--# :toc-placement!:
--#
--# Wrapper for the Slack API.
--#
--# toc::[]
--#
--# == *slack.webhook*(_Table_) -> _Boolean_
--# Send webhook containing values from the argument. Requires the string after the `https://hooks.slack.com/services/` URL in the `SLACK_WEBHOOK` environment variable.
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
local slack_webhook = function()
  T.is_function(slack.webhook)
end
if included then
  return function()
    T["slack.webhook"] = slack_webhook
  end
else
  T["slack.webhook"] = slack_webhook
end
