package ll

import (
	"embed"
	"fmt"
	"os"

	"github.com/yuin/gopher-lua"
)

//#
//# == *ll.FillArg*(*lua.LState, []string)
//# Capture command line arguments as the `arg` table in the global `_G` environment.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |*lua.LState|The current `LState`; usually the result of `lua.NewState()`
//# |[]string |Usually `os.Args`
//# |===
func FillArg(L *lua.LState, args []string) {
	argtb := L.NewTable()
	for i := 0; i < len(args); i++ {
		L.RawSet(argtb, lua.LNumber(i), lua.LString(args[i]))
	}
	L.SetGlobal("arg", argtb)
}

//#
//# == *ll.ReadFile*(embed.FS, string) -> string
//# Read file from an `embed.FS` location.
//#
//# === Arguments
//# [width="72%"]
//# |===
//# |embed.FS |Variable of embedded filesystem
//# |string |Filename
//# |===
//#
//# === Returns
//# [width="72%"]
//# |===
//# |string |Contents of file
//# |===
func ReadFile(f embed.FS, p string) string {
	c, err := f.ReadFile(p)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	return string(c)
}
