package gluasocket_socketcore_test

import (
	"fmt"
	"net"
	"testing"
	"time"

	"github.com/nubix-io/gluasocket"
	"github.com/stretchr/testify/assert"
	"github.com/yuin/gopher-lua"
)

func TestMasterConnect(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()
	gluasocket.Preload(L)

	listener, err := net.Listen("tcp", "localhost:0")
	assert.NoError(err)
	defer listener.Close()
	port := listener.Addr().(*net.TCPAddr).Port

	accepted := false
	go func() {
		if _, err := listener.Accept(); err == nil {
			accepted = true
		}
	}()

	script := fmt.Sprintf(`require 'socket.core'.tcp():connect('%s', %d)`, "127.0.0.1", port)
	assert.NoError(L.DoString(script))

	time.Sleep(20 * time.Millisecond)
	assert.True(accepted)
}
