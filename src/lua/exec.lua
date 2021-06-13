exec.ctx = function(exe)
	local set = {}
	return setmetatable(set, {
		__call = function(_, args)
			args = args or {}
			return exec.command(exe, args, set.env, set.cwd, set.stdin, set.timeout)
		end,
	})
end

exec.cmd = function(exe)
	local format, len, gsub, gmatch =
		string.format, string.len, string.gsub, string.gmatch
	local set = {}
	return setmetatable(set, {
		__call = function(_, a, ...)
			local args
			if a and type(a) == "string" then
				local ergs = format(a, ...)
				args = {}
				for k in gmatch(ergs, "%S+") do
					args[#args + 1] = k
				end
			end
			if a and type(a) == "table" then
				args = a
			end
			local r, so, se, cerr = exec.command(exe, args, set.env, set.cwd, set.stdin, set.timeout)
			local pretty_prefix = function(header, prefix, str)
				local n
				if len(str) > 0 then
					local replacement = format("\n %s > ", prefix)
					str, n = gsub(str, "\n", replacement)
					if n == 0 then
						str = str .. ("\n %s > "):format(prefix)
					end
					return format("%s\n %s >\n %s > %s\n", header, prefix, prefix, str)
				else
					return ""
				end
			end
			if set.errexit == true and r == nil then
				local err = cerr or set.error or "execution failed"
				local header = format('exec.cmd: `%s` => "%s"', exe, err)
				if len(so) < 1 and len(se) < 1 then
					return fmt.panic("%s\n", header)
				else
					fmt.print("%s", pretty_prefix(header, "stdout", so))
					return fmt.panic("%s", pretty_prefix(header, "stderr", se))
				end
			else
				return r, so, se
			end
		end,
	})
end

exec.run = setmetatable({}, {
	__index = function(_, exe)
		return function(...)
			local args
			if not (...) then
				args = {}
			elseif type(...) == "table" then
				args = ...
			else
				args = { ... }
			end
			return exec.command(exe, args)
		end
	end,
})
