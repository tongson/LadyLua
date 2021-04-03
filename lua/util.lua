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
  for n=1, #self do
    s = F("%s%s%s", s, tostring(self[n]), c)
  end
  return s
end
function ring:table()
  local t = {}
  for n=1, #self do
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
util.path_split = function(path)
  local l = len(path)
  local c = sub(path, l, l)
  while l > 0 and c ~= "/" do
    l = l - 1
    c = sub(path, l, l)
  end
  if l == 0 then
    return '', path
  else
    return sub(path, 1, l - 1), sub(path, l + 1)
  end
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
    return false
  end
end

util.falsy = function(s)
  local _
  _, s = pcall(lower, s)
  if s == "no" or s == "false" or s == "off" or s == "0" then
    return true
  else
    return false
  end
end

util.escape_quotes = function(str)
  str = gsub(str, [["]], [[\"]])
  str = gsub(str, [[']], [[\']])
  return str
end

util.month = function(n)
  n = tostring(n)
  if n[1] == '0' then
    n = n[2]
  end
  n = tonumber(n)
  local t = {
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  }
  return t[n]
end

util.return_if = function(bool, value)
  if bool then
    return (value)
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
    return ceil(n/16) * 16
  end
  for i=(align((first or 1)-16)+1),align(min(last or #buf,#buf)) do
    if (i-1) % 16 == 0 then
      write(F('%08X  ', i-1))
    end
    io.write( i > #buf and '   ' or F('%02X ', buf:byte(i)) )
    if i %  8 == 0 then
      write(' ')
    end
    if i % 16 == 0 then
      write( buf:sub(i-16+1, i):gsub('%c','.'), '\n' )
    end
  end
end

util.escape_sql = function(v)
  local vt = type(v)
  if "string" == vt then
    local s = "'" .. (v:gsub("'", "''")) .. "'"
    return (s:gsub('.', {
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

util.hm = function()
  return date("%H:%M")
end

util.ymd = function()
  return date("%Y-%m-%d")
end

util.timestamp = function()
  return date("%Y-%m-%d %H:%M:%S %Z%z")
end

