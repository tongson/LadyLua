package ll

import (
	"github.com/tongson/gl"
	"github.com/yuin/gopher-lua"
)

func ExecCommand(L *lua.LState) int {
	targ := []string{}
	tenv := []string{}
	tbl := L.NewTable()
	exe := L.CheckString(1)
	arg := L.OptTable(2, tbl)
	env := L.OptTable(3, tbl)
	cwd := L.OptString(4, "")
	sin := L.OptString(5, "")
	tme := L.OptNumber(6, 0)

	if arg.Len() > 0 {
		arg.ForEach(func(_, value lua.LValue) {
			targ = append(targ, lua.LVAsString(value))
		})
	}
	if env.Len() > 0 {
		env.ForEach(func(_, value lua.LValue) {
			tenv = append(tenv, lua.LVAsString(value))
		})
	}
	cmd := gl.RunArgs{Exe: exe, Args: targ, Env: tenv, Dir: cwd, Stdin: []byte(sin), Timeout: int(tme)}
	ret, stdout, stderr, err := cmd.Run()

	if ret {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LNil)
	}
	L.Push(lua.LString(stdout))
	L.Push(lua.LString(stderr))
	L.Push(lua.LString(err))
	return 4
}

func ExecCtx(L *lua.LState) int {
	exe := L.CheckString(1)
	set := L.NewTable()
	mt := L.NewTable()
	L.SetField(mt, "__call", L.NewFunction(func(L *lua.LState) int {
		deftbl := L.NewTable()
		args := L.OptTable(2, deftbl)
		L.Push(L.NewFunction(ExecCommand))
		L.Push(lua.LString(exe))
		L.Push(args)
		L.Push(L.GetField(set, "env"))
		L.Push(L.GetField(set, "cwd"))
		L.Push(L.GetField(set, "stdin"))
		L.Push(L.GetField(set, "timeout"))
		L.Call(6, 4)
		return 4
	}))
	L.SetMetatable(set, mt)
	L.Push(set)
	return 1
}
