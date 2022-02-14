--Building Generator

--[[

starting square

new squares start at the first, then are sent to another adjacent cell
each square keeps track of where it sends any square that tries to inhabit its cell
if it sends one square to the right, it must choose next time only to send it left, or forward, or backward.

the initial direction to which a square sends is relative to the direction it was originally pushed toward.



cool:
	make it so that if the house is on a hill, it becomes supported by beams stemming from its floor. These beams are arranged according to the distance between the floor and the ground
	make a great decking/walkway/driveway system for the outdoor portion of the house!
	(put a lamp-post, lamp, light; somewhere, maybe?)





]]

t = tick()
print(t)
--math.randomseed(1474098743.9865)
math.randomseed(tick())

cn = CFrame.new
v2 = Vector2.new
v3 = Vector3.new
u2 = UDim2.new
bn = BrickColor.new
c3 = Color3.new

local ca = function(x, y, z, inRadians)
	if inRadians then
		return CFrame.Angles(x or 0, y or 0, z or 0)
	else
		return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
	end
end

gc = function(obj) return obj:GetChildren() end

for n, s in pairs({"Players", "Debris", "RunService", "Lighting"}) do
	getfenv(1)[s] = Game:GetService(s)
end

function truncateName(name)
	return name:sub(1, 1):lower()..name:sub(2):gsub(" ", "")
end
function setEnvironmentGlobalized(f, t)
	setfenv(f, setmetatable(t or getfenv(f), {__index = function(t, i) return getfenv(1)[i] end}))
	return f
end

--[[

-------------------
set demonstrations:
-------------------


set(instance){prop = value} --set the properties of instance
set(tableOfInstances){prop = value} --set the properties for multiple instances

set(instance){..., descendant} --give descendants to instance
set(instance){..., "environmentNameForThis"} --give variable names to instance

set(instance){..., {Event = function}} --sets instance.Event:connect(function)*
set(instance){..., function() this:Destroy() end} --execute functions on instance*
set(instance){..., {table, function}} --executes function(i, v) on each pair of the table*
set(instance){..., {{1, 10, function}, {-1, 1, 2, function2}}} --executes function(i) on each number 1-10
set(instance){..., {{1, 10, 2, function}}} --executes function(i) on each number; 1-10, step 2*

*For anything using functions, it may be important to note that the variable "this" is equal to the object being set

]]

function set(instance)
	return function(properties)
		if type(instance) == "table" then
			local instances = {}
			for _, toSet in pairs(instance) do
				table.insert(instances, set(toSet)(properties))
			end
			return instances
		elseif type(instance) == "userdata" then
			for k, v in pairs(properties) do
				if type(k) == "string" then
					local propertyName = k:gsub(k, {
						pt = "Parent", sz = "Size", cf = "CFrame", bc = "BrickColor", tr = "Transparency", sc = "Scale", an = "Anchored",
						ts = "TopSurface", bs = "BottomSurface", rs = "RightSurface", ls = "LeftSurface", fs = "FrontSurface", bks = "BackSurface", cl = "Color", mt = "Material",
						nm = "Name", bgc = "BackgroundColor3", bgt = "BackgroundTransparency", bsp = "BorderSizePixel", bc3 = "BorderColor3", ps = "Position", cc = "CanCollide",
						p0 = "Part0", p1 = "Part1"
					})
					instance[propertyName] = v
				elseif type(k) == "number" then
					if type(v) == "userdata" then
						v.Parent = instance
					elseif type(v) == "table" then
						for event, connection in pairs(v) do
							if type(event) == "string" then
								if type(connection) == "function" then
									instance[event]:connect(setEnvironmentGlobalized(connection, {this = instance}))
								end
							elseif type(event) == "number" then
								if type(connection) == "table" then
									if type(connection[1]) == "table" then
										local toDo = connection[2]
										setEnvironmentGlobalized(toDo, {this = instance})
										for i, v in pairs(connection[1]) do
											toDo(i, v)
										end
									else
										local step, toDo = 1, connection[3]
										if type(toDo) == "number" then
											step = connection[3]
											toDo = connection[4]
										end
										setEnvironmentGlobalized(toDo, {this = instance})
										for i = connection[1], connection[2], step do
											toDo(i)
										end
									end
								end
							end
						end
					elseif type(v) == "string" then
						getfenv(0)[v] = instance
					elseif type(v) == "function" then
						setEnvironmentGlobalized(v, {this = instance})()
					end
				end
				if properties.CFrame then instance.CFrame = properties.CFrame end
			end
			return instance
		end
	end
end
function new(instanceType)
	local newInstance = Instance.new(instanceType)
	if newInstance:IsA("BasePart") then
		pcall(function() newInstance.FormFactor = 3 end)
		set(newInstance){sz = v3(1, 1, 1), mt = "SmoothPlastic", ts = 0, bs = 0, Locked = true, an = true}
	elseif newInstance:IsA("GuiObject") then
		set(newInstance){sz = u2(1, 0, 1, 0), bsp = 0, bgc = c3()}
		if newInstance:IsA("TextBox") or newInstance:IsA("TextLabel") or newInstance:IsA("TextButton") then
			set(newInstance){Text = "", TextColor3 = c3(1, 1, 1), bgt = 1}
		end
		if newInstance:IsA("GuiButton") then
			newInstance.AutoButtonColor = false
		end
	end
	return function(properties)
		return set(newInstance)(properties)
	end
end
function destroy(...)
	set({...}){function() this:Destroy() end}
end
function round(n)
	local int, f = math.modf(n)
	if f > 0.5 then
		return math.ceil(n)
	else
		return math.floor(n)
	end
end
function clone(object)
	local clonedObject
	if type(object) == "table" then
		local clonedTable = {}
		for i, v in pairs(object) do
			clonedTable[i] = v
		end
		clonedObject = clonedTable
	else
		clonedObject = object:Clone()
	end
	return clonedObject
end

function castRay(origin, direction, ignoreList)
	local ray = Ray.new(origin, direction)
	local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
	return part, position
end

--part function
function newPart(pt, sz, cf, bc, mt)
	return new'Part'{pt = pt, sz = sz, cf = cf, bc = bn(bc), mt = mt or "SmoothPlastic"}
end

function connect(pt, p1, p2, sz, bc, mt, orientedY)
	local dist = (p2-p1).magnitude
	if not orientedY then
		return newPart(pt, v3(sz.X, sz.Y, dist), cn(p1, p2)*cn(0, 0, -dist/2), bc, mt)
	else
		return newPart(pt, v3(sz.X, dist, sz.Y), cn(p1, p2)*cn(0, 0, -dist/2)*ca(90, 0, 0), bc, mt)
	end
end


for i, v in pairs(gc(Workspace)) do
	if v.Name == "Building Test" or v.Name == "Random Hill" then
		v:Destroy()
	end
end

mound = new'Model'{pt = Workspace, nm = "Random Hill"}

hill = newPart(mound, v3(100, 20, 100), cn(100, 10.5, 100), "Dark green", "Grass")
hill2 = newPart(mound, v3(50, 15, 50), hill.CFrame*cn(-75, -2.5, 25), "Dark green", "Grass")
hill3 = newPart(mound, v3(50, 10, 30), hill.CFrame*cn(-75, -5, -35), "Dark green", "Grass")
hill3a = newPart(mound, v3(10, 5, 30), hill3.CFrame*cn(20, 7.5, 0), "Dark green", "Grass")
hill4 = newPart(mound, v3(10, 5, 30), hill3.CFrame*cn(-30, -2.5, 0), "Dark green", "Grass")

test = new'Model'{pt = Workspace, nm = "Building Test"}

building = new'Model'{pt = test, nm = "The House"}

supportsModel = new'Model'{pt = test, nm = "The House Supports"}

offset = cn(25, 21, 104)
floorSize = v3(14, 1, 14)
wallWidth = 1
floorHeight = 11.5
doorTopWidth = 2.5

doorFrameSize = v2(0.6, 1.2)

supportHeight = 30
supportSize = v2(2, 2)

supportColor = "Black"
supportMaterial = "Wood"

wallColor = "Medium stone grey"
wallMaterial = "Concrete"

upstairsWallColor = "Medium stone grey"
upstairsWallMaterial = "Concrete"

ceilingColor = "Dark stone grey"
ceilingMaterial = "Concrete"

doorFrameColor = "Brown"
doorFrameMaterial = "Wood"

ladderRungs = 5

centralFloor = nil

directions = {v2(0, 1), v2(0, -1), v2(1, 0), v2(-1, 0)}

floors = {
	{v2(0, 0), {1, 2, 3, 4}, {}} --the initial square, which has not sent any of its current directions
}

walls = {}
partsUnderneath = {}
staircases = {}
doorTops = {}

c = 14 --represents the number of floor cells

function has(t, v)
	for i, v2 in pairs(t) do
		if v2 == v then
			return v
		end
	end
	return false
end

function hasFloor(cell)
	for i, v in pairs(floors) do
		if v[1] == cell then
			return v
		end
	end
	return false
end

for f = 1, c do
	local newFloor = {v2(0, 0), {4, 3, 2, 1}, {}}
	--[[for i = 1, 4 do
		table.insert(newFloor[2], math.random(1, 4))
	end]]
	
	local function checkFloor()
		for f2 = 1, #floors do
			local floor2 = floors[f2]
			if newFloor[1] == floor2[1] then
				local d = math.random(1, #floor2[2])
				local dir = floor2[2][d]
				table.remove(floor2[2], d)
				
				if #floor2[2] == 0 then
					floor2[2] = {1, 2, 3, 4}
				end
				
				newFloor[1] = newFloor[1]+directions[dir]
				checkFloor()
			end
		end
	end
	checkFloor()
	table.insert(floors, newFloor)
end

for f = 1, #floors do
	wait()
	local floor1 = floors[f]
	local floorPart = newPart(building, floorSize, offset*cn(floor1[1].X*floorSize.X, 0, floor1[1].Y*floorSize.Z), "Dark stone grey", "Concrete")
	
	local part, pos = castRay(floorPart.Position, v3(0, -supportHeight, 0), {building})
	if part and not has(partsUnderneath, part) then
		table.insert(partsUnderneath, part)
	end
	
	if floor1[1] == v2(0, 0) then
		centralFloor = floorPart
		centralFloor.BrickColor = bn("Bright red")
	end
	
	local emptyAdjacent = 0
	local adjacentWalls = 0
	for d, dir in pairs(directions) do
		local floor2 = hasFloor(floor1[1]+dir)
		if not floor2 then
			emptyAdjacent = emptyAdjacent+1
			local wall = newPart(building, v3(floorSize.X, floorHeight+floorSize.Y, wallWidth), cn(floorPart.Position, (floorPart.CFrame*cn(-dir.X, 0, -dir.Y)).p)*cn(0, floorHeight/2, floorSize.Z/2+wallWidth/2), wallColor, wallMaterial)
			table.insert(floor1[3], wall)
			table.insert(walls, wall)
		else
			if #floor2[3] > 0 then
				adjacentWalls = adjacentWalls+#floor2[3]
			end
		end
	end
	if #floor1[3] > 0 then
			local part, pos = castRay(floorPart.Position, v3(0, -supportHeight, 0), {building})
			
			if part then
				if (pos-floorPart.Position).magnitude > floorPart.Size.Y/2+0.2 then
					local support = connect(supportsModel, floorPart.Position, pos+(pos-floorPart.Position).unit*(supportSize.X+supportSize.Y)/4, supportSize, supportColor, supportMaterial, true)
				end
			else
				for p, underPart in pairs(partsUnderneath) do
					local part, pos = castRay(floorPart.Position-v3(0, supportSize.Y/2, 0), cn(centralFloor.Position+v3(0, supportHeight, 0), underPart.Position).lookVector*supportHeight, {building})
					if part then
						local support = connect(supportsModel, floorPart.Position-v3(0, supportSize.Y/2, 0), pos+(pos-floorPart.Position).unit*(supportSize.X+supportSize.Y)/4, supportSize, supportColor, supportMaterial, true)
					end
				end
			end
	end
	if emptyAdjacent == 1 and adjacentWalls == 2 then
		for w, wall in pairs(floor1[3]) do
			--make door
			local wallCFrame = wall.CFrame
			wall:Destroy()
			local doorTop = newPart(building, v3(floorSize.X, doorTopWidth, wallWidth), wallCFrame*cn(0, floorHeight/2+floorSize.Y/2-doorTopWidth/2, 0), wallColor, wallMaterial)
			--frame
			connect(building, (doorTop.CFrame*cn(-floorSize.X/2-doorFrameSize.X/2, -doorTopWidth/2, 0)).p, (doorTop.CFrame*cn(floorSize.X/2+doorFrameSize.X/2, -doorTopWidth/2, 0)).p, v2(doorFrameSize.Y, doorFrameSize.X), doorFrameColor, doorFrameMaterial, true)
			connect(building, (doorTop.CFrame*cn(floorSize.X/2, -doorTopWidth/2, 0)).p, (doorTop.CFrame*cn(floorSize.X/2, -floorHeight+doorTopWidth/2, 0)).p, doorFrameSize, doorFrameColor, doorFrameMaterial, true)
			connect(building, (doorTop.CFrame*cn(-floorSize.X/2, -doorTopWidth/2, 0)).p, (doorTop.CFrame*cn(-floorSize.X/2, -floorHeight+doorTopWidth/2, 0)).p, doorFrameSize, doorFrameColor, doorFrameMaterial, true)
			table.insert(doorTops, doorTop)
		end
	end
	if emptyAdjacent < 3 then
		local ceilingPart = newPart(building, floorSize, offset*cn(floor1[1].X*floorSize.X, floorHeight, floor1[1].Y*floorSize.Z), floorPart.BrickColor.Name, ceilingMaterial)
	else
		--stairs
		for s = 1, ladderRungs do
			local angleX, angleY, angleZ = cn(centralFloor.Position, floorPart.Position):toObjectSpace(floorPart.CFrame):toEulerAnglesXYZ()
			local Y2 = round(math.deg(angleY)/90)*90
			local rung = newPart(building, v3(floorSize.X/2, 1, 1), floorPart.CFrame*ca(0, Y2, 0)*cn(0, s*(floorHeight/ladderRungs), floorSize.Z/2-0.5), "Nougat", "Wood")
		end
		table.insert(staircases, floorPart)
	end
end

for w, wall in pairs(walls) do
	local wall2 = newPart(building, v3(floorSize.X, floorHeight+floorSize.Y, wallWidth), wall.CFrame*cn(0, floorHeight+floorSize.Y, 0), upstairsWallColor, upstairsWallMaterial)
end

--decking, first floor

for d, doorTop in pairs(doorTops) do
	
end

--roofTop = newPart(building, v3(1, 1, 1), centralFloor.)


