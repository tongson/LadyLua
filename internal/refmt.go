package ll

import (
	"encoding/json"

	gyaml "github.com/ghodss/yaml"
	toml "github.com/pelletier/go-toml"
	lua "github.com/yuin/gopher-lua"
)

func refmtToYAML(L *lua.LState) int {
	j := L.CheckString(1)
	y, err := gyaml.JSONToYAML([]byte(j))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LString(y))
		return 1
	}
}

func refmtToJSON(L *lua.LState) int {
	y := L.CheckString(1)
	j, err := gyaml.YAMLToJSON([]byte(y))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LString(j))
		return 1
	}
}

func refmtTOMLToJSON(L *lua.LState) int {
	s := L.CheckString(1)
	var tree *toml.Tree
	var err error
	if tree, err = toml.LoadBytes([]byte(s)); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	var bytes []byte
	treeMap := tree.ToMap()
	if bytes, err = json.MarshalIndent(treeMap, "", "  "); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(string(bytes[:])))
	return 1
}

func refmtJSONToTOML(L *lua.LState) int {
	s := L.CheckString(1)
	jsonMap := make(map[string]interface{})
	var err error
	jsonBytes := []byte(s)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	err = json.Unmarshal(jsonBytes, &jsonMap)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	tree, err := toml.TreeFromMap(jsonMap)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	tomlBytes, err := tree.ToTomlString()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(string(tomlBytes[:])))
	return 1
}

func RefmtLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, refmtApi)
	L.Push(t)
	return 1
}

var refmtApi = map[string]lua.LGFunction{
	"json":         refmtToJSON,
	"yaml":         refmtToYAML,
	"yaml_to_json": refmtToJSON,
	"json_to_yaml": refmtToYAML,
	"toml_to_json": refmtTOMLToJSON,
	"json_to_toml": refmtJSONToTOML,
}
