local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
local refmt = require("refmt")
local json = require("json")
local expect = T.expect
--# = refmt
--# :toc:
--# :toc-placement!:
--#
--# Convert between JSON and YAML.
--#
--# toc::[]
--#
--# == *refmt.json_to_yaml*(_String_) -> _String_
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
	local y = refmt.json_to_yaml(j)
	local expected = [[one: "1"
two: "2"
]]
	T.equal(y, expected)
end
--#
--# == *refmt.yaml_to_json*(_String_) -> _String_
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
	T.equal(refmt.yaml_to_json(y), expected)
end
--#
--# == *refmt.toml_to_json*(_String_) -> _String_
--# Convert TOML to JSON.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |TOML
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |JSON
--# |===
local refmt_toml_json = function()
	T.is_function(refmt.toml_to_json)
	local t = [[
	[mytoml]
	a = 42
	]]
	local expected = [[{
  "mytoml": {
    "a": 42
  }
}]]
	T.equal(refmt.toml_to_json(t), expected)
end
--#
--# == *refmt.json_to_toml*(_String_) -> _String_
--# Convert JSON to TOML.
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
--# |string |TOML
--# |===
local refmt_json_toml = function()
	T.is_function(refmt.json_to_toml)
	local expected = [[

[mytoml]
  a = 42.0
]]
	local j = [[{
  "mytoml": {
    "a": 42
  }
}]]
	expect(expected)(refmt.json_to_toml(j))
end
if included then
  return function()
		T["refmt.json_to_yaml"] = refmt_yaml
		T["refmt.yaml_to_json"] = refmt_json
		T["refmt.toml_to_json"] = refmt_toml_json
		T["refmt.json_to_toml"] = refmt_json_toml
  end
else

		T["refmt.json_to_yaml"] = refmt_yaml
		T["refmt.yaml_to_json"] = refmt_json
		T["refmt.toml_to_json"] = refmt_toml_json
		T["refmt.json_to_toml"] = refmt_json_toml
end
