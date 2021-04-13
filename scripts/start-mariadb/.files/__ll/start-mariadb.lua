package.path = '/__ll/modules/?.lua'
local podman = require 'podman'
local env = {
  NAME = 'mariadb';
  URL  = 'docker://docker.io/library/mariadb';
  TAG  = '10.5';
  CPUS = '1';
  UNIT = require 'systemd.mariadb';
  DIR  = '/srv/podman/mariadb';
  always_update = false;
}
podman(env)
podman:pull_image()
podman:generate_password()
podman:start_unit()
