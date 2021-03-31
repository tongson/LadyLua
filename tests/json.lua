return function()
  local T = require 'test'
  T.is_table(json)
  T.is_function(json.encode)
  T.is_function(json.decode)
  T.equal(json.encode(true), 'true')
  T.equal(json.encode(1), '1')
  T.equal(json.encode(-10), '-10')
  T.equal(json.encode(nil), 'null')
  T.equal(json.encode({}), '[]')
  T.equal(json.encode({1, 2, 3}), '[1,2,3]')
  T.error(json.encode, 'sparse array', ({1, 2, [10] = 3}))
  T.error(json.encode, 'mixed or invalid key types', {1, 2, 3, name = 'Tim'})
  T.error(json.encode, 'mixed or invalid key types', {name='Tim', [false]=123})
  do
    local obj = {"a",1,"b",2,"c",3}
    local jsonStr = json.encode(obj)
    local jsonObj = json.decode(jsonStr)
    for i = 1, #obj do
      T.equal(obj[i], jsonObj[i])
    end
  end
  do
    local obj = {name="Tim",number=12345}
    local jsonStr = json.encode(obj)
    local jsonObj = json.decode(jsonStr)
    T.equal(obj.name, jsonObj.name)
    T.equal(obj.number, jsonObj.number)
  end
  T.is_nil(json.decode("null"))
  T.equal(json.decode(json.encode({person={name = "tim",}})).person.name, 'tim')
  do
    local obj = {
      abc = 123,
      def = nil,
    }
    local obj2 = {
      obj = obj,
    }
    obj.obj2 = obj2
    T.is_nil(json.encode(obj))
  end
  do
    local a = {}
    for i=1, 5 do
      a[i] = i
    end
    T.equal(json.encode(a), "[1,2,3,4,5]")
  end
end
