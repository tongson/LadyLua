local F = string.format
local gmatch = string.gmatch

string.append = function(str, a)
  return F("%s\n%s", str, a)
end

string.line_to_list = function(str)
  local tbl = {}
  if not str then
    return tbl
  end
  for ln in gmatch(str, "([^\n]*)\n*") do
    tbl[#tbl + 1] = ln
  end
  return tbl
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
