--[[

Survival Time (game concept):
	This is a cooperative build-to-survive style game.
	

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

function truss(pt, sz, cf, bc, mt, tr)
	return new'part'{pt = pt, sz = sz, cf = cf, bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
end

function setAllSurfaces(obj, surfaceType)
	obj.TopSurface = surfaceType
	obj.BottomSurface = surfaceType
	obj.RightSurface = surfaceType
	obj.LeftSurface = surfaceType
	obj.FrontSurface = surfaceType
	obj.BackSurface = surfaceType
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

function PalmTree(pt, CFrame, Segments, Modifier, StartSize, StartAngle, Leaves, LeafSegments, LeafSegmentModifier, LeafStartSize, LeafStartAngle, LeafStartVariation, ExtensionsPerLeaf, Colors, Materials)
	local Palm = new'Model'{pt = pt, Name = "Palm Tree"}
	local Start = part(Palm, StartSize, CFrame*CA(StartAngle[1], StartAngle[2], StartAngle[3])*CN(0, StartSize.Y/2, 0), Colors[1], Materials[1])
	cylinder(Start)
	local CurrentSegment = Start
	for P = 1, Segments-1 do
		local PalmSegment = part(Palm, StartSize+Modifier*P, CurrentSegment.CFrame*CN(0, CurrentSegment.Size.Y/2, 0)*CA(StartAngle[1]/P+math.random(-2, 2), StartAngle[2]/P+math.random(-2, 2), StartAngle[3]/P+math.random(-2, 2))*CN(0, (StartSize+Modifier*P).Y/2-(StartSize+Modifier*P).X/4, 0), Colors[1], Materials[1])
		cylinder(PalmSegment)
		CurrentSegment = PalmSegment
		if P == Segments-1 then
			--Top
			for L = 1, Leaves do
				local LeafStart
				if L%2 == 0 then
					LeafStart = part(Palm, LeafStartSize, PalmSegment.CFrame*CA(0, L*360/Leaves, 0)*CN(0, math.random(-PalmSegment.Size.Y/4*100, PalmSegment.Size.Y/4*100)/100, PalmSegment.Size.Z/2-LeafStartSize.Z/2)*CA(math.random(0, LeafStartVariation[1]), math.random(-LeafStartVariation[2], LeafStartVariation[2]), math.random(-LeafStartVariation[3], LeafStartVariation[3]))*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, LeafStartSize.Y/2, 0), Colors[2], Materials[2])
				else
					LeafStart = part(Palm, LeafStartSize, PalmSegment.CFrame*CA(0, L*360/Leaves, 0)*CN(0, math.random(PalmSegment.Size.Y/4*100, PalmSegment.Size.Y/2*100)/100, PalmSegment.Size.Z/2-LeafStartSize.Z/2)*CA(math.random(0, LeafStartVariation[1]), math.random(-LeafStartVariation[2], LeafStartVariation[2]), math.random(-LeafStartVariation[3], LeafStartVariation[3]))*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, LeafStartSize.Y/2, 0), Colors[2], Materials[2])
				end
				if math.random(0, 1) == 1 then
					local Coconut = part(Palm, V3(2, 2, 2), LeafStart.CFrame*CN(0, 0, LeafStartSize.Z/2+0.5), "Reddish brown", "Slate")
					mesh(Coconut, V3(1, 1, 1), "Sphere")
				end
				local CurrentSegment = LeafStart
				local LeafStartAngle = {math.random(5*5, 8*5)/5, math.random(-1*10, 1*10)/10, math.random(-1.5*10, 1.5*10)/10}
				for S = 1, LeafSegments-1 do
					local LeafSegment = part(Palm, LeafStartSize+LeafSegmentModifier*S, CurrentSegment.CFrame*CN(0, CurrentSegment.Size.Y/2, 0)*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, (LeafStartSize+LeafSegmentModifier*S).Y/2-(LeafStartSize+LeafSegmentModifier*S).X/4, 0), Colors[2], Materials[2])
					CurrentSegment = LeafSegment
					LeafSegment.CanCollide = false
					for E = 1, ExtensionsPerLeaf do
						local LeafExtension = part(Palm, V3(0.2, 0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E), 0.2), LeafSegment.CFrame*CN(0, -LeafSegment.Size.Y/2+LeafSegment.Size.Y/ExtensionsPerLeaf*E, 0)*CA(0, 0, 90-((S-1)*ExtensionsPerLeaf+E)*(90/(LeafSegments-1)/ExtensionsPerLeaf))*CA(LeafStartAngle[1]/ExtensionsPerLeaf*E, LeafStartAngle[2]/ExtensionsPerLeaf*E, LeafStartAngle[3]/ExtensionsPerLeaf*E)*CA(-7, 0, 0)*CN(0, (0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E))/2, 0), Colors[3], Materials[3])
						local LeafExtension2 = part(Palm, V3(0.2, 0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E), 0.2), LeafSegment.CFrame*CN(0, -LeafSegment.Size.Y/2+LeafSegment.Size.Y/ExtensionsPerLeaf*E, 0)*CA(0, 0, -90+((S-1)*ExtensionsPerLeaf+E)*(90/(LeafSegments-1)/ExtensionsPerLeaf))*CA(LeafStartAngle[1]/ExtensionsPerLeaf*E, LeafStartAngle[2]/ExtensionsPerLeaf*E, LeafStartAngle[3]/ExtensionsPerLeaf*E)*CA(-7, 0, 0)*CN(0, (0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E))/2, 0), Colors[3], Materials[3])
						LeafExtension.CanCollide = false
						LeafExtension2.CanCollide = false
					end
				end
			end
		end
	end
	return Palm
end

function storeStand(pt, cf)
	local theStand = new'Model'{pt = pt, nm = "Store Stand"}
	local base = part(theStand, V3(10, 1, 6.2), cf*CN(0, 3, 0), "Reddish brown", "Wood")
end

for _, obj in pairs(Workspace:GetChildren()) do
	if obj.Name == "Survival Time Stuff" then
		obj:Destroy()
	end
end

offset = CN(0, 2, 0)

map = new'Model'{pt = Workspace, nm = "Survival Time Stuff"}
base = part(map, V3(300, 1, 485.41), offset, "Brown", "Slate")

UIS = Game:GetService("UserInputService")

player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")
mouse = player:GetMouse()

playerGui:SetTopbarTransparency(0)

character = player.Character


for i, v in pairs(character:GetChildren()) do
	if v:IsA("LocalScript") and v ~= script then
		v.Disabled = true
		v:Destroy()
	end
end

for _, gui in pairs(playerGui:GetChildren()) do
	if gui.Name == "Cheesecake" then
		gui:Destroy()
	end
end

GUI = new'ScreenGui'{pt = playerGui, nm = "Cheesecake"}
screenSize = GUI.AbsoluteSize

--Main Frame
mainFrame = frame(GUI, U2(1, 0, 1, 0), U2(), C3(0.4, 0.4, 0.4), 1)

buildFrame = frame(GUI, U2(0, 485, 0, 300), U2(1, -495, 1, -310), C3(1, 1, 1), 0)
buildFrame.BorderColor3 = C3(0.7, 0.7, 0.7)
buildFrame.BorderSizePixel = 10
buildStuff = tLabel(buildFrame, "Build stuff.", "Size18", C3(1, 1, 1), U2(1, 0, 0, 26), U2())

buildingItems = {
	{"block", part(nil, V3(5, 5, 5), CN(), "Medium stone grey")},
	{"tile", part(nil, V3(5, 1, 5), CN(), "Medium stone grey")},
	{"column", part(nil, V3(3, 10, 3), CN(), "Medium stone grey")},
	{"ramp", wedge(nil, V3(5, 5, 5), CN(), "Medium stone grey")},
	{"brick", part(nil, V3(2.5, 2, 2.5), CN(), "Medium stone grey")},
	{"glass pane", part(nil, V3(5, 1, 5), CN(), "Medium stone grey", "SmoothPlastic", 0.5)}
}

material = "Metal"
transparency = 0

for i, item in pairs(buildingItems) do
	tLabel(buildFrame, item[1], "Size18", C3(), U2(0, 200, 0, 30), U2(0, 0, 0, -30+i*30))
	local clonePart = item[2]:Clone()
	clonePart.CFrame = offset*CN(0, clonePart.Size.Y/2+0.5, i*5.5-20)
	clonePart.Parent = map
end


