CN, CA, V3, BN, C3 = CFrame.new, CFrame.Angles, Vector3.new, BrickColor.new, Color3.new
--[[
        Beautiful gumdrop candy palace:
                1) Overuse for loops
                2) Arches, domes, towers, fountains, etc.. (epic architecture)
                3) Color scheme must be awesome
                
                Setting:
                        Inside a waterfall
]]
 
Offset = CN(0, 1.5, 0)
 
function Basepart(Type, Parent, Size, CFrame, BrickColor, Material, Transparency)
        local Part = Instance.new(Type, Parent)
        pcall(function() Part.FormFactor = 3 end)
        Part.Size = Size
        Part.Anchored = true
        Part.CFrame = CFrame
        Part.BrickColor = BN(BrickColor or ColorScheme[1])
        Part.Material = Material or "SmoothPlastic"
        Part.Transparency = Transparency or 0
        Part.TopSurface = 0
        Part.BottomSurface = 0
        Part.Locked = true
        return Part
end
function Cylinder(Parent, Scale)
        local Cylinder = Instance.new("CylinderMesh", Parent)
        Cylinder.Scale = Scale or V3(1, 1, 1)
        return Cylinder
end
function Mesh(Parent, MeshType, Scale, MeshId, TextureId)
        local Mesh = Instance.new("SpecialMesh", Parent)
        Mesh.MeshType = MeshType or "Sphere"
        Mesh.Scale = Scale or V3(1, 1, 1)
        Mesh.MeshId = MeshId or ""
        Mesh.TextureId = TextureId or ""
end
function Curve(Parent, Center, Radius, Angle, Segments, Width, Height, BrickColor, Material, Transparency)
        local Circumference, Interval = math.pi*(Radius*2+Width*2), Angle/Segments
        local Length = Circumference/(360/Angle)/Segments
        local Circle = Instance.new("Model", Parent)
        for S = -Segments/2, Segments/2 do
                if Angle == 360 and S == Segments/2 then return end
                local CirclePart = Basepart("Part", Circle, V3(Length, Height, Width), Center*CA(0, math.rad(Interval*S), 0)*CN(0, 0, Radius+Width/2), BrickColor, Material, Transparency)
        end
        return Circle
end
function ConnectPoints(Parent, Point1, Point2, Width, Height, BrickColor, Material, Transparency)
        local Distance = (Point2-Point1).magnitude
        local PointConnection = Basepart("Part", Parent, V3(Width, Distance, Height), CN(Point1, Point2)*CA(math.rad(90), 0, 0)*CN(0, -Distance/2, 0), BrickColor, Material, Transparency)
        return PointConnection
end
function Tree(Parent, CFrame, Width, Height, Limit, Split, WoodColor, Colors)
        local Tree = Instance.new("Model", Parent)
        Tree.Name = "Tree"
        local Trunk = Basepart("Part", Tree, V3(Width, Height, Width), CFrame, WoodColor, "Wood")
        --Cylinder(Trunk)
        local Old = Trunk
        local T1 = {}
        local T2 = {}
        Current = 1
        function Branch(Table)
                wait()
                if Current <= Limit then
                        T1 = Table
                        T2 = {}
                        for B = 1, #T1 do
                                Old = T1[B]
                                if Current == Limit then
                                        --Some leafy things
                                else
                                        for S = 1, Split do
                                                local newSize = V3(T1[B].Size.X*0.75, T1[B].Size.Y*0.9, T1[B].Size.Z*0.75)
                                                local newBranch = Basepart("Part", Tree, newSize, T1[B].CFrame*CN(0, T1[B].Size.Y/2-newSize.X/2, 0)*CA(math.rad(math.random(-45, 45)), math.rad(math.random(-45, 45)), math.rad(math.random(-45, 45)))*CN(0, newSize.Y/2, 0), WoodColor, "Wood")
                                                --Cylinder(newBranch)
                                                table.insert(T2, newBranch)
                                        end
                                end
                        end
                        Current = Current+1
                        Branch(T2)
                        wait()
                end
        end
        Branch({Trunk})
end
function Texture(PT, FC, TX, SU, SV, TR)
        local Thing = Instance.new("Texture", PT)
        Thing.Face = FC
        Thing.Texture = TX
        Thing.StudsPerTileU = SU
        Thing.StudsPerTileV = SV
        Thing.Transparency = TR
        return Thing
end
function TextureFaces(PT, FCS, TX, SU, SV, TR)
        for _, Face in pairs(FCS) do
                Texture(PT, Face, TX, SU, SV, TR)
        end
end
 
RemoveThings = {}
for _, Obj in pairs(Workspace:GetChildren()) do
        if Obj.Name == "Beautiful Gumdrop Candy Palace" then
                table.insert(RemoveThings, Obj)
        end
end
 
Map = Instance.new("Model", Workspace)
Map.Name = "Beautiful Gumdrop Candy Palace"
 
--Base = Basepart("Part", Map, V3(600, 1, 600), Offset, "Bright green", "Grass")
 
for B = 1, 3 do
        local Base = Basepart("Part", Map, V3(215.925, 1, 374), Offset*CA(0, math.rad(B*60), 0)*CN(0, math.sin(B*0.05), 0), "Bright green", "Grass")
        local Base2 = Basepart("Part", Map, V3(247.1, 20, 428), Base.CFrame*CN(0, -10.5, 0), "Dark green", "Grass")
end
for B = 1, 6 do
        local BaseOutside = Basepart("Part", Map, V3(408.75, 20, 100), Offset*CA(0, math.rad(B*60), 0)*CN(0, -10.5+math.sin(B*0.05), 344), "Reddish brown", "Slate")
        --local Bridge = Basepart("Part", Map, V3(408.75, 20, 100), Offset*CA(0, math.rad(B*60), 0)*CN(0, -10.5+math.sin(B*0.05), 304), "Reddish brown", "Slate")
end
 
WallColor = "Light stone grey"
WallColor2 = "Dark stone grey"
WallFloorColor = "Dark stone grey"
WallFloorMaterial = "Slate"
 
for W = 1, 6 do
        local WallOffset = Offset*CA(0, math.rad(W*60), 0)*CN(0, 20.5, 200)
        if W ~= 2 and W ~= 4 and W ~= 6 then
                local WallTop = Basepart("Part", Map, V3(247.1, 1, 26), WallOffset*CN(0, 19.5, 0), WallColor, "Slate")
                local WallFloor = Basepart("Part", Map, V3(247.1, 1, 26), WallTop.CFrame*CN(0, -39.9, 0), WallFloorColor, WallFloorMaterial)
                local WallOutside = Basepart("Part", Map, V3(247.1, 44, 1), WallOffset*CN(0, 2, 13.5), WallColor, "Slate")
                local WallInsideRight = Basepart("Part", Map, V3((215.925-7)/2, 44, 1), WallOffset*CN(-107.9625+52.23125, 2, -13.5), WallColor, "Slate")
                local WallInsideLeft = Basepart("Part", Map, V3((215.925-7)/2, 44, 1), WallOffset*CN(107.9625-52.23125, 2, -13.5), WallColor, "Slate")
                local WallInsideMiddle = Basepart("Part", Map, V3(7, 34, 1), WallOffset*CN(0, 7, -13.5), WallColor, "Slate")
                
                --Arches
                for A = -2, 1 do
                        local InsideCeilingArch = Curve(Map, WallOffset*CN(A*50+25, -12.5, 0)*CA(math.rad(-90), 0, math.rad(-90)), 23.5, 60, 10, 2, 7.1, WallColor2, "Slate")
                        local InsideCeilingArchTop = Basepart("Part", Map, V3(7, 7, 26), WallOffset*CN(A*50+25, 15.5, 0), WallColor, "Slate")
                        local InsideCeilingArchTop2 = Basepart("WedgePart", Map, V3(7, 4, 12), InsideCeilingArchTop.CFrame*CN(0, -5.5, -7)*CA(math.rad(180), 0, 0), WallColor, "Slate")
                        local InsideCeilingArchTop3 = Basepart("WedgePart", Map, V3(7, 4, 12), InsideCeilingArchTop.CFrame*CN(0, -5.5, 7)*CA(math.rad(180), math.rad(180), 0), WallColor, "Slate")
                        local InsideCeilingArch2 = Basepart("Part", Map, V3(7.1, 30, 2), InsideCeilingArchTop.CFrame*CN(0, -21.5, 12), WallColor2, "Slate")
                        --if A ~= 0 then
                                local InsideCeilingArch2B = Basepart("Part", Map, V3(7.1, 30, 2), InsideCeilingArchTop.CFrame*CN(0, -21.5, -12), WallColor2, "Slate")
                        --[[else
                                local InsideCeilingArch2B = Basepart("WedgePart", Map, V3(7.1, 2, 19), InsideCeilingArchTop.CFrame*CN(0, -16, -12)*CA(math.rad(90), math.rad(180), 0), WallColor2, "Slate")
                        end]]
                end
        else
                local WallRightTop = Basepart("Part", Map, V3(73.55, 1, 26), WallOffset*CN(123.55-36.775, 19.5, 0), WallColor, "Slate")
                local WallRightFloor = Basepart("Part", Map, V3(73.55, 1, 26), WallRightTop.CFrame*CN(0, -39.9, 0), WallFloorColor, WallFloorMaterial)
                local WallRightTowerFloor = Basepart("Part", Map, V3(27, 1, 27), WallOffset*CN(50-3.6651914291881/2, -20.4, 0), WallFloorColor, WallFloorMaterial)
                Cylinder(WallRightTowerFloor)
                local WallRightOutside = Basepart("Part", Map, V3(73.55, 44, 1), WallRightTop.CFrame*CN(0, -17.5, 13.5), WallColor, "Slate")
                local WallRightInsideRight = Basepart("Part", Map, V3((57.9625-10)/2, 44, 1), WallRightTop.CFrame*CN(-7.79375-28.98125+(57.9625-10)/4, -17.5, -13.5), WallColor, "Slate")
                local WallRightInsideLeft = Basepart("Part", Map, V3((57.9625-10)/2, 44, 1), WallRightTop.CFrame*CN(-7.79375+28.98125-(57.9625-10)/4, -17.5, -13.5), WallColor, "Slate")
                local WallRightInsideMiddle = Basepart("Part", Map, V3(10, 34, 1), WallRightTop.CFrame*CN(-7.79375, -12.5, -13.5), WallColor, "Slate")
                local LowerRightTower = Curve(Map, WallOffset*CN(50-3.6651914291881/2, 13, 0)*CA(0, math.rad(-90), 0), 13, 180, 12, 1, 66, WallColor, "Slate")
                local UpperRightTower = Curve(Map, WallOffset*CN(50-3.6651914291881/2, 33, 0)*CA(0, math.rad(90), 0), 13, 150, 10, 1, 26, WallColor, "Slate")
                
                local WallLeftTop = Basepart("Part", Map, V3(73.55, 1, 26), WallOffset*CN(-123.55+36.775, 19.5, 0), WallColor, "Slate")
                local WallLeftFloor = Basepart("Part", Map, V3(73.55, 1, 26), WallLeftTop.CFrame*CN(0, -39.9, 0), WallFloorColor, WallFloorMaterial)
                local WallLeftTowerFloor = Basepart("Part", Map, V3(27, 1, 27), WallOffset*CN(-50+3.6651914291881/2, -20.4, 0), WallFloorColor, WallFloorMaterial)
                Cylinder(WallLeftTowerFloor)
                local WallLeftOutside = Basepart("Part", Map, V3(73.55, 44, 1), WallLeftTop.CFrame*CN(0, -17.5, 13.5), WallColor, "Slate")
                --local WallLeftInside = Basepart("Part", Map, V3(57.9625, 44, 1), WallLeftTop.CFrame*CN(7.79375, -17.5, -13.5), "Light stone grey", "Slate")
                local WallLeftInsideRight = Basepart("Part", Map, V3((57.9625-10)/2, 44, 1), WallLeftTop.CFrame*CN(7.79375-28.98125+(57.9625-10)/4, -17.5, -13.5), WallColor, "Slate")
                local WallLeftInsideLeft = Basepart("Part", Map, V3((57.9625-10)/2, 44, 1), WallLeftTop.CFrame*CN(7.79375+28.98125-(57.9625-10)/4, -17.5, -13.5), WallColor, "Slate")
                local WallLeftInsideMiddle = Basepart("Part", Map, V3(10, 34, 1), WallLeftTop.CFrame*CN(7.79375, -12.5, -13.5), WallColor, "Slate")
                local LowerLeftTower = Curve(Map, WallOffset*CN(-50+3.6651914291881/2, 13, 0)*CA(0, math.rad(90), 0), 13, 180, 12, 1, 66, WallColor, "Slate")
                local UpperLeftTower = Curve(Map, WallOffset*CN(-50+3.6651914291881/2, 33, 0)*CA(0, math.rad(-90), 0), 13, 150, 10, 1, 26, WallColor, "Slate")
                
                --Some arches
                for A = 0, 1 do
                        local InsideCeilingArch = Curve(Map, WallRightFloor.CFrame*CN(-25+A*35, 8, 0)*CA(math.rad(-90), 0, math.rad(-90)), 23.5, 60, 10, 2, 7.1, WallColor2, "Slate")
                        local InsideCeilingArchTop = Basepart("Part", Map, V3(7, 7, 26), WallRightFloor.CFrame*CN(-25+A*35, 36, 0), WallColor, "Slate")
                        local InsideCeilingArchTop2 = Basepart("WedgePart", Map, V3(7, 4, 12), InsideCeilingArchTop.CFrame*CN(0, -5.5, -7)*CA(math.rad(180), 0, 0), WallColor, "Slate")
                        local InsideCeilingArchTop3 = Basepart("WedgePart", Map, V3(7, 4, 12), InsideCeilingArchTop.CFrame*CN(0, -5.5, 7)*CA(math.rad(180), math.rad(180), 0), WallColor, "Slate")
                        local InsideCeilingArch2 = Basepart("Part", Map, V3(7.1, 30, 2), InsideCeilingArchTop.CFrame*CN(0, -21.5, 12), WallColor2, "Slate")
                        local InsideCeilingArch2B = Basepart("Part", Map, V3(7.1, 30, 2), InsideCeilingArchTop.CFrame*CN(0, -21.5, -12), WallColor2, "Slate")
                        
                        local InsideCeilingArch = Curve(Map, WallLeftFloor.CFrame*CN(25+A*-35, 8, 0)*CA(math.rad(-90), 0, math.rad(-90)), 23.5, 60, 10, 2, 7.1, WallColor2, "Slate")
                        local InsideCeilingArchTop = Basepart("Part", Map, V3(7, 7, 26), WallLeftFloor.CFrame*CN(25+A*-35, 36, 0), WallColor, "Slate")
                        local InsideCeilingArchTop2 = Basepart("WedgePart", Map, V3(7, 4, 12), InsideCeilingArchTop.CFrame*CN(0, -5.5, -7)*CA(math.rad(180), 0, 0), WallColor, "Slate")
                        local InsideCeilingArchTop3 = Basepart("WedgePart", Map, V3(7, 4, 12), InsideCeilingArchTop.CFrame*CN(0, -5.5, 7)*CA(math.rad(180), math.rad(180), 0), WallColor, "Slate")
                        local InsideCeilingArch2 = Basepart("Part", Map, V3(7.1, 30, 2), InsideCeilingArchTop.CFrame*CN(0, -21.5, 12), WallColor2, "Slate")
                        local InsideCeilingArch2B = Basepart("Part", Map, V3(7.1, 30, 2), InsideCeilingArchTop.CFrame*CN(0, -21.5, -12), WallColor2, "Slate")
                end
                
                for A = 1, #UpperLeftTower:GetChildren() do
                        local B, C = UpperRightTower:GetChildren()[A], UpperLeftTower:GetChildren()[A]
                        if A == 5 or A == 6 or A == 7 then
                                local BC, CC = B.CFrame, C.CFrame
                                B.Size = B.Size+V3(0, -10, 0)
                                C.Size = C.Size+V3(0, -10, 0)
                                B.CFrame = BC*CN(0, 5, 0)
                                C.CFrame = CC*CN(0, 5, 0)
                        end
                end
                for A = 1, #LowerLeftTower:GetChildren() do
                        local B, C = LowerRightTower:GetChildren()[A], LowerLeftTower:GetChildren()[A]
                        if A == 6 or A == 7 or A == 8 then
                                local BC, CC = B.CFrame, C.CFrame
                                B.Size = B.Size+V3(0, -20, 0)
                                C.Size = C.Size+V3(0, -20, 0)
                                B.CFrame = BC*CN(0, -10, 0)
                                C.CFrame = CC*CN(0, -10, 0)
                                local NB = Basepart("Part", Map, V3(B.Size.X, 10, B.Size.Z), BC*CN(0, 28, 0), WallColor, "Slate")
                                local NC = Basepart("Part", Map, V3(C.Size.X, 10, C.Size.Z), CC*CN(0, 28, 0), WallColor, "Slate")
                        end
                end
                
                for S = 0, 39 do
                        local StairRight = Basepart("Part", Map, V3(3.6651914291881, 1, 5), WallOffset*CN(50-3.6651914291881/2, 19.5, 0)*CA(0, math.rad(S*15), 0)*CN(0, -S*1, -10.5), "Reddish brown", "Wood")
                        --local StairRight2 = Basepart("Part", Map, V3(3.6651914291881, 39-S+1, 1), StairRight.CFrame*CN(0, -(39-S+1)/2+0.5, 3), "Reddish brown", "Wood")
                        
                        local StairLeft = Basepart("Part", Map, V3(3.6651914291881, 1, 5), WallOffset*CN(-50+3.6651914291881/2, 19.5, 0)*CA(0, math.rad(S*-15), 0)*CN(0, -S*1, -10.5), "Reddish brown", "Wood")
                        --local StairLeft2 = Basepart("Part", Map, V3(3.6651914291881, 39-S+1, 1), StairLeft.CFrame*CN(0, -(39-S+1)/2+0.5, 3), "Reddish brown", "Wood")
                        
                        if S <= 15 or (S >= 19 and S <= 23) then
                                local StairRight2 = Basepart("Part", Map, V3(2.11, 39-S+1, 0.5), StairRight.CFrame*CN(0, -(39-S+1)/2+0.5, 2.75), "Reddish brown", "Wood")
                                local StairLeft2 = Basepart("Part", Map, V3(2.11, 39-S+1, 0.5), StairLeft.CFrame*CN(0, -(39-S+1)/2+0.5, 2.75), "Reddish brown", "Wood")
                                
                                local StairRight3 = Basepart("Part", Map, V3(3.49, 39-S+1.25, 0.5), StairRight.CFrame*CN(0, -(39-S+1)/2+0.5, -2.5), "Reddish brown", "Wood")
                                local StairLeft3 = Basepart("Part", Map, V3(3.49, 39-S+1.25, 0.5), StairLeft.CFrame*CN(0, -(39-S+1)/2+0.5, -2.5), "Reddish brown", "Wood")
                        elseif S > 15 and S < 19 then
                                local StairRight2 = Basepart("Part", Map, V3(2.11, 32-S+1, 0.5), StairRight.CFrame*CN(0, -(32-S+1)/2+0.5, 2.75), "Reddish brown", "Wood")
                                local StairLeft2 = Basepart("Part", Map, V3(2.11, 32-S+1, 0.5), StairLeft.CFrame*CN(0, -(32-S+1)/2+0.5, 2.75), "Reddish brown", "Wood")
                        end
                end
                for S = 0, 8 do
                        if S < 6 then
                                local StairRight = Basepart("Part", Map, V3(3.6651914291881, 1, 5), WallOffset*CN(50-3.6651914291881/2, 19.5, 0)*CA(0, math.rad(S*-15), 0)*CN(0, S*1, 10.5), "Light stone grey", "Slate")
                                local StairLeft = Basepart("Part", Map, V3(3.6651914291881, 1, 5), WallOffset*CN(-50+3.6651914291881/2, 19.5, 0)*CA(0, math.rad(S*15), 0)*CN(0, S*1, 10.5), "Light stone grey", "Slate")
                        else
                                local StairRight = Basepart("Part", Map, V3(3.6651914291881, 1, 5), WallOffset*CN(50-3.6651914291881/2, 19.5, 0)*CA(0, math.rad(S*-15), 0)*CN(0, 6+math.sin(S)*0.01, 10.5), "Light stone grey", "Slate")
                                local StairLeft = Basepart("Part", Map, V3(3.6651914291881, 1, 5), WallOffset*CN(-50+3.6651914291881/2, 19.5, 0)*CA(0, math.rad(S*15), 0)*CN(0, 6+math.sin(S)*0.01, 10.5), "Light stone grey", "Slate")
                        end
                end
                --Top of the towers
                for A = 1, 12 do
                        local WedgeThingRight = Basepart("WedgePart", Map, V3(2, 6, 3), WallOffset*CN(50-3.6651914291881/2, 40, 0)*CA(0, math.rad(A*30), 0)*CN(0, 0, 15.5)*CA(math.rad(180), 0, 0), WallColor, "Slate")
                        local WedgeThingRight2 = Basepart("Part", Map, V3(2, 3, 3), WedgeThingRight.CFrame*CN(0, -4.5, 0), WallColor, "Slate")
                        
                        local WedgeThingLeft = Basepart("WedgePart", Map, V3(2, 6, 3), WallOffset*CN(-50+3.6651914291881/2, 40, 0)*CA(0, math.rad(A*30), 0)*CN(0, 0, 15.5)*CA(math.rad(180), 0, 0), WallColor, "Slate")
                        local WedgeThingLeft2 = Basepart("Part", Map, V3(2, 3, 3), WedgeThingLeft.CFrame*CN(0, -4.5, 0), WallColor, "Slate")
                end
                local TopRightTower1 = Curve(Map, WallOffset*CN(50-3.6651914291881/2, 48, 0), 13, 360, 24, 4, 4, WallColor, "Slate")
                local TopRightTower2 = Basepart("Part", Map, V3(27, 1, 27), WallOffset*CN(50-3.6651914291881/2, 49.5, 0), WallColor, "Slate")
                Cylinder(TopRightTower2)
                local TopRightTower3 = Basepart("Part", Map, V3(30, 22, 30), TopRightTower2.CFrame*CN(0, 11.5, 0), "Bright orange", "Slate")
                Mesh(TopRightTower3, "FileMesh", V3(20, 30, 20), "rbxassetid://1033714")
                
                local TopLeftTower1 = Curve(Map, WallOffset*CN(-50+3.6651914291881/2, 48, 0), 13, 360, 24, 4, 4, WallColor, "Slate")
                local TopLeftTower2 = Basepart("Part", Map, V3(27, 1, 27), WallOffset*CN(-50+3.6651914291881/2, 49.5, 0), WallColor, "Slate")
                Cylinder(TopLeftTower2)
                local TopLeftTower3 = Basepart("Part", Map, V3(30, 22, 30), TopLeftTower2.CFrame*CN(0, 11.5, 0), "Bright blue", "Slate")
                Mesh(TopLeftTower3, "FileMesh", V3(20, 30, 20), "rbxassetid://1033714")
                
                --Gate!
                local GateTop = Basepart("Part", Map, V3(70.25, 2, 11), WallOffset*CN(0, 24.9, 0), WallColor, "Slate")
                local GateTopSide = Basepart("Part", Map, V3(71.5, 6, 1), GateTop.CFrame*CN(0, 2, -6), WallColor, "Slate")
                local GateTopSide2 = Basepart("Part", Map, V3(71.5, 6, 1), GateTop.CFrame*CN(0, 2, 6), WallColor, "Slate")
        end
end
 
for _, Obj in pairs(RemoveThings) do
        Obj:Destroy()
end
 
Player = Game:GetService("Players"):WaitForChild("ask4kingbily")
Player.Chatted:connect(function(Message)
        if Message == "up" then
                Player.Character:MoveTo(Offset.p)
        end
end)