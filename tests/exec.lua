return function()
  local T = require 'test'
  local D = '/tmp/exec.command'
  local F = '/tmp/exec.command/file'
  T['exec.command SIMPLE'] = function()
    T.is_true(fs.mkdir(D))
    T.is_true(exec.command('/bin/touch', {F}))
    T.is_true(fs.isfile(F))
    T.is_true(exec.command('/usr/bin/rm', {F}))
    T.is_false(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
  T['exec.command CWD'] = function()
    T.is_true(fs.mkdir(D))
    local a = {'/tmp/exec.command/file'}
    local d = '/tmp/exec.command'
    T.is_true(exec.command('/bin/touch', {'file'}, nil, D))
    T.is_true(fs.isfile(F))
    T.is_true(exec.command('/usr/bin/rm', {F}))
    T.is_false(fs.isfile(F))
    T.is_true(fs.rmdir(D))
  end
end
