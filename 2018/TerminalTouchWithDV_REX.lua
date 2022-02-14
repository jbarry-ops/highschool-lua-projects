local V3, CN, BN = Vector3.new, CFrame.new, BrickColor.new
local Players, Teams = Game:GetService("Players"), Game:GetService("Teams")

local competition = {
	["Nobody"] = {"White", 0, 0},
	["Stalemate"] = {"Bright blue"}
	["Golden Nightmare"] = {"Bright yellow", 0, 0},
	["Raiders"] = {"Bright red", 0, 0}
}

local currentTeam = "Nobody"
local requiredTime = 10 --seconds required to win the match.
local zoneSize = V3()
local zoneType = "Platform" --Platform zone





local newPad = Instance.new("Part")
newPad.Size = Vector3.new(30, 1, 30)
newPad.Anchored = true
newPad.CFrame = CFrame.new(0, 4, 0)
newPad.Name = "TerminalTouch"
newPad.Parent = Workspace

--Zone types: 

local Teams = Game:GetService("Teams")
local goldenTeam = Instance.new("Team", Teams)
goldenTeam.Name = "Golden Nightmare"
local raidersTeam = Instance.new("Team", Teams)
raidersTeam.Name = "Raiders"

local zone = Workspace:FindFirstChild("TerminalTouch")
print(zone and "Zone exists." or "Zone doesn't exist!")
local shape = pad.Shape

--ClientEvent = game.ReplicatedStorage.TerminalClient

local display = Workspace:FindFirstChild("")Instance.new("Hint", Workspace)

local Players = Game:GetService("Players")

function announceTeamVictory(teamName) display.Text = "Current Team: "..CurrentTeam.." | Players: "..Competitors[CurrentTeam][1].." | Count: "..Competitors[CurrentTeam][2].."/"..TimeWanted.." | "..teamName.." has won!" end
function resetTeamTimers() for t = 2, #Competitors do Competitors[t][2] = 0 end end
function countCompetitors() local sum = 0 for t = 2, #Competitors do sum = sum + Competitors[t][1] end return sum end

function getCurrentTeam()
    local winner = "Nobody"
    if countCompetitors() <= 0 then return "Nobody" end
    for t, team in pairs(Competitors) do
        if team[1] > Competitors[winner][1] then
            winner = t
        end
    end
    return winner
end

function checkForStalemate()
    local stalemate = false
    for t, team in pairs(Competitors) do
        if team[1] == Competitors[CurrentTeam] then
            stalemate = true
        end
    end
    return stalemate
end

local function touched(part)
    local character = part.Parent
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        print(player.Name.." touched it!")
        local team = player.Team
        local name = team.Name
        print(name)
        Competitors[name][1] = Competitors[name][1] + 1
        --if Competitors[name][1] >= 7 then
            --announceTeamVictory(name)
        --end
    end
end

local function touchEnded(part)
    local character = part.Parent
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        print(player.Name.." stopped touching it!")
        local team = player.Team
        local name = team.Name
        Competitors[name][1] = Competitors[name][1] - 1
    end
end

pad.Touched:connect(touched)
pad.TouchEnded:connect(touchEnded)
pad.AncestryChanged:connect(function() script:Destroy() display:Destroy() end)

while true do
	wait(1)
	
end
