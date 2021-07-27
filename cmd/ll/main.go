package main

import (
	"flag"
	"fmt"
	"github.com/chzyer/readline"
	"github.com/tongson/LadyLua"
	"github.com/tongson/gl"
	"github.com/yuin/gopher-lua"
	"github.com/yuin/gopher-lua/parse"
	"os"
	"runtime"
	"runtime/pprof"
	"time"
)

var start time.Time

const versionNumber = "0.10.0"
const codeName = "\"Black Future\""

func main() {
	start = time.Now()
	runtime.MemProfileRate = 0
	os.Exit(mainAux())
}

func mainAux() int {
	defer gl.RecoverPanic()
	var opt_e, opt_l, opt_p string
	var opt_i, opt_v, opt_dt, opt_dc bool
	var opt_m int
	flag.StringVar(&opt_e, "e", "", "")
	flag.StringVar(&opt_l, "l", "", "")
	flag.StringVar(&opt_p, "p", "", "")
	flag.IntVar(&opt_m, "mx", 0, "")
	flag.BoolVar(&opt_i, "i", false, "")
	flag.BoolVar(&opt_v, "v", false, "")
	flag.BoolVar(&opt_dt, "dt", false, "")
	flag.BoolVar(&opt_dc, "dc", false, "")
	flag.Usage = func() {
		fmt.Println(`Usage: ll [options] [script [args]].
Available options are:
  -e stat  execute string 'stat'
  -l name  require library 'name'
  -mx MB   memory limit(default: unlimited)
  -dt      dump AST trees
  -dc      dump VM codes
  -i       enter interactive mode after executing 'script'
  -p file  write cpu profiles to the file
  -v       show version information`)
	}
	flag.Parse()
	if len(opt_p) != 0 {
		f, err := os.Create(opt_p)
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
		}
		if err := pprof.StartCPUProfile(f); err != nil {
			gl.Panic(err.Error())
		}
		defer pprof.StopCPUProfile()
	}
	if len(opt_e) == 0 && !opt_i && !opt_v && flag.NArg() == 0 {
		opt_i = true
	}

	status := 0

	L := lua.NewState()
	defer L.Close()
	ll.LoadGlobalGo(L, "fs")
	ll.LoadGlobalGo(L, "os")
	ll.LoadGlobalGo(L, "extend")
	ll.LoadGlobalGo(L, "exec")
	ll.PreloadGo(L, "http")
	ll.PreloadGo(L, "json")
	ll.PreloadGo(L, "crypto")
	ll.PreloadGo(L, "ksuid")
	ll.PreloadGo(L, "mysql")
	ll.PreloadGo(L, "lz4")
	ll.PreloadGo(L, "telegram")
	ll.PreloadGo(L, "pushover")
	ll.PreloadGo(L, "slack")
	ll.PreloadGo(L, "logger")
	ll.PreloadGo(L, "fsnotify")
	ll.PreloadGo(L, "bitcask")
	ll.PreloadGo(L, "refmt")
	ll.PreloadGo(L, "rr")
	ll.PreloadGo(L, "uuid")
	ll.PreloadGo(L, "ulid")
	ll.PreloadGo(L, "redis")
	ll.PreloadGo(L, "ssh_config")
	ll.PreloadGo(L, "socket_core")
	ll.PreloadGo(L, "socket_except")
	ll.PreloadGo(L, "socket")
	ll.Preload(L)

	if opt_m > 0 {
		L.SetMx(opt_m)
	}

	if opt_v || opt_i {
		elapsed := time.Since(start)
		fmt.Printf("ll %s %s\n%s\nElapsed: %s\n", versionNumber, codeName, lua.PackageCopyRight, elapsed)
	}

	if len(opt_l) > 0 {
		if err := L.DoFile(opt_l); err != nil {
			fmt.Println(err.Error())
		}
	}

	if nargs := flag.NArg(); nargs > 0 {
		script := flag.Arg(0)
		argtb := L.NewTable()
		for i := 1; i < nargs; i++ {
			L.RawSet(argtb, lua.LNumber(i), lua.LString(flag.Arg(i)))
		}
		L.SetGlobal("arg", argtb)
		/* #nosec G304 */
		if opt_dt || opt_dc {
			file, err := os.Open(script)
			if err != nil {
				fmt.Println(err.Error())
				return 1
			}
			chunk, err2 := parse.Parse(file, script)
			if err2 != nil {
				fmt.Println(err2.Error())
				return 1
			}
			if opt_dt {
				fmt.Println(parse.Dump(chunk))
			}
			if opt_dc {
				proto, err3 := lua.Compile(chunk, script)
				if err3 != nil {
					fmt.Println(err3.Error())
					return 1
				}
				fmt.Println(proto.String())
			}
		}
		if err := L.DoFile(script); err != nil {
			fmt.Println(err.Error())
			status = 1
		}
	}

	if len(opt_e) > 0 {
		if err := L.DoString(opt_e); err != nil {
			fmt.Println(err.Error())
			status = 1
		}
	}

	if opt_i {
		doREPL(L)
	}
	return status
}

// do read/eval/print/loop
func doREPL(L *lua.LState) {
	rl, err := readline.New("> ")
	if err != nil {
		panic(err)
	}
	defer rl.Close()
	for {
		if str, err := loadline(rl, L); err == nil {
			if err := L.DoString(str); err != nil {
				fmt.Println(err)
			}
		} else { // error on loadline
			fmt.Println(err)
			return
		}
	}
}

func incomplete(err error) bool {
	if lerr, ok := err.(*lua.ApiError); ok {
		if perr, ok := lerr.Cause.(*parse.Error); ok {
			return perr.Pos.Line == parse.EOF
		}
	}
	return false
}

func loadline(rl *readline.Instance, L *lua.LState) (string, error) {
	rl.SetPrompt("> ")
	if line, err := rl.Readline(); err == nil {
		if _, err := L.LoadString("return " + line); err == nil { // try add return <...> then compile
			return line, nil
		} else {
			return multiline(line, rl, L)
		}
	} else {
		return "", err
	}
}

func multiline(ml string, rl *readline.Instance, L *lua.LState) (string, error) {
	for {
		if _, err := L.LoadString(ml); err == nil { // try compile
			return ml, nil
		} else if !incomplete(err) { // syntax error , but not EOF
			return ml, nil
		} else {
			rl.SetPrompt(">> ")
			if line, err := rl.Readline(); err == nil {
				ml = ml + "\n" + line
			} else {
				return "", err
			}
		}
	}
}
