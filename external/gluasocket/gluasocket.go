package gluasocket

import (
	"github.com/tongson/LadyLua/external/gluasocket/socket"
	"github.com/tongson/LadyLua/external/gluasocket/socketcore"
	"github.com/yuin/gopher-lua"
)

func Preload(L *lua.LState) {
	L.PreloadModule("socket", gluasocket_socket.Loader)
	L.PreloadModule("socket.core", gluasocket_socketcore.Loader)
}
