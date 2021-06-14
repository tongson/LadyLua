local json = require("ll_json")
package.loaded["ll_json"] = nil
local Encode = json.encode
local Decode = json.decode
local Array = function(j)
	local t = Decode(j)
	local jagen = function(x, i)
		i = i + 1
		local v = x[i]
		if v ~= nil then
			return i, v
		else
			return nil
		end
	end
	return jagen, t, 0
end
local Object = function(j)
	local next = next
	local t = Decode(j)
	return next, t, nil
end
return {
	array = Array,
	object = Object,
	encode = Encode,
	decode = Decode,
}
