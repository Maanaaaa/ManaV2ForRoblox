--[[
    cool esp Library
    made this in order to optimize and evade copying and pasting the same code in game supports

    Made by Maanaaaa
]]
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local library = {}

local function runFunction(func) return func() end

local function isAlive(plr, headCheck)
    local Player = plr or players.LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    end
    return false
end

local function getCharacter(plr)
    return plr.Character or plr.CharacterAdded:Wait()
end

local function getPlrByCharacter(character)
    for _, plr in next, players:GetPlayers() do
        if plr.Character == character then
            return plr
        end
    end
end

local function getHumanoid(plr)
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChildOfClass("Humanoid")
    end
end

local function getHumanoidRootPart(plr)
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("HumanoidRootPart")
    end
end

local function getHead(plr)
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("Head")
    end
end

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

function library:create(name, oneObject, custom)
    local connections = {}
    local obj
    local api = {
        name = name,
        enabled = false,
        mode = "Highlight",
        color = Color3.fromRGB(255, 255, 255),
        adorneePart = "HumanoidRootPart",
        --lineThickness = 0,
        --surfaceTransparency = 0,
        boxHandleAlwaysOnTop = true,
        highlightAlwaysOnTop = true,
        outline = true,
        outlineMode = "Custom",
        outlineColor = Color3.fromRGB(255, 255, 255),
        outlineTransparency = 0,
        fill = false,
        fillMode = "Custom",
        fillColor = Color3.fromRGB(255, 255, 255),
        fillTransparency = 0,
        transparency = 0,
        useTeamColor = false,
        teammates = false,
        modesList = {
            "BoxHandleAdornment",
            "Highlight"
        },
        objectNames = {
            --"SelectionBoxObject",
            "BoxHandleAdornmentObject",
            "HighlightObject"
        }
    }
    function api:removeEspObject(plr, obj)
        local character
        if custom then
            character = obj
        else
            character = plr.Character
        end
        if not character then return end
        for _, objName in ipairs(api.objectNames) do
            local obj = character:FindFirstChild(api.name..objName)
            if obj then
                obj:Destroy()
            end
        end
    end
    function api:removeAllEspObjects()
        for _, plr in next, players:GetPlayers() do
            api:removeEspObject(plr)
        end
    end
    function api:updateEspObject(plr, obj)
        local adorneePart, character, teamColor, color
        if custom then
            adorneePart = obj
            character = obj
        else
            if plr == localPlayer then return end
            character = plr.Character
            if not character then return end

            teamColor = api.useTeamColor and plr.Team and plr.TeamColor
            color = api.useTeamColor and plr.Team and plr.TeamColor or api.color
            adorneePart = ((api.adorneePart == "Character" or obj == character) and character) or (api.adorneePart == "HRP" and character:FindFirstChild("HumanoidRootPart")) or (obj and character:FindFirstChild(obj.Name)) or character:FindFirstChild(api.adorneePart)
        end

        --[[
        if api.mode == "SelectionBox" then
            local boxObject = character:FindFirstChild(api.name.."SelectionBoxObject")
            if not boxObject then
                boxObject = Instance.new("SelectionBox")
                boxObject.Name = api.name.."SelectionBoxObject"
                boxObject.Parent = character
            end
            boxObject.Adornee = adorneePart
            boxObject.LineThickness = api.lineThickness
            boxObject.SurfaceColor3 = color
            boxObject.SurfaceTransparency = api.surfaceTransparency
            boxObject.Transparency = api.transparency
        else]]
        if api.mode == "BoxHandleAdornment" then
            local object
            if oneObject then
                object = character:FindFirstChild(api.name.."BoxHandleAdornmentObject")
                if not object then
                    object = Instance.new("BoxHandleAdornment")
                    object.Name = api.name.."BoxHandleAdornmentObject"
                    object.Parent = character
                end
            else
                object = Instance.new("BoxHandleAdornment")
                object.Name = api.name.."BoxHandleAdornmentObject"
                object.Parent = character
            end

            if object.Adornee ~= adorneePart then
                object.Adornee = adorneePart
            end

            object.Size = ((api.adorneePart == "Full Character" or adorneePart:IsA("Model")) and adorneePart:GetExtentsSize()) or adorneePart.Size
            object.AlwaysOnTop = api.boxHandleAlwaysOnTop
            object.Color3 = color
            object.Transparency = api.transparency
        elseif api.mode == "Highlight" then
            local object
            if oneObject then
                object = character:FindFirstChild(api.name.."HighlightObject")
                if not object then
                    object = Instance.new("Highlight")
                    object.Name = api.name.."HighlightObject"
                    object.Parent = character
                end
            else
                object = Instance.new("Highlight")
                object.Name = api.name.."HighlightObject"
                object.Parent = character
            end

            object.Adornee = adorneePart or character
            object.OutlineColor = (api.useTeamColor and plr.Team and plr.TeamColor.Color) or api.outlineColor
            object.OutlineTransparency = (api.outline and api.outlineTransparency) or 1
            object.FillColor = (api.useTeamColor and plr.Team and plr.TeamColor.Color) or api.fillColor
            object.FillTransparency = (api.fill and api.fillTransparency) or 1
            object.DepthMode = api.highlightAlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        end
    end
    function api:updateAll()
        for _, plr in next, players:GetPlayers() do
            if isAlive(plr) then
                api:updateEspObject(plr)
            end
        end
    end
    function api:start()
        for _, plr in next, players:GetPlayers() do
            api:updateEspObject(plr)
            table.insert(connections, plr.CharacterAdded:Connect(function()
                api:updateEspObject(plr)
            end))
        end
        table.insert(connections, players.PlayerAdded:Connect(function(plr)
            api:updateEspObject(plr)
        end))
    end
    function api:stop()
        for _, connection in next, connections do
            betterDisconnect(connection)
        end
        for _, plr in next, players:GetPlayers() do
            api:removeEspObject(plr)
        end
    end
    return api
end

return library