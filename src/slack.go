package ll

import (
	"github.com/slack-go/slack"
	"github.com/yuin/gluamapper"
	"github.com/yuin/gopher-lua"
	"os"
)

func slackWebhookMessage(L *lua.LState) int {
	a := L.CheckString(1)
	msg := slack.WebhookMessage{
		Text: a,
	}
	token := "https://hooks.slack.com/services/" + os.Getenv("SLACK_WEBHOOK")
	err := slack.PostWebhook(token, &msg)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func slackWebhookAttachment(L *lua.LState) int {
	a := L.CheckTable(1)
	var gostubs slack.Attachment
	{
		err := gluamapper.Map(a, &gostubs)

		if err != nil {
			L.Push(lua.LNil)
			L.Push(lua.LString(err.Error()))
			return 2
		}
	}
	msg := slack.WebhookMessage{
		Attachments: []slack.Attachment{gostubs},
	}
	token := "https://hooks.slack.com/services/" + os.Getenv("SLACK_WEBHOOK")
	err := slack.PostWebhook(token, &msg)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LTrue)
	return 1
}

func slackLoader(L *lua.LState) int {
	t := L.NewTable()
	L.SetFuncs(t, slackApi)
	L.Push(t)
	return 1
}

var slackApi = map[string]lua.LGFunction{
	"attachment": slackWebhookAttachment,
	"message":    slackWebhookMessage,
}
