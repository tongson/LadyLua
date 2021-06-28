-- =========================================
-- tuple, A minimal tuple class for Lua
-- Copyright (c) 2013 Roland Y., MIT License
-- v0.2.0 - compatible Lua 5.1, 5.2, 5.3
-- 2021 LadyLua modifications
-- =========================================

local unpack = unpack
local setmetatable = setmetatable
local tostring = tostring
local min = math.min
local type = type
local assert = assert
local select = select
local t_concat = table.concat

local _clone
_clone = function(obj, seen)
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
		res[_clone(k, s)] = _clone(v, s)
	end
	return setmetatable(res, getmetatable(obj))
end

_readonly = function(t)
	return setmetatable({}, {
		__index = t,
		__newindex = function()
			return error("Attempt to modify read-only table", 0)
		end,
		__metatable = false,
	})
end

local tuple = {}
tuple.__index = tuple

-- Collects values i to j to return a new tuple
function tuple.__call(t, i, j)
	j = j or t.n
	return tuple(unpack(t, i, j))
end

-- Returns a string representation of tuple
function tuple:__tostring()
	local t = {}
	for k, v in self:iterator() do
		t[k] = tostring(v)
	end
	return ("(%s)"):format(t_concat(t, ", "))
end

-- Tuple iterator function
function tuple:iterator()
	local m = self.n
	local i = 0
	return function()
		i = i + 1
		while i <= m do
			return i, self[i]
		end
	end
end

-- Returns tuple length
function tuple:size()
	return self.n
end

-- Tests if tuple contains element v
function tuple:has(v)
	for _, _v in self:iterator() do
		if _v == v then
			return true
		end
	end
	return false
end

-- Does this tuple includes all elements in tuple other ?
function tuple:includes(other)
	if self.n < other.n then
		return false
	end
	for _, element in other:iterator() do
		if not self:has(element) then
			return false
		end
	end
	return true
end

-- Converts tuple to simpe array ?
function tuple:contents()
	return _readonly(_clone(self))
end

-- ==========
-- Operators
-- ==========

-- Tuple equality test
function tuple:__eq(other)
	if self.n ~= other.n then
		return false
	end
	for i, element in other:iterator() do
		if element ~= self[i] then
			return false
		end
	end
	return true
end

-- Tuple relational <= comparison
function tuple:__le(other)
	local n = min(self.n, other.n)
	for i = 1, n do
		if self[i] > other[i] then
			return false
		end
	end
	return true
end

-- Tuple relational < comparison
function tuple:__lt(other)
	local n = min(self.n, other.n)
	for i = 1, n do
		if self[i] >= other[i] then
			return false
		end
	end
	return true
end

-- Tuple addition
function tuple.__add(a, b)
	local t = {}
	for i, element in a:iterator() do
		t[i] = element
	end
	for i, element in b:iterator() do
		t[a.n+i] = element
	end
	local m = a.n + b.n
	t.n = m
	return tuple(unpack(t, 1, m))
end

-- Multiplication
function tuple.__mul(t, n)
	if type(n) == "number" then
		assert(math.floor(n) == n, ("Wrong argument n. Integer expected, got (%s)"):format(n))
		local _t
		for _ = 1, n do
			_t = (_t or tuple()) + t
		end
		return _t
	else
		return n * t
	end
end

function tuple.__newindex()
	error("Attempted to add value to tuple.", 0)
end

-- Class constructor, wrapping up and return
return setmetatable(tuple, {
	__call = function(tbl, ...)
		-- LadyLua modification; clone() to make tables passed immutable.
		return setmetatable(_clone({ n = select("#", ...), ... }), tbl)
	end,
})
