--Astrovo
V3, CN, CA, C3, BN = Vector3.new, CFrame.new, CFrame.Angles, Color3.new, BrickColor.new
Map = Map
Name = "Astrovo"
ParentTo = Workspace
Scale = 8000
Split = 4
OS = CN(0, 0, 0)
CliffHeight = 200
CliffWidth = 250
BoundaryHeight = 500
Asset = "rbxassetid://"
function New(Type)
	return function(Set)
		local Object = Instance.new(Type)
		for A, B in pairs(Set) do
			if type(B) ~= "function" then
				Object[A] = B
			else
				Object[A]:connect(B)
			end
		end
		return Object
	end
end
function M(PT, NM)
	return New'Model'{Parent = PT, Name = NM}
end
function P(PT, SZ, CF, CL, MT, TR, AN)
	local AN, TR, MT, CL, CF, SZ = AN or true, TR or 0, MT or "Plastic", CL or "Really black", CF or OS, SZ or V3(1, 1, 1)
	local P = New'Part'{Parent = PT, FormFactor = 3, Size = SZ, BrickColor = BN(CL), Material = MT, Transparency = TR, Anchored = AN, TopSurface = 0, BottomSurface = 0}
	P.CFrame = CF
	return P
end
function WP(PT, SZ, CF, CL, MT, TR, AN)
	local AN, TR, MT, CL, CF, SZ = AN or true, TR or 0, MT or "Plastic", CL or "Really black", CF or OS, SZ or V3(1, 1, 1)
	local WP = New'WedgePart'{Parent = PT, FormFactor = 3, Size = SZ, BrickColor = BN(CL), Material = MT, Transparency = TR, Anchored = AN, TopSurface = 0, BottomSurface = 0}
	WP.CFrame = CF
	return WP
end
function SM(PT, MT, SC, MI, TI)
	local TI, MI, SC, MT = TI or "", MI or "", SC or V3(1, 1, 1), MT or "Sphere"
	return New'SpecialMesh'{Parent = PT, MeshType = MT, MeshId = MI, TextureId = TI, Scale = SC}
end
function CM(PT, SC)
	local SC = SC or V3(1, 1, 1)
	return New'CylinderMesh'{Parent = PT, Scale = SC}
end
function SK(PT, SZ, CL, OP, RV)
	local RV, OP, CL, SZ = RV or 0, OP or 0.5, CL or C3(), SZ or 10
	return New'Smoke'{Parent = PT, Size = SZ, Color = CL, Opacity = OP, RiseVelocity = RV}
end
for _, Object in pairs(ParentTo:GetChildren()) do
	if Object.Name == Name then
		Object:ClearAllChildren()
		Map = Object
	end
end
if Map == Map then
	Map = M(ParentTo, Name)
end
--Boundaries
--[[Boundaries = M(Map, "Boundaries")
for F = 0, Split do
	for F2 = 0, Split do
		local Floor = P(Map, V3(Scale/Split, 1, Scale/Split), OS*CN(F*(Scale/Split)-Scale/2, 0, F2*(Scale/Split)-Scale/2), "Dark green", "Grass")
	end
end
for C = 1, 4 do
	wait(0.1)
	for C2 = 0, Split do
		local Cliff = P(Map, V3(Scale/Split, CliffHeight, CliffWidth), OS*CA(0, math.rad(90)*C, 0)*CN(C2*(Scale/Split)-Scale/2, CliffHeight/2, Scale/2+(Scale/Split)/2), "Reddish brown", "Slate")
	end
end]]
--Other functions
function BoxTriangle(PT, SZ, CF, CL, MT)
	local Group, SPACE = M(PT, "Boxes"), math.ceil(SZ.Y*0.75)
	local B = P(Group, SZ, CF*CN(SPACE, SZ.Y*0.5, 0)*CA(0, math.rad(math.random(-360, 360)), 0), CL, MT)
	local B2 = P(Group, SZ, CF*CN(-SPACE, SZ.Y*0.5, 0)*CA(0, math.rad(math.random(-360, 360)), 0), CL, MT)
	local B3 = P(Group, SZ, CF*CN(0, SZ.Y*1.5, 0)*CA(0, math.rad(math.random(-360, 360)), 0), CL, MT)
	return B, B2, B3
end
function Hangar(PT, CF, Primary)
	local Group = M(PT, "Hangar")
	local Base = P(Group, V3(1000, 1, 1000), CF, Primary, "Concrete")
	for S = 0, 10 do
		local Side = P(Group, V3(5, 160, 1000), CF*CA(0, 0, math.rad(S*18))*CN(500, 0, 0), Primary, "Concrete")
	end
end
function Tower(PT, CF)
	local Group = M(PT, "Tower")
	local Base = P(Group, V3(25, 1, 25), CF, "Medium stone grey", "Concrete")
	local Side1 = P(Group, V3(1, 40, 25), CF*CN(12, 20.5, 0), "Medium stone grey", "Concrete")
	local Side2 = P(Group, V3(1, 40, 25), CF*CN(-12, 20.5, 0), "Medium stone grey", "Concrete")
	local Side3 = P(Group, V3(23, 40, 1), CF*CN(0, 20.5, -12), "Medium stone grey", "Concrete")
	local Side4 = P(Group, V3(23, 34, 1), CF*CN(0, 23.5, 12), "Medium stone grey", "Concrete")
	local Side4A = P(Group, V3(8.5, 6, 1), CF*CN(-7.25, 3.5, 12), "Medium stone grey", "Concrete")
	local Side4B = P(Group, V3(8.5, 6, 1), CF*CN(7.25, 3.5, 12), "Medium stone grey", "Concrete")
	for S = 0, 3 do
		local Side = P(Group, V3(25, 2, 5), CF*CA(0, math.rad(90)*S, 0)*CN(0, 39.5, 15), "Medium stone grey", "Concrete")
		local Corner = P(Group, V3(5, 2, 5), CF*CA(0, math.rad(90)*S, 0)*CN(15, 39.5, 15), "Medium stone grey", "Concrete")
		local CornerSupport = P(Group, V3(2, 10, 2), CF*CA(0, math.rad(90)*S, 0)*CN(12.5, 45.5, 12.5), "Medium stone grey", "Concrete")
		local Ramp = WP(Group, V3(5, 10, 13), CF*CA(0, math.rad(S*90), 0)*CN(-9, 5.5+S*10, 0), "Brown", "Wood")
		local CornerSection = P(Group, V3(5, 10, 5), CF*CA(0, math.rad(S*90), 0)*CN(-9, 5.5+S*10, 9), "Brown", "Wood")
		if S > 1 then
			local Middle = P(Group, V3(5, 10, 18), CF*CA(0, math.rad(S*90), 0)*CN(-9, -4.5+S*10, 2.5), "Brown", "Wood")
		end
	end
	local Roof = P(Group, V3(27, 2, 27), CF*CN(0, 51.5, 0), "Medium stone grey", "Concrete")
end
function Warehouse(PT, CF, Primary, Secondary)
	local Group = M(PT, "Warehouse")
	local Base = P(Group, V3(300, 1, 250), CF, Secondary, "Concrete")
	local Wall1 = P(Group, V3(2, 50, 250), CF*CN(149, 25.5, 0), Primary, "Concrete")
	local Wall2 = P(Group, V3(2, 50, 250), CF*CN(-149, 25.5, 0), Primary, "Concrete")
	local Wall3 = P(Group, V3(100, 50, 2), CF*CN(-98, 25.5, 124), Primary, "Concrete")
	local Wall4 = P(Group, V3(100, 50, 2), CF*CN(98, 25.5, 124), Primary, "Concrete")
	local Wall5 = P(Group, V3(100, 50, 2), CF*CN(-98, 25.5, -124), Primary, "Concrete")
	local Wall6 = P(Group, V3(100, 50, 2), CF*CN(98, 25.5, -124), Primary, "Concrete")
	local Ceiling = P(Group, V3(300, 2, 250), CF*CN(0, 51.5, 0), Primary, "Concrete")
	local Roof = WP(Group, V3(250, 25, 100), CF*CN(100, 65, 0)*CA(0, math.rad(-90), 0), Primary, "Concrete")
	local Roof2 = WP(Group, V3(250, 25, 100), CF*CN(-100, 65, 0)*CA(0, math.rad(90), 0), Primary, "Concrete")
	local Roof3 = P(Group, V3(100, 25, 250), CF*CN(0, 65, 0), Primary, "Concrete")
	local Support = P(Group, V3(15, 50, 15), CF*CN(75, 25.5, 75), Secondary, "Concrete")
	local Support2 = P(Group, V3(15, 50, 15), CF*CN(-75, 25.5, -75), Secondary, "Concrete")
	local Support3 = P(Group, V3(15, 50, 15), CF*CN(-75, 25.5, 75), Secondary, "Concrete")
	local Support4 = P(Group, V3(15, 50, 15), CF*CN(75, 25.5, -75), Secondary, "Concrete")
	local Siding = WP(Group, V3(250, 52, 50), CF*CN(175, 25.5, 0)*CA(0, math.rad(-90), 0), Primary, "Concrete")
	local Siding2 = WP(Group, V3(250, 52, 50), CF*CN(-175, 25.5, 0)*CA(0, math.rad(90), 0), Primary, "Concrete")
end
function ControlTower(PT, CF)
	local Group = M(PT, "Control Tower")
	local Base = P(Group, V3(100, 1, 50), CF, "Medium stone grey", "Concrete")
	local Wall = P(Group, V3(2, 100, 50), CF*CN(49, 50.5, 0), "Medium stone grey", "Concrete")
	local Wall2 = P(Group, V3(96, 2, 2), CF*CN(0, 1.5, 24), "Medium stone grey", "Concrete")
	local Wall2A = P(Group, V3(96, 12, 2), CF*CN(0, 16.5, 24), "Medium stone grey", "Concrete")
	local Wall3 = P(Group, V3(2, 2, 50), CF*CN(-49, 1.5, 0), "Medium stone grey", "Concrete")
	local Wall3A = P(Group, V3(2, 12, 50), CF*CN(-49, 16.5, 0), "Medium stone grey", "Concrete")
	local Wall4 = P(Group, V3(46, 78, 2), CF*CN(25, 61.5, 24), "Medium stone grey", "Concrete")
	local Wall4 = P(Group, V3(2, 78, 50), CF*CN(1, 61.5, 0), "Medium stone grey", "Concrete")
	local Wall5 = P(Group, V3(46, 100, 2), CF*CN(25, 50.5, -24), "Medium stone grey", "Concrete")
	local Ceil = P(Group, V3(48, 2, 46), CF*CN(-24, 21.5, 0), "Medium stone grey", "Concrete")
	local DoorTop = P(Group, V3(50, 12, 2), CF*CN(-23, 16.5, -24), "Medium stone grey", "Concrete")
	local WallFill = P(Group, V3(46, 8, 2), CF*CN(25, 6.5, 24), "Medium stone grey", "Concrete")
	local DoorWall = P(Group, V3(10, 10, 2), CF*CN(-9, 5.5, -24), "Medium stone grey", "Concrete")
	local WindowWall = P(Group, V3(34, 2, 2), CF*CN(-31, 1.5, -24), "Medium stone grey", "Concrete")
	local Window = P(Group, V3(22, 8, 2), CF*CN(-25, 6.5, -24), "Dove blue", "Plastic", 0.5)
	local WindowSide = P(Group, V3(12, 8, 2), CF*CN(-42, 6.5, -24), "Medium stone grey", "Concrete")
	local WindowSide2 = P(Group, V3(2, 8, 14), CF*CN(-49, 6.5, -18), "Medium stone grey", "Concrete")
	local WindowSide3 = P(Group, V3(2, 8, 14), CF*CN(-49, 6.5, 18), "Medium stone grey", "Concrete")
	local WindowSide4 = P(Group, V3(12, 8, 2), CF*CN(-42, 6.5, 24), "Medium stone grey", "Concrete")
	local OtherSide = P(Group, V3(16, 8, 2), CF*CN(-6, 6.5, 24), "Medium stone grey", "Concrete")
	local Window2 = P(Group, V3(22, 8, 2), CF*CN(-25, 6.5, 24), "Dove blue", "Plastic", 0.5)
	local Window3 = P(Group, V3(2, 8, 22), CF*CN(-49, 6.5, 0), "Dove blue", "Plastic", 0.5)
	local Middle = P(Group, V3(26, 100, 26), CF*CN(25, 50.5, 0), "Medium stone grey", "Concrete")
	local Plat = P(Group, V3(10, 2, 36), CF*CN(43, 99.5, -5), "Medium stone grey", "Concrete")
	for S = 0, 9 do
		local Ramp = WP(Group, V3(10, 10, 26), CF*CN(25, 0, 0)*CA(0, math.rad(S*90), 0)*CN(-18, 5.5+S*10, 0), "Medium stone grey", "Concrete")
		local CornerSection = P(Group, V3(10, 10, 10), CF*CN(25, 0, 0)*CA(0, math.rad(S*90), 0)*CN(-18, 5.5+S*10, 18), "Medium stone grey", "Concrete")
	end
	for S = 0, 3 do
		local Plat = P(Group, V3(50, 2, 20), CF*CN(25, 0, 0)*CA(0, math.rad(S*90), 0)*CN(0, 99.5, 35), "Medium stone grey", "Concrete")
		local PlatCorner = WP(Group, V3(2, 20, 20), CF*CN(25, 0, 0)*CA(0, math.rad(S*90), 0)*CN(35, 99.5, 35)*CA(0, math.rad(180), math.rad(90)), "Medium stone grey", "Concrete")
	end
	local Roof = P(Group, V3(46, 2, 66), CF*CN(25, 127.5, 0), "Medium stone grey", "Concrete")
	local Roof2 = P(Group, V3(10, 2, 46), CF*CN(53, 127.5, 0), "Medium stone grey", "Concrete")
	local Roof3 = P(Group, V3(10, 2, 46), CF*CN(-3, 127.5, 0), "Medium stone grey", "Concrete")
	for S = 0, 3 do
		local WindowStart = P(Group, V3(46, 2, 2), CF*CN(25, 0, 0)*CA(0, math.rad(S*90), 0)*CN(0, 101.5, 24), "Medium stone grey", "Concrete")
		local Slant = P(Group, V3(2, 25, 2), WindowStart.CFrame*CA(math.rad(15), 0, 0)*CN(22, 12.5, 0), "Medium stone grey", "Concrete")
		local Slant2 = P(Group, V3(2, 25, 2), WindowStart.CFrame*CA(math.rad(15), 0, 0)*CN(-22, 12.5, 0), "Medium stone grey", "Concrete")
		local WindowEnd = P(Group, V3(46, 2, 2), WindowStart.CFrame*CA(math.rad(15), 0, 0)*CN(0, 26, 0), "Medium stone grey", "Concrete")
		local Window = P(Group, V3(45, 25, 1), WindowStart.CFrame*CA(math.rad(15), 0, 0)*CN(0, 12.5, 0), "Dove blue", "Plastic", 0.5)
		local Roof4 = WP(Group, V3(2, 10, 10), CF*CN(25, 0, 0)*CA(0, math.rad(S*90), 0)*CN(28, 127.5, 28)*CA(0, math.rad(180), math.rad(90)), "Medium stone grey", "Concrete")
		local Roof5 = WP(Group, V3(10, 26, 10), CF*CN(25, 0, 0)*CA(0, math.rad(S*90)+math.rad(45), 0)*CN(0, 113.5, 32.5), "Medium stone grey", "Concrete")
		local Roof5A = P(Group, V3(11, 3, 11), CF*CN(25, 0, 0)*CA(0, math.rad(S*90)+math.rad(45), 0)*CN(0, 100, 32.5), "Medium stone grey", "Concrete")
		if S == 1 then
			WindowStart:Destroy()
			Window:Destroy()
		end
	end
end
function CrashPlane(PT, CF, Primary)
	local Group = M(PT, "Crashed Plane")
	for S = 0, 9 do
		local Side = P(Group, V3(2, 17.5, 200), CF*CA(0, 0, math.rad(S*36))*CN(25, 0, 0), Primary, "DiamondPlate")
		if S == 1 then Side.Size = V3(2, 17.5, 150) Side.CFrame = CF*CA(0, 0, math.rad(S*36))*CN(25, 0, 25) end
		local Mid = P(Group, V3(25, 17.5, 2), CF*CA(0, 0, math.rad(S*36))*CN(12.5, 0, 0), Primary, "DiamondPlate")
		local TailCone = P(Group, V3(2, 17.5, 40), CF*CA(0, 0, math.rad(S*36))*CN(25, 0, 99)*CA(0, math.rad(-15), 0)*CN(0, 0, 20), Primary, "DiamondPlate")
		local Back = P(Group, V3(30, 5, 2), CF*CA(0, 0, math.rad(S*18))*CN(0, 0, 137), Primary, "DiamondPlate")
	end
	for S = 0, 11 do
		local Window = P(Group, V3(1, 7.5, 7.5), CF*CN(25.6, 0, 92.5-S*10))
		--SK(Window, 200, C3(), 0.05, 100)
		local Window = P(Group, V3(1, 7.5, 7.5), CF*CN(-25.6, 0, 92.5-S*10))
		--SK(Window, 200, C3(), 0.05, 100)
	end
	local Wing1 = P(Group, V3(150, 4, 40), CF*CN(25, 0, -50)*CA(0, math.rad(-30), 0)*CN(60, 0, 0), Primary, "DiamondPlate")
	local Wing1A = P(Group, V3(75, 3, 30), Wing1.CFrame*CN(75, 0, 0)*CA(0, math.rad(-30), 0)*CN(25, 0, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing1.CFrame*CN(20, -15, 0)*CA(0, math.rad(120), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing1.CFrame*CN(-20, -15, 0)*CA(0, math.rad(120), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local Wing2 = P(Group, V3(150, 4, 40), CF*CN(-25, 0, -50)*CA(0, math.rad(30), 0)*CN(-60, 0, 0), Primary, "DiamondPlate")
	local Wing2A = P(Group, V3(75, 3, 30), Wing2.CFrame*CN(-75, 0, 0)*CA(0, math.rad(30), 0)*CN(-25, 0, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing2.CFrame*CN(20, -15, 0)*CA(0, math.rad(60), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing2.CFrame*CN(-20, -15, 0)*CA(0, math.rad(60), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local BTurbine = P(Group, V3(1, 25, 25), CF*CN(0, 0, 137.6)*CA(0, math.rad(90), 0), "Really black")
	SM(BTurbine, "Cylinder")
	--SK(BTurbine, 200, C3(), 1, 10)
	
	local TailSpike = P(Group, V3(4, 50, 25), CF*CN(0, 19, 109)*CA(math.rad(45), 0, 0)*CN(0, 25, 0), Primary, "DiamondPlate")
	local TailSpike2 = P(Group, V3(3, 40, 24), TailSpike.CFrame*CN(0, 17.5, 0)*CA(math.rad(30), 0, 0)*CN(0, 20, 0), Primary, "DiamondPlate")
	local OtherTail = P(Group, V3(100, 4, 25), CF*CN(0, 10, 111), Primary, "DiamondPlate")
	local OtherTail2 = P(Group, V3(40, 3, 20), OtherTail.CFrame*CN(45, 0, 0)*CA(0, math.rad(-30), 0)*CN(20, 0, 0), Primary, "DiamondPlate")
	local OtherTail3 = P(Group, V3(40, 3, 20), OtherTail.CFrame*CN(-45, 0, 0)*CA(0, math.rad(30), 0)*CN(-20, 0, 0), Primary, "DiamondPlate")
	
	local Peg = P(Group, V3(5, 20, 5), CF*CN(12.5, -32, 45), Primary, "DiamondPlate")
	local Axel = P(Group, V3(21.5, 4, 4), Peg.CFrame*CN(0, -7.5, 0), "Really black")
	SM(Axel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	
	local Peg = P(Group, V3(5, 20, 5), CF*CN(-12.5, -32, 45), Primary, "DiamondPlate")
	local Axel = P(Group, V3(21.5, 4, 4), Peg.CFrame*CN(0, -7.5, 0), "Really black")
	SM(Axel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	
	for G = 1, 10 do
		local Ground = P(Group, V3(170-G*10, 1, 170-G*10), CF*CA(math.rad(30), 0, 0)*CN(0, -24+G*0.1, -50)*CA(0, math.rad(math.random(-180, 180)), 0), "Reddish brown", "Grass")
	end
end
function Airplane(PT, CF, Primary)
	local Group = M(PT, "Airplane")
	for S = 0, 9 do
		local Side = P(Group, V3(2, 17.5, 250), CF*CA(0, 0, math.rad(S*36))*CN(25, 0, -25), Primary, "DiamondPlate")
		local TailCone = P(Group, V3(2, 17.5, 40), CF*CA(0, 0, math.rad(S*36))*CN(25, 0, 99)*CA(0, math.rad(-15), 0)*CN(0, 0, 20), Primary, "DiamondPlate")
		local Back = P(Group, V3(30, 5, 2), CF*CA(0, 0, math.rad(S*18))*CN(0, 0, 137), Primary, "DiamondPlate")
	end
	local Front = P(Group, V3(52, 52, 100), CF*CN(0, 0, -150), Primary, "DiamondPlate")
	SM(Front, "Sphere")
	--local FrontW = P(Group, V3(110, 5, 110), Front.CFrame*CA(0, 0, math.rad(0)), "Really black", "DiamondPlate")
	--CM(FrontW)
	for S = 0, 23 do
		if S > 16 or S < 12 then
			local Window = P(Group, V3(1, 7.5, 7.5), CF*CN(25.6, 0, 92.5-S*10))
			local Window = P(Group, V3(1, 7.5, 7.5), CF*CN(-25.6, 0, 92.5-S*10))
		end
	end
	local Wing1 = P(Group, V3(150, 4, 40), CF*CN(25, 0, -50)*CA(0, math.rad(-30), 0)*CN(60, 0, 0), Primary, "DiamondPlate")
	local Wing1A = P(Group, V3(75, 3, 30), Wing1.CFrame*CN(75, 0, 0)*CA(0, math.rad(-30), 0)*CN(25, 0, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing1.CFrame*CN(20, -15, 0)*CA(0, math.rad(120), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing1.CFrame*CN(-20, -15, 0)*CA(0, math.rad(120), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local Wing2 = P(Group, V3(150, 4, 40), CF*CN(-25, 0, -50)*CA(0, math.rad(30), 0)*CN(-60, 0, 0), Primary, "DiamondPlate")
	local Wing2A = P(Group, V3(75, 3, 30), Wing2.CFrame*CN(-75, 0, 0)*CA(0, math.rad(30), 0)*CN(-25, 0, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing2.CFrame*CN(20, -15, 0)*CA(0, math.rad(60), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local Turbine = P(Group, V3(32, 25, 25), Wing2.CFrame*CN(-20, -15, 0)*CA(0, math.rad(60), 0), Primary, "DiamondPlate")
	SM(Turbine, "Cylinder")
	local TurbineA = P(Group, V3(32.25, 23, 23), Turbine.CFrame, "Really black")
	SM(TurbineA, "Cylinder")
	local TurbineB = P(Group, V3(32, 14.5, 25), Turbine.CFrame*CN(0, 7.25, 0), Primary, "DiamondPlate")
	
	local BTurbine = P(Group, V3(1, 25, 25), CF*CN(0, 0, 137.6)*CA(0, math.rad(90), 0), "Really black")
	SM(BTurbine, "Cylinder")
	local TailSpike = P(Group, V3(4, 50, 25), CF*CN(0, 19, 109)*CA(math.rad(45), 0, 0)*CN(0, 25, 0), Primary, "DiamondPlate")
	local TailSpike2 = P(Group, V3(3, 40, 24), TailSpike.CFrame*CN(0, 17.5, 0)*CA(math.rad(30), 0, 0)*CN(0, 20, 0), Primary, "DiamondPlate")
	local OtherTail = P(Group, V3(100, 4, 25), CF*CN(0, 10, 111), Primary, "DiamondPlate")
	local OtherTail2 = P(Group, V3(40, 3, 20), OtherTail.CFrame*CN(45, 0, 0)*CA(0, math.rad(-30), 0)*CN(20, 0, 0), Primary, "DiamondPlate")
	local OtherTail3 = P(Group, V3(40, 3, 20), OtherTail.CFrame*CN(-45, 0, 0)*CA(0, math.rad(30), 0)*CN(-20, 0, 0), Primary, "DiamondPlate")
	
	local Peg = P(Group, V3(5, 20, 5), CF*CN(12.5, -32, 45), Primary, "DiamondPlate")
	local Axel = P(Group, V3(21.5, 4, 4), Peg.CFrame*CN(0, -7.5, 0), "Really black")
	SM(Axel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	
	local Peg = P(Group, V3(5, 20, 5), CF*CN(-12.5, -32, 45), Primary, "DiamondPlate")
	local Axel = P(Group, V3(21.5, 4, 4), Peg.CFrame*CN(0, -7.5, 0), "Really black")
	SM(Axel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	
	local Peg = P(Group, V3(5, 20, 5), CF*CN(0, -32, -100), Primary, "DiamondPlate")
	local Axel = P(Group, V3(21.5, 4, 4), Peg.CFrame*CN(0, -7.5, 0), "Really black")
	SM(Axel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(-9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(5, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	local Wheel = P(Group, V3(3, 15, 15), Axel.CFrame*CN(9, 0, 0), "Really black")
	SM(Wheel, "Cylinder")
	
	--local Front = P(Group, V3(50, 50, 50), CF*CN(0, 0, -175), Primary, "DiamondPlate")
	--SM(Front, "FileMesh", V3(50, 50, 50), Asset.."1080954")
end
--Airfield
Base = P(Map, V3(2000, 1, 2000), OS, "Dark green", "Grass")
Airstrip = P(Map, V3(1500, 1, 500), OS*CN(0, 0.5, 0), "Dark stone grey", "Concrete")
ControlTower(Map, OS*CN(-650, 1, 275))
ControlTower(Map, OS*CN(650, 1, -275)*CA(0, math.rad(180), 0))
Warehouse(Map, OS*CN(300, 1, -375), "Medium stone grey", "Medium stone grey")
Warehouse(Map, OS*CN(-300, 1, -375), "Medium stone grey", "Medium stone grey")
--Hangar(Map, OS*CN(0, 1, 0))
Hangar(Map, OS*CN(0, 1, 750), "Medium stone grey")
CrashPlane(Map, OS*CN(0, 25, 0)*CA(0, math.rad(100), 0)*CA(math.rad(-30), 0, 0), "Earth green")
Airplane(Map, OS*CN(150, 48, 950)*CA(0, math.rad(30), 0), "Brick yellow")
Airplane(Map, OS*CN(-150, 48, 950)*CA(0, math.rad(-30), 0), "Black")
Airplane(Map, OS*CN(-250, 48, 650)*CA(0, math.rad(-30), 0), "Institutional white")
Airplane(Map, OS*CN(250, 48, 650)*CA(0, math.rad(30), 0), "Earth green")