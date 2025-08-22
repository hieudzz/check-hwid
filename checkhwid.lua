-- LocalScript
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local player = Players.LocalPlayer

-- Check Android
local isAndroid = (UIS:GetPlatform() == Enum.Platform.Android)
-- Lấy ClientId (ID duy nhất Roblox cấp cho client)
local clientId = RbxAnalytics:GetClientId()

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeviceInfoGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo TextLabel hiển thị
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.4, 0, 0.1, 0)
label.Position = UDim2.new(0.3, 0, 0.05, 0)
label.BackgroundTransparency = 0.3
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true
label.Parent = screenGui

-- Nội dung hiển thị
label.Text = string.format("Android: %s\nClientId: %s",
    tostring(isAndroid),
    clientId:sub(1,8) .. "..." -- rút gọn để dễ nhìn
)
