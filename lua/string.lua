do
	local F = string.format
	local gmatch = string.gmatch
	local find = string.find
	local sub = string.sub
	local reverse = string.reverse
	local gsub = string.gsub
	local append = table.insert
	local unpack = unpack
	local escape = function(s)
		return (gsub(s, "[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1"))
	end
	local _strip = function(s, left, right, chrs)
		if not chrs then
			chrs = "%s"
		else
			chrs = "[" .. escape(chrs) .. "]"
		end
		local f = 1
		local t
		if left then
			local i1, i2 = find(s, "^" .. chrs .. "*")
			if i2 >= i1 then
				f = i2 + 1
			end
		end
		if right then
			if #s < 200 then
				local i1, i2 = find(s, chrs .. "*$", f)
				if i2 >= i1 then
					t = i1 - 1
				end
			else
				local rs = reverse(s)
				local i1, i2 = find(rs, "^" .. chrs .. "*")
				if i2 >= i1 then
					t = -i2
				end
			end
		end
		return sub(s, f, t)
	end

	string.trim_start = function(s, chrs)
		return _strip(s, true, false, chrs)
	end

	string.trim_end = function(s, chrs)
		return _strip(s, false, true, chrs)
	end

	string.split = function(s, re, plain, n)
		local i1, ls = 1, {}
		if not re then
			re = "%s+"
		end
		if re == "" then
			return { s }
		end
		while true do
			local i2, i3 = find(s, re, i1, plain)
			if not i2 then
				local last = sub(s, i1)
				if last ~= "" then
					append(ls, last)
				end
				if #ls == 1 and ls[1] == "" then
					return {}
				else
					return ls
				end
			end
			append(ls, sub(s, i1, i2 - 1))
			if n and #ls == n then
				ls[#ls] = sub(s, i1)
				return ls
			end
			i1 = i3 + 1
		end
	end

	string.splitv = function(s, re, plain, n)
		return unpack(string.split(s, re, plain, n))
	end

	string.contains = function(str, a)
		return find(str, a, 1, true)
	end

	string.append = function(str, a)
		return F("%s\n%s", str, a)
	end

	string.word_to_list = function(str)
		local t = {}
		for s in gmatch(str, "%w+") do
			t[#t + 1] = s
		end
		return t
	end

	string.to_list = function(str)
		local t = {}
		for s in gmatch(str, "%S+") do
			t[#t + 1] = s
		end
		return t
	end

	string.to_map = function(str, def)
		def = def or true
		local t = {}
		for s in gmatch(str, "%S+") do
			t[s] = def
		end
		return t
	end
end
