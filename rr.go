package ll

import (
	"fmt"
	"github.com/yuin/gopher-lua"
	"os"
	"path/filepath"
	"strings"
)

const (
	libHeader = `
unset IFS
set -o errexit -o nounset -o noglob
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export LC_ALL=C
`
)

const (
	untar = `
LC_ALL=C
set -o errexit -o nounset -o noglob
unset IFS
PATH=/bin:/usr/bin
tar -C %s -cpf - . | tar -C / -xpf -
`
)

const run = "script"

func rrEndFn(L *lua.LState) int {
	mt := L.CheckTable(1)
	dir := mt.RawGetH(lua.LString("cwd"))
	err := os.Chdir(lua.LVAsString(dir))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}

func rrRunFn(L *lua.LState) int {
	mt := L.CheckTable(1)
	dir := mt.RawGetH(lua.LString("dir"))
	err := os.Chdir(lua.LVAsString(dir))
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	hostname := lua.LVAsString(mt.RawGetH(lua.LString("hostname")))
	isDir := StatPath("directory")
	isFile := StatPath("file")
	var sh strings.Builder
	targ := L.NewTable()
	tenv := L.NewTable()
	namespace := L.CheckString(2)
	script := L.CheckString(3)
	arg := L.OptTable(4, targ)
	env := L.OptTable(5, tenv)
	if !isDir(namespace) {
		L.Push(lua.LNil)
		L.Push(lua.LString("rr: Namespace argument is not a directory."))
		return 2
	}
	if !isDir(fmt.Sprintf("%s/%s", namespace, script)) {
		L.Push(lua.LNil)
		L.Push(lua.LString("rr: Script argument is not a directory."))
		return 2
	}
	if !isFile(fmt.Sprintf("%s/%s/%s", namespace, script, run)) {
		L.Push(lua.LNil)
		L.Push(lua.LString("rr: Actual script not a file inside Script directory."))
		return 2
	}
	fnwalk := PathWalker(&sh)
	if !isDir(".lib") {
		_ = os.MkdirAll(".lib", os.ModePerm)
		if StringToFile(".lib/000-header.sh", libHeader) != nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("rr: Unable to write .lib."))
			return 2
		}
	}
	if filepath.Walk(".lib", fnwalk) != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("rr: Unable to walk .lib."))
		return 2
	}
	if isDir(namespace + "/.lib") {
		if filepath.Walk(namespace+"/.lib", fnwalk) != nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("rr: Unable to walk .lib."))
			return 2
		}
	}
	if isDir(namespace + "/" + script + "/.lib") {
		if filepath.Walk(namespace+"/"+script+"/.lib", fnwalk) != nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("rr: Unable to walk .lib."))
			return 2
		}
	}

	var arguments []string
	if arg.Len() > 0 {
		arg.ForEach(func(_, value lua.LValue) {
			arguments = append(arguments, lua.LVAsString(value))
		})
	}
	if env.Len() > 0 {
		env.ForEach(func(_, value lua.LValue) {
			sh.WriteString("export " + lua.LVAsString(value) + "\n")
		})
	}

	arguments = InsertStr(arguments, "set --", 0)
	sh.WriteString(strings.Join(arguments, " "))
	sh.WriteString("\n" + FileRead(namespace+"/"+script+"/"+run))
	modscript := sh.String()
	if hostname == "local" || hostname == "localhost" {
		for _, d := range []string{
			".files",
			".files-local",
			".files-localhost",
			namespace + "/.files",
			namespace + "/.files-local",
			namespace + "/.files-localhost",
			namespace + "/" + script + "/.files",
			namespace + "/" + script + "/.files-local",
			namespace + "/" + script + "/.files-localhost",
		} {
			if isDir(d) {
				rargs := RunArgs{Exe: "sh", Args: []string{"-c", fmt.Sprintf(untar, d)}}
				ret, stdout, stderr, ero := rargs.Run()
				if !ret {
					L.Push(lua.LNil)
					L.Push(lua.LString(stdout))
					L.Push(lua.LString(stderr))
					L.Push(lua.LString(ero))
				}
			}
		}
		rargs := RunArgs{Exe: "sh", Args: []string{"-c", modscript}}
		ret, stdout, stderr, ero := rargs.Run()
		if !ret {
			L.Push(lua.LNil)
			L.Push(lua.LString(stdout))
			L.Push(lua.LString(stderr))
			L.Push(lua.LString(ero))
			return 4

		} else {
			L.Push(lua.LString(modscript))
			L.Push(lua.LString(stdout))
			L.Push(lua.LString(stderr))
			return 3
		}
	} else {
		rh := strings.Split(hostname, "@")
		var realhost string
		if len(rh) == 1 {
			realhost = hostname
		} else {
			realhost = rh[1]
		}
		sshenv := []string{"LC_ALL=C"}
		ssha := RunArgs{Exe: "ssh", Args: []string{"-T", "-a", "-x", "-C", hostname, "uname -n"}, Env: sshenv}
		ret, stdout, _, _ := ssha.Run()
		if ret {
			sshhost := strings.Split(stdout, "\n")
			if realhost != sshhost[0] {
				L.Push(lua.LNil)
				L.Push(lua.LString("rr: Hostname does not match remote host"))
				return 2
			}
		} else {
			L.Push(lua.LNil)
			L.Push(lua.LString("rr: Remote host unreachable"))
			return 2
		}
		for _, d := range []string{
			".files",
			".files-" + realhost,
			namespace + "/.files",
			namespace + "/.files-" + realhost,
			namespace + "/" + script + "/.files",
			namespace + "/" + script + "/.files-" + realhost,
		} {
			if isDir(d) {
				tmpfile, err := os.CreateTemp(os.TempDir(), "_rr")
				if err != nil {
					L.Push(lua.LNil)
					L.Push(lua.LString("rr: Cannot create temporary directory."))
					return 2
				}
				defer os.Remove(tmpfile.Name())
				sftpc := []byte(fmt.Sprintf("lcd %s\ncd /\nput -fRp .\n bye\n", d))
				if _, err = tmpfile.Write(sftpc); err != nil {
					L.Push(lua.LNil)
					L.Push(lua.LString("rr: Failed to write temporary file."))
					return 2
				}
				tmpfile.Close()
				sftpa := RunArgs{Exe: "sftp", Args: []string{"-C", "-b", tmpfile.Name(), hostname}, Env: sshenv}
				ret, _, _, _ := sftpa.Run()
				if !ret {
					L.Push(lua.LNil)
					L.Push(lua.LString("rr: Running sftp failed. Exiting."))
					return 2
				}
				os.Remove(tmpfile.Name())
			}
		}
		sshb := RunArgs{Exe: "ssh", Args: []string{"-T", "-a", "-x", "-C", hostname}, Env: sshenv,
			Stdin: []byte(modscript)}
		ret, stdout, stderr, ero := sshb.Run()
		if !ret {
			L.Push(lua.LNil)
			L.Push(lua.LString(stdout))
			L.Push(lua.LString(stderr))
			L.Push(lua.LString(ero))
			return 4
		} else {
			L.Push(lua.LString(modscript))
			L.Push(lua.LString(stdout))
			L.Push(lua.LString(stderr))
			return 3
		}
	}
}

func rrInit(L *lua.LState) int {
	mt := L.NewTable()
	cwd, err := os.Getwd()
	if err != nil {
		L.Push(lua.LNil)
		return 1
	}
	hostname := L.CheckString(1)
	dir := L.OptString(2, cwd)
	mt.RawSetString("hostname", lua.LString(hostname))
	mt.RawSetString("dir", lua.LString(dir))
	mt.RawSetString("cwd", lua.LString(cwd))
	L.SetMetatable(mt, L.GetTypeMetatable("rr{api}"))
	L.Push(mt)
	return 1
}

var rrApi = map[string]lua.LGFunction{
	"ctx": rrInit,
}

func RrLoader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), rrApi)
	L.Push(mod)
	rrRegister(L)
	return 1
}

var rrMethods = map[string]lua.LGFunction{
	"run":  rrRunFn,
	"done": rrEndFn,
}

func rrRegister(L *lua.LState) {
	mt := L.NewTypeMetatable("rr{api}")
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), rrMethods))
}
