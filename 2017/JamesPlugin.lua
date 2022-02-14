--[[--------------------------------------------------
Here be brief documentation place: --{{{

All
	Esc - Return to normal mode

Normal Mode
	M - Map Setups Mode
	G - Parts Manipulation Mode

M - Map Setups Mode
	


--}}}
----------------------------------------------------]]

--[[--------------------------------------------------
PreSetups--{{{
----------------------------------------------------]]

local V2, V3, CF, CA, C3, UD, R3 = Vector2.new, Vector3.new, CFrame.new, CFrame.Angles, Color3.new, UDim2.new, Region3.new
local mouse

--[[--------------------Defaults-------------------------{{{
------------------------------------------------------]]
Iname = {"BasePart","GuiObject","PointLight"}
IDefaults = {
	{
	Size = V3(1, 1, 1)
	,Anchored		= true
	,Material		= "SmoothPlastic"
	,TopSurface		= 0
	,BottomSurface	= 0
	,Locked			= true
	},{	
	Size				= UD(1, 0, 1, 0)
	,BorderSizePixel	= 0
	,BackgroundColor3	= C3(.5,.5,.5)
	},{
	Range		= 2
	,Color		= C3(1,1,1)
	,Brightness	= 10
	}
}--}}}
--[[--------------------New-----------------------------{{{
------------------------------------------------------]]
function new(instanceType)
	return function(...) -- [plural] table of Property = Value.
		local newInstance = Instance.new(instanceType)
		-- Defaults
		for i,v in ipairs(Iname) do 
			if newInstance:IsA(v) then
				for j,w in ipairs(IDefaults[i]) do
					pcall(function() newInstance[j] = w end)
				end
			end
		end
		-- Specifieds
		local cf = nil
		for i,properties in ipairs({...}) do
			for property, value in pairs(properties) do
				if typeof(value) == "Instance" and typeof(property) ~= "string" then
					pcall(function () value.Parent = newInstance end)
				else
					newInstance[property] = value
				end
			end
			if properties.CFrame then cf = properties.CFrame end 
		end
		if cf then newInstance.CFrame = cf end
		return newInstance
	end
end--}}}

--mathin'
local mr, mn, mrd = math.random, math.noise, math.rad
local mm,mx = math.min, math.max
local mt, ms, mc = math.tan, math.sin, math.cos
local mat,mas,mac = math.atan,math.asin,math.acos
local tau = 2*math.pi

--stringin'
local ss = string.sub
local sl = string.len
local sb = string.byte
local sc = string.char
local gs = string.gsub

--tablin'
local ti = table.insert
local tr = table.remove
local tp = pack
local tu = function(a)--{{{
	if type(a) == "table" then
		return unpack(a)
	else
		return a
	end
end--}}}
local tu2 = function(a)--{{{
	if type(a) == table then
		for i,v in ipairs(a) do
			if type(v) == "function" or (type(a) == "table" and a[L]) then
			a[i] = v()
			end
		end
		return unpack(a)
	else
		return a
	end
end--}}}
local copytable = function(tbl)--{{{
	local tbl = {}
	for i,v in ipairs(tbl) do
		if type(v) == "table" then
			table.insert(tbl,copytable(nw))
		else
			table.insert(tbl,v)
		end
	end
	return tbl
end--}}}
local rkof = function(tbl)--{{{
		local b = 1
		for i,v in pairs(tbl) do b = b+1 end
		local a,c = mr(1,b),1 -- stupidly inefficient
		for i,v in pairs(tbl) do
			c = c+1
			if c == a then return i end
		end
end--}}}
local rof = function(tbl)--{{{
		local b = 1
		for i,v in pairs(tbl) do b = b+1 end
		local a,c = mr(1,b),1 -- stupidly inefficient
		for i,v in pairs(tbl) do
			c = c+1
			if c == a then return v end
		end
end--}}}

function S(t) return game:getService("Selection"):Set(t) end
function G() return game:getService("Selection"):Get() end

--}}}
--[[--------------------------------------------------
Setups--{{{
----------------------------------------------------]]

-->> Early setups
local cam			= workspace:findFirstChild("Camera") or workspace:findFirstChild("Instance") --> not garunteed to work
local mouse			= plugin:GetMouse()
local inputService	= game:getService("UserInputService")

WNum = 1 --> To let you Ctrl-Z things, Put a "W()" after [and before =/?] every undo-able change
W = function () WNum = WNum + 1 game:getService("ChangeHistoryService"):SetWaypoint("RoVim"..WNum) end

-- Setup Totally Unnecessary Toolbar/plugin button--{{{
local toolbar = plugin:CreateToolbar("Doot")
local button = toolbar:CreateButton( "Button", "doot", "")
button.Click:connect(function() print("Um... It's actually always active") --[[ tutorialBits() ]] end)
plugin.Deactivation:connect(function() print("Still always active") end)
--}}}

local selectedThings = G() -- should be nothing at this point.

--<> Assets--{{{
asset = "http://roblox.com/asset/?id="
images = {
	gear = "404566260",
	normal = "130576054",
	redshine = "299117585",
	blueshine = "299117631",
	fireflies = "135915907",
	plus = "407246555", 
	x = "223606812"
}--}}}

-->> State setups--{{{

Mode = "Normal"
downKeys = {}

registers = {} 
registerOffs = {} --> offsets for objs in each register
	-- Yank Selection to register with [when you've selected whatev's] "t" (dvk "y"), foll by register
	-- Put registers with "r" (dvk "p") followed by register

--> when coming back from a key-capturing (to avoid pressing Backspace / delete and deleting selected parts)
fakeSelection = {}

--> For part drawing
makeType = nil
local lastGrowing = nil
local growType1 = nil
local growCirc = nil
local lastGrowPos = nil

--> For palettes
paletteNames = {"", "", ""}
paletteHandles = {PalYank, PalYank, PalYank}
paletteSaves = {{Color = C3(1,1,1), Material = "Neon", Transparency = .5}, {Color = C3(1,1,1), Material = "Neon", Transparency = .5}, {Color = C3(1,1,1), Material = "Neon", Transparency = .5}}
local saveThings = {"Transparency", "Material", "Color"} --[] + Child ParticleEmitter / bbgui, surfgui, decals, textures...

--> Other
local allHints = {}
myChat = ""

--}}}
-->> Gui Setups--{{{

MainSG = new"ScreenGui"{
	Parent = game:getService("StarterGui"),
	Archivable = false,
	Name = "RoVim"}
local modeTxt = new"TextLabel"{ -->> Mode text --{{{
	Parent = MainSG,
	Name = "Mode",
	Size = UD(1,0,0,50),
	Position = UD(0,0,0,0),
	TextXAlignment = 0,
	TextColor3 = C3(0,1,1),
	TextStrokeColor3 = C3(0,0,0),
	TextStrokeTransparency = 0,
	BackgroundTransparency = .8,
	BackgroundColor3 = C3(0,0,0),
	Text = "Normal"} --}}}
local modeImg = new"ImageLabel"{ -->> image --{{{
	Parent = MainSG,
	Name = "ModeL2",
	Size = UD(0,75,0,75),
	BackgroundTransparency = 1,
	Position = UD(0,0.5,0,50),
	Image = asset..images.normal}--}}}
local announce = new"TextLabel"{ -->> hint feedback text label --{{{
	Parent = MainSG,
	Name = "Announce",
	Font = "Highway",
	FontSize = "Size28",
	TextColor3 = C3(1,1,1),
	Size = UD(1,0,0,50),
	BackgroundTransparency = 1,
	Position = UD(0,0,0,0)
	}--}}}

--}}}
-->> setting up model(s) --{{{

while workspace:findFirstChild("PluginMoodle") do --> Rename any ploogins to "OldModel"..Number  --{{{
	local n = 0
	local a
	repeat
		n=n+1
		a = workspace:findFirstChild("OldModel"..n)
		if a and #a:getChildren() < 1 then a:Destroy() end --> destroy the empty ones
	until not a
	workspace.PluginMoodle.Name = "OldModel"..n
end--}}}

MainMdl = new"Model"{
	Parent = workspace,
	Name = "PluginMoodle"}

--}}}
-->> Template Objs--{{{

wipTemplate = workspace:findFirstChild("TempTemplate") or new"Part"{
	Parent		= nil, 
	Anchored	= true, 
	Transparency= .5, 
	CanCollide	= false, 
	Size		= V3(1,1,1), 
	CFrame		= CF(),
		new"Decal"{
		Face	= "Front", 
		Texture	= "http://www.roblox.com/asset/?id=548051629"}
	}

local markTypes = {
	new"Part"{Anchored = true,Transparency = .25,CanCollide = false,Size = V3(.5,.5,.5), Material = "Neon", Color = C3(1,0,0)},
	new"Part"{Anchored = true,Transparency = .25,CanCollide = false,Size = V3(.5,.5,.5), Material = "Neon", Color = C3(1,1,0)},
	new"Part"{Anchored = true,Transparency = .25,CanCollide = false,Size = V3(.5,.5,.5), Material = "Neon", Color = C3(0,1,0)},
	new"Part"{Anchored = true,Transparency = .25,CanCollide = false,Size = V3(.5,.5,.5), Material = "Neon", Color = C3(0,1,1)},
	new"Part"{Anchored = true,Transparency = .25,CanCollide = false,Size = V3(.5,.5,.5), Material = "Neon", Color = C3(0,0,1)}
}

--}}}
-->> Late setups--{{{
	mouse.TargetFilter = MainMdl
--}}}

--}}}
--[[--------------------------------------------------
Basic functions--{{{
----------------------------------------------------]]

-->> Super Generic

function rdo(a,fn) --> aka recurseDo--{{{
	for i,v in ipairs(a:getChildren()) do
		fn(v)
		if #v:getChildren() > 0 then
			rdo(v,fn)
		end
	end
end --}}}
function recurseForParts(m)--{{{
	local ps = {}
	local mods = {}
	if m.className == "Part" then
		table.insert(ps,m)
	end
	for i,v in ipairs(m:getChildren()) do
		if v.className == "Part" then --and v:GetMass() > min then
			table.insert(ps,v)
		elseif v.className == "Model" then
			local temp = recurseForParts(v)
			for i2,v2 in ipairs(temp) do
				table.insert(ps,v2)
			end
		end
	end
	return ps, mods -- If your workspaces keeps a sane structure, this should work excellently
end--}}}
function deb(a,b)--{{{
	game:getService("Debris"):AddItem(a,b)
end--}}}
function rc(start,dir) --> Raycast --{{{
	local ray = Ray.new(start+dir.unit, dir)
	return workspace:findPartOnRay(ray) -- part, endPoint, normal
end--}}}
local function rcat() --> "Regular Cast At (mouseplace)" normal CFrame --{{{
	local thing, point, norm = rc(mouse.Origin.p, (mouse.Hit.p-mouse.Origin.p)*100)
	return CF(point, point+norm)
end--}}}

-->> Mathsy Jank

function dot(a,b)--{{{
	return a.x*b.x+a.y*b.y+a.z*b.z
end--}}}
function angleBetween(a,b)--{{{
	return math.acos(dot(a,b)/(a.magnitude*b.magnitude))
end--}}}
function sphereSampleMark(maxNum, InPart, sphereSize, par) -- {InParts}, markTypes, markSizes) -- l8r, allow to specify Pdistributions for marks--{{{
	local mdlet = Instance.new("Model", par or workspace)
	mdlet.Name = "markeys"
	print("med?")
	local marks = {}
	local count = 0 -- counts num times checked for part @ a spot and failzed
	local done = true
	local thispos = nil
	local forWedges = InPart.Size.Y/InPart.Size.Z
	while #marks < maxNum and count < 500 do
		done = true
		thispos = nil
		repeat 
			done = true
			local offpos = V3(mr()-.5,mr()-.5,mr()-.5)*InPart.Size
			thispos = (InPart.CFrame*CF(offpos)).p
			if InPart:IsA"WedgePart" and (offpos.Y+InPart.Size.Y/2)/(offpos.Z+InPart.Size.Z/2) > forWedges then
				done = false
				count = count+1
			else
				for i,v in ipairs(marks) do
					if (v.Position-thispos).magnitude < sphereSize then
						done = false
						count = count+1
						break
					end
				end
			end
		until done or count > 500
		if thispos then 
			local mrk = markTypes[1]:clone() -- change whenever
			mrk.CFrame = CF(thispos)
			mrk.Parent = mdlet
			table.insert(marks, mrk) 
		end
		wait() -- umm. because for safety. breeh
	end
	return marks
end--}}}
local computedFactorials = {}
function Fact(n) --Factorial--{{{
	if computedFactorials[n] then
		return computedFactorials[n]
	end
    if n == 0 then
        return 1
    else
		computedFactorials[n] = n * Fact(n - 1)
        return computedFactorials[n]
    end
end--}}}
local computedCoeffs = {}
function binomCoeff(n, i)--{{{
	if coeffs[n] then 
		if coeffs[n][i] then
			return coeffs[n][i]
		else
			computedCoeffs[n][i] = Fact(n)/(Fact(i)*Fact(n-i))
		end
	else
		computedCoeffs[n] = {}
		computedCoeffs[n][i] = Fact(n)/(Fact(i)*Fact(n-i))
	end
end--}}}

-->> Rando Bezier stoof

local function foo2(n,ptlist) -- The recursive form of the Beziér curve... n b/w 0 and 1--{{{
	if #ptlist == 0 then return print("fail") end --> U fail. 
	if #ptlist > 2 then 
	   local ptlist2 = {}
	   for i = 1, #ptlist-1 do
		   table.insert(ptlist2,ptlist[i]*(1-n)+ptlist[i+1]*n)
	   end
	   return foo2(n,ptlist2)
	else
	   return (ptlist[1]*(1-n)+ptlist[2]*n)
	end
end--}}}
local function foo(n,ptlist) -- The recursive form of the Beziér curve... n b/w 0 and 1--{{{
	if #ptlist < 1 then return print("fail") end --> U fail. 
	if #ptlist > 2 then 
	   local ptlist2 = {}
	   for i = 1, #ptlist-1 do
		   table.insert(ptlist2,ptlist[i].Position*(1-n)+ptlist[i+1].Position*n)
	   end
	   return foo2(n,ptlist2)
	elseif ptlist[2] then 
	   return (ptlist[1].Position*(1-n)+ptlist[2].Position*n)
	else
	   return (ptlist[1].Position)
	end
end--}}}
function Bezier(points,t)  --> t between 0 and 1 --{{{
	local x, y, z = 0, 0, 0
	local n = #points-1
	for i = 0, #points-1 do
		local p = points[i+1]
		local factor = binomCoeff(n,i) * (t^i)*(1-t)^(n-i)
		x = x + (factor*p.X)
		y = y + (factor*p.Y)
		z = z + (factor*p.Z)
	end
	return Vector3.new(x,y,z)
end--}}}
function RedrawBezier(pointList, partList, detail) --{{{
	local mdl
	if partList[1] then mdl = partList[1].Parent end
	if detail < #partList then
		for i=1,detail-#partList do
			local pln = #partList
			partList[pln]:Destroy()
			partList[pln] = nil
		end
	elseif detail > #partList then
		for i=1,#partList-detail do
			local p2 = partList[1]:clone()
			pt.Name = ""..#partList+i
			p2.Parent = partList[1].Parent
			partList[#partList+1] = p2
		end
	end
	--> 
	local dif = 1/detail
	local pp = pointList[1].Position
	for i = 1, detail do
		local plc = foo(dif*i, pointList) -- alt: foo(dif*i,pointList) 
		local a = (pp-plc).magnitude
		partList[i].Size = V3(2,2,a)
		partList[i].CFrame = CF((plc+pp)/2, pp)
		pp = plc   
	end
end--}}}
function BezierParts(pointList, detail) --> returns mdl, partList--{{{
	local ptTbl = {}
	local dif = 1/detail
	local pp = pointList[1].Position
	for i = 1, detail do
		local pt = new"Part"{
		Parent = MainMdl,
		Name = ""..i,
		Anchored = true,
		Transparency = .5,
		CanCollide = false,
		Size = V3(1,1,1),
		CFrame = CF(0,0,0)}
		ptTbl[#ptTbl+1] = pt
	end
	RedrawBezier(pointList, ptTbl, detail)
	return ptTbl
end--}}}
function Bezier3pts(a,b,c,n,style,par)--{{{
	local a,b,c = a.p,b.p,c.p
	local tbl = {}
	local opts = {Parent = par, Color = C3(0,0,0), Size = V3(.1,.1,1), Position = V3(0,108,0), Material = "Plastic"}
	local lastpt = a
	local n = math.ceil(n)
	for i= 0, 1, 1/n do
		local t1 = a*(1-i) + b*i
		local t2 = b*(1-i) + c*i
		local thispt = t1*(1-i)+t2*i
		opts["CFrame"] = CF((lastpt+thispt)/2,thispt)
		opts.Size = V3(opts.Size.X, opts.Size.Y, (thispt-lastpt).magnitude)
		lastpt = thispt
		local pt = new"Part"(opts)
		set(pt,style)
		table.insert(tbl,pt)
	end
	return tbl
end--}}}
function moveBezier(a,b,c,n,parts)--{{{
	local ayy = parts[1].Parent
	local lastpt = a
	for iter,v in ipairs(parts) do
		v.Parent = nil
		local i = (iter-1)/n
		local t1 = a*(1-i) + b*i
		local t2 = b*(1-i) + c*i
		local thispt = t1*(1-i)+t2*i
		v.CFrame = CF((lastpt+thispt)/2,thispt)
		v.Size = V3(v.Size.X, v.Size.Y, (thispt-lastpt).magnitude)
		lastpt = thispt
		v.Parent = ayy
	end
end--}}}

-->> Making stuff

function Part(par,siz,cf,anch,col,trans)--{{{
	return new"Part"{Parent=par,Size=siz,Anchored=true,Color=col,Transparency=trans,Position=V3(0,1984,0),CFrame=cf}
end--}}}
function debugConnect(a,b)--{{{
	return Part(MainMdl, V3(1,1,(a-b).magnitude), CF((a+b)/2, b), true, C3(1,0,0), .5)
end --}}}

-->> Feedback functions

function isShiftDown()--{{{
	return inputService:IsKeyDown(304) or inputService:IsKeyDown(303)
end--}}}
function hint(txt,time)--{{{
	for i=#allHints,1,-1 do
		if allHints[i].Parent ~= nil then
			local v = allHints[i]
			v:TweenPosition(UD(.7,0,0.5,-20*i), "Out", "Quad", .3, true)
			allHints[i+1] = v
		end
	end
	local txt = new"TextLabel"{
		Parent = MainSG, 
		Archivable = false,
		Size = UD(.3,0,0,20), 
		Position = UD(.7,0,0.5,0), 
		BackgroundTransparency = 1,
		Text = txt,
		FontSize = "Size18",
		TextStrokeTransparency = 0,
		TextStrokeColor3 = C3(0,0,0),
		TextColor3 = C3(1,1,1)}
	allHints[1] = txt
	deb(txt, time or 2)
	return txt
end--}}}

-->> Tabley manip

function reverseTable(t1)--{{{
	local tmp = {}
	for i,v in pairs(t1) do
		tmp[v] = i
	end
	return tmp
end--}}}
function printTbl(a, e)--{{{
	local e = e or 0
	for i,v in pairs(a) do
		print(string.rep("\t",e)..tostring(i).." - "..tostring(v))
		if type(v) == "table" then
			printTbl(v,e+1)
		elseif type(v) == "userdata" then
			printAll(v)
		end
	end
end--}}}
function printAll(obj,k)--{{{
	local k = k or 0
	if type(obj) == "table" then printTbl(obj) return end
	for i,v in pairs(obj:getChildren()) do
		print(string.rep("\t",k).." - "..tostring(v))
		printAll(v,k+1)
	end
end--}}}
function sortByProp(property, tbl) --> sorted by lowest to highest--{{{
	-- bleg. jest an insertion sort this time methinks. Unless I think of a more fun way
	local sorted = {}
	if retIndecies == true then
		local sortInds = {}
		local max, min = 0,0 -- min is the index of last-checked-too-small value + 1
		for i,v in ipairs(tbl) do
			--
			while min < max do
				local this = math.floor((max+min)/2) -- bsikly binary insertion sortch thang.
				if v[property] < sorted[this][property] then
					max = this
				else 
					min = this + 1
				end
			end
			table.insert(sorted,min,v)
			table.insert(sortInds,min,i)
			min, max = 0, #sorted
		end
		return sorted, sortInds
	else
		local max, min = 0,0 -- min is the index of last-checked-too-small value + 1
		for i,v in ipairs(tbl) do
			--
			while min < max do
				local this = math.floor((max+min)/2) -- bsikly binary insertion sortch thang.
				if v[property] < sorted[this][property] then
					max = this
				else 
					min = this + 1
				end
			end
			table.insert(sorted,min,v)
			min, max = 0, #sorted
		end
		return sorted
	end
end--}}}

--}}}
--[[--------------------------------------------------
More interesting Funs--{{{
----------------------------------------------------]]

function getTriangleValues(a,b,c) -- MANY THANKS TO DOOGLEFOX for basic algo, made more efficient by bigbadbob234, assumes V3 points--{{{
	if (c-b).magnitude < (c-a).magnitude then return getTriangleValues(b,c,a) end
	if (c-b).magnitude < (b-a).magnitude then return getTriangleValues(c,a,b) end
	local D = b+(c-b).unit*((c-b).unit:Dot(a-b))
	local C, B = (D-a).unit, (b-c).unit
	local A = B:Cross(C)
	local S1 = V3(.2, (b-D).magnitude, (a-D).magnitude)--/1 -- width
	local S2 = V3(.2, (c-D).magnitude, (a-D).magnitude)--/1 -- width
	local C1 = CF(0,0,0,A.X,B.X,C.X,A.Y,B.Y,C.Y,A.Z,B.Z,C.Z)+(a+b)/2
	local C2 = CF(0,0,0,-A.X,-B.X,C.X,-A.Y,-B.Y,C.Y,-A.Z,-B.Z,C.Z)+(a+c)/2
	return C1, C2, S1, S2
end--}}}
function triangleForPoints(a,b,c)--{{{
	c1, c2, s1,s2 = getTriangleValues(a,b,c)
	local pt1 = new"WedgePart"{
		Parent = MainMdl, 
		Anchored = true, 
		Transparency = 0,
		Color = C3(0,.5,0),
		Material = "Plastic",
		Name = "A", 
		CanCollide = false, 
		Size = s1,
		CFrame = c1 }
	local pt2 = new"WedgePart"{
		Parent = MainMdl, 
		Anchored = true, 
		Material = "Plastic",
		Transparency = 0,
		Name = "B",
		Color = C3(0,.5,0),
		CanCollide = false, 
		Size = s2,
		CFrame = c2 }
	return pt1,pt2
end--}}}

function getRecursivePartsOffsets(pts, cfOff) --{{{ -- pts should be a table of cloned parts. Not going to clone in this function.
	local a,b = {}, {}
	--> a = {pts[n]-clone, {<--That part's sub-part-clones}, ...}, 
	--> b = {pts[n].offset-from-cfOff, {<--That part's sub-part.offsets-from-cfOff}, ...}
	for n,pt in pairs(pts) do -- ipairs would work if I didn't use this fn for the randize put
		if #pt:getChildren() > 0 then
			local curN = #a+1
			local c,d = getRecursivePartsOffsets(pt:getChildren(),cfOff) --> returns two tables: sub-parts, sub-part.Offs
			if pt:IsA"BasePart" then -- "pt" may refer to a model.
				a[curN] = pt
				b[curN] = cfOff:toObjectSpace(pt.CFrame)
			else
				a[curN] = pt
				b[curN] = nil -- It's not a BasePart, no CF needed
			end
			a[curN+1] = c
			b[curN+1] = d
		else
			local thng = #a+1
			if pt:IsA"BasePart" then
				a[thng] = pt
				b[thng] = cfOff:toObjectSpace(pt.CFrame)
			else
				a[thng] = pt
				b[thng] = nil -- It's not a BasePart, no CF needed
			end
		end
	end
	return a,b
end--}}}
function putRecursivePartsOffsets(pts, cfOffs, thisOff, putInto) --{{{ -- pts should be a table of cloned parts. Not going to clone in this function.
	local tmptbl = {}
	for n,pt in pairs(pts) do
		if type(pt) == "table" then
			print("# subt = "..#pt)
			local t2 = putRecursivePartsOffsets(pt, cfOffs[n], thisOff, pts[n-1]) 
			for i,v in pairs(t2) do tmptbl[#tmptbl+1] = v end
		else --
			pt.Parent = putInto
			tmptbl[#tmptbl+1] = pt
			if pt:IsA"BasePart" then
				pt.CFrame  = thisOff * cfOffs[n]
			end
		end
	end
	return tmptbl
end--}}}

local function pullToRegister(key) --> I think imma make this just capture selection and mousePos, put is gonna do the hard work --{{{
	local selecteds = game:getService("Selection"):Get()
	if key == "T" and #selecteds == 1 then 
		if makeType then makeType:Destroy() end -- Probs not nesc
		makeType = selecteds[1]:clone()
	end
	if #selecteds == 0 then 
		registers[key] = nil
		registerOffs[key] = nil
		hint("Cleared Register: "..tostring(key), 2)
	else
		local thing, point, norm = rc(mouse.Origin.p, (mouse.Hit.p-mouse.Origin.p)*100)
		registers[key] = selecteds
		registerOffs[key] = CF(mouse.Hit.p, mouse.Hit.p + norm)
		hint("Yanked selection to "..tostring(key), 2)
	end
end --}}}
local function putRegister(key)--{{{ 
	local toPutTable = registers[key]
	local thing, point, norm = rc(mouse.Origin.p, (mouse.Hit.p-mouse.Origin.p)*200) --> 200 studs from camera stops casting ray
	if toPutTable ~= nil then
		local ao = registerOffs[key]
		local selClones = {}
		for i,v in ipairs(toPutTable) do 
			selClones[#selClones+1] = v:clone() 
		end
		local a,b = getRecursivePartsOffsets(selClones, ao)
		local allThings = putRecursivePartsOffsets(a,b, CF(mouse.Hit.p, mouse.Hit.p+norm), toPutTable[1].Parent) -- s/tpt[1].Par/new"model" --> kinda hacky
		game:getService("Selection"):Set(allThings) -- super lame and hacky
	else
		hint("trying to put from "..key..", found "..tostring(toPutTable), 3).TextColor3 = C3(1,0,0)
	end
end--}}}

local function randizeReplaceFromRegister(key)--{{{ 
	local toPutTable = registers[key]
	local selectedThings = game:getService("Selection"):Get()
	local nextSelect = {}
	if toPutTable ~= nil then
		local ao = registerOffs[key]
		for i,v in ipairs(selectedThings) do
			if v:IsA"BasePart" then
				local n = math.random(1,#toPutTable)
				local selClone = toPutTable[n]:clone()
				local a,b = getRecursivePartsOffsets({selClone}, ao)
				local tmpish = putRecursivePartsOffsets(a,b, v.CFrame, toPutTable[n].Parent) --> kinda hacky
				for i,v in ipairs(tmpish) do
					nextSelect[#nextSelect+1] = v
				end
				print("i"..i)
			end
		end
		game:getService("Selection"):Set(nextSelect)
	else
		hint("trying to put from "..key..", found "..tostring(toPutTable), 3).TextColor3 = C3(1,0,0)
	end
end--}}}

function startDrawingCircle() --> Draw circlet | n-gon,centered @ mouse.hit.p --{{{
	lastGrowPos = mouse.Hit.p
	growCirc = {}
	local prt
	local n = tonumber(myChat) or 12 -- make n pts
	if #selectedThings > 0 then
		prt = selectedThings[1]:clone() -- mhm. why nawt
	else
		prt = makeType ~= nil and makeType:clone() or new"Part"{
		Anchored = true, 
		Transparency = 0, 
		CanCollide = false, 
		Size = V3(1,1,1)}
	end
	for i=1,n do
		local pt = prt:clone()
		pt.Parent = MainMdl
		pt.CFrame = CF(lastGrowPos)*CA(0,i*tau/n,0)
		table.insert(growCirc,pt)
	end
	game:getService("Selection"):Set(growCirc)
end --}}}

--}}}
--[[--------------------------------------------------
Moveits--{{{
----------------------------------------------------]]

keyCapture = nil -- can be defined as pretty much any function
editingDialog = nil

-->> KeyCapture dealios
function beginKeyCapture(fn)--{{{
	cam.CameraType = "Scriptable"
	myChat = ""
	keyCapture = fn
	fakeSelection = game:getService("Selection"):Get()
	modeTxt.BackgroundColor3 = C3(1,1,0)
	game:getService("Selection"):Set({})
end--}}}
function endKeyCapture() --{{{
	keyCapture = nil
	Mode = "Normal"
	modeImg.Image = asset..images.normal
	modeTxt.Text = "Normal"
	modeTxt.BackgroundColor3 = C3(0,0,0)
	cam.CameraType = "Fixed"
	game:getService("Selection"):Set(fakeSelection)
end--}}}
function surfCapture(key)--{{{
	if key == "Return" or key == "Escape" then
		if key == "Return" then 
			endKeyCapture()
			local selecteds = game:getService("Selection"):Get()
			for i,v in ipairs(selecteds) do
				if v:IsA"BasePart" then
				v.TopSurface = myChat
				v.BottomSurface = myChat
				v.LeftSurface = myChat
				v.RightSurface = myChat
				v.FrontSurface = myChat
				v.BackSurface = myChat
				end
			end
		end
	else
		local c=""
		if key == "Space" then c = " "
		elseif (key == "Backspace" or key == "Capslock") and string.len(myChat) >= 1 then myChat = string.sub(myChat, 1, string.len(myChat)-1)
		elseif string.len(key) == 1 then if not downKeys["LeftShift"] and not downKeys["RightShift"] then key = string.lower(key) end c = key
		elseif key=="One" then c = "1" elseif key=="Two" then c = "2" elseif key=="Three" then c = "3" elseif key=="Four" then c = "4" elseif key=="Five" then c = "5" elseif key=="Six" then c = "6" elseif key=="Seven" then c = "7" elseif key=="Eight" then c = "8" elseif key=="Nine" then c = "9" elseif key=="Zero" then c = "0" -- This looks stupid, I kenwo.
		end
		myChat = myChat..c
		modeTxt.Text = "Surface:"..myChat
	end
end--}}}
function nameCapture(key)--{{{
	if key == "Return" or key == "Escape" then
		endKeyCapture()
		if key == "Return" then 
			local selecteds = game:getService("Selection"):Get()
			local n = 0
			for i,v in ipairs(selecteds) do
				n = n+1
				v.Name = string.gsub(myChat, "NM", n)
			end
		end
	else
		local c=""
		if key == "Space" then c = " "
		elseif (key == "Backspace" or key == "Capslock") and string.len(myChat) >= 1 then myChat = string.sub(myChat, 1, string.len(myChat)-1)
		elseif string.len(key) == 1 then if not downKeys["LeftShift"] and not downKeys["RightShift"] then key = string.lower(key) end c = key
		elseif key=="One" then c = "1" elseif key=="Two" then c = "2" elseif key=="Three" then c = "3" elseif key=="Four" then c = "4" elseif key=="Five" then c = "5" elseif key=="Six" then c = "6" elseif key=="Seven" then c = "7" elseif key=="Eight" then c = "8" elseif key=="Nine" then c = "9" elseif key=="Zero" then c = "0" -- This looks stupid, I kenwo.
		end
		myChat = myChat..c
		modeTxt.Text = "Renaming:"..myChat
	end
end--}}}
function recurseForCapture(key)--{{{
	if key == "Return" or key == "Escape" then
		endKeyCapture()
		if key == "Return" then --{{{
			local selecteds = game:getService("Selection"):Get()
			if #selecteds == 0 then selecteds = {workspace} end
			local temp = {}
			print("Recursing")
			local rFind

			if string.find(myChat, "/") then
				local last = string.sub
				local subs = {}
				local prevString = myChat
				local a,b
				repeat 
					local a,b = string.match(prevString, "(.-)/(.+)")
					table.insert(subs,a)
					prevString = b
				until a == nil
				rFind = function(obj,tbl)
					if #obj:getChildren() > 0 then
						for i,v in ipairs(obj:getChildren()) do
							local a = v
							local bool = true
							for j,b in ipairs(subs) do
								pcall(function() a = a[b] end) -- Urgs. lotsa pcalls. supah inefficients
							end
							if a == prevString then
								tbl[#tbl+1] = v
							end
							rFind(v, tbl)
						end
					end
				end
			else
				local clen = string.len(myChat)
				rFind = function(obj,tbl)
					if #obj:getChildren() > 0 then
						for i,v in ipairs(obj:getChildren()) do
							if string.sub(v.Name, 1, clen) == myChat then
							--if v.Name == myChat then
								tbl[#tbl+1] = v
							end
							rFind(v, tbl)
						end
					end
				end
			end

			for i,v in ipairs(selecteds) do
				rFind(v, temp)
			end
			print("done"..tostring(temp).." - "..#temp)
			game:getService("Selection"):Set(temp)
			print("Recursed and set")
		end--}}}
	else
		local c=""
		if key == "Space" then c = " "
		elseif key == "Minus" and downKeys["LeftShift"] then c = "_"
		elseif key == "Underscore" then c = "_"
		elseif key == "Slash" then c = "/"
		elseif key == "Period" then c = "."
		elseif (key == "Backspace" or key == "Capslock") and string.len(myChat) >= 1 then myChat = string.sub(myChat, 1, string.len(myChat)-1)
		elseif string.len(key) == 1 then if not downKeys["LeftShift"] and not downKeys["RightShift"] then key = string.lower(key) end c = key
		elseif key=="One" then c = "1" elseif key=="Two" then c = "2" elseif key=="Three" then c = "3" elseif key=="Four" then c = "4" elseif key=="Five" then c = "5" elseif key=="Six" then c = "6" elseif key=="Seven" then c = "7" elseif key=="Eight" then c = "8" elseif key=="Nine" then c = "9" elseif key=="Zero" then c = "0" -- This looks stupid, I kenwo.
		end
		myChat = myChat..c
		modeTxt.Text = "Recursing for:"..myChat
	end
end--}}}
function chatCapture(key)--{{{
	if key == "Return" or key == "Escape" then
		endKeyCapture()
		if key == "Return" then 
			if myChat == "Stop" then keyCapture = function() end end
			hint("Bob/Panda:", 4).TextColor3 = C3(0.3,1,1) hint(myChat, 4) end
	else
		local c=""
		if key == "Space" then c = " "
		elseif key == "Underscore" then c = "_"
		elseif (key == "Backspace" or key == "Capslock") and string.len(myChat) >= 1 then myChat = string.sub(myChat, 1, string.len(myChat)-1)
		elseif string.len(key) == 1 then if not downKeys["LeftShift"] and not downKeys["RightShift"] then key = string.lower(key) end c = key
		elseif key=="One" then c = "1" elseif key=="Two" then c = "2" elseif key=="Three" then c = "3" elseif key=="Four" then c = "4" elseif key=="Five" then c = "5" elseif key=="Six" then c = "6" elseif key=="Seven" then c = "7" elseif key=="Eight" then c = "8" elseif key=="Nine" then c = "9" elseif key=="Zero" then c = "0" -- This looks stupid, I kenwo.
		end
		myChat = myChat..c
		modeTxt.Text = "ChatMode:"..myChat
	end
end--}}}

--> To registers
function putsyCapture(key)--{{{
	keyCapture = nil
	putRegister(key)
	wait(.5)
	cam.CameraType = "Fixed"
end--}}}
function yanksyCapture(key)--{{{
	keyCapture = nil
	pullToRegister(key)
	wait(.5)
	cam.CameraType = "Fixed"
end--}}}

function randPutCapture(key)--{{{
	keyCapture = nil
	randizeReplaceFromRegister(key)
	wait(.5)
	cam.CameraType = "Fixed"
end--}}}
function randYankCapture(key)--{{{
	keyCapture = nil
	pullToRegister(key) -- 
	wait(.5)
	cam.CameraType = "Fixed"
end--}}}

function PalYank() --> Yank to palette --{{{
	print("tryna yankso")
	local n = #paletteNames
	local t = {}
	local a = G()[1]
	if not a then return end
	if a:IsA"BasePart" then
		for i,v in ipairs(saveThings) do
			t[v] = a[v]
		end
	end
	paletteSaves[n] = t
	paletteNames[n] = tostring(n)
	paletteHandles[n] = L(PalPut, n)
	paletteSaves[n+1] = {["Transparency"] = .5, ["Color"]=C3(.5,.5,.5), ["Material"] = "Neon"}
	paletteNames[n+1] = ""
	paletteHandles[n+1] = PalYank
end
--}}}
function PalPut(n) --> Put from palette --{{{
	local thisPal
	if tonumber(n) then
		thisPal = paletteSaves[tonumber(n)]
	else
		thisPal = paletteSaves[n]
	end
	local sls = G()
	for i,v in ipairs(sls) do
		for prop,val in pairs(thisPal) do
			print("tryna change props")
			pcall(function () v[prop] = val end)
		end
	end
end
--}}}

KeyMap = { --> Change stuff inside this stuff --{{{
["All"] = {--{{{
	["Escape"] = function () --> Back to normal --{{{
		Mode = "Normal"
		modeImg.Image = asset..images.normal
		modeTxt.Text = "Normal"
		modeTxt.BackgroundColor3 = C3(0,0,0)
	end,--}}}
	["Slash"] = function ()--{{{
		beginKeyCapture(chatCapture)
		modeImg.Image = asset..images.fireflies
		modeTxt.BackgroundColor3 = C3(1,1,0)
		modeTxt.Text = "ChatMode:"..myChat
	end--}}}
},--}}}
["Normal"] = {--{{{
	["T"] =  function () --> Yanks --{{{
		hint("YANKING", 1)
		cam.CameraType = "Scriptable"
		keyCapture = yanksyCapture
	end, --}}}
	["R"] = function () --> Puts --{{{
		hint("PUTTING", 1)
		cam.CameraType = "Scriptable"
		keyCapture = putsyCapture
	end, --}}}
	["KeypadOne"] = function () --> Normal draw part --{{{
		if mouse.Target == nil then return end
		selectedThings = game:getService("Selection"):Get()
		local prt = nil
		if #selectedThings > 0 then
			prt = selectedThings[1]:clone() -- mhm. why nawt
			prt.Parent = MainMdl
		else
			prt = makeType ~= nil and makeType:clone() or new("Part"){
				Anchored = true, 
				Transparency = .5, 
				CanCollide = false, 
				Size = V3(1,3,1), 
				CFrame = mouse.Hit}
			prt.Parent = MainMdl
		end
		growType1 = prt
		lastGrowPos = mouse.Hit.p
		selectedThings[#selectedThings + 1] = prt
		game:getService("Selection"):Set(selectedThings)
	end,--}}}
},--}}}
["PartsManip"] = {--{{{
	["Z"] = function () --> Do whatever the Z do --{{{
		local selectedThings = G() --> Get table of selected things
		print("Whatsit") --> Do whatev's
	end, --}}}
	["N"] = function () --> begin naming--{{{
		beginKeyCapture(nameCapture)
		modeImg.Image = asset..images.fireflies
		modeTxt.BackgroundColor3 = C3(1,1,0)
		modeTxt.Text = "Renaming:"..myChat
	end, --}}}
	["Semicolon"] = function () --> (dvk "S") begin ReSurface --{{{
		beginKeyCapture(surfCapture)
		myChat = "0"
		modeImg.Image = asset..images.fireflies
		modeTxt.BackgroundColor3 = C3(0,0,1)
		modeTxt.Text = "Surface:"..myChat
	end, --}}}
},--}}}
["MapSetups"] = {--{{{
	["Space"] = function ()--{{{
		print("Dootsle")
	end,--}}}
},--}}}
} --}}}
KeyMapEnd = { --> And change stuff inside this stuff --{{{
["All"] = {--{{{
	--> ["KeypadOne"] = function () print("wutsit") end,
	--> ["KeypadTwo"] = function () print("Another wutsit") end,
}, --}}}
["Normal"] = {--{{{
	["KeypadOne"] = function () --{{{
		W() --> allow for undos
		growType1 = nil
		lastGrowPos = nil
	end,--}}}
}, --}}}
["PartsManip"] = {},
["MapSetups"] = {},
} --}}}

local function onInputBegan(input,gameProcessed)--{{{
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = tostring(input.KeyCode.Name)
		downKeys[key] = 1
		MainMdl = workspace:findFirstChild("PluginMoodle") or new"Model"{
			Parent = workspace,
			Name = "PluginMoodle"}
		--> grab inputs to keyCapture if it's defined (it'll be a function)
		if keyCapture ~= nil then keyCapture(key) return end --> do this and ignore normal-stuff input-grabbing
		if KeyMap["All"][key] then KeyMap["All"][key]() end
		if KeyMap[Mode][key] then KeyMap[Mode][key]() end
	-->> Not-computer inputs --{{{
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		print("MB1 downd",input.Position)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		print("MB2 downd",input.Position)
	else 
		--print("IType = "..tostring(input.UserInputType))--}}}
	end
end--}}}
local function onInputEnd(input,gameProcessed)--{{{
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = tostring(input.KeyCode.Name)
		downKeys[key] = nil
		if KeyMapEnd["All"][key] then KeyMapEnd["All"][key]() end
		if keyCapture ~= nil then return end --> do this ignore normal input grabbing
		if KeyMapEnd[Mode][key] then KeyMapEnd[Mode][key]() end
	end
end--}}}
local function onInputChange(input, gameProcessed)--{{{
	if input.UserInputType == Enum.UserInputType.MouseMovement then --> TODO CHANGE to allow for lots of diff updates on mouse-moves
		if lastGrowing ~= nil then -->  --{{{
			local place = V3(mouse.hit.p.X, lastGrowing.Position.Y,mouse.hit.p.Z)
			local cf = lastGrowing.CFrame
			local vct = lastGrowing.Position-place
			local tgt = mouse.Target
			lastGrowing.Size = V3(vct.magnitude*2,2,vct.magnitude*2)
			lastGrowing.CFrame = cf

			--}}}
		end
	end
end--}}}
 
inputService.InputBegan:connect(onInputBegan)
inputService.InputEnded:connect(onInputEnd)
inputService.InputChanged:connect(onInputChange)

announce.Text = "Haider ask4kingbily bro"

--}}}
--[[--------------------------------------------------
Debuggery and testing--{{{
----------------------------------------------------]]

function testFunction(a,arg)
	local total = 0
	local lst = tick()
	for i=1,100 do
		lst = tick()
		a(arg)
		total = total+tick()-lst
	end
	print("total = "..total.."\navg = "..total/100)
end

--}}}
--[[--------------------------------------------------
rainbows and lollipops
	~ bbb /// panda
----------------------------------------------------]]

--[[--------------------------------------------------
Todos--{{{

	> objs randomizer(s) (within ranges)
	>> HSV blobs (3D color space? or just HS and V by itself)
	>> similar thing with CFrame/angles
	> fill out the Graph Manip
	> Texture Mode
	> Cutscene([Surface,Billboard,Screen]Gui scheduled tweening + changing) Edit
	> Dialog Edit (Sim. to cutscene in some ways but: Text, sound, and animation triggers)
	> KeyMapping/Macro/Input-OutputFn(s) quick-edit

--}}}
----------------------------------------------------]]

--[[--------------------------------------------------
Extra Pollutions --{{{

require(867488181)("Water") --< Fills parts in a mdl named "TerrDoits" with the specified terrain
require(834486927)("Water") --< Similar, does a HalfSphere starting _wide_ @ its CFrame and going to CFrame*CF(0,-1/2 * size.Y ,0)

--> For CSG operations
plugin:Union(selectedThings) W()
plugin:Negate(selectedThings) W()
plugin:Separate(selectedThings) W()

--> for debugging some things a little quicker
local ply = game.Players.LocalPlayer
char = ply.Character
local hb = Instance.new("HopperBin",ply.Backpack)
hb.Selected:connect(function(mouse)
	mouse.Button1Down:connect(function()
	local tar = mouse.Target
	if tar ~= nil then
		char:MoveTo(mouse.Hit.p)
	end
	end)
end)

--}}}
----------------------------------------------------]]

-- Cookies and cream,
-- ~James Barry