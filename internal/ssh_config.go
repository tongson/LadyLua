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

func sshconfigHostname(L *lua.LState) int {
	host := L.CheckString(1)
	hn := ssh_config.Get(host, "Hostname")
	if hn != "" {
		L.Push(lua.LString(hn))
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString("ssh_config: No such host."))
		return 2
	}
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
	"hostname": sshconfigHostname,
}
