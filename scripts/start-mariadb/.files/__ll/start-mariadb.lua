package.path = '/__ll/modules/?.lua'
local podman = require 'podman'

local UNIT = [==[

]==]
local NAME = 'mariadb'
local URL  = 'docker://docker.io/library/mariadb'
local TAG  = '10.5'
local always_update = false

local id = podman.id(URL, TAG)
if not id or always_update then
  podman.pull(URL, TAG)
  id = podman.id(URL, TAG)
end
podman.start(NAME, UNIT, id)

