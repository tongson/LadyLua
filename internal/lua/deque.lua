--- Deque implementation by Pierre 'catwell' Chapuis
--- MIT licensed (see LICENSE.txt)

local push_back = function(self, x)
  assert(x ~= nil, "deque.push_back: Value cannot be nil.")
  self.tail = self.tail + 1
  self[self.tail] = x
end

local push_front = function(self, x)
  assert(x ~= nil, "deque.push_front: Value cannot be nil.")
  self[self.head] = x
  self.head = self.head - 1
end

local peek_back = function(self)
  return self[self.tail]
end

local peek_front = function(self)
  return self[self.head+1]
end

local pop_back = function(self)
  if self:is_empty() then return nil end
  local r = self[self.tail]
  self[self.tail] = nil
  self.tail = self.tail - 1
  return r
end

local pop_front = function(self)
  if self:is_empty() then return nil end
  local r = self[self.head+1]
  self.head = self.head + 1
  r = self[self.head]
  self[self.head] = nil
  return r
end

local rotate_back = function(self, n)
  n = n or 1
  if self:is_empty() then return nil end
  for _=1,n do
    self:push_front(self:pop_back())
  end
end

local rotate_front = function(self, n)
  n = n or 1
  if self:is_empty() then return nil end
  for _=1,n do
    self:push_back(self:pop_front())
  end
end

local _remove_at_internal = function(self, idx)
  for i=idx, self.tail do
    self[i] = self[i+1]
  end
  self.tail = self.tail - 1
end

local remove_back = function(self, x)
  for i=self.tail,self.head+1,-1 do
    if self[i] == x then
      _remove_at_internal(self, i)
      return true
    end
  end
  return false
end

local remove_front = function(self, x)
  for i=self.head+1,self.tail do
    if self[i] == x then
      _remove_at_internal(self, i)
      return true
    end
  end
  return false
end

local size = function(self)
  return self.tail - self.head
end

local is_empty = function(self)
  return self:size() == 0
end

local contents = function(self)
  local r = {}
  for i=self.head+1,self.tail do
    r[i-self.head] = self[i]
  end
  return r
end

local iter_back = function(self)
  local i = self.tail+1
  return function()
    if i > self.head+1 then
      i = i-1
      return self[i]
    end
  end
end

local iter_front = function(self)
  local i = self.head
  return function()
    if i < self.tail then
      i = i+1
      return self[i]
    end
  end
end

local methods = {
  push_back = push_back,
  push_front = push_front,
  peek_back = peek_back,
  peek_front = peek_front,
  pop_back = pop_back,
  pop_front = pop_front,
  rotate_back = rotate_back,
  rotate_front = rotate_front,
  remove_back = remove_back,
  remove_front = remove_front,
  iter_back = iter_back,
  iter_front = iter_front,
  size = size,
  is_empty = is_empty,
  contents = contents,
}

local new = function()
  local r = {head = 0, tail = 0}
  return setmetatable(r, {__index = methods})
end

return {
  new = new,
}
