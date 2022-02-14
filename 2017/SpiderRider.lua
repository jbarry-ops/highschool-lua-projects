CN, CA, V3, U2, C3, BN = CFrame.new, CFrame.Angles, Vector3.new, UDim2.new, Color3.new, BrickColor.new
function new(instanceType, parent)
		return function(configuration)
				local newInstance = Instance.new(instanceType, parent)
				if newInstance:IsA("BasePart") then
						newInstance.TopSurface = 0
						newInstance.BottomSurface = 0
						newInstance.Material = "SmoothPlastic"
						newInstance.BrickColor = BN("Medium stone grey")
						newInstance.Locked = true
				end
				for property, value in pairs(configuration) do
						if type(value) == "function" then
								newInstance[property]:connect(value)
						else
								newInstance[property] = value
						end
				end
				if configuration["CFrame"] then
						newInstance.CFrame = configuration["CFrame"]
				end
				return newInstance
		end
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
 
--[[for _, Obj in pairs(Workspace:GetChildren()) do
		if Obj.Name == "Awesome scary spider" then
				Obj:Destroy()
		end
end]]
 
Player = Game:GetService("Players").LocalPlayer
Character = Player.Character
Mouse = Player:GetMouse()
UserInputService = Game:GetService("UserInputService")
Camera = Workspace.CurrentCamera
 
Offset = V3(25, 1.25, 25)
SpiderColor = "Black"
 
Spider = new("Model", Character){Name = "Awesome scary spider"}
Platform = new("Part", Spider){Size = V3(10, 1, 10), BrickColor = BN("Really red"), Transparency = 1, CanCollide = true}
 
Torso = new("Part", Spider){Size = V3(4, 4, 6), Name = "Torso", BrickColor = BN(SpiderColor), Transparency = 1}
new("BlockMesh", Torso){Scale = V3(1, 1, 1)}
new("Motor6D", Platform){Part0 = Platform, Part1 = Torso, C0 = CN(0, 5, 0)}
TorsoA = new("Part", Spider){Size = V3(4, 6, 4), BrickColor = BN(SpiderColor)}
--new("SpecialMesh", TorsoA){MeshType = "Sphere", Scale = V3(1.5, 1.5, 1.5)}
new("Motor6D", Torso){Part0 = Torso, Part1 = TorsoA, C0 = CA(math.rad(90), 0, 0)}
 
Head = new("Part", Spider){Size = V3(2, 2, 2), Name = "Head", BrickColor = BN(SpiderColor), Transparency = 1}
new("SpecialMesh", Head){MeshType = "Sphere", Scale = V3(1.5, 1.5, 1.5)}
Neck = new("Motor6D", Torso){Part0 = Torso, Part1 = Head, C0 = CN(0, 0, -4), Name = "Neck"}
 
FakeHead = new("Part", Spider){Size = V3(2, 2, 2), BrickColor = BN(SpiderColor)}
--new("SpecialMesh", FakeHead){MeshType = "Sphere", Scale = V3(1.5, 1.5, 1.5)}
new("Motor6D", Head){Part0 = Head, Part1 = FakeHead, C0 = CN()}
 
RightEye = new("Part", Spider){Size = V3(0.5, 0.5, 0.5), BrickColor = BN("White")}
new("SpecialMesh", RightEye){MeshType = "Sphere", Scale = V3(1, 1, 1)}
new("Motor6D", Head){Part0 = Head, Part1 = RightEye, C0 = CN(0.5, 0.25, -1.25)}
 
LeftEye = new("Part", Spider){Size = V3(0.5, 0.5, 0.5), BrickColor = BN("White")}
new("SpecialMesh", LeftEye){MeshType = "Sphere", Scale = V3(1, 1, 1)}
new("Motor6D", Head){Part0 = Head, Part1 = LeftEye, C0 = CN(-0.5, 0.25, -1.25)}
 
Torso2 = new("Part", Spider){Size = V3(6, 6, 8), BrickColor = BN(SpiderColor)}
new("Motor6D", Torso){Part0 = Torso, Part1 = Torso2, C0 = CN(0, 0, 7)}
--new("SpecialMesh", Torso2){MeshType = "Sphere", Scale = V3(1.5, 1.5, 1.5)}
 
RightLegs = {}
LeftLegs = {}
 
for L = 1, 4 do
		local RightLeg = new("Part", Spider){Size = V3(1, 5, 1), BrickColor = BN(SpiderColor)}
		new("CylinderMesh", RightLeg){Scale = V3(1, 1, 1)}
		new("Motor6D", RightLeg){Part0 = Torso, Part1 = RightLeg, C0 = CN(1.5, -1.5, -2+L)*CA(0, math.rad(45-L*15), math.rad(-60))*CN(0, 2.5, 0)}
		local RightLeg2 = new("Part", Spider){Size = V3(0.8, 5, 0.8), BrickColor = BN(SpiderColor)}
		new("CylinderMesh", RightLeg2){Scale = V3(1, 1, 1)}
		new("Motor6D", RightLeg2){Part0 = RightLeg, Part1 = RightLeg2, C0 = CN(0, 2.1, 0)*CA(0, 0, math.rad(-45))*CN(0, 2.5, 0)}
		local RightLeg3 = new("Part", Spider){Size = V3(0.6, 5, 0.6), BrickColor = BN(SpiderColor)}
		new("CylinderMesh", RightLeg3){Scale = V3(1, 1, 1)}
		new("Motor6D", RightLeg3){Part0 = RightLeg2, Part1 = RightLeg3, C0 = CN(0, 2.2, 0)*CA(0, 0, math.rad(-75))*CN(0, 2.5, 0)}
		table.insert(RightLegs, {RightLeg, RightLeg2, RightLeg3})
		
		local LeftLeg = new("Part", Spider){Size = V3(1, 5, 1), BrickColor = BN(SpiderColor)}
		new("CylinderMesh", LeftLeg){Scale = V3(1, 1, 1)}
		new("Motor6D", LeftLeg){Part0 = Torso, Part1 = LeftLeg, C0 = CN(-1.5, -1.5, -2+L)*CA(0, math.rad(-45+L*15), math.rad(60))*CN(0, 2.5, 0)}
		local LeftLeg2 = new("Part", Spider){Size = V3(0.8, 5, 0.8), BrickColor = BN(SpiderColor)}
		new("CylinderMesh", LeftLeg2){Scale = V3(1, 1, 1)}
		new("Motor6D", LeftLeg2){Part0 = LeftLeg, Part1 = LeftLeg2, C0 = CN(0, 2.1, 0)*CA(0, 0, math.rad(45))*CN(0, 2.5, 0)}
		local LeftLeg3 = new("Part", Spider){Size = V3(0.6, 5, 0.6), BrickColor = BN(SpiderColor)}
		new("CylinderMesh", LeftLeg3){Scale = V3(1, 1, 1)}
		new("Motor6D", LeftLeg3){Part0 = LeftLeg2, Part1 = LeftLeg3, C0 = CN(0, 2.2, 0)*CA(0, 0, math.rad(75))*CN(0, 2.5, 0)}
		table.insert(LeftLegs, {LeftLeg, LeftLeg2, LeftLeg3})
end
 
SpiderHumanoid = new("Humanoid", Spider){WalkSpeed = 30}
Spider:MakeJoints()
Platform.CFrame = CN(Offset)
 
SpiderVelocity = new("BodyVelocity", Platform){maxForce = V3(1/0, 1/0, 1/0)}
SpiderGyro = new("BodyGyro", Platform){maxTorque = V3(1/0, 1/0, 1/0), P = 1000, D = 100}
 
--Now, on to the fun stuffs..
 
Camera.CameraType = "Scriptable"
 
Character:WaitForChild("Animate"):Destroy()
CharacterHumanoid, CharacterTorso = Character:WaitForChild("Humanoid"), Character:WaitForChild("Torso")
CharacterHumanoid.PlatformStand = true
CharacterHumanoid.Changed:connect(function()
		CharacterHumanoid.PlatformStand = true
		CharacterHumanoid.Jump = false
end)
new("Motor6D", Torso){Part0 = Torso, Part1 = CharacterTorso, C0 = CN(0, 5, 0)}
 
Chatting = false
Moving = false
MaxSpeed = 30
Acceleration = 1
Deceleration = 1
SpeedW = 0
SpeedA = 0
SpeedS = 0
SpeedD = 0
Velocity = V3()
CameraAngleX, CameraAngleY = 45, 45
Dragging = false
Keys = {}

Gravity = -Character:GetMass()*Workspace.Gravity
 
UserInputService.InputBegan:connect(function(Input)
		local Key, InputType, Delta = Input.KeyCode.Name, Input.UserInputType.Name, Input.Delta
		if Key == "Slash" and not Chatting then
				Chatting = true
				Keys = {}
		elseif Key == "Return" and Chatting then
				Chatting = false
		elseif (Key == "W" or Key == "A" or Key == "S" or Key == "D") and not Chatting then
				Keys[Key] = true
		end
		if InputType == "MouseButton2" then
				Dragging = true
				UserInputService.MouseBehavior = "LockCurrentPosition"
		end
end)
 
UserInputService.InputChanged:connect(function(Input)
		local Key, InputType, Delta, Position = Input.KeyCode.Name, Input.UserInputType.Name, Input.Delta, Input.Position
		if InputType == "MouseMovement" and Dragging then
				CameraAngleX = CameraAngleX+Delta.Y*0.2
				if CameraAngleX > 80 then
						CameraAngleX = 80
				elseif CameraAngleX < -80 then
						CameraAngleX = -80
				end
				CameraAngleY = CameraAngleY-Delta.X*0.2
		end
end)
 
UserInputService.InputEnded:connect(function(Input)
		local Key, InputType, Delta = Input.KeyCode.Name, Input.UserInputType.Name, Input.Delta
		if (Key == "W" or Key == "A" or Key == "S" or Key == "D") and not Chatting then
				Keys[Key] = nil
		end
		if InputType == "MouseButton2" then
				Dragging = false
				UserInputService.MouseBehavior = "Default"
		end
end)
 
local function UpdateVelocity()
		if Keys["W"] then if SpeedW < MaxSpeed then SpeedW = SpeedW+Acceleration else SpeedW = MaxSpeed end else if SpeedW > 0 then SpeedW = SpeedW-Deceleration else SpeedW = 0 end end
		if Keys["A"] then if SpeedA < MaxSpeed then SpeedA = SpeedA+Acceleration else SpeedA = MaxSpeed end else if SpeedA > 0 then SpeedA = SpeedA-Deceleration else SpeedA = 0 end end
		if Keys["S"] then if SpeedS < MaxSpeed then SpeedS = SpeedS+Acceleration else SpeedS = MaxSpeed end else if SpeedS > 0 then SpeedS = SpeedS-Deceleration else SpeedS = 0 end end
		if Keys["D"] then if SpeedD < MaxSpeed then SpeedD = SpeedD+Acceleration else SpeedD = MaxSpeed end else if SpeedD > 0 then SpeedD = SpeedD-Deceleration else SpeedD = 0 end end
		Velocity = V3(SpeedD-SpeedA, -9.8, SpeedS-SpeedW)
end
 
Game:GetService("RunService").Stepped:connect(function(Time)
		--Animation
		if Moving then
				for L, Leg in pairs(RightLegs) do
						local RightLeg1 = Leg[1]
						local RightLeg2 = Leg[2]
						local RightLeg3 = Leg[3]
						
						local LeftLeg1 = LeftLegs[L][1]
						local LeftLeg2 = LeftLegs[L][2]
						local LeftLeg3 = LeftLegs[L][3]
						
						local Mult = 1-L%2*2
						
						--C0 = CN(-1.5, -1.5, -2+L)*CA(0, math.rad(-45+L*15), math.rad(45))*CN(0, 2.5, 0)
						--C0 = CN(0, 2.1, 0)*CA(0, 0, math.rad(60))*CN(0, 2.5, 0)
						--C0 = CN(0, 2.2, 0)*CA(0, 0, math.rad(60))*CN(0, 2.5, 0)
						
						RightLeg1.Motor6D.C0 = Lerp(RightLeg1.Motor6D.C0, CN(1.5, -1.5, -2+L)*CA(0, math.rad(45-L*15+math.sin(Time*40)*Mult*10), math.rad(-45+math.sin(Time*40)*Mult*20))*CN(0, 2.5, 0), 0.3)
						LeftLeg1.Motor6D.C0 = Lerp(LeftLeg1.Motor6D.C0, CN(-1.5, -1.5, -2+L)*CA(0, math.rad(-45+L*15+math.sin(Time*40)*Mult*-10), math.rad(45+math.sin(Time*40)*Mult*-20))*CN(0, 2.5, 0), 0.3)
				end
		else
				for L, Leg in pairs(RightLegs) do
						local RightLeg1 = Leg[1]
						local RightLeg2 = Leg[2]
						local RightLeg3 = Leg[3]
						
						local LeftLeg1 = LeftLegs[L][1]
						local LeftLeg2 = LeftLegs[L][2]
						local LeftLeg3 = LeftLegs[L][3]
						
						local Mult = 1-L%2*2
						
						--C0 = CN(-1.5, -1.5, -2+L)*CA(0, math.rad(-45+L*15), math.rad(45))*CN(0, 2.5, 0)
						--C0 = CN(0, 2.1, 0)*CA(0, 0, math.rad(60))*CN(0, 2.5, 0)
						--C0 = CN(0, 2.2, 0)*CA(0, 0, math.rad(60))*CN(0, 2.5, 0)
						
						RightLeg1.Motor6D.C0 = Lerp(RightLeg1.Motor6D.C0, CN(1.5, -1.5, -2+L)*CA(0, math.rad(45-L*15), math.rad(-45))*CN(0, 2.5, 0), 0.25)
						LeftLeg1.Motor6D.C0 = Lerp(LeftLeg1.Motor6D.C0, CN(-1.5, -1.5, -2+L)*CA(0, math.rad(-45+L*15), math.rad(45))*CN(0, 2.5, 0), 0.25)
				end
		end
end)
Game:GetService("RunService").RenderStepped:connect(function()
		UpdateVelocity()
		if math.abs(SpiderVelocity.velocity.X) > 0 or math.abs(SpiderVelocity.velocity.Z) > 0 then
				Moving = true
		else
				Moving = false
		end
		local CoordinateFrame2D = CN(V3(Camera.CoordinateFrame.X, Platform.CFrame.Y, Camera.CoordinateFrame.Z), Platform.Position)
		local RelativeVelocity = CoordinateFrame2D*Velocity-CoordinateFrame2D.p
		SpiderVelocity.velocity = RelativeVelocity
		SpiderGyro.cframe = CN(CoordinateFrame2D.p, Platform.Position)
		
		Camera:Interpolate(CN(Torso.Position)*CA(0, math.rad(CameraAngleY), 0)*CA(math.rad(CameraAngleX), 0, 0)*CN(0, 0, -20), Torso.CFrame, 0.01)
end)