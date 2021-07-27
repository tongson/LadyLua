package gluasocket_socketcore_test

import (
	"fmt"
	"testing"

	"github.com/nubix-io/gluasocket"
	"github.com/stretchr/testify/assert"
	"github.com/yuin/gopher-lua"
)

func TestMasterBind(t *testing.T) {
	assert := assert.New(t)
	L := lua.NewState()
	defer L.Close()
	gluasocket.Preload(L)

	script := fmt.Sprintf(`require 'socket'.bind('%s', '%s')`, "localhost", "8383")
	assert.NoError(L.DoString(script))
}
