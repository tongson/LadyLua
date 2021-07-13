package ll

import (
	"github.com/yuin/gopher-lua"
	"github.com/kevinburke/ssh_config"
)

func sshconfigPort(L *lua.LState) int {
	host := L.CheckString(1)
	port := ssh_config.Get(host, "Port")
	L.Push(lua.LString(port))
	return 1
}

func sshconfigIdentityFile(L *lua.LState) int {
	host := L.CheckString(1)
	key := ssh_config.Get(host, "IdentityFile")
	L.Push(lua.LString(key))
	return 1
}


func SSHconfigLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, sshconfigApi)
	L.Push(t)
	return 1
}

var sshconfigApi = map[string]lua.LGFunction{
	"port": sshconfigPort,
	"identity_file": sshconfigIdentityFile,
}
