--- Bimap implementation by Pierre 'catwell' Chapuis
--- MIT licensed (see LICENSE.txt)

local _newindex = function(l, r)
  return function(t, k, v)
    if v ~= nil then
      if r[v] then
        error(
          string.format(
            "cannot assign value %q to key %q: already assigned to key %q",
            tostring(v), tostring(k), tostring(r[v])
          ),
          2
        )
      end
      r[v] = k
    end
    if l[k] ~= nil then r[l[k]] = nil end
    l[k] = v
  end
end

local _call = function(l, r)
  return function(t, x, ...)
    if x == "len" then
      return #l
    elseif x == "raw" then
      return l
    end
  end
end

local new = function(l_val)
  if l_val == nil then l_val = {} end
  assert(type(l_val) == "table")
  local r_val = {}
  for k,v in pairs(l_val) do r_val[v] = k end
  local l_proxy = setmetatable({}, {
    __index = l_val,
    __len = function(t) return #l_val end,
    __newindex = _newindex(l_val, r_val),
    __call = _call(l_val, r_val),
  })
  local r_proxy = setmetatable({}, {
    __index = r_val,
    __len = function(t) return #r_val end,
    __newindex = _newindex(r_val, l_val),
    __call = _call(r_val, l_val),
  })
  return l_proxy, r_proxy
end

return {
  new = new,
}
