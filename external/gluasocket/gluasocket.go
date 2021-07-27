package gluasocket

import (
	"github.com/nubix-io/gluasocket/socket"
	"github.com/nubix-io/gluasocket/socketcore"
	"github.com/yuin/gopher-lua"
)

func Preload(L *lua.LState) {
	L.PreloadModule("socket", gluasocket_socket.Loader)
	L.PreloadModule("socket.core", gluasocket_socketcore.Loader)
}
