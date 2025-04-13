--[[
    Credits to anyones code I used or looked at

    Removed the key system permamently.
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local PlaceId = game.PlaceId
local JobId = game.JobId
local saveasuniversal = false
local loadasuniversal = false
local SliderScaleValue = 1
local Functions = {}
local LocalPlayerEvents = {}
local Mana = {Connections = {}, Friends = {}}

local httprequest = (request and http and http.request or http_request or fluxus and fluxus.request)
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local function runFunction(func) func() end

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
    if tab.Method == "GET" then
        return {
            Body = game:HttpGet(tab.Url, true),
            Headers = {},
            StatusCode = 200
        }
    else
        return {
            Body = "bad exploit",
            Headers = {},
            StatusCode = 404
        }
    end
end 

local betterisfile = function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil
end

local function isAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and (Player.Character:FindFirstChild("HumanoidRootPart")) and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

if shared.Mana then 
    warn("[ManaV2ForRoblox]: Already loaded.")
    Mana.GuiLibrary:playsound("rbxassetid://421058925", 1)
    return
end

do
    function Functions:RunFile(filepath)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath,
            Method = "GET"
        })
        if isfile("NewMana/"..filepath) and shared.ManaDeveloper then
            print("MEEEEEEE " .. filepath)
            return loadstring(readfile("NewMana/" .. filepath))()
        elseif not betterisfile(filepath) and not shared.ManaDeveloper then -- auto update workspace files
                local context = req.Body
                writefile(filepath, context)
            return loadstring(context)()
        else
            if isfile("Mana/" .. filepath) then
                return loadstring(readfile("Mana/" .. filepath))()
            else
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath))()
            end
        end
    end
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}

do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = RunService.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = RunService.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func) 
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = RunService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

shared.Mana = Mana
local GuiLibrary = Functions:RunFile("GuiLibrary.lua")--loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/refs/heads/main/GuiLibrary.lua"))()
local entityHandler = Functions:RunFile("Libraries/playersHandler.lua") --loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua"))()
local toolHandler = Functions:RunFile("Libraries/toolHandler.lua")
local whitelistHandler = Functions:RunFile("Libraries/whiltelistHandler.lua")
Mana.GuiLibrary = GuiLibrary
Mana.Functions = Functions
Mana.RunLoops = RunLoops
Mana.EntityHandler = entityHandler
Mana.ToolHandler = toolHandler
Mana.WhitelistHandler = whitelistHandler
Mana.Activated = true
Mana.Whitelisted = false

GuiLibrary:CreateWindow()

local Tabs = {
    Combat = GuiLibrary:CreateTab({
        Name = "Combat",
        Color = Color3.fromRGB(252, 60, 68),
        Visible = true,
        TabIcon = "CombatTabIcon.png",
        Callback = function() end
    }),
    Movement = GuiLibrary:CreateTab({
        Name = "Movement",
        Color = Color3.fromRGB(255, 148, 36),
        Visible = true,
        TabIcon = "MovementTabIcon.png",
        Callback = function() end
    }),
    Render = GuiLibrary:CreateTab({
        Name = "Render",
        Color = Color3.fromRGB(59, 170, 222),
        Visible = true,
        TabIcon = "RenderTabIcon.png",
        Callback = function() end
    }),
    Utility = GuiLibrary:CreateTab({
        Name = "Utility",
        Color = Color3.fromRGB(83, 214, 110),
        Visible = true,
        TabIcon = "MiscTabIcon.png", --"UtilityTabIcon",
        Callback = function() end
    }),
    World = GuiLibrary:CreateTab({
        Name = "World",
        Color = Color3.fromRGB(52 ,28, 228),
        Visible = true,
        TabIcon = "WorldTabIcon.png",
        Callback = function() end
    }),
    Settings = GuiLibrary:CreateTab({
        Name = "Settings",
        Color = Color3.fromRGB(240, 157, 62),
        Visible = true,
        TabIcon = "MiscTabIcon.png",
        Callback = function() end
    }),
    Friends = GuiLibrary:CreateTab({
        Name = "Friends",
        Color = Color3.fromRGB(240, 157, 62),
        Visible = true,
        TabIcon = "PlayerImage.png",
        Callback = function() end
    }),
    FE = GuiLibrary:CreateTab({
        Name = "FE + Trolling",
        Color = Color3.fromRGB(255, 0, 34),
        Visible = true,
        TabIcon = "Utility.png",
        Callback = function() end
    })
    --[[
    SessionInfo = GuiLibrary:CreateCustomTab({
        Name = "Session info",
        Color = Color3.fromRGB(240, 157, 62)
    })
    ]]
}

Mana.Tabs = Tabs

if GuiLibrary.Device == "Mobile" then
    SliderScaleValue = 0.5
end

-- Settings tab
runFunction(function()
    local onrejoin = {Value = true}
    local asbase = {Value = false}
    local autosaveonrejoin = {Value = false}
    local delay = {Value = 15}

    local divider = Tabs.Settings:CreateSecondDivider("Config")

    local autosave = Tabs.Settings:CreateSecondToggle({
        Name = "AutoSave",
        Callback = function(callback)
            if callback then
                while callback and wait(delay.Value) do
                    if asbase.Value then
                        GuiLibrary:SaveConfig(true)
                    else
                        GuiLibrary:SaveConfig()
                    end
                end
            end
        end
    })

    --[[
    asbase = Tabs.Settings:CreateSecondToggle({
        Name = "Save as universal config",
        Callback = function(callback) 
            saveasuniversal = callback
        end
    })
    ]]

    autosaveonrejoin = Tabs.Settings:CreateSecondToggle({
        Name = "On rejoin",
        Callback = function(v) end
    })

    delay = Tabs.Settings:CreateSlider({
        Name = "Delay",
        Function = function(v)
        end,
        Min = 1,
        Max = 60,
        Default = 15,
        Round = 0
    })

    local resetconfig = Tabs.Settings:CreateButton({
        Name = "ResetConfig",
        Callback = function()
        Mana = nil
        GuiLibrary:Destruct()
        if isfile("Mana/Config/" .. game.PlaceId .. ".json") then delfile("Mana/Config/" .. game.PlaceId .. ".json") end
        Functions:RunFile("MainScript.lua")
        end
    })
end)

runFunction(function()
    local soundvolume = {Value = 1}
    local uiscale = {Value = 1}
    local uicornersradius = {Value = 4}

    local divider = Tabs.Settings:CreateSecondDivider("UI")

    local notifications = Tabs.Settings:CreateSecondToggle({
        Name = "Notifications",
        Callback = function(callback)
            GuiLibrary.Notifications = callback
        end
    })

    local sounds = Tabs.Settings:CreateSecondToggle({
        Name = "Sounds",
        Callback = function(callback)
            GuiLibrary.Sounds = callback
            if soundvolume.MainObject then
                soundvolume.MainObject.Visible = callback
            end
        end
    })

    soundvolume = Tabs.Settings:CreateSlider({
        Name = "Volume",
        Function = function(v)
            GuiLibrary.SoundVolume = v
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 2
    })

    uiscale = Tabs.Settings:CreateSlider({
        Name = "UI scale",
        Function = function(v)
            GuiLibrary.UIScale.Scale = v
        end,
        Min = 0.5,
        Max = 2,
        Default = 1,
        Round = 2
    })

    local uicorners = Tabs.Settings:CreateSecondToggle({
        Name = "UI corners",
        Callback = function(callback)
            GuiLibrary.UICorners = callback
            if uicornersradius.MainObject then
                uicornersradius.MainObject.Visible = callback
            end
        end
    })

    uicornersradius = Tabs.Settings:CreateSlider({
        Name = "Radius",
        Function = function(v)
            GuiLibrary.UICornersRadius = v
        end,
        Min = 0,
        Max = 10,
        Default = 4,
        Round = 0
    })
end)

runFunction(function()
    local divider = Tabs.Settings:CreateSecondDivider("Slider")

    local sliderdoubleclick = Tabs.Settings:CreateSecondToggle({
        Name = "Double click",
        Callback = function(callback)
            GuiLibrary.SliderDoubleClick = callback
        end
    })

    local slidercanoverride = Tabs.Settings:CreateSecondToggle({
        Name = "Value override",
        Callback = function(callback)
            GuiLibrary.SliderCanOverride = callback
        end
    })
end)

runFunction(function()
    local divider = Tabs.Settings:CreateSecondDivider("TextList")

    local textlistlmb = Tabs.Settings:CreateSecondToggle({
        Name = "LMB to delete",
        Callback = function(callback)
            GuiLibrary.TextListLMB = callback
        end
    })

    local textlistrmb = Tabs.Settings:CreateSecondToggle({
        Name = "RMB to delete",
        Callback = function(callback)
            GuiLibrary.TextListRMB = callback
        end
    })
end)

runFunction(function()
    local divider = Tabs.Settings:CreateSecondDivider("Other")

    local sorttabs = Tabs.Settings:CreateButton({
        Name = "Sort tabs",
        Callback = function()
            local xoffset = 40 -- Horizontal spacing between tabs
            local yoffset = 40 -- Vertical spacing from the top
            local rowWidth = 7 -- Number of tabs per row before wrapping
            local totalyoffset = 247 -- Horizontal distance between tabs
    
            -- Collect and sort tabs by their defined order
            local tabs = {}
            for _, v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
                if v.Type == "Tab" then
                    table.insert(tabs, v)
                end
            end
            table.sort(tabs, function(a, b) return a.Table.Order < b.Table.Order end)
    
            -- Position tabs properly in a grid-like format
            for index, tabData in ipairs(tabs) do
                local tab = tabData.Table.MainObject
                local row = math.floor((index - 1) / rowWidth) -- Determines row
                local col = (index - 1) % rowWidth -- Determines column
    
                tab.Position = UDim2.new(0, xoffset + (col * totalyoffset), 0, yoffset + (row * 50)) -- Adjust row height spacing
            end
        end
    })
    

    local unpinall = Tabs.Settings:CreateButton({
        Name = "Pin/Un pin all tabs",
        Callback = function()
            for i, v in next, GuiLibrary.ObjectsThatCanBeSaved do
                if v.Type == "Tab" then
                    v.Table:Pin(false)
                end
            end
        end
    })

    local uninject = Tabs.Settings:CreateButton({
        Name = "Uninject",
        Callback = function()
            GuiLibrary:SaveConfig(saveasuniversal)
            Mana = nil
            GuiLibrary:Destruct()
        end
    })

    local reinject = Tabs.Settings:CreateButton({
        Name = "Reinject",
        Callback = function()
            GuiLibrary:SaveConfig(saveasuniversal)
            Mana = nil
            GuiLibrary:Destruct()
            Functions:RunFile("MainScript.lua")
        end
    })

    local copydiscordinvite = Tabs.Settings:CreateButton({
        Name = "Copy Discord invite",
        Callback = function()
            toclipboard("https://discord.gg/gPkD8BdbMA")
        end
    })
end)

-- Friends tab
runFunction(function()
    local Friends = {List = {}}
    local list = {}
    Mana.Friends = list

    Friends = Tabs.Friends:CreateTextList({
        Name = "Friends",
        List = {},
        PlaceholderText = "Friend Name",
        Callback = function(v)
            if list.v then
                table.remove(Friends.List, list.v)
                list.v = nil
            else
                table.insert(Friends.List, v)
            end
        end
    })
end)

-- Session/GameInfo tab
--[[
runFunction(function()
    local function createlabel(text)
        local label = Instance.new("TextLabel")
        label.Parent = Tabs.SessionInfo:GetMainObject()
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 207, 0, 40)
        label.Font = Enum.Font.Arial
        label.Text = text
        label.TextSize = 22
        label.TextXAlignment = Enum.TextXAlignment.Left

        return label
    end

    local gamename = createlabel("Name: "..game.Name)
    local gameid = createlabel("Game id: "..game.GameId)
    local placeid = createlabel("Place id: "..game.PlaceId)
end)
]]

local Button = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
Button.Name = "GuiButton"
Button.Position = UDim2.new(1, -200, 0, -32)
Button.Text = "Mana"
Button.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Size = UDim2.new(0, 32, 0, 32)
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 0.5
Button.Parent = GuiLibrary.ScreenGui
Corner.Parent = Button
Corner.CornerRadius = UDim.new(0, 8)

Button.MouseButton1Click:Connect(function()
    GuiLibrary:Toggle()
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.RightShift then
        GuiLibrary:Toggle()
    end
end)

print("[ManaV2ForRoblox/MainScript.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")
--print("[ManaV2ForRoblox/MainScript.lua]: Loaded newest version.")

UniversalScript = Functions:RunFile("Universal.lua")
local suc, res = pcall(function()
    Functions:RunFile("Scripts/" .. PlaceId .. ".lua")
end)
if not suc then warn("[ManaV2ForRoblox/MainScript.lua]: an error occured while attempting to load game script: " .. res) end

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        local QueueTeleportFunction = [[
            if shared.ManaDeveloper then 
                loadstring(readfile("NewMana/MainScript.lua"))()
            else 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/MainScript.lua"))()
            end
        ]]
        queueteleport(QueueTeleportFunction)
    end
end)

GuiLibrary:LoadConfig()
GuiLibrary:Toggle()

-- Chat commands

--[[
runFunction(function()
    local whilelist = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/Whitelist/refs/heads/main/Whitelist.json"))
    local commands = {
        reset = function()
            LocalPlayer.Character.Humanoid.Health = 0
        end,
        leave = function(args)
            args = args or "Forced to leave the server."
            LocalPlayer:Kick(tostring(args))
        end,
        rejoin = function()
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
        end,
        serverhop = function()
            TeleportService:Teleport(PlaceId)
        end,
        toggle = function(args)
            if not args then return end
            local split = string.split(args, " ")
            local togglename = split[1]
            local boolText = split[2]
            local bool = nil
            
            if boolText then
                boolText = string.lower(boolText)
                if boolText == "true" or boolText == "on" or boolText == "yes" then
                    bool = true
                elseif boolText == "false" or boolText == "off" or boolText == "no" then
                    bool = false
                end
            end
            
            for i, v in next, GuiLibrary.ObjectsThatCanBeSaved do
                if v.Type == "Toggle" and v.Table.Name:lower() == togglename:lower() then
                    bool = bool ~= nil and bool or not v.Table.Enabled
                    v.Table:Toggle(false, bool)
                    break
                end
            end
        end,
        sit = function(plr)
            local targetPlayer = plr and Players:FindFirstChild(plr) or LocalPlayer
            if isAlive(targetPlayer) then
                targetPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
            end
        end
    }

    local userIdToTag = {}
    local userIdToDeveloper = {}
    
    -- Process whitelist once to create lookup tables :>
    for player, tag in next, whilelist do
        if tag.UserId then
            userIdToTag[tag.UserId] = {
                Color = tag.Color,
                Chattag = tag.Chattag
            }
            
            if tag.Developer or tag.Developer == "true" then
                userIdToDeveloper[tag.UserId] = true
            end
        end
    end
    
    -- Check if the local player is even whitelisted in the first place
    if userIdToTag[LocalPlayer.UserId] then
        Mana.Whitelisted = true
        if userIdToDeveloper[LocalPlayer.UserId] then
            Mana.Developer = true
        end
        
        -- Setting up the message handler 
        TextChatService.OnIncomingMessage = function(message)
            local properties = Instance.new("TextChatMessageProperties")
            
            -- Process commands if the message is from the local player itself
            if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                local messageText = message.Text
                local prefix = ";"
                
                if string.sub(messageText, 1, 1) == prefix then
                    local fullCommand = string.sub(messageText, 2)
                    local split = string.split(fullCommand, " ")
                    local command = string.lower(split[1])
                    local args = #split > 1 and table.concat(split, " ", 2) or nil
                    
                    if commands[command] then
                        task.spawn(function()
                            pcall(commands[command], args)
                        end)
                    end
                end
            end
            
            -- Apply da chat tags
            if message.TextSource then
                local speakerUserId = message.TextSource.UserId
                local tagInfo = userIdToTag[speakerUserId]
                
                if tagInfo then
                    local prefixText = message.PrefixText or ""
                    properties.PrefixText = string.format('<font color="%s">%s</font> %s', 
                        tagInfo.Color, 
                        tagInfo.Chattag, 
                        prefixText)
                else
                    properties.PrefixText = message.PrefixText
                end
            else
                properties.PrefixText = message.PrefixText
            end
            
            return properties
        end
    end
end)
]]