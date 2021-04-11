package.path = '/__ll/modules/?.lua'
local podman = require 'podman'
local url = 'docker://docker.io/library/mariadb'
local tag = '10.5'
local id = podman.id(url, tag)
if not id then
  podman.pull(url, tag)
  id = podman.id(url, tag)
end
