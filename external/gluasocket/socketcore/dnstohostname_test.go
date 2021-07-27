package gluasocket_socketcore_test

import (
	"testing"

	"github.com/nubix-io/gluasocket"
	"github.com/stretchr/testify/assert"
	"github.com/yuin/gopher-lua"
)

func TestDnsToHostnameLocalhost(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()
	gluasocket.Preload(L)

	assert.NoError(L.DoString("return require 'socket.core'.dns.tohostname('8.8.8.8')"))
	assert.Equal("dns.google.", L.ToString(-2))
}
