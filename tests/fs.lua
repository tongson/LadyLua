return function()
  local T = require 'test'
  T['fs'] = function()
    T.is_table(fs)
  end
  T['fs.read'] = function()
    T.is_function(fs.read)
    local s = fs.read'/etc/passwd'
    T.is_string(s)
    T.equal(string.find(s, 'root', 1, true), 1)
    local ne = fs.read'/sdfsfdsd'
    T.equal(#ne, 0)
  end
  T['fs.write'] = function()
    T.is_function(fs.write)
    local s = 'write this'
    T.is_true(fs.write('/tmp/fs.write', s))
    local w = fs.read('/tmp/fs.write')
    T.equal(string.find(s, 'this', 1, true), 7)
    os.remove('/tmp/fs.write')
  end
  T['fs.isdir'] = function()
    T.is_function(fs.isdir)
    T.is_true(fs.isdir('/etc'))
    T.is_false(fs.isdir('/dev/null'))
  end
  T['fs.isfile'] = function()
    T.is_function(fs.isfile)
    T.is_true(fs.isfile('/etc/passwd'))
    T.is_false(fs.isfile('/dev'))
  end
  T['fs.mkdir'] = function()
    T.is_function(fs.mkdir)
    T.is_true(fs.mkdir('/tmp/fs.mkdir'))
    T.is_true(fs.isdir('/tmp/fs.mkdir'))
    T.is_true(fs.rmdir('/tmp/fs.mkdir'))
  end
  T['fs.rmdir'] = function()
    T.is_function(fs.rmdir)
    T.is_true(fs.mkdir('/tmp/fs.rmdir'))
    T.is_true(fs.isdir('/tmp/fs.rmdir'))
    T.is_true(fs.rmdir('/tmp/fs.rmdir'))
    T.is_false(fs.isdir('/tmp/fs.rmdir'))
  end
  T['fs.chdir'] = function()
    T.is_function(fs.chdir)
    T.is_true(fs.mkdir('/tmp/fs.chdir'))
    T.is_true(fs.chdir('/tmp'))
    T.is_true(fs.isdir('fs.chdir'))
    T.is_true(fs.rmdir('fs.chdir'))
    T.is_false(fs.isdir('fs.chdir'))
  end
  T['fs.currentdir'] = function()
    T.is_function(fs.currentdir)
    T.is_true(fs.mkdir('/tmp/fs.currentdir'))
    T.is_true(fs.chdir('/tmp/fs.currentdir'))
    T.equal(fs.currentdir(), '/tmp/fs.currentdir')
    T.is_true(fs.chdir('/tmp'))
    T.is_true(fs.rmdir('fs.currentdir'))
    T.is_false(fs.isdir('/tmp/fs.currentdir'))
  end
  T['fs.attributes'] = function()
    T.is_function(fs.attributes)
    local a = fs.attributes('/etc/passwd')
    T.is_number(a.ino)
    T.equal('file', a.mode)
    T.is_nil(fs.attributes('/invalid'))
  end
  T['fs.symlinkattributes'] = function()
    T.is_function(fs.symlinkattributes)
    local a = fs.symlinkattributes('/dev/fd')
    T.is_number(a.ino)
    T.equal('link', a.mode)
    T.is_nil(fs.symlinkattributes('/invalid'))
  end
  T['fs.link'] = function()
    T.is_function(fs.link)
    -- Hardlinks shouldn't work in /tmp
    T.is_nil(fs.link('/etc/passwd', '/tmp/fs.link'))
    T.is_true(fs.link('/etc/passwd', '/tmp/fs.link', true))
    local a = fs.symlinkattributes('/tmp/fs.link')
    T.equal('link', a.mode)
    os.remove('/tmp/fs.link')
  end
  T['fs.dir'] = function()
    T.is_function(fs.dir)
    T.is_true(fs.mkdir('/tmp/fs.dir'))
    T.is_true(fs.mkdir('/tmp/fs.dir/1'))
    T.is_true(fs.mkdir('/tmp/fs.dir/two'))
    for d, _ in fs.dir('/tmp/fs.dir') do
      _ = string.find(d, '1', 1, true) or string.find(d, 'two', 1, true)
      T.is_number(_)
    end
    T.is_true(fs.rmdir('/tmp/fs.dir/two'))
    T.is_true(fs.rmdir('/tmp/fs.dir/1'))
    T.is_true(fs.rmdir('/tmp/fs.dir'))
  end
  T['fs.touch'] = function()
    T.is_function(fs.touch)
    T.is_true(fs.mkdir('/tmp/fs.touch'))
    T.is_true(fs.touch('/tmp/fs.touch'))
    T.is_true(fs.rmdir('/tmp/fs.touch'))
  end
end
