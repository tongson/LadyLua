local env = {
  VERSION = '0.7.0';
     BIND = '0.0.0.69:60080';
  CONTROL = '0.0.0.69:60081';
     DATA = '0.0.0.69:60082';
     ROOT = '/srv/kapow';
      POW = 'src/index.pow';
}
local test = exec.cmd 'test'; test.errexit = true

test.error = 'Missing systemd-networkd.service.'
test '-f /usr/lib/systemd/system/systemd-networkd.service'

local systemctl = exec.cmd 'systemctl'
systemctl 'disable --now systemd-networkd.service'
systemctl 'enable --now systemd-networkd.service'
systemctl 'restart systemd-networkd.service'

test.error = 'Missing ll executable.'
test('-x /usr/bin/ll')

test.error = 'Missing kapow executable.'
test('-x %s/bin/kapow.v%s', env.ROOT, env.VERSION)

test.error = string.format('Missing %s/%s.', env.ROOT, env.POW)
local chmod = exec.cmd 'chmod'
chmod('+x %s/%s', env.ROOT, env.POW)

systemctl 'disable --now kapow.service'

local unit = [[
[Unit]
Description=kapow

[Install]
WantedBy=multi-user.target

[Service]
Restart=always
RestartSec=5
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
LockPersonality=yes
NoNewPrivileges=yes
RemoveIPC=yes
DevicePolicy=closed
PrivateTmp=yes
PrivateNetwork=false
PrivateDevices=true
ProtectKernelModules=yes
ProtectSystem=full
ProtectHome=yes
ProtectKernelTunables=yes
ProtectKernelLogs=yes
ProtectClock=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE
RestrictAddressFamilies=AF_INET
SystemCallFilter=~bpf process_vm_writev process_vm_readv perf_event_open kcmp lookup_dcookie move_pages swapon swapoff userfaultfd unshare
SystemCallFilter=~@cpu-emulation @debug @module @obsolete @keyring @clock @raw-io @clock @swap @reboot
ProtectControlGroups=yes
RestrictNamespaces=yes
DynamicUser=yes
StateDirectory=kapow
LogsDirectory=kapow
CacheDirectory=kapow
InaccessiblePaths=/usr /bin /proc /sys /sbin /opt /lib64 /lib /boot
TemporaryFileSystem=/srv:ro
BindReadOnlyPaths=__ROOT__
WorkingDirectory=__ROOT__
ExecStart=__ROOT__/bin/kapow.v__VERSION__ server --debug --control-reachable-addr '__CONTROL__' --bind __BIND__ --control-bind __CONTROL__ --data-bind __DATA__ __POW__
]]

fs.write('/etc/systemd/system/kapow.service', unit)

local sed = exec.cmd 'sed'
sed.errexit = true

sed('-i s|__VERSION__|%s| /etc/systemd/system/kapow.service', env.VERSION)
sed('-i s|__BIND__|%s| /etc/systemd/system/kapow.service', env.BIND)
sed('-i s|__CONTROL__|%s|g /etc/systemd/system/kapow.service', env.CONTROL)
sed('-i s|__DATA__|%s| /etc/systemd/system/kapow.service', env.DATA)
sed('-i s|__POW__|%s| /etc/systemd/system/kapow.service', env.POW)
sed('-i s|__ROOT__|%s|g /etc/systemd/system/kapow.service', env.ROOT)

systemctl.errexit = true
systemctl 'daemon-reload'
systemctl 'enable --now kapow.service'
