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
usr/share/gcc-8
lib/udev
etc/selinux
usr/lib/x86_64-linux-gnu/audit
usr/share/polkit-1
etc/cron.daily
usr/share/common-licenses
usr/share/doc
usr/share/doc-base
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
usr/share/keyrings
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
usr/share/doc-base
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
local Notify_Toggle = {}
local Notify = function()
end
local Concat = table.concat
local Insert = table.insert
local Util = require("util")
local Gmatch = string.gmatch
local Setmetatable = setmetatable
local Next = next
local Logger = require("logger")
local Ok = function(msg, tbl)
	local stdout = Logger.new("stdout")
	tbl._ident = "buildah.lua"
	stdout:info(msg, tbl)
end
local Panic = function(msg, tbl)
	local trace = function()
		local frame = 1
		local stack = {}
		while true do
			local info = debug.getinfo(frame, "Sl")
			if not info then
				break
			end
			if info.source ~= "<string>" and info.currentline ~= -1 then
				if info.source and info.currentline then
					stack[#stack + 1] = info.source .. ":" .. tostring(info.currentline)
				end
			end
			frame = frame + 1
		end
		local xstack = {}
		for i = #stack, 1, -1 do
			xstack[#xstack + 1] = stack[i]
		end
		return table.concat(xstack, " → ")
	end
	local stderr = Logger.new()
	tbl._ident = "lbuildah"
	tbl.stack = trace()
	stderr:error(msg, tbl)
	Notify(msg, tbl)
	os.exit(1)
end
local Trim = function(s)
	local sub = string.sub
	local n = 1
	local c = sub(s, n, n)
	while c == "/" do
		n = n + 1
		c = sub(s, n, n)
	end
	return sub(s, n)
end
local buildah = exec.ctx("buildah")
buildah.env = { USER = os.getenv("USER"), HOME = os.getenv("HOME") }
local Buildah = function(msg)
	local set = {}
	return Setmetatable(set, {
		__call = function(_, a)
			a = a or ""
			set.log = set.log or {}
			local t = {}
			local c = set.cmd
			for k in Gmatch(a, "%S+") do
				c[#c + 1] = k
				t[#t + 1] = k
			end
			set.log.args = Next(t) and Concat(t, " ")
			local r, so, se, err = buildah(c)
			if not r then
				set.log.stdout = so
				set.log.stderr = se
				set.log.error = err
				Panic(msg, set.log)
			else
				local final = {
					COMMIT = true,
					PUSH = true,
					ARCHIVE = true,
					DIR = true,
				}
				if final[msg] then
					Notify(msg, set.log)
				end
				Ok(msg, set.log)
			end
		end,
	})
end
local ENV = {}
local LOCAL = {}
Setmetatable(ENV, {
	__newindex = function(_, k, v)
		return rawset(LOCAL, k, v)
	end,
	__index = function(_, value)
		return rawget(LOCAL, value) or rawget(_G, value) or Panic("Unknown command or variable", { string = value })
	end,
})
local Name, Assets
local Creds
do
	local ruser = os.getenv("BUILDAH_USER")
	local rpass = os.getenv("BUILDAH_PASS")
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
local Json = require("json")
ENV.NOTIFY = Setmetatable({}, {
	__newindex = function(_, k, v)
		local key = k:upper()
		Notify_Toggle[key] = v
		Notify = function(msg, tbl)
			tbl.message = msg
			tbl.time = Logger.time()
			tbl._ident = "buildah.lua"
			local payload = Json.encode(tbl)
			if Notify_Toggle.TELEGRAM then
				local telegram = require("telegram")
				local api = telegram.new()
				local send = Util.retry_f(api.channel)
				send(api, Notify_Toggle.TELEGRAM, payload)
			end
			if Notify_Toggle.PUSHOVER then
				local pushover = require("pushover")
				local api = pushover.new()
				local send = Util.retry_f(api.message)
				send(api, Notify_Toggle.PUSHOVER, payload)
			end
			if Notify_Toggle.SLACK then
				local slack = require("slack")
				local attachment = {
					Fallback = payload,
					Color = "#2eb886",
					AuthorName = tbl.name,
					AuthorSubname = tbl.message,
					AuthorLink = "https://github.com/tongson/buildah.lua",
					AuthorIcon = "https://avatars2.githubusercontent.com/u/652790",
					Text = "```" .. payload .. "```",
					Footer = "buildah.lua",
					FooterIcon = "https://platform.slack-edge.com/img/default_application_icon.png",
				}
				local send = Util.retry_f(slack.attachment)
				send(attachment)
			end
		end
	end,
})
ENV.FROM = function(base, cname, assets)
	Name = cname or require("ksuid").new()
	local found = function()
		local _, so, _ = buildah({
			"containers",
			"--json",
		})
		local j = Json.decode(so)
		for _, v in ipairs(j) do
			if v.containername == Name then
				return true
			end
		end
	end
	Assets = assets or fs.currentdir()
	base = base or "scratch"
	if not found() then
		local B = Buildah("FROM")
		B.cmd = {
			"from",
			"--name",
			Name,
			base,
		}
		B.log = {
			image = base,
			name = Name,
		}
		Notify("FROM", { base = base, name = Name })
		B()
	else
		Notify("FROM", { base = "reusing", name = Name })
		Ok("Reusing existing container", {
			name = Name,
		})
	end
end
ENV.ADD = function(src, dest, og, mo)
	if not Name then
		Ok("ADD", { skip = true, name = false })
		return
	end
	local B = Buildah("ADD")
	B.cmd = {
		"add",
		Name,
		src,
		dest,
	}
	if og then
		Insert(B.cmd, 2, og)
		Insert(B.cmd, 2, "--chown")
	end
	if mo then
		Insert(B.cmd, 2, mo)
		Insert(B.cmd, 2, "--chmod")
	end
	B.log = {
		source = src,
		destination = dest,
	}
	B()
end
ENV.RUN = function(v)
	if not Name then
		Ok("RUN", { skip = true, name = false })
		return
	end
	local B = Buildah("RUN")
	B.cmd = {
		"run",
		Name,
		"--",
	}
	B(v)
end
ENV.SH = function(sc)
	if not Name then
		Ok("SH", { skip = true, name = false })
		return
	end
	local B = Buildah("SH")
	B.cmd = {
		"run",
		Name,
		"--",
		"/bin/sh",
		"-c",
		sc,
	}
	B()
end
ENV.RR = function(dir, a)
	if not Name then
		Ok("RR", { skip = true, name = false })
		return
	end
	local sc = [[
	cd __DIR__
	rr __RERUN__
	]]
	sc = sc:gsub("__DIR__", dir)
	sc = sc:gsub("__RERUN__", a)
	local B = Buildah("RR")
	B.cmd = {
		"run",
		Name,
		"--",
		"/bin/sh",
		"-c",
		sc,
	}
	B.log = {
		directory = dir,
		arguments = a,
	}
	B()
end
ENV.SCRIPT = function(s)
	if not Name then
		Ok("SCRIPT", { skip = true, name = false })
		return
	end
	local script = [[chroot %s /bin/sh <<-'__58jvnv82_04fimmv'
%s
__58jvnv82_04fimmv
]]
	local str = fs.read(Assets .. "/" .. s)
	local cwd = Mount()
	local sh = exec.ctx("sh")
	local r, so, se, err = sh({
		"-c",
		script:format(cwd, str),
	})
	Unmount()
	if r then
		Ok("SCRIPT", {
			script = s,
		})
	else
		Panic("SCRIPT", {
			stdout = so,
			stderr = se,
			error = err,
		})
	end
end
ENV.APT_GET = function(v)
	if not Name then
		Ok("APT_GET", { skip = true, name = false })
		return
	end
	local B = Buildah("APT_GET")
	B.cmd = {
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
		[[Dpkg::Options::=--force-confnew]],
		"-o",
		[[DPkg::Options::=--force-unsafe-io]],
	}
	B(v)
end
ENV.APT_PURGE = function(p)
	if not Name then
		Ok("APT_PURGE", { skip = true, name = false })
		return
	end
	local B = Buildah("APT_PURGE")
	B.cmd = {
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
	B.log = { package = p }
	B()
end
ENV.APK = function(v)
	if not Name then
		Ok("APK", { skip = true, name = false })
		return
	end
	local B = Buildah("APK")
	B.cmd = {
		"run",
		Name,
		"--",
		"/sbin/apk",
		"--no-progress",
		"--no-cache",
	}
	B(v)
end
ENV.COPY = function(src, dest, og, mo)
	if not Name then
		Ok("COPY", { skip = true, name = false })
		return
	end
	dest = dest or "/" .. src
	if src:sub(1, 1) ~= "/" then
		src = Assets .. "/" .. src
	end
	local B = Buildah("COPY/UPLOAD")
	B.cmd = {
		"copy",
		Name,
		src,
		dest,
	}
	if og then
		Insert(B.cmd, 2, og)
		Insert(B.cmd, 2, "--chown")
	end
	if mo then
		Insert(B.cmd, 2, mo)
		Insert(B.cmd, 2, "--chmod")
	end
	B.log = {
		source = src,
		destination = dest,
	}
	B()
end
ENV.UPLOAD = ENV.COPY
ENV.MKDIR = function(d, mode)
	if not Name then
		Ok("MKDIR", { skip = true, name = false })
		return
	end
	local mkdir = exec.ctx("mkdir")
	mkdir.cwd = Mount()
	local t = {
		"-p",
		Trim(d),
	}
	if mode then
		Insert(t, 2, mode)
		Insert(t, 2, "-m")
	end
	local r, so, se = mkdir(t)
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
ENV.CHMOD = function(p, mode)
	if not Name then
		Ok("CHMOD", { skip = true, name = false })
		return
	end
	local chmod = exec.ctx("chmod")
	chmod.cwd = Mount()
	local r, so, se = chmod({
		mode,
		Trim(p),
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
ENV.DOWNLOAD = function(src, dest)
	if not Name then
		Ok("DOWNLOAD", { skip = true, name = false })
		return
	end
	local cwd = fs.currentdir()
	local rd
	dest = dest or "."
	if dest:sub(1, 1) == "/" then
		rd = dest
	else
		rd = cwd .. "/" .. dest
	end
	local cp = exec.ctx("cp")
	cp.cwd = Mount()
	local r, so, se = cp({
		"-R",
		"-P",
		"-n",
		Trim(src),
		rd,
	})
	Unmount()
	if r then
		Ok("DOWNLOAD", {
			source = src,
			destination = dest,
		})
	else
		Panic("DOWNLOAD", {
			source = src,
			destination = dest,
			stdout = so,
			stderr = se,
		})
	end
end
ENV.RM = function(f)
	if not Name then
		Ok("RM", { skip = true, name = false })
		return
	end
	local rm = exec.ctx("rm")
	rm.cwd = Mount()
	local frm = function(ff)
		local r, so, se = rm({
			"-r",
			"-f",
			Trim(ff),
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
ENV.CONFIG = Setmetatable({}, {
	__newindex = function(_, k, v)
		k = k:lower()
		local B = Buildah("CONFIG")
		B.cmd = {
			"config",
			("--%s"):format(k),
			([[%s]]):format(v),
			Name,
		}
		B.log = {
			config = k,
			value = v,
		}
		B()
	end,
})
ENV.ENTRYPOINT = function(...)
	local entrypoint = Json.encode({ ... })
	do
		local B = Buildah("ENTRYPOINT(exe)")
		B.cmd = {
			"config",
			"--entrypoint",
			([[%s]]):format(entrypoint),
			Name,
		}
		B.log = {
			entrypoint = entrypoint,
		}
		B()
	end
	do
		local B = Buildah("ENTRYPOINT(term)")
		B.cmd = {
			"config",
			"--stop-signal",
			"TERM",
			Name,
		}
		B.log = {
			term = "TERM",
		}
		B()
	end
end
ENV.ARCHIVE = function(cname)
	Epilogue()
	local B = Buildah("ARCHIVE")
	B.cmd = {
		"commit",
		"--rm",
		"--squash",
		Name,
		("oci-archive:%s"):format(cname),
	}
	B.log = {
		name = Name,
		archive = cname,
	}
	B()
end
ENV.COMMIT = function(cname)
	Epilogue()
	local B = Buildah("COMMIT")
	B.cmd = {
		"commit",
		"--rm",
		"--squash",
		Name,
		("containers-storage:%s"):format(cname),
	}
	B.log = {
		name = Name,
		image = cname,
	}
	B()
end
ENV.PUSH = function(lc, cname)
	local B = Buildah("PUSH")
	B.cmd = {
		"push",
		"--creds",
		("%s"):format(Creds),
		lc,
		("%s"):format(cname),
	}
	B.log = {
		name = lc,
		url = cname,
	}
	B()
end
ENV.DIR = function(dirname)
	Epilogue()
	local B = Buildah("DIR")
	B.cmd = {
		"commit",
		"--rm",
		"--squash",
		Name,
		("dir:%s"):format(dirname),
	}
	B.log = {
		name = Name,
		path = dirname,
	}
	B()
end
ENV.TAR = function(filename)
	local location = "/tmp/" .. Name
	local script = [[
TAR=$(find %s -maxdepth 1 -type f -exec file {} \+ | awk -F\: '/archive/{print $1}')
mv "${TAR}" "%s"
rm -rf "%s"
]]
	Epilogue()
	local B = Buildah("DIR -> TAR")
	B.cmd = {
		"commit",
		"--squash",
		Name,
		("dir:%s"):format(location),
	}
	B.log = {
		name = Name,
		path = location,
	}
	B()
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
	if not Name then
		Ok("PURGE", { skip = true, name = false })
		return
	end
	if a == "debian" or a == "dpkg" or a == "deb" then
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
Util.format_operator()
setfenv(0, ENV)
