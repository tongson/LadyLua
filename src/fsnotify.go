package ll

import (
	"github.com/fsnotify/fsnotify"
	"github.com/yuin/gopher-lua"
)

func fsnCreate(L *lua.LState) int {
	var got bool
	var ero string
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	defer watcher.Close()
	f := L.CheckString(1)
	done := make(chan bool)
	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				if event.Op&fsnotify.Create == fsnotify.Create {
					got = true
					close(done)
					return
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				ero = err.Error()
				return
			}
		}
	}()
	err = watcher.Add(f)
	<-done
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	if got == true {
		L.Push(lua.LTrue)
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString(ero))
		return 2
	}
}

func fsnWrite(L *lua.LState) int {
	var got bool
	var ero string
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	defer watcher.Close()
	f := L.CheckString(1)
	done := make(chan bool)
	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				if event.Op&fsnotify.Write == fsnotify.Write {
					got = true
					close(done)
					return
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				ero = err.Error()
				return
			}
		}
	}()
	err = watcher.Add(f)
	<-done
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	if got == true {
		L.Push(lua.LTrue)
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString(ero))
		return 2
	}
}

func fsnRemove(L *lua.LState) int {
	var got bool
	var ero string
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	defer watcher.Close()
	f := L.CheckString(1)
	done := make(chan bool)
	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				if event.Op&fsnotify.Remove == fsnotify.Remove {
					got = true
					close(done)
					return
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				ero = err.Error()
				return
			}
		}
	}()
	err = watcher.Add(f)
	<-done
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	if got == true {
		L.Push(lua.LTrue)
		return 1
	} else {
		L.Push(lua.LNil)
		L.Push(lua.LString(ero))
		return 2
	}
}

func FsnLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, fsnApi)
	L.Push(t)
	return 1
}

var fsnApi = map[string]lua.LGFunction{
	"create": fsnCreate,
	"write":  fsnWrite,
	"remove": fsnRemove,
}
