local type, setmetatable, ipairs, next, pairs, getmetatable =
      type, setmetatable, ipairs, next, pairs, getmetatable

local gsub = string.gsub
local find = string.find
local insert = table.insert

table.find = function(tbl, str, plain)
  for _, tval in next, tbl do
    tval = gsub(tval, '[%c]', '')
    if find(tval, str, 1, plain) then
      return true
    end
  end
  return false
end

table.to_map = function(tbl, def)
  def = def or true
  local t = {}
  for n = 1, #tbl do
    t[tbl[n]] = def
  end
  return t
end

table.to_list = function(tbl)
  local t = {}
  for k, _ in pairs(tbl) do
    t[#t+1] = k
  end
  return t
end

table.filter = function(tbl, patt, plain)
  plain = plain or nil
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

table.insert_if = function(bool, list, pos, value)
  if bool then
    if type(value) == "table" then
      for n, i in ipairs(value) do
        local p = n - 1
        insert(list, pos + p, i)
      end
    else
      if pos == -1 then
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
  end
}
autotable = function(t)
  t = t or {}
  local meta = getmetatable(t)
  if meta then
    assert(not meta.__index or meta.__index == auto_meta.__index, "__index already set")
    meta.__index = auto_meta.__index
  else
    setmetatable(t, auto_meta)
  end
  return t
end
table.autotable = autotable

table.len = function(t, maxn)
  local n = 0
  if maxn then
    for _ in pairs(t) do
      n = n + 1
      if n >= maxn then break end
    end
  else
    for _ in pairs(t) do
      n = n + 1
    end
  end
  return n
end

local count = function(t, i)
  local n = 0
  for _, v in pairs(t) do
    if i == v then
      n = n + 1
    end
  end
  return n
end
table.count = count

table.unique = function(t)
  local nt = {}
  for _, v in pairs(t) do
    if count(nt, v) == 0 then
      nt[#nt+1] = v
    end
  end
  return nt
end
