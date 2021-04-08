local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
--# = fs
--# :toc:
--# :toc-placement!:
--#
--# Filesystem operations implementing the `lfs` Lua module.
--#
--# Loaded in the global namespace. No need to `require()`.
--#
--# toc::[]
--#
--# == *fs.read*(_String_) -> _String_
--# Read specified file.
--#
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| File path
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string| Contents of file
--# |===
local fs_read = function()
  T.is_function(fs.read)
  local s = fs.read'/etc/passwd'
  T.is_string(s)
  T.equal(string.find(s, 'root', 1, true), 1)
  local ne, se = fs.read'/sdfsfdsd'
  T.is_nil(ne)
  T.is_string(se)
end
--#
--# == *fs.write*(_String_, _String_) -> _Boolean_
--# Write string(#2) to file(#1).
--#
--# Returns boolean `true` if successful.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| File path
--# |string| String to write
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if successful
--# |===
local fs_write = function()
  T.is_function(fs.write)
  local s = 'write this'
  T.is_true(fs.write('/tmp/fs.write', s))
  local w = fs.read('/tmp/fs.write')
  T.equal(string.find(w, 'this', 1, true), 7)
  os.remove('/tmp/fs.write')
end
--#
--# == *fs.isdir*(_String_) -> _Boolean_
--# Check if specified path is a directory.
--#
--# Returns boolean `true` if it is a directory.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Path
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if path is a directory
--# |===
local fs_isdir = function()
  T.is_function(fs.isdir)
  T.is_true(fs.isdir('/etc'))
  local re, se = fs.isdir('/dev/null')
  T.is_nil(re)
  T.is_string(se)
end
--#
--# == *fs.isfile*(_String_) -> _Boolean_
--# Check if specified path is a file.
--#
--# Returns boolean `true` if it is a file, `false` otherwise.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| File path
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if path is a file
--# |===
local fs_isfile = function()
  T.is_function(fs.isfile)
  T.is_true(fs.isfile('/etc/passwd'))
  local re, se = fs.isfile('/dev')
  T.is_nil(re)
  T.is_string(se)
end
--#
--# == *fs.mkdir*(_String_) -> _Boolean_
--# Create directory.
--#
--# Returns boolean `true` if successful.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| Directory path
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if successful
--# |===
local fs_mkdir = function()
  T.is_function(fs.mkdir)
  T.is_true(fs.mkdir('/tmp/fs.mkdir'))
  T.is_true(fs.isdir('/tmp/fs.mkdir'))
  T.is_true(fs.rmdir('/tmp/fs.mkdir'))
end
--#
--# == *fs.rmdir*(_String_) -> _Boolean_
--# Remove directory.
--#
--# Returns boolean `true` if successful.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| File path
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if successful
--# |===
local fs_rmdir = function()
  T.is_function(fs.rmdir)
  T.is_true(fs.mkdir('/tmp/fs.rmdir'))
  T.is_true(fs.isdir('/tmp/fs.rmdir'))
  T.is_true(fs.rmdir('/tmp/fs.rmdir'))
  T.is_nil(fs.isdir('/tmp/fs.rmdir'))
end
--#
--# == *fs.chdir*(_String_) -> _Boolean_
--# Change current working directory. This changes the CWD for the whole script.
--#
--# Returns boolean `true` if successful.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| File path
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean| `true` if successful
--# |===
local fs_chdir = function()
  T.is_function(fs.chdir)
  T.is_true(fs.mkdir('/tmp/fs.chdir'))
  T.is_true(fs.chdir('/tmp'))
  T.is_true(fs.isdir('fs.chdir'))
  T.is_true(fs.rmdir('fs.chdir'))
  T.is_nil(fs.isdir('fs.chdir'))
end
--#
--# == *fs.currentdir*() -> _String_
--# Show the current working directory.
--#
--# Returns the full path of the current directory.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Current directory path
--# |===
local fs_currentdir = function()
  T.is_function(fs.currentdir)
  T.is_true(fs.mkdir('/tmp/fs.currentdir'))
  T.is_true(fs.chdir('/tmp/fs.currentdir'))
  T.equal(fs.currentdir(), '/tmp/fs.currentdir')
  T.is_true(fs.chdir('/tmp'))
  T.is_true(fs.rmdir('fs.currentdir'))
  T.is_nil(fs.isdir('/tmp/fs.currentdir'))
end
--#
--# == *fs.attributes*(_String_) -> _Table_
--# Get the attributes of specified path.
--#
--# Returns a table(map) of the file system attributes.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table |Map of attributes
--# |===
--#
--# === Map(Unix)
--# [width="72%"]
--# |===
--# |dev |Device where the inode resides
--# |ino |Inode number
--# |mode |Mode(file, dir, link, socket, pipe, device)
--# |nlink |Number of hard links to the file
--# |uid |UID of owner
--# |gid |GID of owner
--# |rdev |Device type
--# |access |Time of last access
--# |modification |Time of last modification
--# |change |Time of last file status change
--# |size |File size in bytes
--# |permissions |File permissions string
--# |blocks |Block allocated for file
--# |blksize |Optimal FS blocksize
--# |===
local fs_attributes = function()
  T.is_function(fs.attributes)
  local a = fs.attributes('/etc/passwd')
  T.is_number(a.ino)
  T.equal('file', a.mode)
  T.is_nil(fs.attributes('/invalid'))
end
--#
--# == *fs.symlinkattributes*(_String_) -> _Table_
--# Get the attributes of a symlink, not the path it refers to.
--#
--# Returns a table(map) of the file system attributes.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |table |Map of attributes, see `fs.attributes` map
--# |===
local fs_symlinkattributes = function()
  T.is_function(fs.symlinkattributes)
  local a = fs.symlinkattributes('/dev/fd')
  T.is_number(a.ino)
  T.equal('link', a.mode)
  T.is_nil(fs.symlinkattributes('/invalid'))
end
--#
--# == *fs.link*(_String_, _String_, [,_Boolean_]) -> _Boolean_
--# Create a file system link.
--#
--# First argument is the target path. Second is the new link.
--# Creates a hard link by default. If the optional third argument is set to `true` then a symlink is created insteed.
--#
--# Returns `true` if successful.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful
--# |===
local fs_link = function()
  T.is_function(fs.link)
  -- Hardlinks shouldn't work in /tmp
  T.is_nil(fs.link('/etc/passwd', '/tmp/fs.link'))
  T.is_true(fs.link('/etc/passwd', '/tmp/fs.link', true))
  local a = fs.symlinkattributes('/tmp/fs.link')
  T.equal('link', a.mode)
  os.remove('/tmp/fs.link')
end
--#
--# == *fs.dir*(_String_) -> _Function_
--# Return an iterator that walks the specified path.
--#
--# Returns an `iterator` if no errors encountered.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |function| An iterator
--# |===
local fs_dir = function()
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
--#
--# == *fs.touch*(_String_[, _Number_][, _Number_]) -> _Boolean_
--# Sets access and modification times of an specified path. The first argument is the path to change, the second argument is the access time, and the third argument is the modification time. If the modification time is omitted, the access time provided is used. If both arguments are omitted, the current time is used.
--#
--# Returns `true` if successful.
--# Returns `nil` and an error message when an error is encountered.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |function| An iterator
--# |===
local fs_touch = function()
  T.is_function(fs.touch)
  T.is_true(fs.mkdir('/tmp/fs.touch'))
  T.is_true(fs.touch('/tmp/fs.touch'))
  T.is_true(fs.rmdir('/tmp/fs.touch'))
end
if included then
  return function()
    T['fs.read'] = fs_read
    T['fs.write'] = fs_write
    T['fs.isdir'] = fs_isdir
    T['fs.isfile'] = fs_isfile
    T['fs.mkdir'] = fs_mkdir
    T['fs.rmdir'] = fs_rmdir
    T['fs.chdir'] = fs_chdir
    T['fs.currentdir'] = fs_currentdir
    T['fs.attributes'] = fs_attributes
    T['fs.symlinkattributes'] = fs_symlinkattributes
    T['fs.link'] = fs_link
    T['fs.dir'] = fs_dir
    T['fs.touch'] = fs_touch
  end
else
  T['fs.read'] = fs_read
  T['fs.write'] = fs_write
  T['fs.isdir'] = fs_isdir
  T['fs.isfile'] = fs_isfile
  T['fs.mkdir'] = fs_mkdir
  T['fs.rmdir'] = fs_rmdir
  T['fs.chdir'] = fs_chdir
  T['fs.currentdir'] = fs_currentdir
  T['fs.attributes'] = fs_attributes
  T['fs.symlinkattributes'] = fs_symlinkattributes
  T['fs.link'] = fs_link
  T['fs.dir'] = fs_dir
  T['fs.touch'] = fs_touch
end
