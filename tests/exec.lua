return function()
  local T = require 'test'
  T['exec.command SIMPLE'] = function()
    T.is_true(fs.mkdir('/tmp/exec.command'))
    T.is_true(exec.command('/bin/touch', {'/tmp/exec.command/file'}))
    T.is_true(fs.isfile('/tmp/exec.command/file'))
    T.is_true(exec.command('/usr/bin/rm', {'/tmp/exec.command/file'}))
    T.is_false(fs.isfile('/tmp/exec.command/file'))
    T.is_true(fs.rmdir('/tmp/exec.command'))
  end
end
