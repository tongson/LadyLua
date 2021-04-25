local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
local refmt = require("refmt")
local json = require("json")
--# = refmt
--# :toc:
--# :toc-placement!:
--#
--# Convert between JSON and YAML.
--#
--# toc::[]
--#
--# == *refmt.yaml*(_String_) -> _String_
--# Convert JSON to YAML.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |YAML
--# |===
local refmt_yaml = function()
  T.is_function(refmt.yaml)
	local t = {
		one = "1",
		two = "2",
	}
	local j = json.encode(t)
	local y = refmt.yaml(j)
	local expected = [[one: "1"
two: "2"
]]
  T.equal(y, expected)
end
--#
--# == *refmt.json*(_String_) -> _String_
--# Convert YAML to JSON.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |YAML
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
local refmt_json = function()
  T.is_function(refmt.json)
	local y = [[value: 'hello' # world]]
	local expected = [[{"value":"hello"}]]
  T.equal(refmt.json(y), expected)
end
if included then
  return function()
		T["refmt.yaml"] = refmt_yaml
		T["refmt.json"] = refmt_json
  end
else

		T["refmt.yaml"] = refmt_yaml
		T["refmt.json"] = refmt_json
end
