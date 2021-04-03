local F = string.format

fmt.printf = function(str, ...)
  local stdout = io.stdout
  stdout:write(F(str, ...))
  return stdout:flush()
end

fmt.fprint = function(file, str, ...)
  local o = io.output()
  io.output(file)
  local ret, err = io.write(F(str, ...))
  io.output(o)
  return ret, err
end

local warnf = function(str, ...)
  local stderr = io.stderr
  stderr:write(F(str, ...))
  stderr:flush()
end
fmt.warn = warnf

local panicf = function(str, ...)
  warnf(str, ...)
  os.exit(1)
end
fmt.panic = panicf

fmt.error = function(str, ...)
  return nil, F(str, ...)
end

fmt.assert = function(v, str, ...)
  if v then
    return true
  else
    panicf(str, ...)
  end
end
