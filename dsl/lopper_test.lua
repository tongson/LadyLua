require("lopper")
T = require("test")

sh = CMD("sh")
sh.cwd = "/tmp"
sh("-c", "touch CMD")
T["CMD"] = function()
	T.is_true(fs.isfile("/tmp/CMD"))
	os.remove("/tmp/CMD")
end

SH.CWD = "/tmp"
SH([[
set -efu
touch "/tmp/SH"
]])
T["SH"] = function()
	T.is_true(fs.isfile("/tmp/SH"))
	os.remove("/tmp/SH")
end

script = [[
set -efu
touch "/tmp/${VAR:-SCRIPT_OK}"
]]
fs.write("/tmp/script.sh", script)
SCRIPT.ENV = { "VAR=SCRIPT" }
SCRIPT("/tmp/script.sh")
T["SCRIPT #1"] = function()
	T.is_true(fs.isfile("/tmp/SCRIPT"))
	os.remove("/tmp/SCRIPT")
end
SCRIPT("/tmp/script.sh")
T["SCRIPT #2"] = function()
	T.is_true(fs.isfile("/tmp/SCRIPT_OK"))
	os.remove("/tmp/SCRIPT_OK")
end
script = [[
set -efu
echo "${NIL}"
]]
fs.write("/tmp/script.sh", script)
SCRIPT.IGNORE = true
SCRIPT("/tmp/script.sh")
T["SCRIPT #3"] = function()
	T.is_string("SHOULD EXECUTE THIS TEST")
end
