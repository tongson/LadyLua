local F = string.format

local printf = function(str, ...)
  local stdout = io.stdout
  stdout:write(F(str, ...))
  return stdout:flush()
end

local fprintf = function(file, str, ...)
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

local panicf = function(str, ...)
  warnf(str, ...)
  os.exit(1)
end

local errorf = function(str, ...)
  return nil, F(str, ...)
end

local assertf = function(v, str, ...)
  if v then
    return true
  else
    panicf(str, ...)
  end
end
return {
  printf = printf,
  print = printf,
  fprintf = fprintf,
  fprint = fprintf,
  warnf = warnf,
  warn = warnf,
  errorf = errorf,
  error = errorf,
  panicf = panicf,
  panic = panicf,
  assertf = assertf,
  assert = assertf
}
