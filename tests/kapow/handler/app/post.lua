local Kapow = require("kapow")
local Ok = Kapow.ok

local default = function()
	return Ok("hello")
end

return {
	__DEFAULT = default,
}
