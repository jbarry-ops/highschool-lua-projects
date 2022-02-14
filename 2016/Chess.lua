--[[
	Chess Game:
		Inspired by: samfun123, Vaeb
]]

diamond_mesh = "rbxassetid://9756362"
ring_mesh = "rbxassetid://3270017"

local V3 = Vector3.new
local CN = CFrame.new
local C3 = Color3.new
local BN = BrickColor.new
local U2 = UDim2.new
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
		set(newInstance){sz = V3(1, 1, 1), mt = "SmoothPlastic", ts = 0, bs = 0, Locked = true, an = true}
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
function recurse(object, f)
	local descendants = {}
	local function addDescendants(obj)
		for _, descendant in pairs(obj:GetChildren()) do
			table.insert(descendants, descendant)
			if f then
				f(descendant)
			end
			addDescendants(descendant)
		end
	end
	addDescendants(object)
	return descendants
end
function recurse2(obj, f)
	if f then f(obj) end
	for i, v in ipairs(obj:GetChildren()) do
		recurse2(v)
	end
end

function getMass(model)
	local mass = 0
	recurse(model, function(obj)
		if obj:IsA("BasePart") then
			mass = mass+obj:GetMass()
		end
	end)
	return mass
end

--stravant and AntiBoomz0r
function quaternionFromCFrame(cf)
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
function quaternionToCFrame(px, py, pz, x, y, z, w)
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
function quaternionSlerp(a, b, t)
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
function slerp(a, b, t)
	local qa = {quaternionFromCFrame(a)}
	local qb = {quaternionFromCFrame(b)}
	local ax, ay, az = a.x, a.y, a.z
	local bx, by, bz = b.x, b.y, b.z
	local _t = 1-t
	return quaternionToCFrame(_t*ax+t*bx, _t*ay+t*by, _t*az+t*bz, quaternionSlerp(qa, qb, t))
end
function lerp(a, b, d)
	return a+(b-a)*d
end

defaultPartAnchored = true
defaultPartCFrame = CN()
defaultPartCollision = true
lastPart = nil

function part(parent, size, brickColor, material, transparency)
	local newPart = new'Part'{pt = parent, sz = size or V3(1, 1, 1), bc = BN(brickColor or "Black"), mt = material or "SmoothPlastic", tr = transparency or 0, cf = defaultPartCFrame, cc = defaultPartCollision, an = defaultPartAnchored}
	lastPart = newPart
	return newPart
end
function weld(parent, part0, part1, c0, c1)
	return new'Motor6D'{pt = parent, p0 = part0, p1 = part1, C0 = c0, C1 = c1, nm = "weld"}
end
function block(parent, scale)
	return new'BlockMesh'{pt = parent, sc = scale or V3(1, 1, 1), nm = "mesh"}
end
function cylinder(parent, scale)
	return new'CylinderMesh'{pt = parent, sc = scale or V3(1, 1, 1), nm = "mesh"}
end
function mesh(parent, scale, meshType, meshId)
	return new'SpecialMesh'{pt = parent, sc = scale or V3(1, 1, 1), MeshType = meshType or "Wedge", MeshId = meshId or "", nm = "mesh"}
end


--things

players = {"ask4kingbily", "ask4kingbily"} --for later if you want bug-house, whatevs.
colors = {"White", "Black"} --Bright orange, Black
selectionColor = "Bright orange"
pieceMaterial = "SmoothPlastic"
boardMaterial = "SmoothPlastic"
selectionMaterial = "SmoothPlastic"

board = {}
pieces = {{}, {}}

winner = nil

turn = 1
selected = nil

offset = CN(0, 7, 50)
squareWidth = 5 --5
squareHeight = 1 --1
dimensions = {8, 8}

pieceTypes = {
	king = {
		abbreviation = "K",
		movement = {{0, 1}},
		allDirections = true,
		hasFileMovement = false
	},
	
	queen = {
		abbreviation = "Q",
		movement = {{0, 1}, {1, 1}},
		allDirections = true,
		hasFileMovement = true
	},
	
	rook = {
		abbreviation = "R",
		movement = {{0, 1}},
		allDirections = true,
		hasFileMovement = true
	},
	
	bishop = {
		abbreviation = "B",
		movement = {{1, 1}},
		allDirections = true,
		hasFileMovement = true
	},
	
	knight = {
		abbreviation = "N",
		movement = {{1, 2}, {-1, 2}},
		allDirections = true,
		hasFileMovement = false
	},
	
	pawn = {
		abbreviation = "",
		movement = {{0, 1}},
		allDirections = false,
		hasFileMovement = false
	}
}

function worldToGrid(pos)
	local relative = CN(pos)*offset:inverse()*CN(V3(dimensions[1]/2, 0, dimensions[2]/2)*squareWidth)
	return {round(relative.x/squareWidth), dimensions[2]-round(relative.z/squareWidth)}
end

function gridToWorld(cell)
	return offset*CN(V3(cell[1]-dimensions[1]/2, 0, -cell[2]+dimensions[2]/2)*squareWidth)
end



function makePiece(pieceType, cell, pieceSide)
	local pieceModel = new'Model'{nm = pieceType}
	local pieceCFrame = gridToWorld(cell)*CN(0, squareHeight/2+0.05*squareWidth, 0)
	
	defaultPartAnchored = false
	defaultPartCFrame = pieceCFrame
	defaultPartCollision = true
	
	local base = part(pieceModel, V3(0.9, 0.1, 0.9)*squareWidth, colors[pieceSide], pieceMaterial)						base.Name = "Base"
		cylinder(base)
		
	local base2 = part(pieceModel, V3(0.8, 0.05, 0.8)*squareWidth, colors[pieceSide], pieceMaterial)					base2.Name = "Base Decor"
		cylinder(base2)
		weld(base2, base, base2, CN(0, 0.075*squareWidth, 0))
	
	if pieceType == "Pawn" then																					--Pawn
		local body = part(pieceModel, V3(0.5, 0.7, 0.5)*squareWidth, colors[pieceSide], pieceMaterial)					body.Name = "Body"
			cylinder(body)
			weld(body, base, body, CN(0, 0.4*squareWidth, 0))
		local head = part(pieceModel, V3(0.5, 0.5, 0.5)*squareWidth, colors[pieceSide], pieceMaterial) 					head.Name = "Head"
			mesh(head, V3(1, 1, 1), "Sphere")
			weld(head, body, head, CN(0, 0.35*squareWidth, 0))
		for a = 1, 2 do
			local bodySide = part(pieceModel, V3(0.55, 0.7, 0.1)*squareWidth, colors[pieceSide], pieceMaterial)			bodySide.Name = "Body Side"
				weld(bodySide, body, bodySide, CA(0, a*90, 0))
			local headSide = part(pieceModel, V3(0.55, 0.7, 0.1)*squareWidth, colors[pieceSide], pieceMaterial)			headSide.Name = "Head Side Decor"
				cylinder(headSide)
				weld(headSide, head, headSide, CA(0, a*90, 90))
			local headSide = part(pieceModel, V3(0.7, 0.05, 0.7)*squareWidth, colors[pieceSide], pieceMaterial)			headSide.Name = "Head Side Decor"
				cylinder(headSide)
				weld(headSide, head, headSide, CA(90, 0, a*90))
		end
	elseif pieceType == "Queen" then																			--Queen
		local body = part(pieceModel, V3(0.6, 0.9, 0.6)*squareWidth, colors[pieceSide], pieceMaterial)					body.Name = "Body"
			body.Name = "Body"
			cylinder(body)
			weld(body, base, body, CN(0, 0.5*squareWidth, 0))
	elseif pieceType == "King" then																				--King
		local body = part(pieceModel, V3(0.6, 0.9, 0.6)*squareWidth, colors[pieceSide], pieceMaterial)					body.Name = "Body"
			body.Name = "Body"
			cylinder(body)
			weld(body, base, body, CN(0, 0.5*squareWidth, 0))
	elseif pieceType == "Knight" then																			--Knight
		
	elseif pieceType == "Bishop" then																			--Bishop
		
	elseif pieceType == "Rook" then																				--Rook
		local body = part(pieceModel, V3(0.7, 0.7, 0.7)*squareWidth, colors[pieceSide], pieceMaterial)					body.Name = "Body"
			body.Name = "Body"
			cylinder(body)
			weld(body, base, body, CN(0, 0.4*squareWidth, 0))
		local head = part(pieceModel, V3(0.8, 0.1, 0.8)*squareWidth, colors[pieceSide], pieceMaterial) 					head.Name = "Head"
			cylinder(head)
			weld(head, body, head, CN(0, 0.4*squareWidth, 0))
		for t = 1, 7 do
			local rampart = part(pieceModel, V3(0.1, 0.4, 0.1)*squareWidth, colors[pieceSide], pieceMaterial)			rampart.Name = "Rampart"
				weld(rampart, head, rampart, CA(0, t*360/7, 0)*CN(0, 0.1*squareWidth, 0.35*squareWidth))
			local rampartTop = part(pieceModel, V3(0.1, 0.1, 0.1)*squareWidth, colors[pieceSide], pieceMaterial)		rampartTop.Name = "Rampart Top"
				mesh(rampartTop, V3(0.12, 0.12, 0.12)*squareWidth, "FileMesh", diamond_mesh)
				weld(rampartTop, rampart, rampartTop, CA(0, 45, 0)*CN(0, 0.2*squareWidth, 0))
			local rampartBottom = part(pieceModel, V3(0.1, 0.2, 0.1)*squareWidth, colors[pieceSide], pieceMaterial)		rampartBottom.Name = "Rampart Bottom"
				mesh(rampartBottom, V3(1, 1, 1))
				weld(rampartBottom, rampart, rampartBottom, CN(0, -0.3*squareWidth, 0)*CA(180, 0, 0))
		end
		local headTop = part(pieceModel, V3(0.5, 0.1, 0.5)*squareWidth, colors[pieceSide], pieceMaterial) 				headTop.Name = "Head Top"
			cylinder(headTop)
			weld(headTop, head, headTop, CN(0, 0.1*squareWidth, 0))
		local topPoint = part(pieceModel, V3(0.1, 0.5, 0.1)*squareWidth, colors[pieceSide], pieceMaterial) 				topPoint.Name = "Top Point"
			mesh(topPoint, V3(0.2, 0.4, 0.2)*squareWidth, "FileMesh", diamond_mesh)
			weld(topPoint, headTop, topPoint, CN(0, 0.05*squareWidth, 0))
	end
	
	--local gui = new'BillboardGui'{pt = base, sz = U2(1, 0, 1, 0), Adornee = base, StudsOffset = V3(0, 0, 0), AlwaysOnTop = true}
	--local label = new'TextLabel'{pt = gui, sz = U2(1, 0, 1, 0), bgt = 1, TextColor3 = C3(255, 0, 0), Text = pieceType}
	
	local pieceData = {
		name = pieceType,
		pos = cell,
		side = pieceSide,
		color = colors[pieceSide],
		hasMoved = false,
		killCount = 0,
		model = pieceModel
	}
	
	table.insert(pieces[pieceSide], pieceData)
	return pieceData
end

function getPiece(pieceModel)
	for s, side in pairs(pieces) do
		for p, piece in pairs(side) do
			if piece.model == pieceModel then
				return piece, p, s
			end
		end
	end
end

function canMove(piece, cell)
	--can move to cell
end

--Do the stuff!

for _, obj in pairs(Workspace:GetChildren()) do
	if obj.Name == "Ask4kingbily's Chess Set" then
		obj:Destroy()
	end
end

chess = new'Model'{
	pt = Workspace,
	nm = "Ask4kingbily's Chess Set"
}

if #players == 2 then
	--traditional chess
	
	--generate the board
	
	defaultPartAnchored = true
	defaultPartCFrame = gridToWorld({4, 4})
	defaultPartCollision = true
	
	local chessBoard = new'Model'{pt = chess, nm = "Chess Board"}
	local chessPieces = new'Model'{pt = chess, nm = "Chess Pieces"}
	
	for z = 1, dimensions[2] do
		for x = 1, dimensions[1] do
			local square = part(chessBoard, V3(squareWidth, squareHeight, squareWidth), colors[(x+z+1)%2+1], boardMaterial)
			square.CFrame = gridToWorld({x, z})
			
			--local gui = new'BillboardGui'{pt = square, sz = U2(1, 0, 1, 0), Adornee = square, StudsOffset = V3(0, 0, 0), AlwaysOnTop = true}
			--local label = new'TextLabel'{pt = gui, sz = U2(1, 0, 1, 0), bgt = 1, TextColor3 = BN(colors[(x+z)%2+1]).Color, Text = string.char(96+x)..z, FontSize = "Size18"}
		end
	end
	
	--generate the pieces for each player
	for s = 0, 1 do
		for p = 1, 8 do
			local pawn = makePiece("Pawn", {p, 2+s*5}, s+1)
		end
		local queen = makePiece("Queen", {4, 1+s*7}, s+1)
		local king = makePiece("King", {5, 1+s*7}, s+1)
		for m = 0, 1 do
			local rook = makePiece("Rook", {1+m*7, 1+s*7}, s+1)
			local knight = makePiece("Knight", {2+m*5, 1+s*7}, s+1)
			local bishop = makePiece("Bishop", {3+m*3, 1+s*7}, s+1)
		end
		
		for p, piece in pairs(pieces[s+1]) do
			piece.model.Parent = chessPieces
		end
	end
	
	local turnsTaken = 0
	
	while not winner do
		
		print("turns taken: "..turnsTaken)
	
		local selected = nil
		local selectedData = nil
	
		for _, piece in pairs(pieces[turn]) do
			recurse(piece.model, function(obj)
				if obj:IsA("BasePart") then
					local clickDetector = new'ClickDetector'{pt = obj, {MouseClick = function(player)
						if player.Name ~= players[turn] then return end
						if selected then return end
						print(player.Name.." selected a "..piece.model.Name)
						recurse(chess, function(obj)
							if obj:IsA("ClickDetector") then
								obj:Destroy()
							end
						end)
						selected = piece.model
					end}}
				end
			end)
		end
		
		repeat
			wait()
		until selected
		
		local selectedData = getPiece(selected)
		
		local selectionOutline = new'Model'{pt = chess, nm = "Chess Piece Selection"}
		recurse(selected, function(obj)
			if obj:IsA("BasePart") then
				local outlinePart = obj:Clone()
				outlinePart.Size = obj.Size+V3(0.2, 0.2, 0.2)
				outlinePart.Transparency = 0.5
				outlinePart.Material = selectionMaterial
				outlinePart.BrickColor = BN(selectionColor)
				outlinePart.CanCollide = false
				weld(outlinePart, obj, outlinePart)
				outlinePart.Parent = selectionOutline
			end
		end)
		
		recurse(chessBoard, function(obj)
			if obj:IsA("BasePart") then
				local clickDetector = new'ClickDetector'{pt = obj, {MouseClick = function(player)
					if player.Name ~= players[turn] then return end
					recurse(chess, function(obj)
						if obj:IsA("ClickDetector") then
							obj:Destroy()
						end
					end)
					selected:MoveTo(gridToWorld(worldToGrid(obj.Position)).p)
					selectionOutline:Destroy()
					selected = nil
					selectedData = nil
				end}}
			end
		end)
		
		repeat
			wait()
		until not selected and not selectedData
		
		turnsTaken = turnsTaken+1
		
		if turn == 1 then turn = 2 else turn = 1 end
		
	end
end
