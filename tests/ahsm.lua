local ahsm = require("ahsm")
ahsm.debug = require("tests.ahsm.debug_plain").out

local composite_s = require("tests.ahsm.composite")
composite_s.before = function()
	print("MACHINE STARTED")
end

local hsm = ahsm.init(composite_s) -- create hsm from root composite state

local function send(e)
	print("TEST sending event", e)
	hsm.send_event(e)
end
local function loop(e)
	print("===", hsm.loop())
end

--package.path = package.path .. ";;;tools/?.lua;tools/?/init.lua"
--local to_dot = require 'to_dot'

send(composite_s.events.e_on)
send("e_restart")

--to_dot.to_function(composite_s, print)

send("e_off")
send(composite_s.events.e_on)
while hsm.loop() do
end
