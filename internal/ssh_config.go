package ll

import (
	"os"
	"path/filepath"

	"github.com/kevinburke/ssh_config"
	"github.com/yuin/gopher-lua"
)

func sshconfigPort(L *lua.LState) int {
	host := L.CheckString(1)
	port := ssh_config.Get(host, "Port")
	if port != "" {
		L.Push(lua.LString(port))
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString("ssh_config: No such host."))
		return 2
	}

}

func sshconfigIdentityFile(L *lua.LState) int {
	host := L.CheckString(1)
	key := ssh_config.Get(host, "IdentityFile")
	if key != "" {
		L.Push(lua.LString(key))
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString("ssh_config: No such host."))
		return 2
	}
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

func sshconfigHosts(L *lua.LState) int {
	f, _ := os.Open(filepath.Join(os.Getenv("HOME"), ".ssh", "config"))
	c, _ := ssh_config.Decode(f)
	t := L.NewTable()
	for _, host := range c.Hosts {
		for _, pat := range host.Patterns {
			s := pat.String()
			if s != "*" {
				t.Append(lua.LString(s))
			}
		}
	}
	L.Push(t)
	return 1
}

func SSHconfigLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, sshconfigApi)
	L.Push(t)
	return 1
}

var sshconfigApi = map[string]lua.LGFunction{
	"port":          sshconfigPort,
	"identity_file": sshconfigIdentityFile,
	"hostname":      sshconfigHostname,
	"hosts":         sshconfigHosts,
}
