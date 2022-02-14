--[[

War Blox: 2

Map Size:
	Small:
	Normal:
	Large:

Maps:
	Beach Map:
	Desert Town Map:
	Jungle Base Map:
	Island Airbase Map:
	Snow Tundra Map:
	
]]

Cone = "rbxassetid://1033714"
SwordMesh = "rbxasset://fonts/sword.mesh"
PaperStack = "rbxassetid://1285245"
PaperStackTex = "rbxassetid://1285242"
PlantInPot = "rbxassetid://25920418"
PlantInPotTex = "rbxassetid://25920406"
MugMesh = "rbxassetid://32023686"
CoffeeCup = "rbxassetid://15929962"
CompassMesh = "rbxassetid://14655367"
CompassTex = "rbxassetid://14655345"
TrashbagsMesh = "rbxassetid://92598630"
TrashbagsTex = "rbxassetid://92599263"
TrashbinMesh = "rbxassetid://93047436"
TrashbinTex = "rbxassetid://93047540"
DumpsterMesh = "rbxassetid://93054682"
DumpsterTex = "rbxassetid://93054830"

InsertService = Game:GetService("InsertService")

CN, V3, U2, BN, C3 = CFrame.new, Vector3.new, UDim2.new, BrickColor.new, Color3.new
function CA(X, Y, Z)
	return CFrame.Angles(math.rad(X), math.rad(Y or 0), math.rad(Z or 0))
end
function New(InstanceType)
	local NewInstance = Instance.new(InstanceType)
	if NewInstance:IsA("BasePart") then
		pcall(function() NewInstance.FormFactor = 3 end)
		NewInstance.Size = V3(1, 1, 1)
		NewInstance.Anchored = true
		NewInstance.Material = "SmoothPlastic"
		NewInstance.TopSurface = 0
		NewInstance.BottomSurface = 0
		NewInstance.Locked = true
	end
	return function(Properties)
		for Property, Value in pairs(Properties) do
			NewInstance[Property] = Value
		end
		if Properties.CFrame then NewInstance.CFrame = Properties.CFrame end
		return NewInstance
	end
end
function Motor(Parent, Part0, Part1, C0, C1, Name)
	return New'Motor6D'{Parent = Parent, Part0 = Part0, Part1 = Part1, C0 = C0 or CN(), C1 = C1 or CN(), Name = Name or "Motor"}
end
function Part(Parent, Size, CFrame, BrickColor, Material, Transparency, Shape)
	return New'Part'{Parent = Parent, Shape = Shape or "Block", Size = Size or V3(1, 1, 1), CFrame = CFrame or CN(), BrickColor = BN(BrickColor or ""), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
end
function Wedge(Parent, Size, CFrame, BrickColor, Material, Transparency)
	return New'WedgePart'{Parent = Parent, Size = Size or V3(1, 1, 1), CFrame = CFrame or CN(), BrickColor = BN(BrickColor or ""), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
end
function CornerPart(Parent, Size, CFrame, BrickColor, Material, Transparency)
	return New'CornerWedgePart'{Parent = Parent, Size = Size or V3(1, 1, 1), CFrame = CFrame or CN(), BrickColor = BN(BrickColor or ""), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
end
function Mesh(Parent, MeshType, Scale, MeshId, TextureId)
	return New'SpecialMesh'{Parent = Parent, MeshType = MeshType or "Wedge", Scale = Scale or V3(1, 1, 1), MeshId = MeshId or "", TextureId = TextureId or ""}
end
function Cylinder(Parent, Scale)
	return New'CylinderMesh'{Parent = Parent, Scale = Scale or V3(1, 1, 1)}
end
function Block(Parent, Scale)
	return New'BlockMesh'{Parent = Parent, Scale = Scale or V3(1, 1, 1)}
end
function Unanchor(Model)
	local function A(Thing)
		local function B(Thing)
			for _, Obj in pairs(Thing:GetChildren()) do
				if Obj:IsA("BasePart") then
					Obj.Anchored = false
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
function ConvertToWelds(Model, AnchorPartCFrame, AnchorPart)
	local AnchorPart = AnchorPart
	if not AnchorPart then
		AnchorPart = Part(Model, V3(), AnchorPartCFrame, "", "SmoothPlastic", 1)
		AnchorPart.Name = "Anchor"
		AnchorPart.CanCollide = false
	end
	local function A(Thing)
		local function B(Thing)
			for _, Obj in pairs(Thing:GetChildren()) do
				if Obj:IsA("BasePart") and Obj ~= AnchorPart then
					Motor(Obj, AnchorPart, Obj, AnchorPart.CFrame:toObjectSpace(Obj.CFrame))
				end
				A(Obj)
			end
		end
		B(Thing)
	end
	A(Model)
	Unanchor(Model)
	Model:MoveTo(AnchorPartCFrame.p)
	return AnchorPart
end
function GetTriangleValues(Points, Width)
	local Width = Width or 0
	for _, Point in pairs(Points) do
		if pcall(function() return Point.p end) then Points[_] = Point.p end
	end
	local G, V = 0
	for S = 1, 3 do
		local L = (Points[1+(S+1)%3]-Points[1+S%3]).magnitude
		G, V = L > G and L or G, L > G and {Points[1+(S-1)%3], Points[1+(S)%3], Points[1+(S+1)%3]} or V
	end
	local D = V[2]+(V[3]-V[2]).unit*((V[3]-V[2]).unit:Dot(V[1]-V[2]))
	local C, B = (D-V[1]).unit, (V[2]-V[3]).unit
	local A = B:Cross(C)
	S1 = V3(Width, (V[2]-D).magnitude, (V[1]-D).magnitude)/1--0.2
	S2 = V3(Width, (V[3]-D).magnitude, (V[1]-D).magnitude)/1--0.2
	C1 = CN(0,0,0,A.X,B.X,C.X,A.Y,B.Y,C.Y,A.Z,B.Z,C.Z)+(V[1]+V[2])/2
	C2 = CN(0,0,0,-A.X,-B.X,C.X,-A.Y,-B.Y,C.Y,-A.Z,-B.Z,C.Z)+(V[1]+V[3])/2
	return C1, C2, S1, S2
end
function TriangleConnect(Parent, Points, Width, BrickColor, Material, Transparency)
	local C1, C2, S1, S2 = GetTriangleValues(Points, Width)
	local TM = New'Model'{Parent = Parent, Name = "Triangle Fill"}
	local T1 = Wedge(TM, S1, C1, BrickColor, Material, Transparency)
	Mesh(T1)
	local T2 = Wedge(TM, S2, C2, BrickColor, Material, Transparency)
	Mesh(T2)
	return TM
end
function ConnectPoints(Parent, Point1, Point2, Width, Height, BrickColor, Material, Transparency)
	if pcall(function() return Point1.p end) then Point1, Point2 = Point1.p, Point2.p end
	local Length = (Point2-Point1).magnitude
	return Part(Parent, V3(Width, Length, Height), CN(Point1, Point2)*CA(-90, 0, 0)*CN(0, Length/2, 0), BrickColor, Material, Transparency)
end
function findIntersection(t1, t2, axis)
	if axis == "Z" then
		local t1Start, t1End = t1.CFrame*CN(0, 0, -t1.Size.Z/2), t1.CFrame*CN(0, 0, t1.Size.Z/2)
		local t2Start, t2End = t2.CFrame*CN(0, 0, -t2.Size.Z/2), t2.CFrame*CN(0, 0, t2.Size.Z/2)
		local t2sO = t1.CFrame:toObjectSpace(t2Start)
		local t2eO = t1.CFrame:toObjectSpace(t2End)
		local slope = (t2eO.X-t2sO.X)/(t2eO.Z-t2sO.Z)
		local b = t2sO.X-slope*t2sO.Z
		local intersect = -b/slope
		return t1.CFrame*CN(0, 0, intersect)
	elseif axis == "X" then
		local t1Start, t1End = t1.CFrame*CN(-t1.Size.Z/2, 0, 0), t1.CFrame*CN(t1.Size.Z/2, 0, 0)
		local t2Start, t2End = t2.CFrame*CN(-t2.Size.Z/2, 0, 0), t2.CFrame*CN(t2.Size.Z/2, 0, 0)
		local t2sO = t1.CFrame:toObjectSpace(t2Start)
		local t2eO = t1.CFrame:toObjectSpace(t2End)
		local slope = (t2eO.Z-t2sO.Z)/(t2eO.X-t2sO.X)
		local b = t2sO.Z-slope*t2sO.X
		local intersect = -b/slope
		return t1.CFrame*CN(intersect, 0, 0)
	end
end
function Resize(Part, Size, CFrame)
	local CF = Part.CFrame
	Part.Size = Size
	Part.CFrame = CFrame or CF
end
function Intersect(Part1, Part2, Axis)
	local intersection = findIntersection(Part1, Part2, Axis)
	if Axis == "Z" then
		local d1, d1b, d2, d2b = ((Part1.CFrame*CN(0, 0, Part1.Size.Z/2)).p-intersection.p).magnitude, ((Part1.CFrame*CN(0, 0, -Part1.Size.Z/2)).p-intersection.p).magnitude, ((Part2.CFrame*CN(0, 0, Part2.Size.Z/2)).p-intersection.p).magnitude, ((Part2.CFrame*CN(0, 0, -Part2.Size.Z/2)).p-intersection.p).magnitude
		--Resize
		if d1 < Part1.Size.Z and d1 > d1b then
			Resize(Part1, Part1.Size+V3(0, 0, -d1b), Part1.CFrame*CN(0, 0, d1b/2))
		elseif d1b < Part1.Size.Z and d1b > d1 then
			Resize(Part1, Part1.Size+V3(0, 0, -d1), Part1.CFrame*CN(0, 0, -d1/2))
		end
		if d2 < Part2.Size.Z and d2 > d2b then
			Resize(Part2, Part2.Size+V3(0, 0, -d2b), Part2.CFrame*CN(0, 0, d2b/2))
		elseif d2b < Part2.Size.Z and d2b > d2 then
			Resize(Part2, Part2.Size+V3(0, 0, -d2), Part2.CFrame*CN(0, 0, -d2/2))
		end
	elseif Axis == "X" then
		local d1, d1b, d2, d2b = ((Part1.CFrame*CN(Part1.Size.X/2, 0, 0)).p-intersection.p).magnitude, ((Part1.CFrame*CN(-Part1.Size.X/2, 0, 0)).p-intersection.p).magnitude, ((Part2.CFrame*CN(Part2.Size.X/2, 0, 0)).p-intersection.p).magnitude, ((Part2.CFrame*CN(-Part2.Size.X/2, 0, 0)).p-intersection.p).magnitude
		--Resize
		if d1 < Part1.Size.X and d1 > d1b then
			Resize(Part1, Part1.Size+V3(-d1b, 0, 0), Part1.CFrame*CN(d1b/2, 0, 0))
		elseif d1b < Part1.Size.X and d1b > d1 then
			Resize(Part1, Part1.Size+V3(-d1, 0, 0), Part1.CFrame*CN(-d1/2, 0, 0))
		end
		if d2 < Part2.Size.X and d2 > d2b then
			Resize(Part2, Part2.Size+V3(-d2b, 0, 0), Part2.CFrame*CN(d2b/2, 0, 0))
		elseif d2b < Part2.Size.X and d2b > d2 then
			Resize(Part2, Part2.Size+V3(-d2, 0, 0), Part2.CFrame*CN(-d2/2, 0, 0))
		end
	end
end
function Curve(Parent, Center, Radius, Angle, Segments, Width, Height, BrickColor, Material, Transparency)
	local Circumference, Interval = math.pi*(Radius*2+Width*2), Angle/Segments
	local Length = Circumference/(360/Angle)/Segments
	local Curve = New'Model'{Parent = Parent, Name = "Curve"}
	for S = -Segments/2, Segments/2 do
		if Angle == 360 and S == Segments/2 then return Curve end
		local CirclePart = Part(Curve, V3(Length, Height, Width), Center*CA(0, Interval*S, 0)*CN(0, 0, Radius+Width/2), BrickColor, Material, Transparency)
	end
	return Curve
end
function DecalFaces(PT, FCS, TX, TR)
	for _, Face in pairs(FCS) do
		New'Decal'{Parent = PT, Face = Face, Texture = TX, Transparency = TR or 0}
	end
end
function TextureFaces(Parent, Faces, Texture, TextureScaleX, TextureScaleY, Transparency)
	for _, Face in pairs(Faces) do
		New'Texture'{Parent = Parent, Face = Face, Texture = Texture, StudsPerTileU = TextureScaleX or 1, StudsPerTileV = TextureScaleY or 1, Transparency = Transparency or 0}
	end
end
function Crate(PT, SZ, CF, BN, MT, TB, RL, FB)
	local Thing = Part(PT, SZ, CF*CN(0, SZ.Y/2, 0), BN, MT)
	if TB then
		DecalFaces(Thing, {"Top", "Bottom"}, TB)
	end
	if RL then
		DecalFaces(Thing, {"Right", "Left"}, RL)
	end
	if FB then
		DecalFaces(Thing, {"Front", "Back"}, FB)
	end
	return Thing
end
function CrateTriangle(PT, SZ, CF, BN, MT, TB, RL, FB)
	local Triangle = New'Model'{Parent = PT, Name = "Crate Triangle"}
	local Av = (SZ.X+SZ.Z)/2
	if SZ.Z>SZ.X then
		Crate(Triangle, SZ, CF*CN(Av*0.625, 0, 0)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
		Crate(Triangle, SZ, CF*CN(-Av*0.625, 0, 0)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
		Crate(Triangle, SZ, CF*CN(0, SZ.Y, 0)*CA(0, 90+math.random(-15, 15), 0), BN, MT, TB, RL, FB)
	else
		Crate(Triangle, SZ, CF*CN(0, 0, Av*0.625)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
		Crate(Triangle, SZ, CF*CN(0, 0, -Av*0.625)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
		Crate(Triangle, SZ, CF*CN(0, SZ.Y, 0)*CA(0, 90+math.random(-15, 15), 0), BN, MT, TB, RL, FB)
	end
end
function CoverWall(Parent, CFrame, Size, Radius, Angle, Height, Width, BrickColor, Material)
	local WallOfCover = New'Model'{Parent = Parent, Name = "Cover Wall"}
	for H = 0, Height-1 do
		for C = -Width/2+H, Width/2-H do
			Part(WallOfCover, Size, CFrame*CA(0, C*Angle/Width, 0)*CN(0, H*Size.Y, Radius)*CA(math.random(-15, 15), math.random(-15, 15), 0), BrickColor, Material)
		end
	end
	return WallOfCover
end
function Pyramid(Parent, CFrame, Width, Height, BrickColor, Material, Transparency)
	local Thing = New'Model'{Parent = Parent, Name = "Pyramid"}
	for P = 1, 4 do
		local Pyrpart = CornerPart(Thing, V3(Width/2, Height, Width/2), CFrame*CA(0, 90*P, 0)*CN(-Width/4, Height/2, Width/4), BrickColor, Material)
	end
	return Thing
end
function Turret(Parent, CFrame, Angle, Angle2)
	local Turret = New'Model'{Parent = Parent, Name = "Anti-aircraft gun"}
	local TurretBase = Part(Turret, V3(30, 20, 30), CFrame*CN(0, 10, 0), "Dark stone grey", "Concrete")
	for S = 1, 4 do
		for T = 0, 6 do
			local TurretBaseD = Wedge(Turret, V3(2, 20, 7), TurretBase.CFrame*CA(0, S*90, 0)*CN(-12+T*4, 0, -18.5), "Dark stone grey", "Concrete")
		end
	end
	local TurretBase2 = Part(Turret, V3(25, 1, 25), TurretBase.CFrame*CN(0, 10.5, 0), "Dark stone grey", "Concrete")
	local TurretBase2A = Part(Turret, V3(22.5, 2, 22.5), TurretBase2.CFrame*CN(0, 1.5, 0), "Dark stone grey", "Concrete")
	Cylinder(TurretBase2A)
	local TurretBase2B = Part(Turret, V3(20, 2, 20), TurretBase2A.CFrame*CN(0, 2, 0), "Dark stone grey", "Concrete")
	Cylinder(TurretBase2B)
	
	local GunBase = Part(Turret, V3(22, 1, 28), TurretBase2B.CFrame*CN(0, 1.5, 0)*CA(0, Angle, 0), "Dark stone grey", "Concrete")
	local GunMiddle = Part(Turret, V3(15, 8, 24), GunBase.CFrame*CN(0, 4.5, 2), "Dark stone grey", "Concrete")
	
	local GunRight = Part(Turret, V3(3.5, 8, 26), GunBase.CFrame*CN(9.25, 4.5, 1), "Dark stone grey", "Concrete")
	local GunRightA = Wedge(Turret, V3(3.5, 8, 2), GunRight.CFrame*CN(0, 0, -14), "Dark stone grey", "Concrete")
	local GunLeft = Part(Turret, V3(3.5, 8, 26), GunBase.CFrame*CN(-9.25, 4.5, 1), "Dark stone grey", "Concrete")
	local GunLeftA = Wedge(Turret, V3(3.5, 8, 2), GunLeft.CFrame*CN(0, 0, -14), "Dark stone grey", "Concrete")
	local GunBetween = Part(Turret, V3(3, 8, 2), GunMiddle.CFrame*CN(0, 0, -13), "Dark stone grey", "Concrete")
	local GunBetweenA = Wedge(Turret, V3(3, 8, 2), GunBetween.CFrame*CN(0, 0, -2), "Dark stone grey", "Concrete")
	
	for G = 0, 1 do
		local BarrelConnect = Part(Turret, V3(4, 4, 4), GunMiddle.CFrame*CN(-4.5+G*9, 0, -12.5), "Dark stone grey", "Concrete")
		Mesh(BarrelConnect, "Sphere")
		local BarrelRamp = Wedge(Turret, V3(6, 8, 2), BarrelConnect.CFrame*CN(0, 0, -0.5), "Dark stone grey", "Concrete")
		
		local GunBarrel = Part(Turret, V3(4.5, 8, 4.5), BarrelConnect.CFrame*CA(-90+Angle2, 0, 0)*CN(0, 4, 0), "Dark stone grey", "Concrete")
		Cylinder(GunBarrel)
		local GunBarrel2 = Part(Turret, V3(3, 8, 3), GunBarrel.CFrame*CN(0, 8, 0), "Dark stone grey", "Concrete")
		Cylinder(GunBarrel2)
		local GunBarrel3 = Part(Turret, V3(2.5, 6, 2.5), GunBarrel2.CFrame*CN(0, 7, 0), "Dark stone grey", "Concrete")
		Cylinder(GunBarrel3)
		local GunBarrel4 = Part(Turret, V3(3, 2, 3), GunBarrel3.CFrame*CN(0, 4, 0), "Dark stone grey", "Concrete")
		Cylinder(GunBarrel4)
		local GunBarrelExit = Part(Turret, V3(2, 1, 2), GunBarrel4.CFrame*CN(0, 0.55, 0), "Really black")
		Cylinder(GunBarrelExit)
	end
end
function Hangar(PT, CF, SZ, HT, BC, MT)
	local Hangar = New'Model'{Parent = PT, Name = "Hangar"}
	local Length = SZ*1.25
	local HangarBase = Part(Hangar, V3(SZ, 1, Length), CF, BC, MT)
	local HangarRight = Part(Hangar, V3(1, HT, Length), CF*CN(-SZ/2+0.5, HT/2+.5, 0), BC, MT)
	local HangarLeft = Part(Hangar, V3(1, HT, Length), CF*CN(SZ/2-0.5, HT/2+0.5, 0), BC, MT)
	local HangarCeiling = Part(Hangar, V3(SZ, 1, Length), CF*CN(0, HT+1, 0), BC, MT)
	local HangarCeiling2 = Part(Hangar, V3(SZ/2, HT/2, Length), CF*CN(0, HT*1.25+1.5, 0), BC, MT)
	local HangarRight2 = Wedge(Hangar, V3(Length, HT+2, SZ/4), CF*CN(-SZ/2-SZ/8, HT/2+0.5, 0)*CA(0, 90, 0), BC, MT)
	local HangarRight3 = Wedge(Hangar, V3(Length, HT/2, SZ/4), CF*CN(-SZ/2+SZ/8, HT*1.25+1.5, 0)*CA(0, 90, 0), BC, MT)
	local HangarLeft2 = Wedge(Hangar, V3(Length, HT+2, SZ/4), CF*CN(SZ/2+SZ/8, HT/2+0.5, 0)*CA(0, -90, 0), BC, MT)
	local HangarLeft3 = Wedge(Hangar, V3(Length, HT/2, SZ/4), CF*CN(SZ/2-SZ/8, HT*1.25+1.5, 0)*CA(0, -90, 0), BC, MT)
	local EntranceSideRight = Part(Hangar, V3(10, HT, 1), CF*CN(-SZ/2+6, HT/2+0.5, Length/2-0.5), BC, MT)
	local EntranceSideRight2 = Part(Hangar, V3(10, HT, 1), CF*CN(-SZ/2+6, HT/2+0.5, -Length/2+0.5), BC, MT)
	local EntranceSideLeft = Part(Hangar, V3(10, HT, 1), CF*CN(SZ/2-6, HT/2+0.5, Length/2-0.5), BC, MT)
	local EntranceSideLeft2 = Part(Hangar, V3(10, HT, 1), CF*CN(SZ/2-6, HT/2+0.5, -Length/2+0.5), BC, MT)
	return Hangar
end
function Fountain(Parent, CFrame)
	local Fountain = New'Model'{Parent = Parent, Name = "Fountain"}
	local FirstBase = Curve(Fountain, CFrame*CN(0, 0.5, 0), 0, 360, 20, 30, 1, "Brick yellow", "Wood", 0, 1)
	local FirstOutside = Curve(Fountain, CFrame*CN(0, 3.5, 0), 28, 360, 20, 2, 5, "Brick yellow", "Wood")
	local FirstWater = Part(Fountain, V3(60, 4, 60), CFrame*CN(0, 2.5, 0), "Bright blue", "SmoothPlastic", 0.4) FirstWater.CanCollide = false
	Cylinder(FirstWater)
	local SecondBase = Curve(Fountain, CFrame*CN(0, 3.5, 0), 0, 360, 20, 20, 5, "Brick yellow", "Wood", 0, 1)
	local SecondOutside = Curve(Fountain, CFrame*CN(0, 8.5, 0), 18, 360, 20, 2, 5, "Brick yellow", "Wood")
	local Waterfall = Curve(Fountain, CFrame*CN(0, 7.75, 0), 17.75, 360, 20, 2.5, 6.75, "Bright blue", "SmoothPlastic", 0.4, 1, true)
	local SecondWater = Part(Fountain, V3(40, 3.5, 40), CFrame*CN(0, 7.75, 0), "Bright blue", "SmoothPlastic", 0.4) SecondWater.CanCollide = false
	Cylinder(SecondWater)
	local ThirdBase = Curve(Fountain, CFrame*CN(0, 9.5, 0), 0, 360, 20, 7, 7, "Brick yellow", "Wood", 0, 1)
	local Waterfall2 = Curve(Fountain, CFrame*CN(0, 9.5, 0), 0, 360, 20, 7.25, 7.5, "Bright blue", "SmoothPlastic", 0.4, 1, true)
	local Figure = New'Model'{Parent = Fountain, Name = "Figure"}
	local RightLeg = Part(Fountain, V3(2, 4, 2), CFrame*CN(1, 13, 0)*CA(-15, 0, 0)*CN(0, 2, 0), "Dark stone grey", "SmoothPlastic")
	local Torso = Part(Fountain, V3(4, 4, 2), RightLeg.CFrame*CN(-1, 1.5, 0)*CA(-15, 0, 0)*CN(0, 2, 0), "Dark stone grey", "SmoothPlastic")
	local LeftLeg = Part(Fountain, V3(2, 4, 2), Torso.CFrame*CN(-1, -2, 0)*CA(-30, 0, -5)*CN(0, -1.5, 0), "Dark stone grey", "SmoothPlastic")
	local RightArm = Part(Fountain, V3(2, 4, 2), Torso.CFrame*CN(3, 1, 0)*CA(-30, 0, 15)*CN(0, -1, 0), "Dark stone grey", "SmoothPlastic")
	local LeftArm = Part(Fountain, V3(2, 4, 2), Torso.CFrame*CN(-3, 1, 0)*CA(15, 0, -15)*CN(0, -1, 0), "Dark stone grey", "SmoothPlastic")
	local Head = Part(Fountain, V3(2.2, 2.2, 2.2), Torso.CFrame*CN(0, 2, 0)*CA(-15, 0, 0)*CN(0, 1, 0), "Dark stone grey", "SmoothPlastic")
	--Mesh(Head, "Head")
	local RightSword = Part(Fountain, V3(2, 2, 4), RightArm.CFrame*CN(0, -2, 3)*CA(0, 0, 90), "Black") RightSword.CanCollide = false
	Mesh(RightSword, "FileMesh", V3(2, 2, 2), SwordMesh)
	local LeftSword = Part(Fountain, V3(2, 2, 4), LeftArm.CFrame*CN(0, -2, -3)*CA(0, 180, 90), "Black") LeftSword.CanCollide = false
	Mesh(LeftSword, "FileMesh", V3(2, 2, 2), SwordMesh)
	local HeadSword = Part(Fountain, V3(2, 2, 4), Head.CFrame*CN(3, -0.5, -1.1)*CA(0, 90, 0), "Black") HeadSword.CanCollide = false
	Mesh(HeadSword, "FileMesh", V3(2, 2, 2), SwordMesh)
	return Fountain
end
function Fountain2(PT, CF)
	--Fountain
	local Fountain = New'Model'{Parent = PT, Name = "Fountain2"}
	Curve(Fountain, CF*CN(0, 3, 0), 25, 360, 30, 1, 5, "Medium stone grey", "Concrete")
	Curve(Fountain, CF*CN(0, 1, 0), 0, 360, 30, 25, 1, "Medium stone grey", "Concrete")
	local Water1 = Part(Fountain, V3(50.75, 1, 50.75), CF*CN(0, 4, 0), "Dove blue", "SmoothPlastic", 0.2)
	Water1.CanCollide = false
	Cylinder(Water1)
	
	Curve(Fountain, CF*CN(0, 12, 0), 15, 360, 30, 1, 4, "Medium stone grey", "Concrete")
	Curve(Fountain, CF*CN(0, 5.75, 0), 0, 360, 30, 10, 8.5, "Medium stone grey", "Concrete")
	Curve(Fountain, CF*CN(0, 10.5, 0), 0, 360, 30, 15, 1, "Medium stone grey", "Concrete")
	local Water2 = Part(Fountain, V3(30.75, 1, 30.75), CF*CN(0, 12.5, 0), "Dove blue", "SmoothPlastic", 0.2)
	Water2.CanCollide = false
	Cylinder(Water2)
	
	Curve(Fountain, CF*CN(0, 18, 0), 7.5, 360, 30, 1, 3, "Medium stone grey", "Concrete")
	Curve(Fountain, CF*CN(0, 13.75, 0), 0, 360, 30, 5, 5.5, "Medium stone grey", "Concrete")
	Curve(Fountain, CF*CN(0, 17, 0), 0, 360, 30, 7.5, 1, "Medium stone grey", "Concrete")
	local Water3 = Part(Fountain, V3(15.75, 1, 15.75), CF*CN(0, 18.25, 0), "Dove blue", "SmoothPlastic", 0.2)
	Water3.CanCollide = false
	Cylinder(Water3)
	
	local StatueBase = Part(Fountain, V3(10, 3, 10), CF*CN(0, 19, 0), "Medium stone grey", "Concrete")
	Cylinder(StatueBase)
	local StatueBase2 = Part(Fountain, V3(8, 3, 8), CF*CN(0, 22, 0), "Medium stone grey", "Concrete")
	Cylinder(StatueBase2)
	local StatueBase3 = Part(Fountain, V3(9, 1, 9), CF*CN(0, 24, 0), "Medium stone grey", "Concrete")
	Cylinder(StatueBase3)
	local StatueBase4 = Part(Fountain, V3(7, 1, 7), CF*CN(0, 25, 0), "Medium stone grey", "Concrete")
	Cylinder(StatueBase4)
	
	local StatueRightLeg = Part(Fountain, V3(2, 4, 2), CF*CN(1, 25.5, 0)*CA(15, 0, 0)*CN(0, 2, 0), "Medium stone grey")
	local StatueTorso = Part(Fountain, V3(4, 4, 2), StatueRightLeg.CFrame*CN(0, 2, 0)*CA(60, 0, 0)*CN(-1, 2, 0), "Medium stone grey")
	local StatueLeftLeg = Part(Fountain, V3(2, 4, 2), StatueTorso.CFrame*CN(-1, -2, 0)*CA(30, 0, 0)*CN(0, -2, 0), "Medium stone grey")
	local StatueRightArm = Part(Fountain, V3(2, 4, 2), StatueTorso.CFrame*CN(3, 1, 0)*CA(-30, 0, 30)*CN(0, -1, 0.25), "Medium stone grey")
	local StatueLeftArm = Part(Fountain, V3(2, 4, 2), StatueTorso.CFrame*CN(-3, 1, 0)*CA(-60, 0, -30)*CN(0, -1, 0.25), "Medium stone grey")
	local StatueHead = Part(Fountain, V3(2.5, 2.5, 2.5), StatueTorso.CFrame*CN(0, 2, 0)*CA(15, 0, 0)*CN(0, 1, 0), "Medium stone grey")
	Mesh(StatueHead, "Head")
	
	--Arrow(Fountain, CF*CN(0, 33, 5)*CA(95, 30), -8))
	--Arrow(Fountain, CF*CN(-2, 27, 0)*CA(90, -60), 7))
	--Arrow(Fountain, CF*CN(2.75, 27.5, 2)*CA(112, -30, 8))
	
	--Jet Mesh: 88775328
	--Jet Texture: 88775716
	
	local Jet = Part(Fountain, V3(10, 5, 20), CF*CN(3, 37, 0)*CA(-15, 150, 0), "Black")
	local JetMesh = Mesh(Jet, "FileMesh", V3(10, 10, 10), "rbxassetid://88775328"--[[, "rbxassetid://88775716"]])
end
function PalmTree(Parent, CFrame, Segments, Modifier, StartSize, StartAngle, Leaves, LeafSegments, LeafSegmentModifier, LeafStartSize, LeafStartAngle, LeafStartVariation, ExtensionsPerLeaf, Colors, Materials)
	local Palm = New'Model'{Parent = Parent, Name = "Palm Tree"}
	local Start = Part(Palm, StartSize, CFrame*CA(StartAngle[1], StartAngle[2], StartAngle[3])*CN(0, StartSize.Y/2, 0), Colors[1], Materials[1])
	Cylinder(Start)
	local CurrentSegment = Start
	for P = 1, Segments-1 do
		local PalmSegment = Part(Palm, StartSize+Modifier*P, CurrentSegment.CFrame*CN(0, CurrentSegment.Size.Y/2, 0)*CA(StartAngle[1]/P+math.random(-2, 2), StartAngle[2]/P+math.random(-2, 2), StartAngle[3]/P+math.random(-2, 2))*CN(0, (StartSize+Modifier*P).Y/2-(StartSize+Modifier*P).X/4, 0), Colors[1], Materials[1])
		Cylinder(PalmSegment)
		CurrentSegment = PalmSegment
		if P == Segments-1 then
			--Top
			for L = 1, Leaves do
				local LeafStart
				if L%2 == 0 then
					LeafStart = Part(Palm, LeafStartSize, PalmSegment.CFrame*CA(0, L*360/Leaves, 0)*CN(0, math.random(-PalmSegment.Size.Y/4*100, PalmSegment.Size.Y/4*100)/100, PalmSegment.Size.Z/2-LeafStartSize.Z/2)*CA(math.random(0, LeafStartVariation[1]), math.random(-LeafStartVariation[2], LeafStartVariation[2]), math.random(-LeafStartVariation[3], LeafStartVariation[3]))*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, LeafStartSize.Y/2, 0), Colors[2], Materials[2])
				else
					LeafStart = Part(Palm, LeafStartSize, PalmSegment.CFrame*CA(0, L*360/Leaves, 0)*CN(0, math.random(PalmSegment.Size.Y/4*100, PalmSegment.Size.Y/2*100)/100, PalmSegment.Size.Z/2-LeafStartSize.Z/2)*CA(math.random(0, LeafStartVariation[1]), math.random(-LeafStartVariation[2], LeafStartVariation[2]), math.random(-LeafStartVariation[3], LeafStartVariation[3]))*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, LeafStartSize.Y/2, 0), Colors[2], Materials[2])
				end
				if math.random(0, 1) == 1 then
					local Coconut = Part(Palm, V3(2, 2, 2), LeafStart.CFrame*CN(0, 0, LeafStartSize.Z/2+0.5), "Reddish brown", "Slate")
					Mesh(Coconut, "Sphere")
				end
				local CurrentSegment = LeafStart
				local LeafStartAngle = {math.random(5*5, 8*5)/5, math.random(-1*10, 1*10)/10, math.random(-1.5*10, 1.5*10)/10}
				for S = 1, LeafSegments-1 do
					local LeafSegment = Part(Palm, LeafStartSize+LeafSegmentModifier*S, CurrentSegment.CFrame*CN(0, CurrentSegment.Size.Y/2, 0)*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, (LeafStartSize+LeafSegmentModifier*S).Y/2-(LeafStartSize+LeafSegmentModifier*S).X/4, 0), Colors[2], Materials[2])
					CurrentSegment = LeafSegment
					LeafSegment.CanCollide = false
					for E = 1, ExtensionsPerLeaf do
						local LeafExtension = Part(Palm, V3(0.2, 0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E), 0.2), LeafSegment.CFrame*CN(0, -LeafSegment.Size.Y/2+LeafSegment.Size.Y/ExtensionsPerLeaf*E, 0)*CA(0, 0, 90-((S-1)*ExtensionsPerLeaf+E)*(90/(LeafSegments-1)/ExtensionsPerLeaf))*CA(LeafStartAngle[1]/ExtensionsPerLeaf*E, LeafStartAngle[2]/ExtensionsPerLeaf*E, LeafStartAngle[3]/ExtensionsPerLeaf*E)*CA(-7, 0, 0)*CN(0, (0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E))/2, 0), Colors[3], Materials[3])
						local LeafExtension2 = Part(Palm, V3(0.2, 0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E), 0.2), LeafSegment.CFrame*CN(0, -LeafSegment.Size.Y/2+LeafSegment.Size.Y/ExtensionsPerLeaf*E, 0)*CA(0, 0, -90+((S-1)*ExtensionsPerLeaf+E)*(90/(LeafSegments-1)/ExtensionsPerLeaf))*CA(LeafStartAngle[1]/ExtensionsPerLeaf*E, LeafStartAngle[2]/ExtensionsPerLeaf*E, LeafStartAngle[3]/ExtensionsPerLeaf*E)*CA(-7, 0, 0)*CN(0, (0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E))/2, 0), Colors[3], Materials[3])
						LeafExtension.CanCollide = false
						LeafExtension2.CanCollide = false
					end
				end
			end
		end
	end
	return Palm
end
function Scaffold(Parent, CFrame, Width, Height, Length, BridgeDirection, BridgeWidth, BackCross)
	local Scaffold = New'Model'{Parent = Parent, Name = "Scaffold"}
	local Platform = Part(Scaffold, V3(Width, 1, Length), CFrame*CN(0, Height, 0), "Reddish brown", "Wood")
	local SupportFrontRight = Part(Scaffold, V3(1, Height-1, 1), CFrame*CN(-Width/2+0.5, Height/2, Length/2-0.5), "Reddish brown", "Wood")
	local SupportFrontLeft = Part(Scaffold, V3(1, Height-1, 1), CFrame*CN(Width/2-0.5, Height/2, Length/2-0.5), "Reddish brown", "Wood")
	local SupportBackRight = Part(Scaffold, V3(1, Height-1, 1), CFrame*CN(-Width/2+0.5, Height/2, -Length/2+0.5), "Reddish brown", "Wood")
	local SupportBackLeft = Part(Scaffold, V3(1, Height-1, 1), CFrame*CN(Width/2-0.5, Height/2, -Length/2+0.5), "Reddish brown", "Wood")
	
	ConnectPoints(Scaffold, SupportFrontRight.CFrame*CN(0, Height/2-0.5, 0), SupportBackRight.CFrame*CN(0, -Height/2+0.5, 0), 1, 1, "Reddish brown", "Wood")
	ConnectPoints(Scaffold, SupportFrontRight.CFrame*CN(0, -Height/2+0.5, 0), SupportBackRight.CFrame*CN(0, Height/2-0.5, 0), 1, 1, "Reddish brown", "Wood")
	ConnectPoints(Scaffold, SupportFrontLeft.CFrame*CN(0, Height/2-0.5, 0), SupportBackLeft.CFrame*CN(0, -Height/2+0.5, 0), 1, 1, "Reddish brown", "Wood")
	ConnectPoints(Scaffold, SupportFrontLeft.CFrame*CN(0, -Height/2+0.5, 0), SupportBackLeft.CFrame*CN(0, Height/2-0.5, 0), 1, 1, "Reddish brown", "Wood")
	if BackCross then
		ConnectPoints(Scaffold, SupportBackLeft.CFrame*CN(0, Height/2-0.5, 0), SupportBackRight.CFrame*CN(0, -Height/2+0.5, 0), 1, 1, "Reddish brown", "Wood")
		ConnectPoints(Scaffold, SupportBackLeft.CFrame*CN(0, -Height/2+0.5, 0), SupportBackRight.CFrame*CN(0, Height/2-0.5, 0), 1, 1, "Reddish brown", "Wood")
	end
	if BridgeWidth > 0 then
		ConnectPoints(Scaffold, Platform.CFrame*CN((Width/2-BridgeWidth)*BridgeDirection, 0, Length/2-0.5), CFrame*CN((Width/2-BridgeWidth)*BridgeDirection, 0, Length/2+Height/2), BridgeWidth, 1, "Reddish brown", "Wood")
	end
	return Scaffold, Platform
end
function RadioDish(Parent, CFrame, Angle)
	local DishBase = Part(Parent, V3(4, 1, 4), CFrame, "Dark stone grey", "Concrete")
	Cylinder(DishBase)
	local DishBase2 = Part(Parent, V3(3.5, 1, 3.5), DishBase.CFrame*CN(0, 0.5, 0), "Dark stone grey", "Concrete")
	Cylinder(DishBase2)
	local DishBase3 = Part(Parent, V3(3, 1, 3), DishBase2.CFrame*CN(0, 0.1, 0), "Medium stone grey", "Concrete")
	Cylinder(DishBase3)
	local DishStand = Part(Parent, V3(2, 3, 2), DishBase3.CFrame*CN(0, 2, 0), "Medium stone grey", "Concrete")
	Cylinder(DishStand)
	local DishStand2 = Part(Parent, V3(1.5, 3, 1.5), DishStand.CFrame*CN(0, 3, 0), "Medium stone grey", "Concrete")
	Cylinder(DishStand2)
	local DishStand2S = Part(Parent, V3(1.25, 1.25, 1.25), DishStand2.CFrame*CN(0, 1.5, 0), "Medium stone grey", "Concrete")
	Mesh(DishStand2S, "Sphere")
	local DishStand3 = Part(Parent, V3(1.25, 4, 1.25), DishStand2S.CFrame*Angle*CN(0, 2, 0), "Medium stone grey", "Concrete")
	Cylinder(DishStand3)
	local Dish = Part(Parent, V3(10, 0.5, 10), DishStand3.CFrame*CN(0, 2, 0), "Black")
	Cylinder(Dish)
	local DishA = Part(Parent, V3(9, 0.6, 9), Dish.CFrame, "Dark stone grey", "Concrete")
	Cylinder(DishA)
	local DishB = Part(Parent, V3(7, 0.5, 7), Dish.CFrame*CN(0, -0.1, 0), "Dark stone grey", "Concrete")
	Cylinder(DishB)
	local DishC = Part(Parent, V3(4, 0.5, 4), DishB.CFrame*CN(0, -0.25, 0), "Dark stone grey", "Concrete")
	Cylinder(DishC)
	local DishD = Part(Parent, V3(2, 0.5, 2), DishC.CFrame*CN(0, -0.5, 0), "Dark stone grey", "Concrete")
	Cylinder(DishD)
	local DishPoint = Part(Parent, V3(0.5, 5, 0.5), Dish.CFrame*CN(0, 2.75, 0), "Black", "Concrete")
	Cylinder(DishPoint)
	local DishPointConnect = Part(Parent, V3(0.75, 0.5, 0.75), DishPoint.CFrame*CN(0, -2.65, 0), "Really black")
	Cylinder(DishPointConnect)
	local DishPoint2 = Part(Parent, V3(0.75, 0.75, 0.75), DishPoint.CFrame*CN(0, 2.5, 0), "Really red")
	Mesh(DishPoint2, "Sphere")
	for S = 1, 4 do
		local DishPoint3 = ConnectPoints(Parent, Dish.CFrame*CA(0, 90*S, 0)*CN(0, 0, 4), DishPoint2.CFrame, 0.4, 0.4, "Black", "Concrete")
		Cylinder(DishPoint3)
		local DishPoint3Connect = Part(Parent, V3(0.6, 0.5, 0.6), Dish.CFrame*CA(0, 90*S, 0)*CN(0, 0.1, 3.75), "Really black")
		Cylinder(DishPoint3Connect)
	end
end
function RadioTower(Parent, CFrame)
	local Tower = New'Model'{Parent = Parent, Name = "Radio Tower"}
	local TowerBase = Part(Tower, V3(50, 1, 50), CFrame, "Medium stone grey", "Concrete")
	local TowerTop = Part(Tower, V3(10, 1, 10), CFrame*CN(0, 100, 0), "Medium stone grey", "Concrete")
	local Antenna1 = Part(Tower, V3(1.5, 3, 1.5), TowerTop.CFrame*CN(3.5, 2, 3.5), "Black")
	Cylinder(Antenna1)
	local Antenna1A = Part(Tower, V3(1, 6, 1), Antenna1.CFrame*CN(0, 4.5, 0), "Black")
	Cylinder(Antenna1A)
	local Antenna1B = Part(Tower, V3(0.5, 6, 0.5), Antenna1A.CFrame*CN(0, 6, 0), "Black")
	Cylinder(Antenna1B)
	local Antenna1C = Part(Tower, V3(0.2, 6, 0.2), Antenna1B.CFrame*CN(0, 6, 0), "Black")
	Cylinder(Antenna1C)
	local AntennaConnect = Part(Tower, V3(1.75, 1, 1.75), Antenna1.CFrame*CN(0, -1.95, 0), "Really black")
	Cylinder(AntennaConnect)
	RadioDish(Tower, TowerTop.CFrame*CN(-2.5, 0.1, -2.5), CA(0, 30, 0)*CA(-30, 0, 0))
	local Supports = {}
	for S = 1, 4 do
		local Support = ConnectPoints(Tower, TowerBase.CFrame*CA(0, 90*S, 0)*CN(24, 0, 24), TowerTop.CFrame*CA(0, 90*S, 0)*CN(4, 0, 4), 2, 2, "Medium stone grey", "Concrete")
		Cylinder(Support)
		table.insert(Supports, Support)
	end
	for D = -2, 2 do
		local CS1 = ConnectPoints(Tower, Supports[1].CFrame*CN(0, D*15, 0), Supports[2].CFrame*CN(0, D*15, 0), 2, 2, "Medium stone grey", "Concrete")
		Cylinder(CS1)
		local CS2 = ConnectPoints(Tower, Supports[2].CFrame*CN(0, D*15, 0), Supports[3].CFrame*CN(0, D*15, 0), 2, 2, "Medium stone grey", "Concrete")
		Cylinder(CS2)
		local CS3 = ConnectPoints(Tower, Supports[3].CFrame*CN(0, D*15, 0), Supports[4].CFrame*CN(0, D*15, 0), 2, 2, "Medium stone grey", "Concrete")
		Cylinder(CS3)
		local CS4 = ConnectPoints(Tower, Supports[4].CFrame*CN(0, D*15, 0), Supports[1].CFrame*CN(0, D*15, 0), 2, 2, "Medium stone grey", "Concrete")
		Cylinder(CS4)
		
		local CS5 = ConnectPoints(Tower, Supports[1].CFrame*CN(0, D*15, 0), Supports[2].CFrame*CN(0, D*15+15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS5)
		local CS6 = ConnectPoints(Tower, Supports[1].CFrame*CN(0, D*15+15, 0), Supports[2].CFrame*CN(0, D*15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS6)
		
		local CS7 = ConnectPoints(Tower, Supports[2].CFrame*CN(0, D*15, 0), Supports[3].CFrame*CN(0, D*15+15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS7)
		local CS8 = ConnectPoints(Tower, Supports[2].CFrame*CN(0, D*15+15, 0), Supports[3].CFrame*CN(0, D*15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS8)
		
		local CS9 = ConnectPoints(Tower, Supports[3].CFrame*CN(0, D*15, 0), Supports[4].CFrame*CN(0, D*15+15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS9)
		local CS9 = ConnectPoints(Tower, Supports[3].CFrame*CN(0, D*15+15, 0), Supports[4].CFrame*CN(0, D*15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS9)
		
		local CS10 = ConnectPoints(Tower, Supports[4].CFrame*CN(0, D*15, 0), Supports[1].CFrame*CN(0, D*15+15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS10)
		local CS11 = ConnectPoints(Tower, Supports[4].CFrame*CN(0, D*15+15, 0), Supports[1].CFrame*CN(0, D*15, 0), 1, 1, "Medium stone grey", "Concrete")
		Cylinder(CS11)
	end
end
function HelicopterPad(Parent, CFrame)
	local Pad = New'Model'{Parent = Parent, Name = "Helicopter Landing Pad"}
	local Pad1 = Part(Pad, V3(50, 1, 50), CFrame, "Black", "Concrete")
	local PadInline1 = Part(Pad, V3(1, 1, 48), Pad1.CFrame*CN(23.5, 0.1, 0), "Bright yellow", "Concrete")
	local PadInline2 = Part(Pad, V3(1, 1, 48), Pad1.CFrame*CN(-23.5, 0.1, 0), "Bright yellow", "Concrete")
	local PadInline3 = Part(Pad, V3(46, 1, 1), Pad1.CFrame*CN(0, 0.1, 23.5), "Bright yellow", "Concrete")
	local PadInline4 = Part(Pad, V3(46, 1, 1), Pad1.CFrame*CN(0, 0.1, -23.5), "Bright yellow", "Concrete")
	
	local H1 = Part(Pad, V3(1, 1, 25), Pad1.CFrame*CN(10, 0.1, 0), "Light stone grey", "Concrete")
	local H2 = Part(Pad, V3(1, 1, 25), Pad1.CFrame*CN(-10, 0.1, 0), "Light stone grey", "Concrete")
	local H3 = Part(Pad, V3(19, 1, 1), Pad1.CFrame*CN(0, 0.1, 0), "Light stone grey", "Concrete")
end
function Desk(Parent, CFrame, Width, Length, BrickColor, Material)
	local Desk = New'Model'{Parent = Parent, Name = "Desk"}
	local DeskTop = Part(Desk, V3(Width, 1, Length), CFrame*CN(0, 4, 0), BrickColor, Material)
	local DeskBack = Part(Desk, V3(Width, 3.5, 1), CFrame*CN(0, 1.75, Length/2-0.5), BrickColor, Material)
	local DeskRight = Part(Desk, V3(1, 3.5, Length-1), CFrame*CN(Width/2-0.5, 1.75, -0.5), BrickColor, Material)
	local DeskLeft = Part(Desk, V3(1, 3.5, Length-1), CFrame*CN(-Width/2+0.5, 1.75, -0.5), BrickColor, Material)
	return DeskTop
end
function Laptop(Parent, CFrame, Angle, BrickColor)
	local Laptop = New'Model'{Parent = Parent, Name = "Laptop"}
	local LaptopBoard = Part(Laptop, V3(2, 0.2, 2), CFrame*CN(0, 0.1, 0), BrickColor)
	local LaptopKeyboard = Part(Laptop, V3(1.8, 0.2, 1.2), LaptopBoard.CFrame*CN(0, 0.05, -0.3), BrickColor)
	local LaptopMonitor = Part(Laptop, V3(2, 0.2, 2), LaptopBoard.CFrame*CN(0, 0.2, 1)*CA(Angle, 0, 0)*CN(0, 0, -1), BrickColor)
	local LaptopScreen = Part(Laptop, V3(1.8, 0.2, 1.8), LaptopMonitor.CFrame*CN(0, -0.005, 0), "Really black")
	local LaptopMonitorConnect = Part(Laptop, V3(2, 0.3, 0.2), LaptopBoard.CFrame*CN(0, 0.05, 1), BrickColor)
	local LaptopMonitorConnect2 = Part(Laptop, V3(0.2, 2, 0.2), LaptopMonitorConnect.CFrame*CN(0, 0.15, 0)*CA(0, 0, 90), BrickColor)
	Cylinder(LaptopMonitorConnect2)
end
function StackOfPapers(Parent, CFrame, Size)
	local Papers = New'Model'{Parent = Parent, Name = "Stack Of Papers"}
	local Stack = Part(Papers, V3(Size, Size, Size), CFrame*CN(0, Size/2, 0), "Light stone grey")
	Mesh(Stack, "FileMesh", V3(Size, Size, Size), PaperStack)
	return Stack
end
function PottedPlant(Parent, CFrame)
	local PottedPlant = New'Model'{Parent = Parent, Name = "Potted Plant"}
	local Plant = Part(PottedPlant, V3(2, 4, 2), CFrame*CN(0, 2, 0), "CGA brown", "Wood")
	Mesh(Plant, "FileMesh", V3(4, 4, 4), PlantInPot, PlantInPotTex)
end
function OfficeChair(Parent, CFrame, BrickColor)
	local Chair = New'Model'{Parent = Parent, Name = "Office Chair"}
	local ChairSeat = Part(Chair, V3(2.5, 0.5, 2.5), CFrame*CN(0, 2.5, 0), BrickColor)
	Mesh(ChairSeat, "FileMesh", V3(1.25, 0.25, 2.5), "rbxasset://fonts/torso.mesh")
	local ChairSeatBase = Part(Chair, V3(0.5, 1.5, 0.5), ChairSeat.CFrame*CN(0, -1, 0), "Black")
	Cylinder(ChairSeatBase)
	local ChairSeatBaseConnect = Part(Chair, V3(0.5, 0.5, 0.5), ChairSeatBase.CFrame*CN(0, -0.75, 0)*CA(0, math.random(-180, 180), 0), "Black")
	Mesh(ChairSeatBaseConnect, "Sphere")
	for L = 1, 5 do
		local ChairLeg = Part(Chair, V3(0.5, 2, 0.5), ChairSeatBaseConnect.CFrame*CA(0, L*72, 0)*CN(0, 0, 1)*CA(90, 0, 0), "Black")
		Cylinder(ChairLeg)
		local ChairWheel = Part(Chair, V3(1, 0.2, 1), ChairLeg.CFrame*CN(0, 1.1, 0.25), "Black")
		Cylinder(ChairWheel)
	end
	local ChairBack = Part(Chair, V3(1, 0.2, 0.5), ChairSeat.CFrame*CN(0, 0, 1.5), "Black")
	local ChairBackConnect = Part(Chair, V3(0.2, 1, 0.2), ChairBack.CFrame*CN(0, 0, 0.25)*CA(0, 0, 90), "Black")
	Cylinder(ChairBackConnect)
	local ChairBack2 = Part(Chair, V3(1, 1.2, 0.2), ChairBack.CFrame*CN(0, 0.6, 0.25), "Black")
	local ChairBackCushion = Part(Chair, V3(2.5, 2.5, 0.5), ChairBack2.CFrame*CN(0, 1.85, 0), BrickColor)
	Mesh(ChairBackCushion, "FileMesh", V3(1.25, 1.25, 0.5), "rbxasset://fonts/torso.mesh")
end
function Mug(Parent, CFrame, Size, BrickColor)
	local Mug = Part(Parent, V3(Size, Size, Size), CFrame*CN(0, Size*0.625, 0), BrickColor)
	Mesh(Mug, "FileMesh", V3(Size, Size, Size), MugMesh)
	return Mug
end
function Trashbags(Parent, CFrame, Size)
	local Trashbags = New'Model'{Parent = Parent, Name = "Trashbags"}
	local Bags = Part(Trashbags, Size, CFrame*CN(0, Size.Y/2, 0))
	Mesh(Bags, "FileMesh", Size, TrashbagsMesh, TrashbagsTex)
end
function Compass(Parent, CFrame, Size)
	local Compass = Part(Parent, V3(Size, Size, Size), CFrame*CN(0, Size*0.6, 0))
	Mesh(Compass, "FileMesh", V3(Size*1.35, Size*1.35, Size*1.35), CompassMesh, CompassTex)
	return Compass
end
function Figure(Parent, CFrame, Pose, Assets, BodyColors, TShirt)
	local Figure = New'Model'{Parent = Parent, Name = "Figure"}
	local Torso = Part(Figure, V3(2, 2, 1), CFrame, BodyColors[1]) --[[Torso.Anchored = false]] Torso.Name = "Torso"
	local Head = Part(Figure, V3(1.25, 1.25, 1.25), CFrame, BodyColors[2]) Head.Anchored = false Head.Name = "Head" Head.Transparency = 1
	Mesh(Head, "Head")
	local FakeHead = Part(Figure, V3(1.25, 1.25, 1.25), CFrame, BodyColors[2]) FakeHead.Anchored = false
	Mesh(FakeHead, "Head")
	Motor(Head, Head, FakeHead)
	local RightArm = Part(Figure, V3(1, 2, 1), CFrame, BodyColors[3]) RightArm.Anchored = false RightArm.Name = "Right Arm"
	local LeftArm = Part(Figure, V3(1, 2, 1), CFrame, BodyColors[4]) LeftArm.Anchored = false LeftArm.Name = "Left Arm"
	local RightLeg = Part(Figure, V3(1, 2, 1), CFrame, BodyColors[5]) RightLeg.Anchored = false RightLeg.Name = "Right Leg"
	local LeftLeg = Part(Figure, V3(1, 2, 1), CFrame, BodyColors[6]) LeftLeg.Anchored = false LeftLeg.Name = "Left Leg"
	Motor(Torso, Torso, Head, Pose[1], CN(0, -0.5, 0), "Neck")
	Motor(Torso, Torso, RightArm, Pose[2], CN(0, 0.5, 0), "Right Shoulder")
	Motor(Torso, Torso, LeftArm, Pose[3], CN(0, 0.5, 0), "Left Shoulder")
	Motor(Torso, Torso, RightLeg, Pose[4], CN(0, 1, 0), "Right Hip")
	Motor(Torso, Torso, LeftLeg, Pose[5], CN(0, 1, 0), "Left Hip")
	New'Humanoid'{Parent = Figure, Health = 100}
	Figure:MakeJoints()
	wait()
	for _, Id in pairs(Assets) do
		wait()
		local Asset = InsertService:LoadAsset(Id)
		local AssetItem = Asset:GetChildren()[1]
		if AssetItem:IsA("Decal") then
			AssetItem.Parent = FakeHead
		else
			AssetItem.Parent = Figure
		end
	end
	if TShirt then Instance.new("ShirtGraphic", Figure).Graphic = "rbxassetid://"..TShirt end
	Figure:MakeJoints()
	return Figure
end
function ThumbnailPeeps(Parent, CFrame)
	local Peeps = New'Model'{Parent = Parent}
	local RMDX = Figure(Peeps, CFrame*CN(0, 2.9, 0), { --RMDX
		CN(0, 1, 0)*CA(0, 0, 0),
		CN(1.5, 0.5, 0)*CA(135, 15, 15),
		CN(-1.5, 0.5, 0)*CA(-10, 0, -15),
		CN(0.5, -1, 0)*CA(0, 0, 10),
		CN(-0.5, -1, 0)*CA(0, 0, -10)
	}, {20722130, 1365767, 17424092, 15967743, 8409458, 8409453},
	{"Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow"}, 52291597) --PonyShirt: 52291597
	
	local Shotgun = Part(Peeps, V3(1, 1, 4), RMDX["Right Arm"].CFrame*CN(0, -1, -0.25)*CA(-90, 0, 0), "Black")
	Mesh(Shotgun, "FileMesh", V3(1.8, 1.5, 1), "rbxassetid://3835506")
	
	local Fenrier = Figure(Peeps, CFrame*CN(12, 2.9, -2.5)*CA(0, 30, 0), { --Fenrier
		CN(0, 1, 0)*CA(0, -30, 0),
		CN(1.5, 0.5, 0)*CA(-10, 0, 15),
		CN(-1.5, 0.5, 0)*CA(-10, 0, -15),
		CN(0.5, -1, 0)*CA(10, 0, 10),
		CN(-0.5, -1, 0)*CA(-10, 0, -10)
	}, {1846208, 1859136, 20298783, 14030577},
	{"Dark stone grey", "Brick yellow", "Navy blue", "Navy blue", "Navy blue", "Navy blue"})
	
	local GuitarMan = Figure(Peeps, CFrame*CN(-14, 7.5, 0)*CA(0, -30, 0), { --Guy with guitar and cowboy hat
		CN(0, 1, 0)*CA(0, -30, 0),
		CN(1, 0.5, -0.5)*CA(90, 0, -45),
		CN(-1, 0.5, 0)*CA(80, 0, 30),
		CN(0.5, -1, 0)*CA(-10, 0, 10),
		CN(-0.5, -1, 0)*CA(10, 0, -10)
	}, {1846208, 1859136, 62332732, 19398258, 10527010},
	{"Dark stone grey", "Brick yellow", "Lime green", "Lime green", "Bright orange", "Bright orange"})
	
	local Piano = Part(Peeps, V3(5, 5, 5), GuitarMan.Torso.CFrame*CN(0, -5, 0)*CA(-30, 0, 0))
	Mesh(Piano, "FileMesh", V3(3, 3, 3), "rbxassetid://113221356", "rbxassetid://113221332")
	local Guitar = Part(Peeps, V3(1, 1, 1), GuitarMan["Left Arm"].CFrame*CN(0, -1, 0)*CA(-90, 180, 90)*CN(1.5, 0, 0))
	Mesh(Guitar, "FileMesh", V3(1.5, 1.5, 1.5), "rbxassetid://1082816", "rbxassetid://10504421")
	
	local SniperDude = Figure(Peeps, CFrame*CN(-5.5, 2, -2.5)*CA(0, -30, 0), { --Sniper dude
		CN(0, 1, 0)*CA(0, -30, 0),
		CN(1.5, 0.5, 0)*CA(90, 0, 15),
		CN(-1.5, 0.5, 0)*CA(90, 0, -15),
		CN(0.51, -1.5, 0)*CA(-90, 0, 0)*CN(0, 0.5, 0),
		CN(-0.51, 0, -0.25)*CA(0, 0, 0)
	}, {9315055, 8343331, 1029025, 1309911, 1125510, 10860384},
	{"Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow"}, 11317761)
	
	local CrazyDude = Figure(Peeps, CFrame*CN(6, 3, 0)*CA(0, 15, 0), { --Crazy guy
		CN(0, 1, 0)*CA(0, -30, 0),
		CN(1.5, 0.5, 0)*CA(90, 0, 135),
		CN(-1.5, 0.5, 0)*CA(90, 0, -15),
		CN(0.5, -1, 0)*CA(0, 0, 0),
		CN(-0.5, -1, 0)*CA(0, 0, 0)
	}, {58789718, 58811258, 1365767, 17877340, 21635565},
	{"Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow"}, 20736336)
end
function LandingCraft(Parent, CFrame, DrawbridgeAngle)
	local Craft = New'Model'{Parent = Parent, Name = "Armoured Landing Craft"}
	local Hull = Part(Craft, V3(30, 3, 90), CFrame, "Medium stone grey", "DiamondPlate")
	local BottomFront = Wedge(Craft, V3(38, 5, 9), CFrame*CN(0, -4, -40.5)*CA(0, 0, 180), "Medium stone grey", "DiamondPlate")
	local BottomBack = Wedge(Craft, V3(38, 5, 13), CFrame*CN(0, -4, 42.5)*CA(0, 180, 180), "Medium stone grey", "DiamondPlate")
	local MidBottom = Part(Craft, V3(38, 5, 72), CFrame*CN(0, -4, 0), "Medium stone grey", "DiamondPlate")
	local BackWall = Part(Craft, V3(38, 18, 4), CFrame*CN(0, 7.5, 47), "Medium stone grey", "DiamondPlate")
	local Drawbridge = Part(Craft, V3(30, 24, 1), CFrame*CN(0, 0, -45)*CA(DrawbridgeAngle, 0, 0)*CN(0, 12, 0), "Medium stone grey", "DiamondPlate")
	for D = -11, 11 do
		local DrawbridgePad = Part(Craft, V3(1, 28, 1), Drawbridge.CFrame*CN(0, D, 0.25)*CA(0, 0, 90), "Dark stone grey", "Concrete")
		Cylinder(DrawbridgePad)
	end
	local DrawbridgeTop = Part(Craft, V3(0.5, 29, 0.5), Drawbridge.CFrame*CN(0, 12, 0)*CA(0, 0, 90), "Medium stone grey", "DiamondPlate")
	Cylinder(DrawbridgeTop)
	local DrawbridgeMid = Part(Craft, V3(5, 5, 1), Drawbridge.CFrame*CN(0, 5, -0.5), "Medium stone grey", "DiamondPlate")
	local DrawbridgeMid2 = Part(Craft, V3(4, 4, 1), DrawbridgeMid.CFrame*CN(0, 0, -0.2), "Black", "DiamondPlate")
	DecalFaces(DrawbridgeMid2, {"Front"}, "rbxassetid://114351360")
	local DrawbridgeTopOutside = Part(Craft, V3(29, 1, 1), Drawbridge.CFrame*CN(0, 11, -0.5), "Dark stone grey", "DiamondPlate")
	local DrawbridgeBottomOutside = Part(Craft, V3(29, 1, 1), Drawbridge.CFrame*CN(0, -11, -0.5), "Dark stone grey", "DiamondPlate")
	for D = -5, 5 do
		local DrawbridgeOutsideDecor = Part(Craft, V3(1, 22, 1), Drawbridge.CFrame*CN(D*2.5, 0, -0.5), "Dark stone grey", "DiamondPlate")
		Cylinder(DrawbridgeOutsideDecor)
	end
	for A = -1, 1, 2 do
		local Wall = Part(Craft, V3(4, 18, 90), CFrame*CN(A*17, 7.5, 0), "Medium stone grey", "DiamondPlate")
		local WallBottom = Part(Craft, V3(1, 0.5, 60), Wall.CFrame*CN(-2.5*A, -5.75, -15), "Medium stone grey", "Concrete")
		for D = -4, 1 do
			local WallDecor = Wedge(Craft, V3(1, 18, 1), Wall.CFrame*CN(-2.5*A, 0, D*10)*CA(0, A*90, 0), "Medium stone grey", "Concrete")
			if D ~= -4 then
				local WallDecor2 = Part(Craft, V3(2, 1, 2), Wall.CFrame*CN(-1.6*A, 7, D*10-5)*CA(0, 0, 90), "Medium stone grey", "Concrete")
				Cylinder(WallDecor2)
				local WallDecor3 = Part(Craft, V3(1.75, 1.75, 1.75), WallDecor2.CFrame, "Medium stone grey", "SmoothPlastic")
				Mesh(WallDecor3, "Sphere")
			end
		end
		local FrontSides = Wedge(Craft, V3(4, 18, 10), CFrame*CN(A*17, 7.5, -50)*CA(0, 0, 180), "Medium stone grey", "DiamondPlate")
		local FrontSidesTop = Wedge(Craft, V3(4, 5, 9), CFrame*CN(A*17, 19, -50.5), "Medium stone grey", "DiamondPlate")
		local FrontSidesBack = Wedge(Craft, V3(4, 5, 61), CFrame*CN(A*17, 19, -15.5)*CA(0, 180, 0), "Medium stone grey", "DiamondPlate")
		local DrawbridgeMotor = Part(Craft, V3(4, 4.2, 4), FrontSidesTop.CFrame*CN(0, -2.5, 5.5)*CA(0, 0, 90), "Dark stone grey", "Concrete")
		Cylinder(DrawbridgeMotor)
		local DrawbridgeMotor2 = Part(Craft, V3(3, 1, 3), DrawbridgeMotor.CFrame*CN(0, 2.6*A, 0), "Dark stone grey", "Concrete")
		Cylinder(DrawbridgeMotor2)
		local DrawbridgeMotor2A = Part(Craft, V3(3.05, 0.4, 3.05), DrawbridgeMotor2.CFrame, "Really black", "SmoothPlastic")
		Cylinder(DrawbridgeMotor2A)
		local DrawbridgeMotor3 = Part(Craft, V3(1, 4.5, 5), Drawbridge.CFrame*CN(15.5*A, 9.75, 2), "Medium stone grey", "DiamondPlate")
		--Cylinder(DrawbridgeMotor3)
		local DrawbridgeMotor4 = Part(Craft, V3(3.25, 1.2, 3.25), DrawbridgeMotor3.CFrame*CN(0, 0, 0.5)*CA(0, 0, 90), "Dark stone grey", "Concrete")
		Cylinder(DrawbridgeMotor4)
		local DrawbridgeMotor5 = Part(Craft, V3(3, 1, 3), DrawbridgeMotor4.CFrame*CN(0, A*1.1, 0), "Dark stone grey", "Concrete")
		Cylinder(DrawbridgeMotor5)
		local DrawbridgeMotor5A = Part(Craft, V3(3.05, 0.4, 3.05), DrawbridgeMotor5.CFrame, "Really black", "SmoothPlastic")
		Cylinder(DrawbridgeMotor5A)
		local DrawbridgeWire = ConnectPoints(Craft, DrawbridgeMotor2.CFrame, DrawbridgeMotor5.CFrame, 0.4, 0.4, "Dark stone grey", "DiamondPlate")
		Cylinder(DrawbridgeWire)
	end
	--local Back = Part(Craft, V3(30, 15, 30), CFrame*CN(0, 9, 30), "Medium stone grey", "DiamondPlate")
	local BackTop = Part(Craft, V3(30, 1, 29), CFrame*CN(0, 16, 30.5), "Medium stone grey", "DiamondPlate")
	local BackFront = Part(Craft, V3(20, 15, 1), CFrame*CN(5, 9, 15.5), "Medium stone grey", "DiamondPlate")
	local BackFront2 = Part(Craft, V3(5, 15, 1), CFrame*CN(-12.5, 9, 15.5), "Medium stone grey", "DiamondPlate")
	local BackFront3 = Part(Craft, V3(5, 6, 1), CFrame*CN(-7.5, 13.5, 15.5), "Medium stone grey", "DiamondPlate")
	Curve(Craft, CFrame*CN(-7.5, 7, 15.5)*CA(-90, 0, 0), 2.75, 180, 5, 1.5, 0.95, "Medium stone grey", "DiamondPlate")
	CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(10, 1.5, 10)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
	CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(-10, 1.5, 10)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
	CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(10, 1.5, 20)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
	CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(-10, 1.5, 20)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
	CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(10, 1.5, 40)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
	CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(-10, 1.5, 40)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
	--67328263
	--109085823
	--Ladder
	for L = 1, 10 do
		local LadderStep = Part(Craft, V3(0.5, 4, 0.5), CFrame*CN(0, 0.75+L*1.5, 14)*CA(0, 0, 90), "Medium stone grey", "DiamondPlate")
		Cylinder(LadderStep)
		local LadderStep2 = Part(Craft, V3(0.5, 1, 0.5), LadderStep.CFrame*CN(0, 2, 0.5)*CA(90, 0, 0), "Medium stone grey", "DiamondPlate")
		Cylinder(LadderStep2)
		local LadderStep3 = Part(Craft, V3(0.5, 1, 0.5), LadderStep.CFrame*CN(0, -2, 0.5)*CA(90, 0, 0), "Medium stone grey", "DiamondPlate")
		Cylinder(LadderStep3)
		local LadderStep4 = Part(Craft, V3(0.5, 0.5, 0.5), LadderStep.CFrame*CN(0, 2, 0), "Medium stone grey", "DiamondPlate")
		Mesh(LadderStep4, "Sphere")
		local LadderStep5 = Part(Craft, V3(0.5, 0.5, 0.5), LadderStep.CFrame*CN(0, -2, 0), "Medium stone grey", "DiamondPlate")
		Mesh(LadderStep5, "Sphere")
	end
	--Command Bridge
	local BridgeCeiling = Part(Craft, V3(15, 1, 20), BackTop.CFrame*CN(7.5, 15.5, 3.5), "Medium stone grey", "DiamondPlate")
	local BridgeBack = Part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -13.5, 10.5), "Medium stone grey", "DiamondPlate")
	local BridgeBackA = Part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -1, 10.5), "Medium stone grey", "DiamondPlate")
	local BridgeBack2 = Part(Craft, V3(1, 9.5, 1), BridgeBack.CFrame*CN(0, 6.25, 0), "Medium stone grey", "DiamondPlate")
	local BridgeBackWindow = Part(Craft, V3(15, 9.5, 0.5), BridgeBack.CFrame*CN(0, 6.25, 0), "Navy blue", "SmoothPlastic", 0.75) BridgeBackWindow.Name = "Glass"
	DecalFaces(BridgeBackWindow, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, "rbxassetid://67331799", 0.5)
	local BridgeFront = Part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -13.5, -10.5), "Medium stone grey", "DiamondPlate")
	local BridgeFrontA = Part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -1, -10.5), "Medium stone grey", "DiamondPlate")
	local BridgeFront2 = Part(Craft, V3(1, 9.5, 1), BridgeFront.CFrame*CN(0, 6.25, 0), "Medium stone grey", "DiamondPlate")
	local BridgeFrontWindow = Part(Craft, V3(15, 9.5, 0.5), BridgeFront.CFrame*CN(0, 6.25, 0), "Navy blue", "SmoothPlastic", 0.75) BridgeFrontWindow.Name = "Glass"
	DecalFaces(BridgeFrontWindow, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, "rbxassetid://67331799", 0.5)
	local BridgeRight = Part(Craft, V3(1, 3, 22), BridgeCeiling.CFrame*CN(8, -13.5, 0), "Medium stone grey", "DiamondPlate")
	local BridgeRightA = Part(Craft, V3(1, 3, 22), BridgeCeiling.CFrame*CN(8, -1, 0), "Medium stone grey", "DiamondPlate")
	local BridgeRight2 = Part(Craft, V3(1, 9.5, 1), BridgeRight.CFrame*CN(0, 6.25, 0), "Medium stone grey", "DiamondPlate")
	local BridgeRight3 = Part(Craft, V3(1, 9.5, 1), BridgeRight.CFrame*CN(0, 6.25, -10.5), "Medium stone grey", "DiamondPlate")
	local BridgeRight4 = Part(Craft, V3(1, 9.5, 1), BridgeRight.CFrame*CN(0, 6.25, 10.5), "Medium stone grey", "DiamondPlate")
	local BridgeRightWindow = Part(Craft, V3(0.5, 9.5, 20), BridgeRight.CFrame*CN(0, 6.25, 0), "Navy blue", "SmoothPlastic", 0.75) BridgeRightWindow.Name = "Glass"
	DecalFaces(BridgeRightWindow, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, "rbxassetid://67331799", 0.5)
	local BridgeLeft = Part(Craft, V3(1, 15.5, 8.5), BridgeCeiling.CFrame*CN(-8, -7.25, 6.75), "Medium stone grey", "DiamondPlate")
	local BridgeLeft2 = Part(Craft, V3(1, 15.5, 8.5), BridgeCeiling.CFrame*CN(-8, -7.25, -6.75), "Medium stone grey", "DiamondPlate")
	local BridgeLeft3 = Part(Craft, V3(1, 6.5, 5), BridgeCeiling.CFrame*CN(-8, -2.75, 0), "Medium stone grey", "DiamondPlate")
	Curve(Craft, BridgeCeiling.CFrame*CN(-8, -9.5, 0)*CA(-90, 0, -90), 2.75, 180, 5, 1.5, 0.95, "Medium stone grey", "DiamondPlate")
	OfficeChair(Craft, BridgeCeiling.CFrame*CN(1.5, -15, -5)*CA(0, math.random(-15, 15), 0), "Black")
	local FrontDesk = Desk(Craft, BridgeCeiling.CFrame*CN(1.5, -15, -8)*CA(0, 180, 0), 10, 4, "Reddish brown", "Wood")
	Laptop(Craft, FrontDesk.CFrame*CN(-0.05, 0.5, 0), math.random(15, 75), "Medium stone grey")
	Laptop(Craft, FrontDesk.CFrame*CN(2.05, 0.5, 0), math.random(15, 75), "Black")
	PottedPlant(Craft, FrontDesk.CFrame*CN(7, -4, 0))
	StackOfPapers(Craft, FrontDesk.CFrame*CN(-3, 0.5, 0)*CA(0, math.random(-180, 180), 0), 2)
	Mug(Craft, FrontDesk.CFrame*CN(4, 0, 0), 1.5, "Black")
	local BackDesk = Desk(Craft, BridgeCeiling.CFrame*CN(0, -15, 8), 14, 4, "Reddish brown", "Wood")
	local Map = Part(Craft, V3(3, 1, 3), BackDesk.CFrame*CN(0, 0.1, 0)*CA(0, math.random(-5, 5), 0), "Brick yellow", "Slate")
	DecalFaces(Map, {"Top"}, "rbxassetid://20767941")
	Compass(Craft, BackDesk.CFrame*CN(2.5, 0.5, 0)*CA(0, 30, 0), 1)
	StackOfPapers(Craft, BackDesk.CFrame*CN(-4, 0.5, 0)*CA(0, math.random(-180, 180), 0), 2)
	RadioDish(Craft, BridgeCeiling.CFrame*CN(0, 0.5, 0), CA(45, 90, 0))
	CrateTriangle(Craft, V3(20, 10, 10), CFrame*CN(0, 1.5, -15+15)*CA(0, math.random(-15, 15), 0), "Brown", "Wood", "rbxassetid://110093185", "rbxassetid://110093179", "rbxassetid://110093185") --Shipping container
	ThumbnailPeeps(Craft, CFrame*CN(0, 1.5, -25))
	return Hull
end
function Dumpster(Parent, CFrame, Color, Material)
	local Dumpster = New'Model'{Parent = Parent, Name = "Dumpster"}
	local DumpsterFloor = Part(Dumpster, V3(17, 0.75, 27), CFrame*CN(0, 0.375, 0), Color, Material)
	local DumpsterFloor2 = Part(Dumpster, V3(15, 0.5, 25), DumpsterFloor.CFrame*CN(0, 0.625, 0), Color, Material)
	local DumpsterEnd = Part(Dumpster, V3(15, 5, 0.5), DumpsterFloor2.CFrame*CN(0, 0, 12.5)*CA(45, 0, 0)*CN(0, 2.5, 0), Color, Material)
	local DumpsterEnd2 = Part(Dumpster, V3(15, 5, 0.5), DumpsterEnd.CFrame*CN(0, 2.5, 0)*CA(-45, 0, 0)*CN(0, 2.5, 0), Color, Material)
	local DumpsterEnd3 = Part(Dumpster, V3(15, 5, 0.5), DumpsterFloor2.CFrame*CN(0, 0, -12.5)*CA(-45, 0, 0)*CN(0, 2.5, 0), Color, Material)
	local DumpsterEnd4 = Part(Dumpster, V3(15, 5, 0.5), DumpsterEnd3.CFrame*CN(0, 2.5, 0)*CA(45, 0, 0)*CN(0, 2.5, 0), Color, Material)
	local TopEdgeFront = ConnectPoints(Dumpster, DumpsterEnd2.CFrame*CN(8.375, 2.5, 0), DumpsterEnd2.CFrame*CN(-8.375, 2.5, 0), 0.75, 0.75, Color, Material)
	local TopEdgeBack = ConnectPoints(Dumpster, DumpsterEnd4.CFrame*CN(8.375, 2.5, 0), DumpsterEnd4.CFrame*CN(-8.375, 2.5, 0), 0.75, 0.75, Color, Material)
	for A = -1, 1, 2 do
		local TopFace = ConnectPoints(Dumpster, DumpsterEnd2.CFrame*CN(A*7.25, 0, 0), DumpsterEnd4.CFrame*CN(A*7.25, 0, 0), 0.5, 5, Color, Material)
		local TopEdge = ConnectPoints(Dumpster, DumpsterEnd2.CFrame*CN(A*7.625, 2.5, 0), DumpsterEnd4.CFrame*CN(A*7.625, 2.5, 0), 1.5, 0.75, Color, Material)
		TriangleConnect(Dumpster, {DumpsterEnd.CFrame*CN(A*7.25, 2.5, 0), DumpsterEnd.CFrame*CN(A*7.25, -2.5, 0), DumpsterEnd3.CFrame*CN(A*7.25, 2.5, 0)}, 0.5, Color, Material)
		TriangleConnect(Dumpster, {DumpsterEnd3.CFrame*CN(A*7.25, 2.5, 0), DumpsterEnd3.CFrame*CN(A*7.25, -2.5, 0), DumpsterEnd.CFrame*CN(A*7.25, -2.5, 0)}, 0.5, Color, Material)
	end
	for A = -1, 1 do
		local Size = math.random(5, 8)
		Trashbags(Dumpster, DumpsterFloor2.CFrame*CN(0, 0.25, A*7)*CA(0, math.random(-180, 180), 0), V3(8, 8, 8))
	end
end
function Dumpster2(Parent, CFrame)
	local Dumpster = Part(Parent, V3(12.5, 9, 6), CFrame*CN(0, 5.25, 0))
	Mesh(Dumpster, "FileMesh", V3(1.5, 1.5, 1.5), DumpsterMesh, DumpsterTex)
	Dumpster.Name = "Green Dumpster"
	return Dumpster
end
function Trashbin(Parent, CFrame)
	local Trashbin = Part(Parent, V3(3, 4, 3), CFrame*CN(0, 2.25, 0), "", "SmoothPlastic", 0, "Cylinder")
	local Me = Mesh(Trashbin, "FileMesh", V3(3, 3, 3), TrashbinMesh, TrashbinTex)
	Me.VertexColor = V3(0.5, 0.5, 0.5)
	Trashbin.Name = "Trashbin"
	return Trashbin
end
function Dock(Parent, CFrame, PlankSize, NumberOfPlanks, Spacing, DockHeight, SupportSpacing, DockOffset, Randomness, Colors, Materials)
	local Dock = New'Model'{Parent = Parent, Name = "Dock"}
	local DockLength = PlankSize.Z*NumberOfPlanks+Spacing*(NumberOfPlanks-1)
	local InvisiblePlatform = Part(Dock, V3(PlankSize.X, 0.5, DockLength+PlankSize.Z*0.75), CFrame*CN(0, 0, -DockOffset*(DockLength/2+PlankSize.Z*0.375)), "", "SmoothPlastic", 1)
	local FirstPlank, LastPlank
	for D = 1, NumberOfPlanks do
		local Plank = Part(Dock, PlankSize, CFrame*CN(0, 0, DockLength/2-DockOffset*DockLength/2-(PlankSize.Z+Spacing)*D)*CA(0, math.random(-Randomness, Randomness), 0), Colors[1], Materials[1])
		Plank.CanCollide = false
		if D%SupportSpacing == 0 then
			local Support = Part(Dock, V3(PlankSize.Z, DockHeight, PlankSize.Z), Plank.CFrame*CN(PlankSize.X/2-PlankSize.Z*0.5, -DockHeight/2, 0), Colors[2], Materials[2])
			Cylinder(Support)
			local Support2 = Part(Dock, V3(PlankSize.Z, DockHeight, PlankSize.Z), Plank.CFrame*CN(-PlankSize.X/2+PlankSize.Z*0.5, -DockHeight/2, 0), Colors[2], Materials[2])
			Cylinder(Support2)
		end
		if D == 1 then
			FirstPlank = Plank
		elseif D == NumberOfPlanks then
			LastPlank = Plank
		end
	end
	ConnectPoints(Dock, FirstPlank.CFrame*CN(PlankSize.X/2-PlankSize.Z*1.5, -PlankSize.Y, 0), LastPlank.CFrame*CN(PlankSize.X/2-PlankSize.Z*1.5, -PlankSize.Y, 0), PlankSize.Z, PlankSize.Y, Colors[3], Materials[3])
	ConnectPoints(Dock, FirstPlank.CFrame*CN(-PlankSize.X/2+PlankSize.Z*1.5, -PlankSize.Y, 0), LastPlank.CFrame*CN(-PlankSize.X/2+PlankSize.Z*1.5, -PlankSize.Y, 0), PlankSize.Z, PlankSize.Y, Colors[3], Materials[3])
	ConnectPoints(Dock, FirstPlank.CFrame*CN(0, -PlankSize.Y, 0), LastPlank.CFrame*CN(0, -PlankSize.Y, 0), PlankSize.Z, PlankSize.Y, Colors[3], Materials[3])
end
function MenacingBuilding(Parent, CFrame, Floors)
	local Building = New'Model'{Parent = Parent, Name = "Big Scary Building"}
	for F = 0, Floors do
	--local F = 0
	local Base = Part(Building, V3(160, 1, 50), CFrame*CN(0, F*17, F*50), "Dark stone grey", "Concrete")
	local WallBack = Part(Building, V3(160, 3, 1), Base.CFrame*CN(0, 2, 24.5), "Medium stone grey", "Concrete")
	local WallBackTop = Part(Building, V3(160, 12, 1), WallBack.CFrame*CN(0, 7.5, 0), "Medium stone grey", "Concrete")
	
	local Dir = (0.5-F%2)*2
	for T = 0, 15 do
		local Step = Part(Building, V3(10, 1, 1), Base.CFrame*CN(0, 1+T, 9.5+Dir*T), "Dark stone grey", "Concrete")
	end
	
	local StepCeiling = Part(Building, V3(61, 1, 30), Base.CFrame*CN(0, 33, 10), "Dark stone grey", "Concrete")
	for W = -1, 1, 2 do
		local StepWall = Part(Building, V3(1, 16, 30), Base.CFrame*CN(W*30, 24.5, 10), "Medium stone grey", "Concrete")
		
		if F==Floors then
			--Ladder
			for L=0,16 do
				local Ladder = Part(Building, V3(1, 0.5, 8), StepWall.CFrame*CN(W*1, -7+L*1, 0), "Dark stone grey", "DiamondPlate")
			end
		end
		
		local StepWallFront = Part(Building, V3(24.5, 3, 1), Base.CFrame*CN(W*17.25, 18, -4.5), "Medium stone grey", "Concrete")
		--window sides
		local StepWallFront2 = Part(Building, V3(12.25-1, 10, 1), StepWallFront.CFrame*CN(6.625, 6.5, 0), "Medium stone grey", "Concrete")
		local StepWallFront3 = Part(Building, V3(12.25-1, 10, 1), StepWallFront.CFrame*CN(-6.625, 6.5, 0), "Medium stone grey", "Concrete")
	end
	local DoorTop = Part(Building, V3(59, 3, 1), StepCeiling.CFrame*CN(0, -2, -14.5), "Medium stone grey", "Concrete")
	
	if F==Floors then
		local TopOfficeFloor = Part(Building, V3(61, 1, 50), WallBackTop.CFrame*CN(0, 6.5, 25.5), "Dark stone grey", "Concrete")
		local TopOfficeCeiling = Part(Building, V3(61, 1, 50), TopOfficeFloor.CFrame*CN(0, 17, 0), "Dark stone grey", "Concrete")
		
		for W = -1, 1, 2 do
			local TopOfficeWall = Part(Building, V3(1, 16, 50), TopOfficeFloor.CFrame*CN(W*30, 8.5, 0), "Medium stone grey", "Concrete")
			local TopOfficeWallBack = Part(Building, V3(27, 16, 1), TopOfficeFloor.CFrame*CN(W*16, 8.5, 24.5), "Medium stone grey", "Concrete")
		end
		local TopOfficeWallBackMid = Part(Building, V3(5, 8, 1), TopOfficeFloor.CFrame*CN(0, 4.5, 24.5), "Medium stone grey", "Concrete")
		local TopOfficeWallBackMidTop = Part(Building, V3(5, 3, 1), TopOfficeWallBackMid.CFrame*CN(0, 10.5, 0), "Medium stone grey", "Concrete")
		
		local PartyFloor = Part(Building, V3(61, 1, 50), TopOfficeFloor.CFrame*CN(0, 0, 50), "Dark stone grey", "Concrete")
		
		local buildingSupport = Part(Building, V3(20, (Floors+1)*16, 20), PartyFloor.CFrame*CN(0, -0.5-(Floors+1)*8, 0), "Dark stone grey", "Concrete")
		Cylinder(buildingSupport)
		
		--the top thang
		
		local Stump = Part(Building, V3(20, 14, 14), TopOfficeCeiling.CFrame*CN(0, 7.5, 0), "Medium stone grey", "DiamondPlate")
		for S=-1,1,2 do
			local Stump2 = Wedge(Building, V3(14, 14, 10), Stump.CFrame*CN(S*15, 0, 0)*CA(0, S*-90, 0), "Medium stone grey", "DiamondPlate")
			
			local HornStart = Part(Building, V3(15, 10, 13), Stump.CFrame*CN(0, 4, 0)*CA(0, 0, S*0)*CN(S*7.5, 0, 0), "Dark stone grey", "DiamondPlate")
			local lastHorn = HornStart
			for H=1,5 do
				local newHorn = Part(Building, V3(30, 10-H, 13-H), lastHorn.CFrame*CN(S*(lastHorn.Size.X/2-5), 0, 0)*CA(0, 0, S*15)*CN(S*15, 0, 0), "Dark stone grey", "DiamondPlate")
				lastHorn = newHorn
			end
		end
	else
		--if it's not the top
		--columns
	end
	
	if F%2 == 0 then
		local CeilingFill = Part(Building, V3(10, 1, 35), Base.CFrame*CN(0, 16, -7.5), "Dark stone grey", "Concrete")
	else
		local CeilingFill = Part(Building, V3(10, 1, 19), Base.CFrame*CN(0, 16, -15.5), "Dark stone grey", "Concrete")
		local CeilingFill2 = Part(Building, V3(10, 1, 17), Base.CFrame*CN(0, 16, 16.5), "Dark stone grey", "Concrete")
	end
	
	for S = -1, 1, 2 do
		local Wall = Part(Building, V3(75, 3, 1), Base.CFrame*CN(42.5*S, 2, -24.5), "Medium stone grey", "Concrete")
		local Ceiling = Part(Building, V3(75, 1, 50), Base.CFrame*CN(42.5*S, 16, 0), "Dark stone grey", "Concrete")
		local Base2 = Part(Building, V3(80, 1, 50), Base.CFrame*CN(80*S, 0, 0)*CA(0, 30*S, 0)*CN(40*S, 0, 0), "Dark stone grey", "Concrete")
		local Ceiling2 = Part(Building, V3(80, 1, 50), Base2.CFrame*CN(0, 16, 0), "Dark stone grey", "Concrete")
		local Base3 = Part(Building, V3(80, 1, 50), Base2.CFrame*CN(40*S, 0, 0)*CA(0, 60*S, 0)*CN(40*S, 0, 0), "Dark stone grey", "Concrete")
		local Ceiling3 = Part(Building, V3(80, 1, 50), Base3.CFrame*CN(0, 16, 0), "Dark stone grey", "Concrete")
		--Fill in the gaps
		TriangleConnect(Building, {Base.CFrame*CN(80*S, 0, 0), Base.CFrame*CN(80*S, 0, 25), Base2.CFrame*CN(-40*S, 0, 25)}, 1, "Dark stone grey", "Concrete")
		TriangleConnect(Building, {Base2.CFrame*CN(40*S, 0, 0), Base2.CFrame*CN(40*S, 0, 25), Base3.CFrame*CN(-40*S, 0, 25)}, 1, "Dark stone grey", "Concrete")
		--Ceiling gaps
		TriangleConnect(Building, {Base.CFrame*CN(80*S, 16, 0), Base.CFrame*CN(80*S, 16, 25), Base2.CFrame*CN(-40*S, 16, 25)}, 1, "Dark stone grey", "Concrete")
		TriangleConnect(Building, {Base2.CFrame*CN(40*S, 16, 0), Base2.CFrame*CN(40*S, 16, 25), Base3.CFrame*CN(-40*S, 16, 25)}, 1, "Dark stone grey", "Concrete")
		local GapWall = ConnectPoints(Building, Base.CFrame*CN(79.85*S, 8, 24.5), Base2.CFrame*CN(-39.85*S, 8, 24.5), 1, 15, "Medium stone grey", "Concrete")
		local GapWall2 = ConnectPoints(Building, Base2.CFrame*CN(39.85*S, 8, 24.5), Base3.CFrame*CN(-39.85*S, 8, 24.5), 1, 15, "Medium stone grey", "Concrete")
		--Walls and stuff
		local Wall2 = Part(Building, V3(80, 3, 1), Base2.CFrame*CN(0, 2, -24.5), "Medium stone grey", "Concrete")
		Intersect(Wall, Wall2, "X")
		local Wall2Back = Part(Building, V3(80, 3, 1), Base2.CFrame*CN(0, 2, 24.5), "Medium stone grey", "Concrete")
		local Wall2BackTop = Part(Building, V3(80, 12, 1), Wall2Back.CFrame*CN(0, 7.5, 0), "Medium stone grey", "Concrete")
		local Wall3 = Part(Building, V3(80, 3, 1), Base3.CFrame*CN(0, 2, -24.5), "Medium stone grey", "Concrete")
		Intersect(Wall2, Wall3, "X")
		local Wall3Back = Part(Building, V3(80, 3, 1), Base3.CFrame*CN(0, 2, 24.5), "Medium stone grey", "Concrete")
		local Wall3BackTop = Part(Building, V3(80, 12, 1), Wall3Back.CFrame*CN(0, 7.5, 0), "Medium stone grey", "Concrete")
		--Wall tops
		local WallTop = Part(Building, V3(Wall.Size.X, 12, 1), Wall.CFrame*CN(0, 7.5, 0), "Medium stone grey", "Concrete")
		local Wall2Top = Part(Building, V3(Wall2.Size.X, 12, 1), Wall2.CFrame*CN(0, 7.5, 0), "Medium stone grey", "Concrete")
		local Wall3Top = Part(Building, V3(Wall3.Size.X, 12, 1), Wall3.CFrame*CN(0, 7.5, 0), "Medium stone grey", "Concrete")
		--Ends/Circle Parts
		local TowerFloor = Curve(Building, Base3.CFrame*CN((40+math.pi*25/10/2)*S, 0, 0)*CA(0, 90*S, 0), 0, 180, 10, 25, 1, "Dark stone grey", "Concrete")
		local TowerCeil = Curve(Building, Base3.CFrame*CN((40+math.pi*25/10/2)*S, 16, 0)*CA(0, 90*S, 0), 0, 180, 10, 25, 1, "Dark stone grey", "Concrete")
		local TowerWalls = Curve(Building, Base3.CFrame*CN((40+math.pi*25/10/2)*S, 8, 0)*CA(0, 90*S, 0), 24, 180, 10, 1, 15, "Medium stone grey", "Concrete"):GetChildren()
		Resize(TowerWalls[6], V3(TowerWalls[6].Size.X, 5, 1), TowerWalls[6].CFrame*CN(0, 5, 0))
		Resize(TowerWalls[3], V3(TowerWalls[3].Size.X, 3, 1), TowerWalls[3].CFrame*CN(0, -6, 0))
		Resize(TowerWalls[9], V3(TowerWalls[9].Size.X, 3, 1), TowerWalls[9].CFrame*CN(0, -6, 0))
		local WindowTop = Part(Building, V3(TowerWalls[3].Size.X, 5, 1), TowerWalls[3].CFrame*CN(0, 11, 0), "Medium stone grey", "Concrete")
		local WindowTop2 = Part(Building, V3(TowerWalls[9].Size.X, 5, 1), TowerWalls[9].CFrame*CN(0, 11, 0), "Medium stone grey", "Concrete")
	end
	end
	return Building
end
function HotAirBalloon(Parent, CFrame, ColorType, NormalColors, Colors, ColorMethod)
	local Balloon = New'Model'{Parent = Parent, Name = "Hot Air Balloon"}
	--Basket
	local BasketFloor = Part(Balloon, V3(8, 1, 8), CFrame*CN(0, 0.5, 0), NormalColors[1], "Wood")
	local BasketFloor2 = Part(Balloon, V3(6, 1, 6), BasketFloor.CFrame*CN(0, 0.2, 0), NormalColors[2], "Wood")
	Cylinder(BasketFloor2)
	DecalFaces(BasketFloor2, {"Top"}, "rbxassetid://114351360")
	for S = 1, 4 do
		local BasketWall = Part(Balloon, V3(6, 4, 0.5), BasketFloor.CFrame*CA(0, S*90, 0)*CN(0, 2, -3.75), NormalColors[1], "Wood")
		local BasketWallCorner = Part(Balloon, V3(1.5, 4, 1.5), BasketWall.CFrame*CN(3.75, 0, 0), NormalColors[3], "Wood")
		Cylinder(BasketWallCorner)
		local String = ConnectPoints(Balloon, BasketWallCorner.CFrame*CN(0, 2, 0), BasketFloor.CFrame*CA(0, S*90-45, 0)*CN(0, 14, -6), 0.25, 0.25, NormalColors[5])
		String.CanCollide = false
		--local String2 = ConnectPoints(Balloon, String.CFrame, BasketFloor.CFrame*CA(0, S*90-45, 0)*CN(0, 14, 6), 0.25, 0.25, "White")
		--String2.CanCollide = false
		local StringConnectPointInLip = Part(Balloon, V3(0.75, 0.75, 0.75), BasketFloor.CFrame*CA(0, S*90+45, 0)*CN(0, 14, 6), NormalColors[6], "Wood")
		local BasketWall2 = Part(Balloon, V3(7.5, 4, 0.5), BasketWall.CFrame*CN(0, 0, -0.5), NormalColors[3], "Wood")
	end
	--I KNOW I COULD HAVE MADE THIS INTO A FOR LOOP >:(
	local Lip = Curve(Balloon, BasketFloor.CFrame*CN(0, 14, 0), 6, 360, 20, 1, 1, NormalColors[4], "Wood"):GetChildren()
	local Level1 = Curve(Balloon, BasketFloor.CFrame*CN(0, 18, 0)*CA(0, 15, 0), 7, 360, 20, 1, 1, NormalColors[5]):GetChildren()
	local Level2 = Curve(Balloon, BasketFloor.CFrame*CN(0, 28, 0)*CA(0, 30, 0), 14, 360, 20, 1, 1, NormalColors[5]):GetChildren()
	local Level3 = Curve(Balloon, BasketFloor.CFrame*CN(0, 53, 0)*CA(0, 45, 0), 28, 360, 20, 1, 1, NormalColors[5]):GetChildren()
	local Level4 = Curve(Balloon, BasketFloor.CFrame*CN(0, 78, 0)*CA(0, 60, 0), 35, 360, 20, 1, 1, NormalColors[5]):GetChildren()
	local Level5 = Curve(Balloon, BasketFloor.CFrame*CN(0, 92, 0)*CA(0, 75, 0), 28, 360, 20, 1, 1, NormalColors[5]):GetChildren()
	local Level6 = Curve(Balloon, BasketFloor.CFrame*CN(0, 107, 0)*CA(0, 90, 0), 7, 360, 20, 1, 1, NormalColors[5]):GetChildren()
	for C = 1, 20 do
		local Lip1 = TriangleConnect(Balloon, {Lip[C].CFrame*CN(-Lip[C].Size.X/2, 0, 0), Level1[C].CFrame*CN(-Level1[C].Size.X/2, 0, 0), Level1[C].CFrame*CN(Level1[C].Size.X/2, 0, 0)}, 0.1, Colors[1])
		local Lip2 = TriangleConnect(Balloon, {Lip[C].CFrame*CN(-Lip[C].Size.X/2, 0, 0), Lip[C].CFrame*CN(Lip[C].Size.X/2, 0, 0), Level1[C].CFrame*CN(Level1[C].Size.X/2, 0, 0)}, 0.1, Colors[1])
		local Level1A = TriangleConnect(Balloon, {Level1[C].CFrame*CN(-Level1[C].Size.X/2, 0, 0), Level2[C].CFrame*CN(-Level2[C].Size.X/2, 0, 0), Level2[C].CFrame*CN(Level2[C].Size.X/2, 0, 0)}, 0.1, Colors[2%#Colors] or Colors[#Colors%2] or Colors[2])
		local Level1B = TriangleConnect(Balloon, {Level1[C].CFrame*CN(-Level1[C].Size.X/2, 0, 0), Level1[C].CFrame*CN(Level1[C].Size.X/2, 0, 0), Level2[C].CFrame*CN(Level2[C].Size.X/2, 0, 0)}, 0.1, Colors[2%#Colors] or Colors[#Colors%2] or Colors[2])
		local Level2A = TriangleConnect(Balloon, {Level2[C].CFrame*CN(-Level2[C].Size.X/2, 0, 0), Level3[C].CFrame*CN(-Level3[C].Size.X/2, 0, 0), Level3[C].CFrame*CN(Level3[C].Size.X/2, 0, 0)}, 0.1, Colors[3%#Colors] or Colors[#Colors%3] or Colors[3])
		local Level2B = TriangleConnect(Balloon, {Level2[C].CFrame*CN(-Level2[C].Size.X/2, 0, 0), Level2[C].CFrame*CN(Level2[C].Size.X/2, 0, 0), Level3[C].CFrame*CN(Level3[C].Size.X/2, 0, 0)}, 0.1, Colors[3%#Colors] or Colors[#Colors%3] or Colors[3])
		local Level3A = TriangleConnect(Balloon, {Level3[C].CFrame*CN(-Level3[C].Size.X/2, 0, 0), Level4[C].CFrame*CN(-Level4[C].Size.X/2, 0, 0), Level4[C].CFrame*CN(Level4[C].Size.X/2, 0, 0)}, 0.1, Colors[4%#Colors] or Colors[#Colors%4] or Colors[4])
		local Level3B = TriangleConnect(Balloon, {Level3[C].CFrame*CN(-Level3[C].Size.X/2, 0, 0), Level3[C].CFrame*CN(Level3[C].Size.X/2, 0, 0), Level4[C].CFrame*CN(Level4[C].Size.X/2, 0, 0)}, 0.1, Colors[4%#Colors] or Colors[#Colors%4] or Colors[4])
		local Level4A = TriangleConnect(Balloon, {Level4[C].CFrame*CN(-Level4[C].Size.X/2, 0, 0), Level5[C].CFrame*CN(-Level5[C].Size.X/2, 0, 0), Level5[C].CFrame*CN(Level5[C].Size.X/2, 0, 0)}, 0.1, Colors[5%#Colors] or Colors[#Colors%5] or Colors[5])
		local Level4B = TriangleConnect(Balloon, {Level4[C].CFrame*CN(-Level4[C].Size.X/2, 0, 0), Level4[C].CFrame*CN(Level4[C].Size.X/2, 0, 0), Level5[C].CFrame*CN(Level5[C].Size.X/2, 0, 0)}, 0.1, Colors[5%#Colors] or Colors[#Colors%5] or Colors[5])
		local Level5A = TriangleConnect(Balloon, {Level5[C].CFrame*CN(-Level5[C].Size.X/2, 0, 0), Level6[C].CFrame*CN(-Level6[C].Size.X/2, 0, 0), Level6[C].CFrame*CN(Level6[C].Size.X/2, 0, 0)}, 0.1, Colors[6%#Colors] or Colors[#Colors%6] or Colors[6])
		local Level5B = TriangleConnect(Balloon, {Level5[C].CFrame*CN(-Level5[C].Size.X/2, 0, 0), Level5[C].CFrame*CN(Level5[C].Size.X/2, 0, 0), Level6[C].CFrame*CN(Level6[C].Size.X/2, 0, 0)}, 0.1, Colors[6%#Colors] or Colors[#Colors%6] or Colors[6])
		if ColorMethod == 1 then
			ColorModel(Lip1, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[#Colors])
			ColorModel(Lip2, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[#Colors])
			ColorModel(Level1A, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[#Colors])
			ColorModel(Level1B, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[#Colors])
			ColorModel(Level2A, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[#Colors])
			ColorModel(Level2B, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[#Colors])
			ColorModel(Level3A, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[#Colors])
			ColorModel(Level3B, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[#Colors])
			ColorModel(Level4A, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[#Colors])
			ColorModel(Level4B, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[#Colors])
			ColorModel(Level5A, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[#Colors])
			ColorModel(Level5B, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[#Colors])
		elseif ColorMethod == 2 then
			ColorModel(Lip1, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[1])
			ColorModel(Lip2, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[1])
			ColorModel(Level1A, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[1])
			ColorModel(Level1B, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[1])
			ColorModel(Level2A, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[1])
			ColorModel(Level2B, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[1])
			ColorModel(Level3A, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[1])
			ColorModel(Level3B, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[1])
			ColorModel(Level4A, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[1])
			ColorModel(Level4B, Colors[C%#Colors] or Colors[#Colors%C] or Colors[C] or Colors[1])
			ColorModel(Level5A, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[1])
			ColorModel(Level5B, Colors[(C-1)%#Colors] or Colors[#Colors%(C-1)] or Colors[C-1] or Colors[1])
		elseif ColorMethod == 3 then
			Lip1:GetChildren()[1].BrickColor = BN(Colors[2%#Colors] or Colors[#Colors%2] or Colors[2])
			Lip1:GetChildren()[2].BrickColor = BN(Colors[1])
			Lip2:GetChildren()[1].BrickColor = BN(Colors[2%#Colors] or Colors[#Colors%2] or Colors[2])
			Lip2:GetChildren()[2].BrickColor = BN(Colors[1])
			Level1A:GetChildren()[1].BrickColor = BN(Colors[4%#Colors] or Colors[#Colors%4] or Colors[4])
			Level1A:GetChildren()[2].BrickColor = BN(Colors[3%#Colors] or Colors[#Colors%3] or Colors[3])
			Level1B:GetChildren()[1].BrickColor = BN(Colors[4%#Colors] or Colors[#Colors%4] or Colors[4])
			Level1B:GetChildren()[2].BrickColor = BN(Colors[3%#Colors] or Colors[#Colors%3] or Colors[3])
			Level2A:GetChildren()[1].BrickColor = BN(Colors[6%#Colors] or Colors[#Colors%6] or Colors[6])
			Level2A:GetChildren()[2].BrickColor = BN(Colors[5%#Colors] or Colors[#Colors%5] or Colors[5])
			Level2B:GetChildren()[1].BrickColor = BN(Colors[6%#Colors] or Colors[#Colors%6] or Colors[6])
			Level2B:GetChildren()[2].BrickColor = BN(Colors[5%#Colors] or Colors[#Colors%5] or Colors[5])
			Level3A:GetChildren()[1].BrickColor = BN(Colors[8%#Colors] or Colors[#Colors%8] or Colors[8])
			Level3A:GetChildren()[2].BrickColor = BN(Colors[7%#Colors] or Colors[#Colors%7] or Colors[7])
			Level3B:GetChildren()[1].BrickColor = BN(Colors[8%#Colors] or Colors[#Colors%8] or Colors[8])
			Level3B:GetChildren()[2].BrickColor = BN(Colors[7%#Colors] or Colors[#Colors%7] or Colors[7])
			Level4A:GetChildren()[1].BrickColor = BN(Colors[10%#Colors] or Colors[#Colors%10] or Colors[10])
			Level4A:GetChildren()[2].BrickColor = BN(Colors[9%#Colors] or Colors[#Colors%9] or Colors[9])
			Level4B:GetChildren()[1].BrickColor = BN(Colors[10%#Colors] or Colors[#Colors%10] or Colors[10])
			Level4B:GetChildren()[2].BrickColor = BN(Colors[9%#Colors] or Colors[#Colors%9] or Colors[9])
			Level5A:GetChildren()[1].BrickColor = BN(Colors[12%#Colors] or Colors[#Colors%12] or Colors[12])
			Level5A:GetChildren()[2].BrickColor = BN(Colors[11%#Colors] or Colors[#Colors%11] or Colors[11])
			Level5B:GetChildren()[1].BrickColor = BN(Colors[12%#Colors] or Colors[#Colors%12] or Colors[12])
			Level5B:GetChildren()[2].BrickColor = BN(Colors[11%#Colors] or Colors[#Colors%11] or Colors[11])
		elseif ColorMethod == 4 then
			ColorModel(Lip1, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Lip2, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level1A, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level1B, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level2A, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level2B, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level3A, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level3B, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level4A, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level4B, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level5A, Colors[C%#Colors] or Colors[#Colors])
			ColorModel(Level5B, Colors[C%#Colors] or Colors[#Colors])
		end
	end
	return Balloon, BasketFloor
end
function MoriaMap(Parent, CFrame)
	local Map = New'Model'{Parent = Parent, Name = "War Blox 2 Map"}
	local MiddleFloor = Part(Map, V3(100, 1, 100), CFrame, "Medium stone grey", "Slate")
	--Pyramid(Map, CFrame*CN(0, 0.5, 0), 60, 40, "Brick yellow", "Sand")
	for N = 1, 4 do
		for S = 1, 11 do
			local Step = Part(Map, V3(100, 1, 4), CFrame*CA(0, N*90, 0)*CN(0, S-1, 50+S*2), "Medium stone grey", "Slate")
		end
		local Pillar = Part(Map, V3(24, 151, 24), CFrame*CA(0, N*90, 0)*CN(50+12, 75, 50+12), "Medium stone grey", "Slate")
		local PillarBottom = Part(Map, V3(28, 15, 28), Pillar.CFrame*CN(0, -67.5, 0), "Dark stone grey", "Slate")
		--for T = 0, 6 do
			--local PillarTop = Part(Map, V3(20-T*3, 10, 20-T*3), Pillar.CFrame*CN(0, 80+T*10, 0), "Medium stone grey", "Slate")
		--end
		Pyramid(Map, Pillar.CFrame*CN(0, 75, 0), 20, 40, "Dark stone grey", "Slate")
		local OuterFloor = Part(Map, V3(148, 1, 148), CFrame*CA(0, N*90, 0)*CN(0, 10, 148), "Medium stone grey", "Slate")
		local OuterFloorCorner = Part(Map, V3(148, 1, 148), CFrame*CA(0, N*90, 0)*CN(148, 10, 148), "Medium stone grey", "Slate")
		for A = 0, 1 do
			local Arch = Curve(Map, CFrame*CA(0, N*90, 0)*CN(0, 17.5+A*50, 50+12)*CA(-90, 0, 0), 75, 90, 10, 20, 20, "Medium stone grey", "Slate")
		end
		local BetweenArch = Part(Map, V3(100, 50, 15), CFrame*CA(0, N*90, 0)*CN(0, 122.5, 50+12), "Dark stone grey", "Slate")
	end
	for P = 1, 4 do
		local Block = Part(Map, V3(15, 7, 15), CFrame*CA(0, P*90, 0)*CN(0, 14, 150), "Medium stone grey", "Slate")
		local Sand = Part(Map, V3(14, 1, 14), Block.CFrame*CN(0, 3.1, 0), "Brick yellow", "Sand")
		local BarkColors = {"Fawn brown", "Bronze", "Cork", "Nougat", "Burlap", "Pastel brown"}
		local LeafColors = {"Grime", "Artichoke", "Olivine", "Medium green", "Moss", "Shamrock"}
		local BranchColors = {"Pine Cone", "Fawn brown", "Bronze", "Dark taupe", "Flint", "Brown", "Cork", "Nougat", "Cashmere", "Burlap", "Beige", "Pastel brown"}
		local SizeX, SizeY = math.random(40, 70)/10, math.random(80, 130)/10
		PalmTree(Map, Sand.CFrame, 7, V3(-0.2, -0.1, -0.2), V3(SizeX, SizeY, SizeX), {math.random(-13, 13), math.random(-13, 13), math.random(-13, 13)}, 8, 21, V3(-0.025, 0, -0.025), V3(0.75, 1.5, 0.75), {8, -3, 2}, {16, 3, 3}, 2, {BarkColors[math.random(1, #BarkColors)], BranchColors[math.random(1, #BranchColors)], LeafColors[math.random(1, #LeafColors)]}, {"Slate", "Grass", "Grass"})
	end
	for S = 1, 71 do
		local Stair = Part(Map, V3(100, 1, 4), CFrame*CN(0, 9+S, 222+S*2), "Medium stone grey", "Slate")
		local Stair2 = Part(Map, V3(100, 1, 4), CFrame*CN(0, 11-S, -222-S*2), "Medium stone grey", "Slate")
	end
	local StairTop = Part(Map, V3(120, 1, 100+100), CFrame*CN(0, 80, 416+50), "Medium stone grey", "Slate")
	for N = -1, 1, 2 do
		local StairWall = Part(Map, V3(10, 76, 144), CFrame*CN(N*55, 10.5+34.5+2.5, 294), "Medium stone grey", "Slate")
		local AdjacentWall = Part(Map, V3(162, 76, 10), CFrame*CN(N*141, 10.5+34.5+2.5, 227), "Medium stone grey", "Slate")
		local StairTopSides = Part(Map, V3(162, 1, 234+100), CFrame*CN(N*141, 80, 349+50), "Medium stone grey", "Slate")
	end
	MenacingBuilding(Map, CFrame*CN(0, 81, 450))
	RadioTower(Map, CFrame*CN(150, 10.5, 150))
	Turret(Map, CFrame*CN(175, 81, 260), math.random(-180, 180), math.random(0, 45))
	Turret(Map, CFrame*CN(-175, 81, 260), math.random(-180, 180), math.random(0, 45))
	Fountain2(Map, CFrame)
	ThumbnailPeeps(Map, CFrame*CN(0, 1, 0))
	LandingCraft(Map, CFrame*CN(0, 17, 150)*CA(0, 15, 0), -105)
end

ThingsToKill = {}
for _, Obj in pairs(Workspace:GetChildren()) do
	if Obj.Name == "War Blox 2 Map" then
		table.insert(ThingsToKill, Obj)
	end
end

--MoriaMap(Workspace, CN(0, 1, 0))

Map = New'Model'{Parent = Workspace, Name = "War Blox 2 Map"}

MenacingBuilding(Map, CN(0, 1, 0), 1)

--[[Dumpster(Map, CN(0, 0, -100), "Dark stone grey", "Concrete")

Dumpster2(Map, CN(20, 0, -100))

HelicopterPad(Map, CN(50, 1, -100))

Fountain(Map, CN(30, 1, -180))
Fountain2(Map, CN(100, 1, -180))

Turret(Map, CN(-40, 0, -100), 45, 15)

Pyramid(Map, CN(0, 0.5, -350), 200, 100, "Brick yellow", "Sand")]]

for _, Thing in pairs(ThingsToKill) do
	for _, Obj in pairs(Thing:GetChildren()) do
		Obj:Destroy()
		if _%100 == 0 then wait() end
	end
	Thing:Destroy()
end
