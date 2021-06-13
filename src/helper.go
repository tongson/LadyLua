package ll

import (
	"embed"
	"fmt"
	"github.com/yuin/gopher-lua"
	"os"
)

func FillArg(L *lua.LState, args []string) {
	argtb := L.NewTable()
	for i := 0; i < len(args); i++ {
		L.RawSet(argtb, lua.LNumber(i), lua.LString(args[i]))
	}
	L.SetGlobal("arg", argtb)
}

func ReadFile(f embed.FS, p string) string {
	c, err := f.ReadFile(p)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	return string(c)
}
