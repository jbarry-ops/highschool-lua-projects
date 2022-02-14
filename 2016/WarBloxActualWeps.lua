--First person shooter thing for bro
--Very useful functions and stuff:
CN, V3, U2, BN, C3 = CFrame.new, Vector3.new, UDim2.new, BrickColor.new, Color3.new
function CA(X, Y, Z)
        return CFrame.Angles(math.rad(X or 0), math.rad(Y or 0), math.rad(Z or 0))
end
function New(InstanceType)
        local NewInstance = Instance.new(InstanceType)
        if NewInstance:IsA("BasePart") then
                pcall(function() NewInstance.FormFactor = 3 end)
                NewInstance.Size = V3(1, 1, 1)
                --NewInstance.Anchored = true
                NewInstance.Material = "SmoothPlastic"
                NewInstance.TopSurface = 0
                NewInstance.BottomSurface = 0
                NewInstance.Locked = true
        elseif NewInstance:IsA("GuiObject") then
                NewInstance.Size = U2(1, 0, 1, 0)
                NewInstance.BorderSizePixel = 0
                NewInstance.BackgroundColor3 = C3()
                if NewInstance:IsA("TextBox") or NewInstance:IsA("TextLabel") or NewInstance:IsA("TextButton") then
                        NewInstance.Text = ""
                        NewInstance.TextColor3 = C3(1, 1, 1)
                        NewInstance.BackgroundTransparency = 1
                elseif NewInstance:IsA("ImageLabel") or NewInstance:IsA("ImageButton") then
                        NewInstance.BackgroundTransparency = 1
                end
        end
        return function(Properties)
                for Property, Value in pairs(Properties) do
                        NewInstance[Property] = Value
                end
                if Properties.CFrame then NewInstance.CFrame = Properties.CFrame end
                return NewInstance
        end
end
function Part(Parent, Size, CFrame, BrickColor, Material, Transparency)
        return New'Part'{Parent = Parent, Size = Size, CFrame = CFrame, BrickColor = BN(BrickColor or "Black"), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
end
function Wedge(Parent, Size, CFrame, BrickColor, Material, Transparency)
        return New'WedgePart'{Parent = Parent, Size = Size, CFrame = CFrame, BrickColor = BN(BrickColor or "Black"), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
end
function Mesh(Parent, MeshType, Scale, MeshId, TextureId)
        return New'SpecialMesh'{Parent = Parent, MeshType = MeshType or "Sphere", Scale = Scale or V3(1, 1, 1), MeshId = MeshId or "", TextureId = TextureId or ""}
end
function Cylinder(Parent, Scale)
        return New'CylinderMesh'{Parent = Parent, Scale = Scale or V3(1, 1, 1)}
end
function Block(Parent, Scale)
        return New'BlockMesh'{Parent = Parent, Scale = Scale or V3(1, 1, 1)}
end
function Motor(Parent, Part0, Part1, C0, C1)
        return New'Motor6D'{Parent = Parent, Part0 = Part0, Part1 = Part1, C0 = C0 or CN(), C1 = C1 or CN()}
end
function GetTriangleValues(Points, Width)
        for _, Point in pairs(Points) do
                if Point.p then
                        Points[_] = Point.p
                end
        end
        local G, V = 0
        for S = 1, 3 do
                local L = (Points[1+(S+1)%3]-Points[1+S%3]).magnitude
                G, V = L > G and L or G, L > G and {Points[1+(S-1)%3], Points[1+(S)%3], Points[1+(S+1)%3]} or V
        end
        local D = V[2]+(V[3]-V[2]).unit*((V[3]-V[2]).unit:Dot(V[1]-V[2]))
        local C, B = (D-V[1]).unit, (V[2]-V[3]).unit
        local A = B:Cross(C)
        S1 = V3(Width, (V[2]-D).magnitude, (V[1]-D).magnitude)--/0.2
        S2 = V3(Width, (V[3]-D).magnitude, (V[1]-D).magnitude)--/0.2
        C1 = CN(0,0,0,A.X,B.X,C.X,A.Y,B.Y,C.Y,A.Z,B.Z,C.Z)+(V[1]+V[2])/2
        C2 = CN(0,0,0,-A.X,-B.X,C.X,-A.Y,-B.Y,C.Y,-A.Z,-B.Z,C.Z)+(V[1]+V[3])/2
        return C1, C2, S1, S2
end
function QuaternionFromCFrame(cf)
        local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components() 
        local trace = m00+m11+m22 
        if trace > 0 then 
                local s = math.sqrt(1+trace) 
                local recip = 0.5/s 
                return (m21-m12)*recip, (m02-m20)*recip, (m10-m01)*recip, s*0.5 
        else 
                local i = 0 
                if m11 > m00 then 
                        i = 1 
                end 
                if m22 > (i == 0 and m00 or m11) then 
                        i = 2 
                end 
                if i == 0 then 
                        local s = math.sqrt(m00-m11-m22+1) 
                        local recip = 0.5/s 
                        return 0.5*s, (m10+m01)*recip, (m20+m02)*recip, (m21-m12)*recip 
                elseif i == 1 then 
                        local s = math.sqrt(m11-m22-m00+1) 
                        local recip = 0.5/s 
                        return (m01+m10)*recip, 0.5*s, (m21+m12)*recip, (m02-m20)*recip 
                elseif i == 2 then 
                        local s = math.sqrt(m22-m00-m11+1) 
                        local recip = 0.5/s 
                        return (m02+m20)*recip, (m12+m21)*recip, 0.5*s, (m10-m01)*recip 
                end 
        end 
end
function QuaternionToCFrame(px, py, pz, x, y, z, w)
        local xs, ys, zs = x+x, y+y, z+z
        local wx, wy, wz = w*xs, w*ys, w*zs
        local xx = x*xs
        local xy = x*ys
        local xz = x*zs
        local yy = y*ys
        local yz = y*zs
        local zz = z*zs
        return CFrame.new(px, py, pz, 1-(yy+zz), xy-wz, xz+wy, xy+wz, 1-(xx+zz), yz-wx, xz-wy, yz+wx, 1-(xx+yy))
end
function QuaternionSlerp(a, b, t)
        local cosTheta = a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4]
        local startInterp, finishInterp;
        if cosTheta >= 0.0001 then
                if (1-cosTheta) > 0.0001 then
                        local theta = math.acos(cosTheta)
                        local invSinTheta = 1/math.sin(theta)
                        startInterp = math.sin((1-t)*theta)*invSinTheta
                        finishInterp = math.sin(t*theta)*invSinTheta
                else
                        startInterp = 1-t
                        finishInterp = t
                end
        else
                if (1+cosTheta) > 0.0001 then
                        local theta = math.acos(-cosTheta)
                        local invSinTheta = 1/math.sin(theta)
                        startInterp = math.sin((t-1)*theta)*invSinTheta
                        finishInterp = math.sin(t*theta)*invSinTheta
                else
                        startInterp = t-1
                        finishInterp = t
                end
        end
        return a[1]*startInterp+b[1]*finishInterp, a[2]*startInterp+b[2]*finishInterp, a[3]*startInterp+b[3]*finishInterp, a[4]*startInterp+b[4]*finishInterp
end
function Lerp(a, b, t)
        local qa = {QuaternionFromCFrame(a)}
        local qb = {QuaternionFromCFrame(b)}
        local ax, ay, az = a.x, a.y, a.z
        local bx, by, bz = b.x, b.y, b.z
        local _t = 1-t
        return QuaternionToCFrame(_t*ax+t*bx, _t*ay+t*by, _t*az+t*bz, QuaternionSlerp(qa, qb, t))
end
function AddPart(Parent, Size, Part0, C0, BrickColor, Material, Transparency)
        local NewPart = Part(Parent, V3(1, 1, 1), Part0.CFrame, BrickColor, Material, Transparency)
        NewPart.CanCollide = false
        Block(NewPart, Size)
        local NewMotor = Motor(NewPart, Part0, NewPart, C0)
        return NewPart, NewMotor
end
function AddWedge(Parent, Size, Part0, C0, BrickColor, Material, Transparency)
        local NewWedge = Wedge(Parent, V3(1, 1, 1), Part0.CFrame, BrickColor, Material, Transparency)
        NewWedge.CanCollide = false
        Mesh(NewWedge, "Wedge", Size)
        local NewMotor = Motor(NewWedge, Part0, NewWedge, C0)
        return NewWedge, NewMotor
end
function Sniper(Parent, CFrame, Anchored, Colors)
        local Gun = New'Model'{Parent = Parent, Name = "Sniper"}
        local MainPart = Part(Gun, V3(0.35, 0.5, 3), CFrame, Colors[1], "SmoothPlastic", 0, Anchored)
        local HandleStart = AddPart(Gun, V3(0.3, 0.1, 0.8), MainPart, CN(0, -0.3, 0.9), Colors[1])
        local HandleStart2 = AddWedge(Gun, V3(0.3, 0.1, 0.2), HandleStart, CN(0, 0, 0.5)*CA(180, 0, 0), Colors[1])
        local Handle = AddPart(Gun, V3(0.3, 0.75, 0.35), HandleStart, CN(0, 0, 0.2)*CA(-15, 0, 0)*CN(0, -0.375, 0), Colors[1])
        --Trigger
        local Triggerbox1 = AddPart(Gun, V3(0.1, 0.23, 0.04), HandleStart, CN(0, -0.165, 0), Colors[1])
        local Triggerbox2 = AddPart(Gun, V3(0.1, 0.23, 0.04), HandleStart, CN(0, -0.165, -0.38), Colors[1])
        local Triggerbox3 = AddPart(Gun, V3(0.1, 0.04, 0.34), HandleStart, CN(0, -0.3, -0.19), Colors[1])
        local Triggerbox4 = AddWedge(Gun, V3(0.3, 0.1, 0.2), HandleStart, CN(0, 0, -0.5)*CA(0, 0, 180), Colors[1]) -- -0.33, -0.115
        for A = -1, 1, 2 do
                local TriggerboxSmooth = AddWedge(Gun, V3(0.1, 0.04, 0.04), Triggerbox3, CA(0, 90+90*A, 0)*CN(0, 0, -0.19)*CA(0, 0, 180), Colors[1])
        end
        local Trigger1 = AddPart(Gun, V3(0.04, 0.15, 0.04), HandleStart, CN(0, -0.03, -0.175)*CA(-20, 0, 0)*CN(0, -0.05, 0), Colors[1])
        local Trigger2 = AddPart(Gun, V3(0.04, 0.1, 0.04), Trigger1, CN(0, -0.055, 0)*CA(40, 0, 0)*CN(0, -0.05, 0), Colors[1])
        local BarrelStart = AddPart(Gun, V3(0.35, 0.3, 0.4), MainPart, CN(0, 0.1, -1.7), Colors[1])
        local TopBarrel = AddPart(Gun, V3(0.2, 2, 0.2), BarrelStart, CN(0, 0, -1.2)*CA(90, 0, 0), Colors[1])
        Cylinder(TopBarrel, V3(0.2, 2, 0.2))
        local TopBarrelEnd = AddPart(Gun, V3(0.275, 0.75, 0.275), TopBarrel, CN(0, -1.375, 0), Colors[1])
        Cylinder(TopBarrelEnd, V3(0.3, 0.5, 0.3))
        local BottomBarrelStart = AddPart(Gun, V3(0.3, 0.3, 0.6), BarrelStart, CN(0, -0.15, -0.1), Colors[1])
        local BottomBarrelStartSmooth = AddPart(Gun, V3(0.3, 0.6, 0.3), BottomBarrelStart, CN(0, 0.15, 0)*CA(90, 0, 0), Colors[1])
        Cylinder(BottomBarrelStartSmooth, V3(0.3, 0.6, 0.3))
        return MainPart
end
 
 
--The actual things:
Player = Game:GetService("Players").LocalPlayer
Camera = Workspace.CurrentCamera
PlayerGui = Player:WaitForChild("PlayerGui")
Mouse = Player:GetMouse()
UIS = Game:GetService("UserInputService")
Debris = Game:GetService("Debris")
StarterGui = Game:GetService("StarterGui")
 
Player.CameraMode = "Classic" --LockFirstPerson
Camera:ClearAllChildren()
--UIS.MouseIconEnabled = false
Mouse.TargetFilter = Workspace
--StarterGui:SetCoreGuiEnabled(1, false) --Health
--StarterGui:SetCoreGuiEnabled(2, false) --Backpack
 
for _, Gui in pairs(PlayerGui:GetChildren()) do
        if Gui.Name == "Game Gui" then
                Gui:Destroy()
        end
end
 
MainGui = New'ScreenGui'{Parent = PlayerGui, Name = "Game Gui"}
MainFrame = New'Frame'{Parent = MainGui}
RedVignette = New'ImageLabel'{Parent = MainFrame, Size = U2(1, 4, 1, 4), Position = U2(0, -2, 0, -2), Image = "rbxassetid://192656604", ImageTransparency = 1}
BlackVignette = New'ImageLabel'{Parent = MainFrame, Size = U2(1, 4, 1, 4), Position = U2(0, -2, 0, -2), Image = "rbxassetid://192776775", ImageTransparency = 0}
 
repeat wait() until Player.Character
Character = Player.Character
Humanoid = Character:WaitForChild("Humanoid")
Torso = Character:WaitForChild("Torso")
Head = Character:WaitForChild("Head")
RealRightArm = Character:WaitForChild("Right Arm")
RealLeftArm = Character:WaitForChild("Left Arm")
RightLeg = Character:WaitForChild("Right Leg")
LeftLeg = Character:WaitForChild("Left Leg")
 
RealRightArm:BreakJoints()
RealLeftArm:BreakJoints()
RealRightArm.Anchored = true
RealLeftArm.Anchored = true
RealRightArm.Transparency = 1
RealLeftArm.Transparency = 1
 
for _, Obj in pairs(Character:GetChildren()) do
        if (Obj:IsA("LocalScript") and Obj ~= script) then
                Obj.Disabled = true
                Obj:Destroy()
        end
end
 
Arms = New'Model'{Parent = Workspace, Name = "Arms"}
RightArm = Part(Arms, V3(1, 2, 1), Camera.CoordinateFrame, tostring(RealRightArm.BrickColor)) RightArm.Anchored = true RightArm.CanCollide = false
RightArmBevel = Mesh(RightArm, "FileMesh", V3(1, 1, 1), "rbxasset://fonts/rightarm.mesh")
LeftArm = Part(Arms, V3(1, 2, 1), Camera.CoordinateFrame, tostring(RealRightArm.BrickColor)) LeftArm.Anchored = true LeftArm.CanCollide = false
LeftArmBevel = Mesh(LeftArm, "FileMesh", V3(1, 1, 1), "rbxasset://fonts/leftarm.mesh")
 
RightArmOffset = CN(1, -1.5, 0)
RightArmRotation = CA()
RightArmLength = 2
LeftArmOffset = CN(-3, -1.5, 0)
LeftArmEndOffset = CN(0, 0, 0)
ArmWidth = 0.5
Weapon = nil
WeaponHandleOffset = CN(0, 0, 0)*CA(-90, 0, 0)
 
Equipped = ""
Running = false
Sprinting = false
AimingDownSight = false
 
function Equip(Wep)
        if Weapon then Weapon:Destroy() end
        if Wep == "RocketLauncher" then
                
                RightArmOffset = CN(1, -1, 0)
                RightArmRotation = CA()
                RightArmLength = 2
                LeftArmOffset = CN(-1, -1, 0)
                LeftArmEndOffset = CN(0, -1, 0)
                WeaponHandleOffset = CN(0, 0, 0)*CA(-90, 0, 0)
                
                Weapon = New'Model'{Parent = Workspace, Name = "Weapon"}
                local Handle = Part(Weapon, V3(0.3, 1, 0.3), RightArm.CFrame) Handle.Name = "Handle" Handle.Anchored = true Handle.CanCollide = false
                Cylinder(Handle)
                local Handle2 = Part(Weapon, V3(0.3, 1, 0.3), RightArm.CFrame) Handle2.CanCollide = false
                Cylinder(Handle2)
                Motor(Handle2, Handle, Handle2, CN(0, 0, -1))
                local Barrel = Part(Weapon, V3(0.4, 3, 0.4), RightArm.CFrame) Barrel.Name = "Barrel" Barrel.CanCollide = false
                Cylinder(Barrel)
                Motor(Barrel, Handle, Barrel, CN(0, 0.5, 0)*CA(-90, 0, 0))
                local BarrelHole = Part(Weapon, V3(0.3, 3, 0.3), RightArm.CFrame, "Really black") BarrelHole.CanCollide = false
                Cylinder(BarrelHole)
                Motor(BarrelHole, Barrel, BarrelHole, CN(0, 0.005, 0))
                local BarrelEnd = Part(Weapon, V3(), RightArm.CFrame, "Black", "SmoothPlastic", 1) BarrelEnd.Name = "BarrelEnd" BarrelEnd.CanCollide = false
                Motor(BarrelEnd, Barrel, BarrelEnd, CN(0, 1.5, 0))
        elseif Wep == "Sniper" then
                
                RightArmOffset = CN(1, -1, 0)
                RightArmRotation = CA()
                RightArmLength = 2
                LeftArmOffset = CN(-1, -1, 0)
                LeftArmEndOffset = CN(0, -1, 0)
                WeaponHandleOffset = CN(0, -1, -0.5)*CA(-90, 0, 0)
                
                local Handle = Sniper(Workspace, RightArm.CFrame, false, {"Black"})
                Handle.Parent.Name = "Weapon"
                Weapon = Handle.Parent
                Handle.Name = "Handle"
                
        end
        Equipped = Wep
end
Equip("RocketLauncher")
 
DesiredRightArmOffset = RightArmOffset
DesiredLeftArmOffset = LeftArmOffset
DesiredWeaponHandleOffset = WeaponHandleOffset
Enabled = true
 
Humanoid.Running:connect(function(Speed)
        if Speed > 1 then
                Running = true
        else
                Running = false
        end
end)
 
OldHealth = Humanoid.Health
TimeSinceLastDamage = 0
Humanoid.HealthChanged:connect(function()
        if Humanoid.Health < OldHealth then
                local HealthDifference = OldHealth-Humanoid.Health
                OldHealth = Humanoid.Health
                RedVignette.ImageTransparency = RedVignette.ImageTransparency-HealthDifference/100
                if RedVignette.ImageTransparency < 0 then RedVignette.ImageTransparency = 0 end
                TimeSinceLastDamage = 0
        end
end)
 
Humanoid.Died:connect(function()
        Player.CameraMode = 0
        UIS.MouseIconEnabled = true
        --Arms:Destroy()
        --if Weapon then Weapon:Destroy() end
end)
 
Mouse.Button1Down:connect(function()
        if not Enabled then return end
        Enabled = false
        local MouseHit = Mouse.Hit
        if Equipped == "RocketLauncher" then
                local MuzzleFlashPart = Part(Weapon, V3(1, 1, 1), Weapon.BarrelEnd.CFrame, "Black", "SmoothPlastic", 1)
                --MuzzleFlashPart.Anchored = true
                MuzzleFlashPart.CanCollide = false
                --MuzzleFlashPart.CFrame = Weapon.BarrelEnd.CFrame
                Motor(MuzzleFlashPart, Weapon.BarrelEnd, MuzzleFlashPart, CN(0, 0.4, 0))
                local MuzzleFlash = New'BillboardGui'{Parent = MuzzleFlashPart, Adornee = MuzzleFlashPart, Size = U2(2, 0, 2, 0)}
                local Flash = New'ImageLabel'{Parent = MuzzleFlash, Size = U2(1, 0, 1, 0), Rotation = 0, BackgroundTransparency = 1, Image = "rbxassetid://192664810", ImageTransparency = 0}
                local Smoke = New'ImageLabel'{Parent = MuzzleFlash, Size = U2(1, 0, 1, 0), Rotation = math.random(-180, 180), BackgroundTransparency = 1, Image = "rbxassetid://122434532", ImageTransparency = 0}
                local LightFlash = New'PointLight'{Parent = Weapon.BarrelEnd, Range = 25, Brightness = 1, Color = C3(0.8, 0.6, 0.2)}
                Spawn(function()
                        for A = 1, 10 do
                                wait(0.05)
                                Flash.ImageTransparency = Flash.ImageTransparency+0.5
                                Smoke.ImageTransparency = Smoke.ImageTransparency+0.1
                                Smoke.Rotation = Smoke.Rotation+3
                                LightFlash.Range = LightFlash.Range-5
                        end
                        MuzzleFlashPart:Destroy()
                        LightFlash:Destroy()
                end)
                for A = 1, 2 do
                        wait(0.01)
                        RightArmRotation = RightArmRotation*CN(0, 0, 1)
                end
                local MissileStart = Weapon.BarrelEnd.CFrame
                local NewMissile = Part(Workspace, V3(0.5, 0.5, 0.5), MissileStart, "Black") NewMissile.CanCollide = false
                Mesh(NewMissile, "Sphere")
                NewMissile.Velocity = ((MissileStart*CN(0, 10, 0)).p-MissileStart.p).unit*600
                NewMissile.Touched:connect(function(Part)
                        local HitP = NewMissile.Position
                        if Part:IsDescendantOf(Camera) or Part:IsDescendantOf(Weapon) or Part:IsDescendantOf(Character) then return end
                        local Explosion = New'Explosion'{Parent = Workspace, Position = HitP, BlastRadius = 7, BlastPressure = 0}
                        Explosion.Hit:connect(function(Part)
                                for _, Obj in pairs(Part.Parent:GetChildren()) do
                                        if Obj:IsA("Humanoid") then
                                                Obj:TakeDamage(7)
                                        end
                                end
                        end)
                        NewMissile:Destroy()
                end)
                Debris:AddItem(NewMissile, 14)
                for A = 1, 10 do
                        wait(0.01)
                        RightArmRotation = RightArmRotation*CN(0, 0, -0.2)
                end
        end
        Enabled = true
end)
 
Mouse.Button2Down:connect(function()
        AimingDownSight = true
        if Equipped == "RocketLauncher" then
                RightArmOffset = CN(0, -1.15, 0)
                LeftArmOffset = CN(-1, -1.15, 0)
        end
end)
 
Mouse.Button2Up:connect(function()
        AimingDownSight = false
        if Equipped == "RocketLauncher" then
                RightArmOffset = CN(1, -1, 0)
                LeftArmOffset = CN(-1, -1, 0)
        end
end)
 
--[[UIS.InputBegan:connect(function(Input)
        if Input.KeyCode.Name == "LeftShift" then
                Sprinting = true
        end
end)
 
UIS.InputEnded:connect(function(Input)
        if Input.KeyCode.Name == "LeftShift" then
                Sprinting = false
        end
end)]]
 
T = 0
LastTick = tick()
Game:GetService("RunService").RenderStepped:connect(function()
        --[[if Sprinting then
                Humanoid.WalkSpeed = 22.5
                if Running then
                        WeaponHandleOffset = CN(0, 0, 0)*CA(-90, 90, 0)
                        LeftArmEndOffset = (RightArm.CFrame*CN(0, -RightArmLength/2, 0)):toObjectSpace(Weapon.Handle.CFrame*CN(0, 0, 1))
                        LeftArmEndOffset = CA(0, 0, -90)*CN(0, -1, 0)
                end
        end]]
        if AimingDownSight then
                Humanoid.WalkSpeed = 7.5
        end
        if not Sprinting and not AimingDownSight then
                Humanoid.WalkSpeed = 15
        end
        
        DesiredRightArmOffset = Lerp(DesiredRightArmOffset, RightArmOffset, 0.25)
        DesiredLeftArmOffset = Lerp(DesiredLeftArmOffset, LeftArmOffset, 0.25)
        DesiredWeaponHandleOffset = Lerp(DesiredWeaponHandleOffset, WeaponHandleOffset, 0.25)
        RightArm.Size = V3(ArmWidth, RightArmLength, ArmWidth)
        RightArmBevel.Scale = V3(ArmWidth, RightArmLength/2, ArmWidth)
        local RelativeMouseCf = Camera.CoordinateFrame:toObjectSpace(CN(Mouse.Hit.p))
        --RightArm.CFrame = Lerp(RightArm.CFrame, Camera.CoordinateFrame*CN(RightArmOffset.p, RelativeMouseCf.p)*RightArmRotation*CA(90, 0, 0)*CN(0, -RightArmLength/2, 0), 0.25)
        RightArm.CFrame = Camera.CoordinateFrame*CN(DesiredRightArmOffset.p, RelativeMouseCf.p)*RightArmRotation*CA(90, 0, 0)*CN(0, -RightArmLength/2, 0)
        local EndPos = Camera.CoordinateFrame:toObjectSpace(RightArm.CFrame*CN(0, -RightArmLength/2, 0)*LeftArmEndOffset)
        local LeftArmLength = (EndPos.p-DesiredLeftArmOffset.p).magnitude
        LeftArm.Size = V3(ArmWidth, LeftArmLength, ArmWidth)
        LeftArmBevel.Scale = V3(ArmWidth, LeftArmLength/2, ArmWidth)
        LeftArm.CFrame = Camera.CoordinateFrame*CN(DesiredLeftArmOffset.p, EndPos.p)*CA(90, 0, 0)*CN(0, -LeftArmLength/2, 0)
        RealRightArm.CFrame = RightArm.CFrame
        RealLeftArm.CFrame = LeftArm.CFrame
        if Weapon then
                Weapon.Handle.CFrame = RightArm.CFrame*CN(0, -RightArmLength/2, 0)*DesiredWeaponHandleOffset
        end
        RightArmOffset = RightArmOffset*CN(0, math.sin(T*0.05)*0.001, 0)
        T = T+1
        local Difference = tick()-LastTick
        TimeSinceLastDamage = TimeSinceLastDamage+Difference
        if TimeSinceLastDamage > 10 and Humanoid.Health > 50 then
                RedVignette.ImageTransparency = RedVignette.ImageTransparency+0.01
                if RedVignette.ImageTransparency > 1 then RedVignette.ImageTransparency = 1 end
        end
        LastTick = tick()
end)
 
--Definitely should make a kill-cam sometime.
 
ReticleFrame = New'Frame'{Parent = MainFrame, Size = U2(0, 100, 0, 100), Position = U2(0.5, -50, 0.5, -40), BackgroundTransparency = 1}
for A = 1, 36 do
        local ReticleCircle = New'Frame'{Parent = ReticleFrame, Size = U2(0, 10, 0, 2), Position = U2(0.5, math.sin(math.rad(A*10))*44-5, 0.5, math.cos(math.rad(A*10))*44-1), Rotation = -A*10}
end
for A = -2, 2 do
        local ReticleRanging = New'Frame'{Parent = ReticleFrame, Size = U2(0, 40, 0, 2), Position = U2(0.5, -20, 0.5, -1+A*15)}
end
for A = -1, 1, 2 do
        local ReticleRangeSides = New'Frame'{Parent = ReticleFrame, Size = U2(0, 10, 0, 2), Position = U2(0.5, -5+A*40, 0.5, -1)}
        local ReticleRangeTops = New'Frame'{Parent = ReticleFrame, Size = U2(0, 2, 0, 10), Position = U2(0.5, -1, 0.5, -5+A*40)}
end
local Frames = ReticleFrame:GetChildren()
for A = 1, 3 do
        for _, F in pairs(Frames) do
                local SX, SY = F.Size.X.Offset+2*A, F.Size.Y.Offset+2*A
                local PX, PY = F.Position.X.Offset-A, F.Position.Y.Offset-A
                local Clone = New'Frame'{Parent = ReticleFrame, Size = U2(F.Size.X.Scale, SX, F.Size.Y.Scale, SY), Position = U2(F.Position.X.Scale, PX, F.Position.Y.Scale, PY), Rotation = F.Rotation, BackgroundTransparency = 0.8+A*0.05}
        end
end
 
Mouse.Move:wait()
repeat
        MainFrame.BackgroundTransparency = MainFrame.BackgroundTransparency+0.01
        wait(0.01)
until MainFrame.BackgroundTransparency >= 1
 
--For now, unless we want a menu thing:
--MainGui:Destroy()
 