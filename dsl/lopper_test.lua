require("lopper")
T = require("test")

NOTIFY("start CMD test...")
sh = CMD("sh")
sh.cwd = "/tmp"
sh("-c", "touch CMD")
T["CMD"] = function()
	T.is_true(fs.isfile("/tmp/CMD"))
	os.remove("/tmp/CMD")
end
NOTIFY("end CMD test")

NOTIFY("start SH test...")
SH.CWD = "/tmp"
SH([[
set -efu
touch "/tmp/SH"
]])
T["SH"] = function()
	T.is_true(fs.isfile("/tmp/SH"))
	os.remove("/tmp/SH")
end
NOTIFY("end SH test")

NOTIFY("start SCRIPT test...")
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
NOTIFY("end SCRIPT test")

NOTIFY("start interpolation test...")
text = "%s" % "one"
T["interpolation #1"] = function()
	T.equal(text, "one")
end
NOTIFY("end interpolation test")

NOTIFY("start interpolation test...")
text = "%s:%s" %  { "one", "two" }
T["interpolation #2"] = function()
	T.equal(text, "one:two")
end
NOTIFY("end interpolation test")



T.summary()
