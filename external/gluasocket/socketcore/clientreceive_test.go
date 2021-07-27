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

func TestClientReceiveLines(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()
	gluasocket.Preload(L)

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	assert.NoError(err)
	port := listener.Addr().(*net.TCPAddr).Port

	accepted := false
	closed := false
	go func() {
		if conn, err := listener.Accept(); err == nil {
			accepted = true
			conn.Write([]byte("abc\n"))
			time.Sleep(5 * time.Millisecond)
			conn.Write([]byte("123\n"))
			time.Sleep(5 * time.Millisecond)
			closed = true
			conn.Close()
		}
	}()

	script := fmt.Sprintf(`c=require 'socket.core'.connect('%s', %d); x=c:receive('*l'); y=c:receive(); c:close(); return x,y`, "127.0.0.1", port)
	assert.NoError(L.DoString(script))

	time.Sleep(20 * time.Millisecond)
	assert.True(accepted)
	assert.True(closed)
	assert.Equal("abc", L.ToString(-2))
	assert.Equal("123", L.ToString(-1))
	assert.NoError(listener.Close())
}

func TestClientReceiveBytes(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()
	gluasocket.Preload(L)

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	assert.NoError(err)
	port := listener.Addr().(*net.TCPAddr).Port

	accepted := false
	closed := false
	go func() {
		if conn, err := listener.Accept(); err == nil {
			accepted = true
			conn.Write([]byte("abc\n"))
			time.Sleep(5 * time.Millisecond)
			conn.Write([]byte("123\n"))
			time.Sleep(5 * time.Millisecond)
			closed = true
			conn.Close()
		}
	}()

	script := fmt.Sprintf(`c=require 'socket.core'.connect('%s', %d); x=c:receive(1); y=c:receive(5); z=c:receive('*a'); c:close(); return x,y,z`, "127.0.0.1", port)
	assert.NoError(L.DoString(script))

	time.Sleep(20 * time.Millisecond)
	assert.True(accepted)
	assert.True(closed)
	assert.Equal("a", L.ToString(-3))
	assert.Equal("bc\n12", L.ToString(-2))
	assert.Equal("3\n", L.ToString(-1))
	assert.NoError(listener.Close())
}

func TestClientReceiveUntilClose(t *testing.T) {
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
			conn.Write([]byte("abc\n"))
			time.Sleep(5 * time.Millisecond)
			conn.Write([]byte("123\n"))
			time.Sleep(5 * time.Millisecond)
			closed = true
			conn.Close()
		}
	}()

	script := fmt.Sprintf(`c=require 'socket.core'.connect('%s', %d); x=c:receive('*a'); c:close(); return x`, "127.0.0.1", port)
	assert.NoError(L.DoString(script))

	time.Sleep(20 * time.Millisecond)
	assert.True(accepted)
	assert.True(closed)
	assert.Equal("abc\n123\n", L.ToString(-1))
	assert.NoError(listener.Close())
}
