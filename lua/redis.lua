local redis = require 'redis'
package.loaded['redis'] = nil
local loader = function()
  redis.new = function (addr, password, db)
    addr = addr or '127.0.0.1:6379'
    password = password or ''
    db = db or 0
    local client = redis.client(addr, password, db)
    return {
      hset = function(key, fv)
        return redis.hset(client, key, fv)
      end,
      hget = function(key, field)
        return redis.hget(client, key, field)
      end,
      hdel = function(key, field)
        return redis.hdel(client, key, field)
      end,
      get = function(key)
        return redis.get(client, key)
      end,
      del = function(key)
        return redis.del(client, key)
      end,
      incr = function(key)
        return redis.incr(client, key)
      end,
      set = function(key, value, exp)
        exp = exp or 0
        return redis.set(client, key, value, exp)
      end,
      close = function()
        return redis.close(client)
      end,
    }
  end
  return redis
end
package.preload['redis'] = loader
