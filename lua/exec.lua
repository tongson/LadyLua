exec.ctx = function(exe)
  local set = {}
  return setmetatable(set, {__call = function(_, ...)
    local args = {}
    local n = select("#", ...)
    if n == 1 then
      for k in string.gmatch(..., "%S+") do
        args[#args+1] = k
      end
    elseif n > 1 then
      for _, k in ipairs({...}) do
        args[#args+1] = k
      end
    end
    return exec.command(exe, args, set.env, set.cwd, set.stdin)
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
