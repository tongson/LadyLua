return function()
  local T = require 'test'
  local json = require 'json'
  T['json'] = function()
    T.is_table(json)
  end
  T['json.encode'] = function()
    T.is_function(json.encode)
  end
  T['json.decode'] = function()
    T.is_function(json.decode)
  end
  T['json.encode TRUE'] = function()
    T.equal(json.encode(true), 'true')
  end
  T['json.encode NUMBER'] = function()
    T.equal(json.encode(1), '1')
  end
  T['json.encode SIGNED NUMBER'] = function()
    T.equal(json.encode(-10), '-10')
  end
  T['json.encode NIL'] = function()
    T.equal(json.encode(nil), 'null')
  end
  T['json.encode EMPTY TABLE'] = function()
    T.equal(json.encode({}), '[]')
  end
  T['json.encode SEQUENCE'] = function()
    T.equal(json.encode({1, 2, 3}), '[1,2,3]')
  end
  T['json.encode SEQUENCE'] = function()
    local a = {}
    for i=1, 5 do
      a[i] = i
    end
    T.equal(json.encode(a), "[1,2,3,4,5]")
  end
  T['json.encode SPARSE TABLE'] = function()
    T.error(json.encode, 'sparse array', ({1, 2, [10] = 3}))
  end
  T['json.encode MIXED TABLE #1'] = function()
    T.error(json.encode, 'mixed or invalid key types', {1, 2, 3, name = 'Tim'})
  end
  T['json.encode MIXED TABLE #2'] = function()
    T.error(json.encode, 'mixed or invalid key types', {name='Tim', [false]=123})
  end
  T['json.decode ARRAY'] = function()
    local obj = {"a",1,"b",2,"c",3}
    local jsonStr = json.encode(obj)
    local jsonObj = json.decode(jsonStr)
    for i = 1, #obj do
      T.equal(obj[i], jsonObj[i])
    end
  end
  T['json.decode OBJECT'] = function()
    local obj = {name="Tim",number=12345}
    local jsonStr = json.encode(obj)
    local jsonObj = json.decode(jsonStr)
    T.equal(obj.name, jsonObj.name)
    T.equal(obj.number, jsonObj.number)
  end
  T['json.decode NULL'] = function()
    T.is_nil(json.decode("null"))
  end
  T['json.decode NESTED OBJECT'] = function()
    T.equal(json.decode(json.encode({person={name = "tim",}})).person.name, 'tim')
  end
  T['json.encode INVALID TABLE'] = function()
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
end
