--# = template
--# :toc:
--# :toc-placement!:
--#
--# Embedded Lua templating. This is etlua(github.com/leafo/etlua). +
--#
--# Not in the global namespace. Load with `require('template')`.
--#
--# toc::[]
--#
--# == *template.compile*(_String_) -> _Function_
--# Compiles the template into a function, the returned function can be called to render the template. The function takes one argument: a table to use as the environment within the template. `_G` is used to look up a variable if it can't be found in the environment.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| String to compile
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |function| (_Table_) -> _String_
--# |===
--#
--# == *template.render*(_String_, _Table_) -> _String_
--# Compiles and renders the template in a single call. If you are concerned about high performance this should be avoided in favor of `compile` if it's possible to cache the compiled template.
--#
--# === Arguments
--# [width="72%"]
--# |===
--# |string| String to compile
--# |===
--#
--# === Returns
--# [width="72%"]
--# |===
--# |function| (_Table_) -> _String_
--# |===
--#
--# :note-caption: :information_source:
--# [NOTE]
--# ====
--# Documentation and tests from etlua project page.
--# Check github.com/leafo/etlua for information on the `Parser` raw API.
--# ====
local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local template = require("template")
local compile = template.compile
local render = template.render
local Parser = template.Parser
local single = function()
	do
		local cases = {
			{
				"hello world",
				"hello world",
			},
			{
				"one surf-zone two",
				"one <%= var %> two",
				{ var = "surf-zone" },
			},
			{
				"a ((1))((2))((3)) b",
				"a <% for i=1,3 do %>((<%= i %>))<% end %> b",
			},
			{
				"y%&gt;u",
				[[<%= "y%>u" %>]],
			},
			{
				"y%>u",
				[[<%- 'y%>u' %>]],
			},
			{
				[[
This is my message to you
This is my message to 4



  hello 1
  hello 2
  hello 3
  hello 4
  hello 5
  hello 6
  hello 7
  hello 8
  hello 9
  hello 10

message: yeah

This is my message to oh yeah  %&gt;&quot;]],
				[[
This is my message to <%= "you" %>
This is my message to <%= 4 %>
<% if things then %>
  I love things
<% end %>

<% for i=1,10 do%>
  hello <%= i -%>
<% end %>

message: <%= visitor %>

This is my message to <%= [=[oh yeah  %>"]=] %>]],
				{
					visitor = "yeah",
				},
			},
			{
				"hello",
				[[<%= 'hello' -%>
]],
			},
			-- should have access to _G
			{
				"",
				"<% assert(true) %>",
				{ hello = "world" },
			},
		}

		for _, case in ipairs(cases) do
			T["template.render"] = function()
				T.equal(case[1], render(unpack(case), 2))
			end
		end

		T["template.render || error on unclosed tag"] = function()
			local v, e = render("hello <%= world")
			T.is_nil(v)
			T.equal(e, "failed to find closing tag [1]: hello <%= world")
		end
		T["template.render || bad interpolate tag"] = function()
			local v, e = render("hello <%= if hello then print(nil) end%>")
			T.is_nil(v)
			T.equal(e, [[etlua line:5(column:41) near 'if':   syntax error
]])
		end
		T["template.render || bad code tag"] = function()
			local v, e = render([[
          what is going on
          hello <% howdy doody %>
          there is nothing left
        ]])
			T.is_nil(v)
			T.equal(e, [[etlua line:4(column:21) near 'doody':   parse error
]])
		end
		T["template.compile && use existing buffer"] = function()
			local fn = compile([[hello<%= 'yeah' %>]])
			local buff = { "first" }
			local out = fn({}, buff, #buff)
			T.equal("firsthelloyeah", out)
		end
		T["template.Parser && readme example"] = function()
			local parser = Parser()
			first_fn = parser:load(parser:compile_to_lua("Hello "))
			second_fn = parser:load(parser:compile_to_lua("World"))
			local buffer = {}
			parser:run(first_fn, nil, buffer, #buffer)
			parser:run(second_fn, nil, buffer, #buffer)
			T.equal("Hello World", table.concat(buffer))
		end
	end
	do
		local cases = {
			{ "hello world", false },
			{ "hello 'world", true },
			{ [[hello "hello \" world]], true },
			{ "hello [=[ wor'ld ]=]dad", false },
		}
		for _, expected in ipairs(cases) do
			T["template.Parser && in_string"] = function()
				local s = expected[1]
				T.equal(expected[2], Parser.in_string({ str = s }, 1))
			end
		end
	end
end
if included then
	return function()
		T["template"] = single
	end
else
	T["template"] = single
end
