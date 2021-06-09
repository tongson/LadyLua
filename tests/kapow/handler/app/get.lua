local Kapow = require("kapow")
local Set = Kapow.set
local Ok = Kapow.ok
local Warn = Kapow.warn
local Fail = Kapow.fail
local Redirect_permanent = Kapow.redirect_permanent
local Redirect_temporary = Kapow.redirect_temporary
local Redirect_post = Kapow.redirect_post
local Forbid = Kapow.forbid
local Unprocessable = Kapow.unprocessable
local No_Content = Kapow.no_content

local default = function()
	local r = Set("/response/status", "418")
	local b = Set("/response/body", "kapow.set")
	assert(r)
	assert(b)
end
local ok = function()
	return Ok("kapow.ok")
end
local warn = function()
	return Warn("kapow.warn")
end
local fail = function()
	return Fail("kapow.fail")
end
local redirect_permanent = function()
	return Redirect_permanent("http://127.0.0.1:60080/")
end
local redirect_temporary = function()
	return Redirect_temporary("http://127.0.0.1:60080/")
end
local redirect_post = function()
	return Redirect_post("http://127.0.0.1:60080/")
end
local forbid = function()
	return Forbid("kapow.forbid")
end
local unprocessable = function()
	return Unprocessable()
end
local no_content = function()
	return No_Content()
end
local binary = function()
	return Ok(fs.read("/usr/bin/kapow"))
end
return {
	__DEFAULT = default,
	ok = ok,
	warn = warn,
	fail = fail,
	redirect_permanent = redirect_permanent,
	redirect_temporary = redirect_temporary,
	redirect_post = redirect_post,
	forbid = forbid,
	unprocessable = unprocessable,
	no_content = no_content,
	binary = binary,
}
