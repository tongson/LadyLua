--- Uses an embedded hsm in a state.

local ahsm = require("ahsm")

local helloworld_s = require("tests.ahsm.helloworld") -- load a fsm from a library

local off_s = ahsm.state({
	before = function() --[[print "TEST STATE off"]]
	end,
	op = function() --[[return true]]
	end, --single shot doo function, uncomment return for polling
})
local e_on = {}
local t21 = ahsm.transition({
	from = off_s,
	to = helloworld_s, --target is a composite state, will start it
	events = { e_on }, --event is an object
	guard = function(e)
		return true
	end, --guard function
	effect = function(e) --function called on transition
		--print ('TEST switching on', os.time())
	end,
})
local t22 = ahsm.transition({
	from = helloworld_s,
	to = off_s,
	events = { "e_off" },
	timeout = 7.0,
	effect = function(e) --function called on transition
		--print ('TEST switching off', os.time(), 'timeout:'..tostring(e==ahsm.EV_TIMEOUT))
	end,
})

local composite_s = ahsm.state({
	events = { e_on = e_on }, -- publish events
	states = { off = off_s, helloworld = helloworld_s }, --can provide names to states
	transitions = { ON = t21, OFF = t22 }, --can provide names to transitions
	initial = off_s,
})

return composite_s
