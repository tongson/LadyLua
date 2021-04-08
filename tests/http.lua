local included = pcall(debug.getlocal, 4, 1)
local T = require 'test'
local http = require 'http'
local json = require 'json'
--# = http
--# :toc:
--# :toc-placement!:
--#
--# Perform HTTP requests from Lua. From https://github.com/cjoudrey/gluahttp[gluahttp].
--#
--# toc::[]
--#
--# === Common Options Map
--# [options="header",width="88%"]
--# |===
--# |Name    |Type   | Description
--# |query   |String | URL encoded query params
--# |cookies |Table  | Additional cookies to send with the request
--# |headers |Table  | Additional headers to send with the request
--# |timeout |Number/String |Request timeout. Number of seconds or String such as "1h"
--# |auth    |Table  |Username and password for HTTP basic auth. Table keys are *user* for username, *pass* for passwod. `auth={user="user", pass="pass"}`
--# |===
--#
--# === Additional Options for HTTP POST, PUT, PATCH
--# [options="header",width="88%"]
--# |===
--# |Name |Type   | Description
--# |body |String |Request body
--# |===
--#
--# === Common Response Map
--# [options="header",width="88%"]
--# |===
--# |Name        | Type   | Description
--# |body        | String | The HTTP response body
--# |body_size   | Number | The size of the HTTP response body in bytes
--# |headers     | Table  | The HTTP response headers
--# |cookies     | Table  | The cookies sent by the server in the HTTP response
--# |status_code | Number | The HTTP response status code
--# |url         | String | The final URL the request ended pointing to after redirects
--# |===
--#
--# == *http.get*(_String_, _Table_) -> _Table_
--# HTTP GET.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |URL
--# |table  |Options, see map above
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Response, see map above
--# |===
local common = {
  timeout='30s',
  headers={ Accept='*/*'}
}
local http_request = function()
  local R = http.request('GET', 'https://cloudflare.com', common)
  T.is_userdata(R)
  T.is_string(R.body)
  T.is_number(R.body_size)
  T.is_table(R.headers)
  T.is_table(R.cookies)
  T.is_number(R.status_code)
  T.is_string(R.url)
  T.equal(R.status_code, 200)
end
local http_get = function()
  T.is_function(http.get)
  local R = http.get('https://cloudflare.com', common)
  T.is_userdata(R)
  T.is_string(R.body)
  T.is_number(R.body_size)
  T.is_table(R.headers)
  T.is_table(R.cookies)
  T.is_number(R.status_code)
  T.is_string(R.url)
  T.equal(R.status_code, 200)
end
--#
--# == *http.head*(_String_, _Table_) -> _Table_
--# HTTP HEAD.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |URL
--# |table  |Options, see map above
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Response, see map above
--# |===
local http_head = function()
  T.is_function(http.head)
end
--#
--# == *http.delete*(_String_, _Table_) -> _Table_
--# HTTP DELETE.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |URL
--# |table  |Options, see map above
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Response, see map above
--# |===
local http_delete = function()
  T.is_function(http.delete)
end
--#
--# == *http.patch*(_String_, _Table_) -> _Table_
--# HTTP PATCH.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |URL
--# |table  |Options, see map above
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Response, see map above
--# |===
local http_patch = function()
  T.is_function(http.patch)
end
--#
--# == *http.put*(_String_, _Table_) -> _Table_
--# HTTP PUT.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |URL
--# |table  |Options, see map above
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Response, see map above
--# |===
local http_put = function()
  T.is_function(http.put)
end
--#
--# == *http.post*(_String_, _Table_) -> _Table_
--# HTTP POST.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |URL
--# |table  |Options, see map above
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Response, see map above
--# |===
local http_post = function()
  T.is_function(http.post)
  local p = {
    timeout='30s',
    headers={Accept='*/*', ['Content-Type'] = 'application/x-www-form-urlencoded'},
    query='name=ed&age=34',
    body='name=john&age=12',
  }
  local r = http.post('https://postman-echo.com/post', p)
  T.is_userdata(r)
  T.is_string(r.body)
  T.is_number(r.body_size)
  T.is_table(r.headers)
  T.is_table(r.cookies)
  T.is_number(r.status_code)
  T.is_string(r.url)
  T.equal(r.status_code, 200)
  local body = json.decode(r.body)
  T.equal(body.args.name, 'ed')
  T.equal(body.args.age, '34')
  T.equal(body.form.name, 'john')
  T.equal(body.form.age, '12')
end
if included then
  return function()
    T['http.get'] = http_get
    T['http.request'] = http_request
    T['http.post'] = http_post
    T['http.head'] = http_head
    T['http.delete'] = http_delete
    T['http.patch'] = http_patch
    T['http.put'] = http_put
  end
else
  T['http.get'] = http_get
  T['http.request'] = http_request
  T['http.post'] = http_post
  T['http.head'] = http_head
  T['http.delete'] = http_delete
  T['http.patch'] = http_patch
  T['http.put'] = http_put
end
