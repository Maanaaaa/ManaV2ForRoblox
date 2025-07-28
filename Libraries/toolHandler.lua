--[[
    tool handler module
    
    Made by Maanaaaa
]]
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local connection
local connection2
local handler = {
    currentTool = nil,
    started = false
}

local function isAlive(Player, headCheck)
    local Player = Player or lplr
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

local function getCharacter(plr)
    return plr.Character or plr.CharacterAdded:Wait()
end

function handler:tryAgain()
    warn("[ManaV2ForRoblox/toolHandler.lua]: local player is not alive or realcharacter is missing, trying again in 5 seconds.")
    wait(5)
    handler:start()
end
function handler:start()
    if (not isAlive() and getCharacter(lplr) == nil) or not shared.Mana.PlayersHandler then 
        handler:tryAgain()
        return 
    end
    local entityHandler = shared.Mana.PlayersHandler
    handler.started = true
    if connection then connection:Disconnect() end
    if connection2 then connection2:Disconnect() end

    connection = entityHandler.realcharacter.ChildAdded:Connect(function(Child)
        if Child:IsA("Tool") then
            handler.currentTool = Child
        end
    end)
    
    connection2 = entityHandler.realcharacter.ChildRemoved:Connect(function(Child)
        if Child:IsA("Tool") then
            handler.currentTool = nil
        end
    end)
end

lplr.CharacterAdded:Connect(function()
    if handler.started then
        handler:start()
    end
end)

return handler