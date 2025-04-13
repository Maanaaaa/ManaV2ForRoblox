local players = game:GetService("Players")
local lplr = players.LocalPlayer
local connection
local connection2
local handler = {
    currentTool = nil,
    started = false
}

function handler:tryAgain()
    warn("[ManaV2ForRoblox/toolHandler.lua]: local player is not alive or realcharacter is missing, trying again in 5 seconds.")
    wait(5)
    handler:start()
end
function handler:start()
    local entityHandler = shared.Mana.EntityHandler
    if entityHandler.isAlive == false or entityHandler.realcharacter == nil then 
        handler:tryAgain()
        return 
    end
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