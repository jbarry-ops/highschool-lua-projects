--[[

"Key Terrain"

Terrain Properties:
	Region3int16 MaxExtents
	Color3 WaterColor
	float WaterReflectance
	float WaterTransparency
	float WaterWaveSize
	float WaterWaveSpeed

-- random:NextNumber(min, max)
-- random:NextInteger(min, max)

-- local terrain = Workspace.Terrain
-- terrain:Clear()
-- terrain:FillBlock(CN(), V3(sizeX*4, 4, sizeZ*4), "Water")

-- terrain:CellCenterToWorld --(x, y, z)
-- terrain:CellCornerToWorld --(x, y, z)
-- terrain:WorldToCell -- (V3 position)
-- terrain:WorldToCellPreferEmpty -- (V3 position)
-- terrain:WorldToCellPreferSolid -- (V3 position)

-- terrain:CopyRegion -- (Region3int16)
-- terrain:PasteRegion -- (TerrainRegion region, Vector3int16 corner, bool pasteEmpyCells)

-- terrain:FillBall -- (V3 center, float radius, material)
-- terrain:FillBlock -- (CN cframe, V3 size, material)
-- terrain:FillRegion -- (Region3 region, float resolution, material)

-- terrain:SetMaterialColor -- (material, C3 value)

-- terrain:ReadVoxels -- (Region3 region, float resolution)
-- terrain:WriteVoxels -- (Region3 region, float resolution, array3D materials, array3D occupancy)

local random = Random.new(t)
random:NextInteger(min, max)
random:NextNumber(min = 0, max = 1)

James's optimization note: (x+y-z)*(x+y-z) is slightly faster than (x+y-z)^2, x*x is faster than x^2

]]

local t = tick()
local V3, CN, BN = Vector3.new, CFrame.new, BrickColor.new
local noise, floor, ceil = math.noise, math.floor, math.ceil

--[[**************************************************************************************************************************]]
--[[**************************************************************************************************************************]]

local sizeX, sizeZ = 144, 233

local islandCount = 1
local islandSize = 50

--[[**************************************************************************************************************************]]
--[[**************************************************************************************************************************]]

local terrain = Workspace.Terrain

local function new(n)
	terrain:Clear()
	local map, islands = {}, {}
	for x = 1, sizeX do local mapX = {} for z = 1, sizeZ do mapX[z] = {0} end map[x] = mapX end
	terrain:FillBlock(CN(), V3(sizeX*4, 4, sizeZ*4), "Water")
	
	local function draw(x, z)
		if x < -sizeX/2 or x > sizeX/2 or z < -sizeZ/2 or z > sizeZ/2 then return end
		terrain:FillBlock(CN(x*4, 0, z*4), V3(4, 4, 4), "Grass")
	end
	
	local function island(radius, x0, z0)
		--draw outline of island, then fill it
		--Brennham's circle rasterization algorithm
		local x = radius-1
		local z = 0
		local dx = 1
		local dz = 1
		local err = dx-(radius*2)
		local width = sizeX
		local height = sizeY
		while (x >= z) do
			draw(x+x0, z+z0)
			draw(z+x0, x+z0)
			draw(x0-x, z+z0)
			draw(x0-z, x+z0)
			draw(x0-x, z0-z)
			draw(x0-z, z0-x)
			draw(x+x0, z0-z)
			draw(z+x0, z0-x)
			if err <= 0 then
				z = z+1
				err = err+dz
				dz = dz+2
			end
			if err > 0 then
				x = x-1
				dx = dx+2
				err = err+(-radius*2)+dx
			end
		end
	end
	
	for i = 1, n do
		print("i = "..i)
		local x, y = math.random(1, 144), math.random(1, 233)
		for m = 1, islandSize do
			island(m, x, y)
		end
	end
	
	return map, islands
end

local map, islands = new(1)

print("t = "..t)