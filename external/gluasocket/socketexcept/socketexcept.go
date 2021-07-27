package gluasocket_socketexcept

import (
	"github.com/yuin/gopher-lua"
)

// ----------------------------------------------------------------------------

func Loader(l *lua.LState) int {
	if err := l.DoString(exceptDotLua); err != nil {
		l.RaiseError("Error loading except.lua: %v", err)
		return 0
	}
	return 1
}

const exceptDotLua = `-----------------------------------------------------------------------------
-- Exception control
-- LuaSocket toolkit (but completely independent from other modules)
-- Author: Diego Nehab

-- This provides support for simple exceptions in Lua. During the
-- development of the HTTP/FTP/SMTP support, it became aparent that
-- error checking was taking a substantial amount of the coding. These
-- function greatly simplify the task of checking errors.

-- The main idea is that functions should return nil as its first return
-- value when it finds an error, and return an error message (or value)
-- following nil. In case of success, as long as the first value is not nil,
-- the other values don't matter.

-- The idea is to nest function calls with the "try" function. This function
-- checks the first value, and, if it's falsy, wraps the second value
-- in a table with metatable and calls "error" on it. Otherwise,
-- it returns all values it received.

-- The "newtry" function is a factory for "try" functions that call a finalizer
-- in protected mode before calling "error".

-- The "protect" function returns a new function that behaves exactly like the
-- function it receives, but the new function catches exceptions
-- thrown by "try" functions and returns nil followed by the error message
-- instead.

-- With these three function, it's easy to write functions that throw
-- exceptions on error, but that don't interrupt the user script.
-----------------------------------------------------------------------------

local base = _G
local _M = {}

local exception_metat = {}

function exception_metat:__tostring()
    return base.tostring(self[1])
end

local function do_nothing() end

function _M.newtry(finalizer)
    if finalizer == nil then finalizer = do_nothing end
    return function(...)
        local ok, err = ...
        if ok then
            return ...
        else
            base.pcall(finalizer)
            base.error(base.setmetatable({err}, exception_metat))
        end
    end
end

local function handle_pcall_returns(ok, ...)
    if ok then
        return ...
    else
        local err = ...
        if base.getmetatable(err) == exception_metat then
            return nil, err[1]
        else
            base.error(err, 0)
        end
    end
end

function _M.protect(func)
    return function(...)
        return handle_pcall_returns(base.pcall(func, ...))
    end
end

return _M
`
