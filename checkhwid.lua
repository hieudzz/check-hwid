-- Whiteout Overlay + Mini HUD (FPS, Ping, RAM, Instances)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MPS = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")
local lp = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "WhiteoutOverlay"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = lp:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0
frame.Parent = gui

-- Game name
local gameName = "Unknown"
do
	local ok, info = pcall(function()
		return MPS:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
	end)
	if ok and info and typeof(info) == "table" and info.Name then
		gameName = info.Name
	end
end

-- Info Label (Main)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 320)
infoLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
infoLabel.AnchorPoint = Vector2.new(0.5, 0.5)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(0, 0, 0)
infoLabel.TextStrokeTransparency = 0.3
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.TextSize = 30
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextYAlignment = Enum.TextYAlignment.Center
infoLabel.Parent = gui

-- Mini HUD
local miniHUD = Instance.new("TextLabel")
miniHUD.Size = UDim2.new(0, 250, 0, 90)
miniHUD.Position = UDim2.new(0, 10, 0, 10)
miniHUD.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniHUD.BackgroundTransparency = 0.3
miniHUD.TextColor3 = Color3.new(1, 1, 1)
miniHUD.Font = Enum.Font.SourceSansBold
miniHUD.TextSize = 20
miniHUD.TextXAlignment = Enum.TextXAlignment.Left
miniHUD.TextYAlignment = Enum.TextYAlignment.Top
miniHUD.TextStrokeTransparency = 0.3
miniHUD.Text = "Mini HUD\nFPS: 0\nPing: 0\nRAM: 0 MB\nInst: 0"
miniHUD.Parent = gui
miniHUD.Visible = true

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, 0, 0.9, 0)
toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 28
toggleButton.Text = "Whiteout: ON"
toggleButton.Parent = gui

-- Vars
local visible = true
local hudVisible = true
local transparency = 0
local mapHidden = false
local storedParents = {}
local whiteoutStartTime = os.clock()
local fpsMin, fpsMax, fpsSum, fpsCount = math.huge, 0, 0, 0

-- Hide/Show map
local function hideMap()
	if mapHidden then return end
	mapHidden = true
	storedParents = {}
	for _, obj in ipairs(workspace:GetChildren()) do
		if not obj:IsDescendantOf(lp.Character) and obj ~= workspace.CurrentCamera and obj.Name ~= "Terrain" then
			storedParents[obj] = obj.Parent
			obj.Parent = nil
		end
	end
end
local function showMap()
	if not mapHidden then return end
	mapHidden = false
	for obj, parent in pairs(storedParents) do
		if obj and parent then obj.Parent = parent end
	end
	storedParents = {}
end

-- Apply
local function apply()
	frame.Visible = visible
	frame.BackgroundTransparency = transparency
	infoLabel.Visible = visible
	if visible then
		hideMap()
		whiteoutStartTime = os.clock()
	else
		showMap()
	end
end
apply()

-- Toggle Button click
toggleButton.MouseButton1Click:Connect(function()
	visible = not visible
	apply()
	toggleButton.Text = visible and "Whiteout: ON" or "Whiteout: OFF"
end)

-- Update Stats
local lastUpdate = os.clock()
local frames = 0
RunService.Heartbeat:Connect(function()
	frames += 1
	local now = os.clock()
	if now - lastUpdate >= 1 then
		local fps = frames / (now - lastUpdate)
		frames, lastUpdate = 0, now

		fpsCount += 1
		fpsSum += fps
		if fps < fpsMin then fpsMin = fps end
		if fps > fpsMax then fpsMax = fps end
		local fpsAvg = fpsSum / fpsCount

		-- Ping + RAM + Instances
		local ping = Stats.Network.ServerStatsItem["Data Ping"] and math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) or 0
		local ram = math.floor(Stats:GetTotalMemoryUsageMb())
		local instances = Stats.InstanceCount

		-- Timer
		local elapsed = math.floor(now - whiteoutStartTime)
		local timerText = visible and string.format("Whiteout On: %ds", elapsed) or "Whiteout Off"

		-- Main overlay
		infoLabel.Text = string.format(
			"Game: %s\nPlayer: %s (@%s)\nFPS: %d | AVG: %d | MIN: %d | MAX: %d\nPing: %d ms\nRAM: %d MB | Instances: %d\n%s",
			gameName,
			lp.DisplayName, lp.Name,
			math.floor(fps + 0.5), math.floor(fpsAvg + 0.5),
			math.floor(fpsMin + 0.5), math.floor(fpsMax + 0.5),
			ping, ram, instances, timerText
		)

		-- Mini HUD
		if hudVisible then
			miniHUD.Text = string.format(
				"Mini HUD\nFPS: %d\nPing: %d ms\nRAM: %d MB\nInst: %d",
				math.floor(fps + 0.5), ping, ram, instances
			)
		end
	end
end)

-- Respawn
lp.CharacterAdded:Connect(function()
	task.wait(1)
	visible = true
	apply()
	toggleButton.Text = "Whiteout: ON"
end)

-- Hotkeys
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		visible = not visible
		apply()
		toggleButton.Text = visible and "Whiteout: ON" or "Whiteout: OFF"
	elseif input.KeyCode == Enum.KeyCode.M then -- Toggle Mini HUD
		hudVisible = not hudVisible
		miniHUD.Visible = hudVisible
	elseif input.KeyCode == Enum.KeyCode.LeftBracket then
		transparency = math.clamp(transparency + 0.05, 0, 1)
		apply()
	elseif input.KeyCode == Enum.KeyCode.RightBracket then
		transparency = math.clamp(transparency - 0.05, 0, 1)
		apply()
	end
end)
