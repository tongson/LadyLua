return function()
  local T = require 'test'
  local D = '/tmp/exec.command'
  local F = '/tmp/exec.command/file'
  T['exec.command SIMPLE'] = function()
    T.is_true(fs.mkdir(D))
    T.is_true(exec.command('/bin/touch', {F}))
    T.is_true(fs.isfile(F))
    T.is_true(exec.command('/usr/bin/rm', {F}))
    T.is_nil(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
  T['exec.command CWD'] = function()
    T.is_true(fs.mkdir(D))
    local a = {'/tmp/exec.command/file'}
    local d = '/tmp/exec.command'
    T.is_true(exec.command('/bin/touch', {'file'}, nil, D))
    T.is_true(fs.isfile(F))
    T.is_true(exec.command('/usr/bin/rm', {F}))
    T.is_nil(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
  T['exec.command ENV'] = function()
    local r, o, e = exec.command('/usr/bin/env', nil, {'EXEC=ok'})
    T.is_true(r)
    local s = string.find(o, 'EXEC=ok', 1, true)
    T.is_number(s)
  end
  T['exec.command STDIN'] = function()
    local r, o, e = exec.command('/usr/bin/sed', {'s|ss|gg|'}, nil, nil, 'ss')
    T.is_true(r)
    local s = string.find(o, 'gg', 1, true)
    T.is_number(s)
  end
  T['exec.ctx SIMPLE'] = function()
    T.is_true(fs.mkdir(D))
    local touch = exec.ctx('/bin/touch')
    local t = touch(F)
    T.is_true(t)
    T.is_true(fs.isfile(F))
    local rm = exec.ctx('/usr/bin/rm')
    local r = rm(F)
    T.is_true(r)
    T.is_nil(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
  T['exec.ctx CWD'] = function()
    T.is_true(fs.mkdir(D))
    local a = {'/tmp/exec.command/file'}
    local d = '/tmp/exec.command'
    local touch = exec.ctx('/bin/touch')
    touch.cwd = D
    local t = touch'file'
    T.is_true(t)
    T.is_true(fs.isfile(F))
    local rm = exec.ctx('/usr/bin/rm')
    local r = rm(F)
    T.is_true(r)
    T.is_nil(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
  T['exec.ctx ENV'] = function()
    local env = exec.ctx'/usr/bin/env'
    env.env = {'EXEC=ok'}
    local r, o = env()
    T.is_true(r)
    local s = string.find(o, 'EXEC=ok', 1, true)
    T.is_number(s)
  end
  T['exec.ctx STDIN'] = function()
    local sed = exec.ctx('/usr/bin/sed')
    sed.stdin = 'ss'
    local r, o = sed('s|ss|gg|')
    T.is_true(r)
    local s = string.find(o, 'gg', 1, true)
    T.is_number(s)
  end
  T['exec.run SIMPLE'] = function()
    T.is_true(fs.mkdir(D))
    local t = exec.run.touch(F)
    T.is_true(t)
    T.is_true(fs.isfile(F))
    local r = exec.run.rm(F)
    T.is_true(r)
    T.is_nil(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
end
