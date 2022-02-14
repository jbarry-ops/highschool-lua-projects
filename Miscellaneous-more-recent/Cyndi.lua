--Cyndi
CN, CA, V3, U2, BN, C3 = CFrame.new, CFrame.Angles, Vector3.new, UDim2.new, BrickColor.new, Color3.new
RunService = Game:GetService("RunService")
Player = Game:GetService("Players").LocalPlayer
Character, Camera, Mouse, PlayerGui = Player.Character, Workspace.CurrentCamera, Player:GetMouse(), Player:WaitForChild("PlayerGui")
Camera:ClearAllChildren()
Humanoid, RootPart, Torso, Head, RightArm, LeftArm, RightLeg, LeftLeg = 
Character:WaitForChild("Humanoid"),
Character:WaitForChild("HumanoidRootPart"),
Character:WaitForChild("Torso"),
Character:WaitForChild("Head"),
Character:WaitForChild("Right Arm"),
Character:WaitForChild("Left Arm"),
Character:WaitForChild("Right Leg"),
Character:WaitForChild("Left Leg")
RootJoint, RightShoulder, LeftShoulder, RightHip, LeftHip = 
RootPart:WaitForChild("RootJoint"),
Torso:WaitForChild("Right Shoulder"),
Torso:WaitForChild("Left Shoulder"),
Torso:WaitForChild("Right Hip"),
Torso:WaitForChild("Left Hip")
RootJoint.C0 = CN()
RootJoint.C1 = CN()
Character:WaitForChild("Animate").Disabled = true
Count = 0
local function New(Type)
        return function(Set)
                local Object = Instance.new(Type)
                for A, B in pairs(Set) do
                        Object[A] = B
                end
                return Object
        end
end
function Part(PT, SZ, CF, BC, MT, TR, AN, CC)
        local CC, AN, TR, MT, BC, CF, SZ = CC or true, AN or false, TR or 0, MT or "SmoothPlastic", BC or "Black", CF or CN(), SZ or V3(1, 1, 1)
        local P = New'Part'{Parent = PT, FormFactor = 3, Size = SZ, BrickColor = BN(BC), Material = MT, Transparency = TR, Anchored = AN, CanCollide = CC, TopSurface = 0, BottomSurface = 0}
        P.CFrame = CF
        Count = Count+P:GetMass()
        return P
end
function WedgePart(PT, SZ, CF, BC, MT, TR, AN, CC)
        local CC, AN, TR, MT, BC, CF, SZ = CC or true, AN or false, TR or 0, MT or "SmoothPlastic", BC or "Black", CF or CN(), SZ or V3(1, 1, 1)
        local WP = New'WedgePart'{Parent = PT, FormFactor = 3, Size = SZ, BrickColor = BN(BC), Material = MT, Transparency = TR, Anchored = AN, CanCollide = CC, TopSurface = 0, BottomSurface = 0}
        WP.CFrame = CF
        Count = Count+WP:GetMass()
        return WP
end
function Motor(PT, P0, P1, C0, C1)
        local C1, C0 = C1 or CN(), C0 or CN()
        return New'Motor6D'{Parent = PT, Part0 = P0, Part1 = P1, C0 = C0, C1 = C1}
end
function Mesh(PT, MT, SC, MI, TI)
        local TI, MI, SC, MT = TI or "", MI or "", SC or V3(1, 1, 1), MT or "Wedge"
        return New'SpecialMesh'{Parent = PT, MeshType = MT, Scale = SC, MeshId = MI, TextureId = TI}
end
function Cylinder(PT, SC)
        local SC = SC or V3(1, 1, 1)
        return New'CylinderMesh'{Parent = PT, Scale = SC}
end
function Block(PT, SC)
        local SC = SC or V3(1, 1, 1)
        return New'BlockMesh'{Parent = PT, Scale = SC}
end
local function Raycast(OR, DR, IG)
        local N = Ray.new(OR, DR)
        return Workspace:FindPartOnRayWithIgnoreList(N, IG)
end
-- Credit to Stravant and AntiBoomz0r; Modification of QuaternionSlerp
local function QuaternionFromCFrame(cf) local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components() local trace = m00+m11+m22 if trace > 0 then local s = math.sqrt(1+trace) local recip = 0.5/s return (m21-m12)*recip, (m02-m20)*recip, (m10-m01)*recip, s*0.5 else local i = 0 if m11 > m00 then i = 1 end if m22 > (i == 0 and m00 or m11) then i = 2 end if i == 0 then local s = math.sqrt(m00-m11-m22+1) local recip = 0.5/s return 0.5*s, (m10+m01)*recip, (m20+m02)*recip, (m21-m12)*recip elseif i == 1 then local s = math.sqrt(m11-m22-m00+1) local recip = 0.5/s return (m01+m10)*recip, 0.5*s, (m21+m12)*recip, (m02-m20)*recip elseif i == 2 then local s = math.sqrt(m22-m00-m11+1) local recip = 0.5/s return (m02+m20)*recip, (m12+m21)*recip, 0.5*s, (m10-m01)*recip end end end
local function QuaternionToCFrame(px, py, pz, x, y, z, w) local xs, ys, zs = x+x, y+y, z+z local wx, wy, wz = w*xs, w*ys, w*zs local xx = x*xs local xy = x*ys local xz = x*zs local yy = y*ys local yz = y*zs local zz = z*zs return CFrame.new(px, py, pz, 1-(yy+zz), xy-wz, xz+wy, xy+wz, 1-(xx+zz), yz-wx, xz-wy, yz+wx, 1-(xx+yy)) end
local function QuaternionSlerp(a, b, t) local cosTheta = a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4] local startInterp, finishInterp; if cosTheta >= 0.0001 then if (1-cosTheta) > 0.0001 then local theta = math.acos(cosTheta) local invSinTheta = 1/math.sin(theta) startInterp = math.sin((1-t)*theta)*invSinTheta finishInterp = math.sin(t*theta)*invSinTheta  else startInterp = 1-t finishInterp = t end else if (1+cosTheta) > 0.0001 then local theta = math.acos(-cosTheta) local invSinTheta = 1/math.sin(theta) startInterp = math.sin((t-1)*theta)*invSinTheta finishInterp = math.sin(t*theta)*invSinTheta else startInterp = t-1 finishInterp = t end end return a[1]*startInterp + b[1]*finishInterp, a[2]*startInterp + b[2]*finishInterp, a[3]*startInterp + b[3]*finishInterp, a[4]*startInterp + b[4]*finishInterp end
local function Lerp(a,b,t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.x, a.y, a.z
	local bx, by, bz = b.x, b.y, b.z
	local _t = 1-t
	return QuaternionToCFrame(_t*ax+t*bx, _t*ay+t*by, _t*az+t*bz, QuaternionSlerp(qa, qb, t))
end
--Model
Primary = tostring(BrickColor.Random())
Secondary = tostring(BrickColor.Random())
Thirdary = "Institutional white"--tostring(BrickColor.Random())
for _, Obj in pairs(Workspace:GetChildren()) do
        if Obj.Name == "Cynd" then
                Obj:Destroy()
        end
end
Cyndi = New'Model'{Parent = Workspace, Name = "Cyndi"}
--Floor
Floor = Part(Cyndi, V3(6, 1, 15), CN(0, 10, 0), Primary, "SmoothPlastic", 0, false)
--Front
Front = Part(Cyndi, V3(6, 1, 10), CN(), Primary)
Motor(Front, Front, Floor, CN(), CN(0, 1, -2.5))
--Front Wedge
FrontWedge = WedgePart(Cyndi, V3(6, 2, 20), CN(), Primary)
Motor(FrontWedge, FrontWedge, Front, CN(), CN(0, 1.5, -5))
--Seat
Back = Part(Cyndi, V3(8.5, 4, 2), CN(), Primary)
Motor(Back, Back, Floor, CN(), CN(0, 2.5, 7.5))
Back2 = Part(Cyndi, V3(8.5, 1, 2), CN(), Primary)
Mesh(Back2, "Torso")
Motor(Back2, Back2, Back, CN(), CN(0, 2.5, 0))
Seat1 = Part(Cyndi, V3(1, 3, 4), CN(), Primary)
Motor(Seat1, Seat1, Floor, CN(2.5, -2, -4.5))
--[[Seat1A = Part(Cyndi, V3(4, 0.75, 1), CN(), Primary)
Mesh(Seat1A, "Wedge")
Motor(Seat1A, Seat1A, Seat1, CN(), CN(-1, 1.125, 0)*CA(0, math.rad(90), 0))]]
Seat2 = Part(Cyndi, V3(1, 3, 4), CN(), Primary)
Motor(Seat2, Seat2, Floor, CN(-2.5, -2, -4.5))
--[[Seat2A = Part(Cyndi, V3(4, 0.75, 1), CN(), Primary)
Mesh(Seat2A, "Wedge")
Motor(Seat2A, Seat2A, Seat2, CN(), CN(1, 1.125, 0)*CA(0, math.rad(-90), 0))]]
for S = -1, 2 do
--Siding
Siding = Part(Cyndi, V3(3, 15, 3), CN(), Primary)
Cylinder(Siding)
Motor(Siding, Siding, Floor, CN(), CN(3, 1, 1)*CA(math.rad(90), 0, 0))
Siding2 = Part(Cyndi, V3(1.5, 1.5, 1.5), CN(), Primary)
Mesh(Siding2, "Sphere")
Motor(Siding2, Siding2, Siding, CN(), CN(0, 7.5, 0))
Siding3 = Part(Cyndi, V3(1.5, 4, 1.5), CN(), Primary)
Cylinder(Siding3)
Motor(Siding3, Siding3, Siding2, CN(), CA(math.rad(-25*S), 0, math.rad(-25*S))*CN(0, 2, 0))
Siding4 = Part(Cyndi, V3(1.5, 1.5, 1.5), CN(), Primary)
Mesh(Siding4, "Sphere")
Motor(Siding4, Siding4, Siding3, CN(), CN(0, 2, 0))
Siding5 = Part(Cyndi, V3(1.5, 4, 1.5), CN(), Primary)
Cylinder(Siding5)
Motor(Siding5, Siding5, Siding4, CN(), CA(math.rad(25*S), 0, math.rad(25*S))*CN(0, 2, 0))
Siding6 = Part(Cyndi, V3(1.5, 0.1, 1.5), CN(), "Really black")
Cylinder(Siding6, V3(0.9, 0.1, 0.9))
Motor(Siding6, Siding6, Siding5, CN(), CN(0, 2, 0))
--Other Siding
Siding = Part(Cyndi, V3(3, 15, 3), CN(), Primary)
Cylinder(Siding)
Motor(Siding, Siding, Floor, CN(), CN(-3, 1, 1)*CA(math.rad(90), 0, 0))
Siding2 = Part(Cyndi, V3(1.5, 1.5, 1.5), CN(), Primary)
Mesh(Siding2, "Sphere")
Motor(Siding2, Siding2, Siding, CN(), CN(0, 7.5, 0))
Siding3 = Part(Cyndi, V3(1.5, 4, 1.5), CN(), Primary)
Cylinder(Siding3)
Motor(Siding3, Siding3, Siding2, CN(), CA(math.rad(-25*S), 0, math.rad(25*S))*CN(0, 2, 0))
Siding4 = Part(Cyndi, V3(1.5, 1.5, 1.5), CN(), Primary)
Mesh(Siding4, "Sphere")
Motor(Siding4, Siding4, Siding3, CN(), CN(0, 2, 0))
Siding5 = Part(Cyndi, V3(1.5, 4, 1.5), CN(), Primary)
Cylinder(Siding5)
Motor(Siding5, Siding5, Siding4, CN(), CA(math.rad(25*S), 0, math.rad(-25*S))*CN(0, 2, 0))
Siding6 = Part(Cyndi, V3(1.5, 0.1, 1.5), CN(), "Really black")
Cylinder(Siding6, V3(0.9, 0.1, 0.9))
Motor(Siding6, Siding6, Siding5, CN(), CN(0, 2, 0))
end
--Front Turbine
Middle1 = Part(Cyndi, V3(1, 2, 1), CN(), Primary)
Cylinder(Middle1)
M1M = Motor(Middle1, Middle1, Floor, CN(), CN(0, 1, -12)*CA(math.rad(-5), 0, 0))
for N = 1, 9 do
        local Edge = Part(Cyndi, V3(5.1, 2, 2), CN(), Primary)
        Motor(Edge, Edge, Floor, CN(), CN(0, 1, -12)*CA(math.rad(-5), math.rad(N*40), 0)*CN(0, 0.001*N, -6))
end
for N = 1, 6 do
        local Blade = Part(Cyndi, V3(1, 0.01, 5), CN(), Thirdary)
        Blade.Reflectance = 1
        Block(Blade, V3(1, 0.1, 1))
        Motor(Blade, Blade, Middle1, CN(), CA(0, math.rad(N*60), 0)*CN(0, 0, -2.5)*CA(0, 0, math.rad(30)))
end
--Turbine 2
Middle2 = Part(Cyndi, V3(1, 2, 1), CN(), Primary)
Cylinder(Middle2)
M2M = Motor(Middle2, Middle2, Floor, CN(), CN(0, 1.5, 5)*CA(0, 0, math.rad(5))*CN(8.75, 0, 0))
for N = 1, 9 do
        local Edge = Part(Cyndi, V3(4.2, 2, 1.5), CN(), Primary)
        Motor(Edge, Edge, Floor, CN(), CN(0, 1.5, 5)*CA(0, 0, math.rad(5))*CN(8.75, 0, 0)*CA(0, math.rad(N*40+10), 0)*CN(0, 0.001*N, -5))
end
for N = 1, 6 do
        local Blade = Part(Cyndi, V3(1, 0.01, 5), CN(), Thirdary)
        Blade.Reflectance = 1
        Block(Blade, V3(1, 0.1, 1))
        Motor(Blade, Blade, Middle2, CN(), CA(0, math.rad(N*60), 0)*CN(0, 0, -2.5)*CA(0, 0, math.rad(30)))
end
--Turbine 3
Middle3 = Part(Cyndi, V3(1, 2, 1), CN(), Primary)
Cylinder(Middle3)
M3M = Motor(Middle3, Middle3, Floor, CN(), CN(0, 1.5, 5)*CA(0, 0, math.rad(-5))*CN(-8.75, 0, 0))
for N = 1, 9 do
        local Edge = Part(Cyndi, V3(4.2, 2, 1.5), CN(), Primary)
        Motor(Edge, Edge, Floor, CN(), CN(0, 1.5, 5)*CA(0, 0, math.rad(-5))*CN(-8.75, 0, 0)*CA(0, math.rad(N*40-10), 0)*CN(0, 0.001*N, -5))
end
for N = 1, 6 do
        local Blade = Part(Cyndi, V3(1, 0.01, 5), CN(), Thirdary)
        Blade.Reflectance = 1
        Block(Blade, V3(1, 0.1, 1))
        Motor(Blade, Blade, Middle3, CN(), CA(0, math.rad(N*60), 0)*CN(0, 0, -2.5)*CA(0, 0, math.rad(-30)))
end
--Connect
Connect = Part(Cyndi, V3(5, 0.5, 1), CN(), Primary)
Motor(Connect, Connect, Floor, CN(), CN(0, 1.5, 5)*CA(0, 0, math.rad(-5))*CN(-8.75/2-3.75/2, -0.75, 0))
Connect2 = Part(Cyndi, V3(5, 0.5, 1), CN(), Primary)
Motor(Connect2, Connect2, Floor, CN(), CN(0, 1.5, 5)*CA(0, 0, math.rad(5))*CN(8.75/2+3.75/2, -0.75, 0))
--Fill
Fill1 = Part(Cyndi, V3(5, 2, 6), CN(), Secondary)
Motor(Fill1, Fill1, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(5, 2, -3))
Fill2 = Part(Cyndi, V3(2, 5, 5), CN(), Secondary)
Mesh(Fill2, "Wedge")
Motor(Fill2, Fill2, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(5, 2, -8.5)*CA(0, 0, math.rad(90)))
Fill3 = Part(Cyndi, V3(2, 3, 4), CN(), Secondary)
Mesh(Fill3, "Wedge")
Motor(Fill3, Fill3, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(4, 2, 2)*CA(0, math.rad(180), math.rad(90)))
Fill4 = Part(Cyndi, V3(2, 5, 11.5), CN(), Secondary)
Mesh(Fill4, "Wedge")
Motor(Fill4, Fill4, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(10, 2, -5.25)*CA(0, 0, math.rad(-90)))
Fill5 = Part(Cyndi, V3(2, 2, 8), CN(), Primary)
Motor(Fill5, Fill5, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(6, 2.05, -3.7)*CA(0, math.rad(20), 0))
--[[Fill6 = Part(Cyndi, V3(1, 2, 10), CN(), Primary)
Motor(Fill6, Fill6, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(8, 2.05, -4.75)*CA(0, math.rad(20), 0))]]
Fill7 = Part(Cyndi, V3(1, 2, 17), CN(), Primary)
Motor(Fill7, Fill7, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(10.5, 2.05, -4.25)*CA(0, math.rad(24), 0)*CN(0, 0, -2))
--Other Fill
Fill1 = Part(Cyndi, V3(5, 2, 6), CN(), Secondary)
Motor(Fill1, Fill1, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-5, 2, -3))
Fill2 = Part(Cyndi, V3(2, 5, 5), CN(), Secondary)
Mesh(Fill2, "Wedge")
Motor(Fill2, Fill2, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-5, 2, -8.5)*CA(0, 0, math.rad(-90)))
Fill3 = Part(Cyndi, V3(2, 3, 4), CN(), Secondary)
Mesh(Fill3, "Wedge")
Motor(Fill3, Fill3, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-4, 2, 2)*CA(0, math.rad(180), math.rad(-90)))
Fill4 = Part(Cyndi, V3(2, 5, 11.5), CN(), Secondary)
Mesh(Fill4, "Wedge")
Motor(Fill4, Fill4, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-10, 2, -5.25)*CA(0, 0, math.rad(90)))
Fill5 = Part(Cyndi, V3(2, 2, 8), CN(), Primary)
Motor(Fill5, Fill5, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-6, 2.05, -3.7)*CA(0, math.rad(-20), 0))
--[[Fill6 = Part(Cyndi, V3(1, 2, 10), CN(), Primary)
Motor(Fill6, Fill6, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-8, 2.05, -4.75)*CA(0, math.rad(-20), 0))]]
Fill7 = Part(Cyndi, V3(1, 2, 17), CN(), Primary)
Motor(Fill7, Fill7, Floor, CN(), CA(math.rad(-5), 0, 0)*CN(-10.5, 2.05, -4.25)*CA(0, math.rad(-24), 0)*CN(0, 0, -2))
--Exhaust
Exhaust = Part(Cyndi, V3(4, 8, 4), CN(), Primary)
Cylinder(Exhaust)
Motor(Exhaust, Exhaust, Back, CN(), CN(0, 0, 5)*CA(math.rad(90), 0, 0))
Exhaust2 = Part(Cyndi, V3(4, 0.1, 4), CN(), "Really black")
Cylinder(Exhaust2, V3(0.9, 0.1, 0.9))
Motor(Exhaust2, Exhaust2, Exhaust, CN(), CN(0, 4, 0))
Exhaust3 = Part(Cyndi, V3(4.5, 1, 4.5), CN(), Primary)
Cylinder(Exhaust3)
Motor(Exhaust3, Exhaust3, Exhaust, CN(), CN(0, -4, 0))
--Emblem
for E = -2, 4 do
	Emblem1 = Part(Cyndi, V3(0.25, 0.2, 5), CN(), Secondary)
	Emblem1.Reflectance = 0
	Motor(Emblem1, Emblem1, FrontWedge, CN(), CA(math.rad(-6), 0, 0)*CN(0, 0, -4+E*2)*CA(0, math.rad(20), 0)*CN(0, 0, 2.5))
	Emblem2 = Part(Cyndi, V3(0.25, 0.2, 5), CN(), Secondary)
	Emblem2.Reflectance = 0
	Motor(Emblem2, Emblem2, FrontWedge, CN(), CA(math.rad(-6), 0, 0)*CN(0, 0, -4+E*2)*CA(0, math.rad(-20), 0)*CN(0, 0, 2.5))
	Emblem3 = Part(Cyndi, V3(0.25, 0.2, 0.25), CN(), Secondary)
	Emblem3.Reflectance = 0
	Cylinder(Emblem3)
	Motor(Emblem3, Emblem3, FrontWedge, CN(), CA(math.rad(-6), 0, 0)*CN(0, 0, -4+E*2))
end
--Cockpit
--Glass = Part(Cyndi, V3(5, 3.5, 10), CN(), "Dove blue", "Plastic", 0.5)
--Motor(Glass, Glass, Back, CN(), CN(0, 2.75, 0)*CA(math.rad(-5), 0, 0)*CN(0, -3.5/2, -5))
--Other
Cyndi:MoveTo(Vector3.new(100, 10, 100))
Motor(Floor, Floor, Torso, CN(), CN(0, -4, -6))
Humanoid.WalkSpeed = 0
--Loop
local Gyro = New'BodyGyro'{Parent = Floor, maxTorque = V3(1/0, 1/0, 1/0), P = 10000, D = 250}
--Force = New'BodyForce'{Parent = Floor, force = V3(0, 0, 0)}
local Velocity = New'BodyVelocity'{Parent = Floor, maxForce = V3(1/0, 1/0, 1/0)}
local Grav = New'BodyForce'{Parent = Floor, force = V3(0, 196.2, 0)*Count}
Unit = CN()
Unit2 = CN()
Unit3 = CN()
Unit4 = CN()
local UnitH = 0
local heightSpeed = 100
local Speed = 150
local Tilt = 10
local Jump = false

local function shoot()

end


Humanoid.Died:connect(function () 
        Cyndi:BreakJoints()
        Floor:ClearAllChildren()
end)
Player.Chatted:connect(function () 
        Unit = CN()
        Unit3 = CN()
end)
Mouse.KeyDown:connect(function (Key)
        if Key == "w" then
                if Unit.Z == -Speed then return end
                Unit = Unit*CN(0, 0, -Speed)
                Unit3 = Unit3*CN(-Tilt, 0, 0)
        elseif Key == "a" then
                if Unit.X == -Speed then return end
                Unit = Unit*CN(-Speed, 0, 0)
                Unit3 = Unit3*CN(0, 0, Tilt)
        elseif Key == "s" then
                if Unit.Z == Speed then return end
                Unit = Unit*CN(0, 0, Speed)
                Unit3 = Unit3*CN(Tilt, 0, 0)
        elseif Key == "d" then
                if Unit.X == Speed then return end
                Unit = Unit*CN(Speed, 0, 0)
                Unit3 = Unit3*CN(0, 0, -Tilt)
        elseif Key == "\32" and not Jump then
                Jump = true
                Grav.force = Grav.force+V3(0, 100000, 0)
                wait(1)
                Grav.force = Grav.force+V3(0, -100000, 0)
                wait(1)
                Jump = false
		elseif Key == "q" then
			UnitH = -1
		elseif Key == "e" then
			UnitH = 1
        end
end)
Mouse.KeyUp:connect(function (Key)
        if Key == "w" then
                if Unit.Z == Speed then return end
                Unit = Unit*CN(0, 0, Speed)
                Unit3 = Unit3*CN(Tilt, 0, 0)
        elseif Key == "a" then
                if Unit.X == Speed then return end
                Unit = Unit*CN(Speed, 0, 0)
                Unit3 = Unit3*CN(0, 0, -Tilt)
        elseif Key == "s" then
                if Unit.Z == -Speed then return end
                Unit = Unit*CN(0, 0, -Speed)
                Unit3 = Unit3*CN(-Tilt, 0, 0)
        elseif Key == "d" then
                if Unit.X == -Speed then return end
                Unit = Unit*CN(-Speed, 0, 0)
                Unit3 = Unit3*CN(0, 0, Tilt)
		elseif Key == "q" then
			UnitH = 0
		elseif Key == "e" then
			UnitH = 0
        end
end)

Mouse.Button1Down:connect(function()
	shoot()
end)

Grav2 = 0
RunService.Stepped:connect(function () 
        M1M.C1 = M1M.C1*CA(0, math.rad(45), 0)
        M2M.C1 = M2M.C1*CA(0, math.rad(45), 0)
        M3M.C1 = M3M.C1*CA(0, math.rad(-45), 0)
        Unit2 = Lerp(Unit2, Unit, 0.03)
        Unit4 = Lerp(Unit4, Unit3, 0.03)
        local Pos = (Floor.CFrame*Unit2).p-Floor.Position
        Velocity.velocity = V3(Pos.X, UnitH*heightSpeed, Pos.Z)
        Gyro.cframe = CN(V3(Camera.CoordinateFrame.X, Floor.CFrame.Y, Camera.CoordinateFrame.Z), V3((Head.CFrame*CN(0, 0, -1)).X, Floor.CFrame.Y, (Head.CFrame*CN(0, 0, -1)).Z))*CA(math.rad(Unit4.X), 0, math.rad(Unit4.Z))
        Grav2 = Grav2+0.05
        Velocity.velocity = Velocity.velocity+V3(0, math.sin(Grav2), 0)
end)