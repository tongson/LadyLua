local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local ssh_config = require("ssh_config")
--# = ssh_config
--# :toc:
--# :toc-placement!:
--#
--# Get values from ~/.ssh/config
--#
--# toc::[]
--#
--# == *ssh_config.port*(_String_) -> _String_
--# Get configured Port for Host.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Host
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Port
--# |===
local ssh_config_port = function()
	T.is_function(ssh_config.port)
end
--#
--# == *ssh_config.hostname*(_String_) -> _String_
--# Get configured Hostname for Host.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Host
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Hostname
--# |===
local ssh_config_hostname = function()
	T.is_function(ssh_config.hostname)
end
--#
--# == *ssh_config.identity_file*(_String_) -> _String_
--# Get configured IdentityFile for Host.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Host
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Path of key
--# |===
local ssh_config_identityfile = function()
	T.is_function(ssh_config.identity_file)
end
--#
--# == *ssh_config.hosts*() -> _Table_
--# Get all hosts configured in ~/.ssh/config
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |table|List of hosts
--# |===
local ssh_config_hosts = function()
	T.is_function(ssh_config.hosts)
	T.is_table(ssh_config.hosts())
end
if included then
	return function()
		T["ssh_config.port"] = ssh_config_port
		T["ssh_config.hostname"] = ssh_config_hostname
		T["ssh_config.identityfile"] = ssh_config_identityfile
		T["ssh_config.hosts"] = ssh_config_hosts
	end
else
	T["ssh_config.port"] = ssh_config_port
	T["ssh_config.hostname"] = ssh_config_hostname
	T["ssh_config.identityfile"] = ssh_config_identityfile
	T["ssh_config.hosts"] = ssh_config_hosts
end
