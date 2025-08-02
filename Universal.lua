--[[
    Credits to anyones code i used or looked at

    Made by Maanaaaa and Wowzers
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local teleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local NetworkClient = game:GetService("NetworkClient")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local virtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local localPlayer = Players.LocalPlayer
local lplr = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local workspace = workspace
local Workspace = workspace
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local Backpack = LocalPlayer.Backpack
local Animate = LocalPlayer.Character:FindFirstChild("Animate")
local LightingTime = Lighting.TimeOfDay
local workspaceGravity = workspace.Gravity
local PlayerWalkSpeed = Humanoid.WalkSpeed
local PlayerJumpPower = Humanoid.JumpPower
local PlayerHipHeight = Humanoid.HipHeight
local OldCameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
local PlaceId = game.PlaceId
local JobId = game.JobId
local CurrentTool = nil
local allplayers = {}

local Mana = shared.Mana
local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions
local RunLoops = Mana.RunLoops
local connections = Mana.Connections
local friends = Mana.Friends
local playersHandler = Mana.PlayersHandler
local toolHandler = Mana.ToolHandler
local espLibrary = Mana.EspLibrary
local guifont = GuiLibrary.Font
Mana.StartTick = startTick

playersHandler:start()
toolHandler:start()
CurrentTool = toolHandler.currentTool

local getasset = getcustomasset
local function runFunction(func) func() end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

local requestfunc = http and http.request or http_request or request or function(tab)
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
    if Mana.Developer then
        return getasset("NewMana/" .. path)
    else
        if not betterisfile(path) then
            spawn(function()
                local textlabel = Instance.new("TextLabel")
                textlabel.Size = UDim2.new(1, 0, 0, 36)
                textlabel.Text = "Downloading "..path
                textlabel.BackgroundTransparency = 1
                textlabel.TextStrokeTransparency = 0
                textlabel.TextSize = 30
                textlabel.Font = GuiLibrary.Font
                textlabel.TextColor3 = Color3.new(1, 1, 1)
                textlabel.Position = UDim2.new(0, 0, 0, -36)
                textlabel.Parent = GuiLibrary.ScreenGui
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
end

local spawn = function(func) 
    return coroutine.wrap(func)()
end

local function CreateCoreNotification(title, text, duration)
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration,
	})
end

--[[
while isAlive() and wait(0.1) do
    local Tool = Character:FindFirstChildWhichIsA("Tool")
    if Tool then
        CurrentTool = Tool
    end
end
]]

-- Players handler part
local function isAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and Player.Character:FindFirstChild("HumanoidRootPart") and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

local function TargetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isPlayerTargetable(plr, target)
    return plr ~= LocalPlayer and plr and isAlive(plr) and TargetCheck(plr, target)
end

--[[
local function getClosestPlayer(MaxDistance, TeamCheck, lowesthealth)
	local MaximumDistance = MaxDistance
	local Target = nil
    local lowest = 100
    local unsorted = {}
    local humanoids = {}
    local sorted = {}

    local function sortByHealth()
        for i, player in next, unsorted do
            if isAlive(player) then
                table.insert(humanoids, player.Character.Humanoid.Health)
            end
        end
        table.sort(humanoids, function(a, b)
            return a.health < b.health
        end)

        for i, v in next, humanoids do
            table.insert(sorted, v.player)
        end
    end

    local function checkPlayer(v, byHealth)
        sortByHealth()
        if v.Character ~= nil then
            if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                    local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                    local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                    
                    if byHealth then
                        if v == sorted[1] then
                            Target = v
                        end
                    else
                        if VectorDistance < MaximumDistance then
                            Target = v
                        end
                    end
                end
            end
        end
        sortByHealth()
        return sorted[1]
    end

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
            table.insert(unsorted, player)
			if TeamCheck then
				if v.Team ~= LocalPlayer.Team then
					checkPlayer(v)
				end
			else
				checkPlayer(v)
			end
		end
	end

	return Target
end
]]

local function getClosestPlayer(MaxDisance, TeamCheck)
	local MaximumDistance = MaxDisance
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if TeamCheck then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
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
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
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

local function GetColorFromPlayer(Player) 
    if Player.Team ~= nil then return Player.TeamColor.Color end
end

local function ConvertHealthToColor(Health, MaxHealth)
    -- Input validation
    if type(Health) ~= "number" or type(MaxHealth) ~= "number" then
        return Color3.fromRGB(255, 255, 255)
    end
    
    if MaxHealth <= 0 then
        return Color3.fromRGB(255, 0, 0)
    end
    
    if Health <= 0 then
        return Color3.fromRGB(255, 0, 0)
    end
    
    local Percent = math.clamp((Health / MaxHealth) * 100, 0, 100)
    
    if Percent >= 70 then
        return Color3.fromRGB(96, 253, 48) -- Green
    elseif Percent >= 45 then
        return Color3.fromRGB(255, 196, 0) -- Yellow
    else
        return Color3.fromRGB(255, 71, 71) -- Red
    end
end

local function getCharacter(plr)
    plr = plr or lplr
    return plr.Character or plr.CharacterAdded:Wait()
end

local function getPlrByCharacter(character)
    for _, plr in next, Players:GetPlayers() do
        if plr.Character == character then
            return plr
        end
    end
end

local function getHumanoid(plr)
    plr = plr or lplr
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChildOfClass("Humanoid")
    end
end

local function getHumanoidRootPart(plr)
    plr = plr or lplr
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("HumanoidRootPart")
    end
end

local function getHead(plr)
    plr = plr or lplr
    if isAlive(plr) then
        return getCharacter(plr):FindFirstChild("Head")
    end
end

local function IsVisible(Position, WallCheck, ...)
    if not WallCheck then
        return true
    end
    return #Camera:GetPartsObscuringTarget({Position}, {Camera, LocalPlayer.Character, ...}) == 0
end

local function getClosestPlayerToMouse(Fov, TeamCheck, AimPart, WallCheck)
    local AimFov = Fov
    local TargetPosition = nil
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if isAlive(Player) and Character:FindFirstChild(AimPart) then
                if not TeamCheck or ((TeamCheck and Player.Team ~= LocalPlayer.Team) or (TeamCheck and (Player.Team == nil or Player.Team == "nil") and Player.Neutral == true)) then
                    local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Character[AimPart].Position)
                    if OnScreen then
                        local ScreenPosition2D = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                        local NewMagnitude = (ScreenPosition2D - UserInputService:GetMouseLocation()).Magnitude
                        if NewMagnitude < AimFov and IsVisible(Character[AimPart].Position, WallCheck, Character) then
                            AimFov = NewMagnitude
                            TargetPosition = Player
                        end
                    end
                end
            end
        end
    end
    return TargetPosition
end

local function AimAt(Target, Smoothness, AimPart)
    local AimPart = Target.Character:FindFirstChild(AimPart)
    if AimPart then
        local LookAt = nil
        local Distance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Target.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
        local AdjustedDistance = Distance / 10
        LookAt = Camera.CFrame:PointToWorldSpace(Vector3.new(0, 0, -Smoothness * AdjustedDistance)):Lerp(AimPart.Position, 0.01)
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, LookAt)
    end
end

-- check for CustomAnimations so if any param is missing CustomAnimations wont load, also it was made by ChatGPT (yeah)
local function CheckForAllAnimateParams(Animate)
    print("[ManaV2ForRoblox/Universal.lua]: Checking Animate parameters for CustomAnimations...")

    if not Animate then
        warn("[ManaV2ForRoblox/Universal.lua]: CustomAnimations can't be loaded, 'Animate' script is missing!")
        return false
    end

    local requiredAnimations = {
        {"idle", "Animation1", "AnimationId"},
        {"idle", "Animation2", "AnimationId"},
        {"walk", "WalkAnim", "AnimationId"},
        {"run", "RunAnim", "AnimationId"},
        {"jump", "JumpAnim", "AnimationId"},
        {"fall", "FallAnim", "AnimationId"},
        {"climb", "ClimbAnim", "AnimationId"},
        {"swim", "Swim", "AnimationId"},
    }

    for _, path in ipairs(requiredAnimations) do
        local current = Animate
        for _, step in ipairs(path) do
            if not current:FindFirstChild(step) then
                warn("[ManaV2ForRoblox/Universal.lua]: CustomAnimations can't be loaded, missing: " .. table.concat(path, "."))
                return false
            end
            current = current[step]
        end
    end

    print("[ManaV2ForRoblox/Universal.lua]: All Animate parameters are valid, CustomAnimations can be loaded.")
    return true
end



local function FindTouchInterest(Tool)
    return Tool and Tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end

local function findToolWithTouchInterest(plr)
    for _, tool in next, plr.Backpack do
        local touchInterest = FindTouchInterest(tool)
        if touchInterest then
            return tool
        end
    end
    return
end

-- CanClick is from vape
local function CanClick()
    local MousePosition = UserInputService:GetMouseLocation() - Vector2.new(0, 36)
    for i,v in pairs(PlayerGui:GetGuiObjectsAtPosition(MousePosition.X, MousePosition.Y)) do
        if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
            return false
        end
    end
    for i,v in pairs(CoreGui:GetGuiObjectsAtPosition(MousePosition.X, MousePosition.Y)) do
        if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
            return false
        end
    end
    return true
end

local function GetNearInstances(Radius, Player, RequiredInstance, IgnoreInstances)
    local Instances = {}
    local UselessInstances = {}

    local function IsIgnored(Instance)
        if IgnoreInstances == nil then
            return false
        end
        for _, v in pairs(IgnoreInstances) do
            if Instance:IsA(v) then
                return true
            end
        end
        return false
    end

    for _, Instance in next, workspace:GetDescendants() do
        if (not RequiredInstance or Instance:IsA(RequiredInstance)) and not IsIgnored(Instance) then
            if Instance:IsA("ClickDetector") and RequiredInstance == not "ClickDetector" then
                Instance = Instance.Parent
            end
            local Distance = (Instance.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if Distance <= Radius then
                table.insert(Instances, Instance)
            end
        else
            if IsIgnored(Instance) then
                table.insert(UselessInstances, Instance)
            end
        end
    end

    return Instances
end

local function isFriend(name)
    for _, friend in next, playersHandler.players do
        if friend == name or name == friend then
            return true
        end
    end
    return false
end

local function betterDisconnect(connection)
    if typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
    end
end

--[[
    ToDo list:
    Add normal ESP
    Add PlayerFollow
    Add PlayerJumpscare
    Add TurnInToBall
    Add J3rk0ff + all things that are connected with it
    Add SoundPlayer (Visual/Utility + in FE/Trolling way)
    Add normal notifications with switching between normal and roblox's notifications
    Add plugins/add-ons system
    Add themes system
    Make CustomAnimations dynamic, so it just wont add customization for missing animation
    Add KillAura

]]

-- // Combat tab
runFunction(function()
    local aimAssist = {Enabled = false}
    local aimPart = {Value = "Head"}
    local held = {Value = "RMB"}
    local smoothness = {Value = 100}
    local circle = {Value = false}
    local circleTransparency = {Value = 0}
    local circleFilled = {Value = false}
    local fov = {Value = 70}
    local highlightTarget = {Value = false}
    local highlightMode = {Value = "AimPart"}
    local highlightOutline = {Value = false}
    local highlightOutlineColor = {Value = "255, 255, 255"}
    local highlightOutlineTransparency = {Value = 0}
    local highlightFill = {Value = false}
    local highlightFillColor = {Value = "255, 255, 255"}
    local highlightFillTransparency = {Value = 0}
    local highlightTeamColor = {Value = false}
    local firstCamCheck = {Value = false}
    local wallCheck = {Value = false}
    local teamCheck = {Value = false}
    local autoFire = {Value = false}
    local toolCheck = {Value = false}
    local circleObj
    local CircleUpdateConnection
    local MouseClicked
    local connection
    local leftConnection
    local rightConnection
    local highlight
    local espLibrary = espLibrary:create("AimAssist")
    espLibrary.Mode = "Highlight"

    local function fireShoot(ToolCheck)
        local Player = getClosestPlayerToMouse(fov.Value, teamCheck.Value, aimPart.Value, wallCheck.Value)
        if ToolCheck and toolHandler.currentTool == nil then return end

        if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
            if Player then
                if CanClick() and GuiLibrary.Toggled == false and not UserInputService:GetFocusedTextBox() then
                    if MouseClicked then mouse1release() else mouse1press() end
                    MouseClicked = not MouseClicked
                else
                    if MouseClicked then mouse1release() end
                    MouseClicked = false
                end
            else
                if MouseClicked then mouse1release() end
                MouseClicked = false
            end
        end
    end

    local function UpdateCircle()
        if circle.Value then
            if not circleObj then
                circleObj = Drawing.new("Circle")
                circleObj.Filled = circleFilled.Value
                circleObj.Thickness = 3
                circleObj.Radius = fov.Value
                circleObj.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                circleObj.Visible = true
                circleObj.Transparency = circleTransparency.Value

                CircleUpdateConnection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                    circleObj.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                end)
            end
        else
            if circleObj then
                circleObj:Destroy()
                circleObj = nil
            end
            if CircleUpdateConnection then
                CircleUpdateConnection:Disconnect()
            end
        end
    end

    local function highlightAimTarget(plr, obj)
        if highlightTarget.Value then
            espLibrary:updateEspObject(plr, obj)
        else
            espLibrary:removeAllEspObjects()
        end
    end

    aimAssist = Tabs.Combat:CreateToggle({
        Name = "AimAssist",
        HoverText = "Automatically aims at the closest player to your mouse.",
        Callback = function(callback)
            if callback then
                RunService:BindToRenderStep("AimAssist", Enum.RenderPriority.Camera.Value + 1, function()
                    local leftConnection = held.Value == "LMB" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                    local rightConnection = held.Value == "RMB" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

                    if rightConnection or leftConnection then
                        if firstCamCheck.Value and getHead().LocalTransparencyModifier ~= 1 then return end
                        local plr = getClosestPlayerToMouse(fov.Value, teamCheck.Value, aimPart.Value, wallCheck.Value)
                        if plr and isAlive(plr, aimPart.Value == "Head") then
                            AimAt(plr, smoothness.Value, aimPart.Value)
                            if autoFire.Value then fireShoot(toolCheck.Value) end
                            --[[if highlightTarget.Value then
                                highlightAimTarget(plr, highlightMode.Value == "AimPart" and plr.Character:FindFirstChild(aimPart.Value) or plr.Character)
                            end]]
                        end
                    end
                end)
            else
                betterDisconnect(connection)
                espLibrary:removeAllEspObjects()
                RunService:UnbindFromRenderStep("AimAssist")
            end
        end
    })

    aimPart = aimAssist:CreateDropdown({
        Name = "Aim Part",
        Function = function(v) end,
        List = {"Head", "HumanoidRootPart"},
        Default = "Head",
    })

    held = aimAssist:CreateDropdown({
        Name = "Mouse Held",
        Function = function(v) end,
        List = {"LMB", "RMB"},
        Default = "RMB",
    })

    smoothness = aimAssist:CreateSlider({
        Name = "Smoothness",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0,
    })

    fov = aimAssist:CreateSlider({
        Name = "Fov",
        Function = function(v) end,
        Min = 1,
        Max = 120,
        Default = 70,
        Round = 0,
    })

    circle = aimAssist:CreateToggle({
        Name = "FOV Circle",
        Default = false,
        Function = function(v)
            if circleTransparency.MainObject then circleTransparency.MainObject.Visible = v end
            if circleFilled.MainObject then circleFilled.MainObject.Visible = v end
            if v then UpdateCircle() end
        end
    })

    circleTransparency = aimAssist:CreateSlider({
        Name = "Circle Transparency",
        Function = function(v) UpdateCircle() end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    circleFilled = aimAssist:CreateToggle({
        Name = "Circle Filled",
        Default = false,
        Function = function(v) UpdateCircle() end
    })

    --[[
    highlightTarget = aimAssist:CreateToggle({
        Name = "Highlight Target",
        Default = false,
        Callback = function(v)
            if highlightMode.MainObject then highlightMode.MainObject.Visible = v end
            if highlightOutline.MainObject then highlightOutline.MainObject.Visible = v end
            if highlightFill.MainObject then highlightFill.MainObject.Visible = v end
            if highlightTeamColor.MainObject then highlightTeamColor.MainObject.Visible = v end
        end
    })

    highlightMode = aimAssist:CreateDropdown({
        Name = "Highlight Mode",
        Function = function(v)
            if aimAssist.Enabled then aimAssist:ReToggle(true) end
        end,
        List = {"AimPart", "AimTarget"},
        Default = "AimPart",
    })
    highlightMode.MainObject.Visible = false

    highlightOutline = aimAssist:CreateToggle({
        Name = "Outline",
        Default = false,
        Function = function(v)
            if highlightOutlineColor.MainObject then highlightOutlineColor.MainObject.Visible = v end
            if highlightOutlineTransparency.MainObject then highlightOutlineTransparency.MainObject.Visible = v end
            espLibrary.outline = v
        end
    })
    highlightOutline.MainObject.Visible = false

    highlightOutlineColor = aimAssist:CreateColorSlider({
        Name = "Outline Color",
        Value = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            espLibrary.outlineColor = v
        end
    })
    highlightOutlineColor.MainObject.Visible = false

    highlightOutlineTransparency = aimAssist:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v)
            espLibrary.outlineTransparency = v
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })
    highlightOutlineTransparency.MainObject.Visible = false

    highlightFill = aimAssist:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            if highlightFillColor.MainObject then highlightFillColor.MainObject.Visible = v end
            if highlightFillTransparency.MainObject then highlightFillTransparency.MainObject.Visible = v end
            espLibrary.fill = v
        end
    })
    highlightFill.MainObject.Visible = false

    highlightFillColor = aimAssist:CreateColorSlider({
        Name = "Fill Color",
        Value = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            espLibrary.fillColor = v
        end
    })
    highlightFillColor.MainObject.Visible = false

    highlightFillTransparency = aimAssist:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v)
            espLibrary.fillTransparency = v
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })
    highlightFillTransparency.MainObject.Visible = false

    highlightTeamColor = aimAssist:CreateToggle({
        Name = "Team Color",
        Default = false,
        Function = function(v) end
    })
    highlightTeamColor.MainObject.Visible = false
    ]]

    firstCamCheck = aimAssist:CreateToggle({
        Name = "1st Person Check",
        Default = false,
        Function = function(v) end
    })

    teamCheck = aimAssist:CreateToggle({
        Name = "Team Check",
        Default = false,
        Function = function(v) end
    })

    wallCheck = aimAssist:CreateToggle({
        Name = "Wall Check",
        Default = false,
        Function = function(v) end
    })

    autoFire = aimAssist:CreateToggle({
        Name = "Auto Fire",
        Default = false,
        Function = function(v)
            if toolCheck.MainObject then toolCheck.MainObject.Visible = v end
        end
    })

    toolCheck = aimAssist:CreateToggle({
        Name = "Tool Check",
        Default = false,
        Function = function(v) end
    })
    toolCheck.MainObject.Visible = false
end)


runFunction(function()
    local autoClicker = {Enabled = false}
    local mode = {Value = "Click"}
    local cps = {Value = 15}

    local autoClicker = Tabs.Combat:CreateToggle({
        Name = "AutoClicker",
        HoverText = "Automatically clicks for you.",
        Callback = function(callback)
            if callback then
                spawn(function()
                    repeat
                        if mode.Value == "Click" or mode.Value == "RightClick" then
                            if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
                                if GuiLibrary.Toggled == false and not UserInputService:GetFocusedTextBox() then
                                    local ClickFunction = (mode.Value == "Click" and mouse1click or mouse2click)
                                    ClickFunction()
                                end
                            end
                        elseif mode.Value == "Tool" then
                            if toolHandler.currentTool == not nil and CurrentTool:IsA("Tool") and CanClick() then
                                toolHandler.currentTool:Active()
                            end
                        end
                        wait(1 / cps.Value)
                    until not autoClicker.Enabled
                end)
            end
        end
    })

    mode = autoClicker:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Click", "RightClick", "Tool"},
        Default = "Click"
    })

    cps = autoClicker:CreateSlider({
        Name = "CPS",
        Function = function() end,
        Min = 0,
        Max = 20,
        Default = 13,
        Round = 0
    })
end)

runFunction(function()
    local reach = {Enabled = false}
    local expandPart = {Value = "Head"}
    local expand = {Value = 0}
    local connection

    local function updatePlayer(plr)
        if plr == LocalPlayer then return end
        if isAlive(plr, expandPart.Value == "Head") and isPlayerTargetable(plr, true) then
            local humanoidRootPart = getHumanoidRootPart(plr)
            if expandPart.Value == "HumanoidRootPart" then
                getHumanoidRootPart(plr).Size = Vector3.new(2 * (expand.Value / 10), 2 * (expand.Value / 10), 1 * (expand.Value / 10))
            elseif expandPart.Value == "Head" then
                getHead(plr).Size = Vector3.new((expand.Value / 10), (expand.Value / 10), (expand.Value / 10))
            end
        end
    end

    reach = Tabs.Combat:CreateToggle({
        Name = "Reach",
        HoverText = "Expands hitboxes of other players.",
        Callback = function(callback)
            if callback then
                for _, plr in next, Players:GetPlayers() do
                    updatePlayer(plr)
                end
                connection = Players.PlayerAdded:Connect(function(plr)
                    updatePlayer(plr)
                end)
            else
                if connection then
                    connection:Disconnect()
                end
                for _, plr in next, Players:GetPlayers() do
                    if plr == LocalPlayer then return end
                    getHumanoidRootPart(plr).Size = Vector3.new(2, 2, 1)
                    getHead(plr).Size = Vector3.new(1, 1, 1)
                end
            end
        end
    })

    expandPart = reach:CreateDropdown({
        Name = "Expand Part",
        Function = function(v) end,
        List = {"HumanoidRootPart", "Head"},
        Default = "HumanoidRootPart"
    })

    expand = reach:CreateSlider({
        Name = "Expand Size",
        Min = 1,
        Max = 20,
        Round = 1, 
        Function = function(v) end,
    })
end)

-- // Movement tab
runFunction(function()
    local autoWalk = {Enabled = false}
    autoWalk = Tabs.Movement:CreateToggle({
        Name = "AutoWalk",
        HoverText = "Automatically walks forward for you.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AutoWalk", function()
                    if isAlive() then
                        getHumanoid(LocalPlayer):Move(Vector3.new(0, 0, -1), true)
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AutoWalk")
            end
        end
    })
end)

runFunction(function()
    local clickTP = {Enabled = false}
    local mode = {Value = "Click"}
    local tool
    local connection
    local connection2
    local function tp()
        if isAlive() then
            getHumanoidRootPart(LocalPlayer).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
        end 
    end
    clickTP = Tabs.Movement:CreateToggle({
        Name = "ClickTP",
        HoverText = "Teleports you to where you clicked.",
        Callback = function(callback) 
            if callback then
                if mode.Value == "Tool" then
                    tool = Instance.new("Tool")
                    tool.Name = "TPTool"
                    tool.Parent = Backpack
                    tool.RequiresHandle = false
                    tool.Activated:Connect(tp)
                elseif mode.Value == "Click" then
                    connection = Mouse.Button1Down:Connect(tp)
                elseif mode.Value == "RightClick" then
                    connection2 = Mouse.Button2Down:Connect(tp)
                end
            else
                if connection then 
                    connection:Disconnect()
                    connection = nil
                end
                if connection2 then 
                    connection2:Disconnect()
                    connection2 = nil
                end
                if tool then
                    tool:Destroy()
                end
            end
        end
    })

    mode = clickTP:CreateDropdown({
        Name = "Mode",
        Function = function(v)
            if clickTP.Enabled then clickTP:ReToggle() end
        end,
        List = {"Click", "RightClick", "Tool"},
        Default = "Click"
    })
end)

runFunction(function()
    local fastFall = {Enabled = false}
    local height = {Value = 5}
    local ticks = {Value = 5}
    fastFall = Tabs.Movement:CreateToggle({
        Name = "FastFall",
        HoverText = "Makes you fall faster.",
        Callback = function(callback)
            if callback then
                spawn(function() 
                    repeat task.wait()
                        if isAlive() then
                            local humanoid = getHumanoid(LocalPlayer)
                            local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                            local params = RaycastParams.new()
                            params.FilterDescendantsInstances = {LocalPlayer.Character}
                            params.FilterType = Enum.RaycastFilterType.Blacklist
                            local raycast = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -height.Value * 3, 0), params)
                            if raycast and raycast.Instance then 
                                local velocity = humanoidRootPart.Velocity
                                if humanoid:GetState() == Enum.HumanoidStateType.Freefall and velocity.Y < 0 then 
                                    humanoidRootPart.Velocity = Vector3.new(velocity.X, -(ticks.Value * 30), velocity.Z)
                                end
                            end
                        end
                    until not fastFall.Enabled
                end)
            end
        end
    })
    
    height = fastFall:CreateSlider({
        Name = "FallHeight",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 7,
        Round = 1
    })

    ticks = fastFall:CreateSlider({
        Name = "Ticks",
        Function = function(v) end,
        Min = 1,
        Max = 5,
        Default = 1,
        Round = 0
    })
end)

-- // fps based a little bit :sob:
-- // 60 fps is the best to avoid going down
runFunction(function()
    local fly = {Enabled = false}
    local mode = {Value = "Normal"}
    local keyboardMode = {Value = "LeftShift+Space"}
    local speed = {Value = 23}
    local verticalSpeed = {Value = 20}
    local useBodyPosition = {Value = false}
    local linearVelocity
    local bodyPosition
    fly = Tabs.Movement:CreateToggle({
        Name = "Fly",
        HoverText = "Makes you fly.\nFPS based, recommended FPS is 60.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("Fly", function(Delta)
                    local humanoid = getHumanoid(LocalPlayer)
                    local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                    local moveDirection = humanoid.MoveDirection
                    local velocity = humanoidRootPart.Velocity
                    local xDirection = moveDirection.X * speed.Value
                    local zDirection = moveDirection.Z * speed.Value
                    local yDirection = 0
                    local yVelocity = (math.abs(yDirection) < 0.1 and (workspace.Gravity * Delta * 0.6325)) or yDirection

                    if verticalSpeed.Value > 0 then
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and (keyboardMode.Value == "LeftShift+Space" or keyboardMode.Value == "LeftCtrl+Space") then
                            yDirection = verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.E) and keyboardMode.Value == "Q+E" then
                            yDirection = verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and keyboardMode.Value == "LeftShift+Space" then
                            yDirection = -verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and keyboardMode.Value == "LeftShift+Space" then
                            yDirection = -verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) and keyboardMode.Value == "Q+E" then
                            yDirection = -verticalSpeed.Value
                        end
                    end

                    if mode.Value == "AssemblyAngularVelocity" then
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(xDirection, yVelocity, zDirection)
                    elseif mode.Value == "AssemblyLinearVelocity" then
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(xDirection, yVelocity, zDirection)
                    elseif mode.Value == "LinearVelocity" then
                        linearVelocity = linearVelocity or Instance.new("LinearVelocity", humanoidRootPart)
                        linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
                        linearVelocity.MaxForce = math.huge
                        linearVelocity.VectorVelocity = Vector3.new(xDirection, yDirection, zDirection)
                    elseif mode.Value == "Velocity" then
                        humanoidRootPart.Velocity = Vector3.new(xDirection, yVelocity, zDirection)
                    elseif mode.Value == "CFrame" then
                        local factor = speed.Value - humanoid.WalkSpeed
                        local newMoveDirection = (moveDirection * factor) * Delta
                        local newCFrame = humanoidRootPart.CFrame + Vector3.new(newMoveDirection.X, yDirection * Delta, newMoveDirection.Z)
                        humanoidRootPart.CFrame = newCFrame
                        humanoidRootPart.Velocity = Vector3.zero
                    end

                end)
            else
                if linearVelocity then
                    linearVelocity:Destroy()
                    linearVelocity = nil
                end
                RunLoops:UnbindFromHeartbeat("Fly")
            end
        end
    })

    mode = fly:CreateDropdown({
        Name = "Mode",
        Function = function(v) 
            if speed.MainObject then speed.MainObject.Visible = v == "CFrame" end
        end,
        List = {"AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "CFrame"},
        Default = "Velocity"
    })

    speed = fly:CreateSlider({
        Name = "WalkSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 23,
        Round = 0
    })
    speed.MainObject.Visible = false

    keyboardMode = fly:CreateDropdown({
        Name = "KeyboardMode",
        Function = function(v) end,
        List = {"LeftShift+Space", "Q+E", "LeftCtrl+Space"},
        Default = "LeftShift+Space"
    })

    verticalSpeed = fly:CreateSlider({
        Name = "VerticalSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })
end)

runFunction(function()
    local forwardTP = {Enabled = false}
    local studs = {Value = 5}
    local teleporting = false
    forwardTP = Tabs.Movement:CreateToggle({
        Name = "ForwardTP",
        HoverText = "Teleports you forward.",
        Callback = function(callback)
            if callback and not teleporting then
                teleporting = true
                if isAlive() then
                    local humanoid = getHumanoid(LocalPlayer)
                    local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                    local look = humanoidRootPart.CFrame.LookVector
                    if humanoid.MoveDirection.Magnitude > 0 or Humanoid:GetState() == Enum.HumanoidStateType.Running then
                        local forward = look * studs.Value
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame + forward
                    end
                end
                teleporting = false
                forwardTP:Toggle(true, false)
            end
        end
    })
    
    studs = forwardTP:CreateSlider({
        Name = "Studs",
        Function = function(v) end,
        Min = 1,
        Max = 50,
        Default = 5,
        Round = 0
    })
end)


--[[somewhen later
runFunction(function()
    local ForwardTPMode = {Value = "TP"}
    local ForwardTPValue = {Value = 5}
    local ForwardTPTweenTime = {Value = 0.1}
    local Teleporting = false
    
    ForwardTP = Tabs.Movement:CreateToggle({
        Name = "ForwardTP",
        Keybind = nil,
        Callback = function(callback)
            if callback and not Teleporting then
                if isAlive() then
                    Teleporting = true
                    local Humanoid = LocalPlayer.Character.Humanoid
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local LookVector = HumanoidRootPart.LookVector
                    if Humanoid.MoveDirection.Magnitude > 0 or Humanoid:GetState() == Enum.HumanoidStateType.Running then
                        local ForwardVector = LookVector * ForwardTPValue.Value
                        if ForwardTPMode.Value == "TP" then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + ForwardVector
                        elseif ForwardTPMode.Value == "Tween" then
                            local ForwardTweenInfo = TweenInfo.new(ForwardTPTweenTime.Value)
                            local Tween = TweenService:Create(HumanoidRootPart, ForwardTweenInfo, {Position = HumanoidRootPart.Position + ForwardVector})
                            Tween:Play()
                            wait(ForwardTPTweenTime.Value)
                            Tween:Cancel()
                        end
                    end
                else
                    ForwardTP:Toggle(false, false)
                end
                Teleporting = false
                ForwardTP:Toggle(false, false)
            end
        end
    })

    ForwardTPMode = ForwardTP:CreateDropdown({
        Name = "Mode",
        List = {"TP", "Tween"},
        Default = "TP",
        Function = function(v) 
            if v == "Tween" then
                if ForwardTPTweenTime.MainObject then
                    ForwardTPTweenTime.MainObject.Visible = true
                end
            elseif v == "TP" then
                if ForwardTPTweenTime.MainObject then
                    ForwardTPTweenTime.MainObject.Visible = false
                end
            end
        end
    })
    
    ForwardTPTweenTime = ForwardTP:CreateSlider({
        Name = "Tween Time",
        Function = function(v) end,
        Min = 0,
        Max = 5,
        Default = 0.1,
        Round = 1
    })
    
    ForwardTPValue = ForwardTP:CreateSlider({
        Name = "Studs",
        Function = function(v) end,
        Min = 1,
        Max = 50,
        Default = 5,
        Round = 0
    })
end)
]]

runFunction(function()
    local highJump = {Enabled = false}
    local jumpMode = {Value = "Velocity"}
    local jumps = {Value = 5}
    local mode = {Value = "Toggle"}
    local height = {Value = 20}
    local connection
    local linearVelocity

    local function jump()
        local humanoid = getHumanoid(LocalPlayer)
        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
        if jumpMode.Value == "AssemblyAngularVelocity" then
            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "AssemblyLinearVelocity" then
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "LinearVelocity" then
            linearVelocity = Instance.new("LinearVelocity", humanoidRootPart)
            linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
            linearVelocity.MaxForce = math.huge
            linearVelocity.VectorVelocity = Vector3.new(0, height.Value, 0)
            task.wait(0.1)
            linearVelocity:Destroy()
        elseif jumpMode.Value == "Velocity" then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "TP" then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, height.Value, 0)
        elseif jumpMode.Value == "Jump" then
            spawn(function()
                for i = 1, jumps.Value do
                    task.wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end

    highJump = Tabs.Movement:CreateToggle({
        Name = "HighJump",
        HoverText = "Makes you jump higher.",
        Callback = function(callback)
            if callback then
                if mode.Value == "Toggle" then
                    jump()
                    highJump:Toggle(true)
                elseif mode.Value == "Normal" then
                    connection = table.insert(connections, UserInputService.JumpRequest:Connect(function()
                        jump()
                    end))
                end
            else
                betterDisconnect(connection)
                --workspace.Gravity = 196.19999694824
            end
        end
    })

    jumpMode = highJump:CreateDropdown({
        Name = "JumpMode",
        Function = function(v) 
            if mode.MainObject then
                mode.MainObject.Visible = v == "Jump"
            end
        end,
        List = {"AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "TP", "Jump"},
        Default = "Velocity"
    })

    mode = highJump:CreateDropdown({
        Name = "Mode",
        Callback = function(v) end,
        List = {"Toggle", "Normal"},
        Default = "Toggle"
    })

    jumps = highJump:CreateSlider({
        Name = "Jumps",
        Function = function() end,
        Min = 0,
        Max = 100,
        Default = 5,
        Round = 0
    })

    height = highJump:CreateSlider({
        Name = "Height",
        Function = function() end,
        Min = 0,
        Max = 100,
        Default = 25,
        Round = 0
    })
end)

runFunction(function()
    local longJump = {Enabled = false}
    local mode = {Value = "Velocity"}
    local power = {Value = 50}

    longJump = Tabs.Movement:CreateToggle({
        Name = "LongJump",
        HoverText = "Makes you jump forward.",
        Callback = function(callback)
            if callback then
                local humanoid = getHumanoid(LocalPlayer)
                local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                local oldCFrame = humanoidRootPart.CFrame
                local oldVelocity = humanoidRootPart.Velocity
                local direction = humanoidRootPart.CFrame.LookVector

                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                if mode.Value == "AssemblyAngularVelocity" then
                    humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(direction.X * power.Value, oldVelocity.Y, direction.Z * power.Value)
                elseif mode.Value == "AssemblyLinearVelocity" then
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(direction.X * power.Value, oldVelocity.Y, direction.Z * power.Value)
                elseif mode.Value == "LinearVelocity" then
                    local linearVelocity = Instance.new("LinearVelocity")
                    linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
                    linearVelocity.MaxForce = math.huge
                    linearVelocity.VectorVelocity = Vector3.new(direction.X * power.Value, oldVelocity.Y, direction.Z * power.Value)
                    linearVelocity.Parent = humanoidRootPart
                    task.wait(0.1)
                    linearVelocity:Destroy()
                elseif mode.Value == "Velocity" then
                    local NewVelocity = oldVelocity * power.Value
                    humanoidRootPart.Velocity = Vector3.new(NewVelocity.X, oldVelocity.Y, NewVelocity.X)
                elseif mode.Value == "CFrame" then
                    local newCFrame = oldCFrame * CFrame.new(direction.X * power.Value, 0, direction.Z * power.Value)
                    humanoidRootPart.CFrame = CFrame.new(newCFrame.X, oldCFrame.Y, newCFrame.Z)
                end

                longJump:Toggle(true)
            end
        end
    })

    mode = longJump:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "CFrame"},
        Default = "Velocity"
    })

    power = longJump:CreateSlider({
        Name = "Power",
        Function = function(v) end,
        Min = 1,
        Max = 1000,
        Default = 100,
        Round = 0
    })
end)

runFunction(function()
    local phase = {Enabled = false}
    local parts = {}
    phase = Tabs.Movement:CreateToggle({
        Name = "Phase",
        HoverText = "Makes you walk through walls.",
        Callback = function(callback) 
            if callback then 
                if isAlive() then
                    RunLoops:BindToStepped("Phase", function()
                        for i, v in pairs(getCharacter(LocalPlayer):GetChildren()) do 
                            if v:IsA("BasePart") and v.CanCollide then 
                                parts[v] = v
                                v.CanCollide = false
                            end
                        end
                    end)
                end
            else
                for i, v in next, parts do
                    v.CanCollide = true
                end
                parts = {}
                RunLoops:UnbindFromStepped("Phase")
            end
        end
    })
end)

runFunction(function()
    local speed = {Enabled = false}
    local mode = {Value = "Normal"}
    local value = {Value = 16}
    local autoJump = {Value = false}
    local jumpMode = {Value = "Normal"}
    local autoJumpPower = {Value = 25}
    local jumpPower = {Value = 50}
    local noAnim = {Value = false}
    local linearVelocity
    speed = Tabs.Movement:CreateToggle({
        Name = "Speed",
        HoverText = "Makes you walk faster.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("Speed", function(Delta)
                    if isAlive() then
                        local humanoid = getHumanoid(LocalPlayer)
                        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                        local moveDirection = humanoid.MoveDirection
                        local VelocityX = humanoidRootPart.Velocity.X
                        local VelocityZ = humanoidRootPart.Velocity.Z

                        if jumpPower.Value > humanoid.JumpPower then
                            humanoid.JumpPower = jumpPower.Value
                            humanoid.UseJumpPower = true
                        end

                        --[[cant make this to work normally + with auto jump
                        if mode.Value == "AssemblyAngularVelocity" then
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(moveDirection.X * value.Value, 0, moveDirection.Z * value.Value) --* Delta
                        elseif mode.Value == "AssemblyLinearVelocity" then
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(moveDirection.X * value.Value, 0, moveDirection.Z * value.Value) * Delta
                        elseif mode.Value == "LinearVelocity" then
                            linearVelocity = linearVelocity or Instance.new("LinearVelocity", humanoidRootPart)
                            linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
                            linearVelocity.Attachment0 = humanoidRootPart:FindFirstChildWhichIsA("Attachment")
                            linearVelocity.MaxForce = math.huge
                            linearVelocity.LineDirection = moveDirection
                            linearVelocity.LineVelocity = (moveDirection.X ~= 0 and moveDirection.Z ~= 0) and speed.Value or 0
                        else]]
                        if mode.Value == "Velocity" then
                            local Velocity = Humanoid.MoveDirection * (value.Value * 5) * Delta
                            Character:TranslateBy(Vector3.new(Velocity.X / 10, 0, Velocity.Z / 10))
                        elseif mode.Value == "CFrame" then
                            local Factor = value.Value - humanoid.WalkSpeed
                            local MoveDirection = (moveDirection * Factor) * Delta
                            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(MoveDirection.X, 0, MoveDirection.Z)
                        elseif mode.Value == "Normal" then
                            humanoid.WalkSpeed = value.Value
                        end

                        if autoJump.Value and (humanoid.FloorMaterial ~= Enum.Material.Air) and humanoid.MoveDirection ~= Vector3.zero then
                            if jumpMode == "Normal" then
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            else
                                humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, autoJumpPower.Value, humanoidRootPart.Velocity.Z)
                            end
                        end

                        if noAnim.Value then
                            Character.Animate.Disabled = true
                        end
                        if linearVelocity then
                            linearVelocity:Destroy()
                        end

                    end
                end)
            else
                if RunLoops.HeartTable.Speed then
                    RunLoops:UnbindFromHeartbeat("Speed")
                end

                getHumanoid().WalkSpeed = PlayerWalkSpeed
                getHumanoid().JumpPower = PlayerJumpPower
                getCharacter().Animate.Disabled = false
            end
        end
    })

    mode = speed:CreateDropdown({
        Name = "Mode",
        Function = function(v) 
            if speed.Enabled then 
                speed:ReToggle(true)
            end
        end,
        List = {"Velocity", "CFrame", "Normal"}, -- "AssemblyAngularVelocity", "AssemblyLinearVelocity", "LinearVelocity", "Velocity", "CFrame", "Normal"}
        Default = "Velocity"
    })

    value = speed:CreateSlider({
        Name = "Speed",
        Function = function(v) 
            if speed.Enabled and mode.Value == "Normal" then
                getHumanoid(LocalPlayer).WalkSpeed = v
            end
        end,
        Min = 0,
        Max = 200,
        Default = 16,
        Round = 0
    })

    autoJumpPower = speed:CreateSlider({
        Name = "AutoJumpPower",
        Function = function(v) end,
        Min = 0,
        Max = 30,
        Default = 25,
        Round = 0
    })

    jumpPower = speed:CreateSlider({
        Name = "JumpPower",
        Function = function(v) 
            if speed.Enabled then
                getHumanoid(LocalPlayer).JumpPower = v
            end
        end,
        Min = 0,
        Max = 200,
        Default = 50,
        Round = 0
    })

    autoJump = speed:CreateToggle({
        Name = "AutoJump",
        Default = false,
        Function = function(v)
            if jumpMode.MainObject then jumpMode.MainObject.Visible = v end
        end
    })

    jumpMode = speed:CreateDropdown({
        Name = "AutoJumpMode",
        Function = function(v) 
            if autoJumpPower.MainObject then
                autoJumpPower.MainObject.Visible = v == "Velocity"
            end
            if speed.Enabled then
                speed:ReToggle(true)
            end
        end,
        List = {"Normal", "Velocity"},
        Default = "Normal"
    })
    jumpMode.Container1.Visible = false

    noAnim = speed:CreateToggle({
        Name = "NoAnimation",
        Default = false,
        Function = function(v)
            if speed.Enabled then
                getCharacter(LocalPlayer).Animate.Disabled = v
            end
        end
    })
end)

runFunction(function()
    local spinBot = {Enabled = false}
    local mode = {Value = "Velocity"}
    local spinBotSpeed = {Value = 20}
    local spinBotX = {Value = false}
    local spinBotY = {Value = false}
    local spinBotZ = {Value = false}
    local velocityX
    local velocityY
    local velocityZ
    local angularX
    local angularY
    local angularZ
    local angularVelocity = Instance.new("AngularVelocity")
    spinBot = Tabs.Movement:CreateToggle({
        Name = "SpinBot",
        HoverText = "Makes your character spin.\nDoesn't work in first person.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("SpinBot", function()
                    if isAlive() then
                        local humanoid = getHumanoid(LocalPlayer)
                        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                        local oldVelocity = humanoidRootPart.AssemblyAngularVelocity
                        velocityX = (spinBotX.Value and spinBotSpeed.Value) or oldVelocity.X
                        velocityY = (spinBotY.Value and spinBotSpeed.Value) or oldVelocity.Y
                        velocityZ = (spinBotZ.Value and spinBotSpeed.Value) or oldVelocity.Z
                        angularX = (spinBotX.Value and math.huge) or 0
                        angularY = (spinBotY.Value and math.huge) or 0
                        angularZ = (spinBotZ.Value and math.huge) or 0

                        humanoid.AutoRotate = false
                        if mode.Value == "RotVelocity" then
                            humanoidRootPart.RotVelocity = Vector3.new(velocityX, velocityY, velocityZ)
                        --[[
                        elseif mode.Value == "AngularVelocity" then
                            angularVelocity.Parent = humanoidRootPart
                            angularVelocity.MaxTorque = Vector3.new(angularX, angularY, angularZ)
                            angularVelocity.AngularVelocity = Vector3.new(velocityX, velocityY, velocityZ)
                        ]]
                        elseif mode.Value == "AssemblyAngularVelocity" then
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.new(velocityX, velocityY, velocityZ)
                        end
                    end
                end)
            else
                getHumanoid(LocalPlayer).AutoRotate = true
                RunLoops:UnbindFromHeartbeat("SpinBot")
            end
        end
    })

    mode = spinBot:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"RotVelocity", "AssemblyAngularVelocity"}, --"AngularVelocity",
        Default = "AssemblyAngularVelocity"
    })

    spinBotSpeed = spinBot:CreateSlider({
        Name = "SpinSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })

    spinBotX = spinBot:CreateToggle({
        Name = "Spin X",
        Default = false,
        Function = function(v) end
    })

    spinBotY = spinBot:CreateToggle({
        Name = "Spin Y",
        Default = false,
        Function = function(v) end
    })

    spinBotZ = spinBot:CreateToggle({
        Name = "Spin Z",
        Default = false,
        Function = function(v) end
    })
end)


-- // Render tab
runFunction(function()
    local breadcrumbs = {Enabled = false}
    local mode = {Value = "Trail"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local startColor = {Value = Color3.fromRGB(255, 255, 255)}
    local endColor = {Value = Color3.fromRGB(255, 255, 255)}
    local size = {Value = 0.5}
    local distance = {Value = 1}
    local lifeTime = {Value = 20}
    local transparency = {Value = 0}
    local objects = Instance.new("Folder", workspace)
    objects.Name = "breadcrumbsObjects"
    local trail
	local attachment
	local attachment2
    local lastPos
    --local objects = {}
    breadcrumbs = Tabs.Render:CreateToggle({
        Name = "Breadcrumbs",
        HoverText = "Creates a trail behind you.",
        Callback = function(callback)
            if callback then
                task.spawn(function()
					repeat
						if isAlive() then
                            local humanoidRootPart = getHumanoidRootPart()
                            if mode.Value == "Trail" then
                                if not trail then
                                    attachment = Instance.new("Attachment")
                                    attachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
                                    attachment2 = Instance.new("Attachment")
                                    attachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
                                    trail = Instance.new("Trail")
                                    trail.Attachment0 = attachment
                                    trail.Attachment1 = attachment2
                                    trail.Color = ColorSequence.new(startColor.Value, endColor.Value)
                                    trail.FaceCamera = true
                                    trail.Lifetime = lifeTime.Value / 10
                                    trail.Enabled = true
                                else
                                    local Succes = pcall(function()
                                        attachment.Parent = humanoidRootPart
                                        attachment2.Parent = humanoidRootPart
                                        trail.Parent = Camera
                                    end)
                                    if not Succes then
                                        if trail then trail:Destroy() trail = nil end
                                        if attachment then attachment:Destroy() attachment = nil end
                                        if attachment2 then attachment2:Destroy() attachment2 = nil end
                                    end
                                end
                            elseif mode.Value == "Spheres" then
                                if (lastPos and (humanoidRootPart.Position - lastPos).Magnitude > distance.Value) or not lastPos then
                                    local sphere = Instance.new("Part", objects)
                                    sphere.Shape = Enum.PartType.Ball
                                    sphere.Size = Vector3.new(0.5, 0.5, 0.5)
                                    sphere.Color = color.Value
                                    sphere.Material = Enum.Material.Plastic
                                    sphere.CanCollide = false
                                    sphere.Anchored = true
                                    sphere.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, 0)
                                    sphere.Transparency = transparency.Value
                                    sphere.TopSurface = Enum.SurfaceType.Smooth
                                    sphere.BottomSurface = Enum.SurfaceType.Smooth
                                    sphere.FrontSurface = Enum.SurfaceType.Smooth
                                    sphere.BackSurface = Enum.SurfaceType.Smooth
                                    sphere.LeftSurface = Enum.SurfaceType.Smooth
                                    sphere.RightSurface = Enum.SurfaceType.Smooth
                                    debris:AddItem(sphere, lifeTime.Value)
                                    lastPos = humanoidRootPart.Position
                                end
                            elseif mode.Value == "Cubes" then
                                if (lastPos and (humanoidRootPart.Position - lastPos).Magnitude > distance.Value) or not lastPos then
                                    local cube = Instance.new("Part", objects)
                                    cube.Size = Vector3.new(0.5, 0.5, 0.5)
                                    cube.Color = color.Value
                                    cube.Material = Enum.Material.Plastic
                                    cube.CanCollide = false
                                    cube.Anchored = true
                                    cube.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, 0)
                                    cube.Transparency = transparency.Value
                                    cube.TopSurface = Enum.SurfaceType.Smooth
                                    cube.BottomSurface = Enum.SurfaceType.Smooth
                                    cube.FrontSurface = Enum.SurfaceType.Smooth
                                    cube.BackSurface = Enum.SurfaceType.Smooth
                                    cube.LeftSurface = Enum.SurfaceType.Smooth
                                    cube.RightSurface = Enum.SurfaceType.Smooth
                                    debris:AddItem(cube, lifeTime.Value)
                                    lastPos = humanoidRootPart.Position
                                end
                            end
						end
                        task.wait()
					until not breadcrumbs.Enabled
				end)
            else
                if trail then
                    trail:Destroy()
                    trail = nil
                end
				if attachment then
                    attachment:Destroy()
                    attachment = nil
                end
				if attachment2 then
                    attachment2:Destroy()
                    attachment2 = nil
                end
                for _, object in pairs(objects) do
                    object:Destroy()
                end
            end
        end
    })

    mode = breadcrumbs:CreateDropdown({
        Name = "Mode",
        List = {"Trail", "Spheres", "Cubes"},
        Default = "Trail",
        Function = function(v) 
            if startColor.MainObject then startColor.MainObject.Visible = v == "Trail" end
            if endColor.MainObject then endColor.MainObject.Visible = v == "Trail" end
            if color.MainObject then color.MainObject.Visible = v ~= "Trail" end
            if size.MainObject then size.MainObject.Visible = v ~= "Trail" end
            if distance.MainObject then distance.MainObject.Visible = v ~= "Trail" end
        end
    })

    startColor = breadcrumbs:CreateColorSlider({
        Name = "Start color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) 
            if trail then
                trail.Color = ColorSequence.new(v, endColor.Value)
            end
        end
    })

    endColor = breadcrumbs:CreateColorSlider({
        Name = "End color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) 
            if trail then
                trail.Color = ColorSequence.new(startColor.Value, v)
            end
        end
    })

    color = breadcrumbs:CreateColorSlider({
        Name = "End color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) 
            if breadcrumbs.Enabled then
                for _, obj in next, objects:GetChildren() do
                    obj.Color = v
                end
            end
        end
    })
    color.MainObject.Visible = false

    size = breadcrumbs:CreateSlider({
        Name = "Size",
        Function = function(v) 
            if breadcrumbs.Enabled then
                for _, obj in next, objects:GetChildren() do
                    obj.Size = Vector3.new(v, v, v)
                end
            end
        end,
        Min = 0.1,
        Max = 5,
        Default = 1,
        Round = 1
    })
    size.MainObject.Visible = false

    distance = breadcrumbs:CreateSlider({
        Name = "Distance",
        Function = function(v) end,
        Min = 0.1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    lifeTime = breadcrumbs:CreateSlider({
        Name = "LifeTime",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0
    })

    transparency = breadcrumbs:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            if breadcrumbs.Enabled then
                for _, obj in next, objects:GetChildren() do
                    obj.Transparency = v
                end
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
end)

runFunction(function()
    local camFix = {Enabled = false}
    camFix = Tabs.Render:CreateToggle({
        Name = "CameraFix",
        HoverText = "Changes camera zooming.",
        Callback = function(callback) 
            spawn(function()
                repeat
                    UserSettings():GetService("UserGameSettings").RotationType = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
                    task.wait()
                until not camFix.Enabled
            end)
        end
    })
end)

runFunction(function()
    local esp = {Enabled = false}
    local adorneePart = {Value = "HumanoidRootPart"}
    local mode = {Value = "SelectionBox"}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local color = {Value = Color3.fromRGB(255, 0, 0)}
    local transparency = {Value = 0}
    --local lineThickness = {Value = 0}
    --local surfaceTransparency = {Value = 0}
    local useTeamColor = {Value = false}
    local teammates = {Value = false}
    local alwaysOnTop = {Value = true}
    local connection
    local connection2

    local espLibrary = espLibrary:create("ESP")

    esp = Tabs.Render:CreateToggle({
        Name = "ESP",
        HoverText = "Shows people through walls.",
        Callback = function(callback)
            if callback then
                espLibrary:start()
            else
                espLibrary:stop()
            end
        end
    })

    adorneePart = esp:CreateDropdown({
        Name = "Attach Part",
        List = {"Head", "HumanoidRootPart", "Full Character"},
        Default = "Full Character",
        Function = function(v)
            espLibrary.adorneePart = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end
    })

    mode = esp:CreateDropdown({
        Name = "Mode",
        List = {"BoxHandleAdornment", "Highlight"}, --"SelectionBox", "BoxHandleAdornment", "Highlight"
        Default = "Highlight",
        Callback = function(v)
            espLibrary.mode = v
            local modeVisibility = {
                --SelectionBox = {lineThickness, surfaceTransparency, color, transparency},
                BoxHandleAdornment = {color, transparency},
                Highlight = {outline, fill}
            }
            for _, group in pairs(modeVisibility) do
                for _, item in ipairs(group) do
                    if item.Container then
                        item.Container.Visible = false
                    end
                    if item.Type == "OptionToggle" then
                        item:ReToggle()
                    end
                end
            end
            for _, item in ipairs(modeVisibility[v]) do
                if item.Container then
                    item.Container.Visible = true
                end
            end
            if esp.Enabled then
                esp:ReToggle(true)
                espLibrary:updateAll()
            end
        end
    })

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
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end
    })
    outlineColor.Container.Visible = false

    outlineTransparency = esp:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v)
            espLibrary.outlineTransparency = v
            if esp.Enabled then
                espLibrary:updateAll()
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
        end
    })

    fillColor = esp:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.fillColor = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end
    })
    fillColor.Container.Visible = false

    fillTransparency = esp:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v)
            espLibrary.fillTransparency = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.Container.Visible = false

    color = esp:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            espLibrary.color = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end
    })
    color.Container.Visible = false

    transparency = esp:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            espLibrary.transparency = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    transparency.Container.Visible = false

    --[[
    lineThickness = esp:CreateSlider({
        Name = "Line Thickness",
        Function = function(v)
            espLibrary.lineThickness = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    surfaceTransparency = esp:CreateSlider({
        Name = "Surface Transparency",
        Function = function(v)
            espLibrary.surfaceTransparency = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end,
        Min = 0,
        Max = 10,
        Default = 1,
        Round = 1
    })
    ]]

    alwaysOnTop = esp:CreateToggle({
        Name = "AlwaysOnTop",
        Default = true,
        Function = function(v)
            if mode.Value == "BoxHandleAdornment" then
                esp.boxHandleAlwaysOnTop = v
            elseif mode.Value == "Highlight" then
                esp.highlightAlwaysOnTop = v
            end
        end
    })

    useTeamColor = esp:CreateToggle({
        Name = "TeamColor",
        Default = false,
        Function = function(v)
            espLibrary.useTeamColor = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end
    })

    teammates = esp:CreateToggle({
        Name = "Teammates",
        Default = false,
        Function = function(v)
            espLibrary.teammates = v
            if esp.Enabled then
                espLibrary:updateAll()
            end
        end
    })
end)

runFunction(function()
    local chinaHat = {Enabled = false}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local chinaHatTrail
    chinaHat = Tabs.Render:CreateToggle({
        Name = "ChinaHat",
        HoverText = "Puts a china hat on your head.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("chinaHat", function()
					if isAlive() then
                        local head = getHead(LocalPlayer)
						if chinaHatTrail == nil or chinaHatTrail.Parent == nil then
							chinaHatTrail = Instance.new("Part")
							chinaHatTrail.CFrame =  head.CFrame * CFrame.new(0, 1.1, 0)
							chinaHatTrail.Size = Vector3.new(3, 0.7, 3)
							chinaHatTrail.Name = "ChinaHat"
							chinaHatTrail.Material = Enum.Material.Neon
							chinaHatTrail.CanCollide = false
							chinaHatTrail.Transparency = 0.3
                            chinaHatTrail.Color = color.Value
							local chinaHatMesh = Instance.new("SpecialMesh")
							chinaHatMesh.Parent = chinaHatTrail
							chinaHatMesh.MeshType = "FileMesh"
							chinaHatMesh.MeshId = "http://www.roblox.com/asset/?id=1778999"
							chinaHatMesh.Scale = Vector3.new(3, 0.6, 3)
							chinaHatTrail.Parent = workspace.Camera
						end
						chinaHatTrail.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
						chinaHatTrail.Velocity = Vector3.zero
						chinaHatTrail.LocalTransparencyModifier = head.LocalTransparencyModifier--((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.6 and 1 or 0)
					else
						if chinaHatTrail then
							chinaHatTrail:Destroy()
							chinaHatTrail = nil
						end
					end
				end)
            else
                RunLoops:UnbindFromHeartbeat("chinaHat")
				if chinaHatTrail then
					chinaHatTrail:Destroy()
					chinaHatTrail = nil
				end
            end
        end
    })

    color = chinaHat:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if chinaHatTrail then
                chinaHatTrail.Color = v
            end
        end
    })
end)


runFunction(function()
    local crossHair = {Enabled = false}
    local id = {Value = ""}
    crossHair = Tabs.Render:CreateToggle({
        Name = "CustomCrossHair",
        HoverText = "Changes your crosshair.",
        Callback = function(callback)
            if callback then
                Mouse.Icon = "rbxassetid://" .. id.Value
            else
                Mouse.Icon = ""
            end
        end
    })

    id = crossHair:CreateTextBox({
        Name = "CrossHairID",
        PlaceholderText = "Asset ID",
        DefaultValue = "",
        Function = function(v) end,
    })
end)


--[[
runFunction(function()
    local EspMode = {Value = "Image"}
    local NameMode = {Value = "Username"}
    local HealthBar = {Value = false}
    local Distance = {Value = false}

    local ESPFolder = Instance.new("Folder")
    ESPFolder.Parent = Workspace
    local PlayersTable = {}
    local PlayerAddedConnection
    local PlayerRemovingConnection

    local function RemoveEsp(Player)
        local Image = ESPFolder:FindFirstChild(Player.Name)

        if Image then
            Image:Destroy()
        end
    end

    local function UpdateEsp(Player)
        if EspMode.Value == "Image" then
            local Image
            if PlayersTable[Player.Name] then
                if ESPFolder:FindFirstChild(Player.Name) then
                    Image = ESPFolder[Player.Name]
                    Image.Visible = false
                else
                    Image = Instance.new("ImageLabel")
                    Image.BackgroundTransparency = 1
                    Image.BorderSizePixel = 0
                    Image.Image = GetCustomAsset("Assets/EspFrame.png") --GetCustomAsset("Assets/EspFrame.png")
                    Image.Visible = false
                    Image.Name = Player.Name
                    Image.Parent = ESPFolder
                    Image.Size = UDim2.new(0, 256, 0, 256)
                end
                print(1)

                if isAlive(Player) and Player ~= LocalPlayer and Player.Team ~= tostring(LocalPlayer.Team) then
                    print(2)
                    local Character = Player.Character
                    local Humanoid = Character.Humanoid
                    local HumanoidRootPart = Character.HumanoidRootPart
                    local RootPos, RootVis = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
                    local RootSize = (HumanoidRootPart.Size.X * 1200) * (Camera.ViewportSize.X / 1920)
                    local HeadPos, HeadVis = Camera:WorldToViewportPoint(HumanoidRootPart.Position + Vector3.new(0, 1 + (Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or Humanoid.HipHeight), 0))
                    local LegPos, LegVis = Camera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 1 + (Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or Humanoid.HipHeight), 0))
                    RootPos = RootPos
                    if RootVis then
                        print(RootVis)
                        Image.Visible = RootVis
                        Image.Size = UDim2.new(0, RootSize / RootPos.Z, 0, HeadPos.Y - LegPos.Y)
                        Image.Position = UDim2.new(0, RootPos.X - Image.Size.X.Offset / 2, 0, (RootPos.Y - Image.Size.Y.Offset / 2) - 36)
                    end
                end
            end
        end
    end

    local Esp = Tabs.Render:CreateToggle({
        Name = "ESP",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("ESP", function()
                    for _, Player in next, Players:GetPlayers() do
                        PlayersTable[Player.Name] = Player.Name
                        UpdateEsp(Player)
                    end
                end)

                PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
                    UpdateEsp(Player)
                end)

                PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(Player)
                    RemoveEsp(Player)
                end)
            else
                RunLoops:UnbindFromRenderStep("ESP")
                for _, Player in next, Players:GetPlayers() do
                    RemoveEsp(Player)
                end
                if PlayerAddedConnection then
                    PlayerAddedConnection:Disconnect()
                end
                if PlayerRemovingConnection then
                    PlayerRemovingConnection:Disconnect()
                end
            end
        end
    })

    EspMode = Esp:CreateDropdown({
        Name = "Mode",
        List = {"Image"},
        Default = "Image",
        Callback = function(v)

        end
    })

    EspName = Esp:CreateToggle({
        Name = "Name",
        Default = false,
        Function = function(v)
            if NameMode.MainObject then
                NameMode.MainObject.Visible = v
            end
        end
    })

    NameMode = Esp:CreateDropdown({
        Name = "Name Mode",
        List = {"Username", "DisplayName"},
        Default = "Username",
        Callback = function(v)

        end
    })
    NameMode.MainObject.Visible = false

    HealthBar = Esp:CreateToggle({
        Name = "HealthBar",
        Default = false,
        Function = function(v)

        end
    })

    Distance = Esp:CreateToggle({
        Name = "Distance",
        Default = false,
        Function = function(v)

        end
    })
end)    
]]

runFunction(function()
    local fovChanger = {Enabled = false}
    local fov = {Value = 80}
    local oldfov
    fovChanger = Tabs.Render:CreateToggle({
        Name = "FOVChanger",
        HoverText = "Changes your field for view.",
        Callback = function(callback)
            if callback then
                oldfov = Camera.FieldOfView
                Camera.FieldOfView = fov.Value
            else
                Camera.FieldOfView = oldfov
            end
        end
    })
    
    fov = fovChanger:CreateSlider({
        Name = "FOV",
        Function = function(v) end,
        Min = 1,
        Max = 150,
        Default = 80,
        Round = 0
    })
end)

runFunction(function()
    local fullbright = {Enabled = false}
    local params = {}
	local changed = false
    local connection
    fullbright = Tabs.Render:CreateToggle({
        Name = "Fullbright",
        HoverText = "Makes everything brigher.",
        Callback = function(callback)
            if callback then
                params.Brightness = Lighting.Brightness
                params.ClockTime = Lighting.ClockTime
                params.FogEnd = Lighting.FogEnd
                params.GlobalShadows = Lighting.GlobalShadows
                params.OutdoorAmbient = Lighting.OutdoorAmbient
                changed = true
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                changed = false
                connection = table.insert(connections, Lighting.Changed:Connect(function()
                    if not changed and callback then
                        params.Brightness = Lighting.Brightness
                        params.ClockTime = Lighting.ClockTime
                        params.FogEnd = Lighting.FogEnd
                        params.GlobalShadows = Lighting.GlobalShadows
                        params.OutdoorAmbient = Lighting.OutdoorAmbient
                        changed = true
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 100000
                        Lighting.GlobalShadows = false
                        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                        changed = false
                    end
                end))
            else
                if connection then
                    connection:Disconnect()
                end
                for Name, Value in pairs(params) do
                    Lighting[Name] = Value
                end
            end
        end
    })  
end)

runFunction(function()
    local keyStrokes = {Enabled = false}
    local mode = {Value = "Letters"}
    local textSize = {Value = 15}
    local spaceTextSize = {Value = 17}
    local size = {Value = 1}
    local transparency = {Value = 0.5}
    local showMouseButtons = {Value = false}
    local textXAllignment = {Value = "Left"}
    local textYAllignment = {Value = "Top"}

    keyStrokes = Tabs.Render:CreateToggle({
        Name = "KeyStrokes",
        HoverText = "Creates ui with keys and shows which ones you held.",
        Callback = function(callback)
            Mana.KeyStrokes:toggle()
        end
    })

    mode = keyStrokes:CreateDropdown({
        Name = "Mode",
        Function = function(v) 
            Mana.KeyStrokes:changeSymbols(v)
        end,
        List = {"Letters", "Directions", "Directions2", "Arrows"},
        Default = "Letters"
    })

    textSize = keyStrokes:CreateSlider({
        Name = "Text Size",
        Function = function(v) 
            Mana.KeyStrokes:updateTextSize(v)
        end,
        Min = 10,
        Max = 30,
        Default = 15,
        Round = 0
    })

    spaceTextSize = keyStrokes:CreateSlider({
        Name = "Space Text Size",
        Function = function(v) 
            Mana.KeyStrokes:updateSpaceTextSize(v)
        end,
        Min = 10,
        Max = 30,
        Default = 17,
        Round = 0
    })

    size = keyStrokes:CreateSlider({
        Name = "Size",
        Function = function(v) 
            Mana.KeyStrokes:updateSize(v)
        end,
        Min = 0.1,
        Max = 5,
        Default = 1,
        Round = 2
    })

    transparency = keyStrokes:CreateSlider({
        Name = "Transparency",
        Function = function(v) 
            Mana.KeyStrokes:updateBackgroundTransparency(v)
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 1
    })

    showMouseButtons = keyStrokes:CreateToggle({
        Name = "Mouse Buttons",
        Default = false,
        Function = function(v) 
            Mana.KeyStrokes:toggleMouseButtons(v)
        end
    })

    textXAllignment = keyStrokes:CreateDropdown({
        Name = "Text X Pos",
        Function = function(v) 
            Mana.KeyStrokes:updateTextPosition(v, textYAllignment.Value)
        end,
        List = {"Left", "Center", "Right"},
        Default = "Left"
    })

    textYAllignment = keyStrokes:CreateDropdown({
        Name = "Text Y Pos",
        Function = function(v) 
            Mana.KeyStrokes:updateTextPosition(textXAllignment.Value, v)
        end,
        List = {"Top", "Center", "Bottom"},
        Default = "Top"
    })
end)

-- Made by Wowzers
runFunction(function()
    local nameTags = {Enabled = false}
    local mode = {Value = "Username"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local teamColor = {Value = false}
    local showHP = {Value = false}
    local showDistance = {Value = false}
    local maxDistance = {Value = 1000}
    local billboardGuis = {}
    local connections = {}
    local nameTagsFolder = Instance.new("Folder")
    nameTagsFolder.Name = "NameTagsFolder"
    nameTagsFolder.Parent = CoreGui or workspace
    local connections = {}
    local lastFullUpdate

    for _, existing in pairs(CoreGui:GetChildren()) do
        if existing.Name == "NameTagsFolder" and existing ~= nameTagsFolder then
            existing:Destroy()
        end
    end

    local function CleanupPlayerNameTag(plr)
        local playerName = typeof(plr) == "string" and plr or plr.Name

        if billboardGuis[playerName] then
            if billboardGuis[playerName].Parent then
                billboardGuis[playerName]:Destroy()
            end
            billboardGuis[playerName] = nil
        end
    end

    local textLabelProps = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextStrokeTransparency = 0.4,
        TextYAlignment = Enum.TextYAlignment.Center,
        RichText = true,
        Name = "NameTagText"
    }
    
    local function CreateNameTag(plr)
        if not isAlive(plr, true) then
            return nil
        end
        
        CleanupPlayerNameTag(plr)
        
        local billboardGui = Instance.new("BillboardGui")
        local textLabel = Instance.new("TextLabel")
        
        billboardGui.Name = "NameTag_" .. plr.Name
        billboardGui.Adornee = plr.Character.Head
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 1.2, 0)
        billboardGui.MaxDistance = maxDistance.Value
        billboardGui.Parent = nameTagsFolder
        
        for prop, value in pairs(textLabelProps) do
            textLabel[prop] = value
        end
        textLabel.Parent = billboardGui
        
        billboardGuis[plr.Name] = billboardGui
        return billboardGui
    end
    
    local function UpdateNameTag(plr)
        if not isAlive(plr) then return end
        
        local billboardGui = billboardGuis[plr.Name]
        if not billboardGui or not billboardGui.Parent then return end

        local character = getCharacter(plr)
        local humanoid = getHumanoid(plr)
        local humanoidRootPart = getHumanoidRootPart(plr)
        local localHumanoidRootPart = getHumanoidRootPart()
        
        local textLabel = billboardGui:FindFirstChild("NameTagText")
        if not textLabel then return end
        
        local nameText = mode.Value == "Username" and plr.Name or plr.DisplayName
        local parts = {}

        table.insert(parts, string.format("<font color=\"rgb(%d, %d, %d)\">%s</font>",
            color.RawColorTable.R,
            color.RawColorTable.G,
            color.RawColorTable.B,
        nameText))
        
        if showHP.Value then
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            local healthColor = ConvertHealthToColor(health, maxHealth)
            local color = teamColor and plr.Team and plr.TeamColor or color.Value
            
            table.insert(parts, string.format(" <font color=\"rgb(%d,%d,%d)\">%d HP</font>", 
                math.floor(healthColor.R * 255), 
                math.floor(healthColor.G * 255), 
                math.floor(healthColor.B * 255), 
            health))
        end
        
        if showDistance.Value and isAlive() then
            local distance = math.floor((localHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
            table.insert(parts, string.format(" [%dm]", distance))
        end
        
        textLabel.Text = table.concat(parts)
        
        if showDistance.Value and isAlive() then
            local distance = (localHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            local scaleFactor = math.clamp(1 - (distance / maxDistance.Value) * 0.5, 0.5, 1)
            if math.abs(textLabel.TextSize - (16 * scaleFactor)) > 0.5 then
                textLabel.TextSize = 16 * scaleFactor
            end
        end
    end
    
    local function UpdateAllNameTags()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and isAlive(plr) then
                if billboardGuis[plr.Name] and billboardGuis[plr.Name].Parent then
                    UpdateNameTag(plr)
                else
                    CreateNameTag(plr)
                end
            end
        end
    end
    
    local function CleanupAllNameTags()
        for name, gui in pairs(billboardGuis) do
            if gui and gui.Parent then
                gui:Destroy()
            end
            billboardGuis[name] = nil
        end
    end
    

    nameTags = Tabs.Render:CreateToggle({
        Name = "NameTags",
        HoverText = "Adds nametag above every player.",
        Callback = function(callback)
            if callback then
                table.insert(connections, Players.PlayerRemoving:Connect(function(plr) -- note: here connections is a new table, not accross this whole script
                    CleanupPlayerNameTag(plr)
                end))
                lastFullUpdate = 0
                RunLoops:BindToRenderStep("NameTags", function()
                    local now = tick()
                    if now - lastFullUpdate > 0.5 then
                        lastFullUpdate = now
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer then
                                if isAlive(plr) and (not billboardGuis[plr.Name] or not billboardGuis[plr.Name].Parent) then
                                    CreateNameTag(plr)
                                    table.insert(connections, plr.CharacterRemoving:Connect(function()
                                        CleanupPlayerNameTag(plr)
                                    end))
                                elseif (not isAlive(plr)) and billboardGuis[plr.Name] then
                                    CleanupPlayerNameTag(plr)
                                end
                            end
                            
                        end
                    end
                    for name, gui in pairs(billboardGuis) do
                        local plr = Players:FindFirstChild(name)
                        if plr and gui.Parent and isAlive(plr) then
                            UpdateNameTag(plr)
                        end
                    end
                end)
            else
                for _, connection in next, connections do
                    betterDisconnect(connection)
                end
                CleanupAllNameTags()
            end
        end
    })

    mode = nameTags:CreateDropdown({
        Name = "Name Mode",
        List = {"Username", "DisplayName"},
        Default = "Username",
        Function = function(v)
            if nameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    color = nameTags:CreateColorSlider({
        Name = "Name Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if nameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    teamColor = nameTags:CreateToggle({
        Name = "Team Color",
        Default = false,
        Function = function(v)
            if nameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    showHP = nameTags:CreateToggle({
        Name = "Health",
        Default = false,
        Function = function(v)
            if nameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    showDistance = nameTags:CreateToggle({
        Name = "Distance",
        Default = false,
        Function = function(v)
            if nameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })
    
    maxDistance = nameTags:CreateSlider({
        Name = "Max Distance",
        Min = 100,
        Max = 10000,
        Default = 1000,
        Round = 0,
        Function = function(v)
            if nameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })
end)

runFunction(function()
    local rainbowSkin = {Enabled = false}
    local mode = {Value = "FullCharacter"}
    local colorMode = {Value = "Random"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local delay = {Value = 0.1}
    local newColor

    rainbowSkin = Tabs.Render:CreateToggle({
        Name = "RainbowSkin",
        HoverText = "Makes your skin rainbow/random color.",
        Callback = function(callback)
            repeat
                for _, part in next, getCharacter():GetDescendants() do
                    if part:IsA("BasePart") then
                        if mode.Value == "FullCharacter" then
                            part.Color = (colorMode.Value == "Random") and Color3.new(math.random(), math.random(), math.random()) or color.Value
                        else
                            part.Color = (colorMode.Value == "Random") and Color3.new(math.random(), math.random(), math.random()) or color.Value
                        end
                    end
                end
                wait(delay.Value)
            until not rainbowSkin.Enabled
        end
    })

    mode = rainbowSkin:CreateDropdown({
        Name = "Mode",
        List = {"FullCharacter", "PerPart"},
        Default = "PerPart",
        Function = function(v) end
    })

    colorMode = rainbowSkin:CreateDropdown({
        Name = "ColorMode",
        List = {"Random", "Custom"},
        Default = "Random",
        Function = function(v)
            if delay.MainObject then
                delay.MainObject.Visible = v == "Random"
            end
        end
    })

    color = rainbowSkin:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) end
    })

    delay = rainbowSkin:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0.1,
        Max = 5,
        Default = 0.1,
        Round = 1
    })
end)

runFunction(function()
    local soundPlayer = {Enabled = false}
    local mode = {Value = "Random"}
    local sounds = {List = {}}
    local volume = {Value = 1}
    local sound
    local current, max = 1, 1
    local currentID

    soundPlayer = Tabs.Render:CreateToggle({
        Name = "SoundPlayer",
        HoverText = "Plays music.",
        Callback = function(callback)
            repeat
                if mode.Value == "Random" then
                    currentID = #sounds.List > 0 and sounds.List[math.random(1, #sounds.List)] or "142376088"
                elseif mode.Value == "Order" then
                    max = #sounds.List
                    currentID = sounds.List[current] or "142376088"
                    current = current + 1
                    if current > max then current = 1 end
                end
                if currentID and currentID ~= "" then
                    if sound then
                        sound:Stop()
                        sound:Destroy()
                    end

                    sound = Instance.new("Sound")
                    sound.SoundId = tonumber(currentID) and "rbxassetid://" .. currentID or currentID
                    sound.Volume = volume.Value
                    sound.Parent = workspace
                    sound:Play()

                    repeat task.wait() until sound.IsLoaded

                    sound.Ended:Wait()
                end
            until not soundPlayer.Enabled
            if not soundPlayer.Enabled and sound then
                sound:Stop()
                sound:Destroy()
                sound = nil
            end
        end
    })

    mode = soundPlayer:CreateDropdown({
        Name = "Mode",
        List = {"Random", "Order"},
        Default = "Random",
        Function = function(v) end
    })

    sounds = soundPlayer:CreateTextList({
        Name = "Sounds",
        PlaceholderText = "sound id",
        List = {},
        Default = "",
        Function = function(v) end
    })

    volume = soundPlayer:CreateSlider({
        Name = "Volume",
        Function = function(v)
            if sound then
                sound.Volume = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })
end)

runFunction(function()
    local spawnEsp = {Enabled = false}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local fill = {Value = false}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local fillTransparency = {Value = 0}
    local objects = {}
    local connection

    local function addHighlight(obj)
        if obj:FindFirstChild("SpawnESP") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "SpawnESP"
        highlight.Adornee = obj
        highlight.Parent = obj
        highlight.FillColor = fillColor.Value
        highlight.FillTransparency = fill.Value and fillTransparency.Value or 1
        highlight.OutlineColor = outlineColor.Value
        highlight.OutlineTransparency = outline.Value and outlineTransparency.Value or 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(objects, highlight)
    end

    spawnEsp = Tabs.Render:CreateToggle({
        Name = "SpawnESP",
        HoverText = "Highlights every spawn that has 0 transparency.",
        Callback = function(callback)
            if callback then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("SpawnLocation") then
                        addHighlight(obj)
                    end
                end
                connection = workspace.ChildAdded:Connect(function(child)
                    if child:IsA("SpawnLocation") then
                        addHighlight(child)
                    end
                end)
            else
                for _, obj in pairs(objects) do
                    if obj and obj.Parent then
                        obj:Destroy()
                    end
                end
                table.clear(objects)
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    })

    outline = spawnEsp:CreateToggle({
        Name = "Outline",
        Default = true,
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.OutlineTransparency = v and outlineTransparency.Value or 1
                end
            end
            if outlineColor.MainObject then
                outlineColor.MainObject.Visible = v
            end
            if outlineTransparency.MainObject then
                outlineTransparency.MainObject.Visible = v
            end
        end
    })

    outlineColor = spawnEsp:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.OutlineColor = v
                end
            end
        end
    })
    outlineColor.MainObject.Visible = false

    outlineTransparency = spawnEsp:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.OutlineTransparency = outline.Value and v or 1
                end
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.MainObject.Visible = false

    fill = spawnEsp:CreateToggle({
        Name = "Fill",
        Default = false,
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.FillTransparency = v and fillTransparency.Value or 1
                end
            end
            if fillColor.MainObject then
                fillColor.MainObject.Visible = v
            end
            if fillTransparency.MainObject then
                fillTransparency.MainObject.Visible = v
            end
        end
    })

    fillColor = spawnEsp:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.FillColor = v
                end
            end
        end
    })
    fillColor.MainObject.Visible = false

    fillTransparency = spawnEsp:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.FillTransparency = fill.Value and v or 1
                end
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.MainObject.Visible = false
end)


runFunction(function()
    local viewClip = {Enabled = false}
    viewClip = Tabs.Render:CreateToggle({
        Name = "ViewClip",
        HoverText = "Makes your camera go through objects.",
        Callback = function(callback)
            LocalPlayer.DevCameraOcclusionMode = callback and "Invisicam" or "Zoom"
        end
    })
end)

-- // Utility tab
runFunction(function()
    local antiAFK = {Enabled = false}
    local mode = {Value = "AutoClick"}
    local connection
    antiAFK = Tabs.Utility:CreateToggle({
        Name = "AntiAFK",
        HoverText = "Makes you able to idle for inf amount of time,\nAutoClick clicks when you idle.\nDisableConnections disables connections and requires getconnections function.",
        Callback = function(callback) 
            if callback then
                if mode.Value == "AutoClick" then
                connection = localPlayer.Idled:Connect(function()
                    virtualUser:Button2Down(Vector2.new(0, 0))
                    task.wait(0.1)
                    virtualUser:Button2Up(Vector2.new(0, 0))
                end)
                elseif mode.Value == "DisableConnections" then
                    if getconnections then
                        for i,v in next, getconnections(LocalPlayer.Idled) do
                            v:Disable()
                        end
                    else
                        GuiLibrary:CreateNotification("AntiAFK", "Missing getconnections function.", 10, "Error")
                        antiAFK:Toggle(true)
                    end
                end
            else
                if getconnections then
                    for i,v in next, getconnections(LocalPlayer.Idled) do
                        v:Enable()
                    end
                end
            end
        end
    })

    mode = antiAFK:CreateDropdown({
        Name = "Mode",
        List = {"AutoClick", "DisableConnections"},
        Default = "AutoClick",
        Function = function(v) end
    })
end)

runFunction(function()
    local antiFling = {Enabled = false}
    antiFling = Tabs.Utility:CreateToggle({
        Name = "AntiFling",
        HoverText = "Makes people unable to push/fling you.\nDisables collision.",
        Callback = function(callback) 
            if callback then 
                RunLoops:BindToHeartbeat("AntiFling", function()
                    for _, part in next, getCharacter():GetChildren() do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("AntiFling")
                for _, part in next, getCharacter():GetChildren() do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    })
end)


--[[patched but i don't want to remove it
runFunction(function()
    local AutoReportNotifications = {Value = true}

    local ReportTable = {
        ez = "Bullying",
        gay = "Bullying",
        gae = "Bullying",
        hacks = "Scamming",
        hacker = "Scamming",
        hack = "Scamming",
        cheat = "Scamming",
        hecker = "Scamming",
        get = "Scamming",
        ["get a life"] = "Bullying",
        L = "Bullying",
        thuck = "Swearing",
        thuc = "Swearing",
        thuk = "Swearing",
        fatherless = "Bullying",
        yt = "Offsite Links",
        discord = "Offsite Links",
        dizcourde = "Offsite Links",
        retard = "Swearing",
        tiktok = "Offsite Links",
        bad = "Bullying",
        trash = "Bullying",
        die = "Bullying",
        lobby = "Bullying",
        ban = "Bullying",
        youtube = "Offsite Links",
        ["im hacking"] = "Cheating/Exploiting",
        ["I'm hacking"] = "Cheating/Exploiting",
        download = "Offsite Links",
        ["kill your"] = "Bullying",
        kys = "Bullying",
        ["hack to win"] = "Bullying",
        bozo = "Bullying",
        kid = "Bullying",
        adopted = "Bullying",
        vxpe = "Cheating/Exploiting",
        futureclient = "Cheating/Exploiting",
        nova6 = "Cheating/Exploiting",
        [".gg"] = "Offsite Links",
        gg = "Offsite Links",
        lol = "Bullying",
        suck = "Dating",
        love = "Dating",
        fuck = "Swearing",
        sthu = "Swearing",
        ["i hack"] = "Cheating/Exploiting",
        disco = "Offsite Links",
        dc = "Offsite Links",
        toxic = "Bullying",
        loser = "Bullying",
        noob = "Bullying",
        ["you suck"] = "Bullying",
        ["you're bad"] = "Bullying",
        ["your mom"] = "Bullying"
    }

    local function GetReport(Message)
        for word, reportType in pairs(ReportTable) do 
            if Message:lower():find(word) then 
                return reportType
            end
        end
        return nil
    end

    local AutoReport = Tabs.Utility:CreateToggle({
        Name = "AutoReport",
        Keybind = nil,
        Callback = function(Callback)
            if Callback then
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then 
                    TextChatService.MessageReceived:Connect(function(MessageData)
                        if MessageData.TextSource then
                            local Player = Players:GetPlayerByUserId(MessageData.TextSource.UserId)
                            if Player and Player ~= LocalPlayer then
                                local ReportFound = GetReport(MessageData.Text)
                                if ReportFound then
                                    Players:ReportAbuse(Player, ReportFound, "he said a bad word.")
                                    if AutoReportNotifications.Value then
                                        GuiLibrary:CreateNotification("AutoReport", "Reported: " .. Player.Name .. "\nFor: " .. MessageData.Text, 10, false, "warn")
                                    end
                                end
                            end
                        end
                    end)
                else
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player.Name ~= LocalPlayer.Name then
                            Player.Chatted:connect(function(Message)
                                local ReportFound = GetReport(Message)
                                if ReportFound then
                                    Players:ReportAbuse(Player, ReportFound, "he said a bad word.")
                                    if AutoReportNotifications.Value then
                                        GuiLibrary:CreateNotification("AutoReport", "Reported: " .. Player.Name .. "\nFor: " .. Message, 10, false, "warn")
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    })

    AutoReportNotifications = AutoReport:CreateToggle({
        Name = "Notifications",
        Default = true,
        Function = function() end
    })
end)
]]

runFunction(function()
    local antiKick = {Enabled = false}
	local first = false
    local oldNameCall
    antiKick = Tabs.Utility:CreateToggle({
        Name = "AntiKick",
        HoverText = "Removes client sided kicks.\nRequires hookmetamethod function.",
        Callback = function(callback) 
            if callback then
                if hookmetamethod then
                    oldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
                        local NameCallMethod = getnamecallmethod()
        
                        if tostring(string.lower(NameCallMethod)) == "kick" and callback and not first then
                            GuiLibrary:CreateNotification("AntiKick", "Detected kick attempt.", 7, "Warning")
                            return nil
                        end
        
                        return oldNameCall(Self, ...)
                    end)
                    if not first then
                        first = true
                    end
                else
                    GuiLibrary:CreateNotification("AntiKick", "Missing hookmetamethod function.", 10, "Error")
                    antiKick:Toggle(true)
                    return
                end
            end
        end
    })
end)

--[[doesn't work, 2 days of work in nothing :sob:
runFunction(function()
    local Mode = {Value = "Toggle"}
    local Radius = {Value = 10}
    local Delay = {Value = 1}
    local AutoClickDetector = Tabs.Utility:CreateToggle({
        Name = "AutoClickDetector",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                if fireclickdetector then
                    if Mode.Value == "Toggle" then
                        RunLoops:BindToHeartbeat("AutoClickDetector", function(Delta)
                            local NearClickDetectors = GetNearInstances(Radius.Value, LocalPlayer, "ClickDetector")

                            if NearClickDetectors and NearClickDetectors[1] then
                                for _, ClickDetector in pairs(NearClickDetectors) do
                                    fireclickdetector(ClickDetector)
                                end
                            end
                        end)
                    elseif Mode.Value == "Button" then
                        local NearClickDetectors = GetNearInstances()

                        if NearClickDetectors and NearClickDetectors[1] then
                            for _, ClickDetector in pairs(NearClickDetectors) do
                                fireclickdetector(ClickDetector)
                            end
                        end
                    end
                else
                    GuiLibrary:CreateNotification("AutoClickDetector", "Missing fireclickdetector function.", 10, false)
                    AntiKick:Toggle(true)
                    return
                end
            else
                RunLoops:UnbindFromHeartbeat("AutoClickDetector")
            end
        end
    })

    local Mode = AutoClickDetector:CreateDropdown({
        Name = "Mode",
        List = {"Toggle", "Button"},
        Default = "Toggle",
        Callback = function(v) end
    })

    local Delay = AutoClickDetector:CreateSlider({
        Name = "Delay (seconds)",
        Function = function(v) end,
        Min = 0,
        Max = 5,
        Default = 0.1,
        Round = 1
    })

    local Radius = AutoClickDetector:CreateSlider({
        Name = "Radius (studs)",
        Function = function(v) end,
        Min = 0,
        Max = 500,
        Default = 10,
        Round = 0
    })
end)
]]

runFunction(function()
    local autoRejoin = {Enabled = false}
    local delay = {Value = 5}
    local sameServer = {Value = false}
    autoRejoin = Tabs.Utility:CreateToggle({
        Name = "AutoRejoin",
        HoverText = "Automatically rejoins when you get kicked for idling.",
        Callback = function(callback) 
            if callback then 
                repeat wait(delay.Value) until autoRejoin.Enabled == false or #CoreGui.RobloxPromptGui.promptOverlay:GetChildren() ~= 0
                if autoRejoin.Enabled and sameServer then 
                    if #Players:GetPlayers() <= 1 then
                        localPlayer:Kick("\nRejoining...")
                        task.wait()
                        teleportService:Teleport(PlaceId, localPlayer)
                    else
                        teleportService:TeleportToPlaceInstance(PlaceId, JobId, localPlayer)
                    end
                else
                    if #Players:GetPlayers() <= 1 then
                        localPlayer:Kick("\nRejoining...")
                        task.wait()
                        teleportService:Teleport(PlaceId, localPlayer)
                    end
                end
            end
        end
    })

    delay = autoRejoin:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0,
        Max = 60,
        Default = 5,
        Round = 0
    })

    sameServer = autoRejoin:CreateToggle({
        Name = "SameServer",
        Default = true,
        Function = function() end
    })
end)

runFunction(function()
    local cameraUnlock = {Enabled = false}
    local oldZoomDistance
    cameraUnlock = Tabs.Utility:CreateToggle({
        Name = "CameraUnlock",
        HoverText = "Makes you able to zoom out your camera very far.",
        Callback = function(callback)
            if callback then
                oldZoomDistance = localPlayer.CameraMaxZoomDistance
                localPlayer.CameraMaxZoomDistance = 99999999
            else
                localPlayer.CameraMaxZoomDistance = oldZoomDistance
            end
        end
    })
end)

-- roblox removed old chat, rip
runFunction(function()
    local chatSpammer = {Enabled = false}
    local mode = {Value = "Random"}
    local spamMessages = {List = {}}
    local delay = {Value = 1}
    local hideFloodMessage = {Value = false}
    local connection, max, current = nil, 0, 1
    chatSpammer = Tabs.Utility:CreateToggle({
        Name = "ChatSpammer",
        HoverText = "Automatically sends messages in chat.",
        Callback = function(callback) 
            if callback then
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    repeat
                        local msg
                        if mode.Value == "Random" then
                            if #spamMessages.List == 0 then
                                msg = "Hello world!"
                            else
                                msg = spamMessages.List[math.random(1, #spamMessages.List)]
                            end
                        elseif mode.Value == "Order" then
                            max = #spamMessages.List
                            if #spamMessages.List == 0 then
                                msg = "Hello world!"
                            end
                            if spamMessages.List[current] then
                                msg = spamMessages.List[current]
                                current = current + 1
                                if current > max then
                                    current = 1
                                end
                            else
                                current = 1
                            end
                        end
                        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
                        wait(delay.Value)
                    until not chatSpammer.Enabled
                end
                if hideFloodMessage.Value then
                    local ExperienceChat = CoreGui:FindFirstChild("ExperienceChat")
                    if ExperienceChat then
                        local RCTScrollContentView = ExperienceChat:FindFirstChild("RCTScrollContentView")
                        if RCTScrollContentView then
                            connection = RCTScrollContentView.ChildAdded:Connect(function(msg)
                                if msg.ContentText == "You must wait before sending another message." then
                                    msg.Visible = false
                                end
                            end)
                        end
                    end
                end
            else
                if connection then
                    connection:Disconnect()
                end
            end
        end
    })

    mode = chatSpammer:CreateDropdown({
        Name = "Mode",
        List = {"Random", "Order"},
        Default = "Random",
        Callback = function(v) end
    })

    spamMessages = chatSpammer:CreateTextList({
        Name = "SpamMessages",
        PlaceholderText = "Messages to spam",
        DefaultList = {},
        Function = function(v) end,
    })

    delay = chatSpammer:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0,
        Max = 10,
        Default = 1,
        Round = 1
    })

    hideFloodMessage = chatSpammer:CreateToggle({
        Name = "HideFloodMessage",
        Default = false,
        Function = function(callback) end
    })
end)

-- // i hate this
if Animate and CheckForAllAnimateParams(Animate) == true then
    runFunction(function()
        local customAnimations = {Enabled = false}
        local idleAnimation1 = {Value = ""}
        local idleAnimation2 = {Value = ""}
        local walkAnimation = {Value = ""}
        local runAnimation = {Value = ""}
        local jumpAnimation = {Value = ""}
        local fallAnimation = {Value = ""}
        local climbAnimation = {Value = ""}
        local swimIdleAnimation = {Value = ""}
        local swimAnimation = {Value = ""}
        local oldAnimations = {
            IdleAnimation1 = Animate.idle.Animation1.AnimationId,
            IdleAnimation2 = Animate.idle.Animation2.AnimationId,
            WalkAnimation = Animate.walk.WalkAnim.AnimationId,
            RunAnimation = Animate.run.RunAnim.AnimationId,
            JumpAnimation = Animate.jump.JumpAnim.AnimationId,
            FallAnimation = Animate.fall.FallAnim.AnimationId,
            ClimbAnimation = Animate.climb.ClimbAnim.AnimationId,
            SwimIdleAnimation = Animate.swimidle.SwimIdle.AnimationId,
            SwimAnimation = Animate.swim.Swim.AnimationId
        }
        customAnimations = Tabs.Utility:CreateToggle({
            Name = "CustomAnimations",
            HoverText = "Customizes your animations.",
            Callback = function(callback) 
                if callback then 
                    Animate.idle.Animation1.AnimationId = tonumber(idleAnimation1.Value) and "http://www.roblox.com/asset/?id=" .. idleAnimation1.Value or idleAnimation1.Value
                    Animate.idle.Animation2.AnimationId = tonumber(idleAnimation2.Value) and "http://www.roblox.com/asset/?id=" .. idleAnimation2.Value or idleAnimation2.Value
                    Animate.walk.WalkAnim.AnimationId = tonumber(walkAnimation.Value) and "http://www.roblox.com/asset/?id=" .. walkAnimation.Value or walkAnimation.Value
                    Animate.run.RunAnim.AnimationId = tonumber(runAnimation.Value) and "http://www.roblox.com/asset/?id=" .. runAnimation.Value or runAnimation.Value
                    Animate.jump.JumpAnim.AnimationId = tonumber(jumpAnimation.Value) and "http://www.roblox.com/asset/?id=" .. jumpAnimation.Value or jumpAnimation.Value
                    Animate.fall.FallAnim.AnimationId = tonumber(fallAnimation.Value) and "http://www.roblox.com/asset/?id=" .. fallAnimation.Value or fallAnimation.Value
                    Animate.climb.ClimbAnim.AnimationId = tonumber(climbAnimation.Value) and "http://www.roblox.com/asset/?id=" .. climbAnimation.Value or climbAnimation.Value
                    Animate.swimidle.SwimIdle.AnimationId = tonumber(swimIdleAnimation.Value) and "http://www.roblox.com/asset/?id=" .. swimIdleAnimation.Value or swimIdleAnimation.Value
                    Animate.swim.Swim.AnimationId = tonumber(swimAnimation.Value) and "http://www.roblox.com/asset/?id=" .. swimAnimation.Value or swimAnimation.Value
                else
                    Animate.idle.Animation1.AnimationId = oldAnimations.IdleAnimation1
                    Animate.idle.Animation2.AnimationId = oldAnimations.IdleAnimation2
                    Animate.walk.WalkAnim.AnimationId = oldAnimations.WalkAnimation
                    Animate.run.RunAnim.AnimationId = oldAnimations.RunAnimation
                    Animate.jump.JumpAnim.AnimationId = oldAnimations.JumpAnimation
                    Animate.fall.FallAnim.AnimationId = oldAnimations.FallAnimation
                    Animate.climb.ClimbAnim.AnimationId = oldAnimations.ClimbAnimation
                    Animate.swimidle.SwimIdle.AnimationId = oldAnimations.SwimIdleAnimation
                    Animate.swim.Swim.AnimationId = oldAnimations.SwimAnimation
                end
            end
        })

        idleAnimation1 = customAnimations:CreateTextBox({
            Name = "IdleAnimation1",
            PlaceholderText = "Idle Animation1 ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        idleAnimation2 = customAnimations:CreateTextBox({
            Name = "IdleAnimation2",
            PlaceholderText = "Idle Animation1 ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        walkAnimation = customAnimations:CreateTextBox({
            Name = "WalkAnimation",
            PlaceholderText = "Walk Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        runAnimation = customAnimations:CreateTextBox({
            Name = "RunAnimation",
            PlaceholderText = "Run Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        jumpAnimation = customAnimations:CreateTextBox({
            Name = "JumpAnimation",
            PlaceholderText = "Jump Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        fallAnimation = customAnimations:CreateTextBox({
            Name = "FallAnimation",
            PlaceholderText = "Fall Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        climbAnimation = customAnimations:CreateTextBox({
            Name = "ClimbAnimation",
            PlaceholderText = "Climb Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        swimIdleAnimation = customAnimations:CreateTextBox({
            Name = "SwimIdleAnimation",
            PlaceholderText = "Swim Idle Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        swimAnimation = customAnimations:CreateTextBox({
            Name = "SwimAnimation",
            PlaceholderText = "Swim Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })
    end)
end

runFunction(function()
    local consoleCommands = {Enabled = false}
    local commandbar
    local connection
    consoleCommands = Tabs.Utility:CreateToggle({
        Name = "ConsoleCommands",
        HoverText = "Creates a command bar in dev console.",
        Callback = function(callback)
            if callback then
                commandbar = Instance.new("Frame")
                local inputField = Instance.new("Frame")
                local textBox = Instance.new("TextBox")
                local arrow = Instance.new("TextLabel")

                commandbar.Name = "commandbar"
                commandbar.BackgroundColor3 = Color3.fromRGB(45.00000111758709, 45.00000111758709, 45.00000111758709)
                commandbar.BorderColor3 = Color3.fromRGB(184.00000423192978, 184.00000423192978, 184.00000423192978)
                commandbar.Position = UDim2.new(0, 0, 1, -30)
                commandbar.Size = UDim2.new(1, 0, 0, 30)
                commandbar.Parent = CoreGui.DevConsoleMaster.DevConsoleWindow

                inputField.Name = "inputfield"
                inputField.BackgroundTransparency = 1
                inputField.ClipsDescendants = true
                inputField.Position = UDim2.new(0, 30, 0, 0)
                inputField.Size = UDim2.new(1, -30, 0, 30)
                inputField.Parent = commandbar

                textBox.BackgroundTransparency = 1
                textBox.ClearTextOnFocus = false
                textBox.Font = Enum.Font.Code
                textBox.PlaceholderText = "command line"
                textBox.Text = ""
                textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textBox.TextSize = 15
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Size = UDim2.new(1, 0, 1, 0)
                textBox.Parent = inputField
                textBox.ZIndex = 50

                arrow.Name = "arrow"
                arrow.BackgroundTransparency = 1
                arrow.Font = Enum.Font.Code
                arrow.Text = "> "
                arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
                arrow.TextSize = 15
                arrow.TextXAlignment = Enum.TextXAlignment.Right
                arrow.Size = UDim2.new(0, 30, 1, 0)
                arrow.Parent = commandbar

                connection = table.insert(connections, textBox.FocusLost:Connect(function(enterpressed)
                    if enterpressed then
                        local suc, res = pcall(function()
                            loadstring(textBox.Text)()
                        end)
                        if not suc then
                            error(res)
                        end
                        textBox.Text = ""
                    end
                end))
            else
                commandbar:Destroy()
                betterDisconnect(connection)
            end
        end
    })
end)

--[[this doesn't work
runFunction(function()
    local godMode = {Enabled = false}
    local mode = {Value = "Heal"}
    local healthThreshold = {Value = 100}
    local connection
    local notificationCooldown = 0
    local lastNotificationTime = 0
    local isInitialized = false
    local retryAttempts = 0
    local maxRetryAttempts = 5
    local retryDelay = 2
    local originalJumpPower
    local originalWalkSpeed
    local originalHealth
    local originalMaxHealth
    local damageHistory = {}
    local damageProtection = {active = false, cooldown = 0}
    
    local function cleanupConnections()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
    
    local function restoreOriginalValues(humanoid)
        if originalJumpPower and humanoid then
            humanoid.JumpPower = originalJumpPower
        end
        
        if originalWalkSpeed and humanoid then
            humanoid.WalkSpeed = originalWalkSpeed
        end
        
        if originalHealth and humanoid then
            humanoid.Health = originalHealth
        end
        
        if originalMaxHealth and humanoid then
            humanoid.MaxHealth = originalMaxHealth
        end
    end
    
    local function showNotification(title, message, duration)
        local currentTime = tick()
        if currentTime - lastNotificationTime >= notificationCooldown then
            GuiLibrary:CreateNotification(title, message, duration or 3)
            lastNotificationTime = currentTime
            notificationCooldown = duration or 3
        end
    end
    
    local function initializeGodMode(character, humanoid, hrp)
        if not character or not humanoid or not hrp then return false end
        
        originalJumpPower = humanoid.JumpPower
        originalWalkSpeed = humanoid.WalkSpeed
        originalHealth = humanoid.Health
        originalMaxHealth = humanoid.MaxHealth
        
        isInitialized = true
        retryAttempts = 0
        
        return true
    end
    
    local function applyHealMode(humanoid)
        if not connection then
            connection = humanoid.GetPropertyChangedSignal("Health"):Connect(function()
                local targetHealth = healthThreshold.Value
                
                if humanoid.Health < targetHealth then
                    table.insert(damageHistory, {
                        time = tick(),
                        oldHealth = humanoid.Health,
                        damage = originalHealth - humanoid.Health
                    })
                    
                    if #damageHistory > 10 then
                        table.remove(damageHistory, 1)
                    end
                    
                    if not damageProtection.active then
                        damageProtection.active = true
                        damageProtection.cooldown = tick() + 0.5
                        humanoid.Health = targetHealth
                    end
                    
                    if tick() > damageProtection.cooldown then
                        damageProtection.active = false
                    end
                end
            end)
        end
    end
    
    local function applyHRPMode(character, hrp)
        cleanupConnections()
        
        if hrp then
            local clone = hrp:Clone()
            clone.Transparency = 1
            clone.CanCollide = false
            
            local weld = Instance.new("Weld")
            weld.Part0 = hrp
            weld.Part1 = clone
            weld.C0 = CFrame.new()
            weld.C1 = CFrame.new()
            weld.Parent = hrp
            
            hrp.CanCollide = false
            hrp.Transparency = 1
            
            clone.Parent = character
            hrp.Name = "RealHRP"
            clone.Name = "HumanoidRootPart"
        end
    end
    
    local function applyAntiKnockbackMode(character, humanoid)
        cleanupConnections()
        
        if humanoid then
            humanoid.StateChanged:Connect(function(oldState, newState)
                if newState == Enum.HumanoidStateType.Ragdoll or 
                   newState == Enum.HumanoidStateType.FallingDown then
                    task.wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
            
            if humanoid.RigType == Enum.HumanoidRigType.R6 then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0, 0)
                    end
                end
            else
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("MeshPart") and part.Name ~= "HumanoidRootPart" then
                        part.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0, 0)
                    end
                end
            end
        end
    end
    
    local function applyInvulnerabilityMode(character, humanoid)
        cleanupConnections()
        
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            connection = humanoid.GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < math.huge then
                    humanoid.Health = math.huge
                end
            end)
        end
    end
    
    godMode = Tabs.Utility:CreateToggle({
        Name = "GodMode",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("GodMode", function()
                    if isAlive(LocalPlayer, false) then
                        local Character = LocalPlayer.Character
                        local Humanoid = Character.Humanoid
                        local HumanoidRootPart = Character.HumanoidRootPart
                        
                        if not isInitialized then
                            if not initializeGodMode(Character, Humanoid, HumanoidRootPart) then
                                retryAttempts = retryAttempts + 1
                                if retryAttempts >= maxRetryAttempts then
                                    showNotification("GodMode", "Failed to initialize after multiple attempts. Please try again.", 5)
                                    godMode:Toggle(false)
                                    return
                                end
                                showNotification("GodMode", "Initializing... Attempt " .. retryAttempts .. "/" .. maxRetryAttempts, 1)
                                task.wait(retryDelay)
                                return
                            end
                            showNotification("GodMode", "Successfully initialized!", 2)
                        end
                        
                        if mode.Value == "Heal" then
                            applyHealMode(Humanoid)
                        elseif mode.Value == "HRP" then
                            applyHRPMode(Character, HumanoidRootPart)
                        elseif mode.Value == "AntiKnockback" then
                            applyAntiKnockbackMode(Character, Humanoid)
                        elseif mode.Value == "Invulnerability" then
                            applyInvulnerabilityMode(Character, Humanoid)
                        end
                    else
                        isInitialized = false
                        cleanupConnections()
                        if retryAttempts < maxRetryAttempts then
                            retryAttempts = retryAttempts + 1
                            showNotification("GodMode", "Character not found. Retrying... (" .. retryAttempts .. "/" .. maxRetryAttempts .. ")", 2)
                            task.wait(retryDelay)
                        else
                            showNotification("GodMode", "Unable to find character after multiple attempts. Please try again.", 5)
                            godMode:SetState(false)
                        end
                    end
                end)
            else
                isInitialized = false
                retryAttempts = 0
                cleanupConnections()
                RunLoops:UnbindFromHeartbeat("GodMode")
                
                if isAlive(LocalPlayer, false) then
                    local Character = LocalPlayer.Character
                    local Humanoid = Character.Humanoid
                    
                    restoreOriginalValues(Humanoid)
                    
                    if mode.Value == "HRP" then
                        local realHRP = Character:FindFirstChild("RealHRP")
                        local fakeHRP = Character:FindFirstChild("HumanoidRootPart")
                        
                        if realHRP and fakeHRP then
                            realHRP.Name = "HumanoidRootPart"
                            realHRP.Transparency = 0
                            realHRP.CanCollide = true
                            fakeHRP:Destroy()
                        end
                    end
                end
                
                showNotification("GodMode", "Disabled", 2)
            end
        end
    })

    mode = godMode:CreateDropdown({
        Name = "Mode",
        List = {"Heal", "HRP", "AntiKnockback", "Invulnerability"},
        Default = "Heal",
        Function = function(v)
            if godMode.Enabled then
                isInitialized = false
                cleanupConnections()
                showNotification("GodMode", "Mode changed to " .. v .. ". Reinitializing...", 2)
            end
        end
    })
    
    healthThreshold = godMode:CreateSlider({
        Name = "Health Threshold",
        Min = 1,
        Max = 200,
        Default = 100,
        Round = 0,
        Function = function(val) 
            if mode.Value == "Heal" and godMode.Enabled and connection then
                cleanupConnections()
                
                if isAlive(LocalPlayer, false, true) then
                    local Humanoid = LocalPlayer.Character.Humanoid
                    applyHealMode(Humanoid)
                end
            end
        end
    })
end)
]]

runFunction(function()
    local fastProximityPrompts = {Enabled = false}
    local duration = {Value = 0.1}
    local objects = {}
    fastProximityPrompts = Tabs.Utility:CreateToggle({
        Name = "FastProximityPrompts",
        HoverText = "Makes you able to customize proximity prompt hold duration.",
        Callback = function(callback)
            if callback then
                for _, ProximityObject in pairs(workspace:GetDescendants()) do
                    if ProximityObject:IsA("ProximityPrompt") then
                        objects[ProximityObject] = ProximityObject.HoldDuration
                        ProximityObject.HoldDuration = duration.Value
                    end
                end
            else
                for ProximityObject, OriginalHoldDuration in pairs(objects) do
                    if ProximityObject:IsA("ProximityPrompt") then
                        ProximityObject.HoldDuration = OriginalHoldDuration
                    end
                end
                table.clear(objects)
            end
        end
    })

    duration = fastProximityPrompts:CreateSlider({
        Name = "HoldDuration",
        Function = function(v)
            if fastProximityPrompts.Enabled then
                for _, Object in pairs(workspace:GetDescendants()) do
                    if Object:IsA("ProximityPrompt") then
                        Object.HoldDuration = duration.Value
                    end
                end
            end
        end,
        Min = 0,
        Max = 10,
        Default = 0,
        Round = 1
    })
end)

runFunction(function()
    local fpsUnlocker = {Enabled = false}
    fpsUnlocker = Tabs.Utility:CreateToggle({
        Name = "FPSUnlocker",
        HoverText = "Unlocks your FPS.",
        Callback = function(callback)
            if callback then
                if setfpscap then
                    setfpscap(10000000)
                else
                    GuiLibrary:CreateNotification("FPSUnlocker", "Missing setfpscap function.", 10, "Error")
                    fpsUnlocker:Toggle(true)
                    return
                end
            end
        end
    })
end)

runFunction(function()
    local infiniteJump = {Enabled = false}
    local connection
    infiniteJump = Tabs.Utility:CreateToggle({
        Name = "InfinityJump",
        HoverText  = "Allows you to jump infinitely.",
        Callback = function(callback) 
            if callback then 
                connection = UserInputService.JumpRequest:Connect(function()
                    if callback then
                        getHumanoid():ChangeState(3)
                    end
                end)
            else
                betterDisconnect(connection)
            end
        end
    })
end)

--[[
runFunction(function()
    Noclip = Tabs.Utility:CreateToggle({
        Name = "Noclip",
        Keybind = nil,
        Callback = function(callback) 
            if callback then
                if isAlive() then 
                    LocalPlayer.Character.Humanoid:ChangeState(11)
                else
                    LocalPlayer.Character.Humanoid:ChangeState(5)
                end
            else
                warn("[ManaV2ForRoblox]: LocalPlayer is not alive.")
            end
        end
    })
end)
]]

runFunction(function()
    local rejoin = {Enabled = false}
    rejoin = Tabs.Utility:CreateToggle({
        Name = "Rejoin",
        HoverText = "Rejoins the same game to the same server.",
        Callback = function(callback) 
            if callback then 
                rejoin:Toggle(false, false)
                teleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
            end
        end
    })
end)

runFunction(function()
    local serverHop = {Enabled = false}
    serverHop = Tabs.Utility:CreateToggle({
        Name = "ServerHop",
        HoverText = "Joins the same game but to the different server.",
        Callback = function(callback) 
            if callback then 
                serverHop:Toggle(false, false)
                teleportService:Teleport(PlaceId)
            end
        end
    })
end)

-- World tab
runFunction(function()
    local antiVoid = {Enabled = false}
    local mode = {Value = "Jump"}
    local delay = {Value = 0.1}
    local bounceForce = {Value = 150}
    local tpToSpawnLocation = {Value = false}
    local LastSafePosition = nil
    local IsBeingRescued = false
    local AntiVoidPlatform = nil
    local voidYpos = -200
    local oldjumppower
    local connection

    local function isOnGround()
        if not isAlive() then return false end
        
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then return false end
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local result = workspace:Raycast(
            rootPart.Position,
            Vector3.new(0, -10, 0),
            rayParams
        )
        
        return result ~= nil and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
    end
    
    local function savePosition()
        if not isAlive() or not isOnGround() then return end
        
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        LastSafePosition = rootPart.CFrame
    end
    
    local function RescueFromVoid()
        local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        oldjumppower = Humanoid.JumpPower
        if not isAlive() or IsBeingRescued then return end
        
        if RootPart.Position.Y <= voidYpos then
            IsBeingRescued = true
            
            if mode.Value == "Jump" and AntiVoidPlatform then
                AntiVoidPlatform.CFrame = CFrame.new(RootPart.Position.X, voidYpos, RootPart.Position.Z)
                
                Humanoid.JumpPower = bounceForce.Value
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            else
                if LastSafePosition then
                    RootPart.CFrame = LastSafePosition
                    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                else
                    local spawnLocation = nil
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("SpawnLocation") and obj.Enabled then
                            spawnLocation = obj
                            break
                        end
                    end
                    
                    if spawnLocation and tpToSpawnLocation.Value then
                        RootPart.CFrame = spawnLocation.CFrame * CFrame.new(0, 5, 0)
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    else
                        RootPart.CFrame = CFrame.new(RootPart.Position.X, math.abs(voidYpos), RootPart.Position.Z)
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
            
            task.delay(delay.Value, function()
                Humanoid.JumpPower = oldjumppower
                IsBeingRescued = false
            end)
        end
    end

    antiVoid = Tabs.World:CreateToggle({
        Name = "AntiVoid",
        HoverText = "Makes you unable to fall into the void.",
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AntiVoid", function()
                    if mode.Value == "Jump" then
                        if not AntiVoidPlatform then
                            AntiVoidPlatform = Instance.new("Part")
                            AntiVoidPlatform.Name = "AntiVoidPlatform"
                            AntiVoidPlatform.Size = Vector3.new(400, 1, 400)
                            AntiVoidPlatform.Anchored = true
                            AntiVoidPlatform.CanCollide = true
                            AntiVoidPlatform.Transparency = 1
                            AntiVoidPlatform.Parent = workspace
                        end
                    end
                end)
                connection = RunService.Stepped:Connect(function(deltaTime)
                    local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if antiVoid.Enabled then
                        savePosition(deltaTime)
                        RescueFromVoid()
                        
                        if mode.Value == "Jump" and AntiVoidPlatform and RootPart and RootPart.Position.Y > (voidYpos + math.abs(voidYpos)) then
                            AntiVoidPlatform.CFrame = CFrame.new(RootPart.Position.X, voidYpos - 50, RootPart.Position.Z)
                        end
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AntiVoid")
                if AntiVoidPlatform then
                    AntiVoidPlatform:Destroy()
                end
                betterDisconnect(connection)
            end
        end
    })

    mode = antiVoid:CreateDropdown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Jump", "Teleport"},
        Default = "Jump"
    })

    delay = antiVoid:CreateSlider({
        Name = "PosCheckDelay",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0.1,
        Round = 1
    })

    bounceForce = antiVoid:CreateSlider({
        Name = "Bounce Force",
        Function = function(v) end,
        Min = 0,
        Max = 500,
        Default = 150,
        Round = 0
    })

    tpToSpawnLocation = antiVoid:CreateToggle({
        Name = "TP to Spawn Location",
        Default = false,
        Function = function(v) end
    })
end)

runFunction(function()
    local atmosphereModule = {Enabled = false}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local decay = {Value = Color3.fromRGB(255, 255, 255)}
    local density = {Value = 0.5}
    local glare = {Value = 0.5}
    local haze = {Value = 0.5}
    local offset = {Value = 0.5}
    local atmosphere
    local old = {}

    atmosphereModule = Tabs.World:CreateToggle({
        Name = "Atmopshere",
        HoverText = "Customizes the atmosphere of the game.",
        Callback = function(callback)
            if callback then
                for i, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then
                        table.insert(old, v)
                        v.Parent = game
                    end
                end
                atmosphere = Instance.new("Atmosphere")
                atmosphere.Color = color.Value
                atmosphere.Decay = decay.Value
                atmosphere.Density = density.Value
                atmosphere.Glare = glare.Value
                atmosphere.Haze = haze.Value
                atmosphere.Offset = offset.Value
                atmosphere.Parent = Lighting

                Lighting.LightingChanged:Connect(function()
                    if Lighting:FindFirstChild("Atmosphere") then
                        local atmosphere = Lighting:FindFirstChild("Atmosphere")
                        atmosphere.Color = color.Value
                        atmosphere.Decay = decay.Value
                        atmosphere.Density = density.Value
                        atmosphere.Glare = glare.Value
                        atmosphere.Haze = haze.Value
                        atmosphere.Offset = offset.Value
                    else
                        atmosphere = Instance.new("Atmosphere")
                        atmosphere.Color = color.Value
                        atmosphere.Decay = decay.Value
                        atmosphere.Density = density.Value
                        atmosphere.Glare = glare.Value
                        atmosphere.Haze = haze.Value
                        atmosphere.Offset = offset.Value
                        atmosphere.Parent = Lighting
                    end
                end)
            else
                if atmosphere then
                    atmosphere:Destroy()
                end
                for i, v in pairs(old) do
                    v.Parent = Lighting
                end
                table.clear(old)
            end
        end
    })

    color = atmosphereModule:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if atmosphere then
                atmosphere.Color = v
            end
        end
    })

    decay = atmosphereModule:CreateColorSlider({
        Name = "Decay",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v)
            if atmosphere then
                atmosphere.Decay = v
            end
        end
    })

    density = atmosphereModule:CreateSlider({
        Name = "Density",
        Function = function(v)
            if atmosphere then
                atmosphere.Density = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 3
    })

    glare = atmosphereModule:CreateSlider({
        Name = "Glare",
        Function = function(v)
            if atmosphere then
                atmosphere.Glare = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 5,
        Round = 2
    })

    haze = atmosphereModule:CreateSlider({
        Name = "Haze",
        Function = function(v)
            if atmosphere then
                atmosphere.Haze = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 5,
        Round = 2
    })

    offset = atmosphereModule:CreateSlider({
        Name = "Offset",
        Function = function(v)
            if atmosphere then
                atmosphere.Offset = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 3
    })
end)

runFunction(function()
    local gravity = {Enabled = false}
    local value = {Value = 18}
    local oldGravity
    gravity = Tabs.World:CreateToggle({
        Name = "Gravity",
        HoverText = "Changes the game gravity.",
        Callback = function(callback)
            if callback then
                oldGravity = workspace.Gravity
                workspace.Gravity = value.Value
            else
                workspace.Gravity = oldGravity
            end
        end
    })
    
    value = gravity:CreateSlider({
        Name = "Gravity",
        Function = function(v)
            if gravity.Enabled then
                workspace.Gravity = v
            end
        end,
        Min = 1,
        Max = 200,
        Default = 196,
        Round = 0
    })
end)

runFunction(function()
    local customLighting = {Enabled = false}
    local oldLighting = {
        ShadowSoftness = Lighting.ShadowSoftness,
        Brightness = Lighting.Brightness
    }
    local shadowSoftness = {Value = 1}
    local brightness = {Value = 1}
    local sunRaysIntensity = {Value = 1}
    local spread = {Value = 1}
    local bloomIntensity = {Value = 1}
    local bloomSize = {Value = 1}
    local bloomObject
    local sunRaysObject
    local oldLightingObjects = {}
    local connection
    customLighting = Tabs.World:CreateToggle({
        Name = "Lighting",
        HoverText = "Customizes the lighting of the game.",
        Callback = function(callback)
            if callback then
                Lighting.ShadowSoftness = shadowSoftness.Value
                Lighting.Brightness = brightness.Value
                for i,v in pairs(Lighting:GetChildren()) do
					if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
						table.insert(oldLightingObjects, v)
						v.Parent = game
					end
				end
                bloomObject = Instance.new("BloomEffect")
                bloomObject.Name = "BloomObject"
                bloomObject.Parent = Lighting
                bloomObject.Intensity = bloomIntensity.Value
                bloomObject.Size = bloomSize.Value
                
                sunRaysObject = Instance.new("SunRaysEffect")
                sunRaysObject.Name = "SunRaysObject"
                sunRaysObject.Parent = Lighting
                sunRaysObject.Intensity = sunRaysIntensity.Value
                sunRaysObject.Spread = spread.Value

                connection = Lighting.LightingChanged:Connect(function()
                    if Lighting:FindFirstChild("BloomObject") then
                        local BloomObject = Lighting:FindFirstChild("BloomObject")
                        BloomObject.Parent = Lighting
                        BloomObject.Intensity = bloomIntensity.Value
                        BloomObject.Size = bloomSize.Value
                    else
                        bloomObject = Instance.new("BloomEffect")
                        bloomObject.Name = "BloomObject"
                        bloomObject.Parent = Lighting
                        bloomObject.Intensity = bloomIntensity.Value
                        bloomObject.Size = bloomSize.Value
                    end

                    if Lighting:FindFirstChild("SunRaysObject") then
                        local sunRaysObject = Lighting:FindFirstChild("SunRaysObject")
                        sunRaysObject = Instance.new("SunRaysEffect")
                        sunRaysObject.Name = "SunRaysObject"
                        sunRaysObject.Parent = Lighting
                        sunRaysObject.Intensity = sunRaysIntensity.Value
                        sunRaysObject.Spread = spread.Value
                    else
                        sunRaysObject = Instance.new("SunRaysEffect")
                        sunRaysObject.Name = "SunRaysObject"
                        sunRaysObject.Parent = Lighting
                        sunRaysObject.Intensity = sunRaysIntensity.Value
                        sunRaysObject.Spread = spread.Value
                    end
                end)
            else
                connection:Disconnect()
                Lighting.ShadowSoftness = oldLighting.ShadowSoftness
                Lighting.Brightness = oldLighting.Brightness
                if bloomObject then bloomObject:Destroy() end
                if sunRaysObject then sunRaysObject:Destroy() end
				for i,v in pairs(oldLightingObjects) do
					v.Parent = Lighting
				end
				table.clear(oldLightingObjects)
            end
        end
    })

    shadowSoftness = customLighting:CreateSlider({
        Name = "ShadowSoftness",
        Function = function(v) 
            if customLighting.Enabled then
                Lighting.ShadowSoftness = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 1
    })

    brightness = customLighting:CreateSlider({
        Name = "Brightness",
        Function = function(v) 
            if customLighting.Enabled then
                Lighting.Brightness = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 3,
        Round = 1
    })

    sunRaysIntensity = customLighting:CreateSlider({
        Name = "SunRays Intensity",
        Function = function(v) 
            if customLighting.Enabled then
                sunRaysObject.Intensity = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })

    spread = customLighting:CreateSlider({
        Name = "SunRays Spread",
        Function = function(v) 
            if customLighting.Enabled then
                sunRaysObject.Spread = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })

    bloomIntensity = customLighting:CreateSlider({
        Name = "Bloom Intensity",
        Function = function(v) 
            if customLighting.Enabled then
                bloomObject.Intensity = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 2
    })

    bloomSize = customLighting:CreateSlider({
        Name = "Bloom Intensity",
        Function = function(v) 
            if customLighting.Enabled then
                bloomObject.Size = v
            end
        end,
        Min = 0,
        Max = 56,
        Default = 56,
        Round = 0
    })
end)

runFunction(function()
    local customSky = {Enabled = false}
    local up = {Value = ""}
    local down = {Value = ""}
    local left = {Value = ""}
    local right = {Value = ""}
    local front = {Value = ""}
    local back = {Value = ""}
    local sun = {Value = ""}
    local sunSize = {Value = 11}
    local moon = {Value = ""}
    local moonSize = {Value = 11}
    local oldSkyObjects = {}
    local skyObject
    local connection

    customSky = Tabs.World:CreateToggle({
        Name = "Sky",
        HoverText = "Customizes the sky of the game.",
        Callback = function(callback)
            if callback then
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("PostEffect") or (v:IsA("Sky") and v.Name ~= "SkyObject") then
                        table.insert(oldSkyObjects, v)
                        v.Parent = game
                    end
                end

                skyObject = Instance.new("Sky")
                skyObject.Name = "SkyObject"
                skyObject.Parent = Lighting
                skyObject.SkyboxBk = "rbxassetid://" .. back.Value
                skyObject.SkyboxDn = "rbxassetid://" .. down.Value
                skyObject.SkyboxFt = "rbxassetid://" .. front.Value
                skyObject.SkyboxLf = "rbxassetid://" .. left.Value
                skyObject.SkyboxRt = "rbxassetid://" .. right.Value
                skyObject.SkyboxUp = "rbxassetid://" .. up.Value
                skyObject.SunTextureId = "rbxassetid://" .. sun.Value
                skyObject.MoonTextureId = "rbxassetid://" .. moon.Value
                skyObject.SunAngularSize = sunSize.Value
                skyObject.MoonAngularSize = moonSize.Value

                connection = skyObject.Changed:Connect(function()
                    skyObject.Name = "SkyObject"
                    skyObject.Parent = Lighting
                    skyObject.SkyboxBk = "rbxassetid://" .. back.Value
                    skyObject.SkyboxDn = "rbxassetid://" .. down.Value
                    skyObject.SkyboxFt = "rbxassetid://" .. front.Value
                    skyObject.SkyboxLf = "rbxassetid://" .. left.Value
                    skyObject.SkyboxRt = "rbxassetid://" .. right.Value
                    skyObject.SkyboxUp = "rbxassetid://" .. up.Value
                    skyObject.SunTextureId = "rbxassetid://" .. sun.Value
                    skyObject.MoonTextureId = "rbxassetid://" .. moon.Value
                    skyObject.SunAngularSize = sunSize.Value
                    skyObject.MoonAngularSize = moonSize.Value
                end)
            else
                betterDisconnect(connection)
                if skyObject then skyObject:Destroy() end
                for _, v in pairs(oldSkyObjects) do
                    v.Parent = Lighting
                end
                table.clear(oldSkyObjects)
            end
        end
    })

    back = customSky:CreateTextBox({
        Name = "SkyBack",
        PlaceholderText = "Sky Back ID",
        DefaultValue = "6444884337",
        Function = function(v) back.Value = v end,
    })

    down = customSky:CreateTextBox({
        Name = "SkyDown",
        PlaceholderText = "Sky Down ID",
        DefaultValue = "6444884785",
        Function = function(v) down.Value = v end,
    })

    front = customSky:CreateTextBox({
        Name = "SkyFront",
        PlaceholderText = "Sky Front ID",
        DefaultValue = "6444884337",
        Function = function(v) front.Value = v end,
    })

    left = customSky:CreateTextBox({
        Name = "SkyLeft",
        PlaceholderText = "Sky Left ID",
        DefaultValue = "6444884337",
        Function = function(v) left.Value = v end,
    })

    right = customSky:CreateTextBox({
        Name = "SkyRight",
        PlaceholderText = "Sky Right ID",
        DefaultValue = "6444884337",
        Function = function(v) right.Value = v end,
    })

    up = customSky:CreateTextBox({
        Name = "SkyUp",
        PlaceholderText = "Sky Up ID",
        DefaultValue = "6412503613",
        Function = function(v) up.Value = v end,
    })

    sun = customSky:CreateTextBox({
        Name = "SkySun",
        PlaceholderText = "Sky Sun ID",
        DefaultValue = "6196665106",
        Function = function(v) sun.Value = v end,
    })

    moon = customSky:CreateTextBox({
        Name = "SkyMoon",
        PlaceholderText = "Sky Moon ID",
        DefaultValue = "6444320592",
        Function = function(v) moon.Value = v end,
    })

    sunSize = customSky:CreateSlider({
        Name = "SunSize",
        Function = function(v)
            sunSize.Value = v
            if customSky.Enabled and skyObject then
                skyObject.SunAngularSize = v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 11,
        Round = 0
    })

    moonSize = customSky:CreateSlider({
        Name = "MoonSize",
        Function = function(v)
            moonSize.Value = v
            if customSky.Enabled and skyObject then
                skyObject.MoonAngularSize = v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 11,
        Round = 0
    })
end)

runFunction(function()
    local timeOfDay = {Enabled = false}
    local hours = {Value = 13}
    local minutes = {Value = 0}
    local seconds = {Value = 0}
    local connection
    local oldTime
    local function updateTime()
        Lighting.TimeOfDay = hours.Value..":"..minutes.Value..":"..seconds.Value
    end
    timeOfDay = Tabs.World:CreateToggle({
        Name = "TimeOfDay",
        HoverText = "Customizes the time of the game.",
        Callback = function(callback)
            if callback then
                oldTime = Lighting.TimeOfDay
                updateTime()
                connection = Lighting.Changed:Connect(updateTime())
            else
                Lighting.TimeOfDay = oldTime
                betterDisconnect(connection)
            end
        end
    })

    hours = timeOfDay:CreateSlider({
        Name = "Hours",
        Function = function(v)
            if timeOfDay.Enabled then
                updateTime()
            end
        end,
        Min = 0,
        Max = 24,
        Default = 13,
        Round = 0
    })

    minutes = timeOfDay:CreateSlider({
        Name = "Minutes",
        Function = function(v)
            if timeOfDay.Enabled then
                updateTime()
            end
        end,
        Min = 0,
        Max = 60,
        Default = 0,
        Round = 0
    })

    seconds = timeOfDay:CreateSlider({
        Name = "Seconds",
        Function = function(v)
            if timeOfDay.Enabled then
                updateTime()
            end
        end,
        Min = 0,
        Max = 60,
        Default = 0,
        Round = 0
    })
end)

print("[ManaV2ForRoblox/Universal.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")
task.spawn(function()
    repeat task.wait() until GuiLibrary.ConfigLoaded
    GuiLibrary:CreateNotification("Universal", "Loaded successfully! Press "..GuiLibrary.GuiKeybind.." to open GUI.", 5, "Info", true)
end)