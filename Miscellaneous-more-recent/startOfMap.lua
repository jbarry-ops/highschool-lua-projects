--Stuff
CN, CA, V3, BN, C3 = CFrame.new, CFrame.Angles, Vector3.new, BrickColor.new, Color3.new
Name = "District 72"
Offset = CN(0, 1.5, 0)
Debris = Game:GetService("Debris")
RunService = Game:GetService("RunService")
Lighting = Game:GetService("Lighting")
Players = Game:GetService("Players")
ContentProvider = Game:GetService("ContentProvider")
Create = LoadLibrary("RbxUtility").Create
--Functions
function TE(PT, FC, TX, ST)
	local T = Create'Texture'{Parent = PT, Face = FC, Texture = "http://www.roblox.com/asset/?id="..tostring(TX-1), StudsPerTileU = ST, StudsPerTileV = ST}
	return T
end
function TR(PT, TX, FC, ST)
	for _, Val in pairs(FC) do
		TE(PT, Val, TX, ST)
	end
end
function CV(PT, CO)
	PT.TopSurface = CO
	PT.BottomSurface = CO
	PT.RightSurface = CO
	PT.LeftSurface = CO
	PT.FrontSurface = CO
	PT.BackSurface = CO
end
function MD(PT, NM)
	local NM, PT = NM or "Model", PT or Workspace
	return Create'Model'{Parent = PT, Name = NM}
end
function PR(PT, SZ, CF, BC, MT, TA, AN, CC, TX, ST)
	local CO, CC, AN, TA, MT = CO or 0, CC or true, AN or true, TA or 0, MT or "Plastic"
	local P = Create'Part'{Parent = PT, FormFactor = 3, Size = SZ, BrickColor = BN(BC), Material = MT, Transparency = TA, Anchored = AN, CanCollide = CC}
	CV(P, 10)
	P.CFrame = CF
	if TX and ST then
		TR(P, TX, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, ST)
	end
	return P
end
function SM(PT, MT, SC, MI, TI)
	local TI, MI, SC, MT = TI or "", MI or "", SC or V3(1, 1, 1), MT or "Wedge"
	return Create'SpecialMesh'{Parent = PT, MeshType = MT, Scale = SC, MeshId = MI, TextureId = TI}
end
function BM(PT, SC)
	local SC = SC or V3(1, 1, 1)
	return Create'BlockMesh'{Parent = PT, Scale = SC}
end
function CM(PT, SC)
	local SC = SC or V3(1, 1, 1)
	return Create'CylinderMesh'{Parent = PT, Scale = SC}
end
function MT(PT, P0, P1, C0, C1, MV)
	local MV, C1, C0 = MV or 0.1, C1 or CN(), C0 or CN()
	return Create'Motor6D'{Parent = PT, Part0 = P0, Part1 = P1, C0 = C0, C1 = C1, MaxVelocity = MV}
end
function PL(PT, RN, CL, BR)
	local BR, CL, RN = BR or math.huge, CL or C3(1, 1, 1), RN or 10
	return Create'PointLight'{Parent = PT, Range = RN, Color = CL, Brightness = BR}
end
--More stuff
First = "Medium stone grey"
Grassy = "Dark green"
Wood = "Brown"
FirstMat = "Concrete"
--Other functions
function Frame(PT, SZ, BC, MT)
	local Frame1 = PR(PT.Parent, V3(SZ, PT.Size.Y + (SZ*2), SZ), PT.CFrame * CN(PT.Size.X/2, 0, PT.Size.Z/2), BC, MT)
	local Frame2 = PR(PT.Parent, V3(SZ, PT.Size.Y + (SZ*2), SZ), PT.CFrame * CN(-PT.Size.X/2, 0, PT.Size.Z/2), BC, MT)
	local Frame3 = PR(PT.Parent, V3(SZ, PT.Size.Y + (SZ*2), SZ), PT.CFrame * CN(PT.Size.X/2, 0, -PT.Size.Z/2), BC, MT)
	local Frame4 = PR(PT.Parent, V3(SZ, PT.Size.Y + (SZ*2), SZ), PT.CFrame * CN(-PT.Size.X/2, 0, -PT.Size.Z/2), BC, MT)
	local Frame5 = PR(PT.Parent, V3(SZ, SZ, PT.Size.Z-SZ), PT.CFrame * CN(PT.Size.X/2, PT.Size.Y/2+(SZ/2), 0), BC, MT)
	local Frame6 = PR(PT.Parent, V3(SZ, SZ, PT.Size.Z-SZ), PT.CFrame * CN(-PT.Size.X/2, PT.Size.Y/2+(SZ/2), 0), BC, MT)
	local Frame7 = PR(PT.Parent, V3(PT.Size.X-SZ, SZ, SZ), PT.CFrame * CN(0, PT.Size.Y/2+(SZ/2), PT.Size.Z/2), BC, MT)
	local Frame8 = PR(PT.Parent, V3(PT.Size.X-SZ, SZ, SZ), PT.CFrame * CN(0, PT.Size.Y/2+(SZ/2), -PT.Size.Z/2), BC, MT)
end
--[[function MakeAmmoCrate(PT, PS)
	local Crate = MD(PT, "Ammo Crate")
	local Bottom = PR(Crate, V3(8.5, 0.5, 4.5), PS * CN(0, 0, 0), Wood, "Wood")
	local Front = PR(Crate, V3(8.5, 2.5, 0.5), PS * CN(0, 1.5, 2), Wood, "Wood")
	local Back = PR(Crate, V3(8.5, 2.5, 0.5), PS * CN(0, 1.5, -2), Wood, "Wood")
	local Right = PR(Crate, V3(0.5, 2.5, 3.5), PS * CN(4, 1.5, 0), Wood, "Wood")
	local Left = PR(Crate, V3(0.5, 2.5, 3.5), PS * CN(-4, 1.5, 0), Wood, "Wood")
	local Top = PR(Crate, V3(8.5, 0.5, 4.5), PS * CN(0, 2.75, -2) * CA(math.rad(-75), 0, 0) * CN(0, 0, 2.25), Wood, "Wood")
	local Middle = PR(Crate, V3(7.5, 0.5, 3.5), PS * CN(0, 2.5, 0), "Light stone grey", "Plastic", 1)
	local Smoother = PR(Crate, V3(8.51, 0.5, 0.5), PS * CN(0, 2.75, -2), Wood, "Wood")
	SM(Smoother, V3(1, 1, 1), "Cylinder")
	return Crate
end]]
function MakeCircle(PT, RD, NM, HT, PS, BC, MT)
	for Num = 1, NM do
		NWCF = PS * CA(0, Num * math.rad(360/NM), 0) * CN(0, 0, RD/2) * CA(0, 0, math.rad(0.05))
		local P = PR(PT, V3(RD * 2 * 3.141592653589793238462643383279/NM, HT, RD), NWCF, BC, MT)	
	end
end
toDestroy = {}
for _, Obj in pairs(Workspace:GetChildren()) do
	if Obj.Name == Name then
		table.insert(toDestroy, Obj)
	end
end
--Map
Map = MD(Workspace, Name)
Ground = PR(Map, V3(1000, 1, 1000), Offset*CN(0, 0, 0), Grassy, "Grass")

Bridge = PR(Map, V3(42, 5, 380), Offset*CN(0, 89, 0)*CA(0, math.rad(119.7), 0), First, FirstMat)
for M = 0, 360 do
	Side = PR(Map, V3(4.25, 91, 10), Offset*CA(0, math.rad(M), 0)*CN(0, 46, 235), First, FirstMat)
end
for SC = 0, 1 do
	local Points = {}
	for N = 0, 150 do
		local Stair, Rail
		if N <= 90 then
			Stair = PR(Map, V3(5, N+2, 40), Offset*CA(0, math.rad(N+SC*180), 0)*CN(0, 0.5+N/2, 210), First, FirstMat)
			Rail = PR(Map, V3(1, 7, 1), Stair.CFrame*CN(-1, N/2+4.5, -19), First, FirstMat)
			CM(Rail)
		else
			Stair = PR(Map, V3(5, 92, 40), Offset*CA(0, math.rad(N+SC*180), 0)*CN(0, 45.5+0.01*math.sin(N), 210), First, FirstMat)
			if N < 115 or N > 125 then
				Rail = PR(Map, V3(1, 7, 1), Stair.CFrame*CN(-1, 49.5, -19), First, FirstMat)
				CM(Rail)
			end
		end
		if Rail then
			table.insert(Points, (Rail.CFrame*CN(0, 3.5, 0)).p)
		else
			table.insert(Points, "Durp")
		end
	end
	for P = #Points, 1, -1 do
		if P ~= 1 then
			if Points[P] == "Durp" or Points[P-1] == "Durp" then
			else
				local Dist = (Points[P]-Points[P-1]).magnitude
				local RailTop = PR(Map, V3(1, Dist, 1), CN(Points[P], Points[P-1])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
				CM(RailTop)
			end
		end
		if P == #Points or P == 1 or P == 91 or P == 115 or P == 127 then
			local End = PR(Map, V3(1, 1, 1), CN(Points[P]), First, FirstMat)
			SM(End, "Sphere")
		end
	end
	local towerOutline = PR(Map, V3(40, 152, 40), Offset*CA(0, math.rad(SC*180+155), 0)*CN(0, 75.5, 210), Wood, "Wood")
end
P1, P2 = {}, {}
for R = 1, 111 do
	Rail = PR(Map, V3(1, 7, 1), Bridge.CFrame*CN(-20, 6, -190.4+R*3.4), First, FirstMat)
	CM(Rail)
	table.insert(P1, (Rail.CFrame*CN(0, 3.5, 0)).p)
	Rail2 = PR(Map, V3(1, 7, 1), Bridge.CFrame*CN(20, 6, -190.4+R*3.4), First, FirstMat)
	CM(Rail2)
	table.insert(P2, (Rail2.CFrame*CN(0, 3.5, 0)).p)
end
R1, R2, R3, R4 = Offset*CA(0, math.rad(114), 0)*CN(-1, 98.5+0.01*math.sin(114), 191), 
Offset*CA(0, math.rad(126+180), 0)*CN(-1, 98.5+0.01*math.sin(126), 191), 
Offset*CA(0, math.rad(126), 0)*CN(-1, 98.5+0.01*math.sin(126), 191), 
Offset*CA(0, math.rad(114+180), 0)*CN(-1, 98.5+0.01*math.sin(114), 191)
for P = #P1+1, 1, -1 do
	if P == #P1+1 then
		local Dist = (R1.p-P1[P-1]).magnitude
		local RailTop = PR(Map, V3(1, Dist, 1), CN(R1.p, P1[P-1])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
		CM(RailTop)
		local Dist2 = (R3.p-P2[P-1]).magnitude
		local RailTop2 = PR(Map, V3(1, Dist2, 1), CN(R3.p, P2[P-1])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
		CM(RailTop2)
	elseif P == 1 then
		local Dist = (R2.p-P1[P]).magnitude
		local RailTop = PR(Map, V3(1, Dist, 1), CN(R2.p, P1[P])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
		CM(RailTop)
		local Dist2 = (R4.p-P2[P]).magnitude
		local RailTop2 = PR(Map, V3(1, Dist2, 1), CN(R4.p, P2[P])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
		CM(RailTop2)
	else
		local Dist = (P1[P]-P1[P-1]).magnitude
		local RailTop = PR(Map, V3(1, Dist, 1), CN(P1[P], P1[P-1])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
		CM(RailTop)
		local Dist2 = (P2[P]-P2[P-1]).magnitude
		local RailTop2 = PR(Map, V3(1, Dist2, 1), CN(P2[P], P2[P-1])*CN(0, 0, -Dist/2)*CA(math.rad(90), 0, 0), First, FirstMat)
		CM(RailTop2)
	end
end

for _, v in pairs(toDestroy) do
	v:Destroy()
end