package main

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strings"
)

type RunArgs struct {
	Exe   string
	Args  []string
	Dir   string
	Env   []string
	Stdin []byte
}

type panicT struct {
	msg  string
	code int
}

// Interface to execute the given `RunArgs` through `exec.Command`.
// The first return value is a boolean, true indicates success, false otherwise.
// Second value is the standard output of the command.
// Third value is the standard error of the command.
// Fourth value is error string from Run.
func (a RunArgs) Run() (bool, string, string, string) {
	var r bool = true
	/* #nosec G204 */
	cmd := exec.Command(a.Exe, a.Args...)
	if a.Dir != "" {
		cmd.Dir = a.Dir
	}
	if a.Env != nil || len(a.Env) > 0 {
		cmd.Env = append(os.Environ(), a.Env...)
	}
	if a.Stdin != nil || len(a.Stdin) > 0 {
		cmd.Stdin = bytes.NewBuffer(a.Stdin)
	}
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	var errorStr string
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		r = false
		errorStr = err.Error()
	}
	return r, stdout.String(), stderr.String(), errorStr
}

// Returns a function for simple directory or file check.
// StatPath("directory") for directories.
// StatPath() or StatPath("whatever") for files.
// The function returns boolean `true` on successfully check, `false` otherwise.
func StatPath(f string) func(string) bool {
	switch f {
	case "directory":
		return func(i string) bool {
			if fi, err := os.Stat(i); err == nil {
				if fi.IsDir() {
					return true
				}
			}
			return false
		}
	default:
		return func(i string) bool {
			info, err := os.Stat(i)
			if os.IsNotExist(err) {
				return false
			}
			return !info.IsDir()
		}
	}
}

// Returns a function for walking a path for files.
// Files are read and then contents are written to a strings.Builder pointer.
func PathWalker(sh *strings.Builder) func(string, os.FileInfo, error) error {
	isFile := StatPath("file")
	return func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			return nil
		}
		/* #nosec G304 */
		if isFile(path) {
			file, err := os.Open(path)
			if err != nil {
				log.Panic(err)
			}
			defer func() {
				err := file.Close()
				if err != nil {
					log.Panic(err)
				}
			}()
			str, err := io.ReadAll(file)
			if err != nil {
				log.Panic(err)
			}
			sh.WriteString(string(str)) // length of string and nil err ignored
		}
		return nil
	}
}

// Reads a file `path` then returns the contents as a string.
// Always returns a string value.
// An empty string "" is returned for nonexistent or unreadable files.
func FileRead(path string) string {
	isFile := StatPath("file")
	/* #nosec G304 */
	if isFile(path) {
		file, err := os.Open(path)
		if err != nil {
			log.Panic(err)
		}
		defer func() {
			err := file.Close()
			if err != nil {
				log.Panic(err)
			}
		}()
		str, err := io.ReadAll(file)
		if err != nil {
			log.Panic(err)
		}
		return string(str)
	} else {
		return ""
	}
}

// Insert string argument #2 into index `i` of first argument `a`.
func InsertStr(a []string, b string, i int) []string {
	a = append(a, "")
	copy(a[i+1:], a[i:]) // number of elements copied ignored
	a[i] = b
	return a
}

// Prefix string `s` with pipes "|".
// Used to "prettify" command line output.
// Returns new string.
func PipeStr(prefix string, str string) string {
	replacement := fmt.Sprintf("\n %s > ", prefix)
	str = strings.Replace(str, "\n", replacement, -1)
	return fmt.Sprintf(" %s >\n %s > %s", prefix, prefix, str)
}

// Writes the string `s` to the file `path`.
// It returns any error encountered, nil otherwise.
func StringToFile(path string, s string) error {
	fo, err := os.Create(path)
	if err != nil {
		return err
	}
	defer func() {
		_ = fo.Close()
	}()
	_, err = io.Copy(fo, strings.NewReader(s))
	if err != nil {
		return err
	}
	return nil
}

func RecoverPanic() {
	if rec := recover(); rec != nil {
		err := rec.(panicT)
		fmt.Fprintln(os.Stderr, err.msg)
		os.Exit(err.code)
	}
}

func Assert(e error, s string) {
	if e != nil {
		strerr := strings.Replace(e.Error(), "\n", "\n | ", -1)
		panic(panicT{msg: fmt.Sprintf("assertion failed: %s\n | \n | %s\n | ", s, strerr), code: 255})
	}
}

func Bug(s string) {
	panic(panicT{msg: fmt.Sprintf("BUG: %s", s), code: 255})
}

func Panic(s string) {
	panic(panicT{msg: fmt.Sprintf("FATAL: %s", s), code: 1})
}

func Panicf(f string, a ...interface{}) {
	panic(panicT{msg: fmt.Sprintf("FATAL: "+f, a...), code: 1})
}
