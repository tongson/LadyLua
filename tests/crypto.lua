local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local C = require("crypto")
--# = crypto
--# :toc:
--# :toc-placement!:
--#
--# Cryptography operations and base64 encoding/decoding. +
--#
--# Not in the global namespace. Load with `require('crypto')`.
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
	T.equal(C.base64_encode("AAA"), "QUFB")
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
	T.equal(C.base64_decode("QUFB"), "AAA")
end
--#
--# == *crypto.crc32*(_String_[, _Boolean_]) -> _String_
--# Perform CRC32 on data.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |String to check
--# |boolean|If `true`, returns raw bytes instead of the default hex encoding string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Checksum
--# |===
local crypto_crc32 = function()
	T.is_function(C.crc32)
	T.equal(C.crc32("QUFB"), "067393bf")
end
--#
--# == *crypto.sha256*(_String_[, _Boolean_]) -> _String_
--# Compute the SHA256 hash code from data.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Data
--# |boolean|If `true`, returns raw bytes instead of the default hex encoding string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Hash code
--# |===
local crypto_sha256 = function()
	T.is_function(C.sha256)
	local expected = "71f3e86c42376ed1c9583f0117fad889f5139926594992b3f573e17939cb038f"
	T.equal(C.sha256("ZZZ"), expected)
end
--#
--# == *crypto.sha512*(_String_[, _Boolean_]) -> _String_
--# Compute the SHA512 hash code from data.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Data
--# |boolean|If `true`, returns raw bytes instead of the default hex encoding string
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Hash code
--# |===
local crypto_sha512 = function()
	T.is_function(C.sha512)
	local e =
		"534a31a32f5a4baa41d893121d09e4caf537d749c1ef199322c1daea54da1147ac90ad12aa236358a78a78c9b1a0d6989ba892d131416a4155957e11e0ea9caa"
	T.equal(C.sha512("ZZZ"), e)
end
--#
--# == *crypto.hmac*(_String_, _String_, _String_[, _Boolean_]) -> _String_
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
	local expected = "37e711dea769fa0bda063d4752ef54c3fc0f5940fda3d1683b5cd1873b421bdc"
	T.equal(C.hmac("sha256", "AAA", "KEY"), expected)
end
--#
--# == *crypto.valid_hmac*(_String_, _String_, _String_, _String_) -> _Boolean_
--# Compare MACs in a way that avoids side-channel attacks.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Hash function, example: `sha256`
--# |string |Message
--# |string |Secret key
--# |string |Raw output from crypto.hmac()
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean |`true` if valid
--# |===
local crypto_valid_hmac = function()
  local mac = C.hmac("sha256", "AAA", "KEY", true)
	local bool = C.valid_hmac("sha256", "AAA", "KEY", mac)
	T.is_true(bool)
	mac = C.hmac("sha256", "AA", "KEY", true)
	bool = C.valid_hmac("sha256", "AAA", "KEY", mac)
	T.is_false(bool)
end
if included then
	return function()
		T["crypto.base64_encode"] = crypto_base64_encode
		T["crypto.base64_decode"] = crypto_base64_decode
		T["crypto.crc32"] = crypto_crc32
		T["crypto.sha256"] = crypto_sha256
		T["crypto.sha512"] = crypto_sha512
		T["crypto.hmac"] = crypto_hmac
		T["crypto.valid_hmac"] = crypto_valid_hmac
	end
else
	T["crypto.base64_encode"] = crypto_base64_encode
	T["crypto.base64_decode"] = crypto_base64_decode
	T["crypto.crc32"] = crypto_crc32
	T["crypto.sha256"] = crypto_sha256
	T["crypto.sha512"] = crypto_sha512
	T["crypto.hmac"] = crypto_hmac
  T["crypto.valid_hmac"] = crypto_valid_hmac
end
