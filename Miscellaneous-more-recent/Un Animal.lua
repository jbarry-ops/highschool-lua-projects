--Kinematics

t = tick()
print(t)
math.randomseed(t)

MR = math.random

CN = CFrame.new
V2 = Vector2.new
V3 = Vector3.new
U2 = UDim2.new
BN = BrickColor.new
C3 = Color3.new

local CA = function(x, y, z, inRadians)
	if inRadians then
		return CFrame.Angles(x or 0, y or 0, z or 0)
	else
		return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
	end
end

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
						nm = "Name", bgc = "BackgroundColor3", bgt = "BackgroundTransparency", bsp = "BorderSizePixel", bC3 = "BorderColor3", ps = "Position", cc = "CanCollide",
						p0 = "Part0", p1 = "Part1", mst = "MeshType"
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
				if properties.C0 then instance.C0 = properties.C0 end
				if properties.C1 then instance.C1 = properties.C1 end
			end
			return instance
		end
	end
end

function new(instanceType)
	local newInstance = Instance.new(instanceType)
	if newInstance:IsA("BasePart") then
		pcall(function() newInstance.FormFactor = 3 end)
		set(newInstance){sz = V3(1, 1, 1), mt = "SmoothPlastic", ts = 0, bs = 0, Locked = true, an = false}
	elseif newInstance:IsA("GuiObject") then
		set(newInstance){sz = U2(1, 0, 1, 0), bsp = 0, bgc = C3()}
		if newInstance:IsA("TextBox") or newInstance:IsA("TextLabel") or newInstance:IsA("TextButton") then
			set(newInstance){Text = "", TextColor3 = C3(1, 1, 1), bgt = 1}
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

function weld(p0, p1, c0, c1)
	return new'Weld'{pt = p0, p0 = p0, p1 = p1, C0 = c0, C1 = c1}
end

function part(pt, sz, cf, bc, tr, mt)
	return new'Part'{pt = pt, sz = sz, cf = cf, bc = BN(bc or ""), tr = tr or 0, mt = mt or "SmoothPlastic"}
end

function mesh(pt, sc, mst)
	return new'SpecialMesh'{pt = pt, mst = mst or "Sphere", sc = sc or V3(1, 1, 1)}
end

function cylinder(pt, sc)
	return new'CylinderMesh'{pt = pt, sc = sc or V3(1, 1, 1)}
end

function addPart(pt, sz, p1, c0, c1, bc, tr, mt)
	local newPart = part(pt, sz, p1.CFrame, bc, tr, mt)
	newPart.Anchored = false
	newPart.CanCollide = false
	local newWeld = weld(newPart, p1, c0, c1)
	newWeld.Name = "Weld"
	return newPart, newWeld
end

for _, obj in pairs(Workspace:GetChildren()) do
	if obj.Name == "Kinematics Tests" then
		obj:Destroy()
	end
end

robot = new'Model'{pt = Workspace.ask4kingbily, nm = "Kinematics Tests"}


--joints (from base to furthest joint)
constraints = {
	{50, 50, 0, 2, 5}, --X, Y, Z, SizeX, SizeZ
	{60, 30, 0, 1.75, 4},
	{70, 30, 0, 1.5, 3},
	{80, 30, 0, 1.25, 3},
	{90, 30, 0, 1, 3}
}

base = part(robot, V3(7, 1, 7), CN(0, 1, 0)*CA(0, 45, 0))

joints = {}

for j, constraint in pairs(constraints) do
	local lastJoint = joints[j-1] or base
	local newJoint, newWeld = addPart(robot, V3(constraint[4], constraint[5], constraint[4]), lastJoint, CN(), CN(0, lastJoint.Size.Y/2, 0)*CN(0, constraint[5]/2, 0))
	table.insert(joints, newJoint)
	cylinder(newJoint)
	local elbow = addPart(robot, V3(constraint[4], constraint[4], constraint[4]), newJoint, CN(0, constraint[5]/2, 0), CN())
	mesh(elbow)
end

Player = Players.LocalPlayer
Mouse = Player:GetMouse()

wait(1)

for i = 1, 100 do
	wait()
	for j, joint in pairs(joints) do
		local lastJoint = joints[j-1] or base
		joint.Weld.C1 = CN(0, lastJoint.Size.Y/2, 0)*CA(constraints[j][1]*i/100, 0, 0)*CA(0, constraints[j][2]*i/100, 0)*CA(0, 0, constraints[j][3]*i/100)*CN(0, joint.Size.Y/2, 0)
	end
end

