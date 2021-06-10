local util = {}

local type, pcall, setmetatable, error = type, pcall, setmetatable, error
local date = os.date
local F = string.format
local len = string.len
local sub = string.sub
local gsub = string.gsub
local tostring = tostring
local lower = string.lower
local tonumber = tonumber
local ceil = math.ceil
local min = math.min
local write = io.write
local char = string.char

local ring = {}
function ring.new(max_size)
	local hist = { __index = ring }
	setmetatable(hist, hist)
	hist.max_size = max_size
	hist.size = 0
	hist.cursor = 1
	return hist
end
function ring:concat(c)
	local s = ""
	for n = 1, #self do
		s = F("%s%s%s", s, tostring(self[n]), c)
	end
	return s
end
function ring:table()
	local t = {}
	for n = 1, #self do
		t[n] = tostring(self[n])
	end
	return t
end
function ring:push(value)
	if self.size < self.max_size then
		table.insert(self, value)
		self.size = self.size + 1
	else
		self[self.cursor] = value
		self.cursor = self.cursor % self.max_size + 1
	end
end
function ring:iterator()
	local i = 0
	return function()
		i = i + 1
		if i <= self.size then
			return self[(self.cursor - i - 1) % self.size + 1]
		end
	end
end

util.ring = ring
util.format_operator = function()
	local format = string.format

	local is_callable = function(obj)
		return type(obj) == "function"
			or getmetatable(obj)
			and getmetatable(obj).__call
			and true
	end

	local substitute = function(s, tbl)
		local subst
		if is_callable(tbl) then
			subst = tbl
		else
			function subst(f)
				local str = tbl[f]
				if not str then
					return f
				else
					return str
				end
			end
		end
		local res = gsub(s, "%${([%w_]+)}", subst)
		return (gsub(res, "%$([%w_]+)", subst))
	end

	-- a more forgiving version of string.format, which applies
	-- tostring() to any value with a %s format.
	local formatx = function(fmt, ...)
		local args = { ... }
		local i = 1
		for p in fmt:gmatch("%%.") do
			if p == "%s" and type(args[i]) ~= "string" then
				args[i] = tostring(args[i])
			end
			i = i + 1
		end
		return format(fmt, unpack(args))
	end

	local basic_subst = function(s, t)
		return (s:gsub("%$([%w_]+)", t))
	end

	-- Note this goes further than the original, and will allow these cases:
	-- 1. a single value
	-- 2. a list of values
	-- 3. a map of var=value pairs
	-- 4. a function, as in gsub
	-- For the second two cases, it uses $-variable substituion.
	getmetatable("").__mod = function(a, b)
		if b == nil then
			return a
		elseif type(b) == "table" and getmetatable(b) == nil then
			if #b == 0 then -- assume a map-like table
				return substitute(a, b, true)
			else
				return formatx(a, unpack(b))
			end
		elseif type(b) == "function" then
			return basic_subst(a, b)
		else
			return formatx(a, b)
		end
	end
end
util.path_split = function(path)
	local l = len(path)
	local c = sub(path, l, l)
	while l > 0 and c ~= "/" do
		l = l - 1
		c = sub(path, l, l)
	end
	if l == 0 then
		return nil, path
	else
		return sub(path, 1, l - 1), sub(path, l + 1)
	end
end
util.split_at_char = function(str, ch)
	local l = str:len()
	local c = str:sub(l, l)
	while l > 0 and c ~= ch do
		l = l - 1
		c = str:sub(l, l)
	end
	if l == 0 then
		return nil, str
	else
		return str:sub(1, l - 1), str:sub(l + 1)
	end
end

util.path_apply = function(fn, dir)
	local t = {}
	local f, m
	while util.path_split(dir) do
		dir, f = util.path_split(dir)
		t[#t + 1] = f
		if dir == nil then
			break
		end
	end
	f = ""
	for n = #t, 1, -1 do
		m = F("/%s", t[n])
		f = f .. m
		fn(f)
	end
	return true
end

util.template = function(s, v)
	return (gsub(s, "%${[%s]-([^}%G]+)[%s]-}", v))
end

util.truthy = function(s)
	local _
	_, s = pcall(lower, s)
	if s == "yes" or s == "true" or s == "on" or s == "1" then
		return true
	else
		return nil
	end
end

util.falsy = function(s)
	local _
	_, s = pcall(lower, s)
	if s == "no" or s == "false" or s == "off" or s == "0" then
		return true
	else
		return nil
	end
end

util.escape_quotes = function(str)
	str = gsub(str, [["]], [[\"]])
	str = gsub(str, [[']], [[\']])
	return str
end

util.month = function(n)
	n = tostring(n)
	if n[1] == "0" then
		n = n[2]
	end
	n = tonumber(n)
	local t = {
		"Jan",
		"Feb",
		"Mar",
		"Apr",
		"May",
		"Jun",
		"Jul",
		"Aug",
		"Sep",
		"Oct",
		"Nov",
		"Dec",
	}
	return t[n]
end

util.return_if = function(bool, value)
	if bool then
		return value
	end
end

util.return_if_not = function(bool, value)
	if bool == false or bool == nil then
		return value
	end
end

-- From: http://lua-users.org/wiki/HexDump
-- [first] begin dump at 16 byte-aligned offset containing 'first' byte
-- [last] end dump at 16 byte-aligned offset containing 'last' byte
util.hexdump = function(buf, first, last)
	local function align(n)
		return ceil(n / 16) * 16
	end
	for i = (align((first or 1) - 16) + 1), align(min(last or #buf, #buf)) do
		if (i - 1) % 16 == 0 then
			write(F("%08X  ", i - 1))
		end
		io.write(i > #buf and "   " or F("%02X ", buf:byte(i)))
		if i % 8 == 0 then
			write(" ")
		end
		if i % 16 == 0 then
			write(buf:sub(i - 16 + 1, i):gsub("%c", "."), "\n")
		end
	end
end

util.escape_sql = function(v)
	local vt = type(v)
	if "string" == vt then
		local s = "'" .. (v:gsub("'", "''")) .. "'"
		return (s:gsub(".", {
			[char(0)] = "",
			[char(9)] = "",
			[char(10)] = "",
			[char(11)] = "",
			[char(12)] = "",
			[char(13)] = "",
			[char(14)] = "",
		}))
	elseif "boolean" == vt then
		return v and "TRUE" or "FALSE"
	end
end

util.assert_f = function(fn)
	return function(ok, ...)
		if ok then
			return ok, ...
		else
			if fn then
				fn(...)
			end
			error((...), 0)
		end
	end
end

util.try_f = function(fn)
	return function(ok, ...)
		if ok then
			return ok, ...
		else
			if fn then
				return fn(...)
			end
		end
	end
end

util.sleep = function(s)
	local time = os.time
	local nt = time() + s
	repeat
	until time() > nt
end

util.retry_f = function(fn, t)
	t = t or 3
	local wait = 2
	return function(...)
		local values = { fn(...) }
		local r = 0
		while not values[1] do
			if r == t then
				break
			end
			r = r + 1
			util.sleep(wait+r)
			values = { fn(...) }
		end
		return unpack(values)
	end
end

util.trim_leading = function(s, l)
	local n = 1
	local c = sub(s, n, n)
	while c == l do
		n = n + 1
		c = sub(s, n, n)
	end
	return sub(s, n)
end

-- Add to target in place and return added items
util.append_to_list = function(target, a)
	local t = {}
	for k in a:gmatch("%S+") do
		target[#target + 1] = k
		t[#t + 1] = k
	end
	return t
end

util.hm = function()
	return date("%H:%M")
end

util.ymd = function()
	return date("%Y-%m-%d")
end

util.timestamp = function()
	return date("%Y-%m-%d %H:%M:%S %Z%z")
end

local arglist_mt = {}

-- have pack/unpack both respect the 'n' field
local _unpack = unpack
local unpack = function(t, i, j)
	return _unpack(t, i or 1, j or t.n or #t)
end
local pack = function(...)
	return { n = select("#", ...), ... }
end
util.pack = pack
util.unpack = unpack

function util.deepcompare(t1, t2, ignore_mt, cycles, thresh1, thresh2)
	local ty1 = type(t1)
	local ty2 = type(t2)
	-- non-table types can be directly compared
	if ty1 ~= "table" or ty2 ~= "table" then
		return t1 == t2
	end
	local mt1 = debug.getmetatable(t1)
	local mt2 = debug.getmetatable(t2)
	-- would equality be determined by metatable __eq?
	if mt1 and mt1 == mt2 and mt1.__eq then
		-- then use that unless asked not to
		if not ignore_mt then
			return t1 == t2
		end
	else -- we can skip the deep comparison below if t1 and t2 share identity
		if rawequal(t1, t2) then
			return true
		end
	end

	-- handle recursive tables
	cycles = cycles or { {}, {} }
	thresh1, thresh2 = (thresh1 or 1), (thresh2 or 1)
	cycles[1][t1] = (cycles[1][t1] or 0)
	cycles[2][t2] = (cycles[2][t2] or 0)
	if cycles[1][t1] == 1 or cycles[2][t2] == 1 then
		thresh1 = cycles[1][t1] + 1
		thresh2 = cycles[2][t2] + 1
	end
	if cycles[1][t1] > thresh1 and cycles[2][t2] > thresh2 then
		return true
	end

	cycles[1][t1] = cycles[1][t1] + 1
	cycles[2][t2] = cycles[2][t2] + 1

	for k1, v1 in next, t1 do
		local v2 = t2[k1]
		if v2 == nil then
			return false, { k1 }
		end

		local same, crumbs = util.deepcompare(v1, v2, nil, cycles, thresh1, thresh2)
		if not same then
			crumbs = crumbs or {}
			table.insert(crumbs, k1)
			return false, crumbs
		end
	end
	for k2, _ in next, t2 do
		-- only check whether each element has a t1 counterpart, actual comparison
		-- has been done in first loop above
		if t1[k2] == nil then
			return false, { k2 }
		end
	end

	cycles[1][t1] = cycles[1][t1] - 1
	cycles[2][t2] = cycles[2][t2] - 1

	return true
end

function util.shallowcopy(t)
	if type(t) ~= "table" then
		return t
	end
	local copy = {}
	setmetatable(copy, getmetatable(t))
	for k, v in next, t do
		copy[k] = v
	end
	return copy
end

-----------------------------------------------
-- Clear an arguments or return values list from a table
-- @param arglist the table to clear of arguments or return values and their count
-- @return No return values
function util.cleararglist(arglist)
	for idx = arglist.n, 1, -1 do
		util.tremove(arglist, idx)
	end
	arglist.n = nil
end

-----------------------------------------------
-- table.insert() replacement that respects nil values.
-- The function will use table field 'n' as indicator of the
-- table length, if not set, it will be added.
-- @param t table into which to insert
-- @param pos (optional) position in table where to insert. NOTE: not optional if you want to insert a nil-value!
-- @param val value to insert
-- @return No return values
function util.tinsert(...)
	-- check optional POS value
	local args = { ... }
	local c = select("#", ...)
	local t = args[1]
	local pos = args[2]
	local val = args[3]
	if c < 3 then
		val = pos
		pos = nil
	end
	-- set length indicator n if not present (+1)
	t.n = (t.n or #t) + 1
	if not pos then
		pos = t.n
	elseif pos > t.n then
		-- out of our range
		t[pos] = val
		t.n = pos
	end
	-- shift everything up 1 pos
	for i = t.n, pos + 1, -1 do
		t[i] = t[i - 1]
	end
	-- add element to be inserted
	t[pos] = val
end
-----------------------------------------------
-- table.remove() replacement that respects nil values.
-- The function will use table field 'n' as indicator of the
-- table length, if not set, it will be added.
-- @param t table from which to remove
-- @param pos (optional) position in table to remove
-- @return No return values
function util.tremove(t, pos)
	-- set length indicator n if not present (+1)
	t.n = t.n or #t
	if not pos then
		pos = t.n
	elseif pos > t.n then
		local removed = t[pos]
		-- out of our range
		t[pos] = nil
		return removed
	end
	local removed = t[pos]
	-- shift everything up 1 pos
	for i = pos, t.n do
		t[i] = t[i + 1]
	end
	-- set size, clean last
	t[t.n] = nil
	t.n = t.n - 1
	return removed
end

-----------------------------------------------
-- Checks an element to be callable.
-- The type must either be a function or have a metatable
-- containing an '__call' function.
-- @param object element to inspect on being callable or not
-- @return boolean, true if the object is callable
function util.callable(object)
	return type(object) == "function"
		or type((debug.getmetatable(object) or {}).__call) == "function"
end
-----------------------------------------------
-- Checks an element has tostring.
-- The type must either be a string or have a metatable
-- containing an '__tostring' function.
-- @param object element to inspect on having tostring or not
-- @return boolean, true if the object has tostring
function util.hastostring(object)
	return type(object) == "string"
		or type((debug.getmetatable(object) or {}).__tostring) == "function"
end

-----------------------------------------------
-- Find the first level, not defined in the same file as the caller's
-- code file to properly report an error.
-- @param level the level to use as the caller's source file
-- @return number, the level of which to report an error
function util.errorlevel(level)
	level = (level or 1) + 1 -- add one to get level of the caller
	local info = debug.getinfo(level)
	local source = (info or {}).source
	local file = source
	while file and (file == source or source == "=(tail call)") do
		level = level + 1
		info = debug.getinfo(level)
		source = (info or {}).source
	end
	if level > 1 then
		level = level - 1
	end -- deduct call to errorlevel() itself
	return level
end

-----------------------------------------------
-- store argument list for return values of a function in a table.
-- The table will get a metatable to identify it as an arglist
function util.make_arglist(...)
	local arglist = { ... }
	arglist.n = select("#", ...) -- add values count for trailing nils
	return setmetatable(arglist, arglist_mt)
end

-----------------------------------------------
-- check a table to be an arglist type.
function util.is_arglist(object)
	return getmetatable(object) == arglist_mt
end

return util
