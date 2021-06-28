package.path = "internal/lua/?.lua"
local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local A = require("argparse")
local expect = T.expect
local is_table = T.is_table
local raised = T.error_raised
local new = function()
	local parser = A()
	local p = parser:parse({})
	is_table(p)
end
local one_arg = function()
	local parser = A()
	parser:argument("foo")
	local args = parser:parse({"bar"})
	expect("bar")(args.foo)
end
local opt_arg = function()
	local parser = A()
	parser:argument("foo"):args("?")
	local args = parser:parse({"bar"})
	expect("bar")(args.foo)
end
local many_args = function()
	local parser = A()
	parser:argument("foo1")
	parser:argument("foo2")
	local args = parser:parse({"bar", "baz"})
	expect("bar")(args.foo1)
	expect("baz")(args.foo2)
end
local wildcard_args = function()
	local parser = A()
	parser:argument("foo"):args("*")
	local args = parser:parse({"bar", "baz", "qu"})
	expect("bar")(args.foo[1])
	expect("baz")(args.foo[2])
	expect("qu")(args.foo[3])
end
local hyphens = function()
	local parser = A()
	parser:argument("foo")
	local args = parser:parse({"-"})
	expect("-")(args.foo)
	args = parser:parse({"--", "-q"})
	expect("-q")(args.foo)
end
local commands_after_args = function()
	local parser = A("name")
	parser:argument("file")
	parser:command("create")
	parser:command("remove")
	local args = parser:parse{"temp.txt", "remove"}
	expect("temp.txt")(args.file)
	expect(true)(args.remove)
end
local command_flags = function()
	local parser = A("name")
	local install = parser:command("install")
	install:flag "-q" "--quiet"
	local args = parser:parse{"install", "-q"}
	expect(true)(args.install)
	expect(true)(args.quiet)
end
local nested_commands = function()
	local parser = A("name")
	local install = parser:command("install")
	install:command("bar")
	local args = parser:parse{"install", "bar"}
	expect(true)(args.install)
	expect(true)(args.bar)
end
local action_args = function()
	local parser = A()
	local foo
	parser:argument("foo"):action(function(_, _, passed)
		foo = passed
	end)
	local baz
	parser:argument("baz"):args("*"):action(function(_, _, passed)
		baz = passed
	end)
	parser:parse({"a"})
	expect("a")(foo)
	expect(0)(#baz)
	parser:parse({"b", "c"})
	expect("b")(foo)
	expect("c")(baz[1])
	parser:parse({"d", "e", "f"})
	expect("d")(foo)
	expect("e")(baz[1])
	expect("f")(baz[2])
end
if included then
	return function()
		T["new parser"] = new
		T["one argument"] = one_arg
		T["optional argument"] = opt_arg
		T["several arguments"] = many_args
		T["wildcard arguments"] = wildcard_args
		T["hyphens"] = hyphens
		T["commands after arguments"] = commands_after_args
		T["command flags"] = command_flags
		T["nested commands"] = nested_commands
		T["action on arguments"] = action_args
	end
else
	T["new parser"] = new
	T["one argument"] = one_arg
	T["optional argument"] = opt_arg
	T["several arguments"] = many_args
	T["wildcard arguments"] = wildcard_args
	T["hyphens"] = hyphens
	T["commands after arguments"] = commands_after_args
	T["command flags"] = command_flags
	T["nested commands"] = nested_commands
	T["action on arguments"] = action_args
end
