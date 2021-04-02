local tostring = function(s)
  return string.format('„%s“', tostring(s))
end
local function red(str)    return grey and str or "\27[1;31m" .. str .. "\27[0m" end
local function blue(str)   return grey and str or "\27[1;34m" .. str .. "\27[0m" end
local function green(str)  return grey and str or "\27[1;32m" .. str .. "\27[0m" end
local function yellow(str) return grey and str or "\27[1;33m" .. str .. "\27[0m" end

local tab_tag      = blue   "[----------]"
local done_tag     = blue   "[==========]"
local run_tag      = blue   "[ RUN      ]"
local ok_tag       = green  "[       OK ]"
local fail_tag     = red    "[      FAIL]"
local disabled_tag = yellow "[ DISABLED ]"
local passed_tag   = green  "[  PASSED  ]"
local failed_tag   = red    "[  FAILED  ]"

local ntests = 0
local failed = false
local failed_list = {}

local function trace(start_frame)
    print "Trace:"
    local frame = start_frame
    while true do
        local info = debug.getinfo(frame, "Sl")
        if not info then break end
        if info.what == "C" then
            print(frame - start_frame, "??????")
        else
            print(frame - start_frame, info.short_src .. ":" .. info.currentline .. " ")
        end
        frame = frame + 1
    end
end

local function log(msg)
    if not quiet then
        print(msg)
    end
end

local function fail(msg, start_frame)
    failed = true
    print("Fail: " .. msg)
    trace(start_frame or 4)
end

local function stringize_var_arg(...)
    local args = { n = select("#", ...), ... }
    local result = {}
    for i = 1, args.n do
        if type(args[i]) == 'string' then
            result[i] = '"' .. tostring(args[i]) .. '"'
        else
            result[i] = tostring(args[i])
        end
    end
    return table.concat(result, ", ")
end

local function test_pretty_name(suite_name, test_name)
    if suite_name == "__root" then
        return test_name
    else
        return suite_name .. "." .. test_name
    end
end

-- PUBLIC API -----------------------------------------------------------------
local api = { test_suite_name = "__root", skip = false }

api.assert = function (cond)
    if not cond then
        fail("assertion " .. tostring(cond) .. " failed")
    end
end

api.equal = function (l, r)
    if l ~= r then
        fail(tostring(l) .. " ~= " .. tostring(r))
    end
end

api.not_equal = function (l, r)
    if l == r then
        fail(tostring(l) .. " == " .. tostring(r))
    end
end

api.almost_equal = function (l, r, diff)
    if require("math").abs(l - r) > diff then
        fail("|" .. tostring(l) .. " - " .. tostring(r) .."| > " .. tostring(diff))
    end
end

api.is_false = function (maybe_false)
    if maybe_false or type(maybe_false) ~= "boolean" then
        fail("got " .. tostring(maybe_false) .. " instead of false")
    end
end

api.is_true = function (maybe_true)
    if not maybe_true or type(maybe_true) ~= "boolean" then
        fail("got " .. tostring(maybe_true) .. " instead of true")
    end
end

api.is_not_nil = function (maybe_not_nil)
    if type(maybe_not_nil) == "nil" then
        fail("got nil")
    end
end

api.error_raised = function (f, error_message, ...)
    local status, err = pcall(f, ...)
    if status == true then
        fail("error not raised")
    else
        if error_message ~= nil then
            -- we set "plain" to true to avoid pattern matching in string.find
            if err:find(error_message, 1, true) == nil then
                fail("'" .. error_message .. "' not found in error '" .. tostring(err) .. "'")
            end
        end
    end
end

api.register_assert = function(assert_name, assert_func)
    rawset(api, assert_name, function(...)
        local result, msg = assert_func(...)
        if not result then
            msg = msg or "Assertion "..assert_name.." failed"
            fail(msg)
        end
    end)
end

local function make_type_checker(typename)
    api["is_" .. typename] = function (maybe_type)
        if type(maybe_type) ~= typename then
            fail("got " .. tostring(maybe_type) .. " instead of " .. typename, 4)
        end
    end
end

local supported_types = {"nil", "boolean", "string", "number", "userdata", "table", "function", "thread"}
for i, supported_type in ipairs(supported_types) do
    make_type_checker(supported_type)
end

local last_test_suite
local function run_test(test_suite, test_name, test_function, ...)
    local suite_name = test_suite.test_suite_name
    local full_test_name = test_pretty_name(suite_name, test_name)

    if test_regex and not string.match(full_test_name, test_regex) then
        return
    end

    if test_suite.skip then
        log(disabled_tag .. " " .. full_test_name)
        return
    end


    if suite_name ~= last_test_suite then
        log(tab_tag)
        last_test_suite = suite_name
    end

    ntests = ntests + 1
    failed = false

    log(run_tag .. " " .. full_test_name)

    local start = os.clock()

    local status, err
    for _, f in ipairs({test_suite.start_up,  test_function, test_suite.tear_down}) do
        status, err = pcall(f, ...)
        if not status then
            failed = true
            print(tostring(err))
        end
    end

    local stop = os.clock()

    local is_test_failed = not status or failed
    log(string.format("%s %s %.4f sec",
                            is_test_failed and fail_tag or ok_tag,
                            full_test_name,
                            stop-start))

    if is_test_failed then
        table.insert(failed_list, full_test_name)
    end
end

api.summary = function ()
    log(done_tag)
    local nfailed = #failed_list
    if nfailed == 0 then
        log(passed_tag .. " " .. ntests .. " test(s)")
        os.exit(0)
    else
        log(failed_tag .. " " .. nfailed .. " out of " .. ntests .. ":")
        for _, test_name in ipairs(failed_list) do
            log(failed_tag .. "\t" .. test_name)
        end
        os.exit(1)
    end
end

api.result = function ( ... )
    return ntests, #failed_list
end

local default_start_up = function () end
local default_tear_down = function () collectgarbage() end

api.start_up = default_start_up
api.tear_down = default_tear_down

local all_test_cases = { __root = {} }
local function handle_new_test(suite, test_name, test_function)
    local suite_name = suite.test_suite_name
    if not all_test_cases[suite_name] then
        all_test_cases[suite_name] = {}
    end
    all_test_cases[suite_name][test_name] = test_function

    local info = debug.getinfo(test_function)
    if info.nparams == nil and
            string.sub(test_name, #test_name - 1, #test_name) ~= "_p"
            or info.nparams == 0 then
        run_test(suite, test_name, test_function)
    end
end

local function lookup_test_with_params(suite, test_name)
    local suite_name = suite.test_suite_name

    if all_test_cases[suite_name] and all_test_cases[suite_name][test_name] then
        return function (...)
            run_test(suite
                , test_name .. "(" .. stringize_var_arg(...) .. ")"
                , all_test_cases[suite_name][test_name], ...)
        end
    else
        local full_test_name = test_pretty_name(suite_name, test_name)
        table.insert(failed_list, full_test_name)
        ntests = ntests + 1
        log(fail_tag .. " No " .. full_test_name .. " parametrized test case!")
    end
end

local function new_test_suite(_, name)
    local test_suite = {
        test_suite_name = name,
        start_up = default_start_up,
        tear_down = default_tear_down,
        skip = false }

    setmetatable(test_suite, {
        __newindex = handle_new_test,
        __index = lookup_test_with_params })
    return test_suite
end

local test_suites = {}
setmetatable(api, {
    __index = function (tbl, name)
        if all_test_cases.__root[name] then
            return lookup_test_with_params(tbl, name)
        end

        if not test_suites[name] then
            test_suites[name] = new_test_suite(tbl, name)
        end
        return test_suites[name]
    end,
    __newindex = handle_new_test
})

return api
