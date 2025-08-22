-- LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local function getPlatform()
	-- Thử API chính xác (nếu có)
	local ok, plat = pcall(function()
		return UIS:GetPlatform()
	end)
	if ok and plat then
		return plat -- Enum.Platform
	end

	-- Fallback suy đoán
	if GuiService:IsTenFootInterface() then
		return "Console"
	end
	if UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled then
		return "Mobile"
	end
	return "Desktop"
end

local function isAndroid()
	local ok, plat = pcall(function()
		return UIS:GetPlatform()
	end)
	if ok and plat then
		return plat == Enum.Platform.Android
	end
	-- Fallback: không chắc => false
	return false
end

local function getClientId()
	local ok, cid = pcall(function()
		return RbxAnalyticsService:GetClientId()
	end)
	return ok and cid or "unknown"
end

local me = Players.LocalPlayer
local platform = getPlatform()
local onAndroid = isAndroid()
local clientId = getClientId()

print("[Device Check]")
print("UserId      :", me.UserId)
print("Platform    :", typeof(platform) == "EnumItem" and platform.Name or tostring(platform))
print("Is Android? :", onAndroid)
print("ClientId    :", clientId)

-- Hiện thông báo nhỏ trên màn hình
local StarterGui = game:GetService("StarterGui")
pcall(function()
	Starter
