local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local Object = require("object")
local Point = Object:extend("Point")
Point.scale = 2 -- Class field!

function Point:init(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Point:resize()
	self.x = self.x * self.scale
	self.y = self.y * self.scale
end

function Point.__call()
	return "called"
end

local Rectangle = Point:extend("Rectangle")

function Rectangle:resize()
	Rectangle.super.resize(self) -- Extend Point's `resize()`.
	self.w = self.w * self.scale
	self.h = self.h * self.scale
end

function Rectangle:init(x, y, w, h)
	Rectangle.super.init(self, x, y) -- Initialize Point first!
	self.w = w or 0
	self.h = h or 0
end

function Rectangle:__index(key)
	if key == "width" then
		return self.w
	end
	if key == "height" then
		return self.h
	end
end

function Rectangle:__newindex(key, value)
	if key == "width" then
		self.w = value
	elseif key == "height" then
		self.h = value
	end
end

local rect = Rectangle:new(2, 4, 6, 8)
local extend = function()
	T.expect(6)(rect.w)
end
local is = function()
	T.expect(true)(rect:is(Rectangle))
	T.expect(true)(rect:is("Rectangle"))
end
local is_not = function()
	T.expect(false)(rect:is(Point))
end
local has = function()
	T.expect(1)(rect:has("Point"))
end
local has_object = function()
	T.expect(2)(Rectangle:has(Object))
end
local called = function()
	T.expect("called")(rect())
end
local extend2 = function()
	T.expect(666)(rect.w)
	T.expect(8)(rect.height)
end

if included then
	return function()
		T["extend"] = extend
		T["is"] = is
		T["is not"] = is_not
		T["has"] = has
		T["has object"] = has_object
		T["called"] = called
		rect.width = 666
		T["extend2"] = extend2
	end
else
	T["extend"] = extend
	T["is"] = is
	T["is not"] = is_not
	T["has"] = has
	T["has object"] = has_object
	T["called"] = called
	rect.width = 666
	T["extend2"] = extend2
end
