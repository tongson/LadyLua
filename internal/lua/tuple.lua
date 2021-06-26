-- =========================================
-- tuple, A minimal tuple class for Lua
-- Copyright (c) 2013 Roland Y., MIT License
-- v0.2.0 - compatible Lua 5.1, 5.2, 5.3
-- =========================================

local unpack = unpack or table.unpack
local setmetatable = setmetatable
local ipairs = ipairs
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
--tuple.__index = tuple

-- Collects values i to j to return a new tuple
function tuple.__call(t,i,j)
  return tuple(unpack(t,i,j))
end

-- Returns a string representation of tuple
function tuple:__tostring()
  local t = self:contents()
  for k,v in ipairs(t) do
    t[k] = tostring(v)
  end
  return ('(%s)'):format(t_concat(t,', '))
end

-- Tuple elements iterator function
function tuple:elements(...)
  local i = 0
  return function(...)
    i = i + 1
    if self[i]~=nil then
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
  for k,_v in ipairs(self) do
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
  for _,element in other:elements() do
    if not self:has(element) then
      return false
    end
  end
  return true
end

-- Converts tuple to simpe array ?
function tuple:contents()
  return _clone(self)
end

-- ==========
-- Operators
-- ==========

-- Tuple equality test
function tuple:__eq(other)
  if self.n ~= other.n then
    return false
  end
  for i,element in other:elements() do
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
    if (self[i] > other[i]) then
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
  local t = a()
  for _,element in b:elements() do
    t[#t+1] = element
  end
  t.n = #t
  return t
end

-- Multiplication
function tuple.__mul(t,n)
  if type(n) == 'number' then
    assert(math.floor(n) == n,
      ('Wrong argument n. Integer expected, got (%s)'):format(n))
    local _t
    for i = 1, n do
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
    local new_tuple = _clone{n = select('#',...), ...}
    tbl.__index =  tbl
    return setmetatable(new_tuple, tbl)
  end,
})
