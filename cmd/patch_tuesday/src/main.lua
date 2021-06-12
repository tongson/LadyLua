-- 2021-Jun-12 https://github.com/Immersive-Labs-Sec/msrc-api/ in Lua
local json = require("json")
local http = require("http")
local fmt = require("fmt")
local argparse = require("argparse")
local parser = argparse()
parser:argument("id")
local a = parser:parse(arg)
local body
do
	local options = {
		timeout = "30s",
		headers = { Accept = "application/json" },
	}
	local url = ("https://api.msrc.microsoft.com/cvrf/v2.0/cvrf/%s"):format(a.id)
	local req = http.get(url, options)
	body = json.decode(req.body)
end
local exploited = 0
local cves = {}
local vuln_types = {
	["Elevation of Privilege "] = 0,
	["Security Feature Bypass"] = 0,
	["Remote Code Execution  "] = 0,
	["Information Disclosure "] = 0,
	["Denial of Service      "] = 0,
	["Spoofing               "] = 0,
}
for k in pairs(vuln_types) do
	for _, t in ipairs(body.Vulnerability) do
		local cve = t.CVE
		local title = t.Title.Value
		for _, v in ipairs(t.Threats) do
			if v.Type == 1 and v.Description.Value:contains("Exploited:Yes") then
				exploited = exploited + 1
				cves[cve] = title
			end
			if v.Type == 0 and v.Description.Value == k:trim_end() then
				vuln_types[k] = vuln_types[k] + 1
				break
			end
		end
	end
end
fmt.print("%s\n", body.DocumentTitle.Value)
fmt.print("[+] Found %s vulnerabilities\n", table.size(body.Vulnerability))
for k in pairs(vuln_types) do
	fmt.print("    %s\t\t%s\n", k, vuln_types[k])
end
if exploited > 0 then
	fmt.print("[+] Found %s exploited\n", exploited)
	for c, t in pairs(cves) do
		fmt.print("    %s\t%s\n", c, t)
	end
end
