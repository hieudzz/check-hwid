-- LocalScript: XÓA FULL (ẩn toàn bộ map/players khác) + Khôi phục
-- Mục tiêu: ẩn chỉ ở client (dùng LocalTransparencyModifier), không ảnh hưởng collision.

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- ====== GUI ======
local gui = Instance.new("ScreenGui")
gui.Name = "XoaFullGUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.22, 0)
frame.Position = UDim2.new(0.25, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.35, 0)
title.BackgroundTransparency = 1
title.Text = "XÓA FULL MAP (Client)"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local btnOn = Instance.new("TextButton")
btnOn.Size = UDim2.new(0.48, 0, 0.5, 0)
btnOn.Position = UDim2.new(0.02, 0, 0.45, 0)
btnOn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
btnOn.TextColor3 = Color3.fromRGB(255, 255, 255)
btnOn.TextScaled = true
btnOn.Font = Enum.Font.SourceSansBold
btnOn.Text = "BẬT (Ẩn sạch)"
btnOn.Parent = frame

local btnOff = Instance.new("TextButton")
btnOff.Size = UDim2.new(0.48, 0, 0.5, 0)
btnOff.Position = UDim2.new(0.5, 0, 0.45, 0)
btnOff.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnOff.TextColor3 = Color3.fromRGB(255, 255, 255)
btnOff.TextScaled = true
btnOff.Font = Enum.Font.SourceSansBold
btnOff.Text = "TẮT (Khôi phục)"
btnOff.Parent = frame

-- ====== CORE ======
local nuked = false
local connLoop

-- Chỉ ẩn hình, giữ va chạm: dùng LocalTransparencyModifier (cục bộ)
local function hidePart(p)
	if p:IsA("BasePart") then
		-- Đừng ẩn nhân vật của mình
		local ch = lp.Character
		if ch and p:IsDescendantOf(ch) then return end
		p.LocalTransparencyModifier = 1
	end
end

local function showPart(p)
	if p:IsA("BasePart") then
		p.LocalTransparencyModifier = 0
	end
end

local function applyLightingDark()
	-- Làm tối/đen để “xóa” Terrain/sky cục bộ
	Lighting.FogStart = 0
	Lighting.FogEnd = 1
	Lighting.FogColor = Color3.new(0,0,0)
	Lighting.Brightness = 0
	Lighting.GlobalShadows = false
end

local function restoreLighting()
	-- Khôi phục cơ bản (đủ nhìn lại). Tuỳ game có thể khác.
	Lighting.FogStart = 100000
	Lighting.FogEnd = 100000
	Lighting.FogColor = Color3.fromRGB(255,255,255)
	Lighting.Brightness = 2
	Lighting.GlobalShadows = true
end

local function nukeOnce()
	for _, d in ipairs(workspace:GetDescendants()) do
		hidePart(d)
	end
	-- Ẩn người chơi khác
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= lp and pl.Character then
			for _, d in ipairs(pl.Character:GetDescendants()) do
				hidePart(d)
			end
		end
	end
end

local function restoreOnce()
	for _, d in ipairs(workspace:GetDescendants()) do
		showPart(d)
	end
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl.Character then
			for _, d in ipairs(pl.Character:GetDescendants()) do
				showPart(d)
			end
		end
	end
end

local function startNuke()
	if nuked then return end
	nuked = true
	applyLightingDark()
	nukeOnce()
	-- Liên tục ẩn các part mới spawn để “xóa full” bền
	connLoop = RunService.Heartbeat:Connect(function()
		nukeOnce()
	end)
end

local function stopNuke()
	if not nuked then return end
	nuked = false
	if connLoop then connLoop:Disconnect() connLoop = nil end
	restoreLighting()
	restoreOnce()
end

btnOn.MouseButton1Click:Connect(startNuke)
btnOff.MouseButton1Click:Connect(stopNuke)

-- Hotkey: nhấn F8 để bật/tắt nhanh
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.F8 then
		if nuked then stopNuke() else startNuke() end
	end
end)
