--[[
 
        A New Thing:
                Laser Tag? Yes. The guns have certain range indicators to let you know how far you can shoot. If you shoot too far, the beams will simply break apart and fly into harmless particles.
 
Personalization:
        
        Defense:
                stamina: health
                strength: resist
                resilience: healing
                agility: dodge chance
                
        Offense:
                armor piercing
                accuracy
                precision
                fire-rate (mods gun stats)
                reload time (mods gun stats)
                
                
        suggestion list:
        
                make a cave connecting the main room with the exit room thing - Frank's idea
                make a picnic bench that wraps around the palm tree
                make dirt specks around the digsite
 
]]
 
Cone = "rbxassetid://1033714"
SwordMesh = "rbxasset://fonts/sword.mesh"
PaperStack = "rbxassetid://1285245"
PaperStackTex = "rbxassetid://1285242"
PlantInPot = "rbxassetid://25920418"
PlantInPotTex = "rbxassetid://25920406"
MugMesh = "rbxassetid://32023686"
CoffeeCup = "rbxassetid://15929962"
CompassMesh = "rbxassetid://14655367"
CompassTex = "rbxassetid://14655345"
TrashbagsMesh = "rbxassetid://92598630"
TrashbagsTex = "rbxassetid://92599263"
TrashbinMesh = "rbxassetid://93047436"
TrashbinTex = "rbxassetid://93047540"
DumpsterMesh = "rbxassetid://93054682"
DumpsterTex = "rbxassetid://93054830"
 
--[[t = tick()
math.randomseed(t)
print(t)]]
 
math.randomseed(1485802577.4224)
 
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
 
for n, s in pairs({"Players", "Debris", "RunService", "Lighting", "InsertService"}) do
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
                                                p0 = "Part0", p1 = "Part1", mst = "MeshType", tx = "Texture", tC3 = "TextColor3"
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
                                if properties.cf then instance.CFrame = properties.cf end
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
                set(newInstance){sz = V3(1, 1, 1), mt = "SmoothPlastic", ts = 0, bs = 0, Locked = false, an = true}
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
                                f(descendant, _)
                        end
                        addDescendants(descendant)
                end
        end
        addDescendants(object)
        return descendants
end
function castRay(origin, direction, ignoreList)
        local ray = Ray.new(origin, direction)
        local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
        return part, position
end
function weld(p0, p1, c0, c1)
        return new'Motor6D'{pt = p0, p0 = p0, p1 = p1, C0 = c0, C1 = c1}
end
function part(pt, sz, cf, bc, mt, tr, sh)
        local nP = new'Part'{pt = pt, sz = sz, cf = cf, bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
        if sh then
                nP.Shape = sh
                nP.CFrame = cf
        end
        nP.TopSurface = 10
        nP.BottomSurface = 10
        nP.RightSurface = 10
        nP.LeftSurface = 10
        nP.FrontSurface = 10
        nP.BackSurface = 10
        return nP
end
function cylinderPart(pt, sz, cf, bc, mt, tr, sh)
        local nP = new'Part'{pt = pt, sz = V3(sz.Y, sz.X, sz.Z), Shape = "Cylinder", cf = cf*CA(0, 0, 90), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
        nP.CFrame = cf*CA(0, 0, 90)
        nP.TopSurface = 10
        nP.BottomSurface = 10
        nP.RightSurface = 10
        nP.LeftSurface = 10
        nP.FrontSurface = 10
        nP.BackSurface = 10
        return nP
end
function wedge(pt, sz, cf, bc, mt, tr)
        local thisWedge = new'WedgePart'{pt = pt, sz = sz or V3(1, 1, 1), cf = cf or CN(), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
        thisWedge.TopSurface = 10
        thisWedge.BottomSurface = 10
        thisWedge.RightSurface = 10
        thisWedge.LeftSurface = 10
        thisWedge.FrontSurface = 10
        thisWedge.BackSurface = 10
        return thisWedge
end
function ball(pt, wd, cf, bc, mt, tr)
        local thisBall = new'Part'{pt = pt, Shape = "Ball", sz = V3(wd, wd, wd), cf = cf, bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
        thisBall.TopSurface = 10
        thisBall.BottomSurface = 10
        thisBall.RightSurface = 10
        thisBall.LeftSurface = 10
        thisBall.FrontSurface = 10
        thisBall.BackSurface = 10
        return thisBall
end
function cornerPart(pt, sz, cf, bc, mt, tr)
        return new'CornerWedgePart'{pt = pt, sz = sz or V3(1, 1, 1), cf = cf or CN(), bc = BN(bc or ""), mt = mt or "SmoothPlastic", tr = tr or 0}
end
function pyramid(pt, cf, sz, bc, mt, tr)
        local theThing = new'Model'{pt = pt, nm = "Pyramid"}
        for p = 1, 4 do
                local pyrpart = cornerPart(theThing, V3(sz.X/2, sz.Y, sz.X/2), cf*CA(0, 90*p, 0)*CN(-sz.X/4, sz.Y/2, sz.X/4), bc, mt, tr)
        end
        return theThing
end
function mesh(pt, sc, mst, meshId, textureId)
        return new'SpecialMesh'{pt = pt, mst = mst or "Sphere", sc = sc or V3(1, 1, 1), MeshId = meshId or "", TextureId = textureId or ""}
end
function cylinder(pt, sc)
        return new'CylinderMesh'{pt = pt, sc = sc or V3(1, 1, 1)}
end
 
function unanchor(Model, Exceptions)
        local function A(Thing)
                local function B(Thing)
                        for _, Obj in pairs(Thing:GetChildren()) do
                                if Obj:IsA("BasePart") then
                                        local noAnchor = false
                                        if Exceptions then
                                                for i, v in pairs(Exceptions) do
                                                        if Obj == v then
                                                                noAnchor = true
                                                        end
                                                end
                                        end
                                        Obj.Anchored = noAnchor
                                end
                                A(Obj)
                        end
                end
                B(Thing)
        end
        A(Model)
end
function ColorModel(Model, Color)
        local function R(Thing)
                local function C(Thing)
                        for _, Obj in pairs(Thing:GetChildren()) do
                                if Obj:IsA("BasePart") then
                                        Obj.BrickColor = BN(Color)
                                end
                                R(Obj)
                        end
                end
                C(Thing)
        end
        R(Model)
end
function convertToWelds(Model, AnchorPartCFrame, AnchorPart)
        local AnchorPart = AnchorPart
        if not AnchorPart then
                AnchorPart = part(Model, V3(), AnchorPartCFrame, "", "SmoothPlastic", 1)
                AnchorPart.Name = "Anchor"
                AnchorPart.CanCollide = false
        end
        local function A(Thing)
                local function B(Thing)
                        for _, Obj in pairs(Thing:GetChildren()) do
                                if Obj:IsA("BasePart") and Obj ~= AnchorPart then
                                        weld(Obj, AnchorPart, Obj.CFrame:toObjectSpace(AnchorPart.CFrame))
                                end
                                A(Obj)
                        end
                end
                B(Thing)
        end
        A(Model)
        unanchor(Model, {AnchorPart})
        Model:MoveTo(AnchorPartCFrame.p)
        return AnchorPart
end
 
function getTriangleValues(points, width)
        local width = width or 0
        local G, V = 0
        for S = 1, 3 do
                local L = (points[1+(S+1)%3]-points[1+S%3]).magnitude
                G, V = L > G and L or G, L > G and {points[1+(S-1)%3], points[1+(S)%3], points[1+(S+1)%3]} or V
        end
        local D = V[2]+(V[3]-V[2]).unit*((V[3]-V[2]).unit:Dot(V[1]-V[2]))
        local C, B = (D-V[1]).unit, (V[2]-V[3]).unit
        local A = B:Cross(C)
        S1 = V3(width, (V[2]-D).magnitude, (V[1]-D).magnitude)/1--0.2
        S2 = V3(width, (V[3]-D).magnitude, (V[1]-D).magnitude)/1--0.2
        C1 = CN(0,0,0,A.X,B.X,C.X,A.Y,B.Y,C.Y,A.Z,B.Z,C.Z)+(V[1]+V[2])/2
        C2 = CN(0,0,0,-A.X,-B.X,C.X,-A.Y,-B.Y,C.Y,-A.Z,-B.Z,C.Z)+(V[1]+V[3])/2
        return C1, C2, S1, S2
end
function triangleConnect(pt, points, width, BrickColor, Material, Transparency, noThickness)
        local C1, C2, S1, S2 = getTriangleValues(points, width)
        local TM = new'Model'{pt = pt, nm = "Triangle Fill"}
        local T1 = wedge(TM, S1, C1, BrickColor, Material, Transparency)
        local m1 = mesh(T1, V3(1, 1, 1), "Wedge")
        local T2 = wedge(TM, S2, C2, BrickColor, Material, Transparency)
        local m2 = mesh(T2, V3(1, 1, 1), "Wedge")
        
        if noThickness then
                m1.Scale = V3(0, 1, 1)
                m2.Scale = V3(0, 1, 1)
        end
        return TM
end
function connect(pt, p1, p2, sz, bc, mt, orientedY)
        local dist = (p2-p1).magnitude
        if not orientedY then
                return part(pt, V3(sz.X, sz.Y, dist), CN(p1, p2)*CN(0, 0, -dist/2), bc, mt)
        else
                return part(pt, V3(sz.X, dist, sz.Y), CN(p1, p2)*CN(0, 0, -dist/2)*CA(90, 0, 0), bc, mt)
        end
end
function cylinderConnect(pt, p1, p2, wd, bc, mt)
        local dist = (p2-p1).magnitude
        return cylinderPart(pt, V3(wd, dist, wd), CN(p1, p2)*CN(0, 0, -dist/2)*CA(90, 0, 0), bc, mt)
end
function frame(pt, sz, ps, bgc, bgt)
        return new'Frame'{pt = pt, sz = sz, ps = ps, bgc = bgc, bgt = bgt}
end
function tLabel(pt, Text, TextSize, tC3, sz, ps)
        return new'TextLabel'{pt = pt, Text = Text, TextSize = TextSize, tC3 = tC3, sz = sz, ps = ps}
end
function tButton(pt, Text, TextSize, tC3, sz, ps)
        return new'TextButton'{pt = pt, Text = Text, TextSize = TextSize, tC3 = tC3, sz = sz, ps = ps}
end
function tCombo(pt, Text, TextSize, tC3, sz, ps, bgc, bgt)
        local newFrame = frame(pt, sz, ps, bgc, bgt)
        local newButton = tButton(newFrame, Text, TextSize, tC3)
        return newFrame, newButton
end
function arc(pt, cf, r, n, a, sz, bc, mt, tr, mod, overlapFix)
        local R = sz.X+r
        local c, i = 2*math.pi*(R), a/n --circumference, angleInterval
        local z = c/(360/a)/n --segment length
        local d = ((cf*CA(0, 0, 0)*CN(z/2, 0, r+sz.X)).p-(cf*CA(0, i, 0)*CN(-z/2, 0, r+sz.X)).p).magnitude
        
        z = z+d
        
        local theArc = new'Model'{pt = pt, nm = "This Arc(h), Though"}
        for s = -n/2, n/2 do
                if a == 360 and s == n/2 then return theArc end
                local cPart = part(theArc, V3(z, sz.Y, sz.X), cf*CA(0, i*s, 0)*CN(0, 0, r+sz.X/2), bc, mt, tr)
                if mod then
                        cPart.CFrame = cPart.CFrame*mod
                end
                if overlapFix then
                        cPart.CFrame = cPart.CFrame*CN(0, overlapFix*math.cos(math.rad(s*360/n+12)), 0)
                end
        end
        return theArc
end
function curve(pt, orientation, cf, r, n, a, sz, bc, mt, tr)
        local i = a/n --circumference, angleInterval
        
        local theCurve = new'Model'{pt = pt, nm = "Parts-curve"}
        
        if orientation == "X" then
                for s = -n/2, n/2 do
                        if a == 360 and s == n/2 then return theCurve end
                        local cPart = part(theCurve, sz, cf*CA(i*s, 0, 0)*CN(0, 0, r+sz.X/2), bc, mt, tr)
                end
        elseif orientation == "Y" then
                for s = -n/2, n/2 do
                        if a == 360 and s == n/2 then return theCurve end
                        local cPart = part(theCurve, sz, cf*CA(0, i*s, 0)*CN(r+sz.X/2, 0, 0), bc, mt, tr)
                end
        elseif orientation == "Z" then
                for s = -n/2, n/2 do
                        if a == 360 and s == n/2 then return theCurve end
                        local cPart = part(theCurve, sz, cf*CA(0, 0, i*s)*CN(0, r+sz.X/2, 0), bc, mt, tr)
                end
        end
        return theCurve
end
function weaponsCrate(pt, cf)
        local theCrate = new'Model'{pt = pt, nm = "Weapons Crate"}
        local base = part(theCrate, V3(8, 0.4, 5), cf*CN(0, 0.2, 0), "Reddish brown", "Wood")
        for a = -1, 1, 2 do
                local side = part(theCrate, V3(0.4, 3, 5), cf*CN(a*4.2, 1.5, 0), "Reddish brown", "Wood")
                local side2 = part(theCrate, V3(8.8, 3, 0.4), cf*CN(0, 1.5, a*2.7), "Reddish brown", "Wood")
        end
        local top = part(theCrate, V3(8.8, 0.4, 5.8), cf*CN(4.7, 3.2, 0)*CA(0, 5, -45), "Reddish brown", "Wood")
        
        --bazooka, sniper, pistol, sword, shotgun, grenade, (rocket,) spear, 
        
end
function PalmTree(pt, CFrame, Segments, Modifier, StartSize, StartAngle, Leaves, LeafSegments, LeafSegmentModifier, LeafStartSize, LeafStartAngle, LeafStartVariation, ExtensionsPerLeaf, Colors, Materials)
        local Palm = new'Model'{pt = pt, Name = "Palm Tree"}
        local Start = part(Palm, StartSize, CFrame*CA(StartAngle[1], StartAngle[2], StartAngle[3])*CN(0, StartSize.Y/2, 0), Colors[1], Materials[1])
        cylinder(Start)
        local CurrentSegment = Start
        for P = 1, Segments-1 do
                local PalmSegment = part(Palm, StartSize+Modifier*P, CurrentSegment.CFrame*CN(0, CurrentSegment.Size.Y/2, 0)*CA(StartAngle[1]/P+math.random(-2, 2), StartAngle[2]/P+math.random(-2, 2), StartAngle[3]/P+math.random(-2, 2))*CN(0, (StartSize+Modifier*P).Y/2-(StartSize+Modifier*P).X/4, 0), Colors[1], Materials[1])
                cylinder(PalmSegment)
                CurrentSegment = PalmSegment
                if P == Segments-1 then
                        --Top
                        for L = 1, Leaves do
                                local LeafStart
                                if L%2 == 0 then
                                        LeafStart = part(Palm, LeafStartSize, PalmSegment.CFrame*CA(0, L*360/Leaves, 0)*CN(0, math.random(-PalmSegment.Size.Y/4*100, PalmSegment.Size.Y/4*100)/100, PalmSegment.Size.Z/2-LeafStartSize.Z/2)*CA(math.random(0, LeafStartVariation[1]), math.random(-LeafStartVariation[2], LeafStartVariation[2]), math.random(-LeafStartVariation[3], LeafStartVariation[3]))*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, LeafStartSize.Y/2, 0), Colors[2], Materials[2])
                                else
                                        LeafStart = part(Palm, LeafStartSize, PalmSegment.CFrame*CA(0, L*360/Leaves, 0)*CN(0, math.random(PalmSegment.Size.Y/4*100, PalmSegment.Size.Y/2*100)/100, PalmSegment.Size.Z/2-LeafStartSize.Z/2)*CA(math.random(0, LeafStartVariation[1]), math.random(-LeafStartVariation[2], LeafStartVariation[2]), math.random(-LeafStartVariation[3], LeafStartVariation[3]))*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, LeafStartSize.Y/2, 0), Colors[2], Materials[2])
                                end
                                if math.random(0, 1) == 1 then
                                        local Coconut = part(Palm, V3(2, 2, 2), LeafStart.CFrame*CN(0, 0, LeafStartSize.Z/2+0.5), "Reddish brown", "Slate")
                                        mesh(Coconut, V3(1, 1, 1), "Sphere")
                                end
                                local CurrentSegment = LeafStart
                                local LeafStartAngle = {math.random(5*5, 8*5)/5, math.random(-1*10, 1*10)/10, math.random(-1.5*10, 1.5*10)/10}
                                for S = 1, LeafSegments-1 do
                                        local LeafSegment = part(Palm, LeafStartSize+LeafSegmentModifier*S, CurrentSegment.CFrame*CN(0, CurrentSegment.Size.Y/2, 0)*CA(LeafStartAngle[1], LeafStartAngle[2], LeafStartAngle[3])*CN(0, (LeafStartSize+LeafSegmentModifier*S).Y/2-(LeafStartSize+LeafSegmentModifier*S).X/4, 0), Colors[2], Materials[2])
                                        CurrentSegment = LeafSegment
                                        LeafSegment.CanCollide = false
                                        for E = 1, ExtensionsPerLeaf do
                                                local LeafExtension = part(Palm, V3(0.2, 0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E), 0.2), LeafSegment.CFrame*CN(0, -LeafSegment.Size.Y/2+LeafSegment.Size.Y/ExtensionsPerLeaf*E, 0)*CA(0, 0, 90-((S-1)*ExtensionsPerLeaf+E)*(90/(LeafSegments-1)/ExtensionsPerLeaf))*CA(LeafStartAngle[1]/ExtensionsPerLeaf*E, LeafStartAngle[2]/ExtensionsPerLeaf*E, LeafStartAngle[3]/ExtensionsPerLeaf*E)*CA(-7, 0, 0)*CN(0, (0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E))/2, 0), Colors[3], Materials[3])
                                                local LeafExtension2 = part(Palm, V3(0.2, 0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E), 0.2), LeafSegment.CFrame*CN(0, -LeafSegment.Size.Y/2+LeafSegment.Size.Y/ExtensionsPerLeaf*E, 0)*CA(0, 0, -90+((S-1)*ExtensionsPerLeaf+E)*(90/(LeafSegments-1)/ExtensionsPerLeaf))*CA(LeafStartAngle[1]/ExtensionsPerLeaf*E, LeafStartAngle[2]/ExtensionsPerLeaf*E, LeafStartAngle[3]/ExtensionsPerLeaf*E)*CA(-7, 0, 0)*CN(0, (0+14/((LeafSegments-1)*ExtensionsPerLeaf)*((S-1)*ExtensionsPerLeaf+E))/2, 0), Colors[3], Materials[3])
                                                LeafExtension.CanCollide = false
                                                LeafExtension2.CanCollide = false
                                        end
                                end
                        end
                end
        end
        return Palm
end
function decalFaces(PT, FCS, TX, TR)
        for _, Face in pairs(FCS) do
                new'Decal'{pt = PT, Face = Face, Texture = TX, tr = TR or 0}
        end
end
function Scaffold(Parent, CFrame, Width, Height, Length, BridgeDirection, BridgeWidth, BackCross)
        local Scaffold = new'Model'{pt = Parent, nm = "Scaffold"}
        local Platform = part(Scaffold, V3(Width, 1, Length), CFrame*CN(0, Height, 0), "Reddish brown", "Wood")
        local SupportFrontRight = part(Scaffold, V3(1, Height-1, 1), CFrame*CN(-Width/2+0.5, Height/2, Length/2-0.5), "Reddish brown", "Wood")
        local SupportFrontLeft = part(Scaffold, V3(1, Height-1, 1), CFrame*CN(Width/2-0.5, Height/2, Length/2-0.5), "Reddish brown", "Wood")
        local SupportBackRight = part(Scaffold, V3(1, Height-1, 1), CFrame*CN(-Width/2+0.5, Height/2, -Length/2+0.5), "Reddish brown", "Wood")
        local SupportBackLeft = part(Scaffold, V3(1, Height-1, 1), CFrame*CN(Width/2-0.5, Height/2, -Length/2+0.5), "Reddish brown", "Wood")
        
        connect(Scaffold, (SupportFrontRight.CFrame*CN(0, Height/2-0.5, 0)).p, (SupportBackRight.CFrame*CN(0, -Height/2+0.5, 0)).p, V2(1, 1), "Reddish brown", "Wood")
        connect(Scaffold, (SupportFrontRight.CFrame*CN(0, -Height/2+0.5, 0)).p, (SupportBackRight.CFrame*CN(0, Height/2-0.5, 0)).p, V2(1, 1), "Reddish brown", "Wood")
        connect(Scaffold, (SupportFrontLeft.CFrame*CN(0, Height/2-0.5, 0)).p, (SupportBackLeft.CFrame*CN(0, -Height/2+0.5, 0)).p, V2(1, 1), "Reddish brown", "Wood")
        connect(Scaffold, (SupportFrontLeft.CFrame*CN(0, -Height/2+0.5, 0)).p, (SupportBackLeft.CFrame*CN(0, Height/2-0.5, 0)).p, V2(1, 1), "Reddish brown", "Wood")
        if BackCross then
                connect(Scaffold, (SupportBackLeft.CFrame*CN(0, Height/2-0.5, 0)).p, (SupportBackRight.CFrame*CN(0, -Height/2+0.5, 0)).p, V2(1, 1), "Reddish brown", "Wood")
                connect(Scaffold, (SupportBackLeft.CFrame*CN(0, -Height/2+0.5, 0)).p, (SupportBackRight.CFrame*CN(0, Height/2-0.5, 0)).p, V2(1, 1), "Reddish brown", "Wood")
        end
        if BridgeWidth > 0 then
                connect(Scaffold, (Platform.CFrame*CN((Width/2-BridgeWidth)*BridgeDirection, 0, Length/2-0.5)).p, (CFrame*CN((Width/2-BridgeWidth)*BridgeDirection, 0, Length/2+Height/2)).p, V2(BridgeWidth, 1), "Reddish brown", "Wood")
        end
        return Scaffold, Platform
end
function RadioDish(Parent, CFrame, Angle)
        local DishBase = part(Parent, V3(4, 1, 4), CFrame, "Dark stone grey", "Concrete")
        cylinder(DishBase)
        local DishBase2 = part(Parent, V3(3.5, 1, 3.5), DishBase.CFrame*CN(0, 0.5, 0), "Dark stone grey", "Concrete")
        cylinder(DishBase2)
        local DishBase3 = part(Parent, V3(3, 1, 3), DishBase2.CFrame*CN(0, 0.1, 0), "Medium stone grey", "Concrete")
        cylinder(DishBase3)
        local DishStand = part(Parent, V3(2, 3, 2), DishBase3.CFrame*CN(0, 2, 0), "Medium stone grey", "Concrete")
        cylinder(DishStand)
        local DishStand2 = part(Parent, V3(1.5, 3, 1.5), DishStand.CFrame*CN(0, 3, 0), "Medium stone grey", "Concrete")
        cylinder(DishStand2)
        local DishStand2S = part(Parent, V3(1.25, 1.25, 1.25), DishStand2.CFrame*CN(0, 1.5, 0), "Medium stone grey", "Concrete")
        mesh(DishStand2S, V3(1, 1, 1), "Sphere")
        local DishStand3 = part(Parent, V3(1.25, 4, 1.25), DishStand2S.CFrame*Angle*CN(0, 2, 0), "Medium stone grey", "Concrete")
        cylinder(DishStand3)
        local Dish = part(Parent, V3(10, 0.5, 10), DishStand3.CFrame*CN(0, 2, 0), "Black")
        cylinder(Dish)
        local DishA = part(Parent, V3(9, 0.6, 9), Dish.CFrame, "Dark stone grey", "Concrete")
        cylinder(DishA)
        local DishB = part(Parent, V3(7, 0.5, 7), Dish.CFrame*CN(0, -0.1, 0), "Dark stone grey", "Concrete")
        cylinder(DishB)
        local DishC = part(Parent, V3(4, 0.5, 4), DishB.CFrame*CN(0, -0.25, 0), "Dark stone grey", "Concrete")
        cylinder(DishC)
        local DishD = part(Parent, V3(2, 0.5, 2), DishC.CFrame*CN(0, -0.5, 0), "Dark stone grey", "Concrete")
        cylinder(DishD)
        local DishPoint = part(Parent, V3(0.5, 5, 0.5), Dish.CFrame*CN(0, 2.75, 0), "Black", "Concrete")
        cylinder(DishPoint)
        local DishPointConnect = part(Parent, V3(0.75, 0.5, 0.75), DishPoint.CFrame*CN(0, -2.65, 0), "Really black")
        cylinder(DishPointConnect)
        local DishPoint2 = part(Parent, V3(0.75, 0.75, 0.75), DishPoint.CFrame*CN(0, 2.5, 0), "Really red")
        mesh(DishPoint2, V3(1, 1, 1), "Sphere")
        for S = 1, 4 do
                local DishPoint3 = connect(Parent, (Dish.CFrame*CA(0, 90*S, 0)*CN(0, 0, 4)).p, DishPoint2.Position, V2(0.4, 0.4), "Black", "Concrete", true)
                cylinder(DishPoint3)
                local DishPoint3Connect = part(Parent, V3(0.6, 0.5, 0.6), Dish.CFrame*CA(0, 90*S, 0)*CN(0, 0.1, 3.75), "Really black")
                cylinder(DishPoint3Connect)
        end
end
function RadioTower(Parent, CFrame)
        local Tower = new'Model'{pt = Parent, nm = "Radio Tower"}
        local TowerBase = part(Tower, V3(50, 1, 50), CFrame, "Medium stone grey", "Concrete")
        local TowerTop = part(Tower, V3(10, 1, 10), CFrame*CN(0, 100, 0), "Medium stone grey", "Concrete")
        local Antenna1 = part(Tower, V3(1.5, 3, 1.5), TowerTop.CFrame*CN(3.5, 2, 3.5), "Black")
        cylinder(Antenna1)
        local Antenna1A = part(Tower, V3(1, 6, 1), Antenna1.CFrame*CN(0, 4.5, 0), "Black")
        cylinder(Antenna1A)
        local Antenna1B = part(Tower, V3(0.5, 6, 0.5), Antenna1A.CFrame*CN(0, 6, 0), "Black")
        cylinder(Antenna1B)
        local Antenna1C = part(Tower, V3(0.2, 6, 0.2), Antenna1B.CFrame*CN(0, 6, 0), "Black")
        cylinder(Antenna1C)
        local AntennaConnect = part(Tower, V3(1.75, 1, 1.75), Antenna1.CFrame*CN(0, -1.95, 0), "Really black")
        cylinder(AntennaConnect)
        RadioDish(Tower, TowerTop.CFrame*CN(-2.5, 0.1, -2.5), CA(0, 30, 0)*CA(-30, 0, 0))
        local Supports = {}
        for S = 1, 4 do
                local Support = connect(Tower, (TowerBase.CFrame*CA(0, 90*S, 0)*CN(24, 0, 24)).p, (TowerTop.CFrame*CA(0, 90*S, 0)*CN(4, 0, 4)).p, V2(2, 2), "Medium stone grey", "Concrete", true)
                cylinder(Support)
                table.insert(Supports, Support)
        end
        for D = -2, 2 do
                local CS1 = connect(Tower, (Supports[1].CFrame*CN(0, D*15, 0)).p, (Supports[2].CFrame*CN(0, D*15, 0)).p, V2(2, 2), "Medium stone grey", "Concrete", true)
                cylinder(CS1)
                local CS2 = connect(Tower, (Supports[2].CFrame*CN(0, D*15, 0)).p, (Supports[3].CFrame*CN(0, D*15, 0)).p, V2(2, 2), "Medium stone grey", "Concrete", true)
                cylinder(CS2)
                local CS3 = connect(Tower, (Supports[3].CFrame*CN(0, D*15, 0)).p, (Supports[4].CFrame*CN(0, D*15, 0)).p, V2(2, 2), "Medium stone grey", "Concrete", true)
                cylinder(CS3)
                local CS4 = connect(Tower, (Supports[4].CFrame*CN(0, D*15, 0)).p, (Supports[1].CFrame*CN(0, D*15, 0)).p, V2(2, 2), "Medium stone grey", "Concrete", true)
                cylinder(CS4)
                
                local CS5 = connect(Tower, (Supports[1].CFrame*CN(0, D*15, 0)).p, (Supports[2].CFrame*CN(0, D*15+15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS5)
                local CS6 = connect(Tower, (Supports[1].CFrame*CN(0, D*15+15, 0)).p, (Supports[2].CFrame*CN(0, D*15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS6)
                
                local CS7 = connect(Tower, (Supports[2].CFrame*CN(0, D*15, 0)).p, (Supports[3].CFrame*CN(0, D*15+15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS7)
                local CS8 = connect(Tower, (Supports[2].CFrame*CN(0, D*15+15, 0)).p, (Supports[3].CFrame*CN(0, D*15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS8)
                
                local CS9 = connect(Tower, (Supports[3].CFrame*CN(0, D*15, 0)).p, (Supports[4].CFrame*CN(0, D*15+15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS9)
                local CS9 = connect(Tower, (Supports[3].CFrame*CN(0, D*15+15, 0)).p, (Supports[4].CFrame*CN(0, D*15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS9)
                
                local CS10 = connect(Tower, (Supports[4].CFrame*CN(0, D*15, 0)).p, (Supports[1].CFrame*CN(0, D*15+15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS10)
                local CS11 = connect(Tower, (Supports[4].CFrame*CN(0, D*15+15, 0)).p, (Supports[1].CFrame*CN(0, D*15, 0)).p, V2(1, 1), "Medium stone grey", "Concrete", true)
                cylinder(CS11)
        end
end
function HelicopterPad(Parent, CFrame)
        local Pad = new'Model'{pt = Parent, nm = "Helicopter Landing Pad"}
        local Pad1 = part(Pad, V3(50, 1, 50), CFrame, "Black", "Concrete")
        local PadInline1 = part(Pad, V3(1, 1, 48), Pad1.CFrame*CN(23.5, 0.1, 0), "Bright yellow", "Concrete")
        local PadInline2 = part(Pad, V3(1, 1, 48), Pad1.CFrame*CN(-23.5, 0.1, 0), "Bright yellow", "Concrete")
        local PadInline3 = part(Pad, V3(46, 1, 1), Pad1.CFrame*CN(0, 0.1, 23.5), "Bright yellow", "Concrete")
        local PadInline4 = part(Pad, V3(46, 1, 1), Pad1.CFrame*CN(0, 0.1, -23.5), "Bright yellow", "Concrete")
        
        local H1 = part(Pad, V3(1, 1, 25), Pad1.CFrame*CN(10, 0.1, 0), "Light stone grey", "Concrete")
        local H2 = part(Pad, V3(1, 1, 25), Pad1.CFrame*CN(-10, 0.1, 0), "Light stone grey", "Concrete")
        local H3 = part(Pad, V3(19, 1, 1), Pad1.CFrame*CN(0, 0.1, 0), "Light stone grey", "Concrete")
end
function Desk(Parent, CFrame, Width, Length, BrickColor, Material)
        local Desk = new'Model'{pt = Parent, nm = "Desk"}
        local DeskTop = part(Desk, V3(Width, 1, Length), CFrame*CN(0, 4, 0), BrickColor, Material)
        local DeskBack = part(Desk, V3(Width, 3.5, 1), CFrame*CN(0, 1.75, Length/2-0.5), BrickColor, Material)
        local DeskRight = part(Desk, V3(1, 3.5, Length-1), CFrame*CN(Width/2-0.5, 1.75, -0.5), BrickColor, Material)
        local DeskLeft = part(Desk, V3(1, 3.5, Length-1), CFrame*CN(-Width/2+0.5, 1.75, -0.5), BrickColor, Material)
        return DeskTop
end
function Laptop(Parent, CFrame, Angle, BrickColor)
        local Laptop = new'Model'{pt = Parent, nm = "Laptop"}
        local LaptopBoard = part(Laptop, V3(2, 0.2, 2), CFrame*CN(0, 0.1, 0), BrickColor)
        local LaptopKeyboard = part(Laptop, V3(1.8, 0.2, 1.2), LaptopBoard.CFrame*CN(0, 0.05, -0.3), BrickColor)
        local LaptopMonitor = part(Laptop, V3(2, 0.2, 2), LaptopBoard.CFrame*CN(0, 0.2, 1)*CA(Angle, 0, 0)*CN(0, 0, -1), BrickColor)
        local LaptopScreen = part(Laptop, V3(1.8, 0.2, 1.8), LaptopMonitor.CFrame*CN(0, -0.005, 0), "Really black")
        local LaptopMonitorConnect = part(Laptop, V3(2, 0.3, 0.2), LaptopBoard.CFrame*CN(0, 0.05, 1), BrickColor)
        local LaptopMonitorConnect2 = part(Laptop, V3(0.2, 2, 0.2), LaptopMonitorConnect.CFrame*CN(0, 0.15, 0)*CA(0, 0, 90), BrickColor)
        cylinder(LaptopMonitorConnect2)
end
function StackOfPapers(Parent, CFrame, Size)
        local Papers = new'Model'{pt = Parent, nm = "Stack Of Papers"}
        local Stack = part(Papers, V3(Size, Size, Size), CFrame*CN(0, Size/2, 0), "Light stone grey")
        mesh(Stack, V3(Size, Size, Size), "FileMesh", PaperStack)
        return Stack
end
function PottedPlant(Parent, CFrame)
        local PottedPlant = new'Model'{pt = Parent, nm = "Potted Plant"}
        local Plant = part(PottedPlant, V3(2, 4, 2), CFrame*CN(0, 2, 0), "CGA brown", "Wood")
        mesh(Plant, V3(4, 4, 4), "FileMesh", PlantInPot, PlantInPotTex)
end
function OfficeChair(Parent, CFrame, BrickColor)
        local Chair = new'Model'{pt = Parent, nm = "Office Chair"}
        local ChairSeat = part(Chair, V3(2.5, 0.5, 2.5), CFrame*CN(0, 2.5, 0), BrickColor)
        mesh(ChairSeat, V3(1.25, 0.25, 2.5), "FileMesh", "rbxasset://fonts/torso.mesh")
        local ChairSeatBase = part(Chair, V3(0.5, 1.5, 0.5), ChairSeat.CFrame*CN(0, -1, 0), "Black")
        cylinder(ChairSeatBase)
        local ChairSeatBaseConnect = part(Chair, V3(0.5, 0.5, 0.5), ChairSeatBase.CFrame*CN(0, -0.75, 0)*CA(0, math.random(-180, 180), 0), "Black")
        mesh(ChairSeatBaseConnect, V3(1, 1, 1), "Sphere")
        for L = 1, 5 do
                local ChairLeg = part(Chair, V3(0.5, 2, 0.5), ChairSeatBaseConnect.CFrame*CA(0, L*72, 0)*CN(0, 0, 1)*CA(90, 0, 0), "Black")
                cylinder(ChairLeg)
                local ChairWheel = part(Chair, V3(1, 0.2, 1), ChairLeg.CFrame*CN(0, 1.1, 0.25), "Black")
                cylinder(ChairWheel)
        end
        local ChairBack = part(Chair, V3(1, 0.2, 0.5), ChairSeat.CFrame*CN(0, 0, 1.5), "Black")
        local ChairBackConnect = part(Chair, V3(0.2, 1, 0.2), ChairBack.CFrame*CN(0, 0, 0.25)*CA(0, 0, 90), "Black")
        cylinder(ChairBackConnect)
        local ChairBack2 = part(Chair, V3(1, 1.2, 0.2), ChairBack.CFrame*CN(0, 0.6, 0.25), "Black")
        local ChairBackCushion = part(Chair, V3(2.5, 2.5, 0.5), ChairBack2.CFrame*CN(0, 1.85, 0), BrickColor)
        mesh(ChairBackCushion, V3(1.25, 1.25, 0.5), "FileMesh", "rbxasset://fonts/torso.mesh")
end
function Mug(Parent, CFrame, Size, BrickColor)
        local Mug = part(Parent, V3(Size, Size, Size), CFrame*CN(0, Size*0.625, 0), BrickColor)
        mesh(Mug, V3(Size, Size, Size), "FileMesh", MugMesh)
        return Mug
end
function Trashbags(Parent, CFrame, Size)
        local Trashbags = new'Model'{pt = Parent, nm = "Trashbags"}
        local Bags = ball(Trashbags, math.max(Size.X, Size.Y, Size.Z)*0.81, CFrame*CN(0, Size.Y/2, 0))
        mesh(Bags, Size, "FileMesh", TrashbagsMesh, TrashbagsTex)
end
function Compass(Parent, CFrame, Size)
        local Compass = part(Parent, V3(Size, Size, Size), CFrame*CN(0, Size*0.6, 0))
        mesh(Compass, V3(Size*1.35, Size*1.35, Size*1.35), "FileMesh", CompassMesh, CompassTex)
        return Compass
end
function Figure(Parent, CFrame, Pose, Assets, BodyColors, TShirt)
        local Figure = new'Model'{pt = Parent, nm = "Figure"}
        local Torso = part(Figure, V3(2, 2, 1), CFrame, BodyColors[1]) --[[Torso.Anchored = false]] Torso.Name = "Torso"
        local Head = part(Figure, V3(1.25, 1.25, 1.25), CFrame, BodyColors[2]) Head.Anchored = false Head.Name = "Head" Head.Transparency = 1
        mesh(Head, V3(1, 1, 1), "Head")
        local FakeHead = part(Figure, V3(1.25, 1.25, 1.25), CFrame, BodyColors[2]) FakeHead.Anchored = false
        mesh(FakeHead, V3(1, 1, 1), "Head")
        weld(Head, FakeHead)
        local RightArm = part(Figure, V3(1, 2, 1), CFrame, BodyColors[3]) RightArm.Anchored = false RightArm.Name = "Right Arm"
        local LeftArm = part(Figure, V3(1, 2, 1), CFrame, BodyColors[4]) LeftArm.Anchored = false LeftArm.Name = "Left Arm"
        local RightLeg = part(Figure, V3(1, 2, 1), CFrame, BodyColors[5]) RightLeg.Anchored = false RightLeg.Name = "Right Leg"
        local LeftLeg = part(Figure, V3(1, 2, 1), CFrame, BodyColors[6]) LeftLeg.Anchored = false LeftLeg.Name = "Left Leg"
        weld(Torso, Head, Pose[1], CN(0, -0.5, 0), "Neck")
        weld(Torso, RightArm, Pose[2], CN(0, 0.5, 0), "Right Shoulder")
        weld(Torso, LeftArm, Pose[3], CN(0, 0.5, 0), "Left Shoulder")
        weld(Torso, RightLeg, Pose[4], CN(0, 1, 0), "Right Hip")
        weld(Torso, LeftLeg, Pose[5], CN(0, 1, 0), "Left Hip")
        new'Humanoid'{pt = Figure, Health = 100}
        Figure:MakeJoints()
        wait()
        for _, Id in pairs(Assets) do
                wait()
                local Asset
                local success, err = pcall(function()
                        Asset = InsertService:LoadAsset(Id)
                end)
                if success then
                        local AssetItem = Asset:GetChildren()[1]
                        if AssetItem:IsA("Decal") then
                                AssetItem.Parent = FakeHead
                        else
                                AssetItem.Parent = Figure
                        end
                end
        end
        if TShirt then Instance.new("ShirtGraphic", Figure).Graphic = "rbxassetid://"..TShirt end
        Figure:MakeJoints()
        print("here?")
        return Figure
end
function ThumbnailPeeps(Parent, CFrame)
        local Peeps = new'Model'{pt = Parent}
        local RMDX = Figure(Peeps, CFrame*CN(0, 2.9, 0), { --RMDX
                CN(0, 1, 0)*CA(0, 0, 0),
                CN(1.5, 0.5, 0)*CA(135, 15, 15),
                CN(-1.5, 0.5, 0)*CA(-10, 0, -15),
                CN(0.5, -1, 0)*CA(0, 0, 10),
                CN(-0.5, -1, 0)*CA(0, 0, -10)
        }, {20722130, 1365767, 17424092, 15967743, 8409458, 8409453},
        {"Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow"}, 52291597) --PonyShirt: 52291597
        
        local Shotgun = part(Peeps, V3(1, 1, 4), RMDX["Right Arm"].CFrame*CN(0, -1, -0.25)*CA(-90, 0, 0), "Black")
        mesh(Shotgun, V3(1.8, 1.5, 1), "FileMesh", "rbxassetid://3835506")
        
        local Fenrier = Figure(Peeps, CFrame*CN(12, 2.9, -2.5)*CA(0, 30, 0), { --Fenrier
                CN(0, 1, 0)*CA(0, -30, 0),
                CN(1.5, 0.5, 0)*CA(-10, 0, 15),
                CN(-1.5, 0.5, 0)*CA(-10, 0, -15),
                CN(0.5, -1, 0)*CA(10, 0, 10),
                CN(-0.5, -1, 0)*CA(-10, 0, -10)
        }, {1846208, 1859136, 20298783, 14030577},
        {"Dark stone grey", "Brick yellow", "Navy blue", "Navy blue", "Navy blue", "Navy blue"})
        
        local GuitarMan = Figure(Peeps, CFrame*CN(-14, 7.5, 0)*CA(0, -30, 0), { --Guy with guitar and cowboy hat
                CN(0, 1, 0)*CA(0, -30, 0),
                CN(1, 0.5, -0.5)*CA(90, 0, -45),
                CN(-1, 0.5, 0)*CA(80, 0, 30),
                CN(0.5, -1, 0)*CA(-10, 0, 10),
                CN(-0.5, -1, 0)*CA(10, 0, -10)
        }, {1846208, 1859136, 62332732, 19398258, 10527010},
        {"Dark stone grey", "Brick yellow", "Lime green", "Lime green", "Bright orange", "Bright orange"})
        
        local Piano = part(Peeps, V3(5, 5, 5), GuitarMan.Torso.CFrame*CN(0, -5, 0)*CA(-30, 0, 0))
        mesh(Piano, V3(3, 3, 3), "FileMesh", "rbxassetid://113221356", "rbxassetid://113221332")
        local Guitar = part(Peeps, V3(1, 1, 1), GuitarMan["Left Arm"].CFrame*CN(0, -1, 0)*CA(-90, 180, 90)*CN(1.5, 0, 0))
        mesh(Guitar, V3(1.5, 1.5, 1.5), "FileMesh", "rbxassetid://1082816", "rbxassetid://10504421")
        
        local SniperDude = Figure(Peeps, CFrame*CN(-5.5, 2, -2.5)*CA(0, -30, 0), { --Sniper dude
                CN(0, 1, 0)*CA(0, -30, 0),
                CN(1.5, 0.5, 0)*CA(90, 0, 15),
                CN(-1.5, 0.5, 0)*CA(90, 0, -15),
                CN(0.51, -1.5, 0)*CA(-90, 0, 0)*CN(0, 0.5, 0),
                CN(-0.51, 0, -0.25)*CA(0, 0, 0)
        }, {9315055, 8343331, 1029025, 1309911, 1125510, 10860384},
        {"Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow"}, 11317761)
        
        local CrazyDude = Figure(Peeps, CFrame*CN(6, 3, 0)*CA(0, 15, 0), { --Crazy guy
                CN(0, 1, 0)*CA(0, -30, 0),
                CN(1.5, 0.5, 0)*CA(90, 0, 135),
                CN(-1.5, 0.5, 0)*CA(90, 0, -15),
                CN(0.5, -1, 0)*CA(0, 0, 0),
                CN(-0.5, -1, 0)*CA(0, 0, 0)
        }, {58789718, 58811258, 1365767, 17877340, 21635565},
        {"Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow", "Brick yellow"}, 20736336)
end
function LandingCraft(Parent, CFrame, DrawbridgeAngle)
        local Craft = new'Model'{pt = Parent, nm = "Armoured Landing Craft"}
        local Hull = part(Craft, V3(30, 3, 90), CFrame, "Medium stone grey", "DiamondPlate")
        local BottomFront = wedge(Craft, V3(38, 5, 9), CFrame*CN(0, -4, -40.5)*CA(0, 0, 180), "Medium stone grey", "DiamondPlate")
        local BottomBack = wedge(Craft, V3(38, 5, 13), CFrame*CN(0, -4, 42.5)*CA(0, 180, 180), "Medium stone grey", "DiamondPlate")
        local MidBottom = part(Craft, V3(38, 5, 72), CFrame*CN(0, -4, 0), "Medium stone grey", "DiamondPlate")
        local BackWall = part(Craft, V3(38, 18, 4), CFrame*CN(0, 7.5, 47), "Medium stone grey", "DiamondPlate")
        local Drawbridge = part(Craft, V3(30, 24, 1), CFrame*CN(0, 0, -45)*CA(DrawbridgeAngle, 0, 0)*CN(0, 12, 0), "Medium stone grey", "DiamondPlate")
        for D = -11, 11 do
                local DrawbridgePad = part(Craft, V3(1, 28, 1), Drawbridge.CFrame*CN(0, D, 0.25)*CA(0, 0, 90), "Dark stone grey", "Concrete")
                cylinder(DrawbridgePad)
        end
        local DrawbridgeTop = part(Craft, V3(0.5, 29, 0.5), Drawbridge.CFrame*CN(0, 12, 0)*CA(0, 0, 90), "Medium stone grey", "DiamondPlate")
        cylinder(DrawbridgeTop)
        local DrawbridgeMid = part(Craft, V3(5, 5, 1), Drawbridge.CFrame*CN(0, 5, -0.5), "Medium stone grey", "DiamondPlate")
        local DrawbridgeMid2 = part(Craft, V3(4, 4, 1), DrawbridgeMid.CFrame*CN(0, 0, -0.2), "Black", "DiamondPlate")
        decalFaces(DrawbridgeMid2, {"Front"}, "rbxassetid://114351360")
        local DrawbridgeTopOutside = part(Craft, V3(29, 1, 1), Drawbridge.CFrame*CN(0, 11, -0.5), "Dark stone grey", "DiamondPlate")
        local DrawbridgeBottomOutside = part(Craft, V3(29, 1, 1), Drawbridge.CFrame*CN(0, -11, -0.5), "Dark stone grey", "DiamondPlate")
        for D = -5, 5 do
                local DrawbridgeOutsideDecor = part(Craft, V3(1, 22, 1), Drawbridge.CFrame*CN(D*2.5, 0, -0.5), "Dark stone grey", "DiamondPlate")
                cylinder(DrawbridgeOutsideDecor)
        end
        for A = -1, 1, 2 do
                local Wall = part(Craft, V3(4, 18, 90), CFrame*CN(A*17, 7.5, 0), "Medium stone grey", "DiamondPlate")
                local WallBottom = part(Craft, V3(1, 0.5, 60), Wall.CFrame*CN(-2.5*A, -5.75, -15), "Medium stone grey", "Concrete")
                for D = -4, 1 do
                        local WallDecor = wedge(Craft, V3(1, 18, 1), Wall.CFrame*CN(-2.5*A, 0, D*10)*CA(0, A*90, 0), "Medium stone grey", "Concrete")
                        if D ~= -4 then
                                local WallDecor2 = part(Craft, V3(2, 1, 2), Wall.CFrame*CN(-1.6*A, 7, D*10-5)*CA(0, 0, 90), "Medium stone grey", "Concrete")
                                cylinder(WallDecor2)
                                local WallDecor3 = part(Craft, V3(1.75, 1.75, 1.75), WallDecor2.CFrame, "Medium stone grey", "SmoothPlastic")
                                mesh(WallDecor3, V3(1, 1, 1), "Sphere")
                        end
                end
                local FrontSides = wedge(Craft, V3(4, 18, 10), CFrame*CN(A*17, 7.5, -50)*CA(0, 0, 180), "Medium stone grey", "DiamondPlate")
                local FrontSidesTop = wedge(Craft, V3(4, 5, 9), CFrame*CN(A*17, 19, -50.5), "Medium stone grey", "DiamondPlate")
                local FrontSidesBack = wedge(Craft, V3(4, 5, 61), CFrame*CN(A*17, 19, -15.5)*CA(0, 180, 0), "Medium stone grey", "DiamondPlate")
                local DrawbridgeMotor = part(Craft, V3(4, 4.2, 4), FrontSidesTop.CFrame*CN(0, -2.5, 5.5)*CA(0, 0, 90), "Dark stone grey", "Concrete")
                cylinder(DrawbridgeMotor)
                local DrawbridgeMotor2 = part(Craft, V3(3, 1, 3), DrawbridgeMotor.CFrame*CN(0, 2.6*A, 0), "Dark stone grey", "Concrete")
                cylinder(DrawbridgeMotor2)
                local DrawbridgeMotor2A = part(Craft, V3(3.05, 0.4, 3.05), DrawbridgeMotor2.CFrame, "Really black", "SmoothPlastic")
                cylinder(DrawbridgeMotor2A)
                local DrawbridgeMotor3 = part(Craft, V3(1, 4.5, 5), Drawbridge.CFrame*CN(15.5*A, 9.75, 2), "Medium stone grey", "DiamondPlate")
                --cylinder(DrawbridgeMotor3)
                local DrawbridgeMotor4 = part(Craft, V3(3.25, 1.2, 3.25), DrawbridgeMotor3.CFrame*CN(0, 0, 0.5)*CA(0, 0, 90), "Dark stone grey", "Concrete")
                cylinder(DrawbridgeMotor4)
                local DrawbridgeMotor5 = part(Craft, V3(3, 1, 3), DrawbridgeMotor4.CFrame*CN(0, A*1.1, 0), "Dark stone grey", "Concrete")
                cylinder(DrawbridgeMotor5)
                local DrawbridgeMotor5A = part(Craft, V3(3.05, 0.4, 3.05), DrawbridgeMotor5.CFrame, "Really black", "SmoothPlastic")
                cylinder(DrawbridgeMotor5A)
                local DrawbridgeWire = connect(Craft, DrawbridgeMotor2.Position, DrawbridgeMotor5.Position, V2(0.4, 0.4), "Dark stone grey", "DiamondPlate", true)
                cylinder(DrawbridgeWire)
        end
        --local Back = part(Craft, V3(30, 15, 30), CFrame*CN(0, 9, 30), "Medium stone grey", "DiamondPlate")
        local BackTop = part(Craft, V3(30, 1, 29), CFrame*CN(0, 16, 30.5), "Medium stone grey", "DiamondPlate")
        local BackFront = part(Craft, V3(20, 15, 1), CFrame*CN(5, 9, 15.5), "Medium stone grey", "DiamondPlate")
        local BackFront2 = part(Craft, V3(5, 15, 1), CFrame*CN(-12.5, 9, 15.5), "Medium stone grey", "DiamondPlate")
        local BackFront3 = part(Craft, V3(5, 6, 1), CFrame*CN(-7.5, 13.5, 15.5), "Medium stone grey", "DiamondPlate")
        --[[Curve(Craft, CFrame*CN(-7.5, 7, 15.5)*CA(-90, 0, 0), 2.75, 180, 5, 1.5, 0.95, "Medium stone grey", "DiamondPlate")
        CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(10, 1.5, 10)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
        CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(-10, 1.5, 10)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
        CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(10, 1.5, 20)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
        CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(-10, 1.5, 20)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
        CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(10, 1.5, 40)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")
        CrateTriangle(Craft, V3(3, 3, 3), CFrame*CN(-10, 1.5, 40)*CA(0, math.random(-180, 180), 0), "Brown", "Wood", "rbxassetid://67328263", "rbxassetid://67328263", "rbxassetid://67328263")]]
        --67328263
        --109085823
        --Ladder
        for L = 1, 10 do
                local LadderStep = part(Craft, V3(0.5, 4, 0.5), CFrame*CN(0, 0.75+L*1.5, 14)*CA(0, 0, 90), "Medium stone grey", "DiamondPlate")
                cylinder(LadderStep)
                local LadderStep2 = part(Craft, V3(0.5, 1, 0.5), LadderStep.CFrame*CN(0, 2, 0.5)*CA(90, 0, 0), "Medium stone grey", "DiamondPlate")
                cylinder(LadderStep2)
                local LadderStep3 = part(Craft, V3(0.5, 1, 0.5), LadderStep.CFrame*CN(0, -2, 0.5)*CA(90, 0, 0), "Medium stone grey", "DiamondPlate")
                cylinder(LadderStep3)
                local LadderStep4 = part(Craft, V3(0.5, 0.5, 0.5), LadderStep.CFrame*CN(0, 2, 0), "Medium stone grey", "DiamondPlate")
                mesh(LadderStep4, V3(1, 1, 1), "Sphere")
                local LadderStep5 = part(Craft, V3(0.5, 0.5, 0.5), LadderStep.CFrame*CN(0, -2, 0), "Medium stone grey", "DiamondPlate")
                mesh(LadderStep5, V3(1, 1, 1), "Sphere")
        end
        --Command Bridge
        local BridgeCeiling = part(Craft, V3(15, 1, 20), BackTop.CFrame*CN(7.5, 15.5, 3.5), "Medium stone grey", "DiamondPlate")
        local BridgeBack = part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -13.5, 10.5), "Medium stone grey", "DiamondPlate")
        local BridgeBackA = part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -1, 10.5), "Medium stone grey", "DiamondPlate")
        local BridgeBack2 = part(Craft, V3(1, 9.5, 1), BridgeBack.CFrame*CN(0, 6.25, 0), "Medium stone grey", "DiamondPlate")
        local BridgeBackWindow = part(Craft, V3(15, 9.5, 0.5), BridgeBack.CFrame*CN(0, 6.25, 0), "Navy blue", "SmoothPlastic", 0.75) BridgeBackWindow.Name = "Glass"
        decalFaces(BridgeBackWindow, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, "rbxassetid://67331799", 0.5)
        local BridgeFront = part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -13.5, -10.5), "Medium stone grey", "DiamondPlate")
        local BridgeFrontA = part(Craft, V3(15, 3, 1), BridgeCeiling.CFrame*CN(0, -1, -10.5), "Medium stone grey", "DiamondPlate")
        local BridgeFront2 = part(Craft, V3(1, 9.5, 1), BridgeFront.CFrame*CN(0, 6.25, 0), "Medium stone grey", "DiamondPlate")
        local BridgeFrontWindow = part(Craft, V3(15, 9.5, 0.5), BridgeFront.CFrame*CN(0, 6.25, 0), "Navy blue", "SmoothPlastic", 0.75) BridgeFrontWindow.Name = "Glass"
        decalFaces(BridgeFrontWindow, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, "rbxassetid://67331799", 0.5)
        local BridgeRight = part(Craft, V3(1, 3, 22), BridgeCeiling.CFrame*CN(8, -13.5, 0), "Medium stone grey", "DiamondPlate")
        local BridgeRightA = part(Craft, V3(1, 3, 22), BridgeCeiling.CFrame*CN(8, -1, 0), "Medium stone grey", "DiamondPlate")
        local BridgeRight2 = part(Craft, V3(1, 9.5, 1), BridgeRight.CFrame*CN(0, 6.25, 0), "Medium stone grey", "DiamondPlate")
        local BridgeRight3 = part(Craft, V3(1, 9.5, 1), BridgeRight.CFrame*CN(0, 6.25, -10.5), "Medium stone grey", "DiamondPlate")
        local BridgeRight4 = part(Craft, V3(1, 9.5, 1), BridgeRight.CFrame*CN(0, 6.25, 10.5), "Medium stone grey", "DiamondPlate")
        local BridgeRightWindow = part(Craft, V3(0.5, 9.5, 20), BridgeRight.CFrame*CN(0, 6.25, 0), "Navy blue", "SmoothPlastic", 0.75) BridgeRightWindow.Name = "Glass"
        decalFaces(BridgeRightWindow, {"Top", "Bottom", "Right", "Left", "Front", "Back"}, "rbxassetid://67331799", 0.5)
        local BridgeLeft = part(Craft, V3(1, 15.5, 8.5), BridgeCeiling.CFrame*CN(-8, -7.25, 6.75), "Medium stone grey", "DiamondPlate")
        local BridgeLeft2 = part(Craft, V3(1, 15.5, 8.5), BridgeCeiling.CFrame*CN(-8, -7.25, -6.75), "Medium stone grey", "DiamondPlate")
        local BridgeLeft3 = part(Craft, V3(1, 6.5, 5), BridgeCeiling.CFrame*CN(-8, -2.75, 0), "Medium stone grey", "DiamondPlate")
        --Curve(Craft, BridgeCeiling.CFrame*CN(-8, -9.5, 0)*CA(-90, 0, -90), 2.75, 180, 5, 1.5, 0.95, "Medium stone grey", "DiamondPlate")
        OfficeChair(Craft, BridgeCeiling.CFrame*CN(1.5, -15, -5)*CA(0, math.random(-15, 15), 0), "Black")
        local FrontDesk = Desk(Craft, BridgeCeiling.CFrame*CN(1.5, -15, -8)*CA(0, 180, 0), 10, 4, "Reddish brown", "Wood")
        Laptop(Craft, FrontDesk.CFrame*CN(-0.05, 0.5, 0), math.random(15, 75), "Medium stone grey")
        Laptop(Craft, FrontDesk.CFrame*CN(2.05, 0.5, 0), math.random(15, 75), "Black")
        PottedPlant(Craft, FrontDesk.CFrame*CN(7, -4, 0))
        StackOfPapers(Craft, FrontDesk.CFrame*CN(-3, 0.5, 0)*CA(0, math.random(-180, 180), 0), 2)
        Mug(Craft, FrontDesk.CFrame*CN(4, 0, 0), 1.5, "Black")
        local BackDesk = Desk(Craft, BridgeCeiling.CFrame*CN(0, -15, 8), 14, 4, "Reddish brown", "Wood")
        local Map = part(Craft, V3(3, 1, 3), BackDesk.CFrame*CN(0, 0.1, 0)*CA(0, math.random(-5, 5), 0), "Brick yellow", "Slate")
        decalFaces(Map, {"Top"}, "rbxassetid://20767941")
        Compass(Craft, BackDesk.CFrame*CN(2.5, 0.5, 0)*CA(0, 30, 0), 1)
        StackOfPapers(Craft, BackDesk.CFrame*CN(-4, 0.5, 0)*CA(0, math.random(-180, 180), 0), 2)
        RadioDish(Craft, BridgeCeiling.CFrame*CN(0, 0.5, 0), CA(45, 90, 0))
        --CrateTriangle(Craft, V3(20, 10, 10), CFrame*CN(0, 1.5, -15+15)*CA(0, math.random(-15, 15), 0), "Brown", "Wood", "rbxassetid://110093185", "rbxassetid://110093179", "rbxassetid://110093185") --Shipping container
        --ThumbnailPeeps(Craft, CFrame*CN(0, 1.5, -25))
        return Hull
end
function Dumpster(Parent, CFrame, Color, Material)
        local Dumpster = new'Model'{pt = Parent, nm = "Dumpster"}
        local DumpsterFloor = part(Dumpster, V3(17, 0.75, 27), CFrame*CN(0, 0.375, 0), Color, Material)
        local DumpsterFloor2 = part(Dumpster, V3(15, 0.5, 25), DumpsterFloor.CFrame*CN(0, 0.625, 0), Color, Material)
        local DumpsterEnd = part(Dumpster, V3(15, 5, 0.5), DumpsterFloor2.CFrame*CN(0, 0, 12.5)*CA(45, 0, 0)*CN(0, 2.5, 0), Color, Material)
        local DumpsterEnd2 = part(Dumpster, V3(15, 5, 0.5), DumpsterEnd.CFrame*CN(0, 2.5, 0)*CA(-45, 0, 0)*CN(0, 2.5, 0), Color, Material)
        local DumpsterEnd3 = part(Dumpster, V3(15, 5, 0.5), DumpsterFloor2.CFrame*CN(0, 0, -12.5)*CA(-45, 0, 0)*CN(0, 2.5, 0), Color, Material)
        local DumpsterEnd4 = part(Dumpster, V3(15, 5, 0.5), DumpsterEnd3.CFrame*CN(0, 2.5, 0)*CA(45, 0, 0)*CN(0, 2.5, 0), Color, Material)
        local TopEdgeFront = connect(Dumpster, (DumpsterEnd2.CFrame*CN(8.375, 2.5, 0)).p, (DumpsterEnd2.CFrame*CN(-8.375, 2.5, 0)).p, V2(0.75, 0.75), Color, Material)
        local TopEdgeBack = connect(Dumpster, (DumpsterEnd4.CFrame*CN(8.375, 2.5, 0)).p, (DumpsterEnd4.CFrame*CN(-8.375, 2.5, 0)).p, V2(0.75, 0.75), Color, Material)
        for A = -1, 1, 2 do
                local TopFace = connect(Dumpster, (DumpsterEnd2.CFrame*CN(A*7.25, 0, 0)).p, (DumpsterEnd4.CFrame*CN(A*7.25, 0, 0)).p, V2(0.5, 5), Color, Material)
                local TopEdge = connect(Dumpster, (DumpsterEnd2.CFrame*CN(A*7.625, 2.5, 0)).p, (DumpsterEnd4.CFrame*CN(A*7.625, 2.5, 0)).p, V2(1.5, 0.75), Color, Material)
                triangleConnect(Dumpster, {(DumpsterEnd.CFrame*CN(A*7.25, 2.5, 0)).p, (DumpsterEnd.CFrame*CN(A*7.25, -2.5, 0)).p, (DumpsterEnd3.CFrame*CN(A*7.25, 2.5, 0)).p}, 0.5, Color, Material)
                triangleConnect(Dumpster, {(DumpsterEnd3.CFrame*CN(A*7.25, 2.5, 0)).p, (DumpsterEnd3.CFrame*CN(A*7.25, -2.5, 0)).p, (DumpsterEnd.CFrame*CN(A*7.25, -2.5, 0)).p}, 0.5, Color, Material)
        end
        for A = -1, 1 do
                local Size = math.random(5, 8)
                Trashbags(Dumpster, DumpsterFloor2.CFrame*CN(0, 0.25, A*7)*CA(0, math.random(-180, 180), 0), V3(8, 8, 8))
        end
        arc(Dumpster, DumpsterFloor.CFrame*CN(-8.75, 9.25, -14.75)*CA(0, -90, 0), 0.5, 3, 180, V2(0.4, 0.4), "Medium stone grey", "DiamondPlate")
        arc(Dumpster, DumpsterFloor.CFrame*CN(8.75, 9.25, -14.75)*CA(0, 90, 0), 0.5, 3, 180, V2(0.4, 0.4), "Medium stone grey", "DiamondPlate")
        arc(Dumpster, DumpsterFloor.CFrame*CN(-8.75, 9.25, 14.75)*CA(0, -90, 0), 0.5, 3, 180, V2(0.4, 0.4), "Medium stone grey", "DiamondPlate")
        arc(Dumpster, DumpsterFloor.CFrame*CN(8.75, 9.25, 14.75)*CA(0, 90, 0), 0.5, 3, 180, V2(0.4, 0.4), "Medium stone grey", "DiamondPlate")
end
function Dumpster2(Parent, CFrame)
        local Dumpster = part(Parent, V3(12.5, 9, 6), CFrame*CN(0, 5.25, 0))
        mesh(Dumpster, V3(1.5, 1.5, 1.5), "FileMesh", DumpsterMesh, DumpsterTex)
        Dumpster.Name = "Green Dumpster"
        return Dumpster
end
function Trashbin(Parent, CFrame)
        local Trashbin = part(Parent, V3(3, 4, 3), CFrame*CN(0, 2.25, 0), "", "SmoothPlastic", 0, "cylinder")
        local Me = Mesh(Trashbin, "FileMesh", V3(3, 3, 3), TrashbinMesh, TrashbinTex)
        Me.VertexColor = V3(0.5, 0.5, 0.5)
        Trashbin.Name = "Trashbin"
        return Trashbin
end
 
function Dock(Parent, CFrame, PlankSize, NumberOfPlanks, Spacing, DockHeight, SupportSpacing, DockOffset, Randomness, Colors, Materials)
        local Dock = new'Model'{pt = Parent, nm = "Dock"}
        local DockLength = PlankSize.Z*NumberOfPlanks+Spacing*(NumberOfPlanks-1)
        local InvisiblePlatform = part(Dock, V3(PlankSize.X, 0.5, DockLength+PlankSize.Z*0.75), CFrame*CN(0, 0, -DockOffset*(DockLength/2+PlankSize.Z*0.375)), "", "SmoothPlastic", 1)
        local FirstPlank, LastPlank
        for D = 1, NumberOfPlanks do
                local Plank = part(Dock, PlankSize, CFrame*CN(0, 0, DockLength/2-DockOffset*DockLength/2-(PlankSize.Z+Spacing)*D)*CA(0, math.random(-Randomness, Randomness), 0), Colors[1], Materials[1])
                Plank.CanCollide = false
                if D%SupportSpacing == 0 then
                        local Support = part(Dock, V3(PlankSize.Z, DockHeight, PlankSize.Z), Plank.CFrame*CN(PlankSize.X/2-PlankSize.Z*0.5, -DockHeight/2, 0), Colors[2], Materials[2])
                        cylinder(Support)
                        local Support2 = part(Dock, V3(PlankSize.Z, DockHeight, PlankSize.Z), Plank.CFrame*CN(-PlankSize.X/2+PlankSize.Z*0.5, -DockHeight/2, 0), Colors[2], Materials[2])
                        cylinder(Support2)
                end
                if D == 1 then
                        FirstPlank = Plank
                elseif D == NumberOfPlanks then
                        LastPlank = Plank
                end
        end
        connect(Dock, (FirstPlank.CFrame*CN(PlankSize.X/2-PlankSize.Z*1.5, -PlankSize.Y, 0)).p, (LastPlank.CFrame*CN(PlankSize.X/2-PlankSize.Z*1.5, -PlankSize.Y, 0)).p, V2(PlankSize.Z, PlankSize.Y), Colors[3], Materials[3])
        connect(Dock, (FirstPlank.CFrame*CN(-PlankSize.X/2+PlankSize.Z*1.5, -PlankSize.Y, 0)).p, (LastPlank.CFrame*CN(-PlankSize.X/2+PlankSize.Z*1.5, -PlankSize.Y, 0)).p, V2(PlankSize.Z, PlankSize.Y), Colors[3], Materials[3])
        connect(Dock, (FirstPlank.CFrame*CN(0, -PlankSize.Y, 0)).p, (LastPlank.CFrame*CN(0, -PlankSize.Y, 0)).p, V2(PlankSize.Z, PlankSize.Y), Colors[3], Materials[3])
        
        return Dock
end
 
function Crate(PT, SZ, CF, BN, MT, TB, RL, FB)
        local thing = part(PT, SZ, CF*CN(0, SZ.Y/2, 0), BN, MT)
        if TB then
                decalFaces(thing, {"Top", "Bottom"}, TB)
        end
        if RL then
                decalFaces(thing, {"Right", "Left"}, RL)
        end
        if FB then
                decalFaces(thing, {"Front", "Back"}, FB)
        end
        return thing
end
function CrateTriangle(PT, SZ, CF, BN, MT, TB, RL, FB)
        local Triangle = New'Model'{pt = PT, nm = "Crate Triangle"}
        local Av = (SZ.X+SZ.Z)/2
        if SZ.Z>SZ.X then
                Crate(Triangle, SZ, CF*CN(Av*0.625, 0, 0)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
                Crate(Triangle, SZ, CF*CN(-Av*0.625, 0, 0)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
                Crate(Triangle, SZ, CF*CN(0, SZ.Y, 0)*CA(0, 90+math.random(-15, 15), 0), BN, MT, TB, RL, FB)
        else
                Crate(Triangle, SZ, CF*CN(0, 0, Av*0.625)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
                Crate(Triangle, SZ, CF*CN(0, 0, -Av*0.625)*CA(0, math.random(-15, 15), 0), BN, MT, TB, RL, FB)
                Crate(Triangle, SZ, CF*CN(0, SZ.Y, 0)*CA(0, 90+math.random(-15, 15), 0), BN, MT, TB, RL, FB)
        end
end
function CoverWall(Parent, CFrame, Size, Radius, Angle, Height, Width, BrickColor, Material)
        local WallOfCover = new'Model'{pt = Parent, nm = "Cover Wall"}
        for H = 0, Height-1 do
                for C = -Width/2+H, Width/2-H do
                        part(WallOfCover, Size, CFrame*CA(0, C*Angle/Width, 0)*CN(0, H*Size.Y, Radius)*CA(math.random(-15, 15), math.random(-15, 15), 0), BrickColor, Material)
                end
        end
        return WallOfCover
end
 
function Turret(Parent, CFrame, Angle, Angle2)
        local Turret = new'Model'{pt = Parent, nm = "Anti-aircraft gun"}
        local TurretBase = part(Turret, V3(30, 20, 30), CFrame*CN(0, 10, 0), "Dark stone grey", "Concrete")
        for S = 1, 4 do
                for T = 0, 6 do
                        local TurretBaseD = wedge(Turret, V3(2, 20, 7), TurretBase.CFrame*CA(0, S*90, 0)*CN(-12+T*4, 0, -18.5), "Dark stone grey", "Concrete")
                end
        end
        local TurretBase2 = part(Turret, V3(25, 1, 25), TurretBase.CFrame*CN(0, 10.5, 0), "Dark stone grey", "Concrete")
        local TurretBase2A = part(Turret, V3(22.5, 2, 22.5), TurretBase2.CFrame*CN(0, 1.5, 0), "Dark stone grey", "Concrete")
        cylinder(TurretBase2A)
        local TurretBase2B = part(Turret, V3(20, 2, 20), TurretBase2A.CFrame*CN(0, 2, 0), "Dark stone grey", "Concrete")
        cylinder(TurretBase2B)
        
        local GunModel = new'Model'{pt = Turret, nm = "Just the Gun Part"}
        
        local GunBase = part(GunModel, V3(22, 1, 28), TurretBase2B.CFrame*CN(0, 1.5, 0)*CA(0, Angle, 0), "Dark stone grey", "Concrete")
        local GunMiddle = part(GunModel, V3(15, 8, 24), GunBase.CFrame*CN(0, 4.5, 2), "Dark stone grey", "Concrete")
        
        local GunRight = part(GunModel, V3(3.5, 8, 26), GunBase.CFrame*CN(9.25, 4.5, 1), "Dark stone grey", "Concrete")
        local GunRightA = wedge(GunModel, V3(3.5, 8, 2), GunRight.CFrame*CN(0, 0, -14), "Dark stone grey", "Concrete")
        local GunLeft = part(GunModel, V3(3.5, 8, 26), GunBase.CFrame*CN(-9.25, 4.5, 1), "Dark stone grey", "Concrete")
        local GunLeftA = wedge(GunModel, V3(3.5, 8, 2), GunLeft.CFrame*CN(0, 0, -14), "Dark stone grey", "Concrete")
        local GunBetween = part(GunModel, V3(3, 8, 2), GunMiddle.CFrame*CN(0, 0, -13), "Dark stone grey", "Concrete")
        local GunBetweenA = wedge(GunModel, V3(3, 8, 2), GunBetween.CFrame*CN(0, 0, -2), "Dark stone grey", "Concrete")
        
        for G = 0, 1 do
                local BarrelConnect = part(GunModel, V3(4, 4, 4), GunMiddle.CFrame*CN(-4.5+G*9, 0, -12.5), "Dark stone grey", "Concrete")
                mesh(BarrelConnect, V3(1, 1, 1), "Sphere")
                local BarrelRamp = wedge(GunModel, V3(6, 8, 2), BarrelConnect.CFrame*CN(0, 0, -0.5), "Dark stone grey", "Concrete")
                
                local GunBarrel = part(GunModel, V3(4.5, 8, 4.5), BarrelConnect.CFrame*CA(-90+Angle2, 0, 0)*CN(0, 4, 0), "Dark stone grey", "Concrete")
                cylinder(GunBarrel)
                local GunBarrel2 = part(GunModel, V3(3, 8, 3), GunBarrel.CFrame*CN(0, 8, 0), "Dark stone grey", "Concrete")
                cylinder(GunBarrel2)
                local GunBarrel3 = part(GunModel, V3(2.5, 6, 2.5), GunBarrel2.CFrame*CN(0, 7, 0), "Dark stone grey", "Concrete")
                cylinder(GunBarrel3)
                local GunBarrel4 = part(GunModel, V3(3, 2, 3), GunBarrel3.CFrame*CN(0, 4, 0), "Dark stone grey", "Concrete")
                cylinder(GunBarrel4)
                local GunBarrelExit = part(GunModel, V3(2, 1, 2), GunBarrel4.CFrame*CN(0, 0.55, 0), "Really black")
                cylinder(GunBarrelExit)
        end
        
        --convertToWelds(GunModel, TurretBase2B.CFrame, nil)
end
function Hangar(PT, CF, SZ, HT, BC, MT)
        local Hangar = new'Model'{pt = PT, nm = "Hangar"}
        local Length = SZ*1.25
        local HangarBase = part(Hangar, V3(SZ, 1, Length), CF, BC, MT)
        local HangarRight = part(Hangar, V3(1, HT, Length), CF*CN(-SZ/2+0.5, HT/2+.5, 0), BC, MT)
        local HangarLeft = part(Hangar, V3(1, HT, Length), CF*CN(SZ/2-0.5, HT/2+0.5, 0), BC, MT)
        local HangarCeiling = part(Hangar, V3(SZ, 1, Length), CF*CN(0, HT+1, 0), BC, MT)
        local HangarCeiling2 = part(Hangar, V3(SZ/2, HT/2, Length), CF*CN(0, HT*1.25+1.5, 0), BC, MT)
        local HangarRight2 = wedge(Hangar, V3(Length, HT+2, SZ/4), CF*CN(-SZ/2-SZ/8, HT/2+0.5, 0)*CA(0, 90, 0), BC, MT)
        local HangarRight3 = wedge(Hangar, V3(Length, HT/2, SZ/4), CF*CN(-SZ/2+SZ/8, HT*1.25+1.5, 0)*CA(0, 90, 0), BC, MT)
        local HangarLeft2 = wedge(Hangar, V3(Length, HT+2, SZ/4), CF*CN(SZ/2+SZ/8, HT/2+0.5, 0)*CA(0, -90, 0), BC, MT)
        local HangarLeft3 = wedge(Hangar, V3(Length, HT/2, SZ/4), CF*CN(SZ/2-SZ/8, HT*1.25+1.5, 0)*CA(0, -90, 0), BC, MT)
        local EntranceSideRight = part(Hangar, V3(10, HT, 1), CF*CN(-SZ/2+6, HT/2+0.5, Length/2-0.5), BC, MT)
        local EntranceSideRight2 = part(Hangar, V3(10, HT, 1), CF*CN(-SZ/2+6, HT/2+0.5, -Length/2+0.5), BC, MT)
        local EntranceSideLeft = part(Hangar, V3(10, HT, 1), CF*CN(SZ/2-6, HT/2+0.5, Length/2-0.5), BC, MT)
        local EntranceSideLeft2 = part(Hangar, V3(10, HT, 1), CF*CN(SZ/2-6, HT/2+0.5, -Length/2+0.5), BC, MT)
        return Hangar
end
 
function HotAirBalloon(Parent, CFrame, ColorType, NormalColors, Colors, ColorMethod, rt)
        local Balloon = new'Model'{pt = Parent, nm = "Hot Air Balloon"}
        --Basket
        local BasketFloor = part(Balloon, V3(8, 1, 8), CFrame*CN(0, 0.5, 0), NormalColors[1], "Wood")
        local BasketFloor2 = part(Balloon, V3(6, 1, 6), BasketFloor.CFrame*CN(0, 0.2, 0), NormalColors[2], "Wood")
        cylinder(BasketFloor2)
        decalFaces(BasketFloor2, {"Top"}, "rbxassetid://114351360")
        for S = 1, 4 do
                local BasketWall = part(Balloon, V3(6, 4, 0.5), BasketFloor.CFrame*CA(0, S*90, 0)*CN(0, 2, -3.75), NormalColors[1], "Wood")
                local BasketWallCorner = part(Balloon, V3(1.5, 4, 1.5), BasketWall.CFrame*CN(3.75, 0, 0), NormalColors[3], "Wood")
                cylinder(BasketWallCorner)
                local String = connect(Balloon, (BasketWallCorner.CFrame*CN(0, 2, 0)).p, (BasketFloor.CFrame*CA(0, S*90-45, 0)*CN(0, 14, -6)).p, V2(0.25, 0.25), NormalColors[5])
                String.CanCollide = false
                --local String2 = ConnectPoints(Balloon, String.CFrame, BasketFloor.CFrame*CA(0, S*90-45, 0)*CN(0, 14, 6), 0.25, 0.25, "White")
                --String2.CanCollide = false
                local StringConnectPointInLip = part(Balloon, V3(0.75, 0.75, 0.75), BasketFloor.CFrame*CA(0, S*90+45, 0)*CN(0, 14, 6), NormalColors[6], "Wood")
                local BasketWall2 = part(Balloon, V3(7.5, 4, 0.5), BasketWall.CFrame*CN(0, 0, -0.5), NormalColors[3], "Wood")
        end
        --I KNOW I COULD HAVE MADE THIS INTO A FOR LOOP >:(
        
 
        
        local rt = rt or {15, 30, 45, 60, 75, 90}
        
        local Lip = arc(Balloon, BasketFloor.CFrame*CN(0, 14, 0), 6, 20, 360, V2(1, 1), NormalColors[4], "Wood"):GetChildren()
        local Level1 = arc(Balloon, BasketFloor.CFrame*CN(0, 18, 0)*CA(0, rt[1], 0), 7, 20, 360, V2(1, 1), NormalColors[5]):GetChildren()
        local Level2 = arc(Balloon, BasketFloor.CFrame*CN(0, 28, 0)*CA(0, rt[2], 0), 14, 20, 360, V2(1, 1), NormalColors[5]):GetChildren()
        local Level3 = arc(Balloon, BasketFloor.CFrame*CN(0, 53, 0)*CA(0, rt[3], 0), 28, 20, 360, V2(1, 1), NormalColors[5]):GetChildren()
        local Level4 = arc(Balloon, BasketFloor.CFrame*CN(0, 78, 0)*CA(0, rt[4], 0), 35, 20, 360, V2(1, 1), NormalColors[5]):GetChildren()
        local Level5 = arc(Balloon, BasketFloor.CFrame*CN(0, 92, 0)*CA(0, rt[5], 0), 28, 20, 360, V2(1, 1), NormalColors[5]):GetChildren()
        local Level6 = arc(Balloon, BasketFloor.CFrame*CN(0, 107, 0)*CA(0, rt[6], 0), 7, 20, 360, V2(1, 1), NormalColors[5]):GetChildren()
        for C = 1, 20 do
                local Lip1 = triangleConnect(Balloon, {(Lip[C].CFrame*CN(-Lip[C].Size.X/2, 0, 0)).p, (Level1[C].CFrame*CN(-Level1[C].Size.X/2, 0, 0)).p, (Level1[C].CFrame*CN(Level1[C].Size.X/2, 0, 0)).p}, 0, Colors[1], "SmoothPlastic", 0, true)
                local Lip2 = triangleConnect(Balloon, {(Lip[C].CFrame*CN(-Lip[C].Size.X/2, 0, 0)).p, (Lip[C].CFrame*CN(Lip[C].Size.X/2, 0, 0)).p, (Level1[C].CFrame*CN(Level1[C].Size.X/2, 0, 0)).p}, 0, Colors[1], "SmoothPlastic", 0, true)
                local Level1A = triangleConnect(Balloon, {(Level1[C].CFrame*CN(-Level1[C].Size.X/2, 0.5, 0)).p, (Level2[C].CFrame*CN(-Level2[C].Size.X/2, -0.5, 0)).p, (Level2[C].CFrame*CN(Level2[C].Size.X/2, -0.5, 0)).p}, 0, Colors[2%#Colors] or Colors[#Colors%2] or Colors[2], "SmoothPlastic", 0, true)
                local Level1B = triangleConnect(Balloon, {(Level1[C].CFrame*CN(-Level1[C].Size.X/2, 0.5, 0)).p, (Level1[C].CFrame*CN(Level1[C].Size.X/2, 0.5, 0)).p, (Level2[C].CFrame*CN(Level2[C].Size.X/2, -0.5, 0)).p}, 0, Colors[2%#Colors] or Colors[#Colors%2] or Colors[2], "SmoothPlastic", 0, true)
                local Level2A = triangleConnect(Balloon, {(Level2[C].CFrame*CN(-Level2[C].Size.X/2, 0.5, 0)).p, (Level3[C].CFrame*CN(-Level3[C].Size.X/2, -0.5, 0)).p, (Level3[C].CFrame*CN(Level3[C].Size.X/2, -0.5, 0)).p}, 0, Colors[3%#Colors] or Colors[#Colors%3] or Colors[3], "SmoothPlastic", 0, true)
                local Level2B = triangleConnect(Balloon, {(Level2[C].CFrame*CN(-Level2[C].Size.X/2, 0.5, 0)).p, (Level2[C].CFrame*CN(Level2[C].Size.X/2, 0.5, 0)).p, (Level3[C].CFrame*CN(Level3[C].Size.X/2, -0.5, 0)).p}, 0, Colors[3%#Colors] or Colors[#Colors%3] or Colors[3], "SmoothPlastic", 0, true)
                local Level3A = triangleConnect(Balloon, {(Level3[C].CFrame*CN(-Level3[C].Size.X/2, 0.5, 0)).p, (Level4[C].CFrame*CN(-Level4[C].Size.X/2, -0.5, 0)).p, (Level4[C].CFrame*CN(Level4[C].Size.X/2, -0.5, 0)).p}, 0, Colors[4%#Colors] or Colors[#Colors%4] or Colors[4], "SmoothPlastic", 0, true)
                local Level3B = triangleConnect(Balloon, {(Level3[C].CFrame*CN(-Level3[C].Size.X/2, 0.5, 0)).p, (Level3[C].CFrame*CN(Level3[C].Size.X/2, 0.5, 0)).p, (Level4[C].CFrame*CN(Level4[C].Size.X/2, -0.5, 0)).p}, 0, Colors[4%#Colors] or Colors[#Colors%4] or Colors[4], "SmoothPlastic", 0, true)
                local Level4A = triangleConnect(Balloon, {(Level4[C].CFrame*CN(-Level4[C].Size.X/2, 0.5, 0)).p, (Level5[C].CFrame*CN(-Level5[C].Size.X/2, -0.5, 0)).p, (Level5[C].CFrame*CN(Level5[C].Size.X/2, -0.5, 0)).p}, 0, Colors[5%#Colors] or Colors[#Colors%5] or Colors[5], "SmoothPlastic", 0, true)
                local Level4B = triangleConnect(Balloon, {(Level4[C].CFrame*CN(-Level4[C].Size.X/2, 0.5, 0)).p, (Level4[C].CFrame*CN(Level4[C].Size.X/2, 0.5, 0)).p, (Level5[C].CFrame*CN(Level5[C].Size.X/2, -0.5, 0)).p}, 0, Colors[5%#Colors] or Colors[#Colors%5] or Colors[5], "SmoothPlastic", 0, true)
                local Level5A = triangleConnect(Balloon, {(Level5[C].CFrame*CN(-Level5[C].Size.X/2, 0.5, 0)).p, (Level6[C].CFrame*CN(-Level6[C].Size.X/2, -0.5, 0)).p, (Level6[C].CFrame*CN(Level6[C].Size.X/2, -0.5, 0)).p}, 0, Colors[6%#Colors] or Colors[#Colors%6] or Colors[6], "SmoothPlastic", 0, true)
                local Level5B = triangleConnect(Balloon, {(Level5[C].CFrame*CN(-Level5[C].Size.X/2, 0.5, 0)).p, (Level5[C].CFrame*CN(Level5[C].Size.X/2, 0.5, 0)).p, (Level6[C].CFrame*CN(Level6[C].Size.X/2, -0.5, 0)).p}, 0, Colors[6%#Colors] or Colors[#Colors%6] or Colors[6], "SmoothPlastic", 0, true)
                if ColorMethod == 1 then
                        ColorModel(Lip1, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Lip2, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level1A, Colors[C%#Colors+1] or Colors[1])
                        ColorModel(Level1B, Colors[C%#Colors+1] or Colors[1])
                        ColorModel(Level2A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level2B, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level3A, Colors[C%#Colors+1] or Colors[1])
                        ColorModel(Level3B, Colors[C%#Colors+1] or Colors[1])
                        ColorModel(Level4A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level4B, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level5A, Colors[C%#Colors+1] or Colors[1])
                        ColorModel(Level5B, Colors[C%#Colors+1] or Colors[1])
                elseif ColorMethod == 2 then
                        Lip1:GetChildren()[1].BrickColor = BN(Colors[2%#Colors] or Colors[#Colors%2] or Colors[2])
                        Lip1:GetChildren()[2].BrickColor = BN(Colors[1])
                        Lip2:GetChildren()[1].BrickColor = BN(Colors[2%#Colors] or Colors[#Colors%2] or Colors[2])
                        Lip2:GetChildren()[2].BrickColor = BN(Colors[1])
                        Level1A:GetChildren()[1].BrickColor = BN(Colors[4%#Colors] or Colors[#Colors%4] or Colors[4])
                        Level1A:GetChildren()[2].BrickColor = BN(Colors[3%#Colors] or Colors[#Colors%3] or Colors[3])
                        Level1B:GetChildren()[1].BrickColor = BN(Colors[4%#Colors] or Colors[#Colors%4] or Colors[4])
                        Level1B:GetChildren()[2].BrickColor = BN(Colors[3%#Colors] or Colors[#Colors%3] or Colors[3])
                        Level2A:GetChildren()[1].BrickColor = BN(Colors[6%#Colors] or Colors[#Colors%6] or Colors[6])
                        Level2A:GetChildren()[2].BrickColor = BN(Colors[5%#Colors] or Colors[#Colors%5] or Colors[5])
                        Level2B:GetChildren()[1].BrickColor = BN(Colors[6%#Colors] or Colors[#Colors%6] or Colors[6])
                        Level2B:GetChildren()[2].BrickColor = BN(Colors[5%#Colors] or Colors[#Colors%5] or Colors[5])
                        Level3A:GetChildren()[1].BrickColor = BN(Colors[8%#Colors] or Colors[#Colors%8] or Colors[8])
                        Level3A:GetChildren()[2].BrickColor = BN(Colors[7%#Colors] or Colors[#Colors%7] or Colors[7])
                        Level3B:GetChildren()[1].BrickColor = BN(Colors[8%#Colors] or Colors[#Colors%8] or Colors[8])
                        Level3B:GetChildren()[2].BrickColor = BN(Colors[7%#Colors] or Colors[#Colors%7] or Colors[7])
                        Level4A:GetChildren()[1].BrickColor = BN(Colors[10%#Colors] or Colors[#Colors%10] or Colors[10])
                        Level4A:GetChildren()[2].BrickColor = BN(Colors[9%#Colors] or Colors[#Colors%9] or Colors[9])
                        Level4B:GetChildren()[1].BrickColor = BN(Colors[10%#Colors] or Colors[#Colors%10] or Colors[10])
                        Level4B:GetChildren()[2].BrickColor = BN(Colors[9%#Colors] or Colors[#Colors%9] or Colors[9])
                        Level5A:GetChildren()[1].BrickColor = BN(Colors[12%#Colors] or Colors[#Colors%12] or Colors[12])
                        Level5A:GetChildren()[2].BrickColor = BN(Colors[11%#Colors] or Colors[#Colors%11] or Colors[11])
                        Level5B:GetChildren()[1].BrickColor = BN(Colors[12%#Colors] or Colors[#Colors%12] or Colors[12])
                        Level5B:GetChildren()[2].BrickColor = BN(Colors[11%#Colors] or Colors[#Colors%11] or Colors[11])
                elseif ColorMethod == 3 then
                        ColorModel(Lip1, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Lip2, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level1A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level1B, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level2A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level2B, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level3A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level3B, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level4A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level4B, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level5A, Colors[C%#Colors] or Colors[#Colors])
                        ColorModel(Level5B, Colors[C%#Colors] or Colors[#Colors])
                end
        end
        return Balloon, BasketFloor
end
 
function ammoBox(pt, cf)
        local theBox = new'Model'{pt = pt, nm = "Ammo Box"}
        local crate = part(theBox, V3(8, 5, 3), cf, "Medium stone grey", "DiamondPlate")
        local sGuiF = new'SurfaceGui'{pt = crate, Face = "Front"}
                tLabel(sGuiF, "AMMO", 160, C3())
        return theBox
end
 
--[[player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")
mouse = player:GetMouse()
 
playerGui:SetTopbarTransparency(0)
 
character = player.Character
 
character.Humanoid.JumpPower = 100
character.Humanoid.WalkSpeed = 49
 
for i, v in pairs(character:GetChildren()) do
        if v:IsA("LocalScript") and v ~= script then
                v.Disabled = true
                v:Destroy()
        end
end
 
UIS = Game:GetService("UserInputService")
 
for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "Cheesecake" then
                gui:Destroy()
        end
end]]
 
--[[
        
        when the player opens the game, they will be presented with a menu of choices. These choices include... "Just Play", "Customize", and "Buy", "Quit", "Options".
        The customization is categorized into... "Cosmetics", "Mods", and "Equipment".
        The "buy" option brings up a menu with clear options of what to buy... "Equipment", "Mods", "Cosmetics". These individual things can also be linked in the customization screen to their respective buying places.
        the "Just Play" option will automatically send the player onto one of two teams, and let them choose (maybe) where they will be spawning, kinda like Battlefront?
        The customization screen will also have a part which displays the equipment which is currently "equipped" on the character.
        
        The gameplay itself will have to be both fast-paced, but also easy to ease into. 
        
]]
 
 
--[[theTitle = "War Blox II"
 
GUI = new'ScreenGui'{pt = playerGui, nm = "Cheesecake"}
 
screenSize = GUI.AbsoluteSize
 
--Main Frame
mainFrame = frame(GUI, U2(1, 0, 1, 0), U2(), C3(0.4, 0.4, 0.4), 1)
 
--Title
for t = 1, 3 do
        tLabel(mainFrame, theTitle, 48, C3(1, 0.5, 0.25), U2(1, 0, 0, 100), U2(0, -t, 0, 50-t))
        tLabel(mainFrame, theTitle, 48, C3(0.25, 0.5, 1), U2(1, 0, 0, 100), U2(0, t, 0, 50-t))
end
 
mainTitle = tLabel(mainFrame, theTitle, 48, C3(1.25, 1, 1.25), U2(1, 0, 0, 100), U2(0, 0, 0, 50))
        tSize = mainTitle.TextBounds --the size of the title's text
]]
 
Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)
Lighting.Ambient = Color3.new(1, 1, 1)
 
for _, thing in pairs(Lighting:GetChildren()) do
        if thing:IsA("Sky") then
                thing:Destroy()
        end
end
 
--[[Sky = new'Sky'{
        pt = Lighting,
        CelestialBodiesShown = false,
        SkyboxBk = "rbxassetid://55054494",
        SkyboxDn = "rbxassetid://55054494",
        SkyboxFt = "rbxassetid://55054494",
        SkyboxLf = "rbxassetid://55054494",
        SkyboxRt = "rbxassetid://55054494",
        SkyboxUp = "rbxassetid://55054494"
}]]

Sky = new'Sky'{
        pt = Lighting,
        CelestialBodiesShown = false,
        SkyboxBk = "rbxassetid://323494035",
        SkyboxDn = "rbxassetid://323494368",
        SkyboxFt = "rbxassetid://323494130",
        SkyboxLf = "rbxassetid://323494252",
        SkyboxRt = "rbxassetid://323494067",
        SkyboxUp = "rbxassetid://323493360"
}
 
 
offset = CN(0, 100, 0)
 
decorColor = "Royal purple"
decorMaterial = "Neon"
 
domeColor = "Dark stone grey"
domeMaterial = "SmoothPlastic"
 
 
for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "War Blox Lobby" then
                obj:Destroy()
        end
end
 
lobby = new'Model'{pt = Workspace, nm = "War Blox Lobby"}
 
--mainPlatform = part(lobby, V3(150, 1, 150), offset*CN(0, 0, 0), "Medium stone grey", "SmoothPlastic", 1)
 
 
floor = arc(lobby, offset*CA(0, 180, 0), 20, 12, 360, V2(30, 1), "Dark stone grey", "SmoothPlastic", 0, nil, 0.05)
 
--underneathFloor = arc(lobby, offset*CN(0, -1, 0)*CA(0, 180, 0), 0, 12, 360, V2(50, 1), "Brick yellow", "Slate", 0, nil, 0.05)
 
sand = part(lobby, V3(1, 100, 100), offset*CN(0, -1, 0)*CA(0, 0, 90), "Brick yellow", "Sand", 0, "Cylinder")
 
water = part(lobby, V3(60, 0.5, 60), offset*CN(0, 0, 0), "Cyan", "Granite", 0.4)
water.CanCollide = false
 
secondCenter = offset*CN(0, 0, -139-30)
 
--floor2 = arc(lobby, secondCenter*CN(0, -1, 0), 0, 12, 360, V2(80, 3), "Dark stone grey", "Granite", 0, nil, 0.05)
 
floor2 = part(lobby, V3(3, 160+10, 160+10), secondCenter*CN(0, -1, 0)*CA(0, 0, 90), "Dark stone grey", "Granite", 0, "Cylinder")
 
floorConnection = part(lobby, V3(24, 1, 42), offset*CN(0, 0.05, -49.5-20), "Dark stone grey", "Concrete")
 
 
local BarkColors = {"Fawn brown", "Bronze", "Cork", "Nougat", "Burlap", "Pastel brown"}
local LeafColors = {"Grime", "Artichoke", "Olivine", "Medium green", "Moss", "Shamrock"}
local BranchColors = {"Pine Cone", "Fawn brown", "Bronze", "Dark taupe", "Flint", "Brown", "Cork", "Nougat", "Cashmere", "Burlap", "Beige", "Pastel brown"}
local SizeX, SizeY = math.random(20, 50)/10, math.random(40, 100)/10
 
--PalmTree(pt, CFrame, Segments, Modifier, StartSize, StartAngle, Leaves, LeafSegments, LeafSegmentModifier, LeafStartSize, LeafStartAngle, LeafStartVariation, ExtensionsPerLeaf, Colors, Materials)
PalmTree(lobby, offset*CN(0, 2, 0), 7, V3(-0.2, -0.1, -0.2), V3(SizeX, SizeY, SizeX), {math.random(-7, 7), math.random(-7, 7), math.random(-7, 7)}, 8, 21, V3(-0.05, 0, -0.05), V3(1, 1.5, 0.75), {16, -3, 2}, {16, 3, 3}, 6, {BarkColors[math.random(1, #BarkColors)], BranchColors[math.random(1, #BranchColors)], LeafColors[math.random(1, #LeafColors)]}, {"Slate", "Grass", "Slate"})
 
arc(lobby, offset*CN(0, 1.35, 0), 7, 12, 360, V2(1, 4), "Smoky grey", "Concrete", 0, nil, 0.02)
arc(lobby, offset*CN(0, 0.5, 0), 8, 12, 360, V2(2, 2), "Smoky grey", "Concrete", 0, nil, 0.02)
 
part(lobby, V3(1, 16, 16), offset*CN(0, 2.75, 0)*CA(0, 0, 90), "Cashmere", "Sand", 0, "Cylinder")
 
for l = 0, 3 do
for b = 1, 60+l*3 do
        local colors = {"Copper", "Linen", "Sand red", "Hurricane grey"}
        local brick3 = part(lobby, V3(2, 1, 1), offset*CA(0, b*360/(60+l*3), 0)*CN(0, 0.3, 20+l)*CA(0, math.random(-4, 4), 0)*CN(0, -math.random(0, 100)/1000, 0), colors[math.random(1, #colors)], "Slate")
        --local brickMortar = part(lobby, V3(2.2, 1, 1.2), brick3.CFrame*CN(0, -0.1, 0.2), "Bright yellow", "Metal")
end
end
 
for l = 0, 23 do
        for b = 1, 69+l*3 do
                --if l~= 23 then
                        local colors = {"Fossil", "Ghost grey", "Light stone grey", "Medium stone grey"}
                        local brick3 = part(lobby, V3(2, 1, 1), offset*CA(0, b*360/(69+l*3)+math.sin(l*6^2)*6, 0)*CN(0, 0.3, 24+l)*CA(0, math.random(-4, 4), 0)*CN(0, 0-math.random(0,100)/1000, 0), colors[math.random(1, #colors)], "Slate")
                        --local brickMortar = part(lobby, V3(2.2, 1, 1.2), brick3.CFrame*CN(0, -0.1, -0.2), "Bright yellow", "Metal")
                --else
                        --local colors = {"Fossil", "Ghost grey", "Light stone grey", "Medium stone grey"}
                        --local brick3 = part(lobby, V3(2.25, 1.25, 1.25), offset*CA(0, b*360/(69+l*3), 0)*CN(0, 0.3, 24+l)*CA(0, math.random(-4, 4), 0)*CN(0, 0-math.random(0,100)/1000, 0), colors[b%5+1], "Metal")
                        --local brickMortar = part(lobby, V3(2.2, 1, 1.2), brick3.CFrame*CN(0, -0.1, -0.2), "Bright yellow", "Metal")
                --end
        end
end
 
brickMortar = arc(lobby, offset*CN(0, 0.1, 0), 19.75, 20, 360, V2(28, 1), "Brick yellow", "Slate")
 
--walls
walls = arc(lobby, offset*CN(0, 15.5, 0), 49, 12, 360, V2(1, 30), "Dove blue", "Marble", 0.7)
walls:GetChildren()[1]:Destroy()
 
--supports
for c = -6, 5 do
        local support = part(lobby, V3(3, 32, 3), offset*CA(0, (c+0.5)*30, 0)*CN(0, 14.5, 51), domeColor, domeMaterial)
        --decor
        part(lobby, V3(2, 31, 3+0.4), support.CFrame, decorColor, decorMaterial)
        
        
        local supportBase = part(lobby, V3(5, 4, 5), support.CFrame*CN(0, -14, 0), decorColor, decorMaterial)
        
        local supportBaseDecor = part(lobby, V3(6, 3.5, 6), support.CFrame*CN(0, -14, 0), domeColor, domeMaterial)
end
 
--DOME
domeArches = {}
 
for c = -3, 2 do
        local arch = arc(lobby, offset*CA(0, (c+0.5)*30, 0)*CN(0, 42.25, 0)*CA(-90, 0, 0), 50, 7, 180, V2(2, 2), domeColor, domeMaterial)
        table.insert(domeArches, arch)
        --decor
        arc(lobby, offset*CA(0, (c+0.5)*30, 0)*CN(0, 42.25, 0)*CA(-90, 0, 0), 50-0.2, 7, 180, V2(2.4, 1), decorColor, decorMaterial)
end
 
for a, arch in pairs(domeArches) do
        recurse(arch, function(p, i)
                if domeArches[a+1] then
                        local nextArch = domeArches[a+1]:GetChildren()
                        triangleConnect(lobby, {
                                (nextArch[i].CFrame*CN(-nextArch[i].Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(-p.Size.X/2, 0, 0)).p
                        }, 0, "Dove blue", "Marble", 0.7, true)
                        triangleConnect(lobby, {
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (nextArch[i].CFrame*CN(nextArch[i].Size.X/2, 0, 0)).p,
                                (nextArch[i].CFrame*CN(-nextArch[i].Size.X/2, 0, 0)).p
                        }, 0, "Dove blue", "Marble", 0.7, true)
                else
                        local firstArch = domeArches[1]:GetChildren()
                        local i = #firstArch-i+1
                        triangleConnect(lobby, {
                                (firstArch[i].CFrame*CN(-firstArch[i].Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(-p.Size.X/2, 0, 0)).p
                        }, 0, "Dove blue", "Marble", 0.7, true)
                        triangleConnect(lobby, {
                                (p.CFrame*CN(-p.Size.X/2, 0, 0)).p,
                                (firstArch[i].CFrame*CN(firstArch[i].Size.X/2, 0, 0)).p,
                                (firstArch[i].CFrame*CN(-firstArch[i].Size.X/2, 0, 0)).p
                        }, 0, "Dove blue", "Marble", 0.7, true)
                end
        end)
end
 
local theThings = domeArches[1]:GetChildren()
for b = 2, #theThings-1 do
        local thisPos = theThings[b].CFrame*CN(theThings[b].Size.X/2, 0, 0)
        local dist = (thisPos.p-V3(offset.X, thisPos.Y, offset.Z)).magnitude
        local thisArc = arc(lobby, CN(offset.X, thisPos.Y, offset.Z), dist-b/3, 12, 360, V2(b/3, b/3), domeColor, domeMaterial)
        recurse(thisArc, function(p)
                p.CFrame = p.CFrame*CA(b*360/7*2, 0, 0)
        end)
        --decor
        arc(lobby, CN(offset.X, thisPos.Y, offset.Z), dist-b/3-0.2, 12, 360, V2(b/3+0.4, b/3/2), decorColor, decorMaterial)
end
 
--archway
arc(lobby, offset*CN(0, 15, -49.5-20)*CA(-90, 0, 0), 15, 7, 90, V2(3, 43), domeColor, domeMaterial)
 
--above-door border
arc(lobby, offset*CN(0, 32, 0), 47.75, 12, 360, V2(3, 3), domeColor, domeMaterial)
--decor
arc(lobby, offset*CN(0, 32, 0), 47.75-0.2, 12, 360, V2(3.4, 2), decorColor, decorMaterial)
 
for a = -1, 1, 2 do
        --gap filler
        wedge(lobby, V3(3+40, 2.5, 4), offset*CN(a*10, 29.5, -49.5-20)*CA(180, a*90, 0), domeColor, domeMaterial)
        --passage walls
        local passageWall = part(lobby, V3(3, 30, 43), offset*CN(a*13, 15.5, -49.5-20), domeColor, domeMaterial)
        part(lobby, V3(8, 30, 5), passageWall.CFrame*CN(a*5.5, 0, -21+2), domeColor, domeMaterial)
end
 
weaponsCrate(lobby, offset*CN(0, 0.7, 40))
 
-----------------
--second room!!!!
-----------------
 
domeColor = "Dark stone grey"
domeMaterial = "SmoothPlastic"
 
--above-door border
arc(lobby, secondCenter*CN(0, 32, 0), 77.75, 12, 360, V2(3, 3), domeColor, domeMaterial)
--decor
arc(lobby, secondCenter*CN(0, 32, 0), 77.5, 12, 360, V2(3, 2), "Dove blue", "Neon")
 
local newWalls = arc(lobby, secondCenter*CN(0, 32, 0)*CA(0, 180, 0), 80, 12, 360, V2(2, 64), domeColor, domeMaterial)
 
local firstWall = newWalls:GetChildren()[1]
local firstCFrame = firstWall.CFrame
firstWall.Size = firstWall.Size-V3(0, 30, 0)
firstWall.CFrame = firstCFrame*CN(0, 15, 0)
 
 
 
newDomeArches = {}
 
--archways
for c = -6, 5 do
        local support = part(lobby, V3(64, 6, 6), secondCenter*CA(0, (c+0.5)*30, 0)*CN(0, 32, 80)*CA(0, 0, 90), domeColor, domeMaterial)
        support.Shape = "Cylinder"
        support.CFrame = secondCenter*CA(0, (c+0.5)*30, 0)*CN(0, 32, 80)*CA(0, 0, 90)
        --cylinder(support)
        for s = 0, 6 do
                local supportBot = part(lobby, V3(7+s, 4, 7+s), support.CFrame*CA(0, 0, -90)*CN(0, -32+2-s*0.4, 0), domeColor, domeMaterial)
                cylinder(supportBot)
                new'PointLight'{pt = supportBot, Color = C3(1, 1, 1), Brightness = 2, Range = 24}
        end
        
        local supportOrb = part(lobby, V3(5.9, 5.9, 5.9), support.CFrame*CA(0, 0, -90)*CN(0, 32, 0), "Dove blue", "Neon")
        mesh(supportOrb, V3(1, 1, 1), "Sphere")
        new'PointLight'{pt = supportOrb, Color = C3(1, 1, 1), Brightness = 2, Range = 24}
        
        
        for b = 1, 39 do
                local supportDecor = part(lobby, V3(1, 6.2, 1), support.CFrame*CA(0, 0, -90)*CA(0, b*360/40, 0)*CN(0, -28+b*60/40, 0)*CA(90, 0, 0), "Dove blue", "Neon")
                cylinder(supportDecor)
                supportDecor.CanCollide = false
        end
        
        local newDomeArch = arc(lobby, secondCenter*CN(0, 0, 0)*CA(0, (c+0.5)*30, 0)*CN(0, 50, -57)*CA(0, 0, 90)*CA(0, 30, 0), 140, 12, 45, V2(2, 3), domeColor, domeMaterial)
        
        table.insert(newDomeArches, newDomeArch)
end
 
for a, arch in pairs(newDomeArches) do
        recurse(arch, function(p, i)
                if newDomeArches[a+1] then
                        local nextArch = newDomeArches[a+1]:GetChildren()
                        triangleConnect(lobby, {
                                (nextArch[i].CFrame*CN(-nextArch[i].Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(-p.Size.X/2, 0, 0)).p
                        }, 1, domeColor, domeMaterial, 0, false)
                        triangleConnect(lobby, {
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (nextArch[i].CFrame*CN(nextArch[i].Size.X/2, 0, 0)).p,
                                (nextArch[i].CFrame*CN(-nextArch[i].Size.X/2, 0, 0)).p
                        }, 1, domeColor, domeMaterial, 0, false)
                else
                        local firstArch = newDomeArches[1]:GetChildren()
                        --local i = #firstArch-i+1
                        triangleConnect(lobby, {
                                (firstArch[i].CFrame*CN(-firstArch[i].Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (p.CFrame*CN(-p.Size.X/2, 0, 0)).p
                        }, 1, domeColor, domeMaterial, 0, false)
                        triangleConnect(lobby, {
                                (p.CFrame*CN(p.Size.X/2, 0, 0)).p,
                                (firstArch[i].CFrame*CN(firstArch[i].Size.X/2, 0, 0)).p,
                                (firstArch[i].CFrame*CN(-firstArch[i].Size.X/2, 0, 0)).p
                        }, 1, domeColor, domeMaterial, 0, false)
                end
        end)
end
 
arc(lobby, secondCenter*CN(0, 164.5, 0), 23, 12, 360, V2(3, 3), domeColor, domeMaterial)
 
arc(lobby, secondCenter*CN(0, 181, 0), 0, 12, 360, V2(24, 30), domeColor, domeMaterial, 0, nil, 0.1)
 
 
 
 
 
 
 
 
 
--First map: 
 
offset = CN(0, 3, 0)
 
wallBevel = 40
wallHeight = 70
cliffVariation = 25
cliffHeight = 40
 
toDestroy = {}
 
for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "War Blox 2 Map" then
                table.insert(toDestroy, obj)
        end
end
 
map = new'Model'{pt = Workspace, nm = "War Blox 2 Map"}
 
function waypoint(cf, text, tC3)
        local marker = part(map, V3(2, 2, 2), cf, "Black", "SmoothPlastic", 0.5)
        marker.CanCollide = false
        local markerGui = new'BillboardGui'{pt = marker, Adornee = marker, sz = U2(0, 200, 0, 20), AlwaysOnTop = true}
        local theLabel = tLabel(markerGui, text, 14, tC3)
        theLabel.TextSize = 14
        
end
 
mapFloor = part(map, V3(400, 1, 650), offset, "", "DiamondPlate")
 
ammoBox(lobby, offset*CN(0, 42.5, 0))
 
--mapWalls
local cliffs = {}
local cliffTops = {}
local cliffGrass = {}
for w = 0, 3 do
        local mapWall = part(map, V3(400+250*(w%2), wallHeight, 1), offset*CA(0, w*90, 0)*CN(0, wallHeight/2+0.5, 325-125*(w%2)-0.5), "Dark stone grey", "Concrete")
        local mapWallBevel = arc(map, offset*CA(0, w*90, 0)*CN(200+125*(w%2)-wallBevel-0.95, wallHeight/2+0.5, 325-125*(w%2)-wallBevel-0.95)*CA(0, 45, 0), wallBevel, 10, 90, V2(wallBevel/2, wallHeight), "Dark stone grey", "Concrete")
        
        local cliffSpots = {(mapWall.CFrame*CN(-mapWall.Size.X/2+0.5, wallHeight/2, 0.5)).p}
        local theTops = {}
        local theGrass = {}
        for t = 1, 20 do
                local newSpot = mapWall.CFrame*CN(-mapWall.Size.X/2+t*mapWall.Size.X/20, wallHeight/2+cliffHeight, 0)*CN(MR(-cliffVariation/2, cliffVariation/2), math.sin(t*180/20)*cliffVariation/2*0, MR(-cliffVariation, cliffVariation))
                table.insert(cliffSpots, newSpot.p)
                table.insert(cliffSpots, (mapWall.CFrame*CN(-mapWall.Size.X/2+t*mapWall.Size.X/20, wallHeight/2, 0)).p)
                local newTop = newSpot*CN(0, cliffVariation+MR(0, cliffVariation), -cliffVariation+MR(-cliffVariation/((w+1)%2+1), cliffVariation/((w+1)%2+1)))
                table.insert(theTops, newTop.p)
                local newGrass = newTop*CN(0, 0, 200)
                table.insert(theGrass, newGrass.p)
        end
        --table.insert(cliffSpots, (mapWall.CFrame*CN(mapWall.Size.X/2, 5, 0)).p)
        
        for c = 1, #cliffSpots-2 do
                local firstSpot = cliffSpots[c]
                local secondSpot = cliffSpots[c+1]
                local thirdSpot = cliffSpots[c+2]
                triangleConnect(map, {
                        firstSpot,
                        secondSpot,
                        thirdSpot
                }, 0, "Reddish brown", "Slate", 0, true)
        end
        
        for c = 1, #theTops-1 do
                triangleConnect(map, {
                        theTops[c],
                        cliffSpots[c*2],
                        cliffSpots[c*2+2]
                }, 0, "Reddish brown", "Slate", 0, true)
                triangleConnect(map, {
                        theTops[c],
                        cliffSpots[c*2+2],
                        theTops[c+1]
                }, 0, "Reddish brown", "Slate", 0, true)
        end
        
        for c = 1, #theGrass-1 do
                triangleConnect(map, {
                        theGrass[c],
                        theTops[c],
                        theTops[c+1]
                }, 0, "Reddish brown", "Slate", 0, true)
                triangleConnect(map, {
                        theGrass[c],
                        theTops[c+1],
                        theGrass[c+1]
                }, 0, "Reddish brown", "Slate", 0, true)
        end
        
        table.insert(cliffs, cliffSpots)
        table.insert(cliffTops, theTops)
        table.insert(cliffGrass, theGrass)
end
 
--make ends meet
for c = 1, #cliffs do
        local thisCliff = cliffs[c]
        local nextCliff = cliffs[c+1] or cliffs[1]
        triangleConnect(map, {
                thisCliff[#thisCliff-1],
                thisCliff[#thisCliff],
                nextCliff[2]
        }, 0, "Reddish brown", "Slate", 0, true)
        
        local thisTops = cliffTops[c]
        local nextTops = cliffTops[c+1] or cliffTops[1]
        triangleConnect(map, {
                        thisTops[#thisTops],
                        nextTops[1],
                        nextCliff[2]
                }, 0, "Reddish brown", "Slate", 0, true)
        triangleConnect(map, {
                        thisTops[#thisTops],
                        nextCliff[2],
                        thisCliff[#thisCliff-1]
        }, 0, "Reddish brown", "Slate", 0, true)
        
        local thisGrass = cliffGrass[c]
        local nextGrass = cliffGrass[c+1] or cliffGrass[1]
        triangleConnect(map, {
                        thisTops[#thisTops],
                        nextGrass[1],
                        nextTops[1]
                }, 0, "Reddish brown", "Slate", 0, true)
        triangleConnect(map, {
                        thisGrass[#thisGrass],
                        thisTops[#thisTops],
                        nextGrass[1]
        }, 0, "Reddish brown", "Slate", 0, true)
        
        --TURRET!
        Turret(map, CN(thisTops[#thisTops])*CA(0, c*90-90, 0)*CN(40, 0, 40), MR(-180, 180), MR(0, 60))
        
end
 
--grassStuff = part(map, V3(450, 1, 650), offset*CN(0, 30, 0), "Dark green", "Sand", 0.8)
--grassStuff.CanCollide = false
 
--bridge
bridge = arc(map, offset*CN(0, -16, 0)*CA(-90, 0, 0), 50, 14, 60, V2(5, 30), "Dark stone grey", "Concrete")
 
--tunnel function!
--gots to make the tunnel's walls randomized and stuff!
function tunnel(start, finish, startSize, finishSize, bc, mt, tr, randomization, deadEnd) --randomization: {numberOfSplits, variationLimits, randomnessFactor}
        local thisSegment = new'Model'{pt = map, nm = "Tunnel Segment"}
        if not randomization then
                for s = -1, 1, 2 do
                        --right/left
                        triangleConnect(thisSegment, {(start*CN(s*startSize.X/2, -startSize.Y/2, 0)).p, (start*CN(s*startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, -finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                        triangleConnect(thisSegment, {(start*CN(s*startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, -finishSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                        --top/bottom
                        triangleConnect(thisSegment, {(start*CN(s*-startSize.X/2, s*startSize.Y/2, 0)).p, (start*CN(s*startSize.X/2, s*startSize.Y/2, 0)).p, (finish*CN(s*-finishSize.X/2, s*finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                        triangleConnect(thisSegment, {(start*CN(s*startSize.X/2, s*startSize.Y/2, 0)).p, (finish*CN(s*-finishSize.X/2, s*finishSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, s*finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                end
        else
                --starts
                local RT = CN((start*CN(startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(finishSize.X/2, finishSize.Y/2, 0)).p)
                local RB = CN((start*CN(startSize.X/2, -startSize.Y/2, 0)).p, (finish*CN(finishSize.X/2, -finishSize.Y/2, 0)).p)
                local LT = CN((start*CN(-startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(-finishSize.X/2, finishSize.Y/2, 0)).p)
                local LB = CN((start*CN(-startSize.X/2, -startSize.Y/2, 0)).p, (finish*CN(-finishSize.X/2, -finishSize.Y/2, 0)).p)
                --ends
                local fRT = finish*CN(finishSize.X/2, finishSize.Y/2, 0)
                local fRB = finish*CN(finishSize.X/2, -finishSize.Y/2, 0)
                local fLT = finish*CN(-finishSize.X/2, finishSize.Y/2, 0)
                local fLB = finish*CN(-finishSize.X/2, -finishSize.Y/2, 0)
                --distances
                local dRT = (fRT.p-RT.p).magnitude
                local dRB = (fRB.p-RB.p).magnitude
                local dLT = (fLT.p-LT.p).magnitude
                local dLB = (fLB.p-LB.p).magnitude
                
                local n = randomization[1] --number of randomized segments
                local limits = randomization[2] --randomness limits
                local r = randomization[3] --factor which sets how many in-between values there are.
                
                local lastRT = RT
                local lastRB = RB
                local lastLT = LT
                local lastLB = LB
                
                for d = 1, n do
                        local thisRT = RT*CN(0, 0, -dRT/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        local thisRB = RB*CN(0, 0, -dRB/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        local thisLT = LT*CN(0, 0, -dLT/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        local thisLB = LB*CN(0, 0, -dLB/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        
                        --right
                        triangleConnect(thisSegment, {lastRT.p, lastRB.p, thisRT.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisSegment, {lastRB.p, thisRB.p, thisRT.p}, 0, bc, mt, tr, true)
                        --left
                        triangleConnect(thisSegment, {lastLT.p, lastLB.p, thisLT.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisSegment, {lastLB.p, thisLB.p, thisLT.p}, 0, bc, mt, tr, true)
                        --top
                        triangleConnect(thisSegment, {lastLT.p, lastRT.p, thisRT.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisSegment, {lastLT.p, thisLT.p, thisRT.p}, 0, bc, mt, tr, true)
                        --bottom
                        triangleConnect(thisSegment, {lastLB.p, lastRB.p, thisRB.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisSegment, {lastLB.p, thisLB.p, thisRB.p}, 0, bc, mt, tr, true)
                        
                        lastRT = thisRT
                        lastRB = thisRB
                        lastLT = thisLT
                        lastLB = thisLB
                end
                
                --right
                triangleConnect(thisSegment, {lastRT.p, lastRB.p, fRT.p}, 0, bc, mt, tr, true)
                triangleConnect(thisSegment, {lastRB.p, fRB.p, fRT.p}, 0, bc, mt, tr, true)
                --left
                triangleConnect(thisSegment, {lastLT.p, lastLB.p, fLT.p}, 0, bc, mt, tr, true)
                triangleConnect(thisSegment, {lastLB.p, fLB.p, fLT.p}, 0, bc, mt, tr, true)
                --top
                triangleConnect(thisSegment, {lastLT.p, lastRT.p, fRT.p}, 0, bc, mt, tr, true)
                triangleConnect(thisSegment, {lastLT.p, fLT.p, fRT.p}, 0, bc, mt, tr, true)
                --bottom
                triangleConnect(thisSegment, {lastLB.p, lastRB.p, fRB.p}, 0, bc, mt, tr, true)
                triangleConnect(thisSegment, {lastLB.p, fLB.p, fRB.p}, 0, bc, mt, tr, true)
                
        end
        return thisSegment, CN(start.p, finish.p)
end
 
function cut(pt, side, ps, sz)
        local bc = pt.BrickColor.Name
        local mt = pt.Material
        local tr = pt.Transparency
        local rightSize = V2((pt.Size.X-sz.X)/2-ps.X, pt.Size.Z)
        local leftSize = V2((pt.Size.X-sz.X)/2+ps.X, pt.Size.Z)
        local topSize = V2(sz.X, (pt.Size.Z-sz.Y)/2-ps.Y)
        local bottomSize = V2(sz.X, (pt.Size.Z-sz.Y)/2+ps.Y)
        
        local rightPos = ps+V2(sz.X/2+rightSize.X/2, -ps.Y)
        local leftPos = ps+V2(-sz.X/2-leftSize.X/2, -ps.Y)
        local topPos = ps+V2(0, sz.Y/2+topSize.Y/2)
        local bottomPos = ps+V2(0, -sz.Y/2-bottomSize.Y/2)
        
        local splitStuff = new'Model'{pt = pt.Parent, nm = "Split Stuff!"}
        if side == "X" then
                
                local partR = part(splitStuff, V3(pt.Size.Y+0.2, rightSize.Y, rightSize.X), pt.CFrame*CN(0, rightPos.Y, rightPos.X), bc, mt, tr)
                local partL = part(splitStuff, V3(pt.Size.Y+0.2, leftSize.Y, leftSize.X), pt.CFrame*CN(0, leftPos.Y, leftPos.X), bc, mt, tr)
                local partT = part(splitStuff, V3(pt.Size.Y+0.2, topSize.Y, topSize.X), pt.CFrame*CN(0, topPos.Y, topPos.X), bc, mt, tr)
                local partB = part(splitStuff, V3(pt.Size.Y+0.2, bottomSize.Y, bottomSize.X), pt.CFrame*CN(0, bottomPos.Y, bottomPos.X), bc, mt, tr)
        elseif side == "Y" then
                
                local partR = part(splitStuff, V3(rightSize.X, pt.Size.Y+0.2, rightSize.Y), pt.CFrame*CN(rightPos.X, 0, rightPos.Y), bc, mt, tr)
                local partL = part(splitStuff, V3(leftSize.X, pt.Size.Y+0.2, leftSize.Y), pt.CFrame*CN(leftPos.X, 0, leftPos.Y), bc, mt, tr)
                local partT = part(splitStuff, V3(topSize.X, pt.Size.Y+0.2, topSize.Y), pt.CFrame*CN(topPos.X, 0, topPos.Y), bc, mt, tr)
                local partB = part(splitStuff, V3(bottomSize.X, pt.Size.Y+0.2, bottomSize.Y), pt.CFrame*CN(bottomPos.X, 0, bottomPos.Y), bc, mt, tr)
        elseif side == "Z" then
                
                local partR = part(splitStuff, V3(rightSize.X, rightSize.Y, pt.Size.Y+0.2), pt.CFrame*CN(rightPos.X, rightPos.Y, 0), bc, mt, tr)
                local partL = part(splitStuff, V3(leftSize.X, leftSize.Y, pt.Size.Y+0.2), pt.CFrame*CN(leftPos.X, leftPos.Y, 0), bc, mt, tr)
                local partT = part(splitStuff, V3(topSize.X, topSize.Y, pt.Size.Y+0.2), pt.CFrame*CN(topPos.X, topPos.Y, 0), bc, mt, tr)
                local partB = part(splitStuff, V3(bottomSize.X, bottomSize.Y, pt.Size.Y+0.2), pt.CFrame*CN(bottomPos.X, bottomPos.Y, 0), bc, mt, tr)
        end
        pt:Destroy()
end
 
function wall(start, finish, startSize, finishSize, bc, mt, tr, randomization) --randomization: {numberOfSplits, variationLimits, randomnessFactor}
        local thisWall = new'Model'{pt = map, nm = "Wall Slice"}
        if not randomization then
                for s = -1, 1, 2 do
                        --right/left
                        triangleConnect(thisWall, {(start*CN(s*startSize.X/2, -startSize.Y/2, 0)).p, (start*CN(s*startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, -finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                        triangleConnect(thisWall, {(start*CN(s*startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, -finishSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                        --top/bottom
                        triangleConnect(thisWall, {(start*CN(s*-startSize.X/2, s*startSize.Y/2, 0)).p, (start*CN(s*startSize.X/2, s*startSize.Y/2, 0)).p, (finish*CN(s*-finishSize.X/2, s*finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                        triangleConnect(thisWall, {(start*CN(s*startSize.X/2, s*startSize.Y/2, 0)).p, (finish*CN(s*-finishSize.X/2, s*finishSize.Y/2, 0)).p, (finish*CN(s*finishSize.X/2, s*finishSize.Y/2, 0)).p}, 0, bc, mt, tr, true)
                end
        else
                --starts
                local RT = CN((start*CN(startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(finishSize.X/2, finishSize.Y/2, 0)).p)
                local RB = CN((start*CN(startSize.X/2, -startSize.Y/2, 0)).p, (finish*CN(finishSize.X/2, -finishSize.Y/2, 0)).p)
                local LT = CN((start*CN(-startSize.X/2, startSize.Y/2, 0)).p, (finish*CN(-finishSize.X/2, finishSize.Y/2, 0)).p)
                local LB = CN((start*CN(-startSize.X/2, -startSize.Y/2, 0)).p, (finish*CN(-finishSize.X/2, -finishSize.Y/2, 0)).p)
                --ends
                local fRT = finish*CN(finishSize.X/2, finishSize.Y/2, 0)
                local fRB = finish*CN(finishSize.X/2, -finishSize.Y/2, 0)
                local fLT = finish*CN(-finishSize.X/2, finishSize.Y/2, 0)
                local fLB = finish*CN(-finishSize.X/2, -finishSize.Y/2, 0)
                --distances
                local dRT = (fRT.p-RT.p).magnitude
                local dRB = (fRB.p-RB.p).magnitude
                local dLT = (fLT.p-LT.p).magnitude
                local dLB = (fLB.p-LB.p).magnitude
                
                local n = randomization[1] --number of randomized segments
                local limits = randomization[2] --randomness limits
                local r = randomization[3] --factor which sets how many in-between values there are.
                
                local lastRT = RT
                local lastRB = RB
                local lastLT = LT
                local lastLB = LB
                
                for d = 1, n do
                        local thisRT = RT*CN(0, 0, -dRT/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        local thisRB = RB*CN(0, 0, -dRB/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        local thisLT = LT*CN(0, 0, -dLT/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        local thisLB = LB*CN(0, 0, -dLB/(n+1)*d)*CN(MR(-r, r)/r*limits.X, MR(-r, r)/r*limits.Y, MR(-r, r)/r*limits.Z)
                        
                        --right
                        triangleConnect(thisWall, {lastRT.p, lastRB.p, thisRT.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisWall, {lastRB.p, thisRB.p, thisRT.p}, 0, bc, mt, tr, true)
                        --left
                        triangleConnect(thisWall, {lastLT.p, lastLB.p, thisLT.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisWall, {lastLB.p, thisLB.p, thisLT.p}, 0, bc, mt, tr, true)
                        --top
                        triangleConnect(thisWall, {lastLT.p, lastRT.p, thisRT.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisWall, {lastLT.p, thisLT.p, thisRT.p}, 0, bc, mt, tr, true)
                        --bottom
                        triangleConnect(thisWall, {lastLB.p, lastRB.p, thisRB.p}, 0, bc, mt, tr, true)
                        triangleConnect(thisWall, {lastLB.p, thisLB.p, thisRB.p}, 0, bc, mt, tr, true)
                        
                        lastRT = thisRT
                        lastRB = thisRB
                        lastLT = thisLT
                        lastLB = thisLB
                end
                
                --right
                triangleConnect(thisWall, {lastRT.p, lastRB.p, fRT.p}, 0, bc, mt, tr, true)
                triangleConnect(thisWall, {lastRB.p, fRB.p, fRT.p}, 0, bc, mt, tr, true)
                --left
                triangleConnect(thisWall, {lastLT.p, lastLB.p, fLT.p}, 0, bc, mt, tr, true)
                triangleConnect(thisWall, {lastLB.p, fLB.p, fLT.p}, 0, bc, mt, tr, true)
                --top
                triangleConnect(thisWall, {lastLT.p, lastRT.p, fRT.p}, 0, bc, mt, tr, true)
                triangleConnect(thisWall, {lastLT.p, fLT.p, fRT.p}, 0, bc, mt, tr, true)
                --bottom
                triangleConnect(thisWall, {lastLB.p, lastRB.p, fRB.p}, 0, bc, mt, tr, true)
                triangleConnect(thisWall, {lastLB.p, fLB.p, fRB.p}, 0, bc, mt, tr, true)
                
        end
        return thisWall, CN(start.p, finish.p)
end
 
dockThings = {}
 
for a = -1, 1, 2 do
        --Dock(Parent, CFrame, PlankSize, NumberOfPlanks, Spacing, DockHeight, SupportSpacing, DockOffset, Randomness, Colors, Materials)
        local thisDo = Dock(map, offset*CN(1.5, 29.5, a*100)*CA(0, 90, 0), V3(14, 1, 2), 19, 0.5, 30, 4, 0, 4, {"Reddish brown", "Brown", "Reddish brown"}, {"WoodPlanks", "Wood", "WoodPlanks"})
        table.insert(dockThings, thisDo)
        --coverwalls 'cross the bridge.
        CoverWall(map, offset*CN(a*45, 31.25, a*100)*CA(0, -90*a, 0), V3(3, 2, 2), 10, 180, 5, 10, "Dark stone grey", "Slate")
        CoverWall(map, offset*CN(a*-45, 31.25, a*100)*CA(0, 90*a, 0), V3(3, 2, 2), 10, 180, 5, 10, "Dark stone grey", "Slate")
        
        --Dumpster2(map, offset*CN(a*65, 30, a*100)*CA(0, 45, 0))
        
        local railing = arc(map, offset*CN(0, -16, a*14)*CA(-90, 0, 0), 57, 14, 60, V2(1, 1), "Dark stone grey", "Concrete")
        recurse(railing, function(prt, n) local cf = prt.CFrame prt.Shape = "Cylinder" prt.CFrame = cf end)
        --arc(map, offset*CN(0, -16, a*14)*CA(-90, 0, 0), 55, 14, 60, V2(2, 0.5), "Brown", "Wood")
        for s = -7, 7 do
                --local railingSupport = cylinderPart(map, V3(1, 4, 1), offset*CN(0, -16, a*14)*CA(0, 0, s*60/14)*CN(0, 55.5, 55.5), "Dark stone grey", "Concrete")
        end
        local railingSupports = curve(map, "Z", offset*CN(0, -16, a*14), 55.5, 14, 60, V3(0.7, 3, 0.7), "Dark stone grey", "Concrete")
        
        --supports
        
        local column = cylinderPart(map, V3(5, 36, 5), offset*CN(0, 18, a*7), "Dark stone grey", "Concrete")
 
        local grass = part(map, V3(171, 1, 648), offset*CN(a*113.5, 29.8, 0), "Dark green", "Sand")
        
        cut(grass, "Y", V2(a*-113.5, 0)+V2(a*25.5, a*-100)+V2(a*102.5, a*-38), V2(15, 10))
        
        --V2(a*-113.5, 0)+V2(a*25.5, a*-100)+V2(a*102.5, a*-40)
        
        local riverWall1 = part(map, V3(5, 30, 324-105), offset*CN(a*25.5, 15.5, -162*a-a*52.5), "Dark stone grey", "Concrete")
        local riverWall2 = part(map, V3(5, 30, 324+95), offset*CN(a*25.5, 15.5, 162*a-a*47.5), "Dark stone grey", "Concrete")
        local riverTunnelTop = part(map, V3(5, 10, 10), offset*CN(a*25.5, 25.5, a*-100), "Dark stone grey", "Concrete")
        local riverTunnelBot = part(map, V3(5, 10, 10), offset*CN(a*25.5, 5.5, a*-100), "Dark stone grey", "Concrete")
        
        local tunnelCFrame = offset*CN(a*25.5, 15.5, a*-100)
        
        --ladder
        for l = 1, 5 do
                local ladderPart = part(map, V3(0.6, 4, 0.6), tunnelCFrame*CN(a*-3.5, -13.5+l*1.5, 0)*CA(90, 0, 0), "Medium stone grey", "DiamondPlate")
                cylinder(ladderPart)
                local ladderLeft = part(map, V3(0.6, 1, 0.6), ladderPart.CFrame*CN(a*0.5, 2, 0)*CA(0, 0, 90), "Medium stone grey", "DiamondPlate")
                cylinder(ladderLeft)
                local ladderRight = part(map, V3(0.6, 1, 0.6), ladderPart.CFrame*CN(a*0.5, -2, 0)*CA(0, 0, 90), "Medium stone grey", "DiamondPlate")
                cylinder(ladderRight)
        end
        
        arc(map, tunnelCFrame*CA(0, 0, 90), 4, 8, 360, V2(5, 5), "Dark stone grey", "Concrete", 0, nil, 0.01)
        
        tunnel(tunnelCFrame*CN(a*2.5, 0, 0)*CA(0, 90, 0), tunnelCFrame*CN(a*20, 0, 0)*CA(0, 90, 0), V2(10, 10), V2(10, 10), "Brown", "Slate", 0, {3, V3(1, 1, 1), 100})
        tunnel(tunnelCFrame*CN(a*20, 0, 0)*CA(0, 90, 0), tunnelCFrame*CN(a*55, 0, a*20)*CA(0, 60, 0), V2(10, 10), V2(10, 10), "Brown", "Slate", 0, {3, V3(1, 1, 1), 100})
        --fork in the tunnel, right or left?
        local rTunnel, rightLook = tunnel(tunnelCFrame*CN(a*55, 0, a*20)*CA(0, 60, 0)*CN(-2.5*a, 0, 0), tunnelCFrame*CN(a*70, 0, a*50)*CA(0, 60, 0), V2(5, 10), V2(10, 10), "Brown", "Slate", 0, {3, V3(1, 1, 1), 100})
        local lTunnel, leftLook = tunnel(tunnelCFrame*CN(a*55, 0, a*20)*CA(0, 60, 0)*CN(2.5*a, 0, 0), tunnelCFrame*CN(a*70, 0, a*20)*CA(0, 90, 0), V2(5, 10), V2(10, 10), "Brown", "Slate", 0, {3, V3(1, 1, 1), 100})
        
        --TO THE RIGHT!!!!
        
        tunnel(tunnelCFrame*CN(a*70, 0, a*50)*CA(0, 60, 0), tunnelCFrame*CN(a*90, 0, a*60)*CA(0, 60, 0), V2(10, 10), V2(20, 10), "Brown", "Slate", 0, {3, V3(3, 3, 3), 100})
        
        local thisPlace = tunnelCFrame*CN(a*90, 0, a*60)*CA(0, 60, 0)
        
        --bunkerstyle stuff :D
        part(map, V3(10, 28, 2), thisPlace*CN(14*a, 0, 0), "Dark stone grey", "Concrete")
        part(map, V3(10, 28, 2), thisPlace*CN(-14*a, 0, 0), "Dark stone grey", "Concrete")
        part(map, V3(18, 10, 2), thisPlace*CN(0, 9, 0), "Dark stone grey", "Concrete")
        part(map, V3(18, 10, 2), thisPlace*CN(0, -9, 0), "Dark stone grey", "Concrete")
        
        tunnel(thisPlace*CN(0, -2.5, 0), thisPlace*CN(0, -2.5, a*12.5), V2(30, 15), V2(30, 15), "Gun metallic", "Slate", 0, {1, V3(3, 3, 3), 100})
        tunnel(thisPlace*CN(0, -2.5, a*17.5), thisPlace*CN(0, -2.5, a*30), V2(30, 15), V2(30, 15), "Gun metallic", "Slate", 0, {1, V3(3, 3, 3), 100})
        --middle chunk
        tunnel(thisPlace*CN(-15, 2.5, a*15)*CA(0, 90, 0), thisPlace*CN(15, 2.5, a*15)*CA(0, 90, 0), V2(5, 5), V2(5, 5), "Gun metallic", "Slate", 0)
        tunnel(thisPlace*CN(-15, -12, a*15)*CA(0, 90, 0), thisPlace*CN(15, -12, a*15)*CA(0, 90, 0), V2(5, 4), V2(5, 4), "Gun metallic", "Slate", 0)
        
        tunnel(thisPlace*CN(0, 5, 0), thisPlace*CN(0, 2.5, a*12.5), V2(30, 0), V2(30, 5), "Gun metallic", "Slate", 0, {1, V3(1, 1, 1), 100})
        tunnel(thisPlace*CN(0, 5, a*30), thisPlace*CN(0, 2.5, a*17.5), V2(30, 0), V2(30, 5), "Gun metallic", "Slate", 0, {1, V3(1, 1, 1), 100})
        
        --the bunker's left turn xD
        tunnel(thisPlace*CN(15*a, -5, a*15)*CA(0, 90, 0), thisPlace*CN(50*a, 5, a*25)*CA(0, 90, 0), V2(5, 10), V2(15, 15), "Gun metallic", "Slate", 0, {3, V3(3, 0, 3), 100})
        tunnel(thisPlace*CN(50*a, 5, a*25)*CA(0, 90, 0), thisPlace*CN(85*a, -7.5, a*15)*CA(0, 135, 0), V2(15, 15), V2(7, 10), "Gun metallic", "Slate", 0, {3, V3(3, 0, 3), 100})
        tunnel(thisPlace*CN(85*a, -7.5, a*15)*CA(0, 135, 0), thisPlace*CN(110*a, -1, a*-15)*CA(0, 90, 0), V2(7, 10), V2(40, 25), "Gun metallic", "Slate", 0, {3, V3(3, 0, 3), 100})
        
        tunnel(thisPlace*CN(110*a, -1, a*-15)*CA(0, 90, 0), thisPlace*CN(120*a, -2.5, a*-45)*CA(0, 180, 0), V2(40, 25), V2(20, 20), "Gun metallic", "Slate", 0, {3, V3(5, 0, 5), 100})
        tunnel(thisPlace*CN(120*a, -2.5, a*-45)*CA(0, 180, 0), thisPlace*CN(115*a, -5, a*-65)*CA(0, 180, 0)*CN(0, 5, 0), V2(20, 20), V2(10, 17), "Gun metallic", "Slate", 0, {3, V3(5, 0, 5), 100})
        tunnel(thisPlace*CN(115*a, -5, a*-65)*CA(0, 180, 0)*CN(0, 5, 0), thisPlace*CN(105*a, -5, a*-75)*CA(0, 210, 0)*CN(0, 0, 0), V2(10, 17), V2(14, 14), "Gun metallic", "Slate", 0, {3, V3(1, 0, 1), 100})
        tunnel(thisPlace*CN(105*a, -5, a*-75)*CA(0, 210, 0)*CN(0, 0, 0), thisPlace*CN(90*a, -7.5, a*-75)*CA(0, 240, 0)*CN(0, 0, 0), V2(14, 14), V2(14, 14), "Gun metallic", "Slate", 0, {3, V3(1, 0, 1), 100})
        tunnel(thisPlace*CN(90*a, -7.5, a*-75)*CA(0, 240, 0)*CN(0, 0, 0), thisPlace*CN(80*a, -7.5, a*-75)*CA(0, 300, 0), V2(14, 14), V2(14, 10), "Gun metallic", "Slate", 0, {3, V3(1, 0, 1), 100})
        tunnel(thisPlace*CN(80*a, -7.5, a*-75)*CA(0, 300, 0), thisPlace*CN(70*a, -7.5, a*-65)*CA(0, 360, 0), V2(14, 10), V2(10, 10), "Gun metallic", "Slate", 0, {3, V3(1, 0, 1), 100})
        tunnel(thisPlace*CN(70*a, -7.5, a*-65)*CA(0, 0, 0), thisPlace*CN(97.5*a, -7.5, a*-42.5)*CA(0, 45, 0), V2(10, 10), V2(10, 10), "Gun metallic", "Slate", 0, {3, V3(1, 0, 1), 100})
        tunnel(thisPlace*CN(97.5*a, -7.5, a*-42.5)*CA(0, 45, 0), tunnelCFrame*CN(a*110, -10, a*-40)*CA(0, 30, 0), V2(10, 10), V2(7, 7), "Gun metallic", "Slate", 0, {3, V3(1, 0, 1), 100})
        
        --
        tunnel(thisPlace*CN(0, 0, a*30), thisPlace*CN(0, 0, a*30)*CA(0, -45, 0)*CN(0, -5, a*30), V2(20, 10), V2(10, 10), "Brown", "Slate", 0, {3, V3(3, 3, 3), 100})
        tunnel(thisPlace*CN(0, 0, a*30)*CA(0, -45, 0)*CN(0, -5, a*30), tunnelCFrame*CN(a*100, 0, a*150), V2(10, 10), V2(30, 10), "Brown", "Slate", 0, {3, V3(3, 3, 3), 100})
        tunnel(tunnelCFrame*CN(a*100, 0, a*150), tunnelCFrame*CN(a*100, 0, a*250)*CA(0, -45, 0), V2(30, 10), V2(100, 25), "Brown", "Slate", 0, {3, V3(3, 3, 3), 100})
        
        --part(map, V3(35, 1, 30), thisPlace*CN(0, -9, a*15), "Medium stone grey", "Concrete")
        
        part(map, V3(10, 28, 2), thisPlace*CN(14*a, 0, a*30), "Dark stone grey", "Concrete")
        part(map, V3(10, 28, 2), thisPlace*CN(-14*a, 0, a*30), "Dark stone grey", "Concrete")
        part(map, V3(18, 10, 2), thisPlace*CN(0, 9, a*30), "Dark stone grey", "Concrete")
        part(map, V3(18, 10, 2), thisPlace*CN(0, -9, a*30), "Dark stone grey", "Concrete")
        
        --next place after bunker =P
        --
        
        tunnel(tunnelCFrame*CN(a*117.5, 0, a*-20)*CA(0, 180, 0), tunnelCFrame*CN(a*110, -10, a*-40)*CA(0, 210, 0), V2(15, 15), V2(7, 7), "Brown", "Slate", 0, {3, V3(3, 3, 3), 100})
        
        --TO THE LEFT!!!!
        
        tunnel(tunnelCFrame*CN(a*70, 0, a*20)*CA(0, 90, 0), tunnelCFrame*CN(a*110, 0, a*20)*CA(0, 135, 0), V2(10, 10), V2(30, 15), "Brown", "Slate", 0, {3, V3(3, 0, 3), 100})
        tunnel(tunnelCFrame*CN(a*110, 0, a*20)*CA(0, 135, 0), tunnelCFrame*CN(a*110, 0, a*-20)*CA(0, 180, 0), V2(30, 15), V2(30, 15), "Brown", "Slate", 0, {3, V3(0, 0, 0), 100})
        
        tunnel(tunnelCFrame*CN(a*110, 0, a*20)*CA(0, 135, 0), tunnelCFrame*CN(a*110, 0, a*-20)*CA(0, 180, 0), V2(30, 15), V2(30, 15), "Brown", "Slate", 0, {3, V3(0, 0, 0), 100})
        
        for s = 0, 22 do --stairs ya know.
                --local stair = part(map, V3(15, 1, 2), tunnelCFrame*CN(a*102.5, -7.5+s, a*(-20-s))*CA(0, 180, 0), "Black", "Cobblestone")
        end
        
        tunnel(tunnelCFrame*CN(a*102.5, 0, a*-20)*CA(0, 180, 0), tunnelCFrame*CN(a*102.5, 13.75, a*-38)*CA(0, 180, 0)*CA(a*-90, 0, 0), V2(15, 15), V2(13, 9), "Brown", "Slate", 0, {5, V3(0, 0, 0), 100})
        --tunnel lip
        tunnel(tunnelCFrame*CN(a*102.5, 13.75, a*-38)*CA(0, 180, 0)*CA(90, 0, 0), tunnelCFrame*CN(a*102.5, 16, a*-38)*CA(0, 180, 0)*CA(90, 0, 0), V2(13, 9), V2(12, 8), "Brown", "Slate", 0, {0, V3(), 10})
        tunnel(tunnelCFrame*CN(a*102.5, 16, a*-38)*CA(0, 180, 0)*CA(90, 0, 0), tunnelCFrame*CN(a*102.5, 14.75, a*-38)*CA(0, 180, 0)*CA(90, 0, 0), V2(12, 8), V2(18, 13), "Brown", "Slate", 0, {0, V3(), 10})
        
        --cobblestone steps
        for c = 1, 7 do
                --local step = part(map, V3(1, 1, 1), CN((tunnelCFrame*CN(a*102.5, -7.5+s, a*(-20-s))).p, (tunnelCFrame*CN(a*102.5, -7.5+s, a*(-20-s))).p)*CN)
        end
        
        --tunnel(tunnelCFrame*CN(a*40, 0, 0)*CA(0, 90, 0), tunnelCFrame*CN(a*70, 0, a*20)*CA(0, 90, 0), V2(20, 20), V2(40, 20), "Dark stone grey", "Slate", 0, {3, V3(1, 1, 1), 100})
end
 
local riverGround = part(map, V3(46, 1, 648), offset*CN(0, 1, 0), "Pine Cone", "Slate")
 
 
--local riverWater = part(map, V3(450, 1, 650), offset*CN(0, 7, 0), "Cyan", "Granite", 0.7)
--riverWater.CanCollide = false
 
-------
--Tower
-------
 
local tower = new'Model'{pt = map, nm = "Cool Tower!"}
local towerOffset = offset*CN(-125, 30.2, 250)*CA(0, -90, 0)
 
--towerBase = part(tower, V3(80, 1, 80), towerOffset, "Black", "Slate")
towerBase = arc(tower, towerOffset, 0, 8, 360, V2(40, 1), "Black", "Slate", 0, nil, 0.04)
floor1Walls = arc(tower, towerOffset*CN(0, 12.5, 0), 37.5, 8, 360, V2(2, 24), "Medium stone grey", "Concrete")
--making an archway for the door
thisDoor = floor1Walls:GetChildren()[2]
doorSize = thisDoor.Size
doorCFrame = thisDoor.CFrame
part(tower, V3(2, 24, 2), doorCFrame*CN(doorSize.X/2-1, 0, 0), "Medium stone grey", "Concrete")
part(tower, V3(2, 24, 2), doorCFrame*CN(-doorSize.X/2+1, 0, 0), "Medium stone grey", "Concrete")
arc(tower, doorCFrame*CN(0, 12-doorSize.X/2, 0)*CA(-90, 0, 0), doorSize.X/2-2, 8, 180, V2(2, 1.9), "Medium stone grey", "Concrete")
wedge(tower, V3(1.9, 8.5, 11), doorCFrame*CN(doorSize.X/2-7.5, 7.75, 0)*CA(0, 90, 180), "Medium stone grey", "Concrete")
wedge(tower, V3(1.9, 8.5, 11), doorCFrame*CN(-doorSize.X/2+7.5, 7.75, 0)*CA(0, -90, 180), "Medium stone grey", "Concrete")
thisDoor:Destroy()
 
for f = 0, 3 do
        local column = cylinderPart(tower, V3(6, 75, 6), towerOffset*CA(0, f*90, 0)*CN(0, 37.5, 30), "Dark stone grey", "Concrete")
        local cf = column.CFrame*CA(0, 0, -90)
        --local columnBottom = cylinderPart(tower, V3(8, 5, 8), cf*CN(0, -37.5+2.5, 0), "Dark stone grey", "Concrete")
        for s = 0, 3 do
                local columnDecor = arc(tower, cf*CN(0, -37.5+25*s, 0)*CA(0, 0, 90), 0, 6, 360, V2(5, 6), "Dark stone grey", "Concrete")
        end
        --local diamondSupport = cylinderConnect(tower, (cf*CN(0, 37.5, 0)).p, (towerOffset*CN(0, 125, 0)).p, 6, "Dark stone grey", "DiamondPlate", true)
end
 
--ball(tower, 6, towerOffset*CN(0, 125, 0), "Dark stone grey", "DiamondPlate")
 
--FLOOR 2
 
floor2 = arc(tower, towerOffset*CN(0, 25, 0), 20, 8, 360, V2(15, 2), "Black", "Slate", 0, nil, 0.04)
floor2B = arc(tower, towerOffset*CN(0, 25, 0), 35, 8, 360, V2(5, 2), "Dark stone grey", "Concrete")
floor2Decor = arc(tower, towerOffset*CN(0, 25, 0), 35, 8, 360, V2(5.2, 1), "Medium stone grey", "DiamondPlate")
floor2Outside = arc(tower, towerOffset*CN(0, 27.5, 0), 39.5, 8, 360, V2(0.5, 3), "Dark stone grey", "DiamondPlate")
floor2Walls = arc(tower, towerOffset*CN(0, 25+12.5, 0), 33.5, 8, 360, V2(2, 23), "Medium stone grey", "Concrete")
--making an archway for the door
thisDoor = floor2Walls:GetChildren()[4]
doorSize = thisDoor.Size
doorCFrame = thisDoor.CFrame
part(tower, V3(2, 24, 2), doorCFrame*CN(doorSize.X/2-1, 0, 0), "Medium stone grey", "Concrete")
part(tower, V3(2, 24, 2), doorCFrame*CN(-doorSize.X/2+1, 0, 0), "Medium stone grey", "Concrete")
arc(tower, doorCFrame*CN(0, 12-doorSize.X/2, 0)*CA(-90, 0, 0), doorSize.X/2-2, 8, 180, V2(2, 1.9), "Medium stone grey", "Concrete")
wedge(tower, V3(1.9, 7, 9.5), doorCFrame*CN(doorSize.X/2-6.75, 8.5, 0)*CA(0, 90, 180), "Medium stone grey", "Concrete")
wedge(tower, V3(1.9, 7, 9.5), doorCFrame*CN(-doorSize.X/2+6.75, 8.5, 0)*CA(0, -90, 180), "Medium stone grey", "Concrete")
thisDoor:Destroy()
 
--FLOOR 3
 
floor3 = arc(tower, towerOffset*CN(0, 50, 0), 15, 8, 360, V2(15, 2), "Black", "Slate", 0, nil, 0.04)
floor3B = arc(tower, towerOffset*CN(0, 50, 0), 30, 8, 360, V2(10, 2), "Dark stone grey", "Concrete")
floor3Decor = arc(tower, towerOffset*CN(0, 50, 0), 30, 8, 360, V2(10.2, 1), "Medium stone grey", "DiamondPlate")
floor3Outside = arc(tower, towerOffset*CN(0, 52.5, 0), 39.5, 8, 360, V2(0.5, 3), "Dark stone grey", "DiamondPlate")
floor3Walls = arc(tower, towerOffset*CN(0, 50+12.5, 0), 27.5, 8, 360, V2(2, 23), "Medium stone grey", "Concrete")
--making an archway for the door
thisDoor = floor3Walls:GetChildren()[8]
doorSize = thisDoor.Size
doorCFrame = thisDoor.CFrame
part(tower, V3(2, 24, 2), doorCFrame*CN(doorSize.X/2-1, 0, 0), "Medium stone grey", "Concrete")
part(tower, V3(2, 24, 2), doorCFrame*CN(-doorSize.X/2+1, 0, 0), "Medium stone grey", "Concrete")
arc(tower, doorCFrame*CN(0, 12-doorSize.X/2, 0)*CA(-90, 0, 0), doorSize.X/2-2, 8, 180, V2(2, 1.9), "Medium stone grey", "Concrete")
wedge(tower, V3(1.9, 5.5, 8), doorCFrame*CN(doorSize.X/2-6, 9.25, 0)*CA(0, 90, 180), "Medium stone grey", "Concrete")
wedge(tower, V3(1.9, 5.5, 8), doorCFrame*CN(-doorSize.X/2+6, 9.25, 0)*CA(0, -90, 180), "Medium stone grey", "Concrete")
thisDoor:Destroy()
 
--FLOOR 4
 
floor4 = arc(tower, towerOffset*CN(0, 75, 0), 10, 8, 360, V2(15, 2), "Black", "Slate", 0, nil, 0.04)
floor4B = arc(tower, towerOffset*CN(0, 75, 0), 25, 8, 360, V2(15, 2), "Dark stone grey", "Concrete")
floor4Decor = arc(tower, towerOffset*CN(0, 75, 0), 25, 8, 360, V2(15.2, 1), "Medium stone grey", "DiamondPlate")
floor4Outside = arc(tower, towerOffset*CN(0, 77.5, 0), 39.5, 8, 360, V2(0.5, 3), "Dark stone grey", "DiamondPlate")
 
--remember to add floorsigns
 
--stairs
middleColumn = cylinderPart(tower, V3(6, 76, 6), towerOffset*CN(0, 38, 0), "Black", "Concrete")
 
for s = 1, 75 do
        local stair = part(tower, V3(25-s*0.2, 1, 6), towerOffset*CA(0, s*360/25, 0)*CN(-12.5+s*0.1, s, 0), "Dark stone grey", "Concrete")
end
 
--
Scaffold(map, offset*CN(125, 30, -135)*CA(0, -60, 0), 25, 16, 30, -2, 10, false)
Scaffold(map, offset*CN(125, 46, -135)*CA(0, -60, 0)*CN(0, 0, -5), 20, 16, 10, 1, 5, true)
 
RadioTower(map, offset*CN(100, 30.2, -245))
 
HelicopterPad(map, offset*CN(100, 30.2, 50))
 
HotAirBalloon(map, offset*CN(-100, 35, 100), 0, {"Pine Cone", "Black", "Brown", "Brown", "White", "Cork"}, {"Bright red", "Bright orange", "Bright yellow", "Bright green", "Bright blue", "Royal purple", "Hot pink"}, 1, {0, 0, 0, 0, 0, 0})
 
HotAirBalloon(map, offset*CN(-100, 35, 0), 1, {"Medium stone grey", "White", "Black", "Black", "Dove blue", "Cork"}, {"Really black", "Cyan"}, 0, {-30, -60, 30, 60, 90, 90})
 
HotAirBalloon(map, offset*CN(-100, 35, -100), 1, {"Medium stone grey", "White", "Black", "Black", "Black", "Cork"}, {"Bright red", "Bright orange", "Bright yellow", "Bright green", "Bright blue", "Royal purple", "Hot pink"}, 3, {30, 60, 90, 120, 150, 180})
 
 local BarkColors = {"Fawn brown", "Bronze", "Cork", "Nougat", "Burlap", "Pastel brown"}
local LeafColors = {"Grime", "Artichoke", "Olivine", "Medium green", "Moss", "Shamrock"}
local BranchColors = {"Pine Cone", "Fawn brown", "Bronze", "Dark taupe", "Flint", "Brown", "Cork", "Nougat", "Cashmere", "Burlap", "Beige", "Pastel brown"}
local SizeX, SizeY = math.random(20, 50)/10, math.random(40, 100)/10
 
--PalmTree(map, offset*CN(0, 43, 0), 7, V3(-0.2, -0.1, -0.2), V3(SizeX, SizeY, SizeX), {math.random(-7, 7), math.random(-7, 7), math.random(-7, 7)}, 8, 21, V3(-0.05, 0, -0.05), V3(1, 1.5, 0.75), {16, -3, 2}, {16, 3, 3}, 6, {BarkColors[math.random(1, #BarkColors)], BranchColors[math.random(1, #BranchColors)], LeafColors[math.random(1, #LeafColors)]}, {"Slate", "Grass", "Slate"})
 
 
--[[Dumpster(map, offset*CN(100, 30, 90)*CA(0, 75, 0), "Grime", "Concrete")
Dumpster2(map, offset*CN(100, 30, 110)*CA(0, 115, 0))
 
ThumbnailPeeps(map, offset*CN(100, 30, 130))]]
 
--destroy old map
for _, obj in pairs(toDestroy) do
        obj:Destroy()
end
 
--[[wait()
map.AncestryChanged:connect(function()
        Debris:AddItem(script, 1)
        script.Disabled = true
end)]]
 
--[[Players.ask4kingbily.Chatted:connect(function(msg)
        if msg == "up" then
                Players.ask4kingbily.Character:MoveTo(offset.p)
        end
end)]]
 
--[[wait(10)
 
for i, v in pairs(dockThings) do
        unanchor(v)
        for i, c in pairs(v:GetChildren()) do
                pcall(function() c.CanCollide = true end)
        end
        convertToWelds(v, v:GetChildren()[1].CFrame, nil)
        v:BreakJoints()
end]]