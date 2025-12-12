-- Race clicker
--[[
    Credits to anyones code i used or looked at
]]

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Camera = workspace.CurrentCamera
local RealCamera = workspace.Camera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui

local mana = shared.Mana
local library = mana.GuiLibrary
local tabs = mana.Tabs

local function runFunction(func) func() end

local Services = ReplicatedStorage.Packages.Knit.Services
local Remotes = {
    ClickRemote = Services.ClickService.RF.Click,
    RebithRemote = Services.RebirthService.RF.Rebirth,
    EquipBestPetsRemote = Services.PetsService.RF.EquipBest,
    OpenEggRemote = Services.EggService.RF.Open,
    CraftAllPetsRemote = Services.PetsService.RF.CraftAll,
    ReedemCodeRemote = Services.CodesService.RF.Redeem,
    SeasonRemote = Services.SeasonPassService.RF.ClaimTier
}

runFunction(function()
    local autoFarm = {Enabled = false}
    autoFarm = tabs.Utility:CreateToggle({
        Name = "AutoFarm",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while autoFarm.Enabled and task.wait() do
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(-100000, 0, 0)
                end
            end
        end
    })
end)

runFunction(function()
    local autoClicker = {Enabled = false}
    autoClicker = tabs.Utility:CreateToggle({
        Name = "AutoClick",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while autoClicker.Enabled and task.wait() do
                    Remotes.ClickRemote:InvokeServer()
                end
            end
        end
    })
end)

runFunction(function()
    local autoEquip = {Enabled = false}
    autoEquip = tabs.Utility:CreateToggle({
        Name = "AutoEquipBestPets",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while autoEquip.Enabled and task.wait() do
                    Remotes.EquipBestPetsRemote:InvokeServer()
                end
            end
        end
    })
end)

runFunction(function()
    local autoCraft = {Enabled = false}
    autoCraft = tabs.Utility:CreateToggle({
        Name = "AutoCraftPets",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while autoCraft.Enabled and task.wait() do
                    Remotes.CraftAllPetsRemote:InvokeServer()
                end
            end
        end
    })
end)

runFunction(function()
    local autoSeason = {Enabled = false}
    autoSeason = tabs.Utility:CreateToggle({
        Name = "AutoSeason",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while autoSeason.Enabled and task.wait() do
                    Remotes.SeasonRemote:InvokeServer()
                end
            end
        end
    })
end)

runFunction(function()
    local autoRebirth = {Enabled = false}
    autoRebirth = tabs.Utility:CreateToggle({
        Name = "AutoRebith",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while autoRebirth.Enabled and task.wait() do
                    Remotes.RebithRemote:InvokeServer()
                end
            end
        end
    })
end)

library.CanLoadConfig = true
print("[ManaV2ForRoblox/Scripts/9285238704.lua]: Loaded in " .. tostring(tick() - startTick) .. ". ")