package.path = "./?.lua;modules/?.lua"
local DSL = "lopper"
local ID = require("ksuid").new()
local json = require("json")
local util = require("util")
local logger = require("logger")
local Notify_Toggle = {}
local Notify = function()
end
local Ok = function(msg, tbl)
	local stdout = logger.new("stdout")
	tbl._ident = DSL
	tbl._ksuid = ID
	stdout:info(msg, tbl)
end
local Warn = function(msg, tbl)
	local stderr = logger.new()
	tbl._ident = DSL
	tbl._ksuid = ID
	stderr:warn(msg, tbl)
end
local Debug = function(msg, tbl)
	local stdout = logger.new("stdout")
	tbl._ident = DSL
	tbl._ksuid = ID
	stdout:debug(msg, tbl)
end
local Panic = function(msg, tbl)
	local trace = function()
		local frame = 1
		local stack = {}
		while true do
			local info = debug.getinfo(frame, "Sl")
			if not info then
				break
			end
			if info.source ~= "<string>" and info.currentline ~= -1 then
				if info.source and info.currentline then
					stack[#stack + 1] = info.source .. ":" .. tostring(info.currentline)
				end
			end
			frame = frame + 1
		end
		local xstack = {}
		for i = #stack, 1, -1 do
			xstack[#xstack + 1] = stack[i]
		end
		return table.concat(xstack, " → ")
	end
	local stderr = logger.new()
	tbl._ident = DSL
	tbl._ksuid = ID
	tbl.stack = trace()
	stderr:error(msg, tbl)
	Notify(msg, tbl) --> notification on failure! Last cry before dying
	os.exit(1)
end
local InterfaceAddr = function(interface, ver)
	ver = ver or "inet"
	local ip = exec.ctx("ip")
	local ret, so, se = ip({ "-j", "addr" })
	if not ret then
		Panic("ip(8) command failed.", {
			command = "ip",
			fn = "InterfaceAddr",
			stdout = so,
			stderr = se,
		})
	end
	local j = json.decode(so)
	for _, v in ipairs(j) do
		if v.ifname == interface then
			for _, vv in ipairs(v["addr_info"]) do
				if vv.family == ver then
					return vv["local"]
				end
			end
		end
	end
	Panic("Interface not found.", {
		fn = "InterfaceAddr",
	})
end
local Notify_Function = function(msg, tbl, bool)
	tbl = tbl or {}
	if bool then --> If called as NOTIFY()
		Ok(msg, tbl) --> will not execute during Panic()
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
local Exec = function(exe, t) --> Second argument is the metatable
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

local Command = function(exe)
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
				a = { ... }
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

_G["Notify"] = setmetatable({}, {
	__call = function(_, msg, tbl)
		return Notify_Function(msg, tbl, true)
	end,
	__newindex = function(_, k, v)
		local key = k:upper()
		Notify_Toggle[key] = v
		Notify = Notify_Function
	end,
})
_G["Shell"] = setmetatable({}, {
	__newindex = function(t, k, v)
		rawset(t, k, v) --> Use the metatable to store settings
	end,
	__call = function(t, sc)
		local sh = Exec("sh", t)
		sh({
			"-c",
			sc,
		})
	end,
})
_G["Script"] = setmetatable({}, {
	__newindex = function(t, k, v)
		rawset(t, k, v) --> Use the metatable to store settings
	end,
	__call = function(t, sc)
		local sh = Exec("sh", t)
		sh({
			sc,
		})
	end,
})
_G["Command"] = Command
_G["InterfaceAddr"] = InterfaceAddr
package.preload["lopper"] = function()
	return {
		panic = Panic,
		ok = Ok,
		warn = Warn,
		debug = Debug,
		notify = Notify,
		id = ID,
	}
end
util.format_operator()
