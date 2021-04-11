local podman = exec.cmd 'podman'
local json = require 'json'
podman.errexit = true
local pull = function(u, t)
  podman('pull --tls-verify %s:%s', u, t)
end
local id = function(u, t)
  u = string.gsub(u, 'docker://', '')
  local _, so = podman('images --format json')
  local j = json.decode(so)
  local name = string.format('%s:%s', u, t)
  for i=1, #j do
    local n = table.to_map(j[i].Names)
    if n[name] then
      return j[i].Id
    else
      return nil, 'Container image not found.'
    end
  end
end
local start = function(name, unit, id)
  local systemctl = exec.cmd 'systemctl'
  systemctl('disable --now %s.service', name)
  local fname = string.format('/etc/systemd/system/%s.service', name)
  local funit, changed = string.gsub(unit, '__ID__', id)
  if changed == 0 then
    return nil, 'No ID interpolated.'
  end
  if not fs.write(fname, funit) then
    return nil, 'Unable to write unit.'
  end
  systemctl.errexit = true
  systemctl('enable --now %s.service', name)
end

end
return {
  pull = pull;
  id = id;
  start = start;
}
