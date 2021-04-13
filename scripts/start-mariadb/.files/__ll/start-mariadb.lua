require('podman'){
  NAME = 'mariadb';
  URL  = 'docker://docker.io/library/mariadb';
  TAG  = '10.5';
  CPUS = '1';
  UNIT = require 'systemd.mariadb';
  DIR  = '/srv/podman/mariadb';
  always_update      = false;
  overwrite_password = false;
}
