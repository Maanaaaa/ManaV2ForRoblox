-- Prison Life
repeat task.wait() until game:IsLoaded()

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportSerivce = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local NetworkClient = game:GetService("NetworkClient")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local Backpack = LocalPlayer.Backpack
local Animate = LocalPlayer.Character:FindFirstChild("Animate") -- bc in Arsenal it's missing
local LightingTime = Lighting.TimeOfDay
local workspaceGravity = workspace.Gravity
local PlayerWalkSpeed = Humanoid.WalkSpeed
local PlayerJumpPower = Humanoid.JumpPower
local PlayerHipHeight = Humanoid.HipHeight
local OldCameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
local OldFov = Camera.FieldOfView
local PlaceId = game.PlaceId
local JobId = game.JobId

local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions
local RunLoops = Mana.RunLoops
local EntityLibrary = Mana.EntityLibrary

local getasset = getsynasset or getcustomasset
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

local cachedassets = {}
local function GetCustomAsset(path)
    if not betterisfile(path) then
        spawn(function()
            local textlabel = Instance.new("TextLabel")
            textlabel.Size = UDim2.new(1, 0, 0, 36)
            textlabel.Text = "Downloading "..path
            textlabel.BackgroundTransparency = 1
            textlabel.TextStrokeTransparency = 0
            textlabel.TextSize = 30
            textlabel.Font = Library.Font
            textlabel.TextColor3 = Color3.new(1, 1, 1)
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = ScreenGui
            repeat wait() until betterisfile(path)
            textlabel:Remove()
        end)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/Maan04ka/NewManaV2ForRoblox/main/" .. path:gsub("Mana/Assets", "Assets"),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if cachedassets[path] == nil then
        cachedassets[path] = getasset(path) 
    end
    return cachedassets[path]
end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

function CreateCoreNotification(title, text, duration)
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration,
	})
end

local function IsAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and (Player.Character:FindFirstChild("HumanoidRootPart")) and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

-- Combat Tab

-- Movement Tab

-- Render Tab

-- Utility Tab

runFunction(function()
    local ToolGiver = {Enabled = false}
    local GiveCrudeKnife = {Value = false}
    local GiveSharpenedStick = {Value = false}
    local GiveExtendoMirror = {Value = false}

    local ToolsFolder = ReplicatedStorage:FindFirstChild("Tools") or ReplicatedStorage:WaitForChild("Tools")
    local CrudeKnife = ToolsFolder["Crude Knife"] or ToolsFolder:FindFirstChild("Crude Knife")
    local SharpenedStick = ToolsFolder["Sharpened stick"] or ToolsFolder:FindFirstChild("Sharpened stick")
    local ExtendoMirror = ToolsFolder["Extendo mirror"] or ToolsFolder:FindFirstChild("Extendo mirror")

    local ToolGiver = Tabs.Utility:CreateToggle({
        Name = "ToolGiver",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                if GiveCrudeKnife.Value then
                    CrudeKnife:Clone().Parent = Backpack
                end
                if GiveSharpenedStick.Value then
                    SharpenedStick:Clone().Parent = Backpack
                end
                if GiveExtendoMirror.Value then
                    ExtendoMirror:Clone().Parent = Backpack
                end
            end
        end
    })
end)

runFunction(function()
    local TpWeapons = {Enabled = false}
    local GiveRemington870 = {Value = false}
    local GiveM9 = {Value = false}
    local GiveRiotShield = {Value = false}
    local GiveAK47 = {Value = false}
    local GiveM4A1 = {Value = false}

    local ItemsFolder = workspace:FindFirstChild("Prison_ITEMS"):FindFirstChild("Giver")
    local Remington870 = ItemsFolder["Remington 870"] or ItemsFolder:FindFirstChild("Remington 870")
    local M9 = ItemsFolder.M9 or ItemsFolder:FindFirstChild("M9")
    local RiotShield = ItemsFolder["Riot Shield"] or ItemsFolder:FindFirstChild("Riot Shield")
    local AK47 = ItemsFolder["AK-47"] or ItemsFolder:FindFirstChild("AK-47")
    local M4A1 = ItemsFolder.M4A1 or ItemsFolder:FindFirstChild("M4A1")

    local TpWeapons = Tabs.Utility:CreateToggle({
        Name = "TPWeapons",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                if GiveRemington870.Value then
                    Remington870:MoveTo()
                end
            end
        end
    })
end)

-- World Tab