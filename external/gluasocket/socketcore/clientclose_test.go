package gluasocket_socketcore_test

import (
	"fmt"
	"io"
	"net"
	"testing"
	"time"

	"github.com/nubix-io/gluasocket"
	"github.com/stretchr/testify/assert"
	"github.com/yuin/gopher-lua"
)

func TestClientClose(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()
	gluasocket.Preload(L)

	listener, err := net.Listen("tcp", "localhost:0")
	assert.NoError(err)
	port := listener.Addr().(*net.TCPAddr).Port

	accepted := false
	closed := false
	go func() {
		if conn, err := listener.Accept(); err == nil {
			accepted = true
			for {
				_, err := conn.Read(make([]byte, 1))
				if err == io.EOF {
					closed = true
					break
				}
				time.Sleep(5 * time.Millisecond)
			}
		}
	}()

	script := fmt.Sprintf(`c=require 'socket.core'.connect('%s', %d); c:close()`, "127.0.0.1", port)
	assert.NoError(L.DoString(script))

	time.Sleep(20 * time.Millisecond)
	assert.True(accepted)
	assert.True(closed)

	assert.NoError(listener.Close())
}
