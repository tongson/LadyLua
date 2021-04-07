do
  local root = '/var/lib/kapow'
  local app  = '/src'
  local user = 'kapow'
  arg.version = 'v0.1-20210407'
  -- SOURCE
  package.path = string.format('%s/?.lua;%s/?/init.lua;', root..app, root..app)
  -- PATH
  arg.path       = {}
  arg.path.cache = '/var/cache/'..user
  arg.path.lib   = '/var/lib/'..user
  arg.path.log   = '/var/log/'..user
  -- SETTINGS
  arg.settings                    = {}
  arg.settings.secret             = 'SomethingSecretForTokens'
  arg.settings.test_token         = 'SomethingSecretForTests'
  arg.settings.test_header        = 'X-Test-Token'
end
