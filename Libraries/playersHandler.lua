local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local lplr = players.LocalPlayer
local camera = workspace.CurrentCamera
local friends = shared.Mana.Friends
local handler = {
    players = {},
    entities = {},
    character = {},
    connections = {},
    lconnections = {},
    threads = {},
    realcharacter = nil,
    alive = false,
    started = false
}

function handler:isAlive(plr, headCheck)
    local Player = plr or lplr
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    end
    return false
end

function handler:targetCheck(plr, forcefieldcheck)
    return (forcefieldcheck and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or forcefieldcheck == false)
end

function handler:isPlayerTargetable(plr, forcefieldcheck)
    return plr ~= lplr and plr and handler:isAlive(plr) and handler:targetCheck(plr, forcefieldcheck)
end

function handler:isSameTeam(player)
    return player.Team == lplr.Team
end

function handler:getClosestPlayer(maxDisance, teamCheck)
    local MaximumDistance = maxDisance
	local Target = nil
	for _, v in next, players:GetPlayers() do
		if v.Name ~= lplr.Name then
			if teamCheck then
				if v.Team ~= lplr.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(userInputService:GetMouseLocation().X, userInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(userInputService:GetMouseLocation().X, userInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end
	return Target
end

function handler:getNearPlayers(distance)
    local nearPlayers = {}
    for _, plr in next, players:GetPlayers() do
        if plr ~= lplr and handler:isAlive(plr) then
            local distance = (lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if distance <= distance then
                table.insert(nearPlayers, plr)
            end
        end
    end
    return nearPlayers
end

--[[
function handler:getColorFromPlayer(plr) 
    if plr.Team ~= nil then return plr.TeamColor.Color end
end
]]

-- this was made by Wowzers
function handler:convertHealthToColor(health, maxHealth)
    -- Input validation
    if type(health) ~= "number" or type(maxHealth) ~= "number" then
        return Color3.fromRGB(255, 255, 255) -- Default white for invalid inputs
    end

    if maxHealth <= 0 then
        return Color3.fromRGB(255, 0, 0) -- Red for invalid max health
    end

    if health <= 0 then
        return Color3.fromRGB(255, 0, 0) -- Red for zero health
    end

    -- Calculate health percentage (0 to 100)
    local percent = math.clamp((health / maxHealth) * 100, 0, 100)

    -- Define color ranges
    local colors = {
        {percent = 0,   r = 255, g = 0,   b = 0},   -- Red at 0%
        {percent = 30,  r = 255, g = 71,  b = 71},  -- Light red at 30%
        {percent = 50,  r = 255, g = 196, b = 0},   -- Yellow at 50%
        {percent = 70,  r = 180, g = 225, b = 25},  -- Yellow-green at 70%
        {percent = 100, r = 96,  g = 253, b = 48}   -- Green at 100%
    }

    -- Find the two color points to interpolate between
    local lowerColor, upperColor

    for i = 1, #colors - 1 do
        if percent >= colors[i].percent and percent <= colors[i+1].percent then
            lowerColor = colors[i]
            upperColor = colors[i+1]
            break
        end
    end

    -- Calculate interpolation factor between the two color points
    local range = upperColor.percent - lowerColor.percent
    local factor = (percent - lowerColor.percent) / range

    -- Interpolate RGB values
    local r = math.floor(lowerColor.r + (upperColor.r - lowerColor.r) * factor)
    local g = math.floor(lowerColor.g + (upperColor.g - lowerColor.g) * factor)
    local b = math.floor(lowerColor.b + (upperColor.b - lowerColor.b) * factor)

    return Color3.fromRGB(r, g, b)
end

-- this was made by Wowzers too
local function IsInRange(player, distance, part)
    if not handler:isAlive(player) or not handler:isAlive() then return false end
    
    local TargetRoot = player.Character:FindFirstChild(part) or player.Character.HumanoidRootPart
    local Distance = (handler.character.humanoidRootPart.Position - TargetRoot.Position).Magnitude
    
    return Distance <= distance
end

function handler:isVisible(pos, wallCheck, ...)
    if not wallCheck then
        return true
    end
    return #camera:GetPartsObscuringTarget({pos}, {camera, lplr.Character, ...}) == 0
end

function handler:getClosestPlayerToMouse(fov, teamCheck, aimPart, wallCheck)
    local aimFov = fov
    local aimPart = aimPart or "Head"
    local targetPosition = nil
    for _, Player in pairs(players:GetPlayers()) do
        if Player ~= lplr then
            local Character = Player.Character
            if handler:isAlive(Player) and Character:FindFirstChild(aimPart) then
                if not teamCheck or ((teamCheck and Player.Team ~= lplr.Team) or (teamCheck and (Player.Team == nil or Player.Team == "nil") and Player.Neutral == true)) then
                    local ScreenPosition, OnScreen = camera:WorldToViewportPoint(Character[aimPart].Position)
                    if OnScreen then
                        local ScreenPosition2D = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                        local NewMagnitude = (ScreenPosition2D - userInputService:GetMouseLocation()).Magnitude
                        if NewMagnitude < aimFov and handler:isVisible(Character[aimPart].Position, wallCheck, Character) then
                            aimFov = NewMagnitude
                            targetPosition = Player
                        end
                    end
                end
            end
        end
    end
    return targetPosition
end

function handler:getValidTargets(mode, maxTargets)
    if not handler:getHumanoidRootPart(lplr) then return {} end
    
    local ValidTargets = {}
    
    for _, player in ipairs(players:GetPlayers()) do
        pcall(function()
            if player ~= lplr and handler:isAlive(player) and handler:isInRange(player) and not handler:isSameTeam(player) and not handler:isIgnored(player) and IsWhitelisted(player) then
                table.insert(ValidTargets, player)
            end
        end)
    end
    
    if mode == "Closest" then
        pcall(function()
            table.sort(ValidTargets, function(a, b)
                if not (a.Character and a.Character:FindFirstChild("HumanoidRootPart") and 
                       b.Character and b.Character:FindFirstChild("HumanoidRootPart")) then
                    return false
                end
                
                local DistA = (handler.character.humanoidRootPart.Position - a.Character.HumanoidRootPart.Position).Magnitude
                local DistB = (handler.character.humanoidRootPart.Position - b.Character.HumanoidRootPart.Position).Magnitude
                return DistA < DistB
            end)
        end)
    elseif mode == "LowestHealth" then
        pcall(function()
            table.sort(ValidTargets, function(a, b)
                if not (a.Character and a.Character:FindFirstChild("Humanoid") and 
                       b.Character and b.Character:FindFirstChild("Humanoid")) then
                    return false
                end
                
                return a.Character.Humanoid.Health < b.Character.Humanoid.Health
            end)
        end)
    elseif mode == "HighestHealth" then
        pcall(function()
            table.sort(ValidTargets, function(a, b)
                if not (a.Character and a.Character:FindFirstChild("Humanoid") and 
                       b.Character and b.Character:FindFirstChild("Humanoid")) then
                    return false
                end
                
                return a.Character.Humanoid.Health > b.Character.Humanoid.Health
            end)
        end)
    end
    
    -- Limit the number of targets
    local LimitedTargets = {}
    for i = 1, math.min(#ValidTargets, maxTargets) do
        table.insert(LimitedTargets, ValidTargets[i])
    end
    
    return LimitedTargets
end

function handler:isFriend(name)
    for _, friend in next, friends do
        if friend == name or name == friend then
            return true
        end
    end
    return false
end

function handler:getPlrByCharacter(character)
    for _, plr in next, players:GetPlayers() do
        if plr.Character == character then
            return plr
        end
    end
end

function handler:getHumanoid(plr)
    if handler:isAlive(plr) then
        return plr.Character:FindFirstChildOfClass("Humanoid")
    end
    return
end

function handler:getHumanoidRootPart(plr)
    if handler:isAlive(plr) then
        return plr.Character:FindFirstChild("HumanoidRootPart")
    end
end

function handler:getHead(plr)
    if handler:isAlive(plr) then
        return plr.Character:FindFirstChild("Head")
    end
end

function handler:getEntity(character)
    for _, entity in handler.entities do
        if entity.player == character or entity.Character == character then
            return entity, _
        end
    end
    return
end

function handler:addEntity(character, plr, func)
    if not character or not plr then return end
    handler.threads[character] = task.spawn(function()
        local humanoid = handler:getHumanoid(plr)
        local hrp = handler:getHumanoidRootPart(plr)
        local head = handler:getHead(plr)
        if humanoid and hrp then
            local ent = {
                connections = {},
                character = character,
                health = humanoid.Health,
                head = head,
                humanoid = humanoid,
                humanoidRootPart = hrp,
                hipHeight = humanoid.HipHeight + (hrp.Size.Y / 2) + (humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
                maxHealth = humanoid.MaxHealth,
                npc = plr == nil,
                player = plr,
                rootPart = hrp,
                teamCheck = func or function() end
            }
            if plr == lplr then
                handler.character = table.unpack(ent)
                handler.realcharacter = character
                handler.alive = handler:isAlive()
            else
                ent.targetable = handler:targetCheck(plr)
                handler.entities[plr] = table.unpack(ent)
            end
        else
        end
    end)
end

function handler:removeEntity(character)
    local entity, index = handler:getEntity(character)
    if entity and index then
        for _, connection in next, entity.connections do
            connection:Disconnect()
        end
        table.clear(entity.connections)
        table.remove(handler.entities, index)
        --table.remove(handler.threads, character)
    end
end

function handler:updateEntity(character, player)
    handler:removeEntity(character)
    handler:addEntity(character, player)
end

function handler:addPlayer(character, plr)
    table.insert(handler.players, plr)
    handler:addEntity(character, plr)
    handler.connections[plr] = {
        plr.CharacterAdded:Connect(function(character)
        handler:updateEntity(character, plr)
    end),

    plr.CharacterRemoving:Connect(function()
        handler:removeEntity(plr.Character)
    end)
    }
end

function handler:removePlayer(plr)
    if handler.players[plr] == nil then return end
    handler.players[plr] = nil
    handler:removeEntity(plr.Character)
    for  _, connection in next, handler.connections[plr] do
        connection:Disconnect()
    end
end

function handler:start()
    if handler.started then return end
    handler.started = true
    for _, plr in next, players:GetPlayers() do
        handler:addPlayer(plr.Character, plr)
    end
    handler.connections["playerAdded"] = players.PlayerAdded:Connect(function(plr)
        handler:addPlayer(plr.Character, plr)
    end)
    handler.connections["playerRemoving"] = players.PlayerRemoving:Connect(function(plr)
        handler:removePlayer(plr)
    end)
end

function handler:fullUpdate()
    for _, plr in next, players:GetPlayers() do
        handler:updateEntity(plr.Character, plr)
    end
end

function handler:stop()
    if not handler.started then return end
    handler.started = false
    for _, plr in next, players:GetPlayers() do
        handler:removePlayer(plr)
    end
    for _, connection in next, handler.connections do
        connection:Disconnect()
    end
    for _, connection in handler.lconnections do
        connection:Disconnect()
    end
    table.clear(handler.connections)
end

return handler