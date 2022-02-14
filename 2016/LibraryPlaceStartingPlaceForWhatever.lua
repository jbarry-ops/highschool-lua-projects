--Starting area for one-player adventure game
pi = math.pi
CN, V3, U2, BN, C3 = CFrame.new, Vector3.new, UDim2.new, BrickColor.new, Color3.new
--Functions and cool stuffs
function CA(X, Y, Z)
        return CFrame.Angles(math.rad(X), math.rad(Y or 0), math.rad(Z or 0))
end
SwordMesh = "rbxasset://fonts/sword.mesh"
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
function Curve(Parent, Center, Radius, Angle, Segments, Width, Height, BrickColor, Material, Transparency, AntiArtifacting, AntiCollide)
        local AntiArtifacting = AntiArtifacting or 0
        local Circumference, Interval = math.pi*(Radius*2+Width*2), Angle/Segments
        local Length = Circumference/(360/Angle)/Segments
        local Circle = New'Model'{Parent = Parent, Name = "Curve"}
        for S = -Segments/2, Segments/2 do
                if Angle == 360 and S == Segments/2 then return end
                local CirclePart = Part(Circle, V3(Length, Height+AntiArtifacting*math.abs(math.sin(math.rad(S))), Width), Center*CA(0, Interval*S, 0)*CN(0, 0, Radius+Width/2), BrickColor, Material, Transparency) CirclePart.CanCollide = not AntiCollide
        end
        return Circle
end

function ConnectPoints(Parent, Point1, Point2, Width, Height, BrickColor, Material, Transparency)
	if pcall(function() return Point1.p end) then Point1, Point2 = Point1.p, Point2.p end
	local Length = (Point2-Point1).magnitude
	return Part(Parent, V3(Width, Length, Height), CN(Point1, Point2)*CA(-90, 0, 0)*CN(0, Length/2, 0), BrickColor, Material, Transparency)
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
function Crate(Parent, Size, CFrame, BrickColor, Material, TextureSides, TextureFAB)
        local Crate = Part(Parent, Size, CFrame, BrickColor, Material)
        if TextureSides then
                New'Decal'{Parent = Crate, Face = "Right", TextureId = TextureSides}
                if TextureFAB then
                        New'Decal'{Parent = Crate, Face = "Front", TextureId = TextureFAB}
                        New'Decal'{Parent = Crate, Face = "Back", TextureId = TextureFAB}
                else
                        New'Decal'{Parent = Crate, Face = "Front", TextureId = TextureSides}
                        New'Decal'{Parent = Crate, Face = "Back", TextureId = TextureSides}
                end
        end
end
function CrateTriangle(Parent, Size, CFrame, BrickColor, Material, TextureSides, TextureFAB)
        local Triangle = New'Model'{Parent = Parent, Name = "Crate Triangle"}
        local Av = (Size.X+Size.Z)/2
        Crate(Triangle, Size, CFrame*CN(Av/1.5, 0, 0)*CA(0, math.random(-15, 15), 0), BrickColor, Material, TextureSides, TextureFAB)
        Crate(Triangle, Size, CFrame*CN(-Av/1.5, 0, 0)*CA(0, math.random(-15, 15), 0), BrickColor, Material, TextureSides, TextureFAB)
        Crate(Triangle, Size, CFrame*CN(0, Size.Y, 0)*CA(0, 90+math.random(-15, 15), 0), BrickColor, Material, TextureSides, TextureFAB)
end
function Pillar(Parent, CFrame, Width, Height, Color, Material)
        local Material, Color = Material or "Slate", Color or "Medium stone grey"
        local Pillar = New'Model'{Parent = Parent, Name = "Pillar"}
        local PillarMain = Part(Pillar, V3(Width, Height, Width), CFrame*CN(0, Height/2, 0), Color, Material)
        Cylinder(PillarMain)
        local PillarBottom = Part(Pillar, V3(Width+2, 3, Width+2), PillarMain.CFrame*CN(0, -Height/2, 0), Color, Material)
        Cylinder(PillarBottom)
        local PillarTop = Part(Pillar, V3(Width+2, 3, Width+2), PillarMain.CFrame*CN(0, Height/2+1.5, 0), Color, Material)
        Cylinder(PillarTop)
        return Pillar
end
function Ruins(Parent, CFrame)
        local Ruins = New'Model'{Parent = Parent, Name = "Sand Temple Ruins"}
        RuinsFloor = Part(Ruins, V3(80, 4, 140), CFrame*CN(0, 2, 0), "Brick yellow", "Slate")
        for F = 1, 7 do
                local RuinsFloor2 = Part(Ruins, V3(80+F*3, 4-F*0.5, 140+F*3), RuinsFloor.CFrame*CN(0, -F*0.25, 0), "Brick yellow", "Slate")
        end
        --[[for F = -2, 2 do
                local FloorDecor = Part(Ruins, V3(25, 1, 25), RuinsFloor.CFrame*CN(0, 2.51-math.abs(F)*0.5, F*25)*CA(0, 45, 0), "Really black", "Marble")
                Cylinder(FloorDecor)
                local FloorDecor2 = Part(Ruins, V3(23, 1, 23), FloorDecor.CFrame*CN(0, 0.1, 0), "Light stone grey", "Slate")
                Cylinder(FloorDecor2)
                local FloorDecor3 = Part(Ruins, V3(21, 1, 21), FloorDecor2.CFrame*CN(0, 0.1, 0), "Dark stone grey", "Slate")
                Cylinder(FloorDecor3)
        end]]
        RuinsCeiling = Part(Ruins, V3(87, 3, 142), RuinsFloor.CFrame*CN(0, 35.5, 0), "Brick yellow", "Slate")
        RuinsCeiling2 = Part(Ruins, V3(85, 4, 140), RuinsCeiling.CFrame, "Brick yellow", "Slate")
        RuinsCeiling3 = Part(Ruins, V3(83, 5, 138), RuinsCeiling.CFrame, "Brick yellow", "Slate")
        RuinsCeiling4 = Part(Ruins, V3(81, 6, 136), RuinsCeiling.CFrame, "Brick yellow", "Slate")
        for A = -1, 1, 2 do
                for B = -2, 2 do
                        Pillar(Ruins, RuinsFloor.CFrame*CN(A*30, 2, B*30)*CA(math.random(-10, 10), 0, math.random(-10, 10)), 5, 30, "Brick yellow")
                end
        end
        return Ruins
end
function Bookshelf(Parent, CFrame, Width, Height, Color, Colors)
        local Color = Color or "Reddish brown"
        local Bookshelf = New'Model'{Parent = Parent, Name = "Bookshelf"}
        local BookshelfBase = Part(Bookshelf, V3(Width*2, 0.5, 3), CFrame*CN(0, 0.25, 0), Color, "Wood")
        local BookshelfLeft = Part(Bookshelf, V3(0.5, Height*3, 3), BookshelfBase.CFrame*CN(Width-0.25, Height*1.5+0.25, 0), Color, "Wood")
        local BookshelfRight = Part(Bookshelf, V3(0.5, Height*3, 3), BookshelfBase.CFrame*CN(-Width+0.25, Height*1.5+0.25, 0), Color, "Wood")
        local BookshelfBack = Part(Bookshelf, V3(Width*2, Height*3+0.5, 0.5), BookshelfBase.CFrame*CN(0, Height*1.5+0, 1.75), Color, "Wood")
        local BookshelfTop = Part(Bookshelf, V3(Width*2-1, 0.5, 3), BookshelfBase.CFrame*CN(0, Height*3, 0), Color, "Wood")
        local BookshelfBottom = Part(Bookshelf, V3(Width*2-1, 2.5, 3), BookshelfBase.CFrame*CN(0, 1.5, 0), Color, "Wood")
        for S = 1, Height-1 do
                local Shelf = Part(Bookshelf, V3(Width*2-1, 0.5, 3), BookshelfBase.CFrame*CN(0, 3*S, 0), Color, "Wood")
                local DoAngle = false
                local HasDone = true
                local Num = 2
                for B = -Width+1, Width-1,.7 do
                        if not DoAngle then
                                Num = Num + 1
                        end
                        if math.random(1,5) ~= 1 or HasDone then
                                local Angle = 0
                                local offset = 0
                                if DoAngle == true then 
                                        Num = 0                
                                        Angle = (math.random(0,1) == 0 and 10 or -10)
                                        offset = .7/2
                                        DoAngle = false
                                end
                                local Book = Part(Bookshelf, V3(0.5, 2.25, 2), Shelf.CFrame*CN((B*1)-offset, 0.25, 0)*CA(0, 0, Angle)*CN(0, 1.125, 0), "Light stone grey", "Ice")
                                local ChosenColor = Colors[math.random(1, #Colors)]
                                local BookSpine = Part(Bookshelf, V3(0.3, 2.35, 0.2), Book.CFrame*CN(0, 0, -1), ChosenColor, "Wood")
                                local BookFront = Part(Bookshelf, V3(0.2, 2.35, 2.2), Book.CFrame*CN(0.25, 0, 0), ChosenColor, "Wood")
                                local BookBack = Part(Bookshelf, V3(0.2, 2.35, 2.2), Book.CFrame*CN(-0.25, 0, 0), ChosenColor, "Wood")
                        else
                                DoAngle = true
                                HasDone = true
                                Num = 0
                        end
                        if Num >= 4 then
                                HasDone = false
                                Num = 0
                        end
                end
                wait()
        end
        return Bookshelf
end
function Table(Parent, CFrame, Width, Length, Color, Color2)
        local Table = New'Model'{Parent = Parent, Name = "Table"}
        local TableTop = Part(Table, V3(Width, 0.5, Length), CFrame*CN(0, 4, 0), Color, "Wood") TableTop.Name = "Top"
        local TableTop2 = Part(Table, V3(Width+0.5, 0.5, Length+0.5), TableTop.CFrame*CN(0, 0.5, 0), Color, "Wood")
        local TableTop3 = Part(Table, V3(Width, 0.5, Length), TableTop2.CFrame*CN(0, 0.1, 0), Color2, "Marble")
        for A = -1, 1, 2 do
                local Right = Part(Table, V3(1, 4, 1), TableTop.CFrame*CN(Width/2-0.5, -2, (Length/2-0.5)*A), Color, "Wood")
                Cylinder(Right)
                local RightBottom = Part(Table, V3(1.25, 0.5, 1.25), Right.CFrame*CN(0, -1.75, 0), Color, "Wood")
                local RightBottom2 = Part(Table, V3(1.1, 1, 1.1), RightBottom.CFrame*CN(0, 0.75, 0), Color, "Wood")
                local Left = Part(Table, V3(1, 4, 1), TableTop.CFrame*CN(-Width/2+0.5, -2, (Length/2-0.5)*A), Color, "Wood")
                Cylinder(Left)
                local LeftBottom = Part(Table, V3(1.25, 0.5, 1.25), Left.CFrame*CN(0, -1.75, 0), Color, "Wood")
                local LeftBottom2 = Part(Table, V3(1.1, 1, 1.1), LeftBottom.CFrame*CN(0, 0.75, 0), Color, "Wood")
        end
        return Table
end
function Chair(Parent, CFrame, Color, Color2)
        local Chair = New'Model'{Parent = Parent, Name = "Chair"}
        local Seat = Part(Chair, V3(3.5, 0.5, 3.5), CFrame*CN(0, 2.25, 0), Color, "Wood")
        local SeatCushion = Part(Chair, V3(3, 0.5, 3), Seat.CFrame*CN(0, 0.1, 0), Color2, "Wood")
        for A = -1, 1, 2 do
                local FrontSupport = Part(Chair, V3(0.5, 2, 0.5), Seat.CFrame*CN(1.5*A, -1.25, -1.5), Color, "Wood")
                --Cylinder(FrontSupport)
                local BackSupport = Part(Chair, V3(0.5, 2, 0.5), Seat.CFrame*CN(1.5*A, -1.25, 1.5), Color, "Wood")
                --Cylinder(BackSupport)
                for C = 0, 1 do
                        local Connect = Part(Chair, V3(0.5, 0.5, 2.5), BackSupport.CFrame*CN(0, -0.75+C*1, -1.5), Color, "Wood")
                end
                local Connect2 = Part(Chair, V3(2.5, 0.5, 0.5), Seat.CFrame*CN(0, -1, 0.75*A), Color, "Wood")
                local Back = Part(Chair, V3(0.5, 3.5, 0.5), Seat.CFrame*CN(1.5*A, 2, 1.5), Color, "Wood")
                local BackPoint = Wedge(Chair, V3(0.5, 1, 1.75), Seat.CFrame*CN(0.875*A, 4.25, 1.5)*CA(0, -90*A, 0), Color, "Wood")
        end
        for A = 0, 1 do
                local BackTop = Part(Chair, V3(2.5, 1, 0.5), Seat.CFrame*CN(0, 3.25-A*1.75, 1.5), Color, "Wood")
        end
        return Chair
end
function Fountain(Parent, CFrame)
        local Fountain = New'Model'{Parent = Parent, Name = "Fountain"}
        local FirstBase = Curve(Fountain, CFrame*CN(0, 0.5, 0), 0, 360, 20, 30, 1, "Brick yellow", "Wood", 0, 1)
        local FirstOutside = Curve(Fountain, CFrame*CN(0, 3.5, 0), 28, 360, 20, 2, 5, "Brick yellow", "Wood")
        local FirstWater = Part(Fountain, V3(60, 4, 60), CFrame*CN(0, 2.5, 0), "Bright blue", "SmoothPlastic", 0.2) FirstWater.CanCollide = false
        Cylinder(FirstWater)
        local SecondBase = Curve(Fountain, CFrame*CN(0, 3.5, 0), 0, 360, 20, 20, 5, "Brick yellow", "Wood", 0, 1)
        local SecondOutside = Curve(Fountain, CFrame*CN(0, 8.5, 0), 18, 360, 20, 2, 5, "Brick yellow", "Wood")
        local Waterfall = Curve(Fountain, CFrame*CN(0, 7.75, 0), 17.75, 360, 20, 2.5, 6.75, "Bright blue", "SmoothPlastic", 0.2, 1, true)
        local SecondWater = Part(Fountain, V3(40, 3.5, 40), CFrame*CN(0, 7.75, 0), "Bright blue", "SmoothPlastic", 0.2) SecondWater.CanCollide = false
        Cylinder(SecondWater)
        local ThirdBase = Curve(Fountain, CFrame*CN(0, 9.5, 0), 0, 360, 20, 7, 7, "Brick yellow", "Wood", 0, 1)
        local Waterfall2 = Curve(Fountain, CFrame*CN(0, 9.5, 0), 0, 360, 20, 7.25, 7.5, "Bright blue", "SmoothPlastic", 0.2, 1, true)
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

function Chandelier(Parent, CFrame)
	local Chandelier = New'Model'{Parent = Parent, Name = "Chandelier"}
	--Chain meshid for ring: 3270017 or 16659502
	local Fixture = Part(Chandelier, V3(3, 1, 3), CFrame, "Black", "SmoothPlastic")
	Mesh(Fixture, "Sphere", V3(1, 1, 1))
	for c = 1, 5 do
		local Chain = Part(Chandelier, V3(1, 1, 1), CFrame*CN(0, 0.5-c*1.8, 0)*CA(0, c*90, 0), "Dark stone grey", "SmoothPlastic")
		Mesh(Chain, "FileMesh", V3(1.5, 2, 1.5), "http://www.roblox.com/asset?id=3270017")
	end
	local Top = Part(Chandelier, V3(2, 2, 2), CFrame*CN(0, -9, 0), "Medium stone grey", "SmoothPlastic")
	Cylinder(Top)
	for n = 1, 8 do
		local Shoulder = Part(Chandelier, V3(0.5, 0.5, 0.5), Top.CFrame*CA(0, n*360/8, 0)*CN(0, -1, 0.75), "Light stone grey", "SmoothPlastic")
		Before = Shoulder
		for a = 1, 7 do
			local Arm
			if n%2==0 then
				Arm = Part(Chandelier, V3(0.4, 1.5, 0.4), Before.CFrame*CN(0, -Before.Size.Y/2, 0)*CA(-180/8, 0, 0)*CN(0, -0.75, 0), "White", "SmoothPlastic")
			else
				Arm = Part(Chandelier, V3(0.4, 1, 0.4), Before.CFrame*CN(0, -Before.Size.Y/2, 0)*CA(-180/8, 0, 0)*CN(0, -0.5, 0), "White", "SmoothPlastic")
			end
			Before = Arm
			if a==7 then
				local Candleholder = Part(Chandelier, V3(1.4, 0.5, 1.4), Before.CFrame*CN(0, -Before.Size.Y/2, 0)*CA(-180/8, 0, 0)*CA(180, 0, 0), "White", "SmoothPlastic")
				Cylinder(Candleholder)
				local Wax = Part(Chandelier, V3(0.6, 1.4, 0.6), Candleholder.CFrame*CN(0, 0.95, 0), "Institutional white", "SmoothPlastic")
				Cylinder(Wax)
				local Wick = Part(Chandelier, V3(0.2, math.random(2, 5)/10, 0.2), Wax.CFrame*CN(0, 0.7, 0), "Black", "SmoothPlastic")
				Cylinder(Wick)
				local Flame = Part(Chandelier, V3(7, 7, 7), Wick.CFrame*CA(45, 0, 45), "Bright orange", "SmoothPlastic", 0.95)
				Mesh(Flame)
				Flame.CanCollide = false
				New'Fire'{Parent = Wick, Size = 1, Heat = pi}
			end
		end
	end
end

function Library(Parent, CFrame, WallColor)
        local Library = New'Model'{Parent = Parent, Name = "Library"}
        local LibraryFloor = Part(Library, V3(150, 1, 200), CFrame*CN(0, 0.5, 0), "Artichoke", "Fabric")
        for A = -1, 1, 2 do
                local RightLeftWall = Part(Library, V3(1, 7, 200), LibraryFloor.CFrame*CN(74.5*A, 4, 0), WallColor, "Wood")
                local GlassPane = Part(Library, V3(0.5, 28, 180), RightLeftWall.CFrame*CN(0, 14, 0), "Pastel light blue", "Ice", 0.3)
                local Cross2 = Part(Library, V3(1, 0.5, 180), GlassPane.CFrame*CN(0, 1, 0), WallColor, "Wood")
                for W = -2, 2 do
                        local WindowDivider = Part(Library, V3(1, 21, 10), RightLeftWall.CFrame*CN(0, 14, 25*W), WallColor, "Wood")
						local WindowColumn = Pillar(Library, RightLeftWall.CFrame*CN(-A*10, -2, 25*W), 5, 30.5, "Black", "Slate")
                end
                for W = -1.5, 1.5 do
                        local WindowArch = Curve(Library, RightLeftWall.CFrame*CN(0, 14.5, 25*W)*CA(-90, 0, 90), 7.5, 180, 20, 5, 1, WallColor, "Wood")
                        local Cross1 = Part(Library, V3(1, 19, 0.5), RightLeftWall.CFrame*CN(0, 12.75, 25*W), WallColor, "Wood")
                end
                for E = -1, 1, 2 do
                        local WallEnd = Part(Library, V3(1, 21, 20), RightLeftWall.CFrame*CN(0, 14, 90*E), WallColor, "Wood")
                        local WindowArch = Curve(Library, RightLeftWall.CFrame*CN(0, 12, 67.5*E)*CA(-90, 0, 90), 12.5, 180, 20, 6, 1, WallColor, "Wood")
                        local Cross1 = Part(Library, V3(1, 21.5, 0.5), RightLeftWall.CFrame*CN(0, 14, 67.5*E), WallColor, "Wood")
                end
                local RightLeftWall2 = Part(Library, V3(1, 10, 200), RightLeftWall.CFrame*CN(0, 29.5, 0), WallColor, "Wood")
				
				local DoorwayEdging = Part(Library, V3(2, 10, 2), LibraryFloor.CFrame*CN(A*12, 5.5, -99.5), "White", "Wood")
        end
        local BackWall = Part(Library, V3(148, 38, 1), LibraryFloor.CFrame*CN(0, 19.5, 99.5), WallColor, "Wood")
        local FrontWall = Part(Library, V3(65, 38, 1), LibraryFloor.CFrame*CN(41.5, 19.5, -99.5), WallColor, "Wood")
        local FrontWall2 = Part(Library, V3(65, 38, 1), LibraryFloor.CFrame*CN(-41.5, 19.5, -99.5), WallColor, "Wood")
        local FrontWall3 = Part(Library, V3(18, 18, 1), LibraryFloor.CFrame*CN(0, 29.5, -99.5), WallColor, "Wood")
        local DoorwayArch = Curve(Library, FrontWall3.CFrame*CN(0, -18, 0)*CA(-90, 0, 0), 9, 180, 20, 4, 1, WallColor, "Wood")
		local DoorwayArch2 = Curve(Library, FrontWall3.CFrame*CN(0, -18, 0)*CA(-90, 0, 0), 11, 180, 20, 2, 2, "White", "Wood")
		local Doorway = Part(Library, V3(20, 20, 0.5), LibraryFloor.CFrame*CN(0, 10.5, -99.5), "Brown", "Wood")
		Doorway.CanCollide = false
        local Ceiling = Part(Library, V3(148, 3, 198), LibraryFloor.CFrame*CN(0, 37, 0), "Cadet blue", "Ice")
        Fountain(Library, LibraryFloor.CFrame*CN(0, 0, 57))
        Colors = {
                {"Bright red", "Tr. Red"},
                {"Bright orange", "Neon orange", "Deep orange"},
                {"Bright yellow", "New Yeller", "Tr. Yellow"},
                {"Bright green", "Dark green", "Earth green"},
                {"Bright blue", "Navy blue", "Deep blue", "Dove blue", "Royal blue", "Tr. Blue"}
        }
        for A = -4, 4 do
                Bookshelf(Library, LibraryFloor.CFrame*CN(0, 0.5, 97-40)*CA(0, 20*A, 0)*CN(0, 0, 40), 5, 5, "Brown", Colors[math.abs(A)+1])
        end
        local Colors = {"Bright red", "Bright yellow", "Bright green", "Bright blue"}
        for A = -1, 1, 2 do
                for T = -1, 1, 2 do
                        local Designated = math.random(1, #Colors)
                        local DesignatedColor = Colors[Designated]
                        table.remove(Colors, Designated)
                        local Table = Table(Library, LibraryFloor.CFrame*CN(A*30, 0.5, T*30-30)*CA(0, math.random(-5, 5), 0), 15, 20, "Pine Cone", DesignatedColor)
						Chandelier(Library, LibraryFloor.CFrame*CN(A*30, 35.5, T*30-30))
                        for B = -1, 1, 2 do
                                wait()
                                for C = -1, 1 do
                                        Chair(Library, Table.Top.CFrame*CN(7.5*B, -4, C*5)*CA(0, 90*B+math.random(-5, 5), 0), "Pine Cone", "Black")
                                end
                        end
                end
        end
		
		for s = -1, 1, 2 do
			for b = 0, 3 do
				Bookshelf(Library, LibraryFloor.CFrame*CN(s*64-b*14*s, 0.5, -97)*CA(0, 180, 0), 7, 7-b, "Pine Cone", {"Black", "White", "Medium stone grey"})
			end
		end
		
		--[[for b = -1, 1 do
			Bookshelf(Library, LibraryFloor.CFrame*CN(b*28, 0.5, 97), 14, 7-b^2, "Pine Cone", {"Black", "White", "Medium stone grey"})
		end]]
		
		Scaffold(Library, LibraryFloor.CFrame*CN(30, 0.5, -85), 7, 14, 10, 1, 3, false)
		
        return Library
end

--Lighting
Lighting = Game:GetService("Lighting")
Lighting:ClearAllChildren()
Lighting.Outlines = false

--[[Sky = New'Sky'{
        Parent = Lighting,
        CelestialBodiesShown = false,
        SkyboxBk = "rbxassetid://55054494",
        SkyboxDn = "rbxassetid://55054494",
        SkyboxFt = "rbxassetid://55054494",
        SkyboxLf = "rbxassetid://55054494",
        SkyboxRt = "rbxassetid://55054494",
        SkyboxUp = "rbxassetid://55054494"
}

--Whiteness
Lighting.TimeOfDay = 14
Lighting.Ambient = C3(1, 1, 1)
Lighting.OutdoorAmbient = C3(0.5, 0.5, 0.5)
Lighting.FogColor = C3(1, 1, 1)
Lighting.FogStart = 0
Lighting.FogEnd = 512]]

--Darkness
--[[Lighting.TimeOfDay = 0
Lighting.FogColor = Color3.new()
Lighting.FogStart = 0
Lighting.FogEnd = 512 --64]]

ThingsToKill = {}
for _, Thing in pairs(Workspace.ask4kingbily:GetChildren()) do
        if Thing.Name == "Pumpkin cheesecake flavored nachos" then
                table.insert(ThingsToKill, Thing)
        end
end

--Map time!

Offset = CN(0, 2.5, 0)

Map = New'Model'{Parent = Workspace.ask4kingbily, Name = "Pumpkin cheesecake flavored nachos"}
--Sand = Part(Map, V3(2048, 1, 2048), Offset, "Cool yellow", "Sand")

--Library
Library(Map, Offset*CN(0, 0.5, 0)*CA(0, -15, 0), "Brown") --Pastel brown

--Sand Temple
Ruins(Map, Offset*CN(200, 0.5, 0)*CA(0, 30, 0))

--And.. Now remove the old map, :3
for _, Thing in pairs(ThingsToKill) do
        for _, Obj in pairs(Thing:GetChildren()) do
                Obj:Destroy()
                if _%100 == 0 then wait() end
        end
        Thing:Destroy()
end