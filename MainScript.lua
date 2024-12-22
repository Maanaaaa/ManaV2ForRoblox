--[[
    Credits to anyones code I used or looked at

    Removed the key system permamently.
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
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
local SliderScaleValue = 1
local Functions = {}
local LocalPlayerEvents = {}
local Mana

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

if Mana and Mana.Activated == true then 
    warn("[ManaV2ForRoblox]: Already loaded.")
    Mana.GuiLibrary:playsound("rbxassetid://421058925", 1)
    if Mana.GuiLibrary.ChatNotifications then
        Mana.GuiLibrary:CreateChatNotification("Warn", "Already loaded.")
    end
    return
end

if getgenv then
    getgenv().Mana = {Developer = false}
    Mana = getgenv().Mana
elseif not getgenv then
    _G.Mana = {Developer = false}
    Mana = _G.Mana
    warn("[ManaV2ForRoblox]: Using _G function.")
elseif not (_G and getgenv) then
    return warn("[ManaV2ForRoblox]: Unsupported executor.")
end

do
    function Functions:RunFile(filepath)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath,
            Method = "GET"
        })
        if not betterisfile(filepath) and not Mana.Developer then -- auto update workspace files
                local context = req.Body
                writefile(filepath, context)
            return loadstring(context)()
        else
            if isfile("NewMana/" .. filepath) then
                return loadstring(readfile("NewMana/" .. filepath))()
            elseif isfile("Mana/" .. filepath) then
                return loadstring(readfile("Mana/" .. filepath))()
            else
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath))()
            end
        end
    end
end

Mana.CustomFileSystem = Functions

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

local Whitelist = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/Whitelist/main/Whitelist.json"))
local GuiLibrary = Functions:RunFile("GuiLibrary.lua")--loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/refs/heads/main/GuiLibrary.lua"))()
--local EntityLibrary = loadstring(game)

Mana.GuiLibrary = GuiLibrary
Mana.ThemeManager = GuiLibrary.ThemeManager
Mana.Functions = Functions
Mana.RunLoops = RunLoops
--Mana.EntityLibrary = EntityLibrary
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
    Misc = GuiLibrary:CreateTab({
        Name = "Other",
        Color = Color3.fromRGB(240, 157, 62),
        Visible = true,
        TabIcon = "MiscTabIcon.png",
        Callback = function() end
    }),
}

Mana.Tabs = Tabs

if GuiLibrary.Device == "Mobile" then
    SliderScaleValue = 0.5
end

-- Chattags and commands system
task.spawn(function() -- so it doesn't stop script loading
    for PlayerName, Tag in pairs(Whitelist) do
        if LocalPlayer.UserId == tonumber(Tag.UserId) then
            if Tag.Whitelisted or Tag.Whitelisted == "true" then
                Mana.Whitelisted = true

                Tabs.Private = GuiLibrary:CreateTab({
                    Name = "Private",
                    Color = Color3.fromRGB(243, 247, 5),
                    Visible = true,
                    Callback = function() end
                })

                GuiLibrary:CreateNotification("Whitelist", "Successfully whitelisted as whitelisted!", 10, true, "warn") -- warn bc it has bigger chance that you will notice this
            elseif Tag.Developer or Tag.Developer == "true" then
                Mana.Whitelisted = true
                Mana.Developer = true

                Tabs.Private = GuiLibrary:CreateTab({
                    Name = "Private",
                    Color = Color3.fromRGB(243, 247, 5),
                    Visible = true,
                    Callback = function() end
                })

                GuiLibrary:CreateNotification("Whitelist", "Successfully whitelisted as whitelisted and developer!", 10, true, "warn")
            elseif _G.Helper then
                Mana.Whitelisted = true

                Tabs.Private = GuiLibrary:CreateTab({
                    Name = "Private",
                    Color = Color3.fromRGB(243, 247, 5),
                    Visible = true,
                    Callback = function() end
                })

                GuiLibrary:CreateNotification("Whitelist", "Successfully whitelisted as whitelisted and helper!", 10, true, "warn")
            elseif _G.Tester then
                Mana.Whitelisted = true

                Tabs.Private = GuiLibrary:CreateTab({
                    Name = "Private",
                    Color = Color3.fromRGB(243, 247, 5),
                    Visible = true,
                    Callback = function() end
                })

                GuiLibrary:CreateNotification("Whitelist", "Successfully whitelisted as whitelisted and tester!", 10, true, "warn")
            end
            if Mana.Whitelisted or Mana.Developer then
                TextChatService.OnIncomingMessage = function(Message, ChatStyle)
                    local MessageProperties = Instance.new("TextChatMessageProperties")
                    local Player = Players:GetPlayerByUserId(Message.TextSource.UserId)
                    if Player.Name == PlayerName then
                        MessageProperties.PrefixText = '<font color="' .. Tag.Color .. '">' .. Tag.Chattag .. '</font> ' .. Message.PrefixText
                    end
                    return MessageProperties
                end
            end
        end
    end
end)

-- Misc tab

runFunction(function()
    local AutoSaveDelay = {Value = 5}
    local AutoSaveOnRejoin = {Value = true}
    local LeavingEvent
    AutoSaveConfig = Tabs.Misc:CreateToggle({
        Name = "AutoSaveConfig",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while callback and task.wait(AutoSaveDelay.Value) do
                    GuiLibrary.ConfigSystem.functions:WriteConfigs(GuiLibrary.ConfigTable)
                end

                LeavingEvent = Players.PlayerRemoving:Connect(function(Player)
                    if Player == LocalPlayer and AutoSaveOnRejoin.Value then
                        GuiLibrary.ConfigSystem.functions:WriteConfigs(GuiLibrary.ConfigTable)
                    end
                end)
            else
                if LeavingEvent then
                    LeavingEvent:Disconnect()
                end
            end
        end
    })

    AutoSaveOnRejoin = AutoSaveConfig:CreateToggle({
        Name = "On rejoin or leave",
        Default = true,
        Function = function(v)
        end 
    })

    AutoSaveDelay = AutoSaveConfig:CreateSlider({
        Name = "Delay",
        Function = function(v)
		end,
        Min = 1,
        Max = 60,
        Default = 15,
        Round = 0
    })
end)

runFunction(function()
    local ClickGuiEnabled = false
    local LibrarySettings = Tabs.Misc:CreateToggle({
        Name = "ClickGui",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                ClickGuiEnabled = callback
            end
        end
    })

    LibSounds = LibrarySettings:CreateToggle({
        Name = "Sounds",
        Default = true,
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.Sounds = v
            end
        end 
    })

    Notifications = LibrarySettings:CreateToggle({
        Name = "Notifications",
        Default = true,
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.Notifications = v
            end
        end 
    })

    ChatNotifications = LibrarySettings:CreateToggle({
        Name = "ChatNotifications",
        Default = true,
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.ChatNotifications = v
            end
        end 
    })

    LibrarySize = LibrarySettings:CreateSlider({
        Name = "Size",
        Function = function(v)
            if ClickGuiEnabled then
                GuiLibrary.UIScale.Scale = v
            end
		end,
        Min = 1,
        Max = 10,
        Default = SliderScaleValue,
        Round = 1
    })
end)

runFunction(function()
    Discord = Tabs.Misc:CreateToggle({
        Name = "CopyDiscordInvite",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                toclipboard("https://discord.gg/gPkD8BdbMA")
                Discord:Toggle(true)
            end
        end
    })
end)

runFunction(function()
    DeleteConfig = Tabs.Misc:CreateToggle({
        Name = "DeleteConfig",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mana.Activated = false
                DeleteConfig:Toggle(false)
                GuiLibrary.ScreenGui:Destroy()
                if isfile("Mana/Config/" .. game.PlaceId .. ".json") then delfile("Mana/Config/" .. game.PlaceId .. ".json") end
                wait(1)
                Functions:RunFile("MainScript.lua")
            end
        end
    })
end)

runFunction(function()
    Reinject = Tabs.Misc:CreateToggle({
        Name = "ReInject",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mana.Activated = false
                Reinject:Toggle(false)
                GuiLibrary.ScreenGui:Destroy()
                wait(1)
                Functions:RunFile("MainScript.lua")
            end
        end
    })
end)

runFunction(function()
    ToggleGui = Tabs.Misc:CreateToggle({
        Name = "ToggleGui",
        Keybind = nil,
        Callback = function(callback)
            GuiLibrary:ToggleLibrary()
        end
    })
end)

runFunction(function()
    Uninject = Tabs.Misc:CreateToggle({
        Name = "Uninject",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Mana.Activated = false
                Mana = nil
                Uninject:Toggle(false)
                wait(0.1)
                GuiLibrary.ScreenGui:Destroy()
            end
        end
    })
end)

--[[
runFunction(function()
    local Themes = {Value = "Default"}
    UpdateTheme = Tabs.Misc:CreateToggle({
        Name = "SelectTheme",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                GuiLibrary.ThemeManager:ApplyTheme(Themes.Value)  -- ("Original", Themes.Value)
            end
        end
    })

    Themes = UpdateTheme:CreateDropDown({
        Name = "Theme",
        List = {"DefaultTheme", "DarkTheme", "LightTheme", "KawaiiTheme"},
        --List = {"DefaultTheme", "DarkTheme", "LightTheme", "BlueTheme", "GreenTheme", "RedTheme", "PurpleTheme", "KawaiiTheme"},
        Default = "KawaiiTheme",
        Function = function(v) 
            GuiLibrary.ThemeManager:ApplyTheme(v) -- ("Original", v)
        end
    })
end)
]]

local Button = Instance.new("TextButton")
local Corner = Instance.new("UICorner")
Button.Name = "GuiButton"
Button.Position = UDim2.new(1, -700, 0, -32)
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
    GuiLibrary:ToggleLibrary()
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.RightShift or Input.KeyCode == Enum.KeyCode.N then
        GuiLibrary:ToggleLibrary()
    end
end)

print("[ManaV2ForRoblox/MainScript.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")
--print("[ManaV2ForRoblox/MainScript.lua]: Loaded newest version.")

UniversalScript = Functions:RunFile("Scripts/Universal.lua")
GameScript = Functions:RunFile("Scripts/" .. PlaceId .. ".lua")

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        local QueueTeleportFunction = [[
            if Mana.Developer then 
                loadstring(readfile("NewMana/MainScript.lua"))()
            else 
                loadstring(readfile("Mana/MainScript.lua"))()
            end
        ]]
        queueteleport(QueueTeleportFunction)
    end
end)