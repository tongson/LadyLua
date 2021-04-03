local type, pcall, setmetatable, error = type, pcall, setmetatable, error
local date = os.date
local F = string.format

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
    s = string.format("%s%s%s", s, tostring(self[n]), c)
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

local splitpath = function(path)
  local l = string.len(path)
  local c = string.sub(path, l, l)
  while l > 0 and c ~= "/" do
    l = l - 1
    c = string.sub(path, l, l)
  end
  if l == 0 then
    return '', path
  else
    return string.sub(path, 1, l - 1), string.sub(path, l + 1)
  end
end

local template = function(s, v)
  return (string.gsub(s, "%${[%s]-([^}%G]+)[%s]-}", v))
end

local truthy = function(s)
  local _
  _, s = pcall(string.lower, s)
  if s == "yes" or s == "true" or s == "on" or s == "1" then
    return true
  else
    return false
  end
end

local falsy = function(s)
  local _
  _, s = pcall(string.lower, s)
  if s == "no" or s == "false" or s == "off" or s == "0" then
    return true
  else
    return false
  end
end

local escape_quotes = function(str)
  str = string.gsub(str, [["]], [[\"]])
  str = string.gsub(str, [[']], [[\']])
  return str
end

local month = function(n)
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

local return_if = function(bool, value)
  if bool then
    return (value)
  end
end

local return_if_not = function(bool, value)
  if bool == false or bool == nil then
    return value
  end
end

-- From: http://lua-users.org/wiki/HexDump
-- [first] begin dump at 16 byte-aligned offset containing 'first' byte
-- [last] end dump at 16 byte-aligned offset containing 'last' byte
local hexdump = function(buf, first, last)
  local function align(n)
    return math.ceil(n/16) * 16
  end
  for i=(align((first or 1)-16)+1),align(math.min(last or #buf,#buf)) do
    if (i-1) % 16 == 0 then
      io.write(F('%08X  ', i-1))
    end
    io.write( i > #buf and '   ' or F('%02X ', buf:byte(i)) )
    if i %  8 == 0 then
      io.write(' ')
    end
    if i % 16 == 0 then
      io.write( buf:sub(i-16+1, i):gsub('%c','.'), '\n' )
    end
  end
end

local escape_sql = function(v)
  local vt = type(v)
  if "string" == vt then
    local s = "'" .. (v:gsub("'", "''")) .. "'"
    return (s:gsub('.', {
      [string.char(0)] = "",
      [string.char(9)] = "",
      [string.char(10)] = "",
      [string.char(11)] = "",
      [string.char(12)] = "",
      [string.char(13)] = "",
      [string.char(14)] = "",
    }))
  elseif "boolean" == vt then
    return v and "TRUE" or "FALSE"
  end
end

local assert_f = function(fn)
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

local try_f = function(fn)
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

local hm = function()
  return date("%H:%M")
end

local ymd = function()
  return date("%Y-%m-%d")
end

local timestamp = function()
  return date("%Y-%m-%d %H:%M:%S %Z%z")
end

return {
  hm = hm,
  ymd = ymd,
  timestamp = timestamp,
  assert_f = assert_f,
  try_f = try_f,
  month = month,
  truthy = truthy,
  falsy = falsy,
  return_if = return_if,
  return_if_not = return_if_not,
  splitpath = splitpath,
  escape_sql = escape_sql,
  ring = ring,
  hexdump = hexdump,
  escape_quotes = escape_quotes,
  template = template,
}
