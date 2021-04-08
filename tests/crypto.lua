local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
local C = require 'crypto'
--# = crypto
--# :toc:
--# :toc-placement!:
--#
--# Cryptography operations and base64 encoding/decoding.
--#
--# toc::[]
--#
--# == *crypto.base64_encode*(_String_) -> _String_
--# Encode data to base64.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Data to encode
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Encoded base64 string
--# |===
local crypto_base64_encode = function()
  T.is_function(C.base64_encode)
  T.equal(C.base64_encode('AAA'), 'QUFB')
end
--#
--# == *crypto.base64_decode*(_String_) -> _String_
--# Decode base64 string.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |String to decode
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Decoded data
--# |===
local crypto_base64_decode = function()
  T.is_function(C.base64_decode)
  T.equal(C.base64_decode('QUFB'), 'AAA')
end
--#
--# == *crypto.hmac*(_String_, _String_, _String_, _Boolean_) -> _String_
--# Data integrity and authenticity code computation.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Hash function, example: `sha256`
--# |string |Message
--# |string |Secret key
--# |boolean|If `true`, returns raw bytes instead of the default hex encoding string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Code
--# |===
local crypto_hmac = function()
  local expected = '37e711dea769fa0bda063d4752ef54c3fc0f5940fda3d1683b5cd1873b421bdc'
  T.equal(C.hmac('sha256', 'AAA', 'KEY'), expected)
end
if included then
  return function()
    T['crypto.base64_encode'] = crypto_base64_encode
    T['crypto.base64_decode'] = crypto_base64_decode
    T['crypto.hmac'] = crypto_hmac
  end
else
  T['crypto.base64_encode'] = crypto_base64_encode
  T['crypto.base64_decode'] = crypto_base64_decode
  T['crypto.hmac'] = crypto_hmac
end
