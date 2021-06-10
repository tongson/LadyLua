local H = require("http")
local F = string.format
local getenv = os.getenv
local D = getenv("KAPOW_DATA_URL")
local I = getenv("KAPOW_HANDLER_ID")
local get = function(s)
	s = H.get(F("%s/handlers/%s%s", D, I, s))
	if s.status_code == 200 then
		return s.body
	else
		return nil, "Kapow data URL returned non-200 code."
	end
end
local set = function(r, d)
	local s = H.put(F("%s/handlers/%s%s", D, I, r), { body = d })
	if s.status_code == 200 then
		return true
	else
		return nil, "Kapow data URL returned non-200 code."
	end
end
local xset = function(s, b)
	s = H.put(F("%s/handlers/%s/response/status", D, I), { body = s })
	if b then
		b = H.put(F("%s/handlers/%s/response/body", D, I), { body = b })
		b = (b.status_code == 200)
	else
		b = true
	end
	if s.status_code == 200 and b then
		return true
	else
		return nil, "Kapow data URL returned non-200 code."
	end
end
local ok = function(b)
	return xset("200", b)
end
local warn = function(b)
	return xset("202", b)
end
local fail = function(b)
	return xset("500", b)
end
local forbid = function(b)
	return xset("403", b)
end
local no_content = function()
	return xset("204")
end
local unprocessable = function()
	return xset("422")
end
local redirect = function(c, b)
	local s = H.put(F("%s/handlers/%s/response/status", D, I), { body = c })
	if b then
		b = H.put(F("%s/handlers/%s/response/headers/Location", D, I), { body = b })
		b = (b.status_code == 200)
	else
		b = true
	end
	if s.status_code == 200 and b then
		return true
	else
		return nil, "Kapow data URL returned non-200 code."
	end
end
local redirect_permanent = function(b)
	return redirect("301", b)
end
local redirect_temporary = function(b)
	return redirect("302", b)
end
local redirect_post = function(b)
	return redirect("303", b)
end
return {
	get = get,
	set = set,
	ok = ok,
	warn = warn,
	fail = fail,
	redirect_permanent = redirect_permanent,
	redirect_temporary = redirect_temporary,
	redirect_post = redirect_post,
	forbid = forbid,
	no_content = no_content,
	unprocessable = unprocessable,
}
