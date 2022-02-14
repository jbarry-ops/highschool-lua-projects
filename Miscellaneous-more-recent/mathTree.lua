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

for n, s in pairs({"Players", "Debris", "RunService", "Lighting", "InsertService"}) do
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
				if properties.cf then instance.CFrame = properties.cf end
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
		set(newInstance){sz = V3(1, 1, 1), mt = "SmoothPlastic", ts = 0, bs = 0, Locked = false, an = true}
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
	return new'Motor6D'{pt = p0, p0 = p0, p1 = p1, C0 = c0, C1 = c1}
end
function part(pt, sz, cf, bc, mt, tr, sh)
	local nP = new'Part'{pt = pt, sz = sz, cf = cf, bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
	if sh then
		nP.Shape = sh
		nP.CFrame = cf
	end
	nP.TopSurface = 10
	nP.BottomSurface = 10
	nP.RightSurface = 10
	nP.LeftSurface = 10
	nP.FrontSurface = 10
	nP.BackSurface = 10
	return nP
end
function cylinderPart(pt, sz, cf, bc, mt, tr, sh)
	local nP = new'Part'{pt = pt, sz = V3(sz.Y, sz.X, sz.Z), Shape = "Cylinder", cf = cf*CA(0, 0, 90), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
	nP.CFrame = cf*CA(0, 0, 90)
	nP.TopSurface = 10
	nP.BottomSurface = 10
	nP.RightSurface = 10
	nP.LeftSurface = 10
	nP.FrontSurface = 10
	nP.BackSurface = 10
	return nP
end
function wedge(pt, sz, cf, bc, mt, tr)
	local thisWedge = new'WedgePart'{pt = pt, sz = sz or V3(1, 1, 1), cf = cf or CN(), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
	thisWedge.TopSurface = 10
	thisWedge.BottomSurface = 10
	thisWedge.RightSurface = 10
	thisWedge.LeftSurface = 10
	thisWedge.FrontSurface = 10
	thisWedge.BackSurface = 10
	return thisWedge
end
function ball(pt, wd, cf, bc, mt, tr)
	local thisBall = new'Part'{pt = pt, Shape = "Ball", sz = V3(wd, wd, wd), cf = cf, bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
	thisBall.TopSurface = 10
	thisBall.BottomSurface = 10
	thisBall.RightSurface = 10
	thisBall.LeftSurface = 10
	thisBall.FrontSurface = 10
	thisBall.BackSurface = 10
	return thisBall
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
function mesh(pt, sc, mst, meshId, textureId)
	return new'SpecialMesh'{pt = pt, mst = mst or "Sphere", sc = sc or V3(1, 1, 1), MeshId = meshId or "", TextureId = textureId or ""}
end
function cylinder(pt, sc)
	return new'CylinderMesh'{pt = pt, sc = sc or V3(1, 1, 1)}
end

function unanchor(Model, Exceptions)
	local function A(Thing)
		local function B(Thing)
			for _, Obj in pairs(Thing:GetChildren()) do
				if Obj:IsA("BasePart") then
					local noAnchor = false
					if Exceptions then
						for i, v in pairs(Exceptions) do
							if Obj == v then
								noAnchor = true
							end
						end
					end
					Obj.Anchored = noAnchor
				end
				A(Obj)
			end
		end
		B(Thing)
	end
	A(Model)
end
function ColorModel(Model, Color)
	local function R(Thing)
		local function C(Thing)
			for _, Obj in pairs(Thing:GetChildren()) do
				if Obj:IsA("BasePart") then
					Obj.BrickColor = BN(Color)
				end
				R(Obj)
			end
		end
		C(Thing)
	end
	R(Model)
end
function convertToWelds(Model, AnchorPartCFrame, AnchorPart)
	local AnchorPart = AnchorPart
	if not AnchorPart then
		AnchorPart = part(Model, V3(), AnchorPartCFrame, "", "SmoothPlastic", 1)
		AnchorPart.Name = "Anchor"
		AnchorPart.CanCollide = false
	end
	local function A(Thing)
		local function B(Thing)
			for _, Obj in pairs(Thing:GetChildren()) do
				if Obj:IsA("BasePart") and Obj ~= AnchorPart then
					weld(Obj, AnchorPart, Obj.CFrame:toObjectSpace(AnchorPart.CFrame))
				end
				A(Obj)
			end
		end
		B(Thing)
	end
	A(Model)
	unanchor(Model, {AnchorPart})
	Model:MoveTo(AnchorPartCFrame.p)
	return AnchorPart
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
function cylinderConnect(pt, p1, p2, wd, bc, mt)
	local dist = (p2-p1).magnitude
	return cylinderPart(pt, V3(wd, dist, wd), CN(p1, p2)*CN(0, 0, -dist/2)*CA(90, 0, 0), bc, mt)
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
			cPart.CFrame = cPart.CFrame*CN(0, overlapFix*math.cos(math.rad(s*360/n+12)), 0)
		end
	end
	return theArc
end
function curve(pt, orientation, cf, r, n, a, sz, bc, mt, tr)
	local i = a/n --circumference, angleInterval
	
	local theCurve = new'Model'{pt = pt, nm = "Parts-curve"}
	
	if orientation == "X" then
		for s = -n/2, n/2 do
			if a == 360 and s == n/2 then return theCurve end
			local cPart = part(theCurve, sz, cf*CA(i*s, 0, 0)*CN(0, 0, r+sz.X/2), bc, mt, tr)
		end
	elseif orientation == "Y" then
		for s = -n/2, n/2 do
			if a == 360 and s == n/2 then return theCurve end
			local cPart = part(theCurve, sz, cf*CA(0, i*s, 0)*CN(r+sz.X/2, 0, 0), bc, mt, tr)
		end
	elseif orientation == "Z" then
		for s = -n/2, n/2 do
			if a == 360 and s == n/2 then return theCurve end
			local cPart = part(theCurve, sz, cf*CA(0, 0, i*s)*CN(0, r+sz.X/2, 0), bc, mt, tr)
		end
	end
	return theCurve
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


--[[Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)
Lighting.Ambient = Color3.new(1, 1, 1)

for _, thing in pairs(Lighting:GetChildren()) do
	if thing:IsA("Sky") then
		thing:Destroy()
	end
end

--White sky: rbxassetid://55054494

Sky = new'Sky'{
        pt = Lighting,
        CelestialBodiesShown = false,
        SkyboxBk = "rbxassetid://323494035",
        SkyboxDn = "rbxassetid://323494368",
        SkyboxFt = "rbxassetid://323494130",
        SkyboxLf = "rbxassetid://323494252",
        SkyboxRt = "rbxassetid://323494067",
        SkyboxUp = "rbxassetid://323493360"
}]]

toDestroy = {}

for _, obj in pairs(Workspace:GetChildren()) do
	if obj.Name == "Just a tree?!" then
		table.insert(toDestroy, obj)
	end
end

map = new'Model'{pt = Workspace, nm = "Just a tree?!"}

function waypoint(cf, text, tC3)
	local marker = part(map, V3(2, 2, 2), cf, "Black", "SmoothPlastic", 0.5)
	marker.CanCollide = false
	local markerGui = new'BillboardGui'{pt = marker, Adornee = marker, sz = U2(0, 200, 0, 20), AlwaysOnTop = true}
	local theLabel = tLabel(markerGui, text, 14, tC3)
	theLabel.TextSize = 14
end

--tunnel function!
--gots to make the tunnel's walls randomized and stuff!
function tunnel(start, finish, startSize, finishSize, bc, mt, tr, randomization, deadEnd) --randomization: {numberOfSplits, variationLimits, randomnessFactor}
	local thisSegment = new'Model'{pt = map, nm = "Tunnel Segment"}
	if not randomization then
		for s = -1, 1, 2 do
			--right/left
			triangleConnect(thisSegment, {(start*CN(s*startSize.X/2, -startSize.Y/2, 0)).p, (start*CN(s*startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, -finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
			triangleConnect(thisSegment, {(start*CN(s*startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, -finishSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
			--top/bottom
			triangleConnect(thisSegment, {(start*CN(s*-startSize.X/2, s*startSize.Y/2, 0)).p, (start*CN(s*startSize.X/2, s*startSize.Y/2, 0)).p, (finish*CN(s*-finishSize.X/2, s*finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
			triangleConnect(thisSegment, {(start*CN(s*startSize.X/2, s*startSize.Y/2, 0)).p, (finish*CN(s*-finishSize.X/2, s*finishSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, s*finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
		end
	else
		--starts
		local RT = CN((start*CN(startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(finishSize.X/2, finishSize.Y/2, 0)).p)
		local RB = CN((start*CN(startSize.X/2, -startSize.Y/2, 0)).p, (finish*CN(finishSize.X/2, -finishSize.Y/2, 0)).p)
		local LT = CN((start*CN(-startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(-finishSize.X/2, finishSize.Y/2, 0)).p)
		local LB = CN((start*CN(-startSize.X/2, -startSize.Y/2, 0)).p, (finish*CN(-finishSize.X/2, -finishSize.Y/2, 0)).p)
		--ends
		local fRT = finish*CN(finishSize.X/2, finishSize.Y/2, 0)
		local fRB = finish*CN(finishSize.X/2, -finishSize.Y/2, 0)
		local fLT = finish*CN(-finishSize.X/2, finishSize.Y/2, 0)
		local fLB = finish*CN(-finishSize.X/2, -finishSize.Y/2, 0)
		--distances
		local dRT = (fRT.p-RT.p).magnitude
		local dRB = (fRB.p-RB.p).magnitude
		local dLT = (fLT.p-LT.p).magnitude
		local dLB = (fLB.p-LB.p).magnitude
		
		local n = randomization[1] --number of randomized segments
		local limits = randomization[2] --randomness limits
		local r = randomization[3] --factor which sets how many in-between values there are.
		
		local lastRT = RT
		local lastRB = RB
		local lastLT = LT
		local lastLB = LB
		
		for d = 1, n do
			local thisRT = RT*CN(0, 0, -dRT/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
			local thisRB = RB*CN(0, 0, -dRB/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
			local thisLT = LT*CN(0, 0, -dLT/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
			local thisLB = LB*CN(0, 0, -dLB/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
			
			--right
			triangleConnect(thisSegment, {lastRT.p, lastRB.p, thisRT.p}, 0, bc, mt, tr, true)
			triangleConnect(thisSegment, {lastRB.p, thisRB.p, thisRT.p}, 0, bc, mt, tr, true)
			--left
			triangleConnect(thisSegment, {lastLT.p, lastLB.p, thisLT.p}, 0, bc, mt, tr, true)
			triangleConnect(thisSegment, {lastLB.p, thisLB.p, thisLT.p}, 0, bc, mt, tr, true)
			--top
			triangleConnect(thisSegment, {lastLT.p, lastRT.p, thisRT.p}, 0, bc, mt, tr, true)
			triangleConnect(thisSegment, {lastLT.p, thisLT.p, thisRT.p}, 0, bc, mt, tr, true)
			--bottom
			triangleConnect(thisSegment, {lastLB.p, lastRB.p, thisRB.p}, 0, bc, mt, tr, true)
			triangleConnect(thisSegment, {lastLB.p, thisLB.p, thisRB.p}, 0, bc, mt, tr, true)
			
			lastRT = thisRT
			lastRB = thisRB
			lastLT = thisLT
			lastLB = thisLB
		end
		
		--right
		triangleConnect(thisSegment, {lastRT.p, lastRB.p, fRT.p}, 0, bc, mt, tr, true)
		triangleConnect(thisSegment, {lastRB.p, fRB.p, fRT.p}, 0, bc, mt, tr, true)
		--left
		triangleConnect(thisSegment, {lastLT.p, lastLB.p, fLT.p}, 0, bc, mt, tr, true)
		triangleConnect(thisSegment, {lastLB.p, fLB.p, fLT.p}, 0, bc, mt, tr, true)
		--top
		triangleConnect(thisSegment, {lastLT.p, lastRT.p, fRT.p}, 0, bc, mt, tr, true)
		triangleConnect(thisSegment, {lastLT.p, fLT.p, fRT.p}, 0, bc, mt, tr, true)
		--bottom
		triangleConnect(thisSegment, {lastLB.p, lastRB.p, fRB.p}, 0, bc, mt, tr, true)
		triangleConnect(thisSegment, {lastLB.p, fLB.p, fRB.p}, 0, bc, mt, tr, true)
		
	end
	return thisSegment, CN(start.p, finish.p)
end

--will be using a transform methodology... transform stores the size, position, rotation of branches

--[[
	sine wave throughout the branches? --> maybe later.
]]

willowStringColors = {"Moss", "Artichoke", "Mint", "Medium green"}

function weepingWillow(pt, cf, trunkSize, n, scaling, curveResolution, spread, random1, random2, bumpiness, twist, barkColor, barkMaterial)
	local newTree = new'Model'{pt = pt, nm = "A good tree... hopefully."}
	local trunkTransform = {trunkSize, cf*CN(0, trunkSize.Y, 0)}
	tunnel(cf*CN(0, -trunkSize.Y, 0)*CA(90, 0, 0), cf*CA(90, 0, 0), V2(trunkSize.X, trunkSize.X), V2(trunkSize.X, trunkSize.X), barkColor, barkMaterial, 0, {0, bumpiness*V3(newWidth, newWidth, newHeight), 10})
	local structure = {
		[0] = {
			{trunkTransform}
		}
	}
	local lastTrunk = trunkTransform
	local curveAngle = CA(MR(-2, 2), MR(-2, 2), MR(-2, 2))
	for c = 1, curveResolution-1 do
		local newWidth = trunkSize.X-scaling[1]*trunkSize.X*(c+1)/curveResolution
		local newHeight = trunkSize.Y-scaling[2]*trunkSize.Y*(c+1)/curveResolution
		local newTransform = {
			V2(newWidth, newHeight),
			lastTrunk[2]*curveAngle*CN(0, newHeight, 0),
		}
		tunnel(lastTrunk[2]*CA(90, 0, 0), newTransform[2]*CA(90, 0, 0), V2(lastTrunk[1].X, lastTrunk[1].X), V2(newWidth, newWidth), barkColor, barkMaterial, 0, {0, bumpiness*V3(newWidth, newWidth, Height), 10})
		table.insert(structure[0][1], newTransform)
		lastTrunk = newTransform
	end
	
	for l = 1, n do
		local branches = {}
		for _, B in pairs(structure[l-1]) do
			
			local rand = math.random(1, 6) + math.random(1, 6)
			if rand == 2 or rand == 12 then
				splits = 1
			elseif rand == 3 or rand == 4 or rand == 11 or rand == 10 then
				splits = 3
			else
				splits = 2
			end
			
			local lastAngle = MR(-180, 180)
			
			for s = 1, splits do
				local chosen = B[#B]
				
				local newWidth = chosen[1].X-scaling[1]*chosen[1].X
				local newHeight = chosen[1].Y-scaling[2]*chosen[1].Y
				
				local newAngle = lastAngle+s*360/splits
				local startAngle = CA((math.cos(math.rad(newAngle))*spread+MR(0, random1)+MR(-random2, random2))/curveResolution, MR(-twist, twist)/curveResolution, (math.sin(math.rad(newAngle))*spread+MR(0, random1)+MR(-random2, random2))/curveResolution)
				
				local startTransform = {
					V2(newWidth, newHeight),
					chosen[2]*startAngle*CN(0, newHeight, 0)
				}
				
				
				tunnel(chosen[2]*CA(90, 0, 0), startTransform[2]*CA(90, 0, 0), V2(chosen[1].X, chosen[1].X), V2(newWidth, newWidth), barkColor, barkMaterial, 0, {0, bumpiness*V3(newWidth, newWidth, Height), 10})
				
				local branchCurve = {startTransform}
				local lastBranch = startTransform
				
				local curveAngle = CA((math.cos(math.rad(newAngle))*spread+MR(0, random1)+MR(-random2, random2))/curveResolution, MR(-twist, twist)/curveResolution, (math.sin(math.rad(newAngle))*spread+MR(0, random1)+MR(-random2, random2))/curveResolution)
				
				if l == n then
					barkColor = "Cork"
					newHeight = newHeight+2
					local test = CN(lastBranch[2].p, cf.p)
					local X, Y, Z = lastBranch[2]:toEulerAnglesXYZ()
					local test2 = CN(lastBranch[2].p)*CA(X/curveResolution, Y/curveResolution, Z/curveResolution)
					local test3 = lastBranch[2]:toObjectSpace(test2)
					
					curveAngle = test3
				end
				
				for c = 1, curveResolution-1 do
					local newWidth = newWidth-scaling[1]*newWidth*(c+1)/curveResolution
					local newHeight = newHeight-scaling[2]*newHeight*(c+1)/curveResolution
					
					local newTransform = {
						V2(newWidth, newHeight),
						lastBranch[2]*curveAngle*CN(0, newHeight, 0)
					}
					
					tunnel(lastBranch[2]*CA(90, 0, 0), newTransform[2]*CA(90, 0, 0), V2(lastBranch[1].X, lastBranch[1].X), V2(newWidth, newWidth), barkColor, barkMaterial, 0, {0, bumpiness*V3(newWidth, newWidth, newHeight), 10})
					
					table.insert(branchCurve, newTransform)
					lastBranch = newTransform
					
					if l > 1 --[[and c == curveResolution-1]] then
						--willow!
						--[[local weep = connect(newTree, newTransform[2].p, newTransform[2].p+Vector3.new(0, math.random(-31, -21), 0), V2(0.4, 0.4), willowStringColors[math.random(1, #willowStringColors)], "SmoothPlastic", true)
						weep.CanCollide = false
						weep.Transparency = 0.5
						local weep2 = connect(newTree, newTransform[2].p, newTransform[2].p+Vector3.new(0, math.random(-20, -14), 0), V2(0.2, 0.2), willowStringColors[math.random(1, #willowStringColors)], "SmoothPlastic", true)
						weep2.CanCollide = false
						weep2.Transparency = 0]]
					end
					
				end
				repeat wait() until Workspace:GetRealPhysicsFPS() > 40
				table.insert(branches, branchCurve)
			end
		end
		table.insert(structure, branches)
	end
	
	return newTree, structure
end

weepingWillow(
map, --parent
CN(0, -5, 0), --cframe
V2(3, 3), --trunk size
5, --levels of recursion
{1/5, 1/6}, --scaling
10, --curve resolution
40, --spread
30, --spread modifier/randomness 1
15, --randomness 2
V3(0, 0, 0.4), --bumpiness of bark
30, --twist
"Fawn brown", --bark color
"Slate" --bark material
)

local BarkColors = {"Fawn brown", "Bronze", "Cork", "Nougat", "Burlap", "Pastel brown"}
local LeafColors = {"Grime", "Artichoke", "Olivine", "Medium green", "Moss", "Shamrock"}
local BranchColors = {"Pine Cone", "Fawn brown", "Bronze", "Dark taupe", "Flint", "Brown", "Cork", "Nougat", "Cashmere", "Burlap", "Beige", "Pastel brown"}
local SizeX, SizeY = math.random(20, 50)/10, math.random(40, 100)/10

for p = 1, 1 do
	PalmTree(map, CN(MR(-108, 108), 0, MR(-108, 108)), 7, V3(-0.2, -0.1, -0.2), V3(SizeX, SizeY, SizeX), {math.random(-7, 7), math.random(-7, 7), math.random(-7, 7)}, 8, 21, V3(-0.05, 0, -0.05), V3(1, 1.5, 0.75), {16, -3, 2}, {16, 3, 3}, 6, {BarkColors[math.random(1, #BarkColors)], BranchColors[math.random(1, #BranchColors)], LeafColors[math.random(1, #LeafColors)]}, {"Slate", "Grass", "Slate"})
end

--destroy old map
for _, obj in pairs(toDestroy) do
	obj:Destroy()
end