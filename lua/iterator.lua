local json = require("json")
local Array = function(j)
	local t = json.decode(j)
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
	local t = json.decode(j)
	return next, t, nil
end
return {
	array = Array,
	object = Object,
}
