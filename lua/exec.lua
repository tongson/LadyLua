exec.ctx = function(exe)
  local set = {}
  return setmetatable(set, {__call = function(_, ...)
    local args = {}
    if select("#", ...) > 0 then
      for _, k in ipairs({...}) do
        args[#args+1] = k
      end
    end
    return exec.command(exe, args, set.env, set.cwd, set.stdin)
  end})
end

exec.cmd = function(exe)
  local set = {}
  return setmetatable(set, {__call = function(_, a, ...)
    local args = {}
    if a then
      local ergs = string.format(a, ...)
      for k in string.gmatch(ergs, "%S+") do
        args[#args+1] = k
      end
    end
    local r, so, st = exec.command(exe, args, set.env, set.cwd, set.stdin)
    if set.errexit == true and r == nil then
      return fmt.panic('exec.cmd: `%s` execution failed. Exiting.\n', exe)
    else
      return true, so, st
    end
  end})
end

exec.run = setmetatable({},
  {__index =
    function (_, exe)
      return function(...)
        local args
        if not (...) then
          args = {}
        elseif type(...) == "table" then
          args = ...
        else
          args = {...}
        end
        return exec.command(exe, args)
      end
    end
  })
