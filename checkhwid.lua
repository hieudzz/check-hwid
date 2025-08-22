-- LocalScript đặt trong StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local player = Players.LocalPlayer

-- Check Android
local isAndroid = false
pcall(function()
	isAndroid = (UIS:GetPlatform() == Enum.Platform.Android)
end)

-- Lấy ClientId
local clientId = "unknown"
pcall(function()
	clientId = RbxAnalytics:GetClientId()
end)

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BigIDGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo khung bảng to
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.6, 0, 0.4, 0) -- to chiếm 60% chiều ngang, 40% chiều dọc
frame.Position = UDim2.new(0.2, 0, 0.3, 0) -- ở giữa màn hình
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundTransparency = 1
title.Text = "📱 Device Information"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Nội dung
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0.75, 0)
info.Position = UDim2.new(0, 0, 0.25, 0)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(255, 255, 255)
info.Font = Enum.Font.SourceSans
info.TextScaled = true
info.TextWrapped = true
info.Parent = frame

info.Text = "Android: " .. tostring(isAndroid) .. "\nClientId:\n" .. clientId
