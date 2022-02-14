U2 = UDim2.new
V2, V3 = Vector2.new, Vector3.new
BN, C3 = BrickColor.new, Color3.new
CN = CFrame.new
CA = function(x, y, z, inRadians) --CFrame.Angles
	if inRadians then
		return CFrame.Angles(x or 0, y or 0, z or 0)
	else
		return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
	end
end

for n, s in pairs({"Players", "Debris", "RunService", "Lighting", "ReplicatedStorage"}) do
	getfenv(1)[s] = Game:GetService(s)
end

--functions, etc.
function setEnvironmentGlobalized(f, t)
	setfenv(f, setmetatable(t or getfenv(f), {__index = function(t, i) return getfenv(1)[i] end}))
	return f
end
function set(instance)
	return function(properties)
		if type(instance) == "table" then
			local instances = {}
			for _, toSet in pairs(instance) do
				table.insert(instances, set(toSet)(properties))
			end
			return instances
		elseif type(instance) == "userdata" then
			for k, v in pairs(properties) do
				if type(k) == "string" then
					local propertyName = k:gsub(k, {
						pt = "Parent", sz = "Size", cf = "CFrame", bc = "BrickColor", tr = "Transparency", sc = "Scale", an = "Anchored",
						ts = "TopSurface", bs = "BottomSurface", rs = "RightSurface", ls = "LeftSurface", fs = "FrontSurface", bks = "BackSurface", cl = "Color", mt = "Material",
						nm = "Name", bgc = "BackgroundColor3", bgt = "BackgroundTransparency", bsp = "BorderSizePixel", bC3 = "BorderColor3", ps = "Position", cc = "CanCollide",
						p0 = "Part0", p1 = "Part1", mst = "MeshType", tx = "Texture", tC3 = "TextColor3"
					})
					instance[propertyName] = v
				elseif type(k) == "number" then
					if type(v) == "userdata" then
						v.Parent = instance
					elseif type(v) == "table" then
						for event, connection in pairs(v) do
							if type(event) == "string" then
								if type(connection) == "function" then
									instance[event]:connect(setEnvironmentGlobalized(connection, {this = instance}))
								end
							elseif type(event) == "number" then
								if type(connection) == "table" then
									if type(connection[1]) == "table" then
										local toDo = connection[2]
										setEnvironmentGlobalized(toDo, {this = instance})
										for i, v in pairs(connection[1]) do
											toDo(i, v)
										end
									else
										local step, toDo = 1, connection[3]
										if type(toDo) == "number" then
											step = connection[3]
											toDo = connection[4]
										end
										setEnvironmentGlobalized(toDo, {this = instance})
										for i = connection[1], connection[2], step do
											toDo(i)
										end
									end
								end
							end
						end
					elseif type(v) == "string" then
						getfenv(0)[v] = instance
					elseif type(v) == "function" then
						setEnvironmentGlobalized(v, {this = instance})()
					end
				end
				if properties.CFrame then instance.CFrame = properties.CFrame end
				if properties.C0 then instance.C0 = properties.C0 end
				if properties.C1 then instance.C1 = properties.C1 end
			end
			return instance
		end
	end
end
function new(instanceType)
	local newInstance = Instance.new(instanceType)
	if newInstance:IsA("BasePart") then
		pcall(function() newInstance.FormFactor = 3 end)
		set(newInstance){sz = V3(1, 1, 1), mt = "SmoothPlastic", ts = 0, bs = 0, Locked = true, an = true}
	elseif newInstance:IsA("GuiObject") then
		set(newInstance){sz = U2(1, 0, 1, 0), bsp = 0, bgc = C3()}
		if newInstance:IsA("TextBox") or newInstance:IsA("TextLabel") or newInstance:IsA("TextButton") then
			set(newInstance){Text = "", TextColor3 = C3(1, 1, 1), bgt = 1}
		end
		if newInstance:IsA("GuiButton") then
			newInstance.AutoButtonColor = false
		end
	end
	return function(properties)
		return set(newInstance)(properties)
	end
end

function frame(pt, sz, ps, bgc, bgt, rt)
	return new'Frame'{pt = pt, sz = sz, ps = ps, bgc = bgc, bgt = bgt or 0, Rotation = rt or 0}
end
function tLabel(pt, Text, TextSize, tC3, sz, ps, rt)
	return new'TextLabel'{pt = pt, Text = Text, TextSize = TextSize, tC3 = tC3, sz = sz or U2(1, 0, 1, 0), ps = ps or U2(), Rotation = rt or 0}
end
function tButton(pt, Text, TextSize, tC3, sz, ps, rt)
	return new'TextButton'{pt = pt, Text = Text, TextSize = TextSize, tC3 = tC3, sz = sz or U2(1, 0, 1, 0), ps = ps or U2(), Rotation = rt or 0}
end
function tCombo(pt, Text, TextSize, tC3, sz, ps, bgc, bgt, rt)
	local newFrame = frame(pt, sz, ps, bgc, bgt, rt)
	local newButton = tButton(newFrame, Text, TextSize, tC3)
	return newFrame, newButton
end
function outline(fr, bsp, bC3, mod, tr)
	local tp = frame(fr, U2(1, (mod*2+1)*bsp, 0, bsp), U2(0, (mod*2+1)*-bsp/2, 0, -bsp/2-mod*bsp), bC3, tr or 0)
	local bt = frame(fr, U2(1, (mod*2+1)*bsp, 0, bsp), U2(0, (mod*2+1)*-bsp/2, 1, -bsp/2+mod*bsp), bC3, tr or 0)
	local rt = frame(fr, U2(0, bsp, 1, (mod*2+1)*bsp), U2(1, -bsp/2+mod*bsp, 0, (mod*2+1)*-bsp/2), bC3, tr or 0)
	local lf = frame(fr, U2(0, bsp, 1, (mod*2+1)*bsp), U2(0, -bsp/2-mod*bsp, 0, (mod*2+1)*-bsp/2), bC3, tr or 0)
end
function corner(fr, sz, bC3, rt)
	local tplf = frame(fr, U2(0, sz, 0, sz), U2(0, -sz/2, 0, -sz/2), bC3)
	local tprt = frame(fr, U2(0, sz, 0, sz), U2(1, -sz/2, 0, -sz/2), bC3)
	local btlf = frame(fr, U2(0, sz, 0, sz), U2(0, -sz/2, 1, -sz/2), bC3)
	local btrt = frame(fr, U2(0, sz, 0, sz), U2(1, -sz/2, 1, -sz/2), bC3)
	if rt then
		tplf.Rotation = 45
		tprt.Rotation = 45
		btlf.Rotation = 45
		btrt.Rotation = 45
	end
end
function connect(pt, ps1, ps2, wd, bC3, tr)
	return frame(pt,
		U2(0, math.sqrt((ps2.X.Offset-ps1.X.Offset)^2+(ps2.Y.Offset-ps1.Y.Offset)^2), 0, wd),
		U2((ps2.X.Scale+ps1.X.Scale)/2, (ps2.X.Offset+ps1.X.Offset)/2, (ps2.Y.Scale+ps1.Y.Scale)/2, (ps2.Y.Offset+ps1.Y.Offset)/2),
		bC3,
		tr,
		math.deg(math.atan((ps2.Y.Offset-ps1.Y.Offset)/(ps2.X.Offset-ps1.X.Offset)))
	)
end

--Begin the things.

sci = math.sqrt(5)/2-0.5
phi = math.sqrt(5)/2+0.5

--[[playerGui = script.Parent
player = playerGui.Parent]]
player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")
playerGui:SetTopbarTransparency(0)
character = player.Character

for _, obj in pairs(playerGui:GetChildren()) do
	if obj.Name == "GUI" then
		obj:Destroy()
	end
end

gui = new'ScreenGui'{pt = playerGui, nm = "GUI"}

main = frame(gui, U2(1, 0, 1, 0), U2(), C3())

menuFrame = frame(main, U2(0, 300, 0, 500), U2(0.5, -150, 0.5, -250), C3(1, 1, 1))

menuButtons = {"Play", "Help", "Options", "Credits", "Exit"}

for m, word in pairs(menuButtons) do
	local menuButton = tButton(menuFrame, word:upper(), 60, C3(), U2(0, 300, 0, 100), U2(0, 0, 0, m*100-100))
end












