--Magic script, with DV_REX and TheSleuthyMoose

local player = game:getService("Players").LocalPlayer
local character = player.Character
local humanoid = character:waitForChild("Humanoid")
local torso = character:waitForChild("Torso")

character:waitForChild("Animate").Disabled = true
spawn(function() for i, tracks in pairs(humanoid:GetPlayingAnimationTracks()) do tracks:Stop() end end)

--^^^^^^DISABLE DEFAULT ANIMATION^^^^

local RunService = game:getService("RunService")

local splashParticle = Instance.new("Part")
    splashParticle.Size = Vector3.new(3, 3, 3)
    splashParticle.Shape = "Ball"
    splashParticle.CanCollide = false
    splashParticle.Material = "Glass"
    splashParticle.BrickColor = BrickColor.new("Cyan")
    splashParticle.Transparency = 0.7
    splashParticle.TopSurface = 0
    splashParticle.BottomSurface = 0
    --splashParticle.Anchored = true

local particleMover = Instance.new("BodyVelocity")
    particleMover.maxForce = Vector3.new(math.huge, math.huge, math.huge)

local function particleHit(part)
    local a = part.Parent:findFirstChild("Humanoid")
    if a and part.Parent.name ~= player.Name then
        a:TakeDamage(30) --make each particle deal 30 damage.
    end
end

local splashEffects = {} --a table that we can add splash effects to, in order to keep track of them.
local explosionEffects = {}

local twirling = 0
local twirlMax = 36 --36 frames worth of twirl, turning 10 degrees each twirl will give us a nice thing. We might also want to make the character jump or somefin

local function splash(speed, quantity) --I got rid of pos because the pos will just be at your torso.
    local newFX = Instance.new("Model")
    for i = 1, quantity do
        local newParticle = splashParticle:Clone()
        newParticle.CFrame = torso.CFrame
        newParticle.Touched:connect(particleHit)
        
        local newMover = particleMover:Clone()
        local angle = math.rad(i*360/quantity)
        newMover.velocity = Vector3.new(math.sin(angle)*speed, 0, math.cos(angle)*speed)
        newMover.Parent = newParticle
        newParticle.Parent = newFX
        table.insert(splashEffects, newParticle)
    end
    local explosion = splashParticle:Clone() --I want to make a brief explosion effect (not a real "Explosion" object, but just a kind of shockwave-type effect, to give it more oomph.)
    explosion.CFrame = torso.CFrame
    explosion.Anchored = true
    explosion.Parent = newFX
    table.insert(explosionEffects, explosion)
    newFX.Parent = character
end

mouse = player:GetMouse()
mouse.KeyDown:connect(function(key)
    if key == "q" then
        splash(30, 10)
    end
end)






function updateFX() --update the splash FX by making them fade out. If they go invisible, then delete them.
    for i, v in next(splashEffects) do
        v.Transparency = v.Transparency+0.004 --increasing transparency, etc.
        if v.Transparency >= 1 then v:Destroy() end
    end
    for i, v in next(explosionEffects) do -- we will deal differently with the explosions FX
        local cf = v.CFrame
        v.Transparency = v.Transparency+0.004
        v.Size = v.Size+Vector3.new(0.4, 0.4, 0.4)
        v.CFrame = cf
    end
end

RunService.Stepped:connect(updateFX)
