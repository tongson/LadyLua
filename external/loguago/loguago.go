package loguago

import (
	"strings"

	"github.com/rs/zerolog"
	"github.com/yuin/gluamapper"
	"github.com/yuin/gopher-lua"
)

func log(state *lua.LState, event *zerolog.Event) int {
	msg := state.CheckString(1)
	stubs := state.CheckTable(2)

	gostubs := make(map[string]interface{})
	err := gluamapper.Map(stubs, &gostubs)

	if err != nil {
		state.Push(lua.LNil)
		state.Push(lua.LString(err.Error()))

		return 2
	}

	for str, val := range gostubs {
		event.Interface(strings.ToLower(str), val)
	}

	event.Msg(msg)
	return 0
}

// Logger is a simple type used to manage
// the state and backing zerolog.Logger
type Logger struct {
	logger *zerolog.Logger
}

// NewLogger creates and returns a new logger
// using an existing zerolog.Logger
func NewLogger(logger zerolog.Logger) *Logger {
	return &Logger{
		&logger,
	}
}

// Loader is the default stub used by the Gopher-Lua
// PreloadModule function.
func (logmod *Logger) Loader(state *lua.LState) int {
	logger := logmod.logger

	exports := map[string]lua.LGFunction{
		"info": func(l *lua.LState) int {
			event := logger.Info()
			return log(l, event)
		},
		"debug": func(l *lua.LState) int {
			event := logger.Debug()
			return log(l, event)
		},
		"warn": func(l *lua.LState) int {
			event := logger.Warn()
			return log(l, event)
		},
		"error": func(l *lua.LState) int {
			event := logger.Error()
			return log(l, event)
		},
	}

	mod := state.SetFuncs(state.NewTable(), exports)
	state.Push(mod)

	return 1
}
