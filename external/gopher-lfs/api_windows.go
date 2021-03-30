// +build windows

package lfs

import (
	"os"
	"syscall"
	"time"

	"github.com/yuin/gopher-lua"
)

func attributesFill(tbl *lua.LTable, stat os.FileInfo) error {
	sys := stat.Sys().(*syscall.Win32FileAttributeData)
	tbl.RawSetString("dev", lua.LNumber(0))
	tbl.RawSetString("ino", lua.LNumber(0))

	if stat.IsDir() {
		tbl.RawSetString("mode", lua.LString("directory"))
	} else {
		tbl.RawSetString("mode", lua.LString("file"))
	}

	tbl.RawSetString("nlink", lua.LNumber(0))
	tbl.RawSetString("uid", lua.LNumber(0))
	tbl.RawSetString("gid", lua.LNumber(0))
	tbl.RawSetString("rdev", lua.LNumber(0))

	tbl.RawSetString("access", lua.LNumber(time.Unix(0, sys.LastAccessTime.Nanoseconds()/1e9).Second()))
	tbl.RawSetString("modification", lua.LNumber(time.Unix(0, sys.CreationTime.Nanoseconds()/1e9).Second()))
	tbl.RawSetString("change", lua.LNumber(time.Unix(0, sys.LastWriteTime.Nanoseconds()/1e9).Second()))
	tbl.RawSetString("size", lua.LNumber(stat.Size()))

	tbl.RawSetString("blocks", lua.LNumber(0))
	tbl.RawSetString("blksize", lua.LNumber(0))
	return nil
}
