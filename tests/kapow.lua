local included = pcall(debug.getlocal, 4, 1)
local kapow = require("kapow")
local http = require("http")
local crypto = require("crypto")
local T = require("test")
local URL = "http://127.0.0.1:60080"
--# = kapow
--# :toc:
--# :toc-placement!:
--#
--# For interfacing with the Kapow(github.com/BBVA/kapow) data point. +
--#
--# Not in the global namespace. Load with `require('kapow')`.
--#
--# toc::[]
--#
--# == *kapow.get*(_String_) -> _String_
--# Fetch a Kapow resource.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Example: `/request/path`
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |string |Data from resource
--# |===
local kapow_get = function()
	T.is_function(kapow.get)
	-- Exercised by Kapow app at 0.0.0.69:60080.
end
--#
--# == *kapow.set*(_String_, _String_) -> _Boolean_
--# Set a Kapow resource.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Example: `/response/body`
--# |string |Data for resource
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_set = function()
	T.is_function(kapow.set)
	local r = http.get(URL .. "/")
	T.equal(r.status_code, 418)
	T.equal(r.body, "kapow.set")
end
local kapow_set_binary = function()
	local b = http.get(URL .. "/binary")
	local bin = fs.read("/home/e/bin/kapow.v0.7.0")
	T.equal(#bin, b.body_size)
	local lc = crypto.sha512(bin)
	local rt = crypto.sha512(b.body)
	T.equal(lc, rt)
end
--#
--# == *kapow.ok*(_String_) -> _Boolean_
--# HTTP 200, all is good.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Body to accompany the HTTP 200
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_ok = function()
	T.is_function(kapow.ok)
	local r = http.get(URL .. "/ok")
	T.equal(r.status_code, 200)
	T.equal(r.body, "kapow.ok")
end
--#
--# == *kapow.fail*(_String_) -> _Boolean_
--# HTTP 500, the ship sank.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Body to accompany the HTTP 500
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_fail = function()
	T.is_function(kapow.fail)
	local r = http.get(URL .. "/fail")
	T.equal(r.status_code, 500)
	T.equal(r.body, "kapow.fail")
end
--#
--# == *kapow.warn*(_String_) -> _Boolean_
--# HTTP 202, something's wrong.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Body to accompany the HTTP 202
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_warn = function()
	T.is_function(kapow.warn)
	local r = http.get(URL .. "/warn")
	T.equal(r.status_code, 202)
	T.equal(r.body, "kapow.warn")
end
--#
--# == *kapow.forbid*(_String_) -> _Boolean_
--# HTTP 403, forbidden.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |Body to accompany the HTTP 403
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_forbid = function()
	T.is_function(kapow.forbid)
	local r = http.get(URL .. "/forbid")
	T.equal(r.status_code, 403)
	T.equal(r.body, "kapow.forbid")
end
--#
--# == *kapow.unprocessable*() -> _Boolean_
--# HTTP 422, detects hackers.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_unprocessable = function()
	T.is_function(kapow.unprocessable)
	local r = http.get(URL .. "/unprocessable")
	T.equal(r.status_code, 422)
	T.equal(r.body_size, 0)
end
--#
--# == *kapow.no_content*() -> _Boolean_
--# HTTP 204, from /dev/null.
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_no_content = function()
	T.is_function(kapow.no_content)
	local r = http.get(URL .. "/no_content")
	T.equal(r.status_code, 204)
	T.equal(r.body_size, 0)
end
--#
--# == *kapow.redirect*(_String_) -> _Boolean_
--# Perform redirect to argument #1.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string |URL
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |boolean | `true` if successful, nil and an error string otherwise
--# |===
local kapow_redirect = function()
	T.is_function(kapow.redirect)
	local r = http.get(URL .. "/redirect")
	T.equal(r.url, URL.."/")
	T.equal(r.status_code, 418)
end
if included then
	return function()
		T["kapow.get"] = kapow_get
		T["kapow.set"] = kapow_set
		T["kapow.set binary"] = kapow_set_binary
		T["kapow.ok"] = kapow_ok
		T["kapow.fail"] = kapow_fail
		T["kapow.warn"] = kapow_warn
		T["kapow.forbid"] = kapow_forbid
		T["kapow.unprocessable"] = kapow_unprocessable
		T["kapow.no_content"] = kapow_no_content
		T["kapow.redirect"] = kapow_redirect
	end
else
	T["kapow.get"] = kapow_get
	T["kapow.set"] = kapow_set
	T["kapow.set binary"] = kapow_set_binary
	T["kapow.ok"] = kapow_ok
	T["kapow.fail"] = kapow_fail
	T["kapow.warn"] = kapow_warn
	T["kapow.forbid"] = kapow_forbid
	T["kapow.unprocessable"] = kapow_unprocessable
	T["kapow.no_content"] = kapow_no_content
	T["kapow.redirect"] = kapow_redirect
end
