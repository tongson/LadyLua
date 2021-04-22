package main

import (
	"github.com/rs/zerolog"
	"github.com/yuin/gluamapper"
	"github.com/yuin/gopher-lua"
	"os"
	"strings"
	"time"
)

var loggerFile *os.File

const (
	LOGGER_TYPE = "logger{api}"
)

type loggerT struct {
	logger *zerolog.Logger
}

func loggerInit(logger zerolog.Logger) *loggerT {
	return &loggerT{
		&logger,
	}
}

var loggerExports = map[string]lua.LGFunction{
	"new": loggerNew,
}

func loggerCheck(L *lua.LState) *loggerT {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*loggerT); ok {
		return v
	} else {
		return nil
	}
}

func loggerLoader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), loggerExports)
	L.Push(mod)
	loggerRegister(L)
	return 1
}

func loggerRegister(L *lua.LState) {
	mt := L.NewTypeMetatable(LOGGER_TYPE)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), loggerMethods))
}

func loggerNew(L *lua.LState) int {
	zerolog.TimeFieldFormat = time.RFC3339
	ud := L.NewUserData()
	a := L.OptString(1, "stderr")
	switch a {
	case "stdout":
		ud.Value = loggerInit(zerolog.New(os.Stdout).With().Timestamp().Logger())
	case "stderr":
		ud.Value = loggerInit(zerolog.New(os.Stderr).With().Timestamp().Logger())
	default:
		loggerFile, err := os.OpenFile(a, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0644)
		if err != nil {
			ud.Value = nil
		} else {
			ud.Value = loggerInit(zerolog.New(loggerFile).With().Timestamp().Logger())
		}
	}
	L.SetMetatable(ud, L.GetTypeMetatable(LOGGER_TYPE))
	L.Push(ud)
	return 1
}

func loggerPush(L *lua.LState, event *zerolog.Event) int {
	msg := L.CheckString(2)
	stubs := L.CheckTable(3)

	gostubs := make(map[string]interface{})
	err := gluamapper.Map(stubs, &gostubs)

	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}

	for str, val := range gostubs {
		event.Interface(strings.ToLower(str), val)
	}
	event.Msg(msg)
	loggerFile.Close()
	return 0
}

var loggerMethods = map[string]lua.LGFunction{
	"info": func(L *lua.LState) int {
		logger := loggerCheck(L)
		if logger == nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("info: Invalid logger."))
			return 2
		}
		event := logger.logger.Info()
		return loggerPush(L, event)
	},
	"debug": func(L *lua.LState) int {
		logger := loggerCheck(L)
		if logger == nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("info: Invalid logger."))
			return 2
		}

		event := logger.logger.Debug()
		return loggerPush(L, event)
	},
	"warn": func(L *lua.LState) int {
		logger := loggerCheck(L)
		if logger == nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("info: Invalid logger."))
			return 2
		}
		event := logger.logger.Warn()
		return loggerPush(L, event)
	},
	"error": func(L *lua.LState) int {
		logger := loggerCheck(L)
		if logger == nil {
			L.Push(lua.LNil)
			L.Push(lua.LString("info: Invalid logger."))
			return 2
		}
		event := logger.logger.Error()
		return loggerPush(L, event)
	},
}
