for _, Obj in pairs(Workspace:GetChildren()) do
	if Obj.Name == "Tree" then
		Obj:ClearAllChildren()
		wait()
		Obj:Destroy()
	end
end
CN, V3, U2, BN, C3 = CFrame.new, Vector3.new, UDim2.new, BrickColor.new, Color3.new
--Functions and cool things
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
function Part(Parent, Size, CFrame, BrickColor, Material, Transparency)
	return New'Part'{Parent = Parent, Size = Size, CFrame = CFrame, BrickColor = BN(BrickColor or "Black"), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
end
function Spawn(Parent, Size, CFrame, BrickColor, Material, Transparency)
	return New'SpawnLocation'{Parent = Parent, Size = Size, CFrame = CFrame, BrickColor = BN(BrickColor or "Black"), Material = Material or "SmoothPlastic", Transparency = Transparency or 0}
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

--Tree Generator

function Tree(Parent, CFrame, TrunkWidth, TrunkHeight, Levels, CurveResolution, Scaling, Randomness, LeafSize, ColorScheme, BarkMaterial, LeafMaterial)
	local Tree = New'Model'{Parent = Parent, Name = "Tree"}
	local Trunk = Part(Tree, V3(TrunkWidth, TrunkHeight, TrunkWidth), CFrame*CN(0, TrunkHeight/2, 0), ColorScheme[1], BarkMaterial)
	Cylinder(Trunk)
	local Branches = {
		[0] = {
			{Trunk}
		}
	}
	local LastTrunk = Trunk
	local TrunkCurveAngle = CA(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
	for T = 1, CurveResolution-1 do
		local NewWidth = TrunkWidth-Scaling[1]*TrunkWidth*(T+1)/CurveResolution
		local NewHeight = TrunkHeight-Scaling[2]*TrunkHeight*(T+1)/CurveResolution
		local NewTrunk = Part(Tree, V3(NewWidth, NewHeight, NewWidth), LastTrunk.CFrame*CN(0, LastTrunk.Size.Y/2-NewWidth/2, 0)*TrunkCurveAngle*CN(0, NewHeight/2, 0), ColorScheme[1], BarkMaterial)
		Cylinder(NewTrunk)
		table.insert(Branches[0][1], NewTrunk)
		LastTrunk = NewTrunk
	end
	for L = 1, Levels do
		local BranchesTable = {}
		for _, B in pairs(Branches[L-1]) do
			local LastAngle = math.random(-180, 180)
			--local LastAngle = 0
			local NumberOfSplits = math.random(2, 3)
			if math.random(1, 21) == 7 then
				NumberOfSplits = 1
			end
			for S = 1, NumberOfSplits do
				repeat wait() until Workspace:GetRealPhysicsFPS() > 40
				local ChosenSegment = B[#B]
				local SegmentWidth, SegmentHeight = ChosenSegment.Size.X, ChosenSegment.Size.Y
				local NewWidth = SegmentWidth-Scaling[1]*SegmentWidth
				local NewHeight = SegmentHeight-Scaling[2]*SegmentHeight
				local NewAngle = LastAngle+360/NumberOfSplits
				NewAngle = NewAngle+math.random(-21, 21)
				LastAngle = NewAngle
				local StartAngle = CA(math.random(0, Randomness)/CurveResolution, math.random(-5, 5), math.random(-5, 5))
				local BranchStart = Part(Tree, V3(NewWidth, NewHeight, NewWidth), ChosenSegment.CFrame*CN(0, SegmentHeight/2-NewWidth/2, 0)*CA(0, NewAngle, 0)*StartAngle*CN(0, NewHeight/2, 0), ColorScheme[1], BarkMaterial)
				Cylinder(BranchStart)
				local BranchCurve = {BranchStart}
				local LastBranch = BranchStart
				local BranchCurveAngle = CA(math.random(3, Randomness)/CurveResolution, math.random(-5, 5), math.random(-5, 5))
				for C = 1, CurveResolution-1 do
					repeat wait() until Workspace:GetRealPhysicsFPS() > 40
					local NewWidth = NewWidth-Scaling[1]*NewWidth*(C+1)/CurveResolution
					local NewHeight = NewHeight-Scaling[2]*NewHeight*(C+1)/CurveResolution
					local NewBranch = Part(Tree, V3(NewWidth, NewHeight, NewWidth), LastBranch.CFrame*CN(0, LastBranch.Size.Y/2-NewWidth/2, 0)*BranchCurveAngle*CN(0, NewHeight/2, 0), ColorScheme[1], BarkMaterial)
					Cylinder(NewBranch)
					table.insert(BranchCurve, NewBranch)
					if L > 2 --[[and C == CurveResolution-1]] then
						local NumberOfLeaves = {1, 2, 3}
						local NumberOfLeaves = 1
						for E = 1, NumberOfLeaves do
							local LeafStem = Part(Tree, V3(0.05, LeafSize.Y/2, 0.05), NewBranch.CFrame*CN(0, math.random(-NewHeight*5, NewHeight*5)/10, 0)*CA(0, math.random(-180, 180), 0)*CN(0, 0, NewWidth/2-0.025)*CA(math.random(13, 21), math.random(13, 21), math.random(8, 21))*CN(0, LeafSize.Y/4, 0), ColorScheme[1], BarkMaterial)
							Cylinder(LeafStem)
							local randomSizeMod = math.random(7, 14)/14
							local Leaf = Part(Tree, LeafSize*randomSizeMod, LeafStem.CFrame*CN(0, LeafSize.Y/4, 0)*BranchCurveAngle*CN(0, LeafSize.Y/2, 0), ColorScheme[2][math.random(1, #ColorScheme[2])], LeafMaterial)
							Leaf.CFrame = LeafStem.CFrame*CN(0, Leaf.Size.Y/4, 0)*BranchCurveAngle*CN(0, Leaf.Size.Y/2, 0)
							Leaf.Name = "Leaf"
							Leaf.CanCollide = false
							Mesh(Leaf, "Sphere")
						end
					end
					LastBranch = NewBranch
				end
				table.insert(BranchesTable, BranchCurve)
			end
			--repeat wait() until Workspace:GetRealPhysicsFPS() > 40
		end
		table.insert(Branches, BranchesTable)
	end
	return Tree
end
Colors = {
	{"Bright red", "Tr. Red"},
	{"Bright yellow", "Neon orange", "Br. yellowish orange"},
	{"Bright green", "Dark green", "Earth green"},
	{"Lilac", "Alder", "Pastel violet"},
	{"Pastel Blue", "Pastel light blue", "Dove blue", "White"}
}
for i = 1, 1 do
Tree(
	Workspace, --Parent
	CN(math.random(-108, 108), 0, math.random(-108, 108))*CA(0, 0, 0), --CFrame
	3, --Trunk width
	5, --Trunk height
	6, --Levels of recursion
	6, --Curve resolution
	{1/5, 1/6}, --Scaling: First value is how much less (percentage-wise) the width of the next branch will be relative to its parent, next is height
	108, --Randomness
	V3(0.5, 1, 0.2), --Leaf size
	{"Cashmere", Colors[math.random(1,#Colors)]}, --Color scheme
	"Wood", --Bark material
	"Plastic" --Leaf material
)
end