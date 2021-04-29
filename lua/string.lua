do
	local F = string.format
	local gmatch = string.gmatch

	string.append = function(str, a)
		return F("%s\n%s", str, a)
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

	string.to_map = function(str, def)
		def = def or true
		local t = {}
		for s in gmatch(str, "%S+") do
			t[s] = def
		end
		return t
	end
end
