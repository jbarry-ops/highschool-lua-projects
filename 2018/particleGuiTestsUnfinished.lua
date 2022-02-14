local U2, V2, V3, BN, C3, CN, CA = UDim2.new, Vector2.new, Vector3.new, BrickColor.new, Color3.new, CFrame.new, CFrame.Angles
local random, deg, rad, atan, sqrt, sin, cos, tan, pi, ceil, floor = math.random, math.deg, math.rad, math.atan, math.sqrt, math.sin, math.cos, math.tan, math.pi, math.ceil, math.floor

local new = Instance.new
local frame = new'Frame' frame.BorderSizePixel = 0
local label = new'TextLabel' label.BorderSizePixel = 0
local image = new'ImageLabel' image.BackgroundTransparency = 1
local tButton = new'TextButton' tButton.BorderSizePixel = 0

function outline(fr, bsp, c3, mod, tr)
	local bsp = bsp
	local mod = mod
	local a = mod*2+1
	local b = -bsp/2
	local c = a*b
	local d = mod*bsp
	local tp = frame:Clone()
		tp.Size = U2(1, a*bsp, 0, bsp)
		tp.Position = U2(0, c, 0, b-d)
		tp.BackgroundColor3 = c3
		tp.BackgroundTransparency = tr
	local bt = tp:Clone()
		bt.Position = U2(0, c, 1, b+d)
	local rt = bt:Clone()
		rt.Size = U2(0, bsp, 1, a*bsp)
		rt.Position = U2(1, b+d, 0, c)
	local lf = rt:Clone()
		lf.Position = U2(0, b-d, 0, c)
	tp.Parent = fr
	bt.Parent = fr
	rt.Parent = fr
	lf.Parent = fr
end
function corner(fr, sz, rt, c3, bsp, bC3)
	local a = -sz/2
	local tplf = frame:Clone()
		tplf.Size = U2(0, sz, 0, sz)
		tplf.Position = U2(0, a, 0, a)
		tplf.Rotation = rt
		tplf.BackgroundColor3 = bC3
		tplf.BorderSizePixel = bsp
		tplf.BorderColor3 = bC3
	local tprt = tplf:Clone()
		tprt.Position = U2(1, a, 0, a)
	local btlf = tprt:Clone()
		btlf.Position = U2(0, a, 1, a)
	local btrt = btlf:Clone()
		btrt.Position = U2(1, a, 1, a)
	tplf.Parent = fr
	tprt.Parent = fr
	btlf.Parent = fr
	btrt.Parent = fr
end
function connect(pt, ps1, ps2, wd, bC3, tr, zi)
	local x1 = ps1.X.Offset
	local x2 = ps2.X.Offset
	local y1 = ps1.Y.Offset
	local y2 = ps2.Y.Offset
	local xd = x2-x1
	local yd = y2-y1
	local line = frame:Clone()
		line.Size = U2(0, sqrt(xd^2+yd^2), 0, wd)
		line.Position = U2(0, (x2+x1)/2, 0, (y2+y1)/2)
		line.AnchorPoint = V2(0.5, 0.5)
		line.Rotation = deg(atan(yd/xd))
		line.BackgroundColor3 = bC3
		line.BackgroundTransparency = tr
	line.Parent = pt
	return line
end
function makeConnect(gui, ps1, ps2, wd)
	local x1 = ps1.X.Offset
	local x2 = ps2.X.Offset
	local y1 = ps1.Y.Offset
	local y2 = ps2.Y.Offset
	local xd = x2-x1
	local yd = y2-y1
	gui.Size = U2(0, sqrt(xd^2+yd^2), 0, wd)
	gui.Position = U2(0, (x2+x1)/2, 0, (y2+y1)/2)
	gui.Rotation = deg(atan(yd/xd))
end

local Players = Game:getService("Players")
local Debris = Game:getService("Debris")
local RunService = Game:getService("RunService")
local UIS = Game:getService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:waitForChild("PlayerGui")

playerGui:SetTopbarTransparency(0)

for g, gui in pairs(playerGui:getChildren()) do
	if gui.Name == "Space Paint Laser" then
		gui:Destroy()
	end
end

local gui = new'ScreenGui'
	gui.Name = "Space Paint Laser"
	gui.Parent = playerGui

local main = frame:Clone()
	main.Size = U2(1, 0, 1, 0)
	main.Position = U2(0, 0, 0, 0)
	main.BackgroundColor3 = C3(1/6, 1/6, 1/6)
	main.Parent = gui

local menu = frame:Clone()
	menu.Size = U2(1/3, 0, 1, 0)
	menu.Position = U2(1/3, 0, 0, 0)
	menu.BackgroundColor3 = C3(1/3, 1/3, 1/3)
	menu.Parent = main

local lines = {}

local menuX, menuY = menu.AbsoluteSize.X, menu.AbsoluteSize.Y

--[[for s = 0, 1 do
	for d = 0, 6 do
		local decor2 = frame:Clone()
		decor2.Size = U2(0, 20, 1-d/6, 10)
		decor2.Position = U2(-1/6+s*(4/3), -s*20-d*50+s*d*100, d/6, -10)
		decor2.BackgroundColor3 = C3(1/9, 1/9, 1/9)
		decor2.Parent = menu
		local decor3 = decor2:Clone()
		decor3.Size = U2(1/6, 10+d*50, 0, 20)
		decor3.Position = decor2.Position+U2(-1/6*s, 20-(30+d*50)*s, 0, 0)
		decor3.Parent = menu
		local pa = decor3.AbsolutePosition-menu.AbsolutePosition
		local p1 = U2(0, pa.X, 0, pa.Y)
		local decorA = decor3:Clone()
		decorA.Size = U2(0, 30, 0, 30)
		decorA.Position = p1
		decorA.BackgroundColor3 = C3(1, 0, 0)
		decorA.Parent = menu
		local dist = 600-d*58
		local line = connect(menu, p1, p1+U2(0, -dist+s*dist*2, 0, dist), 20, C3(1/9, 1/9, 1/9)) line.ZIndex = 1
		local lineB = connect(menu, p1, p1+U2(0, -dist+s*dist*2, 0, dist), 10, C3(1/6, 1/6, 1/6)) lineB.ZIndex = 1
		local thisColor = C3(6/6, 2/6, 2/6)
		if d == 4 then thisColor = C3(2/6, 4/6, 2/6) elseif d == 6 then thisColor = C3(2/6, 2/6, 4/6) end
		if d%2 == 0 then
			local line2 = connect(menu, p1, p1+U2(0, -dist+s*dist*2, 0, -dist), 20, C3(1/6, 1/6, 1/6), 0)
			local line2B = connect(menu, p1, p1+U2(0, -dist+s*dist*2, 0, -dist), 10, thisColor, 0)
			table.insert(lines, {line2, line2B, p1})
			line2.ZIndex = 2
			line2B.ZIndex = 2
		end
		local decor4 = decor3:Clone()
		decor4.Size = U2(0, 30, 0, 30)
		decor4.Position = decor2.Position+U2(0, 10, 0, 10)
		decor4.BackgroundColor3 = C3(1/6, 1/6, 1/6)
		decor4.AnchorPoint = V2(0.5, 0.5)
		decor4.Rotation = 45
		decor4.Parent = menu
		local decor5 = decor4:Clone()
		decor5.Size = U2(0, 20, 0, 20)
		decor5.BackgroundColor3 = C3(1/9, 1/9, 1/9)
		decor5.Parent = menu
	end
end

for i = 0, 6 do
	for d = 0, 2 do
		local decor = frame:Clone()
		decor.Size = U2(0, 30, 1-d/6, 0)
		decor.Position = U2(i/6, 30-i/6*90, d/12, 0)
		decor.BackgroundColor3 = C3(1/9, 1/9, 1/9)
		decor.Parent = menu
		local val = pi*2/6*i+d*pi*2/6
		local cos1 = cos(val)*0.5
		local sin1 = sin(val)*0.5
		corner(decor, 16, 45, C3(0.8+sin1, 0.8-cos1, 0.8-sin1), 3, C3(0.5+sin1, 0.5-cos1, 0.5-sin1))
	end
end
	]]
local goFrame = frame:Clone()
	goFrame.Size = U2(1, 0, 1/6, 0)
	goFrame.Position = U2(0, 0, 2/6, 0)
	goFrame.BackgroundColor3 = C3(6/6, 2/6, 2/6)
	goFrame.Parent = menu
	
local stuffFrame = goFrame:Clone()
	stuffFrame.Position = U2(0, 0, 3/6, 0)
	stuffFrame.BackgroundColor3 = C3(2/6, 4/6, 2/6)
	stuffFrame.Parent = menu

local helpFrame = stuffFrame:Clone()
	helpFrame.Position = U2(0, 0, 4/6, 0)
	helpFrame.BackgroundColor3 = C3(2/6, 2/6, 4/6)
	helpFrame.Parent = menu

local titleFrame = helpFrame:Clone()
	titleFrame.Size = U2(4/3, 80, 1/6, 0)
	titleFrame.BackgroundColor3 = C3(1/9, 1/9, 1/9)
	titleFrame.ClipsDescendants = true
	titleFrame.Position = U2(-1/6, -40, 1/6, 0)
	titleFrame.Parent = menu
	titleFrame.BackgroundTransparency = 0

local tpX, tpY = titleFrame.AbsolutePosition.X, titleFrame.AbsolutePosition.Y
local tsX, tsY = titleFrame.AbsoluteSize.X, titleFrame.AbsoluteSize.Y
	
local t = 0
local lastMousePos = UIS:GetMouseLocation()
local mouseDiff = V2(0, 0)

local coolFX = {}
local particles = false

local fxObj = image:Clone()
	fxObj.Size = U2(0, 60, 0, 60)
	--fxObj.BackgroundColor3 = C3(1, 0, 0)
	fxObj.ZIndex = 2
	fxObj.Image = "rbxassetid://242837894"
	--242837894 = snowflake
	--243953162 = bubble
	--574660495 = light blue plasma
	--244982565 = leaf
	--245630713 = white hex
	--582351464 = green hex
	--497822844 = neon blue circle :)
	fxObj.AnchorPoint = V2(0.5, 0.5)
	
local function doFX(p, v, n)
	if #coolFX > 300 or n > 10 then return end --limit. Also, you may add if n > # for a limit on recursions
	local fx = fxObj:Clone()
		--fx.Rotation = random(-180, 180)
		v = v*(1-n*0.05)
		local r = 20+n*10
		fx.Size = U2(0, r, 0, r)
		fx.Position = U2(0, p.X, 0, p.Y)
		fx.ImageTransparency = 0.1*n-0.1
		fx.Parent = titleFrame
	table.insert(coolFX, {fx, p, v, n})
end

titleFrame.MouseEnter:connect(function(x, y)
	particles = true
	if mouseDiff.Magnitude > 0 then
			doFX(V2(x-tpX, y-34-tpY), mouseDiff*50, 1)
	end
end)
titleFrame.MouseLeave:connect(function()
	particles = false
end)

--[[function doGame()
	print("Complete.")

	for i, v in pairs(menu:getChildren()) do
		v:TweenSizeAndPosition(v.Size, v.Position + U2(0, 0, 1.5, 0), "In", "Elastic", 1, false, nil)
	end
	
	
	
end

goButton.MouseButton1Down:connect(doGame)]]

RunService.Stepped:connect(function()
	local mousePos = UIS:GetMouseLocation()
	mouseDiff = (mousePos-lastMousePos).Unit
	if particles then
	for j, k in pairs(coolFX) do
		local this = k[1]
		local p = k[2]
		local v = k[3]
		local vx = v.X
		local vy = v.Y
		local n = k[4]
		local nP = p+v
		local dP = nP-V2(tsX/2, tsY/2)
			local aX, aY = math.abs(dP.X), math.abs(dP.Y)
		if aX > tsX/2 or aY > tsY/2 then --if the thing is out of bounds
			table.remove(coolFX, j)
			this:Destroy()
			local o = random(1, 20)
			local l = o*2
			for d = 0, 1 do
				local f = d*l-o
				local newV
				if math.abs(aY) > tsY/2 then
					newV = V2(f, -vy).Unit*50
				else
					newV = V2(-vx, f).Unit*50
				end
				doFX(p, newV, n+1)
			end
		else
			k[2] = nP
			this.Position = U2(0, nP.X, 0, nP.Y)
		end
	end
	else
		for j, k in pairs(coolFX) do
			local this = k[1]
			table.remove(coolFX, j)
			this:Destroy()
		end
	end
	lastMousePos = mousePos
	t = t+1
end)

gui.AncestryChanged:connect(function()
	delay(wait(), function()
		script.Disabled = true
		script:Destroy()
	end)
end)