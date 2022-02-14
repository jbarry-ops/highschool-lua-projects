--[[

	A New Thing:
		Laser Tag? Yes. The guns have certain range indicators to let you know how far you can shoot. If you shoot too far, the beams will simply break apart and fly into harmless particles.

Personalization:
	
	Defense:
		stamina: health
		strength: resist
		resilience: healing
		agility: dodge chance
		
	Offense:
		armor piercing
		accuracy
		precision
		fire-rate (mods gun stats)
		reload time (mods gun stats)

]]

t = tick()
math.randomseed(t)
print(t)

MR = math.random

CN = CFrame.new
V2 = Vector2.new
V3 = Vector3.new
U2 = UDim2.new
BN = BrickColor.new
C3 = Color3.new

local CA = function(x, y, z, inRadians)
	if inRadians then
		return CFrame.Angles(x or 0, y or 0, z or 0)
	else
		return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
	end
end

for n, s in pairs({"Players", "Debris", "RunService", "Lighting"}) do
	getfenv(1)[s] = Game:GetService(s)
end

function truncateName(name)
	return name:sub(1, 1):lower()..name:sub(2):gsub(" ", "")
end

function setEnvironmentGlobalized(f, t)
	setfenv(f, setmetatable(t or getfenv(f), {__index = function(t, i) return getfenv(1)[i] end}))
	return f
end

--[[

-------------------
set demonstrations:
-------------------


set(instance){prop = value} --set the properties of instance
set(tableOfInstances){prop = value} --set the properties for multiple instances

set(instance){..., descendant} --give descendants to instance
set(instance){..., "environmentNameForThis"} --give variable names to instance

set(instance){..., {Event = function}} --sets instance.Event:connect(function)*
set(instance){..., function() this:Destroy() end} --execute functions on instance*
set(instance){..., {table, function}} --executes function(i, v) on each pair of the table*
set(instance){..., {{1, 10, function}, {-1, 1, 2, function2}}} --executes function(i) on each number 1-10
set(instance){..., {{1, 10, 2, function}}} --executes function(i) on each number; 1-10, step 2*

*For anything using functions, it may be important to note that the variable "this" is equal to the object being set

]]

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

function destroy(...)
	set({...}){function() this:Destroy() end}
end

function round(n)
	local int, f = math.modf(n)
	if f > 0.5 then
		return math.ceil(n)
	else
		return math.floor(n)
	end
end

function clone(object)
	local clonedObject
	if type(object) == "table" then
		local clonedTable = {}
		for i, v in pairs(object) do
			clonedTable[i] = v
		end
		clonedObject = clonedTable
	else
		clonedObject = object:Clone()
	end
	return clonedObject
end

function recurse(object, f)
	local descendants = {}
	local function addDescendants(obj)
		for _, descendant in pairs(obj:GetChildren()) do
			table.insert(descendants, descendant)
			if f then
				f(descendant, _)
			end
			addDescendants(descendant)
		end
	end
	addDescendants(object)
	return descendants
end

function castRay(origin, direction, ignoreList)
	local ray = Ray.new(origin, direction)
	local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
	return part, position
end

function weld(p0, p1, c0, c1)
	return new'Weld'{pt = p0, p0 = p0, p1 = p1, C0 = c0, C1 = c1}
end

function part(pt, sz, cf, bc, mt, tr)
	return new'Part'{pt = pt, sz = sz, cf = cf, bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
end

function wedge(pt, sz, cf, bc, mt, tr)
	return new'WedgePart'{pt = pt, sz = sz or V3(1, 1, 1), cf = cf or CN(), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
end

function cornerPart(pt, sz, cf, bc, mt, tr)
	return new'CornerWedgePart'{pt = pt, sz = sz or V3(1, 1, 1), cf = cf or CN(), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
end

function pyramid(pt, cf, sz, bc, mt, tr)
	local theThing = new'Model'{pt = pt, nm = "Pyramid"}
	for p = 1, 4 do
		local pyrpart = cornerPart(theThing, V3(sz.X/2, sz.Y, sz.X/2), cf*CA(0, 90*p, 0)*CN(-sz.X/4, sz.Y/2, sz.X/4), bc, mt, tr)
	end
	return theThing
end

function mesh(pt, sc, mst)
	return new'SpecialMesh'{pt = pt, mst = mst or "Sphere", sc = sc or V3(1, 1, 1)}
end

function cylinder(pt, sc)
	return new'CylinderMesh'{pt = pt, sc = sc or V3(1, 1, 1)}
end

function getTriangleValues(points, width)
	local width = width or 0
	local G, V = 0
	for S = 1, 3 do
		local L = (points[1+(S+1)%3]-points[1+S%3]).magnitude
		G, V = L > G and L or G, L > G and {points[1+(S-1)%3], points[1+(S)%3], points[1+(S+1)%3]} or V
	end
	local D = V[2]+(V[3]-V[2]).unit*((V[3]-V[2]).unit:Dot(V[1]-V[2]))
	local C, B = (D-V[1]).unit, (V[2]-V[3]).unit
	local A = B:Cross(C)
	S1 = V3(width, (V[2]-D).magnitude, (V[1]-D).magnitude)/1--0.2
	S2 = V3(width, (V[3]-D).magnitude, (V[1]-D).magnitude)/1--0.2
	C1 = CN(0,0,0,A.X,B.X,C.X,A.Y,B.Y,C.Y,A.Z,B.Z,C.Z)+(V[1]+V[2])/2
	C2 = CN(0,0,0,-A.X,-B.X,C.X,-A.Y,-B.Y,C.Y,-A.Z,-B.Z,C.Z)+(V[1]+V[3])/2
	return C1, C2, S1, S2
end

function triangleConnect(pt, points, width, BrickColor, Material, Transparency, noThickness)
	local C1, C2, S1, S2 = getTriangleValues(points, width)
	local TM = new'Model'{pt = pt, nm = "Triangle Fill"}
	local T1 = wedge(TM, S1, C1, BrickColor, Material, Transparency)
	local m1 = mesh(T1, V3(1, 1, 1), "Wedge")
	local T2 = wedge(TM, S2, C2, BrickColor, Material, Transparency)
	local m2 = mesh(T2, V3(1, 1, 1), "Wedge")
	
	if noThickness then
		m1.Scale = V3(0, 1, 1)
		m2.Scale = V3(0, 1, 1)
	end
	return TM
end

function connect(pt, p1, p2, sz, bc, mt, orientedY)
	local dist = (p2-p1).magnitude
	if not orientedY then
		return part(pt, V3(sz.X, sz.Y, dist), CN(p1, p2)*CN(0, 0, -dist/2), bc, mt)
	else
		return part(pt, V3(sz.X, dist, sz.Y), CN(p1, p2)*CN(0, 0, -dist/2)*CA(90, 0, 0), bc, mt)
	end
end

function frame(pt, sz, ps, bgc, bgt)
	return new'Frame'{pt = pt, sz = sz, ps = ps, bgc = bgc, bgt = bgt}
end

function tLabel(pt, Text, FontSize, tC3, sz, ps)
	return new'TextLabel'{pt = pt, Text = Text, FontSize = FontSize, tC3 = tC3, sz = sz, ps = ps}
end

function tButton(pt, Text, FontSize, tC3, sz, ps)
	return new'TextButton'{pt = pt, Text = Text, FontSize = FontSize, tC3 = tC3, sz = sz, ps = ps}
end

function tCombo(pt, Text, FontSize, tC3, sz, ps, bgc, bgt)
	local newFrame = frame(pt, sz, ps, bgc, bgt)
	local newButton = tButton(newFrame, Text, FontSize, tC3)
	return newFrame, newButton
end

function arc(pt, cf, r, n, a, sz, bc, mt, tr, mod, overlapFix)
	local R = sz.X+r
	local c, i = 2*math.pi*(R), a/n --circumference, angleInterval
	local z = c/(360/a)/n --segment length
	local d = ((cf*CA(0, 0, 0)*CN(z/2, 0, r+sz.X)).p-(cf*CA(0, i, 0)*CN(-z/2, 0, r+sz.X)).p).magnitude
	
	z = z+d
	
	local theArc = new'Model'{pt = pt, nm = "This Arc(h), Though"}
	for s = -n/2, n/2 do
		if a == 360 and s == n/2 then return theArc end
		local cPart = part(theArc, V3(z, sz.Y, sz.X), cf*CA(0, i*s, 0)*CN(0, 0, r+sz.X/2), bc, mt, tr)
		if mod then
			cPart.CFrame = cPart.CFrame*mod
		end
		if overlapFix then
			cPart.CFrame = cPart.CFrame*CN(0, overlapFix*math.cos(math.rad(s*360/n+5)), 0)
		end
	end
	return theArc
end

function weaponsCrate(pt, cf)
	local theCrate = new'Model'{pt = pt, nm = "Weapons Crate"}
	local base = part(theCrate, V3(8, 0.4, 5), cf*CN(0, 0.2, 0), "Reddish brown", "Wood")
	for a = -1, 1, 2 do
		local side = part(theCrate, V3(0.4, 3, 5), cf*CN(a*4.2, 1.5, 0), "Reddish brown", "Wood")
		local side2 = part(theCrate, V3(8.8, 3, 0.4), cf*CN(0, 1.5, a*2.7), "Reddish brown", "Wood")
	end
	local top = part(theCrate, V3(8.8, 0.4, 5.8), cf*CN(4.7, 3.2, 0)*CA(0, 5, -45), "Reddish brown", "Wood")
end

function storeStand(pt, cf)
	local theStand = new'Model'{pt = pt, nm = "Store Stand"}
	local base = part(theStand, V3(10, 1, 6.2), cf*CN(0, 3, 0), "Reddish brown", "Wood")
end

player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")
mouse = player:GetMouse()

playerGui:SetTopbarTransparency(0)

character = player.Character

character.Humanoid.JumpPower = 140
character.Humanoid.WalkSpeed = 100

for i, v in pairs(character:GetChildren()) do
	if v:IsA("LocalScript") and v ~= script then
		v.Disabled = true
		v:Destroy()
	end
end

UIS = Game:GetService("UserInputService")

for _, gui in pairs(playerGui:GetChildren()) do
	if gui.Name == "Cheesecake" then
		gui:Destroy()
	end
end

--[[
	
	when the player opens the game, they will be presented with a menu of choices. These choices include... "Just Play", "Customize", and "Buy", "Quit", "Options".
	The customization is categorized into... "Cosmetics", "Mods", and "Equipment".
	The "buy" option brings up a menu with clear options of what to buy... "Equipment", "Mods", "Cosmetics". These individual things can also be linked in the customization screen to their respective buying places.
	the "Just Play" option will automatically send the player onto one of two teams, and let them choose (maybe) where they will be spawning, kinda like Battlefront?
	The customization screen will also have a part which displays the equipment which is currently "equipped" on the character.
	
	The gameplay itself will have to be both fast-paced, but also easy to ease into. 
	
]]


theTitle = "War Blox II"

GUI = new'ScreenGui'{pt = playerGui, nm = "Cheesecake"}

screenSize = GUI.AbsoluteSize

--Main Frame
mainFrame = frame(GUI, U2(1, 0, 1, 0), U2(), C3(0.4, 0.4, 0.4), 1)

--Title
for t = 1, 3 do
	tLabel(mainFrame, theTitle, "Size48", C3(1, 0.5, 0.25), U2(1, 0, 0, 100), U2(0, -t, 0, 50-t))
	tLabel(mainFrame, theTitle, "Size48", C3(0.25, 0.5, 1), U2(1, 0, 0, 100), U2(0, t, 0, 50-t))
end

mainTitle = tLabel(mainFrame, theTitle, "Size48", C3(1.25, 1, 1.25), U2(1, 0, 0, 100), U2(0, 0, 0, 50))
	tSize = mainTitle.TextBounds --the size of the title's text


Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)


offset = CN(0, 3, 0)

decorColor = "Bright yellow"
decorMaterial = "Foil"

domeColor = "Black"
domeMaterial = "Slate"


for _, obj in pairs(Workspace:GetChildren()) do
	if obj.Name == "War Blox Lobby" then
		obj:Destroy()
	end
end

lobby = new'Model'{pt = Workspace, nm = "War Blox Lobby"}

mainPlatform = part(lobby, V3(150, 1, 150), offset*CN(0, 0, 0), "Medium stone grey", "SmoothPlastic", 1)


floor = arc(lobby, offset*CA(0, 180, 0), 10, 12, 360, V2(40, 1), "Dark stone grey", "Concrete", 0, nil, 0.05)

underneathFloor = arc(lobby, offset*CN(0, -1, 0)*CA(0, 180, 0), 10, 12, 360, V2(40, 1), "Black", "Slate", 0, nil, 0.05)

secondCenter = offset*CN(0, 0, -139-30)

floor2 = arc(lobby, secondCenter, 0, 12, 360, V2(80, 1), "Dark stone grey", "Granite", 0, nil, 0.05)

floorConnection = part(lobby, V3(23, 1, 40), offset*CN(0, 0, -49.5-20), "Dark stone grey", "Concrete")

--walls
walls = arc(lobby, offset*CN(0, 15.5, 0), 49, 12, 360, V2(1, 30), "Dove blue", "Marble", 0.7)
walls:GetChildren()[1]:Destroy()

--supports
for c = -6, 5 do
	local support = part(lobby, V3(3, 32, 3), offset*CA(0, (c+0.5)*30, 0)*CN(0, 14.5, 51), domeColor, domeMaterial)
	--decor
	part(lobby, V3(2, 31, 3+0.4), support.CFrame, decorColor, decorMaterial)
	
	
	local supportBase = part(lobby, V3(5, 4, 5), support.CFrame*CN(0, -14, 0), decorColor, decorMaterial)
	
	local supportBaseDecor = part(lobby, V3(6, 3.5, 6), support.CFrame*CN(0, -14, 0), domeColor, domeMaterial)
end

--DOME
domeArches = {}

for c = -3, 2 do
	local arch = arc(lobby, offset*CA(0, (c+0.5)*30, 0)*CN(0, 42.25, 0)*CA(-90, 0, 0), 50, 7, 180, V2(2, 2), domeColor, domeMaterial)
	table.insert(domeArches, arch)
	--decor
	arc(lobby, offset*CA(0, (c+0.5)*30, 0)*CN(0, 42.25, 0)*CA(-90, 0, 0), 50-0.2, 7, 180, V2(2.4, 1), decorColor, decorMaterial)
end

for a, arch in pairs(domeArches) do
	recurse(arch, function(p, i)
		if domeArches[a+1] then
			local nextArch = domeArches[a+1]:GetChildren()
			triangleConnect(lobby, {
				(nextArch[i].CFrame*CN(-nextArch[i].Size.X/2, 0, 0)).p,
				(p.CFrame*CN(p.Size.X/2, 0, 0)).p,
				(p.CFrame*CN(-p.Size.X/2, 0, 0)).p
			}, 0, "Dove blue", "Marble", 0.7, true)
			triangleConnect(lobby, {
				(p.CFrame*CN(p.Size.X/2, 0, 0)).p,
				(nextArch[i].CFrame*CN(nextArch[i].Size.X/2, 0, 0)).p,
				(nextArch[i].CFrame*CN(-nextArch[i].Size.X/2, 0, 0)).p
			}, 0, "Dove blue", "Marble", 0.7, true)
		else
			local firstArch = domeArches[1]:GetChildren()
			local i = #firstArch-i+1
			triangleConnect(lobby, {
				(firstArch[i].CFrame*CN(-firstArch[i].Size.X/2, 0, 0)).p,
				(p.CFrame*CN(p.Size.X/2, 0, 0)).p,
				(p.CFrame*CN(-p.Size.X/2, 0, 0)).p
			}, 0, "Dove blue", "Marble", 0.7, true)
			triangleConnect(lobby, {
				(p.CFrame*CN(-p.Size.X/2, 0, 0)).p,
				(firstArch[i].CFrame*CN(firstArch[i].Size.X/2, 0, 0)).p,
				(firstArch[i].CFrame*CN(-firstArch[i].Size.X/2, 0, 0)).p
			}, 0, "Dove blue", "Marble", 0.7, true)
		end
	end)
end

local theThings = domeArches[1]:GetChildren()
for b = 2, #theThings-1 do
	local thisPos = theThings[b].CFrame*CN(theThings[b].Size.X/2, 0, 0)
	local dist = (thisPos.p-V3(offset.X, thisPos.Y, offset.Z)).magnitude
	local thisArc = arc(lobby, CN(offset.X, thisPos.Y, offset.Z), dist-b/3, 12, 360, V2(b/3, b/3), domeColor, domeMaterial)
	recurse(thisArc, function(p)
		p.CFrame = p.CFrame*CA(b*360/7*2, 0, 0)
	end)
	--decor
	arc(lobby, CN(offset.X, thisPos.Y, offset.Z), dist-b/3-0.2, 12, 360, V2(b/3+0.4, b/3/2), decorColor, decorMaterial)
end

--archway
arc(lobby, offset*CN(0, 15, -49.5-20)*CA(-90, 0, 0), 15, 7, 90, V2(3, 43), "Black", "Slate")

--above-door border
arc(lobby, offset*CN(0, 32, 0), 47.75, 12, 360, V2(3, 3), domeColor, domeMaterial)
--decor
arc(lobby, offset*CN(0, 32, 0), 47.75-0.2, 12, 360, V2(3.4, 2), decorColor, decorMaterial)

for a = -1, 1, 2 do
	--gap filler
	wedge(lobby, V3(3+40, 2.5, 4), offset*CN(a*10, 29.5, -49.5-20)*CA(180, a*90, 0), "Black", "Slate")
	--passage walls
	part(lobby, V3(3, 30, 43), offset*CN(a*13, 15.5, -49.5-20), "Black", "Slate")
end

--secondFloor = part(lobby, V3(50, 1, 100), offset*CN(0, 0, -49.5-50), "Medium stone grey", "Cobblestone")

weaponsCrate(lobby, offset*CN(0, 0.5, 40))

-----------------
--second room!!!!
-----------------
                    
--archways
for c = -6, 5 do
	local support = part(lobby, V3(4, 32, 4), secondCenter*CA(0, (c+0.5)*30, 0)*CN(0, 14.5, 49), "Black", "Slate")
	cylinder(support)
	
	local supportOrb = part(lobby, V3(3.9, 3.9, 3.9), support.CFrame*CN(0, 16, 0), "White", "Neon")
	mesh(supportOrb, V3(1, 1, 1), "Sphere")
	
	for b = 1, 19 do
		local supportDecor = part(lobby, V3(1, 4.2, 1), support.CFrame*CA(0, b*18, 0)*CN(0, -15.5+b*1.6, 0)*CA(90, 0, 0), "Dove blue", "Neon")
		cylinder(supportDecor)
	end
	
	arc(lobby, secondCenter*CA(0, (c+0.5)*30+15, 0)*CN(0, 17.9, 50)*CA(-90, 0, 0), 12.5, 12, 180, V2(2, 3), "Black", "Slate")
	
	for a = -1, 1, 2 do
		--gap filler
		wedge(lobby, V3(3, 4, 5), secondCenter*CA(0, (c+0.5)*30+15, 0)*CN(a*9.5, 28.5, 50)*CA(180, a*90, 0), "Black", "Slate")
	end
	
	
	
	
	
	local support = part(lobby, V3(6, 64, 6), secondCenter*CA(0, (c+0.5)*30, 0)*CN(0, 32, 75), "Black", "Slate")
	cylinder(support)
	local supportTop = part(lobby, V3(5, 1, 7, support.CFrame*CN(0, 32, -5), "Black", "Slate"))
end

--above-door border
arc(lobby, secondCenter*CN(0, 50, 0), 47.75, 12, 360, V2(3, 39), "Black", "Slate")
--decor
arc(lobby, secondCenter*CN(0, 32, 0), 47.5, 12, 360, V2(3, 2), "Bright yellow", "Foil")
