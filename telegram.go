package main

import (
	"github.com/go-telegram-bot-api/telegram-bot-api"
	"github.com/yuin/gopher-lua"
	"os"
)

const (
	TELEGRAM_TYPE = "telegram{bot}"
)

func telegramCheck(L *lua.LState) *tgbotapi.BotAPI {
	ud := L.CheckUserData(1)
	if v, ok := ud.Value.(*tgbotapi.BotAPI); ok {
		return v
	} else {
		return nil
	}
}

func telegramMessage(L *lua.LState) int {
	bot := telegramCheck(L)
	if bot == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("telegram.message: Initializing with Telegram token failed."))
		return 2
	}
	i := L.CheckInt64(2)
	m := L.CheckString(3)
	msg := tgbotapi.NewMessage(i, m)
	if _, err := bot.Send(msg); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func telegramChannelMessage(L *lua.LState) int {
	bot := telegramCheck(L)
	if bot == nil {
		L.Push(lua.LNil)
		L.Push(lua.LString("telegram.channel: Initializing with Telegram token failed."))
		return 1
	}
	c := L.CheckString(2)
	m := L.CheckString(3)
	msg := tgbotapi.NewMessageToChannel(c, m)
	if _, err := bot.Send(msg); err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

var telegramMethods = map[string]lua.LGFunction{
	"message": telegramMessage,
	"channel": telegramChannelMessage,
}

var telegramExports = map[string]lua.LGFunction{
	"new": telegramNew,
}

func telegramLoader(L *lua.LState) int {
	mod := L.SetFuncs(L.NewTable(), telegramExports)
	L.Push(mod)
	telegramRegister(L)
	return 1
}

func telegramRegister(L *lua.LState) {
	mt := L.NewTypeMetatable(TELEGRAM_TYPE)
	L.SetField(mt, "__index", L.SetFuncs(L.NewTable(), telegramMethods))
}

func telegramNew(L *lua.LState) int {
	token := os.Getenv("TELEGRAM_TOKEN")
	ud := L.NewUserData()
	bot, err := tgbotapi.NewBotAPI(token)
	if err == nil {
		ud.Value = bot
	} else {
		ud.Value = nil
	}
	L.SetMetatable(ud, L.GetTypeMetatable(TELEGRAM_TYPE))
	L.Push(ud)
	return 1
}
