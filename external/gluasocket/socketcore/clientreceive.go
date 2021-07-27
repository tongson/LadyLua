package gluasocket_socketcore

import (
	"bytes"
	"io"
	"net"
	"time"

	"github.com/yuin/gopher-lua"
)

func clientReceiveMethod(L *lua.LState) int {
	client := checkClient(L)
	pattern := L.Get(2)
	//prefix := "" // TODO L.CheckString(3)

	// Read a number of bytes from the socket
	if pattern.Type() == lua.LTNumber {
		if client.Timeout <= 0 {
			client.Conn.SetDeadline(time.Time{})
		} else {
			client.Conn.SetDeadline(time.Now().Add(client.Timeout))
		}
		var buf bytes.Buffer
		bytesToRead := L.ToInt(2)
		for i := 0; i < bytesToRead; i++ {
			byte, err := client.Reader.ReadByte()
			if err == io.EOF {
				break
			}
			if err != nil {
				errstr := err.Error()
				if err, ok := err.(net.Error); ok && err.Timeout() {
					errstr = "timeout"
				}
				L.Push(lua.LNil)
				L.Push(lua.LString(errstr))
				return 2
			}
			buf.WriteByte(byte)
		}
		L.Push(lua.LString(string(buf.Bytes())))
		return 1
	}

	// Read a line of text from the socket. Line separators are not returned.
	// This is the default pattern so nil is the same as "*l".
	if pattern.Type() == lua.LTNil || (pattern.Type() == lua.LTString && pattern.String() == "*l") {
		var buf bytes.Buffer
		for {
			if client.Timeout <= 0 {
				client.Conn.SetDeadline(time.Time{})
			} else {
				client.Conn.SetDeadline(time.Now().Add(client.Timeout))
			}
			line, isPrefix, err := client.Reader.ReadLine()
			if err != nil {
				errstr := err.Error()
				if err, ok := err.(net.Error); ok && err.Timeout() {
					errstr = "timeout"
				}
				L.Push(lua.LNil)
				L.Push(lua.LString(errstr))
				return 2
			}
			buf.Write(line)
			if !isPrefix {
				break
			}
		}
		L.Push(lua.LString(string(buf.Bytes())))
		return 1
	}

	// Read until the connection is closed
	if pattern.Type() == lua.LTString && pattern.String() == "*a" {
		if client.Timeout <= 0 {
			client.Conn.SetDeadline(time.Time{})
		} else {
			client.Conn.SetDeadline(time.Now().Add(client.Timeout))
		}
		var buf bytes.Buffer
		for {
			byte, err := client.Reader.ReadByte()
			if err == io.EOF {
				break
			}
			if err != nil {
				errstr := err.Error()
				if err, ok := err.(net.Error); ok && err.Timeout() {
					errstr = "timeout"
				}
				L.Push(lua.LNil)
				L.Push(lua.LString(errstr))
				return 2
			}
			buf.WriteByte(byte)
		}
		L.Push(lua.LString(string(buf.Bytes())))
		return 1
	}

	L.RaiseError("client:receive() not implemented yet")
	return 0
}
