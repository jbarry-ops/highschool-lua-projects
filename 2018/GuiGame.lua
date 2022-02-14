local U2, V2, C3 = UDim2.new, Vector2.new, Color3.new
local sqrt, ceil, floor, random = math.sqrt, math.ceil, math.floor, math.random
local sin, cos, tan, atan, pi, deg, rad = math.sin, math.cos, math.tan, math.atan, math.pi, math.deg, math.rad
local s5 = math.sqrt(5) -- 2.236
local av = n1/2 -- 1.118
local sci = av+0.5 --0.618
local phi = av-0.5 --1.618
--newproxy(), rawset(table, index, value), getmetatable(table), setmetatable(table, table2)
--local function update() end RunService:BindToRenderStep("Update", 150, update)
--game:getService("ContentProvider"):PreloadAsync(assets)
--local function copy(obj, pt, ps) local this = obj:Clone() this.Position = ps this.Parent = pt return this end

local Players, Debris, RunService, UIS = Game:getService("Players"), Game:getService("Debris"), Game:getService("RunService"), Game:getService("UserInputService")

local function set(obj, props) for p, q in pairs(props) do obj[p] = q end return obj end
local function new(obj, pt, props) local this = obj:Clone() for p, q in pairs(props) do this[p] = q end this.Parent = pt return this end

local Frame = set(Instance.new("Frame"), {BorderSizePixel = 0})
local Image = set(Instance.new("ImageLabel"), {BorderSizePixel = 0})
local Label = set(Instance.new("TextLabel"), {BorderSizePixel = 0, TextScaled = true})
local Button = set(Instance.new("TextButton"), {BorderSizePixel = 0, TextScaled = true, TextColor3 = C3(), AutoButtonColor = false})
local Box = set(Instance.new("TextBox"), {BorderSizePixel = 0, TextScaled = true})

local MainMenuBorder = new(Frame, nil, {Size = U2(0, 6, 0, 12), BackgroundColor3 = C3(1, 0, 0)})

local function connect(obj, ps1, ps2, wd)
	local x1, x2, y1, y2 = ps1.X.Offset, ps2.X.Offset, ps1.Y.Offset, ps2.Y.Offset
	local xd, yd = x2-x1, y2-y1
	obj.Size = U2(0, sqrt(xd^2+yd^2), 0, wd)
	obj.Position = U2(0, (x2+x1)/2, 0, (y2+y1)/2)
	obj.Rotation = deg(atan(yd/xd))
end

local function corner(obj, pt)
	local tl = obj:Clone() tl.Position = U2(0, 0, 0, 0) tl.Parent = pt
	local tr = tl:Clone() tr.Position = U2(1, 0, 0, 0) tr.Parent = pt
	local bl = tr:Clone() bl.Position = U2(0, 0, 1, 0) bl.Parent = pt
	local br = bl:Clone() br.Position = U2(1, 0, 1, 0) br.Parent = pt
end

local function outline(obj, pt)
	local x, y = pt.AbsoluteSize.X, pt.AbsoluteSize.Y
	local w, h = obj.AbsoluteSize.X, obj.AbsoluteSize.Y
	local tp = obj:Clone() tp.Position = U2(0, 0, 0, 0) tp.Parent = pt tp.Size = U2(0, x, 0, h)
	local bt = tp:Clone() bt.Position = U2(0, 0, 0, y) bt.Parent = pt
	local lf = bt:Clone() lf.Position = U2(0, 0, 0, 0) lf.Parent = pt lf.Size = U2(0, w, 0, y)
	local rt = lf:Clone() rt.Position = U2(0, x, 0, 0) rt.Parent = pt
end

local playerGui = Players.LocalPlayer:waitForChild("PlayerGui") playerGui:SetTopbarTransparency(0) pcall(function() playerGui["Hello world!"]:Destroy() end)
local screenGui = set(Instance.new("ScreenGui"), {Name = "Hello world!", Parent = playerGui}) screenGui.AncestryChanged:connect(function() delay(wait(), function() script:Destroy() end) end)

local main = new(Frame, screenGui, {Size = U2(1, 0, 1, 0), BackgroundColor3 = C3()})
local menu = new(main, main, {Size = U2(1/3, 0, 1, 0), Position = U2(1/3, 0, 0, 0), BackgroundColor3 = C3(0, 0, 0)})

--local play = new(Button, menu, {Size = U2(1, 0, 1/6, 0), Position = U2(0, 0, 4/12, 0), BackgroundColor3 = C3(2/6, 2/6, 2/6), Text = "PLAY", TextColor3 = C3(0, 0, 0)})
	--outline(MainMenuBorder, play)
	--corner(MainMenuBorder, play)
--local help = new(play, menu, {Position = U2(0, 0, 7/12, 0), Text = "HELP"})
	--outline(MainMenuBorder, help)

