local V3, CN, CA, BN = Vector3.new, CFrame.new, CFrame.Angles, BrickColor.new
local pairs, sqrt, ceil, floor = pairs, math.sqrt, math.ceil, math.floor
local sin, cos, tan, deg, rad, pi = math.sin, math.cos, math.tan, math.deg, math.rad, math.pi

local Debris, RunService, UIS, Lighting = Game:GetService("Debris"), Game:GetService("RunService"), Game:GetService("UserInputService"), Game:GetService("Lighting")

local function set(obj, props) for p, q in pairs(props) do obj[p] = q end end
local function new(obj, props) local this = Instance.new(obj) for p, q in pairs(props) do this[p] = q end return this end
local function copy(obj, pt, props) local this = obj:Clone() for p, q in pairs(props) do this[p] = q end this.Parent = pt return this end

local SpecialMesh, CylinderMesh, Motor, Model = Instance.new("SpecialMesh"), Instance.new("CylinderMesh"), Instance.new("Motor6D"), Instance.new("Model")
local Part = new("Part", {TopSurface = 0, BottomSurface = 0, Material = "SmoothPlastic"})
local WedgePart = new("WedgePart", {TopSurface = 0, BottomSurface = 0, Material = "SmoothPlastic"})

local function part(pt, sz, bc, mt) return copy(Part, pt, {Size = sz, BrickColor = bc, Material = mt}) end
local function wedge(pt, sz, bc, mt) return copy(WedgePart, pt, {Size = sz, BrickColor = bc, Material = mt}) end
local function motor(pt, p0, p1, c0) return copy(Motor, pt, {Part0 = p0, Part1 = p1, C0 = c0}) end
local function addPart(pt, sz, bc, mt, p0, c0) local this = part(pt, sz, bc, mt) return this, motor(this, p0, this, c0) end
local function addWedge(pt, sz, bc, mt, p0, c0) local this = wedge(pt, sz, bc, mt) return this, motor(this, p0, this, c0) end
local function addCylinder(pt, sz, bc, mt, p0, c0) local this = part(pt, sz, bc, mt) this.Shape = "Cylinder" return this, motor(this, p0, this, c0) end
local function addSphere(pt, sz, bc, mt, p0, c0) local this = part(pt, sz, bc, mt) this.Shape = "Ball" return this, motor(this, p0, this, c0) end

local color, material, offset = {BN("Black"), BN("White")}, {"Slate", "SmoothPlastic"}, CN(40, 40, 40)

local dragon = new("Model", {Name = "龙"})

local torso = part(dragon, V3(4, 4, 16), color[1], material[1])
	local gyro = new("BodyGyro", {MaxTorque = V3(1/0, 1/0, 1/0), P = 10^6, CFrame = CN(), Parent = torso})
	local velocity = new("BodyVelocity", {MaxForce = V3(1/0, 1/0, 1/0), P = 10^4, Velocity = V3(), Parent = torso})

local tailStart, tailStartJoint = addPart(dragon, V3(3.7, 3.7, 3), color[1], material[1], torso, CN(0, -0.15, -8))

local tail = {{tailStartJoint, CN(0, -0.15, -8), 3}}
local last = tailStart

for i = 0, 11 do --tail parts
	local w, l = last.Size.X, last.Size.Z
	local nW, nL = w-0.3, l
	
	local newTail, newJoint = addPart(dragon, V3(nW, nW, nL), color[1], material[1], last, CN(0, -0.15, -l/2+nW/3)*CA(sin(i*pi/6)*pi/14, 0, 0)*CN(0, 0, -l/2))
	local tailTop = addWedge(newTail, V3(nW, 0.3, nL), color[1], material[1], newTail, CN(0, nW/2+0.15, 0))
	local tailBot = addWedge(newTail, V3(nW, 0.3, nL), color[2], material[2], newTail, CN(0, -nW/2-0.15, 0)*CA(pi, 0, 0))
	
	last = newTail
	table.insert(tail, {newJoint, CN(0, -0.15, -l/2), l})
end

--ANIMATION: HAVE FUNCTIONS FOR EACH ANIMATION, AND PLAY THEM WITH RUNSERVICE:BINDTOSTEP? OR RunService.Stepped:connect(function) while you unconnect the current one.
--[[
	animation = function() end
	animation2 = function() end
	RunService.Stepped:connect(animation)
	animation:disconnect()
	RunService.Stepped:connect(animation2)
	...
...
]]

--local legs = {}

for s = -1, 1, 2 do
	local hindThigh, hindThighJoint = addPart(dragon, V3(2, 4, 4), color[1], material[1], torso, CN(3*s, 1, -6)*CA(-rad(15), 0, 0)*CN(0, -2, 0))
		local thighTop = addCylinder(hindThigh, V3(1.9, 4, 4), color[1], material[1], hindThigh, CN(0, 2, 0)*CA(rad(90), 0, 0))
	local hindShin, hindShinJoint = addPart(dragon, V3(1.75, 3, 2), color[1], material[1], hindThigh, CN(0, -1, 0)*CA(rad(75), 0, 0)*CN(0, -1.5, 0))
	local hindAnkle, hindAnkleJoint = addPart(dragon, V3(1, 6, 1.5), color[1], material[1], hindShin, CN(0, -1, 0)*CA(rad(-60), 0, 0)*CN(0, -3, 0))
	
	local foreThigh, foreThighJoint = addPart(dragon, V3(2, 6, 2), color[1], material[1], torso, CN(3*s, 2, 7)*CA(rad(45), 0, 0)*CN(0, -3, 0))
		local thighTop = addSphere(foreThigh, V3(2, 2, 2), color[1], material[1], torso, CN(2*s, 2, 7)--[[*CA(rad(90), 0, 0)]])
	local foreShin, foreShinJoint = addPart(dragon, V3(1.5, 4, 1.5), color[1], material[1], foreThigh, CN(0, -2.5, 0)*CA(rad(-30), 0, 0)*CN(0, -2, 0))
	
	local wingShoulder = addPart(dragon, V3(1.5, 8, 2), color[1], material[1], thighTop, CA(rad(-45), 0, s*rad(-15))*CN(0, 4, 0))
	local wingStart = addPart(dragon, V3(1, 6, 1), color[1], material[1], wingShoulder, CN(0, 3.5, 0)*CA(rad(60), 0, 0)*CN(0, 3, 0))
	
	--for w = 0, 2 do
		local wing
	--end
	
	--hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii  johhhnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn frank was here
	--table.insert(legs, {hindThighJoint, hindShinJoint, foreThighJoint, foreShinJoint})
end

local neckStart, neckStartJont = addPart(dragon, V3(3.8, 3.8, 2), color[1], material[1], torso, CN(0, 0, 0))
for i = 0, 6 do
	--local neck = 
end

pcall(function() Workspace["龙"]:Destroy() end)
torso.CFrame = offset
dragon.Parent = Workspace
dragon.AncestryChanged:connect(function() script.Disabled = true script:Destroy() end)

--Lighting.Ambient = Color3.new(3/4, 3/4, 3/4)

--[[RunService.Stepped:connect(function(t)
	for i, v in pairs(tail) do
		local joint = v[1]
		local c0 = v[2]
		local l = v[3]
		local n = pi/6
	end
	legs[1][1].C0 = CN(-2, 1, -6)*CA(-rad(15)+math.sin(t*pi/4)*pi/8, 0, 0)*CN(0, -3, 0)
	legs[2][1].C0 = CN(2, 1, -6)*CA(-rad(15)-math.sin(t*pi/4)*pi/8, 0, 0)*CN(0, -3, 0)
end)]]