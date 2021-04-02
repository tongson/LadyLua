return function()
  local T = require 'test'
  local C = require 'crypto'
  T['crypto.base64_encode'] = function()
    T.equal(C.base64_encode('AAA'), 'QUFB')
    T.equal(C.base64_decode('QUFB'), 'AAA')
  end
  T['crypto.hmac'] = function()
    local expected = '37e711dea769fa0bda063d4752ef54c3fc0f5940fda3d1683b5cd1873b421bdc'
    T.equal(C.hmac('sha256', 'AAA', 'KEY'), expected)
  end
end
