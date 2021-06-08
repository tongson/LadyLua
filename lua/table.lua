do
	local type, setmetatable, ipairs, next, pairs, getmetatable =
		type, setmetatable, ipairs, next, pairs, getmetatable

	local gsub = string.gsub
	local find = string.find
	local insert = table.insert

	local _find
	_find = function(tbl, str, pattern)
		local plain = true
		if pattern then
			plain = nil
		end
		if type(tbl) == "table" then
			for key, tval in pairs(tbl) do
				if type(tval) == "string" then
					if find(tval, str, 1, plain) then
						return true, tostring(key)
					end
				else
					if tval == str then
						return true, tostring(key)
					end
				end
			end
			for key, tval in pairs(tbl) do
				local r, k = _find(tval, str, pattern)
				if r then
					return true, tostring(k)
				end
			end
		end
		return nil, "Value not found."
	end
	table.find = _find

	table.to_map = function(tbl, def, holes)
		def = def or true
		local t = {}
		if not holes then
			for n = 1, #tbl do
				t[tbl[n]] = def
			end
		else
			for _, v in next, tbl do
				t[v] = def
			end
		end
		return t
	end

	table.to_list = function(tbl)
		local t = {}
		for k, _ in pairs(tbl) do
			t[#t + 1] = k
		end
		return t
	end

	table.filter = function(tbl, patt, pattern)
		local plain = true
		if pattern then
			plain = nil
		end
		local s, c = #tbl, 0
		for n = 1, s do
			if find(tbl[n], patt, 1, plain) then
				tbl[n] = nil
			end
		end
		for n = 1, s do
			if tbl[n] ~= nil then
				c = c + 1
				tbl[c] = tbl[n]
			end
		end
		for n = c + 1, s do
			tbl[n] = nil
		end
		return tbl
	end

	table.insert_if = function(list, bool, value, pos)
		local len = #list
		local fin = len + 1
		pos = pos or fin
		if bool then
			if type(value) == "table" then
				local p = pos - 1
				if pos == fin then
					for n, i in ipairs(value) do
						insert(list, len + n, i)
					end
				else
					for n, i in ipairs(value) do
						insert(list, p + n, i)
					end
				end
			else
				if pos == fin then
					insert(list, value)
				else
					insert(list, pos, value)
				end
			end
		end
	end

	local autotable
	local auto_meta = {
		__index = function(t, k)
			t[k] = autotable()
			return t[k]
		end,
	}
	autotable = function(t)
		t = t or {}
		local meta = getmetatable(t)
		if meta then
			assert(
				not meta.__index or meta.__index == auto_meta.__index,
				"__index already set"
			)
			meta.__index = auto_meta.__index
		else
			setmetatable(t, auto_meta)
		end
		return t
	end
	table.auto = autotable

	table.size = function(t, maxn)
		local n = 0
		if maxn then
			for _ in next, t do
				n = n + 1
				if n >= maxn then
					break
				end
			end
		else
			for _ in next, t do
				n = n + 1
			end
		end
		return n
	end

	local count = function(t, i)
		local n = 0
		for _, v in next, t do
			if i == v and not (v == nil) then
				n = n + 1
			end
		end
		return n
	end
	table.count = count

	table.unique = function(t)
		local nt = {}
		local n = 0
		for _, v in next, t do
			if count(nt, v) == 0 then
				n = n + 1
				nt[n] = v
			end
		end
		return nt
	end
	local clone
	clone = function(obj, seen)
		if type(obj) ~= "table" then
			return obj
		end
		if seen and seen[obj] then
			return seen[obj]
		end
		local s = seen or {}
		local res = {}
		s[obj] = res
		for k, v in next, obj do
			res[clone(k, s)] = clone(v, s)
		end
		return setmetatable(res, getmetatable(obj))
	end
	table.clone = clone
end
