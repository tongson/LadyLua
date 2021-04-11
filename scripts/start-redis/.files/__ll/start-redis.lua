local systemctl = exec.cmd 'systemctl'
systemctl 'stop redis@default.service'
systemctl.errexit = true
systemctl 'enable --now redis@default.service'
