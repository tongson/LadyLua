package main

import (
	"github.com/yuin/gopher-lua"
)

func execCommand(L *lua.LState) int {
	targ := []string{}
	tenv := []string{}
	tbl := L.NewTable()
	exe := L.CheckString(1)
	arg := L.OptTable(2, tbl)
	env := L.OptTable(3, tbl)
	cwd := L.OptString(4, "")
	sin := L.OptString(5, "")

	if arg.Len() > 0 {
		arg.ForEach(func(_, value lua.LValue) {
			targ = append(targ, lua.LVAsString(value))
		})
	}
	if env.Len() > 0 {
		env.ForEach(func(_, value lua.LValue){
			tenv = append(tenv, lua.LVAsString(value))
		})
	}
	cmd := RunArgs{Exe: exe, Args: targ, Env: tenv, Dir: cwd, Stdin: []byte(sin)}
	ret, stdout, stderr := cmd.Run()

	if ret {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LNil)
	}
  L.Push(lua.LString(stdout))
	L.Push(lua.LString(stderr))
	return 3
}
