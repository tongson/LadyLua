local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local lz4 = require("lz4")
--# = lz4
--# :toc:
--# :toc-placement!:
--#
--# LZ4 compression and decompression.
--#
--# toc::[]
--#
--# == *lz4.compress*(_String_) -> _String_
--# Compress data.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Data
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Compressed binary data
--# |===
local lz4_compress = function()
	T.is_function(lz4.compress)
	local lz4c = exec.ctx("lz4")
	local data = "AAA111ZZZ"
	local compressed = lz4.compress(data)
	lz4c.stdin = compressed
	local r, so = lz4c({ "-d", "-c" })
	T.is_true(r)
	T.equal(so, data)
end
--#	
--# == *lz4.decompress*(_String_) -> _String_
--# Decompress lz4 data.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Compressed
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Decompressed data
--# |===
local lz4_decompress = function()
	local crypto = require("crypto")
	T.is_function(lz4.decompress)
	local ls = fs.read("/bin/ls")
	local sum = crypto.sha256(ls)
	local compressed = lz4.compress(ls)
	local data = lz4.decompress(compressed)
	T.equal(sum, crypto.sha256(data))
end
if included then
	return function()
		T["lz4.compress"] = lz4_compress
		T["lz4.decompress"] = lz4_decompress
	end
else
	T["lz4.compress"] = lz4_compress
	T["lz4.decompress"] = lz4_decompress
end
