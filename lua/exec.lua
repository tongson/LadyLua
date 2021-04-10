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
    local args
    if a and type(a) == 'string' then
      local ergs = string.format(a, ...)
      args = {}
      for k in string.gmatch(ergs, "%S+") do
        args[#args+1] = k
      end
    end
    if a and type(a) == 'table' then
      args = a
    end
    local r, so, se = exec.command(exe, args, set.env, set.cwd, set.stdin)
    local pretty_prefix = function(header, prefix, str)
      if string.len(str) > 0 then
        local replacement = string.format('\n %s > ', prefix)
        str = string.gsub(str, "\n", replacement)
        return string.format("%s\n %s >\n %s > %s\n", header, prefix, prefix, str)
      else
        return ""
      end
    end
    if set.errexit == true and r == nil then
      local err = set.error or 'execution failed'
      local header = string.format('exec.cmd: `%s` => "%s"', exe, err)
      fmt.print('%s', pretty_prefix(header, 'stdout', so))
      return fmt.panic('%s', pretty_prefix(header, 'stderr', se))
    else
      return true, so, se
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
