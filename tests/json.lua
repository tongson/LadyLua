local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local json = require("json")
--# = json
--# :toc:
--# :toc-placement!:
--#
--# JSON encoding and decoding of Lua values.
--#
--# toc::[]
--#
--# == *json.encode*(_Any_) -> _String_
--# Encode value to JSON.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |any |Any value
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON representation
--# |===
local json_encode = function()
	T.is_function(json.encode)
end
local json_encode_true = function()
	T.equal(json.encode(true), "true")
end
local json_encode_number = function()
	T.equal(json.encode(1), "1")
end
local json_encode_signed = function()
	T.equal(json.encode(-10), "-10")
end
local json_encode_nil = function()
	T.equal(json.encode(nil), "null")
end
local json_encode_emptytable = function()
	T.equal(json.encode({}), "[]")
end
local json_encode_sequence1 = function()
	T.equal(json.encode({ 1, 2, 3 }), "[1,2,3]")
end
local json_encode_sequence2 = function()
	local a = {}
	for i = 1, 5 do
		a[i] = i
	end
	T.equal(json.encode(a), "[1,2,3,4,5]")
end
local json_encode_sparsetable = function()
	T.error(json.encode, "sparse array", { 1, 2, [10] = 3 })
end
local json_encode_mixedtable1 = function()
	T.error(json.encode, "mixed or invalid key types", { 1, 2, 3, name = "Tim" })
end
local json_encode_mixedtable2 = function()
	T.error(
		json.encode,
		"mixed or invalid key types",
		{ name = "Tim", [false] = 123 }
	)
end
local json_encode_invalidtable = function()
	local obj = {
		abc = 123,
		def = nil,
	}
	local obj2 = {
		obj = obj,
	}
	obj.obj2 = obj2
	T.is_nil(json.encode(obj))
end
--#
--# == *json.decode*(_String_) -> _Any_
--# Decode JSON to Lua value
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON string
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |any |Lua value
--# |===
local json_decode = function()
	T.is_function(json.decode)
end
local json_decode_array = function()
	local obj = { "a", 1, "b", 2, "c", 3 }
	local jsonStr = json.encode(obj)
	local jsonObj = json.decode(jsonStr)
	for i = 1, #obj do
		T.equal(obj[i], jsonObj[i])
	end
end
local json_decode_object = function()
	local obj = { name = "Tim", number = 12345 }
	local jsonStr = json.encode(obj)
	local jsonObj = json.decode(jsonStr)
	T.equal(obj.name, jsonObj.name)
	T.equal(obj.number, jsonObj.number)
end
local json_decode_null = function()
	T.is_nil(json.decode("null"))
end
local json_decode_nestedobject = function()
	T.equal(
		json.decode(json.encode({ person = { name = "tim" } })).person.name,
		"tim"
	)
end
if included then
	return function()
		T["json.encode"] = json_encode
		T["json.encode true"] = json_encode_true
		T["json.encode number"] = json_encode_number
		T["json.encode signed number"] = json_encode_signed
		T["json.encode nil"] = json_encode_nil
		T["json.encode empty table"] = json_encode_emptytable
		T["json.encode sequence #1"] = json_encode_sequence1
		T["json.encode sequence #2"] = json_encode_sequence2
		T["json.encode sparse table"] = json_encode_sparsetable
		T["json.encode mixed table #1"] = json_encode_mixedtable1
		T["json.encode mixed table #2"] = json_encode_mixedtable2
		T["json.encode invalid table"] = json_encode_invalidtable
		T["json.decode"] = json_decode
		T["json.decode array"] = json_decode_array
		T["json.decode object"] = json_decode_object
		T["json.decode null"] = json_decode_null
		T["json.decode nested object"] = json_decode_nestedobject
	end
else
	local errstr = function(tested, str, ...)
		local n, s = tested(...)
		if n ~= nil then
			return false, "First return value is not nil."
		end
		if nil == (string.find(s, str, 1, true)) then
			return false, string.format('Not found in error string: "%s".', str)
		end
		return true
	end
	T.register_assert("error", errstr)

	T["json.encode"] = json_encode
	T["json.encode true"] = json_encode_true
	T["json.encode number"] = json_encode_number
	T["json.encode signed number"] = json_encode_signed
	T["json.encode nil"] = json_encode_nil
	T["json.encode empty table"] = json_encode_emptytable
	T["json.encode sequence #1"] = json_encode_sequence1
	T["json.encode sequence #2"] = json_encode_sequence2
	T["json.encode sparse table"] = json_encode_sparsetable
	T["json.encode mixed table #1"] = json_encode_mixedtable1
	T["json.encode mixed table #2"] = json_encode_mixedtable2
	T["json.encode invalid table"] = json_encode_invalidtable
	T["json.decode"] = json_decode
	T["json.decode array"] = json_decode_array
	T["json.decode object"] = json_decode_object
	T["json.decode null"] = json_decode_null
	T["json.decode nested object"] = json_decode_nestedobject
end
