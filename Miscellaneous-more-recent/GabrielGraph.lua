math.randomseed(tick())

points = {}
connected = {}
numPoints = 7
pointSpace = 77
pushDistance = 14
width = 3

function part(parent, sz, cf, bc)
	local newPart = Instance.new("Part", parent)
	newPart.FormFactor = 3
	newPart.Anchored = true
	newPart.Size = sz
	newPart.CFrame = cf
	newPart.BrickColor = BrickColor.new(bc)
	newPart.Material = "SmoothPlastic"
	newPart.TopSurface = 0
	newPart.BottomSurface = 0
	return newPart
end

for i, v in pairs(Workspace:GetChildren()) do
	if v.Name == "Gabriel Graph" then
		v:Destroy()
	end
end

graph = Instance.new("Model", Workspace)
graph.Name = "Gabriel Graph"

function push(pos)
	for pp = 1, #points do
		wait()
		local ppt = points[pp]
		local d = (ppt-pos).magnitude
		
		if d<pushDistance then
			local pushPos = (CFrame.new(pos, ppt)*CFrame.Angles(0, math.rad(math.random(-45, 45)), 0)).lookVector*pushDistance
			return push(ppt+pushPos)
		end
	end
	return pos
end

base = part(graph, Vector3.new(pointSpace*2, 1, pointSpace*2), CFrame.new(0, 1, 0), "Dark green")

for a = 0, 2 do
	local height = a*20+width
for p = 1, numPoints do
	local newPosition = Vector3.new(math.random(-pointSpace, pointSpace), height, math.random(-pointSpace, pointSpace))
	newPosition2 = newPosition--push(newPosition)
	
	table.insert(points, newPosition2)
	part(graph, Vector3.new(1, 1, 1), CFrame.new(newPosition2), "White")
end
end

numPoints = numPoints*3
--Gabriel Graphing

function connect(pt, pt2)
	print("connected..\n\t"..tostring(pt).."\n\t"..tostring(pt2))
	local m = (pt2+pt)/2
	local d = (pt2-pt).magnitude
	part(graph, Vector3.new(width, width, d), CFrame.new(m, pt2), "Black")
end

function check(p)
	local pt = points[p]
	
	for p2 = 1, #points do
		local pt2 = points[p2]
		local m = (pt2+pt)/2
		local d = (pt2-pt).magnitude
		local f = false
	
		for p3, pt3 in pairs(points) do
			if (pt3-m).magnitude<d/2 then
				f = true
				break
			end
		end
		
		if not f then
			--has free connection
			connect(pt, pt2)
		end
		
	end
end

for p, pt in pairs(points) do
	wait()
	check(p)
end