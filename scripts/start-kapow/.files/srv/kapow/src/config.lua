do
  local root = '/srv/kapow'
  local app  = '/src'
  local user = 'kapow'
  arg.version = 'v0.1-20210407'
  -- SOURCE
  package.path = string.format('%s/?.lua;%s/?/init.lua;', root..app, root..app)
  -- PATH
  arg.path       = {}
  arg.path.cache = '/var/cache/private/'..user
  arg.path.lib   = '/var/lib/private/'..user
  arg.path.log   = '/var/log/private/'..user
  -- SETTINGS
  arg.settings                    = {}
  arg.settings.secret             = 'SomethingSecretForTokens'
  arg.settings.test_token         = 'SomethingSecretForTests'
  arg.settings.test_header        = 'X-Test-Token'
end
