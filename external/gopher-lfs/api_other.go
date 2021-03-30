// +build !darwin,!linux,!windows

package lfs

import (
	"errors"
	"os"
	"runtime"

	"github.com/yuin/gopher-lua"
)

func attributesFill(tbl *lua.LTable, stat os.FileInfo) error {
	return errors.New("unsupported operating system " + runtime.GOOS)
}
