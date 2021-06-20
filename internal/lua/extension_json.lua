return setmetatable({}, {
	__call = function()
		local json = require("json")
		local decode = json.decode
		json.array = function(j)
			local t = decode(j)
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
		json.object = function(j)
			local next = next
			local t = decode(j)
			return next, t, nil
		end
	end,
})
