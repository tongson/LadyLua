local panic = function(ret, msg, tbl)
  local stderr = require 'stderr'
  if not ret then
    stderr.error(msg, tbl)
    os.exit(1)
  end
end
local M = {}
local stdout = require 'stdout'
local podman = exec.ctx 'podman'
local start = function(name, unit, cpus, iid, dir)
  local systemctl = exec.ctx 'systemctl'
  systemctl{
    'disable';
    '--now';
    string.format('%s.service', name);
  }
  local fname = string.format('/etc/systemd/system/%s.service', name)
  local changed
  unit, changed = string.gsub(unit, '__ID__', iid)
  panic((changed == 1), 'unable to interpolate image ID', {
    what = 'string.gsub';
    changed = false;
    to = iid;
  })
  unit, changed = string.gsub(unit, '__DIR__', dir)
  panic((changed == 5), 'unable to interpolate directory path', {
    what = 'string.gsub';
    changed = false;
    to = dir;
  })
  unit, changed = string.gsub(unit, '__CPUS__', cpus)
  panic((changed == 1), 'unable to interpolate cpuset-cpus', {
    what = 'string.gsub';
    changed = false;
    to = cpus;
  })
  panic(fs.write(fname, unit), 'unable to write unit', {
    what = 'fs.write';
    file = fname;
  })
  local r, so, se = systemctl{
    'enable';
    '--now';
    string.format('%s.service', name);
  }
  panic(r, 'unable to start service', {
    what = 'systemctl';
    command = 'enable';
    service = name;
    stdout = so;
    stderr = se;
  })
end
local generate_password_file = function(path)
  local password = require 'password'
  local util = require 'util'
  local p = password.generate(16, 2, 0, true, false)
  if p == nil or string.len(p) == 0 then
    panic(nil, 'unable to generate password', {
      what = 'password.generate'
    })
  end
  local dir = util.path_split(path)
  util.path_apply(fs.mkdir, dir)
  panic(fs.isdir(dir), 'unable to create directory', {
    what = 'fs.mkdir';
    dir = dir;
  })
  panic(fs.write(path, p), 'unable to write password', {
    what = 'fs.write';
    path = path;
  })
end
local id = function(u, t)
  local json = require 'json'
  local r, so, se = podman{
    'images';
    '--format';
    'json';
  }
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
		for _, v in ipairs(j[i].Names) do
			if v == name then
        return j[i].Id
			end
		end
	end
  return nil, 'Container image not found.'
end
local pull = function(u, t)
  local r, so, se = podman{
    'pull';
    '--tls-verify';
    string.format('%s:%s', u, t);
  }
  panic(r, 'unable to pull image', {
    what = 'podman';
    command = 'pull';
    url = u;
    tag = t;
    stdout = so;
    stderr = se;
  })
end
setmetatable(M, {
  __call = function(_, e)
    local env = {
      NAME = 'Unit name.';
      URL  = 'Image URL.';
      TAG  = 'Image tag.';
      CPUS = 'Argument to podman --cpuset-cpus.';
      UNIT = 'systemd unit template.';
      DIR  = 'Bind directory path.';
      always_update = 'Boolean flag, if `true` always pull the image.';
      overwrite_password = 'Boolean flag, if `true` always overwrite password file.';
    }
    M.env = {}
    M.reg = {}
    for k in next, e do
      if not env[k] then
        panic(nil, 'Invalid key', {
            key = k;
        })
      else
        M.env[k] = e[k]
      end
    end
    -- pull
    M.reg.id = id(M.env.URL, M.env.TAG)
    if M.env.always_update or not M.reg.id then
      pull(M.env.URL, M.env.TAG)
      stdout.info('Pulled image', {
        url = M.env.URL;
        tag = M.env.TAG;
      })
      M.reg.id = id(M.env.URL, M.env.TAG)
      stdout.info('Got image ID', {
        id = M.reg.id;
      })
    end
    -- password
    local path = M.env.DIR..'/password'
    if M.env.overwrite_password or not fs.isfile(path) then
      generate_password_file(path)
      stdout.info('Wrote password file', {
        file = path;
      })
    end
    -- start
    start(M.env.NAME, M.env.UNIT, M.env.CPUS, M.reg.id, M.env.DIR)
    stdout.info('Started systemd unit', {
      name = M.env.NAME;
    })
  end;
})
return M
