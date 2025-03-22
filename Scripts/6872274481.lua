local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local PlayerScripts = LocalPlayer.PlayerScripts
local Backpack = LocalPlayer.Backpack
local Animation = Character.Animate
local LightingTime = Lighting.TimeOfDay
local workspace = game.workspace -- you dont see this
local Workspace = workspace -- ok?
local CurrentCamera = workspace.CurrentCamera
local Camera = workspace.Camera
local PlayerWalkSpeed = Humanoid.WalkSpeed
local PlayerJumpPower = Humanoid.JumpPower

local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions
local RunLoops = Mana.RunLoops

local getasset = getsynasset or getcustomasset
local function runFunction(func) func() end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

-- Functions that don't need BedwarsTable

local function IsAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and (Player.Character:FindFirstChild("HumanoidRootPart")) and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

local function GetRemote(tab)
    for i,v in pairs(tab) do
        if v == "Client" then
            return tab[i + 1]
        end
    end
    return ""
end

local function DumpRemote(tab)
    local ind-- = table.find(tab, 'Client')
    for i, v in tab do 
        if v == 'Client' then
            ind = i
            break
        end
    end
    return ind and tab[ind + 1] or ''
end

local function hvFunc(thingg)
    return {thinggg = thingg}
end

local function playsound(id, volume) 
    local sound = Instance.new("Sound")
    sound.Parent = workspace
    sound.SoundId = id
    sound.PlayOnRemove = true 
    if volume then 
        sound.Volume = volume
    end
    sound:Destroy()
end

local function getItem(itemName)
    for i5, v5 in pairs(getinv(LocalPlayer).items) do
        if v5.itemType == itemName then
            return v5, i5
        end
    end
    return nil
end

local function getwool()
    for i5, v5 in pairs(getinv(LocalPlayer).items) do
        if v5.itemType:match("wool") or v5.itemType:match("grass") then
            return v5.itemType, v5.amount
        end
    end	
    return nil
end

local function GetNearEntities(range)
    if IsAlive() then
        local localpos, lteam = LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer:GetAttribute('Team')
        local returned, mag = nil, range
        for _, v in Players:GetPlayers() do
            if IsAlive(v) then
                if v.Player:GetAttribute('Team') ~= lteam and v.Health > 0 then
                    local newmag = (v.RootPart.Position - localpos).Magnitude
                    if newmag <= mag then
                        returned, mag = v, newmag
                    end
                end
            end
        end
        return returned
    end
end

--local Client = require(ReplicatedStorage.TS.remotes).default.Client
--local Flamework = require(ReplicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
--local RemoteFolder = ReplicatedStorage:WaitForChild("rbxts_include")["node_modules"]["@rbxts"]["net"]["out"]["_NetManaged"]
--local KnitClient = debug.getupvalue(require(PlayerScripts.TS.knit).setup, 6)

local BedwarsTable = {
    --BlockEngine = require(ReplicatedStorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
    --BlockPlacer = require(ReplicatedStorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
    --Client = Client,
    --ClientBlockEngine = require(PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
    --CombatConstant = require(ReplicatedStorage.TS.combat["combat-constant"]).CombatConstant,
    FallRemote = ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"].GroundHit,
    --InventoryUtil = require(ReplicatedStorage.TS.inventory["inventory-util"]).InventoryUtil,
    --ItemTable = debug.getupvalue(require(ReplicatedStorage.TS.item['item-meta']).getItemMeta, 1),
    --KnockbackTable = require(ReplicatedStorage.TS.damage['knockback-util']).KnockbackUtil,
    --PickupRemote = DumpRemote(debug.getconstants(KnitClient.Controllers.ItemDropController.checkForPickup)),
    --QueryUtil = require(ReplicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).GameQueryUtil,
    --SoundList = require(ReplicatedStorage.TS.sound['game-sound']).GameSound,
    --SoundManager = require(ReplicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).SoundManager,
    --SprintController = KnitClient.Controllers.SprintController,
    SwitchToolController = ReplicatedStorage["rbxts_include"]["node_modules"]["@rbxts"].net.out._NetManaged.SetInvItem,
    --SwordController = KnitClient.Controllers.SwordController
}

local BedwarsStore = {Hand = {}, Tools = {}}

-- Functions that need BedwarsTable

--[[
local blocktable = BedwarsTable.ClientBlockEngine.new(BedwarsTable.BlockEngine, getwool())
function placeblockthing(newpos, customblock)
    local placeblocktype = (customblock or getwool())
    blocktable.blockType = placeblocktype
    if BedwarsTable.BlockEngine:isAllowedPlacement(LocalPlayer, placeblocktype, Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3)) and getItem(placeblocktype) then
        return blocktable:placeBlock(Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
    end
end

local oldpos = Vector3.new(0, 0, 0)
function getScaffold(vec, diagonaltoggle)
    local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
    local newpos = (oldpos - realvec)
    local returedpos = realvec
        if IsAlive() then
            local angle = math.deg(math.atan2(-LocalPlayer.Character.Humanoid.MoveDirection.X, -LocalPlayer.Character.Humanoid.MoveDirection.Z))
            local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
            if goingdiagonal and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0)) and diagonaltoggle then
                return oldpos
            end
        end
    return realvec
end
]]

local function Hash(p1)
    local hashmod = require(ReplicatedStorage.TS["remote-hash"]["remote-hash-util"])
    local toret = hashmod.RemoteHashUtil:prepareHashVector3(p1)
    return toret
end

local function GetInventory(plr)
    local plr = plr or LocalPlayer
    local thingy, thingytwo = pcall(function() return BedwarsTable.InventoryUtil.getInventory(plr) end)
    return (thingy and thingytwo or {
        items = {},
        armor = {},
        hand = nil
    })
end

local function GetSword()
    local sd
    local higherdamage
    local swordslots
    local swords = GetInventory().items
    for i, v in pairs(swords) do
        if v.itemType:lower():find("sword") or v.itemType:lower():find("blade") then
            if higherdamage == nil or BedwarsTable.ItemTable[v.itemType].sword.damage > higherdamage then
                sd = v
                higherdamage = BedwarsTable.ItemTable[v.itemType].sword.damage
                swordslots = i
            end
        end
    end
    return sd, swordslots
end

local function GetEquipped()
    local typetext = ""
    local obj = (IsAlive() and LocalPlayer.Character:FindFirstChild("HandInvItem") and LocalPlayer.Character.HandInvItem.Value or nil)
    if obj then
        if obj.Name:find("sword") or obj.Name:find("blade") or obj.Name:find("baguette") or obj.Name:find("scythe") or obj.Name:find("dao") then
            typetext = "sword"
        end
        if obj.Name:find("wool") or ItemTable[obj.Name].block then
            typetext = "block"
        end
        if obj.Name:find("bow") then
            typetext = "bow"
        end
    end
    return {Object = obj, Type = typetext}
end

function SwitchTool(tool)
    BedwarsTable.SwitchToolController:InvokeServer({
    hand = tool,
  })
  repeat task.wait() until Character.HandInvItem == tool
end

--GuiLibrary:RemoveObject("AutoClicker")
--GuiLibrary:RemoveObject("Aimbot")

-- Combat Tab

runFunction(function()
    local AimAssistRange = {Value = 0}
    local AimAssistSmoothness = {Value = 0}
    local AimAssistVertical = {Value = false}
    local AimAssistActive = {Value = false}

    local AimAssist = Tabs.Combat:CreateToggle({
        Name = "AimAssist",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AimAssist", function(delta)
                    if BedwarsStore.Hand.Type == 'sword' and (AimAssistActive.Value or (tick() - BedwarsTable.SwordController.lastSwing) < 0.2) then
                        local plr = GetNearEntities(AimAssistRange.Value)
                        if plr and not BedwarsTable.AppController:isLayerOpen(BedwarsTable.UILayers.MAIN) then
                            local pos, vis = Camera:WorldToViewportPoint(plr.RootPart.Position)
                            if vis and isrbxactive() then
                                pos = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()) * ((100 - AimAssistSmoothness.Value) * delta / 3)
                                mousemoverel(pos.X, AimAssistVertical.Value and pos.Y or 0)
                            end
                        end
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AimAssist")
            end
        end
    })

    AimAssistRange = AimAssist:CreateSlider({
        Name = "Range",
        Min = 1,
        Max = 30,
        Default = 30,
        Round = 0,
        Function = function(v) end
    })
    AimAssistSmoothness = AimAssist:CreateSlider({
        Name = "Smoothness",
        Min = 1,
        Max = 100,
        Default = 70,
        Round = 0,
        Function = function(v) end
    })

    AimAssistActive = AimAssist:CreateToggle({
        Name = "Always Active",
        Default = false,
        Function = function(v) end
    })

    AimAssistVertical = AimAssist:CreateToggle({
        Name = "Vertical Aim",
        Default = false,
        Function = function(v) end
    })
end)

runFunction(function()
-- AutoClicker
end)

runFunction(function()
    local NoClickDelay = Tabs.Combat:CreateToggle({
        Name = "NoClickDelay",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while callback and task.wait() do
                    if entity.isAlive and callback then
                        for i, v in pairs(ItemTable) do
                            if type(v) == "table" and rawget(v, "sword") then
                                v.sword.attackSpeed = 0.0000000001
                            end
                            BedwarsTable.SwordController.isClickingTooFast = function() return false end
                        end
                    else

                    end
                end
            end
        end
    })
end)

runFunction(function()
    local ReachValue = {Value = 18}

    Reach = Tabs.Combat:CreateToggle({
        Name = "Reach",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                BedwarsTable.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = ReachValue.Value + 2
            else
                BedwarsTable.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
            end
        end
    })

    ReachValue = Reach:CreateSlider({
        Name = "Reach",
        Function = function(v)
            if Reach.ReachEnabled then
                BedwarsTable.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = v + 2
            end
        end,
        Min = 1,
        Max = 18,
        Default = 18,
        Round = 1
    })
end)

runFunction(function()
    local VelocityHorizontal = {Value = 0}
    local VelocityVertical = {Value = 0}
    local Velocity = Tabs.Combat:CreateToggle({
        Name = "Velocity",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                applyKnockback = BedwarsTable.KnockbackUtil.applyKnockback
                BedwarsTable.KnockbackUtil.applyKnockback = function(root, mass, dir, KnockBack, ...)
                    KnockBack = KnockBack or {}
                    KnockBack.horizontal = (KnockBack.horizontal or 1) * (VelocityHorizontal.Value / 100)
                    KnockBack.vertical = (KnockBack.vertical or 1) * (VelocityVertical.Value / 100)
                    return applyKnockback(root, mass, dir, KnockBack, ...)
                end
            end
        end
    })
    VelocityHorizontal = Velocity:CreateSlider({
        Name = "Horizontal",
        Function = function(v) end,
        Min = 0,
        Max = 100,
        Default = 0,
        Round = 0
    })
    VelocityVertical = Velocity:CreateSlider({
        Name = "Vertical",
        Function = function(v) end,
        Min = 0,
        Max = 100,
        Default = 0,
        Round = 0
    })
end)

-- Movement Tab

runFunction(function() -- basically universal speed but with smaller max speed so ppl dont say that speed lagbacks
    local SpeedMode = {Value = "Normal"}
    local AutoJumpMode = {Value = "Normal"}
    local SpeedValue = {Value = 16}
    local JumpHeightValue = {Value = 25}
    local JumpPowerValue = {Value = 50}
    local AutoJump = {Value = false}
    local NoAnimation = {Value = false}
    local SpeedEnabled = false
    Speed = Tabs.Movement:CreateToggle({
        Name = "Speed",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                SpeedEnabled = callback
                RunLoops:BindToHeartbeat("Speed", function(Delta)
                    if IsAlive() then
                        local Character = LocalPlayer.Character
                        local Humanoid = Character.Humanoid
                        local HumanoidRootPart = Character.HumanoidRootPart
                        local MoveDirection = Humanoid.MoveDirection
                        local VelocityX = HumanoidRootPart.Velocity.X
                        local VelocityZ = HumanoidRootPart.Velocity.Z

                        if SpeedMode.Value == "Velocity" then
                            local Velocity = Humanoid.MoveDirection * (SpeedValue.Value * 5) * Delta
                            local NewVelocity = Vector3.new(Velocity.X / 10, 0, Velocity.Z / 10)
                            Character:TranslateBy(NewVelocity)
                        elseif SpeedMode.Value == "CFrame" then
                            local Factor = SpeedValue.Value - Humanoid.WalkSpeed
                            local MoveDirection = (MoveDirection * Factor) * Delta
                            local NewCFrame = HumanoidRootPart.CFrame + Vector3.new(MoveDirection.X, 0, MoveDirection.Z)

                            HumanoidRootPart.CFrame = NewCFrame
                        elseif SpeedMode.Value == "Normal" then
                            Humanoid.WalkSpeed = SpeedValue.Value
                        end

                        if AutoJump.Value and (Humanoid.FloorMaterial ~= Enum.Material.Air) and Humanoid.MoveDirection ~= Vector3.zero then
                            if AutoJumpMode == "Normal" then
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            else
                                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, JumpHeightValue.Value, HumanoidRootPart.Velocity.Z)
                            end
                        end

                        if NoAnimation.Value then
                            Character.Animate.Disabled = true
                        end

                        Humanoid.JumpPower = JumpPowerValue.Value
                    end
                end)
            else
                if RunLoops.HeartTable.Speed then
                    RunLoops:UnbindFromHeartbeat("Speed")
                end

                Character.Humanoid.WalkSpeed = PlayerWalkSpeed
                Character.Humanoid.JumpPower = PlayerJumpPower
                Character.Animate.Disabled = true
            end
        end
    })

    SpeedMode = Speed:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"CFrame", "Normal", "Velocity"},
        Default = "Normal"
    })

    AutoJumpMode = Speed:CreateDropDown({
        Name = "AutoJumpMode",
        Function = function(v) 
            if v == "Velocity" then
                if JumpHeightValue.MainObject then
                    JumpHeightValue.MainObject.Visible = true
                end
            elseif v == "Normal" then
                if JumpHeightValue.MainObject then
                    JumpHeightValue.MainObject.Visible = false
                end
            end
        end,
        List = {"Normal", "Velocity"},
        Default = "Normal"
    })

    SpeedValue = Speed:CreateSlider({
        Name = "Speed",
        Function = function(v) 
            if SpeedEnabled and SpeedMode.Value == "Normal" then
                LocalPlayer.Character.Humanoid.WalkSpeed = v
            end
        end,
        Min = 0,
        Max = 30,
        Default = 16,
        Round = 0
    })

    JumpHeightValue = Speed:CreateSlider({
        Name = "AutoJumpHeight",
        Function = function(v) end,
        Min = 0,
        Max = 30,
        Default = 25,
        Round = 0
    })

    JumpPowerValue = Speed:CreateSlider({
        Name = "JumpPower",
        Function = function(v) 
            if SpeedEnabled then
                LocalPlayer.Character.Humanoid.JumpPower = v
            end
        end,
        Min = 0,
        Max = 200,
        Default = 50,
        Round = 0
    })

    AutoJump = Speed:CreateToggle({
        Name = "AutoJump",
        Default = false,
        Function = function(v)
            if AutoJumpMode.MainObject then
                AutoJumpMode.MainObject.Visible = v
            end
        end
    })

    NoAnimation = Speed:CreateToggle({
        Name = "NoAnimation",
        Default = false,
        Function = function(v)
            if SpeedEnabled then
                Character.Animate.Disabled = v
            end
        end
    })
end)

runFunction(function()
    Tabs.Combat:CreateToggle({
        Name = "Sprint",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                spawn(function()
                    repeat
                        wait()
                        if (not callback) then return end
                        if BedwarsTable.SprintController.sprinting == false then
                            BedwarsTable.SprintController:startSprinting()
                        end
                    until (not callback)
                end)
            else
                BedwarsTable.SprintController:stopSprinting()
            end
        end
    })
end)

-- Render Tab

runFunction(function()
    local SpawnParts = {}
    SpawnESP = Tabs.Render:CreateToggle({
        Name = "SpawnESP",
        Keybind = nil,
        Callback = function(v)
            if v then 
                for i,v2 in pairs(workspace.MapCFrames:GetChildren()) do 
                    if v2.Name:find("spawn") and v2.Name ~= "spawn" and v2.Name:find("respawn") == nil then
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(1, 1000, 1)
                        part.Position = v2.Value.p
                        part.Anchored = true
                        part.Parent = workspace
                        part.CanCollide = false
                        part.Transparency = 0.5
                        part.Material = Enum.Material.Neon
                        part.Color = Color3.new(1, 0, 0)
                        BedwarsTable.QueryUtil:setQueryIgnored(part, true)
                        table.insert(SpawnParts, part)
                    end
                end
            else
                for i,v in pairs(SpawnParts) do v:Destroy() end
                table.clear(SpawnParts)
            end
        end
    })
end)

-- Utility Tab

