--[[
    murder mystery 2 module
    Made by Maanaaaa
]]

local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local starterGui = game:GetService("StarterGui")
local players = game:GetService("Players")

local lplr = players.LocalPlayer
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local backpack = localPlayer.Backpack

local Mana = shared.Mana
local GuiLibrary = Mana.GuiLibrary
local tabs = Mana.Tabs
local Functions = Mana.Functions
local runLoops = Mana.RunLoops
local playersHandler = Mana.PlayersHandlers
local espLibrary = Mana.EspLibrary

local tweens = {
    coin = function(time, coin, obj)
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Circular)
        return tweenService:Create(obj, tweenInfo, {CFrame = coin.CFrame})
    end
}

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
            Url = "https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. path:gsub("Mana/Assets", "Assets"),
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

local function createCoreNotification(title, text, duration)
	starterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration,
	})
end

local function findTouchInterest(obj)
    return obj and obj:FindFirstChildWhichIsA("TouchTransmitter", true)
end

local function isAlive(plr, headCheck)
    local plr = plr or localPlayer
    if plr and plr.Character and ((plr.Character:FindFirstChildOfClass("Humanoid")) and plr.Character:FindFirstChild("HumanoidRootPart") and (headCheck and plr.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    end
    return false
end

local function getCharacter(plr)
    plr = plr or localPlayer
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
    local plr = plr or localPlayer
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChildOfClass("Humanoid")
    end
end

local function getHumanoidRootPart(plr)
    local plr = plr or localPlayer
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("HumanoidRootPart")
    end
end

local function getHead(plr)
    local plr = plr or localPlayer
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("Head")
    end
end

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

local function getMurder()
    for _, plr in next, players:GetPlayers() do
        local character = getCharacter(plr)
        local backpack = plr:FindFirstChild("Backpack")
        if (character and character:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife")) then
            return plr
        end
    end
    return
end

local function getSheriff()
    for _, plr in next, players:GetPlayers() do
        local character = getCharacter(plr)
        local backpack = plr:FindFirstChild("Backpack")
        if (character and character:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then
            return plr
        end
    end
    return
end

local function getMap()
    for _, v in next, workspace:GetChildren() do
        if v:FindFirstChild("CoinContainer") then
            return v
        end
    end
    return
end

local function getGun()
    local map = getMap()
    if not map then return nil end
    return map:FindFirstChild("GunDrop")
end

local function getLocalPlayerGun()
    return (backpack:FindFirstChild("Gun")) or (getCharacter():FindFirstChild("Gun"))
end

local function getLocalPlayerKnife()
    return (backpack:FindFirstChild("Knife")) or (getCharacter():FindFirstChild("Knife"))
end

local function getClosestPlayer(maxDisance, teamCheck)
	local target
	for _, v in next, players:GetPlayers() do
		if v.Name ~= localPlayer.Name then
			if teamCheck then
				if v.Team ~= localPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(userInputService:GetMouseLocation().X, userInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								if VectorDistance < maxDisance then
									target = v
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
							if VectorDistance < maxDisance then
								target = v
							end
						end
					end
				end
			end
		end
	end
	return target
end

local function getNearPlayer(maxDistance)
    local target
    for _, plr in next, players:GetPlayers() do
        if plr ~= localPlayer and isAlive() and isAlive(plr) then
            local character = getCharacter(plr)
            local humanoidRootPart = character and getHumanoidRootPart(plr) or nil
            if character and humanoidRootPart then
                local distance = (humanoidRootPart.Position - getHumanoidRootPart().Position).Magnitude
                if distance < maxDistance then
                    target = plr
                    return plr
                end
            end
        end
    end
    return target
end

local function getNearestCoin(maxDistance)
    local target
    local closestDistance = maxDistance or math.huge
    local map = getMap()
    local humanoidRootPart = getHumanoidRootPart()
    if not map or not isAlive() then return end
    for _, coin in next, map.CoinContainer:GetChildren() do
        if coin.Name == "Coin_Server" then
            local distance = (coin.Position - humanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                target = coin
            end
        end
    end
    return target
end

--[[
local weaponEvents = replicatedStorage:FindFirstChild("WeaponEvents")
local remotes = replicatedStorage:FindFirstChild("Remotes")
local remotes = {
    gunBeam = weaponEvents:WaitForChild("GunBeam"),
    roundStart = remotes.Gameplay:FindFirstChild("RoundStart")
}
]]
-- // Combat tab
runFunction(function()
    local killAura = {Enabled = false}
    --local mode = {Value = "TPPlayer"}
    local maxDistance = {Value = 10}
    killAura = tabs.Combat:CreateToggle({
        Name = "KillAura",
        HoverText = "Automatically kills everyone who's near you.",
        Callback = function(callback)
            if callback then
                runLoops:BindToHeartbeat("KillAura", function()
                    local plr = getNearPlayer(maxDistance.Value)
                    local knife = getLocalPlayerKnife()
                    local stab = knife and knife:FindFirstChild("Stab") or nil
                    if plr and knife and stab then
                        for _, v in next, plr:GetDescendants() do
                            if v:IsA("Part") or v:IsA("BasePart") or v:IsA("MeshPart") then
                                v.CanCollide = false
                            end
                        end
                        local humanoidRootPart = getHumanoidRootPart(plr)
                        local localHumanoidRootPart = getHumanoidRootPart()
                        if humanoidRootPart and localHumanoidRootPart then
                            humanoidRootPart.CFrame = localHumanoidRootPart.CFrame -- // got this idea from yarhm, don't bully me for this :pray:
                            stab:FireServer("Slash")
                        end
                    end
                end)
            else
                runLoops:UnbindFromHeartbeat("KillAura")
            end
        end
    })

    maxDistance = killAura:CreateSlider({
        Name = "MaxDistance",
        Min = 0,
        Max = 15,
        Round = 1,
        Default = 10,
        Callback = function(v) end
    })
end)

-- // Visual tab
runFunction(function()
    local esp = {Enabled = false}
    local adorneePart = {Value = "HumanoidRootPart"}
    local mode = {Value = "SelectionBox"}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local color = {Value = Color3.fromRGB(255, 0, 0)}
    local transparency = {Value = 0}
    local alwaysOnTop = {Value = true}
    local previous
    local espLibrary = espLibrary:create("GunESP", true, true)

    local function clearPrevious()
        if previous then
            espLibrary:removeEspObject(previous)
        end
    end

    esp = tabs.Render:CreateToggle({
        Name = "GunESP",
        HoverText = "Shows gun through walls when it's dropped.\nMay stop working for a short amount of time, usually due to executor issues.",
        Callback = function(callback)
            if callback then
                runLoops:BindToHeartbeat("GunESP", function()
                    local gun = getGun()
                    if gun then
                        previous = gun
                        espLibrary:updateEspObject(nil, gun)
                    end
                end)
            else

            end
        end
    })

    outline = esp:CreateToggle({
        Name = "Outline",
        Default = false,
        Function = function(v)
            espLibrary.outline = v
            if outlineColor.MainObject then outlineColor.MainObject.Visible = v end
            if outlineTransparency.MainObject then outlineTransparency.MainObject.Visible = v end
        end
    })

    outlineColor = esp:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.outlineColor = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(nil, previous)
            end
        end
    })
    outlineColor.Container.Visible = false

    outlineTransparency = esp:CreateSlider({
        Name = "Outline transp.",
        Function = function(v)
            espLibrary.outlineTransparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(nil, previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.Container.Visible = false

    fill = esp:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            espLibrary.fill = v
            if fillColor.MainObject then fillColor.MainObject.Visible = v end
            if fillTransparency.MainObject then fillTransparency.MainObject.Visible = v end
            if esp.Enabled and previous then
                espLibrary:updateEspObject(nil, previous)
            end
        end
    })

    fillColor = esp:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.fillColor = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(nil, previous)
            end
        end
    })
    fillColor.Container.Visible = false

    fillTransparency = esp:CreateSlider({
        Name = "Fill transp.",
        Function = function(v)
            espLibrary.fillTransparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(nil, previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.Container.Visible = false

    alwaysOnTop = esp:CreateToggle({
        Name = "AlwaysOnTop",
        Default = true,
        Function = function(v)
            esp.highlightAlwaysOnTop = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(nil, previous)
            end
        end
    })
end)

runFunction(function()
    local esp = {Enabled = false}
    local adorneePart = {Value = "HumanoidRootPart"}
    local mode = {Value = "SelectionBox"}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local color = {Value = Color3.fromRGB(255, 0, 0)}
    local transparency = {Value = 0}
    local alwaysOnTop = {Value = true}
    local previous
    local espLibrary = espLibrary:create("MurderESP", true)

    local function clearPrevious()
        if previous then
            espLibrary:removeEspObject(previous)
        end
    end

    esp = tabs.Render:CreateToggle({
        Name = "MurderESP",
        HoverText = "Shows murder through walls.",
        Callback = function(callback)
            if callback then
                runLoops:BindToHeartbeat("MurderESP", function()
                    local murder = getMurder()
                    if murder and murder ~= localPlayer then
                        previous = murder
                        espLibrary:updateEspObject(murder)
                    end
                end)
            else
                runLoops:UnbindFromHeartbeat("MurderESP")
                clearPrevious()
            end
        end
    })

    adorneePart = esp:CreateDropdown({
        Name = "Adornee Part",
        List = {"Head", "HRP", "Character"},
        Default = "Character",
        Function = function(v)
            espLibrary.adorneePart = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })

    mode = esp:CreateDropdown({
        Name = "Mode",
        List = espLibrary.modesList,
        Default = "Highlight",
        Callback = function(v)
            espLibrary.mode = v
            if color.MainObject then color.MainObject.Visible = v == "BoxHandleAdornment" end
            if transparency.MainObject then transparency.MainObject.Visible = v == "BoxHandleAdornment" end
            if outline.MainObject then outline.MainObject.Visible = v == "Highlight" end
            if outlineColor.MainObject then outlineColor.MainObject.Visible = (v == "Highlight" and outline.Value) end
            if outlineTransparency.MainObject then outlineTransparency.MainObject.Visible = (v == "Highlight" and outline.Value) end
            if fill.MainObject then fill.MainObject.Visible = v == "Highlight" end
            if fillColor.MainObject then fillColor.MainObject.Visible = (v == "Highlight" and fill.Value) end
            if fillTransparency.MainObject then fillTransparency.MainObject.Visible = (v == "Highlight" and fill.Value) end
            if esp.Enabled and previous then
                esp:ReToggle(true)
                espLibrary:updateEspObject(previous)
            end
        end
    })

    color = esp:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.color = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
    color.Container.Visible = false

    outline = esp:CreateToggle({
        Name = "Outline",
        Default = false,
        Function = function(v)
            espLibrary.outline = v
            if outlineColor.MainObject then outlineColor.MainObject.Visible = v end
            if outlineTransparency.MainObject then outlineTransparency.MainObject.Visible = v end
        end
    })

    outlineColor = esp:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.outlineColor = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
    outlineColor.Container.Visible = false

    outlineTransparency = esp:CreateSlider({
        Name = "Outline transp.",
        Function = function(v)
            espLibrary.outlineTransparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.Container.Visible = false

    fill = esp:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            espLibrary.fill = v
            if fillColor.MainObject then fillColor.MainObject.Visible = v end
            if fillTransparency.MainObject then fillTransparency.MainObject.Visible = v end
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })

    fillColor = esp:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.fillColor = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
    fillColor.Container.Visible = false

    fillTransparency = esp:CreateSlider({
        Name = "Fill transp.",
        Function = function(v)
            espLibrary.fillTransparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.Container.Visible = false

    transparency = esp:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            espLibrary.transparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    transparency.Container.Visible = false

    alwaysOnTop = esp:CreateToggle({
        Name = "AlwaysOnTop",
        Default = false,
        Function = function(v)
            if mode.Value == "BoxHandleAdornment" then
                esp.boxHandleAlwaysOnTop = v
            elseif mode.Value == "Highlight" then
                esp.highlightAlwaysOnTop = v
            end
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
end)

runFunction(function()
    local esp = {Enabled = false}
    local adorneePart = {Value = "HumanoidRootPart"}
    local mode = {Value = "SelectionBox"}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local color = {Value = Color3.fromRGB(255, 0, 0)}
    local transparency = {Value = 0}
    local alwaysOnTop = {Value = true}
    local previous
    local espLibrary = espLibrary:create("SheriffESP", true)

    local function clearPrevious()
        if previous then
            espLibrary:removeEspObject(previous)
        end
    end

    esp = tabs.Render:CreateToggle({
        Name = "SheriffESP",
        HoverText = "Shows sheriff through walls.",
        Callback = function(callback)
            if callback then
                runLoops:BindToHeartbeat("SheriffESP", function()
                    local sheriff = getSheriff()
                    if sheriff and sheriff ~= localPlayer then
                        previous = sheriff
                        espLibrary:updateEspObject(sheriff)
                    end
                end)
            else
                runLoops:UnbindFromHeartbeat("SheriffESP")
                clearPrevious()
            end
        end
    })

    adorneePart = esp:CreateDropdown({
        Name = "Adornee Part",
        List = {"Head", "HRP", "Character"},
        Default = "Character",
        Function = function(v)
            espLibrary.adorneePart = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })

    mode = esp:CreateDropdown({
        Name = "Mode ", -- // added space to avoid conflict with other mode dropdowns
        List = espLibrary.modesList,
        Default = "Highlight",
        Callback = function(v)
            espLibrary.mode = v
            if color.Container then color.Container.Visible = v == "BoxHandleAdornment" end
            if transparency.Container then transparency.Container.Visible = v == "BoxHandleAdornment" end
            if outline.Container then outline.Container.Visible = v == "Highlight" end
            if outlineColor.Container then outlineColor.Container.Visible = (v == "Highlight" and outline.Value) end
            if outlineTransparency.Container then outlineTransparency.Container.Visible = (v == "Highlight" and outline.Value) end
            if fill.Container then fill.Container.Visible = v == "Highlight" end
            if fillColor.MainObContainerject then fillColor.Container.Visible = (v == "Highlight" and fill.Value) end
            if fillTransparency.Container then fillTransparency.Container.Visible = (v == "Highlight" and fill.Value) end
            if esp.Enabled and previous then
                esp:ReToggle(true)
                espLibrary:updateEspObject(previous)
            end
        end
    })

    color = esp:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.color = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
    color.Container.Visible = false

    outline = esp:CreateToggle({
        Name = "Outline",
        Default = false,
        Function = function(v)
            espLibrary.outline = v
            if outlineColor.Container then outlineColor.Container.Visible = v end
            if outlineTransparency.Container then outlineTransparency.Container.Visible = v end
        end
    })

    outlineColor = esp:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.outlineColor = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
    outlineColor.Container.Visible = false

    outlineTransparency = esp:CreateSlider({
        Name = "Outline transp.",
        Function = function(v)
            espLibrary.outlineTransparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.Container.Visible = false

    fill = esp:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            espLibrary.fill = v
            if fillColor.Container then fillColor.Container.Visible = v end
            if fillTransparency.Container then fillTransparency.Container.Visible = v end
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })

    fillColor = esp:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.fillColor = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
    fillColor.Container.Visible = false

    fillTransparency = esp:CreateSlider({
        Name = "Fill transp.",
        Function = function(v)
            espLibrary.fillTransparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.Container.Visible = false

    transparency = esp:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            espLibrary.transparency = v
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    transparency.Container.Visible = false

    alwaysOnTop = esp:CreateToggle({
        Name = "AlwaysOnTop",
        Default = false,
        Function = function(v)
            if mode.Value == "BoxHandleAdornment" then
                esp.boxHandleAlwaysOnTop = v
            elseif mode.Value == "Highlight" then
                esp.highlightAlwaysOnTop = v
            end
            if esp.Enabled and previous then
                espLibrary:updateEspObject(previous)
            end
        end
    })
end)

-- // Utility tab
runFunction(function()
    local collectCoins = {Enabled = false}
    local mode = {Value = "Teleport"}
    local time = {Value = 1}
    local delay = {Value = 0.5}
    local collected = {}
    collectCoins = tabs.Utility:CreateToggle({
        Name = "AutoFarmBeachBalls", -- // CoinsFarm
        Callback = function(callback)
            repeat
                local coin = getNearestCoin()
                if coin and not collected[coin] then
                    local humanoidRootPart = getHumanoidRootPart()
                    if mode.Value == "Tween" then
                        tweens.coin(time.Value, coin, humanoidRootPart):Play()
                        task.wait()
                    elseif mode.Value == "Teleport" then
                        humanoidRootPart.CFrame = coin.CFrame
                        task.wait(delay.Value)
                    end
                    collected[coin] = true
                end
                task.wait()
            until not collectCoins.Enabled
        end
    })

    mode = collectCoins:CreateDropdown({
        Name = "Mode",
        List = {"Teleport", "Tween"},
        Default = "Teleport",
        Callback = function(v)
            if time.Container then time.Container.Visible = v == "Tween" end
            if delay.Container then delay.Container.Visible = v == "Teleport" end
        end
    })

    time = collectCoins:CreateSlider({
        Name = "TweenTime",
        Min = 0,
        Max = 5,
        Round = 1,
        Default = 1,
        Callback = function(v) end
    })
    time.Container.Visible = false

    delay = collectCoins:CreateSlider({
        Name = "Delay",
        Min = 0.1,
        Max = 5,
        Round = 1,
        Default = 1,
        Callback = function(v) end
    })
end)

runFunction(function()
    local autoShootMurder = {Enabled = false}
    autoShootMurder = tabs.Utility:CreateToggle({
        Name = "AutoShootMurder",
        HoverText = "Automatically shoots murder when you have a gun.",
        Callback = function(callback)
            repeat
                if not autoShootMurder.Enabled then break end
                local murder = getMurder()
                local gun = getLocalPlayerGun()
                local knifeLocal = gun and gun:FindFirstChild("KnifeLocal") or nil
                local createBeam = knifeLocal and knifeLocal:FindFirstChild("CreateBeam") or nil
                local remote = createBeam and createBeam:FindFirstChild("RemoteFunction") or nil
                local hrp = getHumanoidRootPart(murder)
                local humanoid = getHumanoid()
                if murder and gun and knifeLocal and createBeam and remote and hrp then
                    if gun.Parent == backpack then
                        humanoid:EquipTool(gun)
                    end
                    local RunService = game:GetService("RunService")
                    local dt = RunService.Heartbeat:Wait()
                    local velocity = hrp.Velocity
                    local predictedPosition = hrp.Position + velocity * dt
                    remote:InvokeServer(1, predictedPosition, "AH2")
                end
                task.wait(1)
            until not autoShootMurder.Enabled
        end
    })
end)


runFunction(function()
    local gunNotifier = {Enabled = false}
    local connection
    local map 
    local previousMap
    gunNotifier = tabs.Utility:CreateToggle({
        Name = "GunDropNotify",
        HoverText = "Sends a message when gun is dropped.",
        Callback = function(callback)
            if callback then
                task.spawn(function()
                    while gunNotifier.Enabled and task.wait(0.1) do
                        map = getMap()
                        if map and map ~= previousMap then
                            betterDisconnect(connection)
                            connection = map.ChildAdded:Connect(function(child)
                                if child.Name == "GunDrop" then
                                    GuiLibrary:CreateNotification("GunDropNotify", "A gun has been dropped.", 5, "Info")
                                end
                            end)
                            previousMap = map
                        end
                    end
                end)
            else
                betterDisconnect(connection)
            end
        end
    })
end)

runFunction(function()
    local tpToGun = {Enabled = false}
    tpToGun = tabs.Utility:CreateToggle({
        Name = "TPToGun",
        HoverText = "Teleports you to dropped gun.",
        Callback = function(callback)
            if callback then
                local gun = getGun()
                if gun then
                    getHumanoidRootPart().CFrame = gun.CFrame
                end
                tpToGun:Toggle(true)
            end
        end
    })
end)

runFunction(function()
    local tpToMurder = {Enabled = false}
    tpToMurder = tabs.Utility:CreateToggle({
        Name = "TPToMurder",
        HoverText = "Teleports you to murder.",
        Callback = function(callback)
            if callback then
                local murder = getMurder()
                if murder then
                    getHumanoidRootPart().CFrame = getHumanoidRootPart(murder).CFrame
                end
                tpToMurder:Toggle(true)
            end
        end
    })
end)

runFunction(function()
    local tpToSheriff = {Enabled = false}
    tpToSheriff = tabs.Utility:CreateToggle({
        Name = "TPToSheriff",
        HoverText = "Teleports you to sheriff or hero.",
        Callback = function(callback)
            if callback then
                local sheriff = getSheriff()
                if sheriff then
                    getHumanoidRootPart().CFrame = getHumanoidRootPart(sheriff).CFrame
                end
                tpToSheriff:Toggle(true)
            end
        end
    })
end)

GuiLibrary.CanLoadConfig = true