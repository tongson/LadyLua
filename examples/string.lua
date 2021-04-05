local I = require 'inspect'

local s = 'one'
local x = s:append'two'
fmt.print('%s\n', I(x))

local z = 'one\ttwo'
local zt = z:to_list()
fmt.print('%s\n', I(zt))

local n = '1# 2! 3.'
local nt = n:word_to_list()
fmt.print('%s\n', I(nt))

local l =[[five
six
seven]]
local lt = l:line_to_list()
fmt.print('%s\n', I(lt))
