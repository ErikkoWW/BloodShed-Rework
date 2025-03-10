-- my code i made for TFA Base ~ Yurie
local EmptyFunc = function() end

local debugInfoTbl = debug.getinfo(EmptyFunc)

if debugInfoTbl.short_src and debugInfoTbl.short_src:StartWith("addons") then
	return -- we're overriding workshop shit, no need for any checks
end
-- my code end

local ogid = "504945881"
local alladdons = engine.GetAddons()
local ogmounted = false

for _, atbl in ipairs(alladdons) do
	if atbl.wsid and atbl.wsid == ogid then
		if atbl.downloaded and atbl.mounted then
			ogmounted = true
		end

		break
	end
end

if not ogmounted then return end -- original addon not installed, no need for warnings

-- waiting for full client load, THIS IS THE ONLY FUCKING WAY TO ENSURE THAT
hook.Add("HUDPaint", "LF_EPS_OGMountWarn", function()
	if not IsValid(LocalPlayer()) then return end
	hook.Remove("HUDPaint", "LF_EPS_OGMountWarn")

	chat.AddText(Color(255, 127, 127), "WARNING: ", color_white, "You have the original Enhanced Playermodel Selector addon installed and enabled.")
	chat.AddText(color_white, "Due to how Workshop mounting system works, the file override might not work, and as a result the hands tab will not appear.")
	chat.AddText(color_white, "Before reporting the missing tab ", Color(255, 127, 127), "make sure the original addon is disabled/not installed first.")
end)