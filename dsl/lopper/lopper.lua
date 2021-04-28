package.path = "./?.lua;modules/?.lua"
local DSL = "Lopper"
local ID = require("ksuid").new()
local json = require("json")
local util = require("util")
local logger = require("logger")
local unpack = unpack
local Notify_Toggle = {}
local Notify = function()
end
local Ok = function(msg, tbl)
	local stdout = logger.new("stdout")
	tbl._ident = DSL
	tbl._ksuid = ID
	stdout:info(msg, tbl)
end
local Panic = function(msg, tbl)
	local trace = function()
		local start_frame = 2
		local frame = start_frame
		local ln
		local src
		while true do
			local info = debug.getinfo(frame, "Sl")
			if not info then
				break
			end
			if info.what == "main" and info.source ~= "<string>" then
				ln = tostring(info.currentline)
				src = info.source
			end
			frame = frame + 1
		end
		return src, ln
	end
	local src, ln = trace()
	local stderr = logger.new()
	tbl._ident = DSL
	tbl._ksuid = ID
	tbl._line_number = ln
	tbl._source = src
	stderr:error(msg, tbl)
	Notify(msg, tbl)     --> notification on failure! Last cry before dying
	os.exit(1)
end
local Notify_Function = function(msg, tbl, bool)
	tbl = tbl or {}
	if bool then         --> If called as NOTIFY()
		Ok(msg, tbl)       --> will not execute during Panic()
	end
	tbl._ident = DSL
	tbl._ksuid = ID
	tbl.message = msg
	tbl.time = logger.time() --> Use similar timestamp from Go side
	local payload = json.encode(tbl)
	if Notify_Toggle.TELEGRAM then
		local telegram = require("telegram")
		local api = telegram.new()
		local send = util.retry_f(api.channel)
		send(api, Notify_Toggle.TELEGRAM, payload)
	end
	if Notify_Toggle.PUSHOVER then
		local pushover = require("pushover")
		local api = pushover.new()
		local send = util.retry_f(api.message)
		send(api, Notify_Toggle.PUSHOVER, payload)
	end
	if Notify_Toggle.SLACK then
		local slack = require("slack")
		local attachment = {
			Fallback = payload,
			Color = "#2eb886",
			AuthorName = tbl.name,
			AuthorSubname = tbl.message,
			AuthorLink = "https://github.com/tongson/LadyLua",
			AuthorIcon = "https://avatars2.githubusercontent.com/u/652790",
			Text = "```" .. payload .. "```",
			Footer = DSL,
			FooterIcon = "https://platform.slack-edge.com/img/default_application_icon.png",
		}
		local send = util.retry_f(slack.attachment)
		send(attachment)
	end
end
local Exec = function(exe, t)  --> Second argument is the metatable
	local fn = exec.ctx(exe)
	local msg = exe:upper()
	local set = {}
	fn.cwd = t.CWD
	fn.stdin = t.STDIN
	fn.env = t.ENV
	return setmetatable(set, {
		__call = function(_, a)
			local log = {}
			a = a or {}
			local r, so, se, err = fn(a)
			log.stdout = so
			log.stderr = se
			log.error = err
			if not r and not t.IGNORE then
				Panic(msg, log)
			else
				Ok(msg, log)
				t.CWD = nil
				t.STDIN = nil
				t.ENV = nil
				t.IGNORE = nil
			end
		end,
	})
end

local Cmd = function(exe)
	local set = {}
	return setmetatable(set, {
		__call = function(_, ...)
			local msg = exe:upper()
			local log = {}
			local a = {}
			if select("#", ...) == 1 then
				if type(...) == "table" then
					a = ...
				else
					Panic()
				end
			else
				a = {...}
			end
			local r, so, se, err = exec.command(exe, a, set.env, set.cwd, set.stdin)
			log.stdout = so
			log.stderr = se
			if not r and not set.IGNORE then
				log.error = err
				Panic(msg, log)
			else
				Ok(msg, log)
			end
		end,
	})
end

local ENV = {}
setmetatable(ENV, {
	__index = function(_, value)
		return rawget(_G, value) or Panic("Unknown command or variable", { string = value })
	end,
})
ENV.NOTIFY = setmetatable({}, {
	__call = function(_, msg, tbl)
		return Notify_Function(msg, tbl, true)
	end,
	__newindex = function(_, k, v)
		local key = k:upper()
		Notify_Toggle[key] = v
		Notify = Notify_Function
	end,
})
ENV.SH = setmetatable({}, {
	__newindex = function(t, k, v)
		rawset(t, k, v)    --> Use the metatable to store settings
	end,
	__call = function(t, sc)
		local sh = Exec("sh", t)
		sh({
			"-c",
			sc,
		})
	end,
})
ENV.SCRIPT = setmetatable({}, {
	__newindex = function(t, k, v)
		rawset(t, k, v)    --> Use the metatable to store settings
	end,
	__call = function(t, sc)
		local sh = Exec("sh", t)
		sh({
			sc,
		})
	end,
})
ENV.CMD = function(exe)
	return Cmd(exe)
end

getmetatable("").__mod = function(a, b)
	if not b then
		return a
	elseif type(b) == "table" then
		return a:format(unpack(b))
	else
		return a:format(b)
	end
end
setfenv(3, ENV)
return {
	Exec = Exec,
	Panic = Panic,
	Ok = Ok,
	Notify = Notify,
}
