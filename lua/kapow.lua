local H = require 'http'
local F = string.format
local getenv = os.getenv
local D = getenv 'KAPOW_DATA_URL'
local I = getenv 'KAPOW_HANDLER_ID'
local get = function(s)
  s = H.get(F('%s/handlers/%s%s', D, I, s))
  if s.status_code == 200 then
    return s.body
  else
    return nil, 'Kapow data URL returned non-200 code.'
  end
end
local set = function(r, d)
  local s = H.put(F('%s/handlers/%s%s', D, I, r), { body = d })
  if s.status_code == 200 then
    return true
  else
    return nil, 'Kapow data URL returned non-200 code.'
  end
end
local xset = function(s, b)
  s = H.put(F('%s/handlers/%s/response/status', D, I), { body = s })
  if b then
    b = H.put(F('%s/handlers/%s/response/body', D, I), { body = b })
    b = (b.status_code == 200)
  else
    b = true
  end
  if s.status_code == 200 and b then
    return true
  else
    return nil, 'Kapow data URL returned non-200 code.'
  end
end
local ok = function(b)
  return xset('200', b)
end
local warn = function(b)
  return xset('202', b)
end
local fail = function(b)
  return xset('500', b)
end
local forbid = function(b)
  return xset('403', b)
end
local not_allowed = function()
  return xset('405')
end
local no_content = function()
  return xset('204')
end
local redirect = function(b)
  local s = H.put(F('%s/handlers/%s/response/status', D, I), { body = '303' })
  if b then
    b = H.put(F('%s/handlers/%s/headers/Location', D, I), { body = b })
    b = (b.status_code == 200)
  else
    b = true
  end
  if s.status_code == 200 and b then
    return true
  else
    return nil, 'Kapow data URL returned non-200 code.'
  end
end
return {
  get = get,
  set = set,
  ok = ok,
  warn = warn,
  fail = fail,
  redirect = redirect,
  forbid = forbid,
  not_allowed = not_allowed,
  no_content = no_content,
}
