package main

import (
	"flag"
	"fmt"
	"github.com/chzyer/readline"
	gluacrypto "github.com/tongson/LadyLua/external/gluacrypto/crypto"
	"github.com/tongson/LadyLua/external/gluahttp"
	mysql "github.com/tongson/LadyLua/external/gluasql/mysql"
	ljson "github.com/tongson/LadyLua/external/gopher-json"
	"github.com/tongson/LadyLua/external/gopher-lfs"
	"github.com/tongson/LadyLua/src"
	"github.com/tongson/gl"
	"github.com/yuin/gopher-lua"
	"github.com/yuin/gopher-lua/parse"
	"os"
	"runtime"
	"runtime/pprof"
	"time"
)

var start time.Time

const versionNumber = "0.9.0"
const codeName = "\"Scared Shrapnel\""

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
	nsFs := L.SetFuncs(L.NewTable(), lfs.Api)
	L.SetGlobal("fs", nsFs)
	L.SetField(nsFs, "isdir", L.NewFunction(ll.FsIsdir))
	L.SetField(nsFs, "isfile", L.NewFunction(ll.FsIsfile))
	L.SetField(nsFs, "read", L.NewFunction(ll.FsRead))
	L.SetField(nsFs, "write", L.NewFunction(ll.FsWrite))
	nsOs := L.GetField(L.Get(lua.EnvironIndex), "os")
	L.SetField(nsOs, "hostname", L.NewFunction(ll.OsHostname))
	L.SetField(nsOs, "outbound_ip", L.NewFunction(ll.OsOutboundIP))
	L.SetField(nsOs, "sleep", L.NewFunction(ll.OsSleep))
	L.SetGlobal("pi", L.NewFunction(ll.GlobalPi))
	L.PreloadModule("http", gluahttp.Xloader)
	L.PreloadModule("ll_json", ljson.Loader)
	L.PreloadModule("crypto", gluacrypto.Loader)
	L.PreloadModule("ksuid", ll.KsuidLoader)
	L.PreloadModule("mysql", mysql.Loader)
	L.PreloadModule("lz4", ll.Lz4Loader)
	L.PreloadModule("telegram", ll.TelegramLoader)
	L.PreloadModule("pushover", ll.PushoverLoader)
	L.PreloadModule("slack", ll.SlackLoader)
	L.PreloadModule("logger", ll.LoggerLoader)
	L.PreloadModule("fsnotify", ll.FsnLoader)
	L.PreloadModule("bitcask", ll.BitcaskLoader)
	L.PreloadModule("refmt", ll.RefmtLoader)
	L.PreloadModule("rr", ll.RrLoader)
	L.PreloadModule("uuid", ll.UuidLoader)
	L.PreloadModule("ulid", ll.UlidLoader)
	L.SetGlobal("exec", L.NewTable())
	nsExec := L.GetField(L.Get(lua.EnvironIndex), "exec")
	L.SetField(nsExec, "command", L.NewFunction(ll.ExecCommand))
	ll.PatchLoader(L, "exec")
	ll.PatchLoader(L, "table")
	ll.PatchLoader(L, "string")
	L.PreloadModule("redis", ll.RedisLoader)
	loaders := L.GetField(L.GetField(L.Get(lua.EnvironIndex), "package"), "loaders")
	if ltb, ok := loaders.(*lua.LTable); ok {
		li := ltb.Len()
		ltb.RawSetInt(li+1, L.NewFunction(ll.EmbedLoader))
	}

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
