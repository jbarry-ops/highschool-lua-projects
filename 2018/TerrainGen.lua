local t = tick()
local V3, CN, BN = Vector3.new, CFrame.new, BrickColor.new
local noise, floor, ceil, abs, random = math.noise, math.floor, math.ceil, math.abs, math.random

local terrain = Workspace.Terrain
terrain:Clear()

local Part = Instance.new("Part")
Part.Anchored = true
Part.Size = V3(4, 4, 4)
Part.Material = "SmoothPlastic"

for i, v in pairs(Workspace:GetChildren()) do
	if v.Name == "terrainz" then
		v:Destroy()
		wait()
	end
end

local model = Instance.new("Model")
model.Name = "terrainz"
model.Parent = Workspace

local offset = CN(-400, 0, -400)

local function draw(x, y, z, m, s)
	--terrain:FillBlock(CN(x*4, y*4, z*4), V3(4, 4, 4), m)
	local prt = Part:Clone()
	prt.Size = V3(4, ceil(abs(s)/4)*4, 4)
	prt.CFrame = CN(x*4, ceil(y/4)*4, z*4)*offset
	prt.BrickColor = BN(m)
	prt.Parent = model
end

local f = 0.003 --gradual
local f2 = 0.006 --hills
local f3 = 0.03 --bumpy

local no, no2, no3 = random()*100, random()*100, random()*100

local x, y, z = 200, 1, 200

local waito = 0

for i = 1, x do
	for j = 1, y do
		for k = 1, z do
			local a = noise(i*f+no, (i+k)/2*f+no, k*f+no) --gradual
			local b = noise(i*f2+no2, (i)*f2+no2, k*f2+no2) --hills
			local c = noise(i*f3+no3, (k)*f3+no3, k*f3+no3) --bumpy
			local e = (b+c)/2
			local h = j
			local m = "Dark green"
			local s = 4
			--[[if math.abs(a) < 0.25 then
				if e > 0 then --islands
					h = j+abs(b+c)*20
					s = abs(b)*160
					m = "Reddish brown"
					if e < 0.08 then
						m = "Dark stone grey"
						h = j+abs(b+c)*20
					end
				end
			else
				if e > 0 then
					h = j+e*20
					s = 4
					m = "Bright green"
				end
			end]]
			
			if e > 0 then
				m = "Brown"
				h = j+abs(b+c)*20
				s = j+abs(b+c)*80
			else
				if b+c < -0.5 then
					m = "Dark stone grey"
					h = j+abs(e)*20
					s = j+abs(e)*40
				end
			end
			
			draw(i, h+a*0, k, m, s)
			if waito > 2048 then waito = 0 print(wait()) end
			waito = waito + 1
		end
	end
end

print("t = "..t)

--go around, checking the neighbors of certain cells to see if they need to be deleted.
--if a cell isn't surrounded by down-diagonals (diagonal and down), then maybe you can remove the part. Also, if it isn't surrounded by down-adjacents

--terrain:FillBlock(CN(x*2, 0, z*2), V3(x*4, 4, z*4), "Water")

--have the more spikey noise affect more and more as the slower noise gets further away from 0?
