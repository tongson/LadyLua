// +build linux

package lfs

import (
	"os"
	"syscall"

	"github.com/yuin/gopher-lua"
)

func attributesFill(tbl *lua.LTable, stat os.FileInfo) error {
	sys := stat.Sys().(*syscall.Stat_t)
	tbl.RawSetString("dev", lua.LNumber(sys.Dev))
	tbl.RawSetString("ino", lua.LNumber(sys.Ino))
	{
		var mode string
		switch sys.Mode & syscall.S_IFMT {
		case syscall.S_IFREG:
			mode = "file"
		case syscall.S_IFDIR:
			mode = "directory"
		case syscall.S_IFLNK:
			mode = "link"
		case syscall.S_IFSOCK:
			mode = "socket"
		case syscall.S_IFIFO:
			mode = "named pipe"
		case syscall.S_IFCHR:
			mode = "char device"
		case syscall.S_IFBLK:
			mode = "block device"
		default:
			mode = "other"
		}
		tbl.RawSetString("mode", lua.LString(mode))
	}
	tbl.RawSetString("nlink", lua.LNumber(sys.Nlink))
	tbl.RawSetString("uid", lua.LNumber(sys.Uid))
	tbl.RawSetString("gid", lua.LNumber(sys.Gid))
	tbl.RawSetString("rdev", lua.LNumber(sys.Rdev))
	tbl.RawSetString("access", lua.LNumber(sys.Atim.Sec))
	tbl.RawSetString("modification", lua.LNumber(sys.Mtim.Sec))
	tbl.RawSetString("change", lua.LNumber(sys.Ctim.Sec))
	tbl.RawSetString("size", lua.LNumber(sys.Size))
	tbl.RawSetString("blocks", lua.LNumber(sys.Blocks))
	tbl.RawSetString("blksize", lua.LNumber(sys.Blksize))
	return nil
}
