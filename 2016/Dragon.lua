CN, CA, V3, U2, BN, C3 = CFrame.new, CFrame.Angles, Vector3.new, UDim2.new, BrickColor.new, Color3.new DB, RS, PS, CP = Game:GetService("Debris"), Game:GetService("RunService"), Game:GetService("Players"), Game:GetService("ContentProvider")
New, Part, Motor, Mesh, Cylinder = function(Type)
        return function(Set) local Obj = Instance.new(Type) for A, B in pairs(Set) do Obj[A] = B end return Obj end end, function(PT, SZ, BC, MT, TR, CC) local CC, TR, MT = CC or true, TR or 0, MT or "SmoothPlastic"
        return New'Part'{Parent = PT, FormFactor = 3, Size = SZ, TopSurface = 0, BottomSurface = 0, BrickColor = BN(BC), Material = MT, Transparency = TR, CanCollide = CC} end, function(PT, P0, P1, C0, C1) local C1, C0 = C1 or CN(), C0 or CN()
        return New'Motor6D'{Parent = PT, Part0 = P0, Part1 = P1, C0 = C0, C1 = C1} end, function(PT, MT, SC, MI, TI) local TI, MI, SC, MT = TI or "", MI or "", SC or V3(1, 1, 1), MT or "Wedge"
        return New'SpecialMesh'{Parent = PT, MeshType = MT, Scale = SC, MeshId = MI, TextureId = TI} end, function(PT, SC) local SC = SC or V3(1, 1, 1)
        return New'CylinderMesh'{Parent = PT, Scale = SC} end
function GetTriangleValues(Points) 
        local G, V = 0
        for S = 1, 3 do
                local L = (Points[1+(S+1)%3]-Points[1+S%3]).magnitude
                G, V = L > G and L or G, L > G and {Points[1+(S-1)%3], Points[1+(S)%3], Points[1+(S+1)%3]} or V
        end
        local D = V[2]+(V[3]-V[2]).unit*((V[3]-V[2]).unit:Dot(V[1]-V[2]))
        local C, B = (D-V[1]).unit, (V[2]-V[3]).unit
        local A = B:Cross(C)
        S1 = V3(0, (V[2]-D).magnitude, (V[1]-D).magnitude)/0.2
        S2 = V3(0, (V[3]-D).magnitude, (V[1]-D).magnitude)/0.2
        C1 = CN(0,0,0,A.X,B.X,C.X,A.Y,B.Y,C.Y,A.Z,B.Z,C.Z)+(V[1]+V[2])/2
        C2 = CN(0,0,0,-A.X,-B.X,C.X,-A.Y,-B.Y,C.Y,-A.Z,-B.Z,C.Z)+(V[1]+V[3])/2
        return C1, C2, S1, S2
end
--Player = PS.LocalPlayer
--Character, Mouse, Camera = Player.Character, Player:GetMouse(), Workspace.CurrentCamera
Primary = "Really black"
Secondary = "Institutional white"
pcall(function() Workspace.Dragon:Destroy() end)
Dragon = New'Model'{Parent = Workspace, Name = "Dragon"}
TailThings = {}
WingThings = {}
WingThings2 = {}
WingT = {}
WingT2 = {}
Torso = Part(Dragon, V3(8, 8, 20), Primary, "Slate") Torso.Anchored = true
for N = 1, 7 do
        Horn = Part(Dragon, V3(1.4, 0.5, 1.4), "Institutional white")
        Cylinder(Horn)
        Motor(Horn, Horn, Torso, CN(), CN(0, 3.75, 8-N*2.5)*CA(math.rad(-18), 0, 0)*CN(0, 0.25, 0))
        Current2 = Horn
        for H = 1, 6 do
                local Horn2 = Part(Dragon, V3(1.4-H*0.2, 0.5, 1.4-H*0.2), "Institutional white")
                Cylinder(Horn2)
                Motor(Horn2, Horn2, Current2, CN(), CN(0, 0.5, 0))
                Current2 = Horn2
        end
end
 
Torso2 = Part(Dragon, V3(7, 0.5, 20.5), Secondary)
Torso2.Reflectance = 1
Motor(Torso2, Torso2, Torso, CN(), CN(0, -4, 0))
 
Wing1 = Part(Dragon, V3(2, 8, 2), Primary, "Slate")
Motor(Wing1, Wing1, Torso, CN(), CN(3, 3, 9.5)*CA(math.rad(-45), 0, math.rad(-15))*CN(0, 3.5, 0))
table.insert(WingThings, {Wing1, CN(3, 3, 9.5)*CA(math.rad(-45), 0, math.rad(-15)), CN(0, 3.5, 0)})
Wing2 = Part(Dragon, V3(1.6, 8, 1.6), Primary, "Slate")
Motor(Wing2, Wing2, Wing1, CN(), CN(0, 3, 0)*CA(math.rad(90), 0, math.rad(-15))*CN(0, 4, 0))
table.insert(WingThings, {Wing2, CN(0, 3, 0)*CA(math.rad(90), 0, math.rad(-15)), CN(0, 4, 0)})
Wing3 = Part(Dragon, V3(1.2, 8, 1.2), Primary, "Slate")
Motor(Wing3, Wing3, Wing2, CN(), CN(0, 3, 0)*CA(math.rad(-45), 0, math.rad(-60))*CN(0, 4, 0))
table.insert(WingThings, {Wing3, CN(0, 3, 0)*CA(math.rad(-45), 0, math.rad(-60)), CN(0, 4, 0)})
for W = 1, 5 do
        local Current = Wing3
        local Tab = {}
        for WingThing = 1, 5 do
                local Wing4 = Part(Dragon, V3(0.9-WingThing*0.1, 8, 0.9-WingThing*0.1), Primary, "Slate")
                Motor(Wing4, Wing4, Current, CN(), CN(0, 3.9, 0)*CA(math.rad(27-W*9), 0, math.rad(-0)) * CN(0, 4, 0))
                Current = Wing4
                table.insert(WingThings, {Wing4, CN(0, 3.9, 0)*CA(math.rad(27-W*9), 0, math.rad(-0)), CN(0, 4, 0)})
                table.insert(Tab, Wing4)
        end
        table.insert(WingT, Tab)
end
Wing1B = Part(Dragon, V3(2, 8, 2), Primary, "Slate")
Motor(Wing1B, Wing1B, Torso, CN(), CN(-3, 3, 9.5)*CA(math.rad(-45), 0, math.rad(15))*CN(0, 3.5, 0))
table.insert(WingThings2, {Wing1B, CN(-3, 3, 9.5)*CA(math.rad(-45), 0, math.rad(15)), CN(0, 3.5, 0)})
Wing2B = Part(Dragon, V3(1.6, 8, 1.6), Primary, "Slate")
Motor(Wing2B, Wing2B, Wing1B, CN(), CN(0, 3, 0)*CA(math.rad(90), 0, math.rad(15))*CN(0, 4, 0))
table.insert(WingThings2, {Wing2B, CN(0, 3, 0)*CA(math.rad(90), 0, math.rad(15)), CN(0, 4, 0)})
Wing3B = Part(Dragon, V3(1.2, 8, 1.2), Primary, "Slate")
Motor(Wing3B, Wing3B, Wing2B, CN(), CN(0, 3, 0)*CA(math.rad(-45), 0, math.rad(60))*CN(0, 4, 0))
table.insert(WingThings2, {Wing3B, CN(0, 3, 0)*CA(math.rad(-45), 0, math.rad(60)), CN(0, 4, 0)})
for W = 1, 5 do
        local Current = Wing3B
        local Tab = {}
        for WingThing = 1, 5 do
                local Wing4B = Part(Dragon, V3(0.9-WingThing*0.1, 8, 0.9-WingThing*0.1), Primary, "Slate")
                Motor(Wing4B, Wing4B, Current, CN(), CN(0, 3.9, 0)*CA(math.rad(27-W*9), 0, math.rad(0)) * CN(0, 4, 0))
                Current = Wing4B
                table.insert(WingThings2, {Wing4B, CN(0, 3.9, 0)*CA(math.rad(27-W*9), 0, math.rad(0)), CN(0, 4, 0)})
                table.insert(Tab, Wing4B)
        end
        table.insert(WingT2, Tab)
end
Tail1 = Part(Dragon, V3(7.75, 7.75, 2), Primary, "Slate")
Motor(Tail1, Tail1, Torso, CN(), CN(0, 0, -10)*CA(0, 0, 0)*CN(0, 0, -1))
Tail1B = Part(Dragon, V3(6.75, 0.5, 2.5), Secondary)
Tail1B.Reflectance = 1
Motor(Tail1B, Tail1B, Tail1, CN(), CN(0, -3.875, 0))
table.insert(TailThings, Tail1)
Current = Tail1
for Tail = 1, 28 do
        local Tail2 = Part(Dragon, V3(7.75-Tail*0.25, 7.75-Tail*0.25, 2), Primary, "Slate")
        Motor(Tail2, Tail2, Current, CN(), CN(0, 0, -0.5)*CA(0, 0, 0)*CN(0, 0, -1))
        table.insert(TailThings, Tail2)
        Current = Tail2
        if Tail ~= 28 then
                local Tail2B = Part(Dragon, V3(6.75-Tail*0.25, 0.5, 2.5), Secondary)
                Tail2B.Reflectance = 1
                Motor(Tail2B, Tail2B, Tail2, CN(), CN(0, -Tail2.Size.Y/2, 0))
        end
end
Current = Torso
for Neck = 1, 19 do
        local Neck1 = Part(Dragon, V3(8-Neck*0.2, 8-Neck*0.2, 2), Primary, "Slate")
        Motor(Neck1, Neck1, Current, CN(), CN(0, 0, Current.Size.Z/2-1)*CA(2*math.rad(-math.sin(math.rad(Neck*18))*9), 0, 0)*CN(0, 0, 1))
        Current = Neck1
        local Neck2 = Part(Dragon, V3(7-Neck*0.2, 0.5, 2.5), Secondary)
        Neck2.Reflectance = 1
        Motor(Neck2, Neck2, Neck1, CN(), CN(0, -Neck1.Size.Y/2, 0))
        if Neck > 10 and Neck < 18 then
                Horn = Part(Dragon, V3(1.4, 0.5, 1.4), "Institutional white")
                Cylinder(Horn)
                Motor(Horn, Horn, Neck1, CN(), CN(0, Neck1.Size.Y/2+0.25, 0))
                Current2 = Horn
                for H = 1, 6 do
                        local Horn2 = Part(Dragon, V3(1.4-H*0.2, 0.5, 1.4-H*0.2), "Institutional white")
                        Cylinder(Horn2)
                        Motor(Horn2, Horn2, Current2, CN(), CN(0, 0.5, 0))
                        Current2 = Horn2
                end
        end
end
Head = Part(Dragon, V3(5, 5, 4), Primary, "Slate")
Motor(Head, Head, Current, CN(), CN(0, 0, 3))
UpperLip = Part(Dragon, V3(4.5, 1, 4), Primary, "Slate")
Motor(UpperLip, UpperLip, Head, CN(), CN(0, -0.5, 4))
 
RightNostril = Part(Dragon, V3(1.5, 1, 1.5), Primary, "Slate")
Motor(RightNostril, RightNostril, UpperLip, CN(), CN(-1.25, 0.25, 1))
LeftNostril = Part(Dragon, V3(1.5, 1, 1.5), Primary, "Slate")
Motor(LeftNostril, LeftNostril, UpperLip, CN(), CN(1.25, 0.25, 1))
 
LowerLip = Part(Dragon, V3(4.5, 1, 4), Primary, "Slate")
Motor(LowerLip, LowerLip, Head, CN(), CN(0, -1.5, 1.5)*CA(math.rad(0), 0, 0)*CN(0, 0, 2))
RightEye = Part(Dragon, V3(1, 0.5, 1), "Institutional white")
Motor(RightEye, RightEye, Head, CN(), CN(-1.5, 1, 1.55))
RightPupil = Part(Dragon, V3(0.4, 0.4, 1), "Lime green") --RightPupil.Reflectance = 1
Motor(RightPupil, RightPupil, RightEye, CN(), CN(0, 0, 0.05))
LeftEye = Part(Dragon, V3(1, 0.5, 1), "Institutional white")
Motor(LeftEye, LeftEye, Head, CN(), CN(1.5, 1, 1.55))
LeftPupil = Part(Dragon, V3(0.4, 0.4, 1), "Lime green") --LeftPupil.Reflectance = 1
Motor(LeftPupil, LeftPupil, LeftEye, CN(), CN(0, 0, 0.05))
 
Horn = Part(Dragon, V3(2, 0.5, 2), "Institutional white")
Cylinder(Horn)
Motor(Horn, Horn, Head, CN(), CN(1.25, 2, 0.5)*CA(math.rad(-10), 0, math.rad(-10))*CN(0, 0.25, 0))
Current = Horn
for H = 1, 17 do
        local Horn2 = Part(Dragon, V3(2-H*0.1, 1, 2-H*0.1), "Institutional white")
        Cylinder(Horn2)
        Motor(Horn2, Horn2, Current, CN(), CA(math.rad(-5), 0, math.rad(-5))*CN(0, 0.5, 0))
        Current = Horn2
end
 
Horn = Part(Dragon, V3(2, 0.5, 2), "Institutional white")
Cylinder(Horn)
Motor(Horn, Horn, Head, CN(), CN(-1.25, 2, 0.5)*CA(math.rad(-10), 0, math.rad(10))*CN(0, 0.25, 0))
Current = Horn
for H = 1, 17 do
        local Horn2 = Part(Dragon, V3(2-H*0.1, 1, 2-H*0.1), "Institutional white")
        Cylinder(Horn2)
        Motor(Horn2, Horn2, Current, CN(), CA(math.rad(-5), 0, math.rad(5))*CN(0, 0.5, 0))
        Current = Horn2
end
 
RightFrontLeg = Part(Dragon, V3(5, 10, 5), Primary, "Slate")
Motor(RightFrontLeg, RightFrontLeg, Torso, CN(), CN(-4, 0, 10)*CA(math.rad(60), 0, math.rad(-15))*CN(0, -2, 0))
RightFrontLeg2 = Part(Dragon, V3(3, 14, 3), Primary, "Slate")
Motor(RightFrontLeg2, RightFrontLeg2, RightFrontLeg, CN(), CN(0, -5, 0)*CA(math.rad(-90), 0, math.rad(-0))*CN(0, -5.5, 0))
RightFrontFoot = Part(Dragon, V3(4, 4, 4), Primary, "Slate")
Motor(RightFrontFoot, RightFrontFoot, RightFrontLeg2, CN(), CN(0, -7, 0)*CA(math.rad(30), 0, 0))
 
LeftFrontLeg = Part(Dragon, V3(5, 10, 5), Primary, "Slate")
Motor(LeftFrontLeg, LeftFrontLeg, Torso, CN(), CN(4, 0, 10)*CA(math.rad(-60), 0, math.rad(15))*CN(0, -2, 0))
LeftFrontLeg2 = Part(Dragon, V3(3, 14, 3), Primary, "Slate")
Motor(LeftFrontLeg2, LeftFrontLeg2, LeftFrontLeg, CN(), CN(0, -5, 0)*CA(math.rad(-90), 0, 0)*CN(0, -5.5, 0))
LeftFrontFoot = Part(Dragon, V3(4, 4, 4), Primary, "Slate")
Motor(LeftFrontFoot, LeftFrontFoot, LeftFrontLeg2, CN(), CN(0, -7, 0)*CA(math.rad(30), 0, 0))
 
RightBackLeg = Part(Dragon, V3(5, 10, 5), Primary, "Slate")
Motor(RightBackLeg, RightBackLeg, Torso, CN(), CN(-4, 0, -7)*CA(math.rad(30), 0, math.rad(-0))*CN(0, -2, 0))
RightBackLeg2 = Part(Dragon, V3(3, 14, 3), Primary, "Slate")
Motor(RightBackLeg2, RightBackLeg2, RightBackLeg, CN(), CN(0, -5, 0)*CA(math.rad(15), 0, math.rad(-0))*CN(0, -5.5, 0))
RightBackFoot = Part(Dragon, V3(4, 4, 4), Primary, "Slate")
Motor(RightBackFoot, RightBackFoot, RightBackLeg2, CN(), CN(0, -7, 0)*CA(math.rad(90), 0, 0))
 
LeftBackLeg = Part(Dragon, V3(5, 10, 5), Primary, "Slate")
Motor(LeftBackLeg, LeftBackLeg, Torso, CN(), CN(4, 0, -7)*CA(math.rad(-30), 0, math.rad(0))*CN(0, -2, 0))
LeftBackLeg2 = Part(Dragon, V3(3, 14, 3), Primary, "Slate")
Motor(LeftBackLeg2, LeftBackLeg2, LeftBackLeg, CN(), CN(0, -5, 0)*CA(math.rad(75), 0, math.rad(-0))*CN(0, -5.5, 0))
LeftBackFoot = Part(Dragon, V3(4, 4, 4), Primary, "Slate")
Motor(LeftBackFoot, LeftBackFoot, LeftBackLeg2, CN(), CN(0, -7, 0)*CA(math.rad(90), 0, 0))
 
New'BodyPosition'{Parent = Torso, maxForce = V3(1/0, 1/0, 1/0), position = V3(100, 25, 100)}
Gyro = New'BodyGyro'{Parent = Torso, maxTorque = V3(1/0, 1/0, 1/0), P = 5000, D = 120}
Torso.CFrame = CN(100, 25, 100)
 
for A = 1, #WingT-1 do
        for B = 1, #WingT[A] do
                wait()
                local Part1, Part2 = WingT[A][B], WingT[A+1][B]
                local P1, P2, P3, P4 = (Part1.CFrame * CFrame.new(0, 4, 0)).p, (Part1.CFrame * CFrame.new(0, -4, 0)).p, (Part2.CFrame * CFrame.new(0, 4, 0)).p, (Part2.CFrame * CFrame.new(0, -4, 0)).p
                local C1, C2, S1, S2 = GetTriangleValues{P1, P2, P3}
                local T1, T2 = Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3), Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3) T1.CanCollide = false T2.CanCollide = false
                T1.Reflectance = 1 T2.Reflectance = 1
                local M1, M2 = Mesh(T1, "Wedge", S1), Mesh(T2, "Wedge", S2)
                local W1, W2 = Motor(T1, Part1, T1, Part1.CFrame:toObjectSpace(C1)), Motor(T2, Part1, T2, Part1.CFrame:toObjectSpace(C2))
                local C1, C2, S1, S2 = GetTriangleValues{P4, P2, P3}
                local T3, T4 = Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3), Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3) T3.CanCollide = false T4.CanCollide = false
                T3.Reflectance = 1 T4.Reflectance = 1
                local M3, M4 = Mesh(T3, "Wedge", S1), Mesh(T4, "Wedge", S2)
                local W3, W4 = Motor(T3, Part1, T3, Part1.CFrame:toObjectSpace(C1)), Motor(T4, Part1, T4, Part1.CFrame:toObjectSpace(C2))
                WingT[A][B] = {Part1, Part2, M1, W1, M2, W2, M3, W3, M4, W4}
                -- Wing 2
                local Part1, Part2 = WingT2[A][B], WingT2[A+1][B]
                local P1, P2, P3, P4 = (Part1.CFrame * CFrame.new(0, 4, 0)).p, (Part1.CFrame * CFrame.new(0, -4, 0)).p, (Part2.CFrame * CFrame.new(0, 4, 0)).p, (Part2.CFrame * CFrame.new(0, -4, 0)).p
                local C1, C2, S1, S2 = GetTriangleValues{P1, P2, P3}
                local T1, T2 = Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3), Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3) T1.CanCollide = false T2.CanCollide = false
                T1.Reflectance = 1 T2.Reflectance = 1
                local M1, M2 = Mesh(T1, "Wedge", S1), Mesh(T2, "Wedge", S2)
                local W1, W2 = Motor(T1, Part1, T1, Part1.CFrame:toObjectSpace(C1)), Motor(T2, Part1, T2, Part1.CFrame:toObjectSpace(C2))
                local C1, C2, S1, S2 = GetTriangleValues{P4, P2, P3}
                local T3, T4 = Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3), Part(Dragon, V3(0.2, 0.2, 0.2), Secondary, "Glass", 0.3) T3.CanCollide = false T4.CanCollide = false
                T3.Reflectance = 1 T4.Reflectance = 1
                local M3, M4 = Mesh(T3, "Wedge", S1), Mesh(T4, "Wedge", S2)
                local W3, W4 = Motor(T3, Part1, T3, Part1.CFrame:toObjectSpace(C1)), Motor(T4, Part1, T4, Part1.CFrame:toObjectSpace(C2))
                WingT2[A][B] = {Part1, Part2, M1, W1, M2, W2, M3, W3, M4, W4}
        end
end
 
Angl = 0
Angl2 = 0
RS.Stepped:connect(function()
        Angl = Angl+0.03
		
		RightFrontLeg.Motor6D.C1 = CN(-4, 0, 10)*CA(math.rad(60), 0, math.rad(-15))*CN(0, -2, 0)
		RightFrontLeg2.Motor6D.C1 = CN(0, -5, 0)*CA(math.rad(-90), 0, math.rad(-0))*CN(0, -5.5, 0)
		
		RightBackLeg.Motor6D.C1 = CN(-4, 0, -7)*CA(math.rad(30), 0, math.rad(-0))*CN(0, -2, 0)
		RightBackLeg2.Motor6D.C1 = CN(0, -5, 0)*CA(math.rad(15), 0, math.rad(-0))*CN(0, -5.5, 0)
		
		LeftFrontLeg.Motor6D.C1 = CN(4, 0, 10)*CA(math.rad(-60), 0, math.rad(15))*CN(0, -2, 0)
		LeftFrontLeg2.Motor6D.C1 = CN(0, -5, 0)*CA(math.rad(-90), 0, 0)*CN(0, -5.5, 0)
		
		LeftBackLeg.Motor6D.C1 = CN(4, 0, -7)*CA(math.rad(-30), 0, math.rad(0))*CN(0, -2, 0)
		LeftBackLeg2.Motor6D.C1 = CN(0, -5, 0)*CA(math.rad(75), 0, math.rad(-0))*CN(0, -5.5, 0)
		
        for T = 1, #TailThings do
                TailThings[T]:WaitForChild("Motor6D").C1 = CN(0, 0, -((TailThings[T-1] or Torso).Size.Z/2)+0.5)*CA(math.rad(-4), math.rad(math.sin(math.rad(Angl)*18)*2), 0)*CN(0, 0, -TailThings[T].Size.Z/2)
        end
		
		
        for W = 1, #WingThings do
                local Dist = math.abs((#WingThings*#WingThings[W])/2-W)*math.rad(30)
                WingThings[W][1]:WaitForChild("Motor6D").C1 = WingThings[W][2]*CA(0, 0, math.rad(math.sin(Angl)*Dist))*WingThings[W][3]
                WingThings2[W][1]:WaitForChild("Motor6D").C1 = WingThings2[W][2]*CA(0, 0, math.rad(math.sin(Angl)*-Dist))*WingThings2[W][3]
        end
		
		
		
        Wing1:WaitForChild("Motor6D").C1 = CN(3, 2, 5.5)*CA(math.rad(-15), 0, math.rad(-45+math.sin(Angl-math.pi/4)*-30))*CN(0, 3.5, 0)
        Wing1B:WaitForChild("Motor6D").C1 = CN(-3, 2, 5.5)*CA(math.rad(-15), 0, math.rad(45+math.sin(Angl-math.pi/4)*30))*CN(0, 3.5, 0)
		
		
        --wing fills
		for A = 1, #WingT-1 do
                for B = 1, #WingT[A] do
                        local Part1, Part2 = WingT[A][B][1], WingT[A][B][2]
                        local P1, P2, P3, P4 = (Part1.CFrame * CFrame.new(0, 4, 0)).p, (Part1.CFrame * CFrame.new(0, -4, 0)).p, (Part2.CFrame * CFrame.new(0, 4, 0)).p, (Part2.CFrame * CFrame.new(0, -4, 0)).p
                        local C1, C2, S1, S2 = GetTriangleValues{P1, P2, P3}
                        WingT[A][B][3].Scale = S1
                        WingT[A][B][4].C0 = Part1.CFrame:toObjectSpace(C1)
                        WingT[A][B][5].Scale = S2
                        WingT[A][B][6].C0 = Part1.CFrame:toObjectSpace(C2)
                        local C1, C2, S1, S2 = GetTriangleValues{P4, P2, P3}
                        WingT[A][B][7].Scale = S1
                        WingT[A][B][8].C0 = Part1.CFrame:toObjectSpace(C1)
                        WingT[A][B][9].Scale = S2
                        WingT[A][B][10].C0 = Part1.CFrame:toObjectSpace(C2)
                        -- Wing 2
                        local Part1, Part2 = WingT2[A][B][1], WingT2[A][B][2]
                        local P1, P2, P3, P4 = (Part1.CFrame * CFrame.new(0, 4, 0)).p, (Part1.CFrame * CFrame.new(0, -4, 0)).p, (Part2.CFrame * CFrame.new(0, 4, 0)).p, (Part2.CFrame * CFrame.new(0, -4, 0)).p
                        local C1, C2, S1, S2 = GetTriangleValues{P1, P2, P3}
                        WingT2[A][B][3].Scale = S1
                        WingT2[A][B][4].C0 = Part1.CFrame:toObjectSpace(C1)
                        WingT2[A][B][5].Scale = S2
                        WingT2[A][B][6].C0 = Part1.CFrame:toObjectSpace(C2)
                        local C1, C2, S1, S2 = GetTriangleValues{P4, P2, P3}
                        WingT2[A][B][7].Scale = S1
                        WingT2[A][B][8].C0 = Part1.CFrame:toObjectSpace(C1)
                        WingT2[A][B][9].Scale = S2
                        WingT2[A][B][10].C0 = Part1.CFrame:toObjectSpace(C2)
                end
        end
end)
while true do
        wait(math.random(1, 5))
        local RightEyeLid = Part(Dragon, V3(1, 1, 1), Primary, "Slate")
        local RELM = Mesh(RightEyeLid, "Brick", V3(1.1, 0, 1.2))
        local RELW = Motor(RightEyeLid, RightEyeLid, RightEye, CN(), CN(0, 0.3, 0))
        local LeftEyeLid = Part(Dragon, V3(1, 1, 1), Primary, "Slate")
        local LELM = Mesh(LeftEyeLid, "Brick", V3(1.1, 0, 1.2))
        local LELW = Motor(LeftEyeLid, LeftEyeLid, LeftEye, CN(), CN(0, 0.3, 0))
        for L = 1, 10 do
                RELM.Scale = RELM.Scale+V3(0, 0.06, 0)
                RELW.C1 = RELW.C1*CN(0, -0.03, 0)
                LELM.Scale = LELM.Scale+V3(0, 0.06, 0)
                LELW.C1 = LELW.C1*CN(0, -0.03, 0)
                wait(0.01)
        end
        wait(math.random(1, 10)/10)
        for L = 1, 10 do
                RELM.Scale = RELM.Scale+V3(0, -0.06, 0)
                RELW.C1 = RELW.C1*CN(0, 0.03, 0)
                LELM.Scale = LELM.Scale+V3(0, -0.06, 0)
                LELW.C1 = LELW.C1*CN(0, 0.03, 0)
                wait(0.01)
        end
        RightEyeLid:Destroy()
        LeftEyeLid:Destroy()
		Gyro.cframe = CN(math.random(-100, 100), math.random(-10, 10), math.random(-100, 100))
end