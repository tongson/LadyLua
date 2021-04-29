local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local mysql = require("mysql")
--# = mysql
--# :toc:
--# :toc-placement!:
--#
--# Access MySQL or MariaDB databases.
--#
--# toc::[]
--#
--# == *mysql.escape*(_String_) -> _String_
--# Escape a query.
--#
--# == *mysql.new*
--# Initialize mysql instance.
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |object |Instance of mysql that you can index into
--# |===
--#
--# == *close*
--# Close mysql instance.
--#
--# == *set_timeout*(_Number_)
--# Set timeout.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Timeout in ms
--# |===
--#
--# == *set_keepalive*(_Number_, _Number_)
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |number |Timeout in ms
--# |number |Max idle connections(poolSize)
--# |===
--#
--# == *connect*(_Table_)
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |See map below
--# |===
--#
--# === Map
--# [options="header",width="72%"]
--# |===
--# |host |
--# |port |
--# |database |
--# |user |
--# |password |
--# |===
--#
--# == *query*(_String_[, ...]) -> _Table_
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |SQL query
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table |Query results, empty table if no results
--# |===
local mysql_new = function()
	T.is_function(mysql.new)
	local c = mysql.new()
	T.is_userdata(c)
	c:close()
end
local mysql_close = function()
	local c = mysql.new()
	T.is_function(c.close)
	c:close()
end
local mysql_connect = function()
	local c = mysql.new()
	T.is_function(c.connect)
	local password = os.getenv("MYSQL_PASSWORD")
	local ok, err = c:connect({
		host = "",
		port = "",
		database = "",
		user = "",
		password = password,
	})
	T.is_true(ok)
	T.is_nil(err)
	c:close()
end
local mysql_query = function()
	local c = mysql.new()
	T.is_function(c.connect)
	local password = os.getenv("MYSQL_PASSWORD")
	local ok, err = c:connect({
		host = "0.255.128.1",
		port = "3306",
		database = "mysql",
		user = "root",
		password = password,
	})
	T.is_true(ok)
	T.is_nil(err)
	local qok, qerr = c:query("SELECT * FROM user LIMIT 1")
	T.is_nil(qerr)
	T.is_table(qok)
	T.is_table(qok[1])
	T.equal(qok[1].password_expired, "N")
	local cok, cerr = c:query([[SELECT * FROM user where max_user_connections=?]], 0)
	T.is_nil(cerr)
	T.is_table(cok)
	T.equal(next(cok), 1)
	local nok, nerr = c:query([[SELECT * FROM user where max_user_connections=?]], 1)
	T.is_nil(nerr)
	T.is_table(nok)
	T.is_nil(next(nok))
	c:close()
end
if included then
	return function()
		T["mysql.new"] = mysql_new
		T["close"] = mysql_close
		T["connect"] = mysql_connect
		T["query"] = mysql_query
	end
else
	T["mysql.new"] = mysql_new
	T["close"] = mysql_close
	T["connect"] = mysql_connect
	T["query"] = mysql_query
end
