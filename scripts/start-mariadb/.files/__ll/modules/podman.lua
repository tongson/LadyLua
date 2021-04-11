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
local template = function(i)
  local unit = [==[
]==]
end
return {
  pull = pull;
  id = id;
}
