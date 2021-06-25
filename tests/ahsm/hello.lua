--- Two state flip-flop.

local ahsm = require("ahsm")
local debug_plain = require 'debug_plain'
ahsm.debug = debug_plain.out



local hello_s = ahsm.state({
	after = function()
		print("HW STATE hello")
	end,
}) --state with exit func
local world_s = ahsm.state({
	before = function()
		print("HW STATE world")
	end,
}) --state with entry func
local t11 = ahsm.transition({
	from = hello_s,
	to = world_s,
	events = { hello_s.EV_DONE },
}) --transition on state completion
local t12 = ahsm.transition({
	from = world_s,
	to = hello_s,
	events = { "e_restart" },
	timeout = 2.0,
}) --transition with timeout, event is a string

local a = 0
local helloworld_s = ahsm.state({
	states = { hello = hello_s, world = world_s }, --composite state
	transitions = { to_world = t11, to_hello = t12 },
	initial = hello_s, --initial state for machine
	op = coroutine.wrap(function() -- a long running doo with yields
		while true do
			a = a + 1
			coroutine.yield(true)
		end
	end),
	before = function()
		print("HW doo running")
	end,
	after = function()
		print("HW doo iteration count", a)
	end, -- will show efect of doo on exit
})

--local helloworld_s = require 'helloworld'
local fsm = ahsm.init(helloworld_s)
fsm.send_event("e_restart")
while fsm.loop() do
end
