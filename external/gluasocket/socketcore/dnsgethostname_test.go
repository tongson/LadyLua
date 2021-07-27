package gluasocket_socketcore_test

import (
	"os"
	"testing"

	"github.com/nubix-io/gluasocket/socketcore"
	"github.com/stretchr/testify/assert"
	"github.com/yuin/gopher-lua"
)

func TestDnsGetHostName(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()

	L.PreloadModule("socket.core", gluasocket_socketcore.Loader)

	expected, err := os.Hostname()
	assert.NoError(err)

	assert.NoError(L.DoString(`return require 'socket.core'.dns.gethostname()`))
	actual := L.Get(-1)

	assert.Equal(expected, actual.String())
}
