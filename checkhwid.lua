-- LocalScript (StarterPlayerScripts)
-- Auto XÓA FULL map/players khác/effect khi chạy

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Ẩn tất cả Part, Character khác
local function hidePart(p)
	if p:IsA("BasePart") then
		-- không ẩn nhân vật của mình
		local ch = lp.Character
		if ch and p:IsDescendantOf(ch) then return end
		p.LocalTransparencyModifier = 1
	end
end

-- Áp dụng lighting đen
local function darkLighting()
	Lighting.FogStart = 0
	Lighting.FogEnd = 1
	Lighting.FogColor = Color3.new(0,0,0)
	Lighting.Brightness = 0
	Lighting.GlobalShadows = false
end

-- Xóa mọi hiệu ứng nặng
local function clearEffects(obj)
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
		obj.Enabled = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 1
	end
end

local function nukeOnce()
	for _, d in ipairs(workspace:GetDescendants()) do
		hidePart(d)
		clearEffects(d)
	end
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= lp and pl.Character then
			for _, d in ipairs(pl.Character:GetDescendants()) do
				hidePart(d)
				clearEffects(d)
			end
		end
	end
end

-- Áp dụng ngay khi chạy
darkLighting()
nukeOnce()

-- Giữ liên tục
RunService.Heartbeat:Connect(nukeOnce)
