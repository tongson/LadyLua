package.path = '/__ll/modules/?.lua'

local env = {
  NAME = 'mariadb';
  URL  = 'docker://docker.io/library/mariadb';
  TAG  = '10.5';
  CPUS = '1';
  UNIT = require 'systemd.mariadb';
  FILE = '/srv/podman/mariadb/password';
  always_update = false;
}
local podman = require 'podman'
podman(env)
podman:pull_image()
podman:generate_password()
podman:start_unit()
