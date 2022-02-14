colors = {"Really red", "Lime green", "Toothpaste", "Royal blue", "Royal purple", "New Yeller", "Bright orange", "Institutional white", "Hot pink"}
for p, player in pairs(Game.Players:GetChildren()) do
	local character = player.Character
	local torso = character:FindFirstChild("Torso")
	if not torso then return end
	local glowStick = Instance.new("Tool", player.Backpack)
	glowStick.Name = "Glow stick"
	local handle = Instance.new("Part", glowStick)
	handle.Name = "Handle"
	handle.Material = "Neon"
	handle.Size = Vector3.new(1, 2, 1)
	local chosen = math.random(1, #colors)
	handle.BrickColor = BrickColor.new(colors[chosen])
	local light = Instance.new("PointLight", handle)
	light.Color = BrickColor.new(colors[chosen]).Color
	local equipped = false
	local first = true
	glowStick.Equipped:connect(function(mouse)
		equipped = true
		if first then
			first = false
			mouse.Button1Down:connect(function()
				if equipped then
					local newGlowStick = handle:Clone()
					newGlowStick.CFrame = torso.CFrame*CFrame.new(0, 0, 2)
					local newForce = Instance.new("BodyForce", newGlowStick)
					newForce.Force = (mouse.Hit.p-torso.Position)*50
					newGlowStick.Parent = Workspace
					Game:GetService("Debris"):AddItem(newGlowStick, 10)
				end
			end)
		end
		while equipped do
			wait(1)
			local chosen = math.random(1, #colors)
			handle.BrickColor = BrickColor.new(colors[chosen])
			light.Color = BrickColor.new(colors[chosen]).Color
		end
	end)
	glowStick.Unequipped:connect(function()
		equipped = false
	end)
	
end