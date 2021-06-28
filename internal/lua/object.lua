--[[ Öbject - Base superclass that implements Ö𑫁𐊯

Key features of this library:

- Metamethods inheritance
- Store all metadata in metatables (no `__junk` in actual tables)
- Can subtly identify class membership
- Very tiny and fast, readable source

]]
local Object = {
  classname = 'Object',
  super = {}
}


--[[ Adds all metamethods from itself and all parents to the specified table
Maintains the order of the hierarchy: Rect > Point > Object.
> self (Object) apply from
> apply_here (table) apply to
]]
local function applyMetaFromParents(self, apply_here)
  local applied = {}
  self:each('meta', function(key, value)
    if not applied[key] then
      apply_here[key] = value
      applied[key] = true
    end
  end)
end


--[[ Adds __index metamethods from itself or closest parent to the table
> self (Object) apply from
> apply_here (table) apply to
]]
local function applyMetaIndexFromParents(self, apply_here)
  if self.__index == nil then apply_here.__index = self return end

  apply_here.__index = function(instance, key)
    local t = type(self.__index)
    local v
    if t == 'function' then v = self.__index(instance, key)
      elseif t == 'table' then v = self.__index[key]
      else error("'__index' must be a function or table", 2)
    end
    if v ~= nil then return v end
    return self[key]
  end
end


--[[ Creates an instance of the class
A simple call to the class as a function does the same.
> ... (any) [] arguments passed to init
< instance (Object)
]]
function Object:new(...)
  local obj_mt = {
    __index = self,
    __tostring = function() return 'instance of ' .. self.classname end
  }
  local obj = setmetatable({}, obj_mt)
  obj:init(...)
  applyMetaFromParents(self, obj_mt)
  applyMetaIndexFromParents(self, obj_mt)
  return setmetatable(obj, obj_mt)
end


--[[ Initializes the class
By default, an object takes a table with fields and applies them to itself,
but descendants are expected to replace this method with another.
> fields (table) [] new fields
]]
function Object:init(fields)
  local t = type(fields)
  if t ~= 'table' then
    error("'Object:init()' expected a table, but got " .. t, 3)
  end
  for key, value in pairs(fields) do self[key] = value end
end


--[[ Creates a new class by inheritance
> name (string) new class name
> ... (table|Object) [] additional properties
< cls (Object)
]]
function Object:extend(name, ...)
  if type(name) ~= 'string' then error('class must have a name', 2) end

  local cls, cls_mt = {}, {}
  for key, value in pairs(getmetatable(self)) do cls_mt[key] = value end
  for _, extra in ipairs{...} do
    for key, value in pairs(extra) do cls[key] = value end
  end

  cls.classname = name
  cls.super = self
  cls_mt.__index = self
  cls_mt.__tostring = function() return 'class ' .. name end
  setmetatable(cls, cls_mt)
  return cls
end


--[[ Sets someone else's methods
> ... (table|Object) methods
]]
function Object:implement(...)
  for _, cls in pairs({...}) do
    for key, value in pairs(cls) do
      if self[key] == nil and type(value) == 'function' then
        self[key] = value
      end
    end
  end
end


--[[ Returns the range of kinship between itself and the checking class
Returns `0` if it belongs to it or` false` if there is no kinship.
> Test (string|Object) test class
> limit (integer) [] check depth (default unlimited)
< kinship (integer|boolean)
]]
function Object:has(Test, limit)
  local t = type(Test)
  local searchedName
  if t == 'string' then
    searchedName = Test
  else
    searchedName = Test.classname
    if t ~= 'table' then return false end
  end

  local i = 0
  while self.super do
    if self.classname == searchedName then return i end
    if i == limit then return false end
    i = i + 1
    self = self.super
  end
  return false
end


--[[ Identifies affiliation to class
> Test (string|Object)
< result (boolean)
]]
function Object:is(Test)
  return self:has(Test, 0) == 0
end


--[[ Loops through all elements, performing an action on each
Can stop at fields, metafields, methods, or all.
Always skips basic fields and methods inherent from the Object class.
> etype ("field"|"method"|"meta"|"all") item type
> action (function:key,value,...) action on each element
> ... [] additional arguments for the action
< result (integer=table}) results of all actions
]]
function Object:each(etype, action, ...)
  local results, checks = {}, {}
  local function meta(key) return key:find('__') == 1 end
  local function func(value) return type(value) == 'function' end
  function checks.all() return true end
  function checks.meta(key) return meta(key) end
  function checks.method(key, value) return func(value) and not meta(key) end
  function checks.field(key, value) return not func(value) and not meta(key) end
  checks.methods = checks.method
  checks.fields = checks.field
  if not checks[etype] then error('wrong etype: ' .. tostring(etype)) end
  while self ~= Object do
    for key, value in pairs(self) do
      if not Object[key] and checks[etype](key, value) then
        table.insert(results, { action(key, value, ...) })
      end
    end
    self = self.super
  end
  return results
end


return setmetatable(Object, {
  __tostring = function(self) return 'class ' .. self.classname end,
  __call = Object.new
})
