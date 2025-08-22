local UIS = game:GetService("UserInputService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local isAndroid = (UIS:GetPlatform() == Enum.Platform.Android)
local clientId = RbxAnalytics:GetClientId()

print("Is Android? ", isAndroid)
print("ClientId   : ", clientId)
