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
local playersHandler = Functions:RunFile("Libraries/playersHandler.lua") --loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua"))()
local toolHandler = Functions:RunFile("Libraries/toolHandler.lua")
--local whitelistHandler = Functions:RunFile("Libraries/whiltelistHandler.lua")
Mana.GuiLibrary = GuiLibrary
Mana.Functions = Functions
Mana.RunLoops = RunLoops
Mana.PlayersHandler = playersHandler
Mana.ToolHandler = toolHandler
--Mana.WhitelistHandler = whitelistHandler
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
    Profiles = GuiLibrary:CreateTab({
        Name = "Profiles",
        Color = Color3.fromRGB(255, 255, 255),
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
    --[[
    FE = GuiLibrary:CreateTab({
        Name = "FE + Trolling",
        Color = Color3.fromRGB(255, 0, 34),
        Visible = true,
        TabIcon = "Utility.png",
        Callback = function() end
    }),
    Plugins = GuiLibrary:CreateTab({
        Name = "Plugins",
        Color = Color3.fromRGB(49, 204, 90),
        Visible = true,
        TabIcon = "MiscTabIcon.png",
        Callback = function() end
    }),
    ]]
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

-- // key strokes
local keyStrokes = GuiLibrary:CreateKeyStrokes()
Mana.KeyStrokes = keyStrokes
keyStrokes:toggle()

--[[ // text list (soon)
local textList = GuiLibrary:CreateTextList()
Mana.TextList = textList
Tabs.TextList = textList.tab
]]

-- // Settings tab
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

    uicornersradius = Tabs.Settings:CreateSlider({
        Name = "UI corners radius",
        Function = function(v)
            GuiLibrary.uiCornersRadius = v
            GuiLibrary:updateUICorners(v)
        end,
        Min = 0,
        Max = 10,
        Default = 4,
        Round = 0
    })
end)

--[[ soon
runFunction(function()
    local textListEnabled = {Value = false}
    local divider = Tabs.Settings:CreateSecondDivider("Text List")
    textListEnabled = Tabs.Settings:CreateSecondToggle({
        Name = "Text List",
        Callback = function(callback)
            Tabs.TextList:Toggle(callback, callback)
        end
    })
end)
]]

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
    local divider = Tabs.Settings:CreateSecondDivider("Other")

    local sorttabs = Tabs.Settings:CreateButton({
        Name = "Sort tabs",
        Callback = function()
            local xoffset = 40
            local yoffset = 40
            local rowWidth = 7
            local totalyoffset = 247
    
            local tabs = {}
            for _, v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
                if v.Type == "Tab" then
                    table.insert(tabs, v)
                end
            end
            table.sort(tabs, function(a, b) return a.Table.Order < b.Table.Order end)
    
            for index, tabData in ipairs(tabs) do
                local tab = tabData.Table.MainObject
                local row = math.floor((index - 1) / rowWidth)
                local col = (index - 1) % rowWidth
    
                tab.Position = UDim2.new(0, xoffset + (col * totalyoffset), 0, yoffset + (row * 50))
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

-- Profiles tab
runFunction(function()
    local onrejoin = {Value = true}
    local autosaveonrejoin = {Value = false}
    local delay = {Value = 15}
    local profilesList = {}

    local divider = Tabs.Profiles:CreateSecondDivider("Config")

    local autosave = Tabs.Profiles:CreateSecondToggle({
        Name = "AutoSave",
        Callback = function(callback)
            if callback then
                while callback and wait(delay.Value) do
                    GuiLibrary:SaveConfig()
                end
            end
        end
    })

    autosaveonrejoin = Tabs.Profiles:CreateSecondToggle({
        Name = "On rejoin",
        Callback = function(v) end
    })

    delay = Tabs.Profiles:CreateSlider({
        Name = "Delay",
        Function = function(v)
        end,
        Min = 1,
        Max = 60,
        Default = 15,
        Round = 0
    })

    local resetprofile = Tabs.Profiles:CreateButton({
        Name = "Reset current profile",
        Callback = function()
        Mana = nil
        GuiLibrary:Destruct()
        if isfile("Mana/Config/"..game.PlaceId..GuiLibrary.CurrentProfile..".json") then delfile("Mana/Config/"..game.PlaceId..GuiLibrary.CurrentProfile..".json") end
        Functions:RunFile("MainScript.lua")
        end
    })

    local profilesList = Tabs.Profiles:CreateTextList({
        Name = "Profiles",
        List = {"Default"},
        PlaceholderText = "Profile name",
        Choose = true,
        MultiChoose = false,
        Default = "Default",
        Callback = function(v, bool)
            if bool then
                GuiLibrary:switchProfile(v)
            end
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

--[[ // TextList tab (soon)
runFunction(function()
    local sorting = {Value = "Alphabetical"}
    local backgroundTransparency = {Value = 0.7}
    local texSize = {Value = 15}
    local customTextEnabled = {Value = false}
    local customText = {Value = ""}
    local customTextSize = {Value = 18}
    local autoXAllignment = {Value = true}

    sorting = Tabs.TextList:CreateDropDown({
        Name = "Sorting",
        List = {"Alphabetical", "Length"},
        Default = "Alphabetical",
        Callback = function(v)
            textList:updateSortingMode(v)
        end
    })

    backgroundTransparency = Tabs.TextList:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            textList:updateBackgroundTransparency(v)
        end,
        Min = 0,
        Max = 1,
        Default = 0.7,
        Round = 2
    })

    texSize = Tabs.TextList:CreateSlider({
        Name = "Text size",
        Function = function(v)
            textList:updateTextSize(v)
        end,
        Min = 10,
        Max = 30,
        Default = 15,
        Round = 0
    })

    customTextEnabled = Tabs.TextList:CreateSecondToggle({
        Name = "Custom text",
        Default = true,
        Callback = function(callback)
            if customText.MainObject then customText.MainObject.Visible = callback end
            if customTextSize.MainObject then customTextSize.MainObject.Visible = callback end
            textList:addCustomText()
        end
    })

    customText = Tabs.TextList:CreateTextBox({
        Name = "Custom text",
        PlaceholderText = "Custom text text",
        Default = "Hello world!",
        Callback = function(v)
            textList:updateCustomText(v)
        end
    })
    customText.MainObject.Visible = false

    customTextSize = Tabs.TextList:CreateSlider({
        Name = "Custom text size",
        Function = function(v)
            textList:updateCustomTextSize(v)
        end,
        Min = 10,
        Max = 30,
        Default = 18,
        Round = 0
    })
    customTextSize.MainObject.Visible = false

    autoXAllignment = Tabs.TextList:CreateSecondToggle({
        Name = "Auto text X align.",
        Default = false,
        Callback = function(callback)
            textList:updateAutoTextXAlignment(callback)
        end
    })
end)
]]

-- // cool gui button
local Button = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
Button.Name = "GuiButton"
Button.Position = UDim2.new(0.12, 0, 0, -41)
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

Functions:RunFile("Universal.lua")

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

GuiLibrary.Loaded = true
GuiLibrary:LoadConfig()
--GuiLibrary:Toggle()