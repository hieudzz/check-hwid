-- LocalScript (client)

local Players = game:GetService("Players")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local UIS = game:GetService("UserInputService")

local function getExecutorName()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        if name and ver then return string.format("%s (%s)", name, ver) end
        if name then return tostring(name) end
    end
    if syn then return "syn-like (mobile shim?)" end
    return "Unknown"
end

local function tryGetExecutorHWID()
    local try = {
        function() return syn and syn.get_hwid and syn.get_hwid() end,
        function() return gethwid and gethwid() end,
        function() return get_hwid and get_hwid() end,
        function() return getdeviceid and getdeviceid() end,
        function() return deviceid and deviceid() end,
        function() return get_device_id and get_device_id() end,
    }
    for _, f in ipairs(try) do
        local ok, v = pcall(f)
        if ok and v and tostring(v) ~= "" then
            return tostring(v)
        end
    end
    return nil
end

local function getClientId()
    local ok, v = pcall(function() return RbxAnalytics:GetClientId() end)
    return ok and v or "unknown"
end

local isAndroid = false
pcall(function() isAndroid = (UIS:GetPlatform() == Enum.Platform.Android) end)

local execName = getExecutorName()
local execHWID = tryGetExecutorHWID()
local clientId = getClientId()

-- ==== GUI ====
local lp = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ExecIDPanel"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.7, 0, 0.42, 0)
frame.Position = UDim2.new(0.15, 0, 0.29, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundTransparency = 1
title.Text = "🔐 Executor / Device IDs"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0.6, 0)
info.Position = UDim2.new(0, 10, 0.2, 0)
info.BackgroundTransparency = 1
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.TextWrapped = true
info.TextScaled = false
info.Font = Enum.Font.SourceSans
info.TextColor3 = Color3.fromRGB(255, 255, 255)
info.TextSize = 20
info.Parent = frame

local function buildText()
    local lines = {
        ("Platform: %s"):format(isAndroid and "Android" or "Other"),
        ("Executor: %s"):format(execName),
        ("Executor HWID: %s"):format(execHWID or "N/A (executor không cung cấp API)"),
        ("ClientId: %s"):format(clientId),
    }
    return table.concat(lines, "\n")
end
info.Text = buildText()

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.45, 0, 0.15, 0)
copyBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextScaled = true
copyBtn.Text = "Copy HWID (or ClientId)"
copyBtn.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.45, 0, 0.15, 0)
closeBtn.Position = UDim2.new(0.5, 0, 0.82, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextScaled = true
closeBtn.Text = "Close"
closeBtn.Parent = frame

local StarterGui = game:GetService("StarterGui")
local function toast(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = "Exec ID", Text = msg, Duration = 5})
    end)
end

copyBtn.MouseButton1Click:Connect(function()
    local textToCopy = execHWID or clientId
    if setclipboard then
        pcall(setclipboard, textToCopy)
        toast("Đã copy: " .. string.sub(textToCopy, 1, 24) .. "...")
    else
        toast("Executor không hỗ trợ setclipboard; hãy tự ghi lại.")
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
