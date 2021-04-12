local panic = function(ret, msg, tbl)
  local stderr = require 'stderr'
  if not ret then
    stderr.error(msg, tbl)
    os.exit(1)
  end
end
local json = require 'json'
local podman = exec.cmd 'podman'

local pull = function(u, t)
  local r, so, se = podman('pull --tls-verify %s:%s', u, t)
  panic(r, 'unable to pull image', {
    what = 'podman';
    command = 'pull';
    url = u;
    tag = t;
    stdout = so;
    stderr = se;
  })
end
local id = function(u, t)
  local r, so, se = podman('images --format json')
  panic(r, 'unable to list images', {
    what = 'podman';
    command = 'images';
    stdout = so;
    stderr = se;
  })
  local j = json.decode(so)
  u = string.gsub(u, 'docker://', '')
  local name = string.format('%s:%s', u, t)
  for i=1, #j do
    if table.find(j[i].Names, name) then
      return j[i].Id
    else
      return nil, 'Container image not found.'
    end
  end
end
local start = function(name, unit, iid)
  local systemctl = exec.cmd 'systemctl'
  systemctl('disable --now %s.service', name)
  local fname = string.format('/etc/systemd/system/%s.service', name)
  local funit, changed = string.gsub(unit, '__ID__', iid)
  panic((changed == 1), 'unable to interpolate', {
    what = 'string.gsub';
    changed = false;
    to = iid;
  })
  panic(fs.write(fname, funit), 'unable to write unit', {
    what = 'fs.write';
    file = fname;
  })
  local r, so, se = systemctl('enable --now %s.service', name)
  panic(r, 'unable to start service', {
    what = 'systemctl';
    command = 'enable';
    service = name;
    stdout = so;
    stderr = se;
  })
end

return {
  pull = pull;
  id = id;
  start = start;
}
