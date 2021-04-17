-- Requires buildah, crun
local stdin_userland = [[
bin/domainname
bin/findmnt
bin/lsblk
bin/nisdomainname
bin/rbash
bin/wdctl
bin/ypdomainname
bin/sh
bin/dash
bin/bash
bin/cat
bin/chgrp
bin/chmod
bin/chown
bin/cp
bin/date
bin/dd
bin/df
bin/dir
bin/echo
bin/false
bin/ln
bin/ls
bin/mkdir
bin/mknod
bin/mktemp
bin/mv
bin/pwd
bin/readlink
bin/rm
bin/rmdir
bin/sleep
bin/stty
bin/sync
bin/touch
bin/true
bin/uname
bin/vdir
usr/bin/[
usr/bin/arch
usr/bin/b2sum
usr/bin/base32
usr/bin/base64
usr/bin/basename
usr/bin/chcon
usr/bin/cksum
usr/bin/comm
usr/bin/csplit
usr/bin/cut
usr/bin/dircolors
usr/bin/dirname
usr/bin/du
usr/bin/env
usr/bin/expand
usr/bin/expr
usr/bin/factor
usr/bin/fmt
usr/bin/fold
usr/bin/groups
usr/bin/head
usr/bin/hostid
usr/bin/id
usr/bin/install
usr/bin/join
usr/bin/link
usr/bin/logname
usr/bin/md5sum
usr/bin/md5sum.textutils
usr/bin/mkfifo
usr/bin/nice
usr/bin/nl
usr/bin/nohup
usr/bin/nproc
usr/bin/numfmt
usr/bin/od
usr/bin/paste
usr/bin/pathchk
usr/bin/pinky
usr/bin/pr
usr/bin/printenv
usr/bin/printf
usr/bin/ptx
usr/bin/realpath
usr/bin/runcon
usr/bin/seq
usr/bin/sha1sum
usr/bin/sha224sum
usr/bin/sha256sum
usr/bin/sha384sum
usr/bin/sha512sum
usr/bin/shred
usr/bin/shuf
usr/bin/sort
usr/bin/split
usr/bin/stat
usr/bin/stdbuf
usr/bin/sum
usr/bin/tac
usr/bin/tail
usr/bin/tee
usr/bin/test
usr/bin/timeout
usr/bin/tr
usr/bin/truncate
usr/bin/tsort
usr/bin/tty
usr/bin/unexpand
usr/bin/uniq
usr/bin/unlink
usr/bin/users
usr/bin/wc
usr/bin/who
usr/bin/whoami
usr/bin/yes
usr/lib/x86_64-linux-gnu/coreutils/libstdbuf.so
usr/sbin/chroot
bin/egrep
bin/fgrep
bin/grep
usr/bin/rgrep
bin/gunzip
bin/gzexe
bin/gzip
bin/uncompress
bin/zcat
bin/zcmp
bin/zdiff
bin/zegrep
bin/zfgrep
bin/zforce
bin/zgrep
bin/zless
bin/zmore
bin/znew
sbin/shadowconfig
usr/bin/chage
usr/bin/chfn
usr/bin/chsh
usr/bin/expiry
usr/bin/gpasswd
usr/bin/passwd
usr/lib/tmpfiles.d/passwd.conf
usr/sbin/chmem
usr/sbin/e2freefrag
usr/sbin/e4crypt
usr/sbin/e4defrag
usr/sbin/fdformat
usr/sbin/filefrag
usr/sbin/ldattach
usr/sbin/mklost+found
usr/sbin/nologin
usr/sbin/policy-rc.d
usr/sbin/readprofile
usr/sbin/rmt
usr/sbin/rtcwake
usr/sbin/tzconfig
usr/sbin/chgpasswd
usr/sbin/chpasswd
usr/sbin/cpgr
usr/sbin/cppw
usr/sbin/groupadd
usr/sbin/groupdel
usr/sbin/groupmems
usr/sbin/groupmod
usr/sbin/grpck
usr/sbin/grpconv
usr/sbin/grpunconv
usr/sbin/newusers
usr/sbin/pwck
usr/sbin/pwconv
usr/sbin/pwunconv
usr/sbin/useradd
usr/sbin/userdel
usr/sbin/usermod
usr/sbin/vigr
usr/sbin/vipw
sbin/agetty
sbin/badblocks
sbin/blkdiscard
sbin/blkzone
sbin/cfdisk
sbin/chcpu
sbin/ctrlaltdel
sbin/debugfs
sbin/dumpe2fs
sbin/e2fsck
sbin/e2image
sbin/e2label
sbin/e2mmpstatus
sbin/e2undo
sbin/fsck.cramfs
sbin/fsck.ext2
sbin/fsck.ext3
sbin/fsck.ext4
sbin/fsck.minix
sbin/fsfreeze
sbin/fstab-decode
sbin/isosize
sbin/killall5
sbin/logsave
sbin/mke2fs
sbin/mkfs
sbin/mkfs.bfs
sbin/mkfs.cramfs
sbin/mkfs.ext2
sbin/mkfs.ext3
sbin/mkfs.ext4
sbin/mkfs.minix
sbin/raw
sbin/resize2fs
sbin/runuser
sbin/sfdisk
sbin/sulogin
sbin/swaplabel
sbin/tune2fs
sbin/wipefs
sbin/zramctl
sbin/mkhomedir_helper
sbin/pam_tally
sbin/pam_tally2
sbin/unix_chkpwd
sbin/unix_update
usr/sbin/pam_timestamp_check
usr/sbin/pam-auth-update
usr/sbin/pam_getenv
usr/sbin/addgroup
usr/sbin/adduser
usr/sbin/delgroup
usr/sbin/deluser
usr/share/adduser/adduser.conf
usr/sbin/update-passwd
usr/share/base-passwd/group.master
usr/share/base-passwd/passwd.master
bin/sed
usr/bin/find
usr/bin/xargs
usr/bin/mawk
bin/tar
usr/lib/mime/packages/tar
usr/sbin/rmt-tar
usr/sbin/tarcat
usr/bin/cmp
usr/bin/diff
usr/bin/diff3
usr/bin/sdiff
sbin/ldconfig
usr/bin/catchsegv
usr/bin/getconf
usr/bin/getent
usr/bin/iconv
usr/bin/ldd
usr/bin/locale
usr/bin/localedef
usr/bin/pldd
usr/bin/tzselect
usr/bin/zdump
usr/sbin/iconvconfig
usr/sbin/zic
bin/arch
bin/ash
bin/base64
bin/bbconfig
bin/busybox
bin/dmesg
bin/dnsdomainname
bin/dumpkmap
bin/ed
bin/fatattr
bin/fdflush
bin/fsync
bin/getopt
bin/hostname
bin/ionice
bin/iostat
bin/ipcalc
bin/kbd_mode
bin/kill
bin/link
bin/linux32
bin/linux64
bin/login
bin/lzop
bin/makemime
bin/more
bin/mount
bin/mountpoint
bin/mpstat
bin/netstat
bin/nice
bin/pidof
bin/ping
bin/ping6
bin/pipe_progress
bin/printenv
bin/ps
bin/reformime
bin/rev
bin/run-parts
bin/setpriv
bin/setserial
bin/stat
bin/su
bin/umount
bin/usleep
bin/watch
sbin/acpid
sbin/adjtimex
sbin/arp
sbin/blkid
sbin/blockdev
sbin/depmod
sbin/fbsplash
sbin/fdisk
sbin/findfs
sbin/fsck
sbin/fstrim
sbin/getty
sbin/halt
sbin/hwclock
sbin/ifconfig
sbin/ifdown
sbin/ifenslave
sbin/ifup
sbin/init
sbin/inotifyd
sbin/insmod
sbin/ip
sbin/ipaddr
sbin/iplink
sbin/ipneigh
sbin/iproute
sbin/iprule
sbin/iptunnel
sbin/klogd
sbin/loadkmap
sbin/logread
sbin/losetup
sbin/lsmod
sbin/mdev
sbin/mkdosfs
sbin/mkfs.vfat
sbin/mkmntdirs
sbin/mkswap
sbin/modinfo
sbin/modprobe
sbin/nameif
sbin/nologin
sbin/pivot_root
sbin/poweroff
sbin/raidautorun
sbin/reboot
sbin/rmmod
sbin/route
sbin/setconsole
sbin/slattach
sbin/swapoff
sbin/swapon
sbin/switch_root
sbin/sysctl
sbin/syslogd
sbin/tunctl
sbin/udhcpc
sbin/vconfig
sbin/watchdog
usr/bin
usr/bin/[[
usr/bin/awk
usr/bin/bc
usr/bin/beep
usr/bin/blkdiscard
usr/bin/bunzip2
usr/bin/bzcat
usr/bin/bzip2
usr/bin/cal
usr/bin/chvt
usr/bin/clear
usr/bin/cpio
usr/bin/crontab
usr/bin/cryptpw
usr/bin/dc
usr/bin/deallocvt
usr/bin/dos2unix
usr/bin/eject
usr/bin/fallocate
usr/bin/flock
usr/bin/free
usr/bin/fuser
usr/bin/hd
usr/bin/hexdump
usr/bin/ipcrm
usr/bin/ipcs
usr/bin/killall
usr/bin/less
usr/bin/logger
usr/bin/lsof
usr/bin/lsusb
usr/bin/lzcat
usr/bin/lzma
usr/bin/lzopcat
usr/bin/mesg
usr/bin/microcom
usr/bin/mkpasswd
usr/bin/nc
usr/bin/nmeter
usr/bin/nsenter
usr/bin/nslookup
usr/bin/openvt
usr/bin/pgrep
usr/bin/pkill
usr/bin/pmap
usr/bin/pscan
usr/bin/pstree
usr/bin/pwdx
usr/bin/readlink
usr/bin/renice
usr/bin/reset
usr/bin/resize
usr/bin/scanelf
usr/bin/setkeycodes
usr/bin/setsid
usr/bin/sha3sum
usr/bin/showkey
usr/bin/ssl_client
usr/bin/strings
usr/bin/time
usr/bin/top
usr/bin/traceroute
usr/bin/traceroute6
usr/bin/ttysize
usr/bin/udhcpc6
usr/bin/unix2dos
usr/bin/unlzma
usr/bin/unlzop
usr/bin/unshare
usr/bin/unxz
usr/bin/unzip
usr/bin/uptime
usr/bin/uudecode
usr/bin/uuencode
usr/bin/vi
usr/bin/vlock
usr/bin/volname
usr/bin/wget
usr/bin/which
usr/bin/whois
usr/bin/xxd
usr/bin/xzcat
usr/sbin/add-shell
usr/sbin/arping
usr/sbin/brctl
usr/sbin/crond
usr/sbin/ether-wake
usr/sbin/fbset
usr/sbin/killall5
usr/sbin/loadfont
usr/sbin/nanddump
usr/sbin/nandwrite
usr/sbin/nbd-client
usr/sbin/ntpd
usr/sbin/partprobe
usr/sbin/rdate
usr/sbin/rdev
usr/sbin/readahead
usr/sbin/remove-shell
usr/sbin/rfkill
usr/sbin/sendmail
usr/sbin/setfont
usr/sbin/setlogcons
etc/alternatives
etc/logrotate.d
etc/logrotate.d/acpid
etc/modprobe.d
etc/modprobe.d/aliases.conf
etc/modprobe.d/blacklist.conf
etc/modprobe.d/i386.conf
etc/modprobe.d/kms.conf
etc/modules
etc/modules-load.d
etc/network/if-down.d
etc/network/if-post-down.d
etc/network/if-post-up.d
etc/network/if-pre-down.d
etc/network/if-pre-up.d
etc/network/if-up.d
etc/periodic
lib/firmware
media
usr/lib/modules-load.d
etc/sysctl.conf
etc/sysctl.d
etc/crontabs
lib/sysctl.d
lib/modules-load.d
var/lib/systemd
etc/systemd
lib/systemd
usr/share/polkit-1
etc/cron.daily
usr/share/common-licenses
usr/share/doc
usr/share/man
usr/share/menu
usr/share/groff
usr/share/info
usr/share/lintian
usr/share/linda
usr/share/bug
usr/share/locale
usr/share/bash-completion
var/cache/man
]]
local stdin_dpkg = [[
usr/bin/dpkg
usr/bin/dpkg-deb
usr/bin/dpkg-divert
usr/bin/dpkg-maintscript-helper
usr/bin/dpkg-query
usr/bin/dpkg-split
usr/bin/dpkg-statoverride
usr/bin/dpkg-trigger
usr/bin/update-alternatives
usr/share/dpkg
etc/dpkg
usr/lib/dpkg
var/lib/dpkg
var/lib/apt
usr/bin/apt
usr/bin/apt-cache
usr/bin/apt-cdrom
usr/bin/apt-config
usr/bin/apt-get
usr/bin/apt-key
usr/bin/apt-mark
usr/lib/apt
usr/bin/debsig-verify
sbin/start-stop-daemon
etc/apt
usr/bin/deb-systemd-helper
usr/bin/deb-systemd-invoke
usr/sbin/invoke-rc.d
usr/sbin/service
usr/sbin/update-rc.d
usr/bin/gpgv
bin/run-parts
bin/tempfile
bin/which
sbin/installkernel
usr/bin/ischroot
usr/bin/savelog
usr/sbin/add-shell
usr/sbin/remove-shell
usr/share/debianutils/shells
etc/apt/apt.conf.d/01autoremove
etc/cron.daily/apt-compat
etc/kernel/postinst.d/apt-auto-removal
etc/logrotate.d/apt
lib/systemd/system/apt-daily-upgrade.service
lib/systemd/system/apt-daily-upgrade.timer
lib/systemd/system/apt-daily.service
lib/systemd/system/apt-daily.timer
usr/bin/apt
usr/bin/apt-cache
usr/bin/apt-cdrom
usr/bin/apt-config
usr/bin/apt-get
usr/bin/apt-key
usr/bin/apt-mark
usr/lib/apt
usr/lib/dpkg
usr/lib/s390x-linux-gnu/libapt-private.so.0.0
usr/lib/s390x-linux-gnu/libapt-private.so.0.0.0
usr/share/bash-completion/completions/apt
etc/debconf.conf
usr/bin/debconf
usr/bin/debconf-apt-progress
usr/bin/debconf-communicate
usr/bin/debconf-copydb
usr/bin/debconf-escape
usr/bin/debconf-set-selections
usr/bin/debconf-show
usr/sbin/dpkg-preconfigure
usr/sbin/dpkg-reconfigure
usr/share/debconf
usr/share/perl5/Debconf
usr/share/perl5/Debian
usr/share/pixmaps/debian-logo.pngG
]]
local stdin_docs = [[
usr/share/common-licenses
usr/share/doc
usr/share/man
usr/share/menu
usr/share/groff
usr/share/info
usr/share/lintian
usr/share/linda
usr/share/bug
usr/share/locale
usr/share/bash-completion
var/cache/man
]]
local list_perl = {
	"usr/bin/perl*",
	"usr/lib/*/perl*",
}
local list_apk = {
	"sbin/apk",
	"etc/apk",
	"lib/apk",
	"lib/libapk*",
	"usr/share/apk",
	"var/lib/apk",
}
local Concat = table.concat
local Gmatch = string.gmatch
local Ok = require("stdout").info
local Panic = function(msg, tbl)
	local stderr = require("stderr").error
	stderr(msg, tbl)
	os.exit(1)
end
local buildah = exec.ctx("buildah")
local Buildah = function(a, msg, tbl)
	buildah.env = { USER = os.getenv("USER"), HOME = os.getenv("HOME") }
	local r, so, se = buildah(a)
	if not r then
		tbl.stdout = so
		tbl.stderr = se
		Panic(msg, tbl)
	else
		Ok(msg, tbl)
	end
end
local ENV = {}
setmetatable(ENV, {
	__index = function(_, value)
		return rawget(ENV, value)
			or rawget(_G, value)
			or Panic("Unknown command or variable", { string = value })
	end,
})
local Name, Assets
local Creds
do
	local ruser = os.getenv("BUILDAH_USER")
	local rpass = os.getenv("BUILDAH_PASSWORD")
	if ruser and rpass then
		Creds = ruser .. ":" .. rpass
	end
end
local Mount = function()
	local r, so, se = buildah({
		"mount",
		Name,
	})
	if not r or (so == "/") then
		Panic("buildah mount", {
			name = Name,
			stdout = so,
			stderr = se,
		})
	end
	return so:sub(1, -2)
end
local Unmount = function()
	local r, so, se = buildah({
		"unmount",
		Name,
	})
	if not r then
		Panic("buildah unmount", {
			name = Name,
			stdout = so,
			stderr = se,
		})
	end
	return true
end
local Try = function(fn, args, msg)
	local tbl = {}
	local r, so, se = fn(args)
	if not r then
		tbl.stdout = so
		tbl.stderr = se
		Unmount()
		Panic(msg, tbl)
	end
end
local Epilogue = function()
	local dir = Mount()
	local rm = exec.ctx("rm")
	rm.cwd = dir
	local mkdir = exec.ctx("mkdir")
	mkdir.cwd = dir
	local msg = "epilogue"
	Try(rm, { "-r", "-f", "tmp" }, msg)
	Try(mkdir, { "-m", "01777", "tmp" }, msg)
	Try(rm, { "-r", "-f", "var/tmp" }, msg)
	Try(mkdir, { "-m", "01777", "var/tmp" }, msg)
	Try(rm, { "-r", "-f", "var/log" }, msg)
	Try(mkdir, { "-m", "0755", "var/log" }, msg)
	Try(rm, { "-r", "-f", "var/cache" }, msg)
	Try(mkdir, { "-m", "0755", "var/cache" }, msg)
	Unmount()
end
ENV.FROM = function(base, cid, assets)
	Assets = assets or fs.currentdir()
	Name = cid or require("uid").new()
	if not cid then
		local a = {
			"from",
			"--name",
			Name,
			base,
		}
		Buildah(a, "FROM", {
			image = base,
			name = Name,
		})
	else
		Ok("Reusing existing container", {
			name = Name,
		})
	end
end
ENV.ADD = function(src, dest, og)
	og = og or "root:root"
	local a = {
		"add",
		"--chown",
		og,
		Name,
		src,
		dest,
	}
	Buildah(a, "ADD", {
		source = src,
		destination = dest,
	})
end
ENV.RUN = function(v)
	local a = {
		"run",
		Name,
		"--",
	}
	local run = {}
	for k in Gmatch(v, "%S+") do
		run[#run + 1] = k
		a[#a + 1] = k
	end
	Buildah(a, "RUN", {
		name = Name,
		command = Concat(run, " "),
	})
end
ENV.SCRIPT = function(s)
	local a = {
		"run",
		"--volume",
		("%s/%s:/%s"):format(Assets, s, s),
		Name,
		"--",
		"/bin/sh",
		("/%s"):format(s),
	}
	Buildah(a, "SCRIPT", {
		script = a,
	})
end
ENV.APT_GET = function(v)
	local a = {
		"run",
		Name,
		"--",
		"/usr/bin/env",
		"LC_ALL=C",
		"DEBIAN_FRONTEND=noninteractive",
		"apt-get",
		"-qq",
		"--no-install-recommends",
		"-o",
		"APT::Install-Suggests=0",
		"-o",
		"APT::Get::AutomaticRemove=1",
		"-o",
		"Dpkg::Use-Pty=0",
		"-o",
		[[Dpkg::Options::='--force-confnew']],
		"-o",
		[[DPkg::options::='--force-unsafe-io']],
	}
	local run = {}
	for k in Gmatch(v, "%S+") do
		run[#run + 1] = k
		a[#a + 1] = k
	end
	Buildah(a, "APT_GET", {
		command = run[1],
		arg = Concat(run, " ", 2),
	})
end
ENV.APT_PURGE = function(p)
	local a = {
		"run",
		Name,
		"--",
		"dpkg",
		"--purge",
		"--no-triggers",
		"--force-remove-essential",
		"--force-breaks",
		"--force-unsafe-io",
		p,
	}
	Buildah(a, "APT_PURGE", {
		package = p,
	})
end
ENV.COPY = function(src, dest, og)
	og = og or "root:root"
	local a = {
		"copy",
		"--chown",
		og,
		Name,
		src,
		dest,
	}
	Buildah(a, "COPY", {
		source = src,
		destination = dest,
	})
end
ENV.MKDIR = function(d, mode)
	mode = mode or "0700"
	local mkdir = exec.ctx("mkdir")
	mkdir.cwd = Mount()
	local r, so, se = mkdir({
		"-m",
		mode,
		"-p",
		d:sub(2),
	})
	Unmount()
	if r then
		Ok("MKDIR", {
			directory = d,
		})
	else
		Panic("MKDIR", {
			directory = d,
			stdout = so,
			stderr = se,
		})
	end
end
ENV.CHMOD = function(mode, p)
	local chmod = exec.ctx("chmod")
	chmod.cwd = Mount()
	local r, so, se = chmod({
		mode,
		p:sub(2),
	})
	Unmount()
	if r then
		Ok("CHMOD", {
			path = p,
		})
	else
		Panic("CHMOD", {
			path = p,
			stdout = so,
			stderr = se,
		})
	end
end
ENV.RM = function(f)
	local rm = exec.ctx("rm")
	rm.cwd = Mount()
	local frm = function(ff)
		local r, so, se = rm({
			"-r",
			"-f",
			ff:sub(2),
		})
		if r then
			Ok("RM", {
				file = ff,
			})
		else
			Unmount()
			Panic("RM", {
				file = ff,
				stdout = so,
				stderr = se,
			})
		end
	end
	if type(f) == "table" and next(f) then
		for _, r in ipairs(f) do
			frm(r)
		end
	else
		frm(f)
	end
	Unmount()
end
ENV.CONFIG = function(config)
	for k, v in pairs(config) do
		local a = {
			"config",
			("--%s"):format(k),
			([['%s']]):format(v),
			Name,
		}
		Buildah(a, "CONFIG", {
			config = k,
			value = v,
		})
	end
end
ENV.ENTRYPOINT = function(entrypoint)
	local a = {
		"config",
		"--entrypoint",
		([['[\"%s\"]']]):format(entrypoint),
		Name,
	}
	Buildah(a, "ENTRYPOINT(exe)", {
		entrypoint = entrypoint,
	})
	a = {
		"config",
		"--cmd",
		[['']],
		Name,
	}
	Buildah(a, "ENTRYPOINT(cmd)", {
		cmd = [['']],
	})
	a = {
		"config",
		"--stop-signal",
		"TERM",
		Name,
	}
	Buildah(a, "ENTRYPOINT(term)", {
		term = "TERM",
	})
end
ENV.ARCHIVE = function(cname)
	Epilogue()
	local a = {
		"commit",
		"--rm",
		"--squash",
		Name,
		("oci-archive:%s"):format(cname),
	}
	Buildah(a, "ARCHIVE", {
		name = Name,
		archive = cname,
	})
end
ENV.DIR = function(dirname)
	Epilogue()
	local a = {
		"commit",
		"--rm",
		"--squash",
		Name,
		("dir:%s"):format(dirname),
	}
	Buildah(a, "DIR", {
		name = Name,
		path = dirname,
	})
end
ENV.TAR = function(filename)
	local location = "/tmp/" .. Name
	local script = [[
TAR=$(find %s -maxdepth 1 -type f -exec file {} \+ | awk -F\: '/archive/{print $1}')
mv "${TAR}" "%s"
rm -rf "%s"
]]
	Epilogue()
	local a = {
		"commit",
		"--rm",
		"--squash",
		Name,
		("dir:%s"):format(location),
	}
	Buildah(a, "DIR->TAR", {
		name = Name,
		path = location,
	})
	local sh = exec.ctx("sh")
	local r, so, se = sh({
		"-c",
		script:format(location, filename, location),
	})
	if r then
		Ok("TAR", {
			file = filename,
		})
	else
		Panic("TAR", {
			stdout = so,
			stderr = se,
		})
	end
end
ENV.PURGE = function(a, opts)
	if a == "debian" or a == "dpkg" then
		local xargs = exec.ctx("xargs")
		xargs.cwd = Mount()
		xargs.stdin = stdin_dpkg
		local r, so, se = xargs({ "rm", "-r", "-f" })
		Unmount()
		if r then
			Ok("PURGE(dpkg)", {})
		else
			Panic("PURGE(dpkg)", {
				stdout = so,
				stderr = se,
			})
		end
	end
	if a == "perl" then
		local sh = exec.ctx("sh")
		sh.cwd = Mount()
		for _, v in ipairs(list_perl) do
			Try(sh, { "-c", ([[rm -rf -- %s]]):format(v) }, "PURGE(perl)")
		end
		Unmount()
		Ok("PURGE(perl)", {})
	end
	if a == "apk" or a == "apk-tools" then
		local sh = exec.ctx("sh")
		sh.cwd = Mount()
		for _, v in ipairs(list_apk) do
			Try(sh, { "-c", ([[rm -rf -- %s]]):format(v) }, "PURGE(apk-tools)")
		end
		Unmount()
		Ok("PURGE(apk-tools)", {})
	end
	if a == "userland" then
		local sh = exec.ctx("sh")
		sh.cwd = Mount()
		local tbl = stdin_userland:to_map()
		if opts then
			for _, f in ipairs(opts) do
				tbl[f] = nil
			end
		end
		for v in next, tbl do
			Try(sh, { "-c", ([[rm -rf -- %s]]):format(v) }, "PURGE(userland)")
		end
		Unmount()
		Ok("PURGE(userland)", {})
	end
	if a == "docs" or a == "documentation" then
		local xargs = exec.ctx("xargs")
		xargs.cwd = Mount()
		xargs.stdin = stdin_docs
		local r, so, se = xargs({ "rm", "-r", "-f" })
		Unmount()
		if r then
			Ok("PURGE(docs)", {})
		else
			Panic("PURGE(docs)", {
				stdout = so,
				stderr = se,
			})
		end
	end
end
setfenv(3, ENV)
