CN, CA, V3, BN, C3 = CFrame.new, CFrame.Angles, Vector3.new, BrickColor.new, Color3.new
--[[
        Beautiful gumdrop candy palace:
                1) Overuse for loops
                2) Arches, domes, towers, fountains, etc.. (epic architecture)
                3) Color scheme must be awesome
                
                Setting:
                        Inside a waterfall
]]
 
ColorScheme = {
        "Dark stone grey",
        "Light stone grey",
        "Black",
        "Brick yellow",
        "Nougat"
}
WaterColor = "Dove blue"
Offset = CN(300, 900, 300)
 
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
function UnicornStatue(Parent, CFrame)
        local AlternatingColors = {"Black", "Medium stone grey", "Dark stone grey", "Light stone grey"}
        local Unicorn = Instance.new("Model", Parent)
        Unicorn.Name = "Unicorn Statue"
        local Base1 = Basepart("Part", Unicorn, V3(50, 1, 50), CFrame, "Black", "Slate")
        Cylinder(Base1)
        local Base1A = Curve(Unicorn, CFrame*CN(0, -0.2, 0), 24, 360, 28, 2, 2, "Light stone grey", "Slate")
        local Base1A = Curve(Unicorn, CFrame*CN(0, -0.2, 0), 24.5, 360, 28, 1, 2.2, "Black", "Slate")
        
        local Base2 = Basepart("Part", Unicorn, V3(20, 3, 20), CFrame*CN(0, 2, 0), "Dark stone grey", "Marble")
        Cylinder(Base2)
        
        local Base2A = Basepart("Part", Unicorn, V3(24, 1, 24), CFrame*CN(0, 0.25, 0), "Dark stone grey", "Slate")
        Cylinder(Base2A)
        local Base2B = Basepart("Part", Unicorn, V3(23, 1, 23), CFrame*CN(0, 0.3, 0), "Light stone grey", "Marble")
        Cylinder(Base2B)
        local Base2C = Basepart("Part", Unicorn, V3(22, 1, 22), CFrame*CN(0, 0.35, 0), "Black", "Marble")
        Cylinder(Base2C)
        
        local Base2D = Basepart("Part", Unicorn, V3(19, 1, 19), CFrame*CN(0, 3.1, 0), "Black", "Marble")
        Cylinder(Base2D)
        local Base2E = Basepart("Part", Unicorn, V3(18, 1, 18), CFrame*CN(0, 3.2, 0), "Dark stone grey", "Slate")
        Cylinder(Base2E)
        
        for A = 1, 14 do
                local BaseDecor1 = Basepart("Part", Unicorn, V3(3, 1, 10), CFrame*CA(0, math.rad(A*360/14), 0)*CN(0, 0.1, 17.5), "Light stone grey", "Slate")
                local BaseDecor1A = Basepart("Part", Unicorn, V3(2, 1, 9), BaseDecor1.CFrame*CN(0, 0.1, 0), AlternatingColors[A%2+1], "Marble")
                
                local BaseDecor2 = Basepart("Part", Unicorn, V3(2, 1, 10), CFrame*CA(0, math.rad((A+0.5)*360/14), 0)*CN(0, 0.1, 20), "Light stone grey", "Slate")
                local BaseDecor2A = Basepart("Part", Unicorn, V3(1, 1, 9), BaseDecor2.CFrame*CN(0, 0.1, 0), "Dark stone grey", "Marble")
        end
 
        PillarThings = {}
        for A = 1, 10 do
                local Pillar1 = Basepart("Part", Unicorn, V3(7, 10, 7), CFrame*CA(0, math.rad(A*360/10), 0)*CN(0, 4.5, 40), "Black", "Slate")
                Cylinder(Pillar1)
                Current = Pillar1
                for B = 1, 5 do
                        local Pillar1A = Basepart("Part", Unicorn, V3(7-B*1, 10, 7-B*1), Current.CFrame*CN(0, 5, 0)*CA(math.rad(-18), 0, 0)*CN(0, 5, 0), "Black", "Slate")
                        Cylinder(Pillar1A)
                        local Pillar1B = Basepart("Part", Unicorn, V3(7-B*1, 7-B*1, 7-B*1), Current.CFrame*CN(0, 5, 0), "Black", "Slate")
                        Mesh(Pillar1B, "Sphere")
                        Current = Pillar1A
                end
                local Pillar2 = Basepart("Part", Unicorn, V3(7, 50, 7), Pillar1.CFrame*CN(0, 30, 0), "Black", "Slate")
                Cylinder(Pillar2)
                for B = 0, 7 do
                        local Pillar2A = Basepart("Part", Unicorn, V3(8+B*0.25, 3, 8+B*0.25), Pillar2.CFrame*CN(0, 23.5+B*0.25, 0), AlternatingColors[B%2+1], "Slate")
                        Cylinder(Pillar2A)
                        local Pillar1C = Basepart("Part", Unicorn, V3(8+B*0.25, 3, 8+B*0.25), Pillar1.CFrame*CN(0, -3.5-B*0.25, 0), AlternatingColors[B%2+1], "Slate")
                        Cylinder(Pillar1C)
                end
        end
        
        local Top1 = Curve(Unicorn, CFrame*CN(0, 60, 0), 34, 360, 28, 12, 3, "Black", "Slate")
        local Top1A = Curve(Unicorn, CFrame*CN(0, 60, 0), 35, 360, 28, 10, 3.2, "Medium stone grey", "Slate")
        local Top2 = Basepart("Part", Unicorn, V3(70, 2.8, 70), CFrame*CN(0, 60, 0), "Medium stone grey", "Slate")
        Cylinder(Top2)
        
        local PillarsTop = Basepart("Part", Unicorn, V3(10, 2, 10), CFrame*CN(0, 35, 0), "Black", "Slate")
        Cylinder(PillarsTop)
        local PillarsTopA = Basepart("Part", Unicorn, V3(9, 2.2, 9), PillarsTop.CFrame, "Medium stone grey", "Slate")
        Cylinder(PillarsTopA)
        
        local Thing = ConnectPoints(Unicorn, Top2.Position, PillarsTop.Position, 10.5, 10.5, "Medium stone grey", "Slate")
        Cylinder(Thing)
        
        local Floor = Basepart("Part", Map, V3(100, 1, 100), CFrame*CN(0, -0.95, 0), "Dark stone grey", "Slate")
        Cylinder(Floor)
        
        for A = 0, 5 do
                local Inside = Basepart("Part", Map, V3(59-A, 1, 59-A), CFrame*CN(0, -0.8+A*0.15, 0), AlternatingColors[A%2+3], "Slate")
                Cylinder(Inside)
        end
        local Outside = Curve(Unicorn, CFrame*CN(0, -0.9, 0), 34, 360, 28, 12, 1, "Black", "Slate")
        local Outside2 = Curve(Unicorn, CFrame*CN(0, -0.8, 0), 35, 360, 28, 10, 1, "Medium stone grey", "Slate")
        
        local OutsideWall = Curve(Unicorn, CFrame*CN(0, 40, 0), 40, 360, 28, 1, 40, "Black", "Slate")
        local OutsideWallA = Curve(Unicorn, CFrame*CN(0, 20, 0), 39, 360, 28, 3, 3, "Black", "Slate")
        
        return Unicorn
end
 
for _, Obj in pairs(Workspace:GetChildren()) do
        if Obj.Name == "Beautiful Gumdrop Candy Palace" then
                Obj:Destroy()
        end
end
 
Map = Instance.new("Model", Workspace)
Map.Name = "Beautiful Gumdrop Candy Palace"
 
--Base = Basepart("Part", Map, V3(300, 1, 300), Offset, "Fire yellow", "SmoothPlastic")
for A = 1, 4 do
        local BaseBottom = Basepart("CornerWedgePart", Map, V3(150, 300, 150), Offset*CA(0, math.rad(90*A), 0)*CN(-75, -150.5, -75)*CA(math.rad(180), 0, 0), "Reddish brown", "Slate")
end
Base = Basepart("Part", Map, V3(300, 1, 300), Offset, "Grime", "Grass")
UnicornStatue(Map, Offset*CN(0, 1, 0))
Tree(Map, Offset*CN(0, 5, 0), 2, 7, 5, 2, "Brown")
 
Player = Game:GetService("Players"):WaitForChild("ask4kingbily")
Player.Chatted:connect(function(Message)
        if Message == "up" then
                Player.Character:MoveTo(Offset.p)
        end
end)