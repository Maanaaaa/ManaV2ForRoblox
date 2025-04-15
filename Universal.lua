--[[
    Credits to anyones code i used or looked at

    Made by Maanaaaa and Wowzers
]]

repeat task.wait() until game:IsLoaded()

local startTick = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
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
local OldFov = Camera.FieldOfView
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
local guifont = GuiLibrary.Font
Mana.StartTick = startTick

playersHandler:start()
toolHandler:start()
CurrentTool = toolHandler.currentTool
--print(CurrentTool)

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

local function isAlive(Player, headCheck, humanoidRootPartCheckDisabled)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and (humanoidRootPartCheckDisabled == false and Player.Character:FindFirstChild("HumanoidRootPart")) and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
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

--[[
    ToDo list:
    Add normal ESP
    Rewrite FastFall - Next update
    Rewrite ForwardTP - Next update
    Rewrite SpinBot - Next update
    Add PlayerFollow
    Add PlayerJumpscare
    Add TurnInToBall
    Add J3rk0ff + all things that are connected with it
    Add SoundPlayer (Visual/Utility + in FE/Trolling way)

]]

-- Combat tab
--[[
runFunction(function()
    local SilentAim = {Enabled = false}
    local AimPart = {Value = "Head"}
    local AimHeld = {Value = "RMB"}
    local SilentAimSmoothness = {Value = 100}
    local SilentAimCircle = {Value = false}
    local CircleTransparency = {Value = 0}
    local SilentAimCircleFilled = {Value = false}
    local SilentAimFov = {Value = 70}
    local SilentAimWallCheck = {Value = false}
    local SilentAimTeamCheck = {Value = false}
    local SilentAimAutoFire = {Value = false}
    local SilentAimAutoFireToolCheck = {Value = false}
    local SilentAimShowTarget = {Value = false}
    local SilentAimShowTargetFill = {Value = false}
    local SilentAimShowTargetFillColor = {Value = "255, 255, 255"}
    local SilentAimShowTargetFillTrasnparency = {Value = 0}
    local SilentAimShowTargetOutline = {Value = false}
    local SilentAimShowTargetOutlineColor = {Value = "255, 255, 255"}
    local SilentAimShowTargetOutlineTrasnparency = {Value = 0}
    local SilentAimFriends = {Value = false}
    local Circle
    local CircleUpdateConnection
    local MouseClicked
    local InputConnection
    local RightConnection
    local LeftConnection
    local OldTarget
    local HighlightObject

    --FireShoot is from vape

    local function FireShoot(ToolCheck)
        local Player = getClosestPlayerToMouse(SilentAimFov.Value, SilentAimTeamCheck.Value, AimPart.Value, SilentAimWallCheck.Value)

        if ToolCheck then
            if CurrentTool == nil then
                return 
            end
        end
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
        if SilentAimCircle.Value then
            if not Circle then
                Circle = Drawing.new("Circle")
                Circle.Filled = SilentAimCircleFilled.Enabled
                Circle.Thickness = 3
                Circle.Radius = SilentAimFov.Value
                Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                Circle.Visible = true
                Circle.Transparency = CircleTransparency.Value

                CircleUpdateConnection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                end)
            end
        else
            if Circle then
                Circle:Destroy()
                Circle = nil
            end
            if CircleUpdateConnection then
                CircleUpdateConnection:Disconnect()
            end
        end
    end

    local SilentAim = Tabs.Combat:CreateToggle({
        Name = "SilentAim",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                InputConnection = UserInputService.InputBegan:Connect(function(Input)
                    if (AimHeld.Value == "RMB" and Input.UserInputType == Enum.UserInputType.MouseButton2) then
                        RightConnection = true
                        LeftConnection = false
                    elseif (AimHeld.Value == "LMB" and Input.UserInputType == Enum.UserInputType.MouseButton1) then
                        LeftConnection = true
                        RightConnection = false
                    end

                    RunService:BindToRenderStep("SilentAim", Enum.RenderPriority.Camera.Value + 1, function()
                        if (AimHeld.Value == "LMB" and LeftConnection) or (AimHeld.Value == "RMB" and RightConnection) then
                            local Player = getClosestPlayerToMouse(SilentAimFov.Value, SilentAimTeamCheck.Value, AimPart.Value, SilentAimWallCheck.Value)
                            if Player and isAlive(Player, AimPart.Value == "Head") then
                                if SilentAimFriends.Value and isFriend(Player.Name) then 
                                    print("FRIEND " .. Player.Name)
                                    return
                                else
                                    if SilentAimShowTarget then
                                        if Player == not OldTarget then
                                            if HighlightObject then
                                                HighlightObject:Destroy()
                                            end
                                            HighlightObject = Instance.new("Highlight")
                                            HighlightObject.Parent = Player.Character
                                            if SilentAimShowTargetFill.Value then
                                                HighlightObject.FillColor = SilentAimShowTargetFillColor.Value:find("Color3") and SilentAimShowTargetFillColor or Color3.fromRGB(SilentAimShowTargetFillColor.Value)
                                                HighlightObject.FillTransparency = SilentAimShowTargetFillTrasnparency.Value
                                            end
                                            if SilentAimShowTargetOutline.Value then
                                                HighlightObject.OutlineColor = SilentAimShowTargetOutlineColor.Value:find("Color3") and SilentAimShowTargetOutlineColor or Color3.fromRGB(SilentAimShowTargetOutlineColor.Value)
                                                HighlightObject.OutlineTransparency = SilentAimShowTargetOutlineTrasnparency.Value
                                            end
                                        end
                                    end
                                    if Player then
                                        AimAt(Player, SilentAimSmoothness.Value, AimPart.Value)
                                        if SilentAimAutoFire.Value then
                                            FireShoot(SilentAimAutoFireToolCheck.Value)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end)
            else
                InputConnection:Disconnect()
                RunService:UnbindFromRenderStep("SilentAim")
            end
        end
    })

    AimPart = SilentAim:CreateDropDown({
        Name = "Aim Part",
        Function = function(v) end,
        List = {"Head", "HumanoidRootPart"},
        Default = "Head",
    })

    AimHeld = SilentAim:CreateDropDown({
        Name = "Mouse Held",
        Function = function(v) end,
        List = {"LMB", "RMB"},
        Default = "RMB",
    })

    SilentAimSmoothness = SilentAim:CreateSlider({
        Name = "Smoothness",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0,
    })

    SilentAimFov = SilentAim:CreateSlider({
        Name = "Fov",
        Function = function(v) end,
        Min = 1,
        Max = 120,
        Default = 70,
        Round = 0,
    })

    SilentAimTeamCheck = SilentAim:CreateToggle({
        Name = "Team Check",
        Default = false,
        Function = function(v) end
    })

    SilentAimWallCheck = SilentAim:CreateToggle({
        Name = "Wall Check",
        Default = false,
        Function = function(v) end
    })

    SilentAimCircle = SilentAim:CreateToggle({
        Name = "FOV Circle",
        Default = false,
        Function = function(v) 
            if CircleTransparency.MainObject then CircleTransparency.MainObject.Visible = v end
            if SilentAimCircleFilled.MainObject then SilentAimCircleFilled.MainObject.Visible = v end
			if v then
				UpdateCircle()
			end
        end
    })
    
    CircleTransparency = SilentAim:CreateSlider({
        Name = "Circle Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    SilentAimCircleFilled = SilentAim:CreateToggle({
        Name = "Circle Filled",
        Default = false,
        Function = function(v) end
    })

    SilentAimAutoFire = SilentAim:CreateToggle({
        Name = "Auto Fire",
        Default = false,
        Function = function(v) 
            if SilentAimAutoFireToolCheck.MainObject then SilentAimAutoFireToolCheck.MainObject.Visible = v end
        end
    })

    SilentAimAutoFireToolCheck = SilentAim:CreateToggle({
        Name = "Tool Check",
        Default = false,
        Function = function(v) end
    })

    SilentAimShowTarget = SilentAim:CreateToggle({
        Name = "Show Target",
        Default = false,
        Callback = function(v)
            if SilentAimShowTargetFill.MainObject then SilentAimShowTargetFill.MainObject.Visible = v end
            if SilentAimShowTargetFillColor.MainObject then SilentAimShowTargetFillColor.MainObject.Visible = v end
        end
    })

    SilentAimShowTargetFill = SilentAim:CreateToggle({
        Name = "FillTarget",
        Default = false,
        Function = function(v) 
            if SilentAimShowTargetFillColor.MainObject then SilentAimShowTargetFillColor.MainObject.Visible = v end
            if SilentAimShowTargetFillTrasnparency.MainObject then SilentAimShowTargetFillTrasnparency.MainObject.Visible = v end
        end
    })

    SilentAimShowTargetFillColor = SilentAim:CreateTextBox({
        Name = "Fill Color",
        PlaceholderText = "Color (RGB)",
        Function = function(v) end
    })

    SilentAimShowTargetFillTrasnparency = SilentAim:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    SilentAimShowTargetOutline = SilentAim:CreateToggle({
        Name = "Outline Target",
        Default = false,
        Function = function(v) 
            if SilentAimShowTargetOutlineColor.MainObject then SilentAimShowTargetOutlineColor.MainObject.Visible = v end
            if SilentAimShowTargetOutlineTrasnparency.MainObject then SilentAimShowTargetOutlineTrasnparency.MainObject.Visible = v end
        end
    })

    SilentAimShowTargetOutlineColor = SilentAim:CreateTextBox({
        Name = "Outline Color",
        PlaceholderText = "Color (RGB)",
        Function = function(v) end
    })

    SilentAimShowTargetOutlineTrasnparency = SilentAim:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    SilentAimFriends = SilentAim:CreateToggle({
        Name = "WhitelistFriends",
        Default = false,
        Function = function(v) end
    })
end)
]]

runFunction(function()
    local SilentAim = {Enabled = false}
    local AimPart = {Value = "Head"}
    local AimHeld = {Value = "RMB"}
    local SilentAimSmoothness = {Value = 100}
    local SilentAimCircle = {Value = false}
    local SilentAimCircleTransparency = {Value = 0}
    local SilentAimCircleFilled = {Value = false}
    local SilentAimFov = {Value = 70}
    local SilentAimWallCheck = {Value = false}
    local SilentAimTeamCheck = {Value = false}
    local SilentAimAutoFire = {Value = false}
    local SilentAimAutoFireToolCheck = {Value = false}
    local Circle
    local CircleUpdateConnection
    local MouseClicked
    local connection
    local LeftConnection
    local RightConnection

    --FireShoot is from vape

    local function fireShoot(ToolCheck)
        local Player = getClosestPlayerToMouse(SilentAimFov.Value, SilentAimTeamCheck.Value, AimPart.Value, SilentAimWallCheck.Value)

        if ToolCheck then
            if toolHandler.currentTool == nil then
                return 
            end
        end
        if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
            if Player then
                if CanClick() and GuiLibrary.ClickGui.Tabs == false and not UserInputService:GetFocusedTextBox() then
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
        if SilentAimCircle then
            if not Circle then
                Circle = Drawing.new("Circle")
                Circle.Filled = SilentAimCircleFilled.Enabled
                Circle.Thickness = 3
                Circle.Radius = SilentAimFov.Value
                Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                Circle.Visible = true
                Circle.Transparency = SilentAimCircleTransparency.Value

                CircleUpdateConnection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                end)
            end
        else
            if Circle then
                Circle:Destroy()
                Circle = nil
            end
            if CircleUpdateConnection then
                CircleUpdateConnection:Disconnect()
            end
        end
    end

    local SilentAim = Tabs.Combat:CreateToggle({
        Name = "SilentAim",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                connection = UserInputService.InputBegan:Connect(function(Input)
                    if (AimHeld.Value == "RMB" and Input.UserInputType == Enum.UserInputType.MouseButton2) then
                        RightConnection = true
                        LeftConnection = false
                    elseif (AimHeld.Value == "LMB" and Input.UserInputType == Enum.UserInputType.MouseButton1) then
                        LeftConnection = true
                        RightConnection = false
                    end

                    RunService:BindToRenderStep("SilentAim", Enum.RenderPriority.Camera.Value + 1, function()
                        if (AimHeld.Value == "LMB" and LeftConnection) or (AimHeld.Value == "RMB" and RightConnection) then
                            local plr = getClosestPlayerToMouse(SilentAimFov.Value, SilentAimTeamCheck.Value, AimPart.Value, SilentAimWallCheck.Value)
                            if plr and isAlive(plr, AimPart.Value == "Head") then
                                AimAt(plr, SilentAimSmoothness.Value, AimPart.Value)
                                if SilentAimAutoFire.Value then
                                    fireShoot(SilentAimAutoFireToolCheck.Value)
                                end
                            end
                        end
                    end)
                end)
            else
                connection:Disconnect()
                RunService:UnbindFromRenderStep("SilentAim")
            end
        end
    })

    AimPart = SilentAim:CreateDropDown({
        Name = "Aim Part",
        Function = function(v) end,
        List = {"Head", "HumanoidRootPart"},
        Default = "Head",
    })

    AimHeld = SilentAim:CreateDropDown({
        Name = "Mouse Held",
        Function = function(v) end,
        List = {"LMB", "RMB"},
        Default = "RMB",
    })

    SilentAimSmoothness = SilentAim:CreateSlider({
        Name = "Smoothness",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0,
    })

    SilentAimFov = SilentAim:CreateSlider({
        Name = "Fov",
        Function = function(v) end,
        Min = 1,
        Max = 120,
        Default = 70,
        Round = 0,
    })

    SilentAimTeamCheck = SilentAim:CreateToggle({
        Name = "Team Check",
        Default = false,
        Function = function(v) end
    })

    SilentAimWallCheck = SilentAim:CreateToggle({
        Name = "Wall Check",
        Default = false,
        Function = function(v) end
    })

    SilentAimCircle = SilentAim:CreateToggle({
        Name = "FOV Circle",
        Default = false,
        Function = function(v) 
            if SilentAimCircleTransparency.MainObject then SilentAimCircleTransparency.MainObject.Visible = v end
            if SilentAimCircleFilled.MainObject then SilentAimCircleFilled.MainObject.Visible = v end
			if v then
				UpdateCircle()
			end
        end
    })
    
    SilentAimCircleTransparency = SilentAim:CreateSlider({
        Name = "Circle Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    SilentAimCircleFilled = SilentAim:CreateToggle({
        Name = "Circle Filled",
        Default = false,
        Function = function(v) end
    })

    SilentAimAutoFire = SilentAim:CreateToggle({
        Name = "Auto Fire",
        Default = false,
        Function = function(v) 
            if SilentAimAutoFireToolCheck.MainObject then SilentAimAutoFireToolCheck.MainObject.Visible = v end
        end
    })

    SilentAimAutoFireToolCheck = SilentAim:CreateToggle({
        Name = "Tool Check",
        Default = false,
        Function = function(v) end
    })
    
end)

runFunction(function()
    local AutoClickerMode = {Value = "Click"}
    local AutoClickerCPS = {Value = 15}

    local AutoClicker = Tabs.Combat:CreateToggle({
        Name = "AutoClicker",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while callback and task.wait(1 / AutoClickerCPS.Value) do
                    if AutoClickerMode.Value == "Click" or AutoClickerMode.Value == "RightClick" then
                        if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
                            if GuiLibrary.ClickGui.Tabs.Visible == false and not UserInputService:GetFocusedTextBox() then
                                local ClickFunction = (AutoClickerMode.Value == "Click" and mouse1click or mouse2click)
                                ClickFunction()
                            end
                        end
                    elseif AutoClickerMode.Value == "Tool" then
                        if toolHandler.currentTool == not nil and CurrentTool:IsA("Tool") and CanClick() then
                            toolHandler.currentTool:Active()
                        end
                    end
                end
            end
        end
    })

    AutoClickerMode = AutoClicker:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Click", "RightClick", "Tool"},
        Default = "Click"
    })

    AutoClickerCPS = AutoClicker:CreateSlider({
        Name = "CPS",
        Function = function() end,
        Min = 0,
        Max = 20,
        Default = 13,
        Round = 0
    })
end)

runFunction(function()
    local Reach = {Enabled = false}
    local ReachExpandPart = {Value = "Head"}
    local ReachExpand = {Value = 0}
    local connection
    local edited = {}

    local function UpdatePlayer(plr)
        if not edited[plr] then edited[plr] = true end
        if isAlive(plr, ReachExpandPart.Value == "Head") and isPlayerTargetable(plr, true) then
            if ReachExpandPart.Value == "HumanoidRootPart" then
                plr.Character.HumanoidRootPart.Size = Vector3.new(2 * (ReachExpand.Value / 10), 2 * (ReachExpand.Value / 10), 1 * (ReachExpand.Value / 10))
            elseif ReachExpandPart.Value == "Head" then
                plr.Character.Head.Size = Vector3.new((ReachExpand.Value / 10), (ReachExpand.Value / 10), (ReachExpand.Value / 10))
            end
        end
    end

    Reach = Tabs.Combat:CreateToggle({
        Name = "Reach",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for _, plr in next, Players:GetPlayers() do
                    UpdatePlayer(plr)
                end
                connection = Players.PlayerAdded:Connect(function(plr)
                    UpdatePlayer(plr)
                end)
            else
                if connection then
                    connection:Disconnect()
                end
                for _, plr in next, Players:GetPlayers() do
                    plr.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    plr.Character.Head.Size = Vector3.new(1, 1, 1)
                end
                for _, plr in next, playersHandler.players do
                    if edited[plr] then
                        edited[plr] = nil
                    end
                end
            end
        end
    })

    ReachExpandPart = Reach:CreateDropDown({
        Name = "Expand Part",
        Function = function(v) end,
        List = {"HumanoidRootPart", "Head"},
        Default = "HumanoidRootPart"
    })

    ReachExpand = Reach:CreateSlider({
        Name = "Expand Size",
        Min = 1,
        Max = 20,
        Round = 1, 
        Function = function(v) end,
    })
end)

-- Movement tab

runFunction(function()
    local autoWalk = {Enabled = false}
    autoWalk = Tabs.Movement:CreateToggle({
        Name = "AutoWalk",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AutoWalk", function()
                    if playersHandler:isAlive() then
                        playersHandler.character.humanoid:Move(Vector3.new(0, 0, -1), true)
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AutoWalk")
            end
        end
    })
end)

--[[from rektsky and not working
runFunction(function()
    local CloneGodmodeSpeed = {Value = 100}
    local CloneGodmodeConnection
    local RealCharacter
    local Clone

    local function MakeClone()
        RealCharacter = LocalPlayer.Character
        RealCharacter.Archivable = true
        Clone = RealCharacter:Clone()
        Clone.Parent = workspace
        LocalPlayer.Character = Clone
    end

    CloneGodmode = Tabs.Movement:CreateToggle({
        Name = "CloneGodmode",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                spawn(function()
                    MakeClone()
                    RunLoops:BindToHeartbeat("CloneGodmode", function()
                        local Velocity = Clone.Humanoid.MoveDirection * CloneGodmodeSpeed.Value
                        Clone.HumanoidRootPart.Velocity = Vector3.new(Velocity.X, LocalPlayer.Character.HumanoidRootPart.Velocity.Y, Velocity.Z)
                    end)
                end)
            else
                if Clone then
                    Clone:Destroy()
                end
                LocalPlayer.Character = RealCharacter
                if RealCharacter then
                    RealCharacter.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                end
                RunLoops:UnbindFromHeartbeat("CloneGodmode")
            end
        end
    })

    CloneGodmodeSpeed = CloneGodmode:CreateSlider({
        Name = "Speed",
        Function = function(v) end,
        Min = 1,
        Max = 300,
        Default = 100,
        Round = 0
    })
end)
]]

runFunction(function()
    local ClickTPMode = {Value = "Click"}
    local MouseConnection1
    local MouseConnection2
    ClickTP = Tabs.Movement:CreateToggle({
        Name = "ClickTP",
        Keybind = nil,
        Callback = function(callback) 
            if callback then
                if ClickTPMode.Value == "Tool" then
                    local Tool = Instance.new("Tool")
                    Tool.Name = "TPTool"
                    Tool.Parent = Backpack
                    Tool.RequiresHandle = false
                    Tool.Activated:Connect(function()
                        if isAlive() and callback then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                elseif ClickTPMode.Value == "Click" then
                    MouseConnection1 = Mouse.Button1Down:Connect(function()
                        if isAlive() and callback and ClickTPMode.Value == "Click" then 
                            LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                elseif ClickTPMode.Value == "RightClick" then
                    MouseConnection2 = Mouse.Button2Down:Connect(function()
                        if isAlive() and callback and ClickTPMode.Value == "RightClick" then 
                            LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                end
            else
                if MouseConnection1 then 
                    MouseConnection1:Disconnect()
                    MouseConnection1 = nil
                end
                if MouseConnection2 then 
                    MouseConnection2:Disconnect()
                    MouseConnection2 = nil
                end
                if Backpack:FindFirstChild("TPTool") then
                    Backpack:FindFirstChild("TPTool"):Destroy()
                end
            end
        end
    })

    ClickTPMode = ClickTP:CreateDropDown({
        Name = "Mode",
        Function = function(v) 
            ClickTP:Toggle()
            ClickTP:Toggle()
        end,
        List = {"Click", "RightLick", "Tool"},
        Default = "Click"
    })
end)

local FlyEnabled = false
runFunction(function()
    local FlySpeed = {Value = 23}
    local FlyVerticalSpeed = {Value = 20}
    local FlyMode = {Value = "Normal"}
    local FlyKeyboardMode = {Value = "LeftShift+Space"}
    Fly = Tabs.Movement:CreateToggle({
        Name = "Fly",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FlyEnabled = callback
                RunLoops:BindToHeartbeat("Fly", function(Delta)
                    local Character = LocalPlayer.Character
                    local Humanoid = Character.Humanoid
                    local HumanoidRootPart = Character.HumanoidRootPart

                    local MoveDirection = Humanoid.MoveDirection
                    local Velocity = HumanoidRootPart.Velocity
                    local XDirection = MoveDirection.X * FlySpeed.Value
                    local ZDirection = MoveDirection.Z * FlySpeed.Value
                    local YDirection = 0

                    if FlyVerticalSpeed.Value > 0 then
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and (FlyKeyboardMode.Value == "LeftShift+Space" or FlyKeyboardMode.Value == "LeftCtrl+Space") then 
                            YDirection = FlyVerticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.E) and FlyKeyboardMode.Value == "Q+E" then
                            YDirection = FlyVerticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and FlyKeyboardMode.Value == "LeftShift+Space" then
                            YDirection = -FlyVerticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and FlyKeyboardMode.Value == "LeftShift+Space" then
                            YDirection = -FlyVerticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) and FlyKeyboardMode.Value == "Q+E" then
                            YDirection = -FlyVerticalSpeed.Value
                        end
                    end

                    if FlyMode.Value == "Velocity" then
                        HumanoidRootPart.Velocity = Vector3.new(XDirection, YDirection, ZDirection)
                    elseif FlyMode.Value == "CFrame" then
                        local Factor = FlySpeed.Value - Humanoid.WalkSpeed
                        local NewMoveDirection = (MoveDirection * Factor) * Delta
                        local NewCFrame = HumanoidRootPart.CFrame + Vector3.new(MoveDirection.X, YDirection * Delta, MoveDirection.Z)

                        HumanoidRootPart.Velocity = Vector3.new(Velocity.X, 0, Velocity.Y)
                        HumanoidRootPart.CFrame = NewCFrame
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("Fly")
            end
        end
    })

    FlyMode = Fly:CreateDropDown({
        Name = "FlyMode",
        Function = function(v) end,
        List = {"CFrame", "Velocity"},
        Default = "Velocity"
    })

    FlyKeyboardMode = Fly:CreateDropDown({
        Name = "KeyboardMode",
        Function = function(v) end,
        List = {"LeftShift+Space", "Q+E", "LeftCtrl+Space"},
        Default = "LeftShift+Space"
    })

    FlySpeed = Fly:CreateSlider({
        Name = "FlyWalkSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 23,
        Round = 0
    })

    FlyVerticalSpeed = Fly:CreateSlider({
        Name = "FlyVerticalSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })
end)

-- this rewrite
runFunction(function()
    local FastFallHeight = {Value = 5}
    local FastFallTicks = {Value = 5}
    local FastFallEnabled = false

    FastFall = Tabs.Movement:CreateToggle({
        Name = "FastFall",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FastFallEnabled = true
                spawn(function() 
                    repeat task.wait()
                        if isAlive() then
                            local Params = RaycastParams.new()
                            Params.FilterDescendantsInstances = {LocalPlayer.Character}
                            Params.FilterType = Enum.RaycastFilterType.Blacklist
                            local Raycast = workspace:Raycast(LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(0, -FastFallHeight.Value * 3, 0), Params)
                            if Raycast and Raycast.Instance then 
                                local Velocity = LocalPlayer.Character.HumanoidRootPart.Velocity
                                if LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Velocity.Y < 0 then 
                                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(Velocity.X, -(FastFallTicks.Value * 30), Velocity.Z)
                                end
                            end
                        end
                    until not FastFallEnabled
                end)
            else
                FastFallEnabled = false
            end
        end
    })
    
    FastFallHeight = FastFall:CreateSlider({
        Name = "FallHeight",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 7,
        Round = 1
    })

    FastFallTicks = FastFall:CreateSlider({
        Name = "Ticks",
        Function = function(v) end,
        Min = 1,
        Max = 5,
        Default = 1,
        Round = 0
    })
end)

runFunction(function()
    local ForwardVectorValue = {Value = 5}
    local Teleporting = false
    ForwardTP = Tabs.Movement:CreateToggle({
        Name = "ForwardTP",
        Keybind = nil,
        Callback = function(callback)
            if callback and not Teleporting then
                Teleporting = true
                if isAlive() then
                    local Humanoid = LocalPlayer.Character.Humanoid
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local LookVector = HumanoidRootPart.CFrame.LookVector
                    if Humanoid.MoveDirection.Magnitude > 0 or Humanoid:GetState() == Enum.HumanoidStateType.Running then
                        local ForwardVector = LookVector * ForwardVectorValue.Value
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + ForwardVector
                    end
                end
                Teleporting = false
                ForwardTP:Toggle(false, false)
            end
        end
    })
    
    ForwardVectorValue = ForwardTP:CreateSlider({
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

    ForwardTPMode = ForwardTP:CreateDropDown({
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
    local HighJumpMode = {Value = "Velocity"}
    local HighJumpJumps = {Value = 5}
    local JumpMode = {Value = "Toggle"}
    local HighJumpHeight = {Value = 20}
    local HighJumpForce = {Value = 25}
    local connection

    HighJump = Tabs.Movement:CreateToggle({
        Name = "HighJump",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                local Character = LocalPlayer.Character
                local Humanoid = Character.Humanoid
                local HumanoidRootPart = Character.HumanoidRootPart

                if JumpMode.Value == "Toggle" then
                    if HighJumpMode.Value == "Jump" then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait()
                        spawn(function()
                            for i = 1, HighJumpJumps.Value do
                                wait()
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end)
                    elseif HighJumpMode.Value == "Velocity" then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, HighJumpHeight.Value, 0)
                    elseif HighJumpMode.Value == "TP" then
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, HighJumpHeight.Value, 0)
                    end
                    HighJump:Toggle(false, false) 
                elseif JumpMode.Value == "Normal" then
                    RunLoops:BindToRenderStep("HighJump", function()
                        connection = table.insert(connections, UserInputService.JumpRequest:Connect(function()
                            if HighJumpMode.Value == "Jump" then
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                task.wait()
                                workspace.Gravity = 5
                                spawn(function()
                                    for i = 1, HighJumpJumps.Value do
                                        wait()
                                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                    end
                                end)
                            elseif HighJumpMode.Value == "Velocity" then
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, HighJumpHeight.Value, 0)
                            elseif HighJumpMode.Value == "TP" then
                                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, HighJumpHeight.Value, 0)
                            end
                        end))
                    end)
                end
            else
                if connection then connection:Disconnect(); connection:disconnect() end
                RunLoops:UnbindFromRenderStep("HighJump")
                workspace.Gravity = 196.19999694824
            end
        end
    })

    HighJumpMode = HighJump:CreateDropDown({
        Name = "JumpMode",
        Function = function(v) 
            if v == "Velocity" or v == "TP" then
                if HighJumpForce.MainObject then
                    HighJumpForce.MainObject.Visible = false
                end
                if HighJumpHeight.MainObject then
                    HighJumpHeight.MainObject.Visible = true
                end
                if HighJumpJumps.MainObject then
                    HighJumpJumps.MainObject.Visible = false
                end
            elseif v == "Jump" then
                if HighJumpHeight.MainObject then
                    HighJumpHeight.MainObject.Visible = false
                end
                if HighJumpForce.MainObject then
                    HighJumpForce.MainObject.Visible = true
                end
                if HighJumpJumps.MainObject then
                    HighJumpJumps.MainObject.Visible = true
                end
            end
        end,
        List = {"Jump", "Velocity", "TP"},
        Default = "Velocity"
    })

    JumpMode = HighJump:CreateDropDown({
        Name = "Mode",
        Callback = function(v) end,
        List = {"Toggle", "Normal"},
        Default = "Toggle"
    })

    HighJumpJumps = HighJump:CreateSlider({
        Name = "Jumps",
        Function = function() end,
        Min = 0,
        Max = 100,
        Default = 5,
        Round = 0
    })

    HighJumpHeight = HighJump:CreateSlider({
        Name = "Height",
        Function = function() end,
        Min = 0,
        Max = 100,
        Default = 25,
        Round = 0
    })

    HighJumpForce = HighJump:CreateSlider({
        Name = "Force",
        Function = function() end,
        Min = 0,
        Max = 50,
        Default = 25,
        Round = 0
    })
end)

runFunction(function()
    local LongJumpMode = {Value = "Velocity"}
    local LongJumpPower = {Value = 2}

    LongJump = Tabs.Movement:CreateToggle({
        Name = "LongJump",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                local Character = LocalPlayer.Character
                local Humanoid = Character.Humanoid
                local HumanoidRootPart = Character.HumanoidRootPart
                local OldVelocity = HumanoidRootPart.Velocity
                if LongJumpMode.Value == "CFrame" then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -0.2, -2.1)
                    Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                    wait(0.1)
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -0.5, -2.1)
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    wait(0.1)
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0.2, 0)
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                elseif LongJumpMode.Value == "Velocity" then
                    local NewVelocity = OldVelocity * LongJumpPower.Value -- (OldVelocity * LongJumpPower.Value) / 2.5
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    HumanoidRootPart.Velocity = Vector3.new(NewVelocity.X, OldVelocity.Y, NewVelocity.X)
                end
                LongJump:Toggle(false)
            end
        end
    })

    LongJumpMode = LongJump:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"CFrame", "Velocity"},
        Default = "Velocity"
    })

    LongJumpPower = LongJump:CreateSlider({
        Name = "Height",
        Function = function() end,
        Min = 1,
        Max = 10,
        Default = 2,
        Round = 0
    })
end)

runFunction(function()
    local Parts = {}
    Phase = Tabs.Movement:CreateToggle({
        Name = "Phase",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                if isAlive() then
                    RunLoops:BindToStepped("Phase", function()
                        for i, v in pairs(LocalPlayer.Character:GetChildren()) do 
                            if v:IsA("BasePart") and v.CanCollide then 
                                Parts[v] = v
                                v.CanCollide = false
                            end
                        end
                    end)
                end
            else
                for i, v in next, Parts do
                    v.CanCollide = true
                end
                Parts = {}
                RunLoops:UnbindFromStepped("Phase")
            end
        end
    })
end)

runFunction(function()
    local SpeedMode = {Value = "Normal"}
    local AutoJumpMode = {Value = "Normal"}
    local SpeedValue = {Value = 16}
    local AutoJumpPower = {Value = 25}
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
                    if isAlive() then
                        local Character = LocalPlayer.Character
                        local Humanoid = Character.Humanoid
                        local HumanoidRootPart = Character.HumanoidRootPart
                        local MoveDirection = Humanoid.MoveDirection
                        local VelocityX = HumanoidRootPart.Velocity.X
                        local VelocityZ = HumanoidRootPart.Velocity.Z

                        if JumpPowerValue.Value > Humanoid.JumpPower then
                            Humanoid.JumpPower = JumpPowerValue.Value
                            Humanoid.UseJumpPower = true
                        end

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
                                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, AutoJumpPower.Value, HumanoidRootPart.Velocity.Z)
                            end
                        end

                        if NoAnimation.Value then
                            Character.Animate.Disabled = true
                        end

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
                if AutoJumpPower.MainObject then
                    AutoJumpPower.MainObject.Visible = true
                end
            elseif v == "Normal" then
                if AutoJumpPower.MainObject then
                    AutoJumpPower.MainObject.Visible = false
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
        Max = 200,
        Default = 16,
        Round = 0
    })

    AutoJumpPower = Speed:CreateSlider({
        Name = "AutoJumpPower",
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
            if AutoJumpMode.MainObject then AutoJumpMode.MainObject.Visible = v end
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

--[[broken
runFunction(function()
    local SpinBotSpeed = {Value = 0}
    local SpinBotX = {Value = false}
    local SpinBotY = {Value = false}
    local SpinBotZ = {Value = false}
    local VelocityX
    local VelocityY
    local VelocityZ
    SpinBot = Tabs.Movement:CreateToggle({
        Name = "SpinBot",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("SpinBot", function()
                    if isAlive() then
                        local Character = LocalPlayer.Character
                        local HumanoidRootPart = Character.HumanoidRootPart
                        local OldVelocity = HumanoidRootPart.RotVelocity

                        if SpinBotX.Value then
                            VelocityX = SpinBotSpeed.Value
                        else
                            VelocityX = OldVelocity.X
                        end
                        if SpinBotY.Value then
                            VelocityY = SpinBotSpeed.Value
                        else
                            VelocityY = OldVelocity.Y
                        end
                        if SpinBotZ.Value then
                            VelocityZ = SpinBotSpeed.Value
                        else
                            VelocityZ = OldVelocity.Z
                        end

                        HumanoidRootPart.RotVelocity = Vector3.new(VelocityX, VelocityY, VelocityZ)
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("SpinBot")
            end
        end
    })

    SpinBotSpeed = SpinBot:CreateSlider({
        Name = "SpinSpeed",
        Function = function() end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })

    SpinBotX = SpinBot:CreateToggle({
        Name = "Spin X",
        Default = false,
        Function = function(v) end
    })

    SpinBotY = SpinBot:CreateToggle({
        Name = "Spin Y",
        Default = false,
        Function = function(v) end
    })

    SpinBotZ = SpinBot:CreateToggle({
        Name = "Spin Z",
        Default = false,
        Function = function(v) end
    })
end)
]]

-- Render tab

runFunction(function()
    local BreadcrumbsLifeTime = {Value = 20}
    local BreadcrumbsTransparency = {Value = 0}
    local BreadcrumbsThick = {Value = 7}
    local BreadcrumbsTrail
	local BreadcrumbsAttachment
	local BreadcrumbsAttachment2
    Breadcrumbs = Tabs.Render:CreateToggle({
        Name = "Breadcrumbs",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                task.spawn(function()
					repeat
						if isAlive() then
                            local Character = LocalPlayer.Character
                            local HumanoidRootPart = Character.HumanoidRootPart
                            if not BreadcrumbsTrail then
                                BreadcrumbsAttachment = Instance.new("Attachment")
                                BreadcrumbsAttachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
                                BreadcrumbsAttachment2 = Instance.new("Attachment")
                                BreadcrumbsAttachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
                                BreadcrumbsTrail = Instance.new("Trail")
                                BreadcrumbsTrail.Attachment0 = BreadcrumbsAttachment
                                BreadcrumbsTrail.Attachment1 = BreadcrumbsAttachment2
                                BreadcrumbsTrail.FaceCamera = true
                                BreadcrumbsTrail.Lifetime = BreadcrumbsLifeTime.Value / 10
                                BreadcrumbsTrail.Enabled = true
                            else
                                local Succes = pcall(function()
                                    BreadcrumbsAttachment.Parent = HumanoidRootPart
                                    BreadcrumbsAttachment2.Parent = HumanoidRootPart
                                    BreadcrumbsTrail.Parent = Camera
                                end)
                                if not Succes then
                                    if BreadcrumbsTrail then BreadcrumbsTrail:Destroy() BreadcrumbsTrail = nil end
                                    if BreadcrumbsAttachment then BreadcrumbsAttachment:Destroy() BreadcrumbsAttachment = nil end
                                    if BreadcrumbsAttachment2 then BreadcrumbsAttachment2:Destroy() BreadcrumbsAttachment2 = nil end
                                end
                            end
						end
						task.wait(0.3)
					until not Breadcrumbs.Enabled
				end)
            else
                if BreadcrumbsTrail then
                    BreadcrumbsTrail:Destroy()
                    BreadcrumbsTrail = nil
                end
				if BreadcrumbsAttachment then
                    BreadcrumbsAttachment:Destroy()
                    BreadcrumbsAttachment = nil
                end
				if BreadcrumbsAttachment2 then
                    BreadcrumbsAttachment2:Destroy()
                    BreadcrumbsAttachment2 = nil
                end
            end
        end
    })

    BreadcrumbsLifeTime = Breadcrumbs:CreateSlider({
        Name = "LifeTime",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0
    })

    BreadcrumbsTransparency = Breadcrumbs:CreateSlider({
        Name = "Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 100,
        Default = 20,
        Round = 2
    })

    BreadcrumbsThick = Breadcrumbs:CreateSlider({
        Name = "Thick",
        Function = function(v) end,
        Min = 1,
        Max = 50,
        Default = 7,
        Round = 2
    })
end)

runFunction(function()
    CameraFix = Tabs.Render:CreateToggle({
        Name = "CameraFix",
        Keybind = nil,
        Callback = function(callback) 
            spawn(function()
                repeat
                    task.wait()
                    if (not CameraFix.Enabled) then break end
                    UserSettings():GetService("UserGameSettings").RotationType = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
                until (not CameraFix.Enabled)
            end)
        end
    })
end)

runFunction(function()
    local ChamsMode = {Value = "SelectionBox"}
    local ChamsAdorneePart = {Value = "HumanoidRootPart"}
    local ChamsSelectionBoxLineThickness = {Value = 0}
    local ChamsSelectionBoxSurfaceTransparency = {Value = 0}
    local ChamsBoxHandleAdornmentSizeX = {Value = 1}
    local ChamsBoxHandleAdornmentSizeY = {Value = 1}
    local ChamsBoxHandleAdornmentSizeZ = {Value = 1}
    local ChamsBoxHandleAdornmentAlwaysOnTop = {Value = true}
    local ChamsHighlightOutline = {Value = true}
    local ChamsHighlightOutlineTransparency = {Value = 0}
    local ChamsHighlightFill = {Value = false}
    local ChamsHighlightFillTransparency = {Value = 0}
    local ChamsTransparency = {Value = 0.6}
    local ChamsTeamColor = {Value = false}
    local ChamsTeammates = {Value = false}
    local PlayerAddedConnection

    local ChamsFolder = Instance.new("Folder")
    ChamsFolder.Parent = workspace
    ChamsFolder.Name = "ChamsFolder"

    local ObjectsName = {
        "SelectionBoxObject",
        "BoxHandleAdornmentObject",
        "HighlightObject"
    }

    local function RemoveChams(Player)
        local Character = Player.Character
        if not Character then return end

        for _, Object in ipairs(ObjectsName) do
            local Object = Character:FindFirstChild(Object)
            if Object then
                Object:Destroy()
            end
        end
    end

    local function UpdateChams(Player)
        if isAlive(Player) then
            local Character = Player.Character
            if not Character then return end
            local AdorneePart = ChamsAdorneePart.Value == "Full Character" and Character or Character:FindFirstChild(ChamsAdorneePart.Value)
            local color = ChamsTeamColor.Value and Player.Team and Player.TeamColor or Color3.fromRGB(255, 0, 0)

            if ChamsMode.Value == "SelectionBox" then
                local BoxObject = Character:FindFirstChild("SelectionBoxObject")
                if not BoxObject then
                    BoxObject = Instance.new("SelectionBox")
                    BoxObject.Name = "SelectionBoxObject"
                    BoxObject.Parent = Character
                end
                BoxObject.Adornee = AdorneePart
                BoxObject.LineThickness = ChamsSelectionBoxLineThickness.Value
                BoxObject.SurfaceColor3 = color
                BoxObject.SurfaceTransparency = ChamsSelectionBoxSurfaceTransparency.Value
                BoxObject.Transparency = ChamsTransparency.Value
            elseif ChamsMode.Value == "BoxHandleAdornment" then
                local BoxObject = Character:FindFirstChild("BoxHandleAdornmentObject")
                if not BoxObject then
                    BoxObject = Instance.new("BoxHandleAdornment")
                    BoxObject.Name = "BoxHandleAdornmentObject"
                    BoxObject.Parent = Character
                end
                BoxObject.Adornee = AdorneePart
                BoxObject.Size = Vector3.new(ChamsBoxHandleAdornmentSizeX.Value, ChamsBoxHandleAdornmentSizeY.Value, ChamsBoxHandleAdornmentSizeZ.Value)
                BoxObject.AlwaysOnTop = ChamsBoxHandleAdornmentAlwaysOnTop.Value
                BoxObject.Color3 = color
                BoxObject.Transparency = ChamsTransparency.Value
            elseif ChamsMode.Value == "Highlight" then
                local HighlightObject = Character:FindFirstChild("HighlightObject")
                if not HighlightObject then
                    HighlightObject = Instance.new("Highlight")
                    HighlightObject.Name = "HighlightObject"
                    HighlightObject.Parent = Character
                end
                HighlightObject.Adornee = AdorneePart
                HighlightObject.FillColor = ChamsHighlightFill.Value and color or Color3.fromRGB(255, 255, 255)
                HighlightObject.FillTransparency = ChamsHighlightFillTransparency.Value
                HighlightObject.OutlineColor = color
                HighlightObject.OutlineTransparency = ChamsHighlightOutline.Value and ChamsHighlightOutlineTransparency.Value or 1
            end
        end
    end

    local Chams = Tabs.Render:CreateToggle({
        Name = "Chams",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for _, Player in next, Players:GetPlayers() do
                    UpdateChams(Player)
                end

                PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
                    UpdateChams(Player)
                end)
            else
                for _, Player in next, Players:GetPlayers() do
                    RemoveChams(Player)
                end
                if PlayerAddedConnection then
                    PlayerAddedConnection:Disconnect()
                end
            end
        end
    })

    ChamsAdorneePart = Chams:CreateDropDown({
        Name = "Attach Part",
        List = {"Head", "HumanoidRootPart", "Full Character"},
        Default = "Full Character",
        Callback = function(v) end
    })

    ChamsMode = Chams:CreateDropDown({
        Name = "Mode",
        List = {"SelectionBox", "BoxHandleAdornment", "Highlight"},
        Default = "SelectionBox",
        Callback = function(v)
            local modeVisibility = {
                SelectionBox = {ChamsSelectionBoxLineThickness, ChamsSelectionBoxSurfaceTransparency},
                BoxHandleAdornment = {ChamsBoxHandleAdornmentSizeX, ChamsBoxHandleAdornmentSizeY, ChamsBoxHandleAdornmentSizeZ},
                Highlight = {ChamsHighlightOutline, ChamsHighlightFill}
            }
    
            for _, group in pairs(modeVisibility) do
                for _, item in ipairs(group) do
                    if item.MainObject then
                        item.MainObject.Visible = false
                    end
                end
            end
    
            for _, item in ipairs(modeVisibility[v]) do
                if item.MainObject then
                    item.MainObject.Visible = true
                end
            end
        end
    })

    ChamsSelectionBoxLineThickness = Chams:CreateSlider({
        Name = "Line Thickness",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    ChamsSelectionBoxSurfaceTransparency = Chams:CreateSlider({
        Name = "Surface Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 10,
        Default = 1,
        Round = 1
    })

    ChamsBoxHandleAdornmentSizeX = Chams:CreateSlider({
        Name = "Box Size X",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    ChamsBoxHandleAdornmentSizeY = Chams:CreateSlider({
        Name = "Box Size Y",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    ChamsBoxHandleAdornmentSizeZ = Chams:CreateSlider({
        Name = "Box Size Z",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    ChamsHighlightOutline = Chams:CreateToggle({
        Name = "Outline",
        Default = true,
        Function = function(v)
            if ChamsHighlightOutlineTransparency.MainObject then
                ChamsHighlightOutlineTransparency.MainObject.Visible = v
            end
        end
    })

    ChamsHighlightOutlineTransparency = Chams:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    ChamsHighlightFill = Chams:CreateToggle({
        Name = "Fill",
        Default = true,
        Function = function(v)
            if ChamsHighlightFillTransparency.MainObject then
                ChamsHighlightFillTransparency.MainObject.Visible = v
            end
        end
    })

    ChamsHighlightFillTransparency = Chams:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    ChamsTransparency = Chams:CreateSlider({
        Name = "Chams Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    ChamsTeammates = Chams:CreateToggle({
        Name = "Teammates",
        Default = false,
        Function = function(v) end
    })

    ChamsTeamColor = Chams:CreateToggle({
        Name = "TeamColor",
        Default = false,
        Function = function(v) end
    })
end)

runFunction(function()
    local ChinaHatTrail
    local ChinaHatEnabled = false
    ChinaHat = Tabs.Render:CreateToggle({
        Name = "ChinaHat",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("ChinaHat", function()
					if isAlive() then
						if ChinaHatTrail == nil or ChinaHatTrail.Parent == nil then
							ChinaHatTrail = Instance.new("Part")
							ChinaHatTrail.CFrame =  LocalPlayer.Character.Head.CFrame * CFrame.new(0, 1.1, 0)
							ChinaHatTrail.Size = Vector3.new(3, 0.7, 3)
							ChinaHatTrail.Name = "ChinaHat"
							ChinaHatTrail.Material = Enum.Material.Neon
							ChinaHatTrail.CanCollide = false
							ChinaHatTrail.Transparency = 0.3
							local ChinaHatMesh = Instance.new("SpecialMesh")
							ChinaHatMesh.Parent = ChinaHatTrail
							ChinaHatMesh.MeshType = "FileMesh"
							ChinaHatMesh.MeshId = "http://www.roblox.com/asset/?id=1778999"
							ChinaHatMesh.Scale = Vector3.new(3, 0.6, 3)
							ChinaHatTrail.Parent = workspace.Camera
						end
						ChinaHatTrail.CFrame = LocalPlayer.Character.Head.CFrame * CFrame.new(0, 1.1, 0)
						ChinaHatTrail.Velocity = Vector3.zero
						ChinaHatTrail.LocalTransparencyModifier = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.6 and 1 or 0)
					else
						if ChinaHatTrail then
							ChinaHatTrail:Destroy()
							ChinaHatTrail = nil
						end
					end
				end)
            else
                RunLoops:UnbindFromHeartbeat("ChinaHat")
				if ChinaHatTrail then
					ChinaHatTrail:Destroy()
					ChinaHatTrail = nil
				end
            end
        end
    })
end)

if GuiLibrary.Device ~= "Mobile" then
    runFunction(function()
        local CrossHairId = {Value = ""}
        CustomCrossHair = Tabs.Render:CreateToggle({
            Name = "CustomCrossHair",
            Keybind = nil,
            Callback = function(callback)
                if callback then
                    Mouse.Icon = "rbxassetid://" .. CrossHairId.Value
                else
                    Mouse.Icon = ""
                end
            end
        })

        CrossHairId = CustomCrossHair:CreateTextBox({
            Name = "CrossHairID",
            PlaceholderText = "Cross Hair ID",
            DefaultValue = "",
            Function = function(v) end,
        })
    end)
end

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

    EspMode = Esp:CreateDropDown({
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

    NameMode = Esp:CreateDropDown({
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
    local NewFov = {Value = 80}
    FovChanger = Tabs.Render:CreateToggle({
        Name = "FovChanger",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Camera.FieldOfView = NewFov.Value
            else
                Camera.FieldOfView = OldFov
            end
        end
    })
    
    NewFov = FovChanger:CreateSlider({
        Name = "Field Of View",
        Function = function(v)
            Camera.FieldOfView = v
        end,
        Min = 1,
        Max = 150,
        Default = 80,
        Round = 0
    })
end)

runFunction(function()
    local LightingParameters = {}
	local LightingChanged = false
    local connection
    Fullbright = Tabs.Render:CreateToggle({
        Name = "Fullbright",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                LightingParameters.Brightness = Lighting.Brightness
                LightingParameters.ClockTime = Lighting.ClockTime
                LightingParameters.FogEnd = Lighting.FogEnd
                LightingParameters.GlobalShadows = Lighting.GlobalShadows
                LightingParameters.OutdoorAmbient = Lighting.OutdoorAmbient
                LightingChanged = true
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                LightingChanged = false
                connection = table.insert(connections, Lighting.Changed:Connect(function()
                    if not LightingChanged and callback then
                        LightingParameters.Brightness = Lighting.Brightness
                        LightingParameters.ClockTime = Lighting.ClockTime
                        LightingParameters.FogEnd = Lighting.FogEnd
                        LightingParameters.GlobalShadows = Lighting.GlobalShadows
                        LightingParameters.OutdoorAmbient = Lighting.OutdoorAmbient
                        LightingChanged = true
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 100000
                        Lighting.GlobalShadows = false
                        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                        LightingChanged = false
                    end
                end))
            else
                connection:Disconnect()
                connection:disconnect()
                for Name, Value in pairs(LightingParameters) do
                    Lighting[Name] = Value
                end
            end
        end
    })  
end)

-- I SWEAR TO FUCKING GOD IF THIS SHIT DOESN'T WORK IMA HONESTLY FUCK LUA
runFunction(function()
    local NameTags = {Enabled = false}
    local NameTagsMode = {Value = "Username"}
    local NameTagsHP = {Value = false}
    local NameTagsDistance = {Value = false}
    local NameTagsMaxDistance = {Value = 1000}
    
    -- Connection THE FUCKING STORAGE for the SHITTY cleanup
    local connections = {}
    
    -- Create folder and parent it properly
    local espfolder = Instance.new("Folder")
    espfolder.Name = "ESPFolder"
    
    -- Use a safe parent
    if game:GetService("CoreGui") then
        espfolder.Parent = game:GetService("CoreGui")
    else
        espfolder.Parent = workspace
    end
    
    -- Clean up any existing ESP folder to prevent the stupid duplicates
    for _, existing in pairs(game:GetService("CoreGui"):GetChildren()) do
        if existing.Name == "ESPFolder" and existing ~= espfolder then
            existing:Destroy()
        end
    end
    
    -- Convert health to the appropriate color
    local function ConvertHealthToColor(Health, MaxHealth)
        if type(Health) ~= "number" or type(MaxHealth) ~= "number" or MaxHealth <= 0 or Health <= 0 then
            return Color3.fromRGB(255, 0, 0)
        end
        
        local Percent = math.clamp((Health / MaxHealth) * 100, 0, 100)
        
        if Percent >= 70 then
            return Color3.fromRGB(96, 253, 48) 
        elseif Percent >= 45 then
            return Color3.fromRGB(255, 196, 0) 
        else
            return Color3.fromRGB(255, 71, 71) 
        end
    end
    
    local billboardGuis = {}
    
    -- Function to check if a player is alive
    local aliveCache = {}
    local lastAliveCheck = {}
    local function isAlive(player)
        if not player then player = game:GetService("Players").LocalPlayer end
        
        -- Use cached result if checked recently
        local now = tick()
        if lastAliveCheck[player.Name] and now - lastAliveCheck[player.Name] < 0.2 then
            return aliveCache[player.Name]
        end
        
        -- Perform the actual fucking check
        local character = player.Character
        local isAlive = character and 
                       character:FindFirstChild("Humanoid") and 
                       character:FindFirstChild("HumanoidRootPart") and 
                       character.Humanoid.Health > 0
        
        -- Cache the result
        aliveCache[player.Name] = isAlive
        lastAliveCheck[player.Name] = now
        
        return isAlive
    end
    
    -- Clean up existing nametag for a player(s)
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
        if not plr or not plr.Character or not plr.Character:FindFirstChild("Head") then
            return nil
        end
        
        CleanupPlayerNameTag(plr)
        
        local billboardGui = Instance.new("BillboardGui")
        local textLabel = Instance.new("TextLabel")
        
        -- Configure billboardGui
        billboardGui.Name = "NameTag_" .. plr.Name
        billboardGui.Adornee = plr.Character.Head
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 1.2, 0)
        billboardGui.MaxDistance = NameTagsMaxDistance.Value
        billboardGui.Parent = espfolder
        
        for prop, value in pairs(textLabelProps) do
            textLabel[prop] = value
        end
        textLabel.Parent = billboardGui
        
        billboardGuis[plr.Name] = billboardGui
        return billboardGui
    end
    
    local function UpdateNameTag(plr)
        local billboardGui = billboardGuis[plr.Name]
        if not billboardGui or not billboardGui.Parent then return end
        
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local character = plr.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return end
        
        local textLabel = billboardGui:FindFirstChild("NameTagText")
        if not textLabel then return end
        
        local nameText = NameTagsMode.Value == "Username" and plr.Name or plr.DisplayName
        local parts = {nameText}
        
        if NameTagsHP.Value then
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            local healthColor = ConvertHealthToColor(health, maxHealth)
            
            table.insert(parts, string.format(" <font color=\"rgb(%d,%d,%d)\">%d HP</font>", 
                math.floor(healthColor.R * 255), 
                math.floor(healthColor.G * 255), 
                math.floor(healthColor.B * 255), 
                health))
        end
        
        -- Add distance information if it's enabled
        if NameTagsDistance.Value and isAlive(LocalPlayer) then
            local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
            table.insert(parts, string.format(" [%dm]", distance))
        end
        
        -- Set the final text
        textLabel.Text = table.concat(parts)
        
        -- Only adjust text size if needed
        if NameTagsDistance.Value and isAlive(LocalPlayer) then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            local scaleFactor = math.clamp(1 - (distance / NameTagsMaxDistance.Value) * 0.5, 0.5, 1)
            if math.abs(textLabel.TextSize - (16 * scaleFactor)) > 0.5 then
                textLabel.TextSize = 16 * scaleFactor
            end
        end
    end
    
    -- Update all nametags with current settings
    local function UpdateAllNameTags()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
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
    
    -- Clean up all the shown nametags
    local function CleanupAllNameTags()
        for name, gui in pairs(billboardGuis) do
            if gui and gui.Parent then
                gui:Destroy()
            end
            billboardGuis[name] = nil
        end
        
        -- Clear caches
        aliveCache = {}
        lastAliveCheck = {}
    end
    
    -- Disconnect all event connections
    local function DisconnectAll()
        for _, connection in pairs(connections) do
            if typeof(connection) == "RBXScriptConnection" and connection.Connected then
                connection:Disconnect()
            end
        end
        connections = {}
    end

    NameTags = Tabs.Render:CreateToggle({
        Name = "NameTags",
        Keybind = nil,
        Callback = function(callback)
            NameTags.Enabled = callback
            
            -- Always clean up previous state
            RunLoops:UnbindFromRenderStep("NameTags")
            DisconnectAll()
            
            if callback then
                -- Clean up any existing tags first
                CleanupAllNameTags()
                
                -- Add player removing event
                local playerRemovingConn = game:GetService("Players").PlayerRemoving:Connect(function(plr)
                    if NameTags.Enabled then
                        CleanupPlayerNameTag(plr)
                    end
                end)
                table.insert(connections, playerRemovingConn)
                
                -- Create the render step to update nametags
                local lastFullUpdate = 0
                RunLoops:BindToRenderStep("NameTags", function()
                    local now = tick()
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    
                    -- Only do a full update every 0.5 seconds
                    if now - lastFullUpdate > 0.5 then
                        lastFullUpdate = now                      
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer then
                                if isAlive(plr) and (not billboardGuis[plr.Name] or not billboardGuis[plr.Name].Parent) then
                                    CreateNameTag(plr)
                                elseif (not isAlive(plr)) and billboardGuis[plr.Name] then
                                    CleanupPlayerNameTag(plr)
                                end
                            end
                        end
                    end
                    
                    -- Update only visible nametags every frame for smooth distance/health updates
                    for name, gui in pairs(billboardGuis) do
                        local plr = Players:FindFirstChild(name)
                        if plr and gui.Parent and isAlive(plr) then
                            UpdateNameTag(plr)
                        end
                    end
                end)
            else
                -- Clean up when disabled
                CleanupAllNameTags()
            end
        end
    })

    NameTagsMode = NameTags:CreateDropDown({
        Name = "Name Mode",
        List = {"Username", "DisplayName"},
        Default = "Username",
        Function = function(val)
            NameTagsMode.Value = val
            if NameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    NameTagsHP = NameTags:CreateToggle({
        Name = "Health",
        Default = false,
        Function = function(val)
            NameTagsHP.Value = val
            if NameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })

    NameTagsDistance = NameTags:CreateToggle({
        Name = "Distance",
        Default = false,
        Function = function(val)
            NameTagsDistance.Value = val
            if NameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })
    
    NameTagsMaxDistance = NameTags:CreateSlider({
        Name = "Max Distance",
        Min = 100,
        Max = 10000,
        Default = 1000,
        Round = 0,
        Function = function(val)
            NameTagsMaxDistance.Value = val
            if NameTags.Enabled then
                UpdateAllNameTags()
            end
        end
    })
    
    -- Clean up on script end
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
        if NameTags.Enabled then
            RunLoops:UnbindFromRenderStep("NameTags")
            DisconnectAll()
            CleanupAllNameTags()
        end
    end)
end)

runFunction(function()
    local RainbowSkinEnabled = false
    RainbowSkin = Tabs.Render:CreateToggle({
        Name = "RainbowSkin",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                while RainbowSkinEnabled and task.wait(0.1) do
                    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    for _,part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = Color3.new(math.random(), math.random(), math.random())
                        end
                    end
                end
            else
                RainbowSkinEnabled = false
            end
        end
    })
end)

runFunction(function()
    ViewClip = Tabs.Render:CreateToggle({
        Name = "ViewClip",
        Keybind = nil,
        Callback = function(callback) 
            if callback then
                LocalPlayer.DevCameraOcclusionMode = "Invisicam"
            else
                LocalPlayer.DevCameraOcclusionMode = "Zoom"
            end
        end
    })
end)

--[[somewhen
this was made by Wowzers
runFunction(function()
    local TracerStartPoint = {Value = "Mouse"}
    local TracerThickness = {Value = 2}
    local TracerTransparency = {Value = 0}
    local TracerTeamCheck = {Value = true}
    local Lines = {}
    local PlayerRemovingConnection

    local function UpdateTracers()
        for _, Player in pairs(Players:GetPlayers()) do
            if isAlive(Player) and Player ~= LocalPlayer and (not TracerTeamCheck.Value or Player.Team ~= LocalPlayer.Team) then
                local Line = Drawing.new("Line")
                Lines[Player.Name] = Line

                local HumanoidRootPartPosition = character.HumanoidRootPart.Position
                local HumanoidRootPartSize = character.HumanoidRootPart.Size
                local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPartPosition - Vector3.new(0, HumanoidRootPartSize.Y / 2, 0))
                
                Line.Thickness = TracerThickness.Value
                Line.Transparency = TracerTransparency.Value

                if TracerStartPoint.Value == "Mouse" then
                    Line.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                elseif TracerStartPoint.Value == "Center" then
                    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                elseif TracerStartPoint.Value == "Bottom" then
                    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                end

                if OnScreen then
                    Line.To = Vector2.new(Vector.X, Vector.Y)
                    Line.Visible = true
                else
                    Line.Visible = false
                end
            end
        end
    end

    Tracers = Tabs.Render:CreateToggle({
        Name = "Tracers",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                ESPEnabled = callback
                RunLoops:BindToRenderStep("Tracers", function()
                    UpdateTracers()
                end)

                PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(Player)
                    if Lines[Player.Name] then
                        Lines[Player.Name].Visible = false
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("Tracers")

                if PlayerRemovingConnection then
                    PlayerRemovingConnection:Disconnect()
                end
                
                for _, Line in pairs(Lines) do
                    Line.Visible = false
                end
            end
        end
    })  

    TracerStartPoint = Tracers:CreateDropDown({
        Name = "StartPoint",
        Function = function(v)
            TracerStartPoint.Value = v
        end,
        List = {"Center", "Mouse", "Bottom"},
        Default = "Bottom"
    })

    TracerThickness = Tracers:CreateSlider({
        Name = "Thickness",
        Function = function(v)
            TracerThickness.Value = v
        end,
        Min = 0.1,
        Max = 4,
        Default = 2,
        Round = 1
    })

    TracerTransparency = Tracers:CreateSlider({
        Name = "TracerTransparency",
        Function = function(v)
            TracerTransparency.Value = v
        end,
        Min = 0.1,
        Max = 1,
        Default = 0,
        Round = 1
    })
end)
]]

--[[
runFunction(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    
    local TracerStartPoint = {Value = "Bottom"}
    local TracerThickness = {Value = 2}
    local TracerTransparency = {Value = 0}
    local TracerTeamCheck = {Value = true}
    local TracerColor = {Value = Color3.fromRGB(255, 255, 255)}
    local Lines = {}
    local PlayerRemovingConnection
    
    -- Helper function to check if a player is alive
    local function isAlive(player)
        local character = player.Character
        return character and 
               character:FindFirstChild("Humanoid") and 
               character:FindFirstChild("HumanoidRootPart") and 
               character.Humanoid.Health > 0
    end
    
    local function UpdateTracers()
        -- Clear old lines first
        for playerName, line in pairs(Lines) do
            if not Players:FindFirstChild(playerName) then
                line:Remove()
                Lines[playerName] = nil
            else
                line.Visible = false -- Hide all lines, we'll show only valid ones
            end
        end
        
        -- Update or create new lines
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isAlive(player) and 
               (not TracerTeamCheck.Value or player.Team ~= LocalPlayer.Team) then
                
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        -- Get the bottom position of the HumanoidRootPart
                        local position = humanoidRootPart.Position - Vector3.new(0, humanoidRootPart.Size.Y/2, 0)
                        local vector, onScreen = Camera:WorldToViewportPoint(position)
                        
                        if onScreen then
                            -- Create or get existing line
                            local line = Lines[player.Name]
                            if not line then
                                line = Drawing.new("Line")
                                Lines[player.Name] = line
                            end
                            
                            -- Set line properties
                            line.Thickness = TracerThickness.Value
                            line.Transparency = 1 - TracerTransparency.Value
                            line.Color = TracerColor.Value
                            
                            -- Set start position based on user preference
                            if TracerStartPoint.Value == "Mouse" then
                                line.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                            elseif TracerStartPoint.Value == "Center" then
                                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            elseif TracerStartPoint.Value == "Bottom" then
                                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            end
                            
                            -- Set end position to player
                            line.To = Vector2.new(vector.X, vector.Y)
                            line.Visible = true
                        end
                    end
                end
            end
        end
    end
    
    -- Clean up all lines
    local function CleanupLines()
        for _, line in pairs(Lines) do
            line:Remove()
        end
        Lines = {}
    end
    
    -- HSV to RGB conversion function
    local function HSVtoRGB(h, s, v)
        local r, g, b
        
        local i = math.floor(h * 6)
        local f = h * 6 - i
        local p = v * (1 - s)
        local q = v * (1 - f * s)
        local t = v * (1 - (1 - f) * s)
        
        i = i % 6
        
        if i == 0 then r, g, b = v, t, p
        elseif i == 1 then r, g, b = q, v, p
        elseif i == 2 then r, g, b = p, v, t
        elseif i == 3 then r, g, b = p, q, v
        elseif i == 4 then r, g, b = t, p, v
        elseif i == 5 then r, g, b = v, p, q
        end
        
        return Color3.fromRGB(r * 255, g * 255, b * 255)
    end
    
    -- Vape v4 style Color Picker implementation
    local function CreateVapeColorPicker(parent, default, callback)
        local colorPickerFrame = Instance.new("Frame")
        colorPickerFrame.Name = "ColorPicker"
        colorPickerFrame.Size = UDim2.new(1, 0, 0, 120)
        colorPickerFrame.BackgroundTransparency = 1
        colorPickerFrame.Parent = parent
        
        -- Create the hue slider (rainbow)
        local hueSlider = Instance.new("Frame")
        hueSlider.Name = "HueSlider"
        hueSlider.Size = UDim2.new(1, -20, 0, 15)
        hueSlider.Position = UDim2.new(0, 10, 0, 10)
        hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueSlider.BorderSizePixel = 0
        hueSlider.Parent = colorPickerFrame
        
        -- Create rainbow gradient for hue slider
        local hueGradient = Instance.new("UIGradient")
        hueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        hueGradient.Parent = hueSlider
        
        -- Hue slider knob
        local hueKnob = Instance.new("Frame")
        hueKnob.Name = "HueKnob"
        hueKnob.Size = UDim2.new(0, 5, 1, 6)
        hueKnob.Position = UDim2.new(0, 0, 0, -3)
        hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueKnob.BorderColor3 = Color3.fromRGB(0, 0, 0)
        hueKnob.BorderSizePixel = 1
        hueKnob.Parent = hueSlider
        
        -- Create saturation/value picker area
        local svPicker = Instance.new("Frame")
        svPicker.Name = "SVPicker"
        svPicker.Size = UDim2.new(1, -20, 0, 80)
        svPicker.Position = UDim2.new(0, 10, 0, 35)
        svPicker.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Will be updated based on hue
        svPicker.BorderSizePixel = 0
        svPicker.Parent = colorPickerFrame
        
        -- Create white gradient (horizontal - saturation)
        local saturationGradient = Instance.new("UIGradient")
        saturationGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        saturationGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
        saturationGradient.Rotation = 90
        saturationGradient.Parent = svPicker
        
        -- Create black gradient (vertical - value)
        local valueFrame = Instance.new("Frame")
        valueFrame.Name = "ValueFrame"
        valueFrame.Size = UDim2.new(1, 0, 1, 0)
        valueFrame.BackgroundTransparency = 1
        valueFrame.BorderSizePixel = 0
        valueFrame.Parent = svPicker
        
        local valueGradient = Instance.new("UIGradient")
        valueGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        valueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        valueGradient.Parent = valueFrame
        
        -- SV picker knob
        local svKnob = Instance.new("Frame")
        svKnob.Name = "SVKnob"
        svKnob.Size = UDim2.new(0, 6, 0, 6)
        svKnob.Position = UDim2.new(1, -3, 0, -3)
        svKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        svKnob.BorderColor3 = Color3.fromRGB(0, 0, 0)
        svKnob.BorderSizePixel = 1
        svKnob.ZIndex = 2
        svKnob.Parent = svPicker
        
        -- Current color display
        local currentColor = Instance.new("Frame")
        currentColor.Name = "CurrentColor"
        currentColor.Size = UDim2.new(0, 30, 0, 15)
        currentColor.Position = UDim2.new(1, -40, 0, 10)
        currentColor.BackgroundColor3 = default
        currentColor.BorderColor3 = Color3.fromRGB(30, 30, 30)
        currentColor.BorderSizePixel = 1
        currentColor.Parent = colorPickerFrame
        
        -- Variables to track color state
        local hue, sat, val = 0, 1, 1
        local dragging = nil
        
        -- Update functions
        local function updateHue(hueValue)
            hue = hueValue
            svPicker.BackgroundColor3 = HSVtoRGB(hue, 1, 1)
            local color = HSVtoRGB(hue, sat, val)
            currentColor.BackgroundColor3 = color
            TracerColor.Value = color
            callback(color)
        end
        
        local function updateSV(satValue, valValue)
            sat = satValue
            val = valValue
            local color = HSVtoRGB(hue, sat, val)
            currentColor.BackgroundColor3 = color
            TracerColor.Value = color
            callback(color)
        end
        
        -- Input handlers
        hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = "hue"
                local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                hueKnob.Position = UDim2.new(relativeX, -2.5, 0, -3)
                updateHue(relativeX)
            end
        end)
        
        svPicker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = "sv"
                local relativeX = math.clamp((input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X, 0, 1)
                local relativeY = math.clamp((input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y, 0, 1)
                svKnob.Position = UDim2.new(relativeX, -3, relativeY, -3)
                updateSV(relativeX, 1 - relativeY)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                if dragging == "hue" then
                    local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                    hueKnob.Position = UDim2.new(relativeX, -2.5, 0, -3)
                    updateHue(relativeX)
                elseif dragging == "sv" then
                    local relativeX = math.clamp((input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X, 0, 1)
                    local relativeY = math.clamp((input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y, 0, 1)
                    svKnob.Position = UDim2.new(relativeX, -3, relativeY, -3)
                    updateSV(relativeX, 1 - relativeY)
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = nil
            end
        end)
        
        -- Initialize with default color
        updateHue(0) -- Start with red
        updateSV(1, 1) -- Full saturation and value
        
        return colorPickerFrame
    end
    
    Tracers = Tabs.Render:CreateToggle({
        Name = "Tracers",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                -- Create player removing connection
                PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
                    if Lines[player.Name] then
                        Lines[player.Name]:Remove()
                        Lines[player.Name] = nil
                    end
                end)
                
                -- Bind the update function to RenderStepped
                RunLoops:BindToRenderStep("Tracers", UpdateTracers)
            else
                -- Unbind the update function
                RunLoops:UnbindFromRenderStep("Tracers")
                
                -- Disconnect player removing connection
                if PlayerRemovingConnection then
                    PlayerRemovingConnection:Disconnect()
                    PlayerRemovingConnection = nil
                end
                
                -- Clean up lines
                CleanupLines()
            end
        end
    })
    
    TracerStartPoint = Tracers:CreateDropDown({
        Name = "Start Point",
        Function = function(v)
            TracerStartPoint.Value = v
        end,
        List = {"Center", "Mouse", "Bottom"},
        Default = "Bottom"
    })
    
    TracerThickness = Tracers:CreateSlider({
        Name = "Thickness",
        Function = function(v)
            TracerThickness.Value = v
        end,
        Min = 0.1,
        Max = 4,
        Default = 2,
        Round = 1
    })
    
    TracerTransparency = Tracers:CreateSlider({
        Name = "Transparency",
        Function = function(v)
            TracerTransparency.Value = v
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    
    TracerTeamCheck = Tracers:CreateToggle({
        Name = "Team Check",
        Default = true,
        Callback = function(callback)
            TracerTeamCheck.Value = callback
        end
    })
    
    -- Create a section for color picker
    local ColorSection = Tracers:CreateDivider("Tracer Color")
    
    -- Create the color picker
    local colorPickerContainer = Instance.new("Frame")
    colorPickerContainer.Name = "ColorPickerContainer"
    colorPickerContainer.Size = UDim2.new(1, 0, 0, 140)
    colorPickerContainer.BackgroundTransparency = 1
    colorPickerContainer.Parent = ColorSection -- Assuming Section returns the instance
    
    -- Create the color picker UI
    CreateVapeColorPicker(colorPickerContainer, Color3.fromRGB(255, 255, 255), function(color)
        TracerColor.Value = color
    end)
end)
]]

-- Utility tab
runFunction(function()
    AntiAFK = Tabs.Utility:CreateToggle({
        Name = "AntiAFK",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                if getconnections then                     
                    for i,v in next, getconnections(LocalPlayer.Idled) do
                        v:Disable()
                    end
                else
                    GuiLibrary:CreateNotification("AntiAFK", "Missing getconnections function.", 10, false, "error")
                    AntiAFK:Toggle(true)
                end
            else
                for i,v in next, getconnections(LocalPlayer.Idled) do
                    v:Enable()
                end
            end
        end
    })
end)

runFunction(function()
    AntiFling = Tabs.Utility:CreateToggle({
        Name = "AntiFling",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                RunLoops:BindToHeartbeat("AntiFling", function(Delta)
                    for _, Part in next, LocalPlayer.Character:GetChildren() do
                        if Part:IsA("BasePart") and Part.Name == not "HumanoidRootPart" then
                            Part.CanCollide = false
                        end
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("AntiFling")
                for _, Part in next, LocalPlayer.Character:GetChildren() do
                    if Part:IsA("BasePart") and Part.Name == not "HumanoidRootPart" then
                        Part.CanCollide = true
                    end
                end
            end
        end
    })
end)

--[[patched :sob:
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
	local First = false
    local OldNameCall
    AntiKick = Tabs.Utility:CreateToggle({
        Name = "AntiKick",
        Keybind = nil,
        Callback = function(callback) 
            if callback then
                if hookmetamethod then
                    OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
                        local NameCallMethod = getnamecallmethod()
        
                        if tostring(string.lower(NameCallMethod)) == "kick" and callback and not first then
                            GuiLibrary:CreateNotification("AntiKick", "Detected kick attempt.", 7, false, "warn")
                            return nil
                        end
        
                        return OldNameCall(Self, ...)
                    end)
                    if not First then
                        First = true
                    end
                else
                    GuiLibrary:CreateNotification("AntiKick", "Missing hookmetamethod function.", 10, false)
                    AntiKick:Toggle(true)
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

    local Mode = AutoClickDetector:CreateDropDown({
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
    local AutoRejoinDelay = {Value = 5}
    local AutoRejoinSameServer = {Value = false}
    AutoRejoin = Tabs.Utility:CreateToggle({
        Name = "AutoRejoin",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                repeat wait(AutoRejoinDelay.Value) until AutoRejoin.Enabled == false or #CoreGui.RobloxPromptGui.promptOverlay:GetChildren() ~= 0
                if AutoRejoin.Enabled and not AutoRejoinSameServer then 
                    if #Players:GetPlayers() <= 1 then
                        LocalPlayer:Kick("\nRejoining...")
                        task.wait()
                        TeleportService:Teleport(PlaceId, LocalPlayer)
                    end
                else
                    if #Players:GetPlayers() <= 1 then
                        LocalPlayer:Kick("\nRejoining...")
                        task.wait()
                        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
                    end
                end
            end
        end
    })

    AutoRejoinDelay = AutoRejoin:CreateSlider({
        Name = "Delay",
        Function = function(v) end,
        Min = 0,
        Max = 60,
        Default = 5,
        Round = 0
    })

    AutoRejoinSameServer = AutoRejoin:CreateToggle({
        Name = "SameServer",
        Default = true,
        Function = function() end
    })
end)

runFunction(function()
    CameraUnlock = Tabs.Utility:CreateToggle({
        Name = "CameraUnlock",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                LocalPlayer.CameraMaxZoomDistance = 99999999
            else
                LocalPlayer.CameraMaxZoomDistance = OldCameraMaxZoomDistance
            end
        end
    })
end)

-- not making support for old chat version bc boblox will remove it on 30 april
runFunction(function()
    local chatSpammer = {Enabled = false}
    local mode = {Value = "Random"}
    local spamMessages = {List = {}}
    local delay = {Value = 1}
    local hideFloodMessage = {Value = false}
    local connection, max, current = nil, 0, 1

    chatSpammer = Tabs.Utility:CreateToggle({
        Name = "ChatSpammer",
        Keybind = nil,
        Callback = function(callback) 
            if callback then
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    repeat
                        local msg
                        if mode.Value == "Random" then
                            if #spamMessages.List == 0 then
                                msg = "Maanaaaa was here"
                            else
                                msg = spamMessages.List[math.random(1, #spamMessages.List)]
                            end
                        elseif mode.Value == "Order" then
                            max = #spamMessages.List
                            if #spamMessages.List == 0 then
                                msg = "Maanaaaa was here"
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
                    connection = CoreGui.ExperienceChat:FindFirstChild("RCTScrollContentView").ChildAdded:Connect(function(msg)
                        if msg.ContentText == "You must wait before sending another message." then
                            msg.Visible = false
                            print("detected flood message")
                        end
                    end)
                end
            else
                if connection then
                    connection:Disconnect()
                end
            end
        end
    })

    mode = chatSpammer:CreateDropDown({
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

if Animate and CheckForAllAnimateParams(Animate) == true then
    runFunction(function()
        local IdleAnimation1 = {Value = ""}
        local IdleAnimation2 = {Value = ""}
        local WalkAnimation = {Value = ""}
        local RunAnimation = {Value = ""}
        local JumpAnimation = {Value = ""}
        local FallAnimation = {Value = ""}
        local ClimbAnimation = {Value = ""}
        local SwimIdleAnimation = {Value = ""}
        local SwimAnimation = {Value = ""}
        local OldAnimations = {
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
        CustomAnimations = Tabs.Utility:CreateToggle({
            Name = "CustomAnimations",
            Keybind = nil,
            Callback = function(callback) 
                if callback then 
                    Animate.idle.Animation1.AnimationId = tonumber(IdleAnimation1.Value) and "http://www.roblox.com/asset/?id=" .. IdleAnimation1.Value or IdleAnimation1.Value
                    Animate.idle.Animation2.AnimationId = tonumber(IdleAnimation2.Value) and "http://www.roblox.com/asset/?id=" .. IdleAnimation2.Value or IdleAnimation2.Value
                    Animate.walk.WalkAnim.AnimationId = tonumber(WalkAnimation.Value) and "http://www.roblox.com/asset/?id=" .. WalkAnimation.Value or WalkAnimation.Value
                    Animate.run.RunAnim.AnimationId = tonumber(RunAnimation.Value) and "http://www.roblox.com/asset/?id=" .. RunAnimation.Value or RunAnimation.Value
                    Animate.jump.JumpAnim.AnimationId = tonumber(JumpAnimation.Value) and "http://www.roblox.com/asset/?id=" .. JumpAnimation.Value or JumpAnimation.Value
                    Animate.fall.FallAnim.AnimationId = tonumber(FallAnimation.Value) and "http://www.roblox.com/asset/?id=" .. FallAnimation.Value or FallAnimation.Value
                    Animate.climb.ClimbAnim.AnimationId = tonumber(ClimbAnimation.Value) and "http://www.roblox.com/asset/?id=" .. ClimbAnimation.Value or ClimbAnimation.Value
                    Animate.swimidle.SwimIdle.AnimationId = tonumber(SwimIdleAnimation.Value) and "http://www.roblox.com/asset/?id=" .. SwimIdleAnimation.Value or SwimIdleAnimation.Value
                    Animate.swim.Swim.AnimationId = tonumber(SwimAnimation.Value) and "http://www.roblox.com/asset/?id=" .. SwimAnimation.Value or SwimAnimation.Value
                else
                    Animate.idle.Animation1.AnimationId = OldAnimations.IdleAnimation1
                    Animate.idle.Animation2.AnimationId = OldAnimations.IdleAnimation2
                    Animate.walk.WalkAnim.AnimationId = OldAnimations.WalkAnimation
                    Animate.run.RunAnim.AnimationId = OldAnimations.RunAnimation
                    Animate.jump.JumpAnim.AnimationId = OldAnimations.JumpAnimation
                    Animate.fall.FallAnim.AnimationId = OldAnimations.FallAnimation
                    Animate.climb.ClimbAnim.AnimationId = OldAnimations.ClimbAnimation
                    Animate.swimidle.SwimIdle.AnimationId = OldAnimations.SwimIdleAnimation
                    Animate.swim.Swim.AnimationId = OldAnimations.SwimAnimation
                end
            end
        })

        IdleAnimation1 = CustomAnimations:CreateTextBox({
            Name = "IdleAnimation1",
            PlaceholderText = "Idle Animation1 ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        IdleAnimation2 = CustomAnimations:CreateTextBox({
            Name = "IdleAnimation2",
            PlaceholderText = "Idle Animation1 ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        WalkAnimation = CustomAnimations:CreateTextBox({
            Name = "WalkAnimation",
            PlaceholderText = "Walk Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        RunAnimation = CustomAnimations:CreateTextBox({
            Name = "RunAnimation",
            PlaceholderText = "Run Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        JumpAnimation = CustomAnimations:CreateTextBox({
            Name = "JumpAnimation",
            PlaceholderText = "Jump Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        FallAnimation = CustomAnimations:CreateTextBox({
            Name = "FallAnimation",
            PlaceholderText = "Fall Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        ClimbAnimation = CustomAnimations:CreateTextBox({
            Name = "Climb Animation",
            PlaceholderText = "Climb Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        SwimIdleAnimation = CustomAnimations:CreateTextBox({
            Name = "SwimIdleAnimation",
            PlaceholderText = "Swim Idle Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })

        SwimAnimation = CustomAnimations:CreateTextBox({
            Name = "SwimAnimation",
            PlaceholderText = "Swim Animation ID",
            DefaultValue = "",
            Function = function(v) end,
        })
    end)
end

runFunction(function()
    local commandbar
    local connection
    Tabs.Utility:CreateToggle({
        Name = "ConsoleCommands",
        Keybind = nil,
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
                if connection then connection:Disconnect() end
            end
        end
    })
end)

runFunction(function()
    local GodMode = {Enabled = false}
    local Mode = {Value = "Heal"}
    local HealthThreshold = {Value = 100}
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
                local targetHealth = HealthThreshold.Value
                
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
    
    GodMode = Tabs.Utility:CreateToggle({
        Name = "GodMode",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("GodMode", function()
                    if isAlive(LocalPlayer, false, true) then
                        local Character = LocalPlayer.Character
                        local Humanoid = Character.Humanoid
                        local HumanoidRootPart = Character.HumanoidRootPart
                        
                        if not isInitialized then
                            if not initializeGodMode(Character, Humanoid, HumanoidRootPart) then
                                retryAttempts = retryAttempts + 1
                                if retryAttempts >= maxRetryAttempts then
                                    showNotification("GodMode", "Failed to initialize after multiple attempts. Please try again.", 5)
                                    GodMode:Toggle(false)
                                    return
                                end
                                showNotification("GodMode", "Initializing... Attempt " .. retryAttempts .. "/" .. maxRetryAttempts, 1)
                                task.wait(retryDelay)
                                return
                            end
                            showNotification("GodMode", "Successfully initialized!", 2)
                        end
                        
                        if Mode.Value == "Heal" then
                            applyHealMode(Humanoid)
                        elseif Mode.Value == "HRP" then
                            applyHRPMode(Character, HumanoidRootPart)
                        elseif Mode.Value == "AntiKnockback" then
                            applyAntiKnockbackMode(Character, Humanoid)
                        elseif Mode.Value == "Invulnerability" then
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
                            GodMode:SetState(false)
                        end
                    end
                end)
            else
                isInitialized = false
                retryAttempts = 0
                cleanupConnections()
                RunLoops:UnbindFromHeartbeat("GodMode")
                
                if isAlive(LocalPlayer, false, true) then
                    local Character = LocalPlayer.Character
                    local Humanoid = Character.Humanoid
                    
                    restoreOriginalValues(Humanoid)
                    
                    if Mode.Value == "HRP" then
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

    Mode = GodMode:CreateDropDown({
        Name = "Mode",
        List = {"Heal", "HRP", "AntiKnockback", "Invulnerability"},
        Default = "Heal",
        Function = function(v)
            if GodMode.Enabled then
                isInitialized = false
                cleanupConnections()
                showNotification("GodMode", "Mode changed to " .. v .. ". Reinitializing...", 2)
            end
        end
    })
    
    HealthThreshold = GodMode:CreateSlider({
        Name = "Health Threshold",
        Min = 1,
        Max = 200,
        Default = 100,
        Round = 0,
        Function = function(val) 
            if Mode.Value == "Heal" and GodMode.Enabled and connection then
                cleanupConnections()
                
                if isAlive(LocalPlayer, false, true) then
                    local Humanoid = LocalPlayer.Character.Humanoid
                    applyHealMode(Humanoid)
                end
            end
        end
    })
end)

runFunction(function()
    local ProximityPromptsHoldDuration = {Value = 0.1}
    local FastProximityPromptsEnabled = false
    local ChangedObjects = {}
    FastProximityPrompts = Tabs.Utility:CreateToggle({
        Name = "FastProximityPrompts",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FastProximityPromptsEnabled = true
                for _, ProximityObject in pairs(workspace:GetDescendants()) do
                    if ProximityObject:IsA("ProximityPrompt") then
                        ChangedObjects[ProximityObject] = ProximityObject.HoldDuration
                        ProximityObject.HoldDuration = ProximityPromptsHoldDuration.Value
                    end
                end
            else
                FastProximityPromptsEnabled = false
                for ProximityObject, OriginalHoldDuration in pairs(ChangedObjects) do
                    if ProximityObject:IsA("ProximityPrompt") then
                        ProximityObject.HoldDuration = OriginalHoldDuration
                    end
                end
                table.clear(ChangedObjects)
            end
        end
    })

    ProximityPromptsHoldDuration = FastProximityPrompts:CreateSlider({
        Name = "HoldDuration",
        Function = function(v)
            if FastProximityPromptsEnabled then
                for _, Object in pairs(workspace:GetDescendants()) do
                    if Object:IsA("ProximityPrompt") then
                        Object.HoldDuration = ProximityPromptsHoldDuration.Value
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
    FPSUnlocker = Tabs.Utility:CreateToggle({
        Name = "FPSUnlocker",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                if setfpscap then
                    setfpscap(10000000)
                else
                    GuiLibrary:CreateNotification("FPSUnlocker", "Missing setfpscap function.", 10, false, "error")
                    FPSUnlocker:Toggle(true)
                    return
                end
            end
        end
    })
end)

runFunction(function()
    InfinityJump = Tabs.Utility:CreateToggle({
        Name = "InfinityJump",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                UserInputService.JumpRequest:Connect(function()
                    if callback then
                        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
                    end
                end)
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
    ServerHop = Tabs.Utility:CreateToggle({
        Name = "ServerHop",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                ServerHop:Toggle(false, false)
                TeleportService:Teleport(PlaceId)
            end
        end
    })
end)

-- World tab
runFunction(function()
    local AntiVoid = {Enabled = false}
    local Mode = {Value = "Jump"}
    local Delay = {Value = 0.1}
    local BounceForce = {Value = 150}
    local TPtoSpawnLocation = {Value = false}
    local positionsaveinterval = 0.5
    local LastSafePosition = nil
    local LastSaveTime = 0
    local PositionSaveAccumulator = 0
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
            
            if Mode.Value == "Jump" and AntiVoidPlatform then
                AntiVoidPlatform.CFrame = CFrame.new(RootPart.Position.X, voidYpos, RootPart.Position.Z)
                
                Humanoid.JumpPower = BounceForce.Value
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
                    
                    if spawnLocation and TPtoSpawnLocation.Value then
                        RootPart.CFrame = spawnLocation.CFrame * CFrame.new(0, 5, 0)
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    else
                        RootPart.CFrame = CFrame.new(RootPart.Position.X, math.abs(voidYpos), RootPart.Position.Z)
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
            
            task.delay(Delay.Value, function()
                Humanoid.JumpPower = oldjumppower
                IsBeingRescued = false
            end)
        end
    end

    AntiVoid = Tabs.World:CreateToggle({
        Name = "AntiVoid",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AntiVoid", function()
                    if Mode.Value == "Jump" then
                        if not AntiVoidPlatform then
                            AntiVoidPlatform = Instance.new("Part")
                            AntiVoidPlatform.Name = "AntiVoidPlatform"
                            AntiVoidPlatform.Size = Vector3.new(400, 1, 400)
                            AntiVoidPlatform.Anchored = true
                            AntiVoidPlatform.CanCollide = true
                            AntiVoidPlatform.Transparency = 1
                            AntiVoidPlatform.Parent = workspace
                        end

                        connection = RunService.Stepped:Connect(function(deltaTime)
                            local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if AntiVoid.Enabled then
                                savePosition(deltaTime)
                                RescueFromVoid()
                                
                                if Mode.Value == "Jump" and AntiVoidPlatform and RootPart and RootPart.Position.Y > (voidYpos + math.abs(voidYpos)) then
                                    AntiVoidPlatform.CFrame = CFrame.new(RootPart.Position.X, voidYpos - 50, RootPart.Position.Z)
                                end
                            end
                        end)
                    end
                end)
            else
                RunLoops:UnbindFromRenderStep("AntiVoid")
                if AntiVoidPlatform then
                    AntiVoidPlatform:Destroy()
                end
                if connection then
                    connection:Disconnect()
                end
            end
        end
    })

    Mode = AntiVoid:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Jump", "Teleport"},
        Default = "Jump"
    })

    Delay = AntiVoid:CreateSlider({
        Name = "PosCheckDelay",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0.1,
        Round = 1
    })

    BounceForce = AntiVoid:CreateSlider({
        Name = "Bounce Force",
        Function = function(v) end,
        Min = 0,
        Max = 500,
        Default = 150,
        Round = 0
    })

    TPtoSpawnLocation = AntiVoid:CreateToggle({
        Name = "TP to Spawn Location",
        Default = false,
        Function = function(v) end
    })
end)

--[[next week
runFunction(function()
    local atmosphereModule = {Enabled = false}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local decay = {Value = Color3.fromRGB(255, 255, 255)}
    local density = {Value = 0.5}
    local glare = {Value = 0.5}
    local haze = {Value = 0.5}
    local offset = {Value = 0.5}
    local atmosphere

    atmosphereModule = Tabs.World:CreateToggle({
        Name = "Atmopshere",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                atmosphere = Instance.new("Atmosphere")
                atmosphere.Color = color.Value
                atmosphere.Decay = decay.Value
                atmosphere.Density = density.Value
                atmosphere.Glare = glare.Value
                atmosphere.Haze = haze.Value
                atmosphere.Offset = offset.Value
                atmosphere.Parent = Lighting
            else
                if atmosphere then
                    atmosphere:Destroy()
                end
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
]]

runFunction(function()
    local GravityValue = {Value = 18}
    local GravityEnabled = false
    Gravity = Tabs.World:CreateToggle({
        Name = "Gravity",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                GravityEnabled = true
                workspace.Gravity = GravityValue.Value
            else
                GravityEnabled = false
                workspace.Gravity = workspaceGravity
            end
        end
    })
    
    GravityValue = Gravity:CreateSlider({
        Name = "Gravity",
        Function = function(v)
            if GravityEnabled then
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
    local OldLighting = {
        ShadowSoftness = Lighting.ShadowSoftness,
        Brightness = Lighting.Brightness
    }
    local ShadowSoftness = {Value = 1}
    local Brightness = {Value = 1}
    local SunRaysIntensity = {Value = 1}
    local Spread = {Value = 1}
    local BloomIntensity = {Value = 1}
    local BloomSize = {Value = 1}
    local BloomObject
    local SunRaysObject
    local OldLightingObjects
    local CustomLightingEnabled = false
    local LightingChangedConnection
    CustomLighting = Tabs.World:CreateToggle({
        Name = "Lighting",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                CustomLightingEnabled = true
                Lighting.ShadowSoftness = ShadowSoftness.Value
                Lighting.Brightness = Brightness.Value
                for i,v in pairs(Lighting:GetChildren()) do
					if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
						table.insert(OldLightingObjects, v)
						v.Parent = game
					end
				end
                BloomObject = Instance.new("BloomEffect")
                BloomObject.Name = "BloomObject"
                BloomObject.Parent = Lighting
                BloomObject.Intensity = BloomIntensity.Value
                BloomObject.Size = BloomSize.Value

                SunRaysObject = Instance.new("SunRaysEffect")
                SunRaysObject.Name = "SunRaysObject"
                SunRaysObject.Parent = Lighting
                SunRaysObject.Intensity = SunRaysIntensity.Value
                SunRaysObject.Spread = Spread.Value

                LightingChangedConnection = Lighting.LightingChanged:Connect(function()
                    if Lighting:FindFirstChild("BloomObject") then
                        local BloomObject = Lighting:FindFirstChild("BloomObject")
                        BloomObject.Parent = Lighting
                        BloomObject.Intensity = BloomIntensity.Value
                        BloomObject.Size = BloomSize.Value
                    else
                        BloomObject = Instance.new("BloomEffect")
                        BloomObject.Name = "BloomObject"
                        BloomObject.Parent = Lighting
                        BloomObject.Intensity = BloomIntensity.Value
                        BloomObject.Size = BloomSize.Value
                    end

                    if Lighting:FindFirstChild("SunRaysObject") then
                        local SunRaysObject = Lighting:FindFirstChild("SunRaysObject")
                        SunRaysObject = Instance.new("SunRaysEffect")
                        SunRaysObject.Name = "SunRaysObject"
                        SunRaysObject.Parent = Lighting
                        SunRaysObject.Intensity = SunRaysIntensity.Value
                        SunRaysObject.Spread = Spread.Value
                    else
                        SunRaysObject = Instance.new("SunRaysEffect")
                        SunRaysObject.Name = "SunRaysObject"
                        SunRaysObject.Parent = Lighting
                        SunRaysObject.Intensity = SunRaysIntensity.Value
                        SunRaysObject.Spread = Spread.Value
                    end
                end)
            else
                LightingChangedConnection:Disconnect()
                CustomLightingEnabled = false
                Lighting.ShadowSoftness = OldLighting.ShadowSoftness
                Lighting.Brightness = OldLighting.Brightness
                if BloomObject then BloomObject:Destroy() end
                if SunRaysObject then SunRaysObject:Destroy() end
				for i,v in pairs(OldLightingObjects) do
					v.Parent = Lighting
				end
				table.clear(OldLightingObjects)
            end
        end
    })

    ShadowSoftness = CustomLighting:CreateSlider({
        Name = "ShadowSoftness",
        Function = function(v) 
            if CustomLightingEnabled then
                Lighting.ShadowSoftness = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0.5,
        Round = 1
    })

    Brightness = CustomLighting:CreateSlider({
        Name = "Brightness",
        Function = function(v) 
            if CustomLightingEnabled then
                Lighting.Brightness = v
            end
        end,
        Min = 0,
        Max = 10,
        Default = 3,
        Round = 1
    })

    SunRaysIntensity = CustomLighting:CreateSlider({
        Name = "SunRays Intensity",
        Function = function(v) 
            if CustomLightingEnabled then
                SunRaysObject.Intensity = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })

    Spread = CustomLighting:CreateSlider({
        Name = "SunRays Spread",
        Function = function(v) 
            if CustomLightingEnabled then
                SunRaysObject.Spread = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 1
    })

    BloomIntensity = CustomLighting:CreateSlider({
        Name = "Bloom Intensity",
        Function = function(v) 
            if CustomLightingEnabled then
                BloomObject.Intensity = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 1,
        Round = 2
    })

    BloomSize = CustomLighting:CreateSlider({
        Name = "Bloom Intensity",
        Function = function(v) 
            if CustomLightingEnabled then
                BloomObject.Size = v
            end
        end,
        Min = 0,
        Max = 56,
        Default = 56,
        Round = 0
    })
end)

runFunction(function()
    local SkyUp = {Value = ""}
	local SkyDown = {Value = ""}
	local SkyLeft = {Value = ""}
	local SkyRight = {Value = ""}
	local SkyFront = {Value = ""}
	local SkyBack = {Value = ""}
	local SkySun = {Value = ""}
    local SunSize = {Value = 11}
	local SkyMoon = {Value = ""}
    local MoonSize = {Value = 11}
    local OldSkyObjects = {}
    local SkyEnabled = false
    local SkyObject
    local SkyChangedObject
    CustomSky = Tabs.World:CreateToggle({
        Name = "Sky",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                SkyEnabled = true
                for i,v in pairs(Lighting:GetChildren()) do
					if v:IsA("PostEffect") or (v:IsA("Sky") and v.Name == not "SkyObject") then
						table.insert(OldSkyObjects, v)
						v.Parent = game
					end
				end
				SkyObject = Instance.new("Sky")
                SkyObject.Name = "SkyObject"
                SkyObject.Parent = Lighting
				SkyObject.SkyboxBk = "rbxassetid://" .. SkyBack.Value
				SkyObject.SkyboxDn = "rbxassetid://" .. SkyDown.Value
				SkyObject.SkyboxFt = "rbxassetid://" .. SkyFront.Value
				SkyObject.SkyboxLf = "rbxassetid://" .. SkyLeft.Value
				SkyObject.SkyboxRt = "rbxassetid://" .. SkyRight.Value
				SkyObject.SkyboxUp = "rbxassetid://" .. SkyUp.Value
				SkyObject.SunTextureId = "rbxassetid://" .. SkySun.Value
				SkyObject.MoonTextureId = "rbxassetid://" .. SkyMoon.Value
                SkyObject.SunAngularSize = SunSize.Value
                SkyObject.MoonAngularSize = MoonSize.Value

                SkyChangedObject = SkyObject.Changed:Connect(function()
                    SkyObject.SkyboxBk = "rbxassetid://" .. SkyBack.Value
                    SkyObject.SkyboxDn = "rbxassetid://" .. SkyDown.Value
                    SkyObject.SkyboxFt = "rbxassetid://" .. SkyFront.Value
                    SkyObject.SkyboxLf = "rbxassetid://" .. SkyLeft.Value
                    SkyObject.SkyboxRt = "rbxassetid://" .. SkyRight.Value
                    SkyObject.SkyboxUp = "rbxassetid://" .. SkyUp.Value
                    SkyObject.SunTextureId = "rbxassetid://" .. SkySun.Value
                    SkyObject.MoonTextureId = "rbxassetid://" .. SkyMoon.Value
                    SkyObject.SunAngularSize = SunSize.Value
                    SkyObject.MoonAngularSize = MoonSize.Value
                end)
			else
                SkyChangedObject:Disconnect()
                SkyEnabled = false
				if SkyObject then 
                    SkyObject:Destroy() 
                end
				for i,v in pairs(OldSkyObjects) do
					v.Parent = Lighting
				end
				table.clear(OldSkyObjects)
            end
        end
    })

    SkyBack = CustomSky:CreateTextBox({
        Name = "SkyBack",
        PlaceholderText = "Sky Back ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    SkyDown = CustomSky:CreateTextBox({
        Name = "SkyDown",
        PlaceholderText = "Sky Down ID",
        DefaultValue = "6444884785",
        Function = function(v) end,
    })

    SkyFront = CustomSky:CreateTextBox({
        Name = "SkyFront",
        PlaceholderText = "Sky Front ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    SkyLeft = CustomSky:CreateTextBox({
        Name = "SkyLeft",
        PlaceholderText = "Sky Left ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    SkyRight = CustomSky:CreateTextBox({
        Name = "SkyRight",
        PlaceholderText = "Sky Right ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    SkyUp = CustomSky:CreateTextBox({
        Name = "SkyUp",
        PlaceholderText = "Sky Up ID",
        DefaultValue = "6412503613",
        Function = function(v) end,
    })

    SkySun = CustomSky:CreateTextBox({
        Name = "SkySun",
        PlaceholderText = "Sky Sun ID",
        DefaultValue = "6196665106",
        Function = function(v) end,
    })

    SkyMoon = CustomSky:CreateTextBox({
        Name = "SkyMoon",
        PlaceholderText = "Sky Moon ID",
        DefaultValue = "6444320592",
        Function = function(v) end,
    })

    SunSize = CustomSky:CreateSlider({
        Name = "SunSize",
        Function = function(v) 
            if SkyEnabled then
                SkyObject.SunAngularSize = v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 11,
        Round = 0
    })

    MoonSize = CustomSky:CreateSlider({
        Name = "MoonSize",
        Function = function(v) 
            if SkyEnabled then
                SkyObject.MoonAngularSize = v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 11,
        Round = 0
    })
end)

runFunction(function()
    local TimeOfDay = {Enabled = false}
    local Hours = {Value = 13}
    local Minutes = {Value = 0}
    local Seconds = {Value = 0}
    local TimeOfDayEnabled = false
    local Connection
    TimeOfDay = Tabs.World:CreateToggle({
        Name = "TimeOfDay",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                TimeOfDayEnabled = true
                Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value.. ":" .. Seconds.Value
                Connection = Lighting.Changed:Connect(function()
                    Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value.. ":" .. Seconds.Value
                end)
            else
                TimeOfDayEnabled = false
                Lighting.TimeOfDay = LightingTime

                if Connection then
                    Connection:Disconnect()
                end
            end
        end
    })
        
    Hours = TimeOfDay:CreateSlider({
        Name = "Hours",
        Function = function()
            if TimeOfDayEnabled then 
                Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value .. ":" .. Seconds.Value
            end
        end,
        Min = 0,
        Max = 24,
        Default = 13,
        Round = 0
    })
    
    Minutes = TimeOfDay:CreateSlider({
        Name = "Minutes",
        Function = function()
            if TimeOfDayEnabled then 
                Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value.. ":" .. Seconds.Value
            end
        end,
        Min = 0,
        Max = 64,
        Default = 0,
        Round = 0
    })
    
    Seconds = TimeOfDay:CreateSlider({
        Name = "Seconds",
        Function = function()
            if TimeOfDayEnabled then 
                Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value .. ":" .. Seconds.Value
            end
        end,
        Min = 0,
        Max = 64,
        Default = 0,
        Round = 0
    })
end)

-- FE + Trolling tab
runFunction(function()
    local PlayerFollow = {Enabled = false}
    local mode = {Value = "Closest"}
    local player = {Value = ""}


    PlayerFollow = Tabs.FE:CreateToggle({
        Name = "PlayerFollow",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("PlayerFollow", function()
                    if isAlive() then
                        if mode.Value == "Closest" then
                            local closestplr = getClosestPlayer(10000000, false)
                            if closestplr and isAlive(closestplr) then
                                local plrhumanoidRootPart = closestplr.Character.HumanoidRootPart
                                local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                                local backVector = plrhumanoidRootPart.CFrame.LookVector / 2
                                humanoidRootPart.CFrame = plrhumanoidRootPart - backVector
                            else
                                warn("no plr or not alive")
                            end
                        elseif mode.Value == "Custom" then

                        end
                    end
                end)
            else

            end
        end
    })

    mode = PlayerFollow:CreateDropDown({
        Name = "Mode",
        List = {"Closest", "Custom"},
        Default = "Closest",
        Function = function(v)
            if v == "Custom" then
                if player.MainObject then player.MainObject.Visible = true end
            else
                if player.MainObject then player.MainObject.Visible = false end
            end
        end
    })
end)

print("[ManaV2ForRoblox/Universal.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")

-- Private part

--[[
if (Mana.Developer and Mana.Whitelisted) and Tabs.Private then
    local PrivateStartTick = tick()

    runFunction(function()
        local FakeLagSend = {Value = false}
        local FakeLagRecieve = {Value = false}
        FakeLag = Tabs.Private:CreateToggle({
            Name = "FakeLag",
            Keybind = nil,
            Callback = function(callback) 
                if callback then
                    if FakeLagSend.Value then 
                        RunLoops:BindToHeartbeat("SendFakeLag", function() 
                            if isAlive() and sethiddenproperty then
                                sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
                            elseif not sethiddenproperty then
                                GuiLibrary:CreateNotification("FakeLag", "Missing sethiddenproperty function.", 10, false, "error")
                                RunLoops:UnbindFromHeartbeat("SendFakeLag")
                                FakeLag:Toggle(true)
                            end
                        end)
                    end
                    if FakeLagRecieve.Value then 
                        settings().Network.IncomingReplicationLag = 99999999999999999
                    end
                else
                    NetworkClient:SetOutgoingKBPSLimit(math.huge)
                    settings().Network.IncomingReplicationLag = 0
                    RunLoops:UnbindFromHeartbeat("SendFakeLag")
                end
            end
        })
        FakeLagSend = FakeLag:CreateToggle({
            Name = "Sending",
            Function = function() end,
            Default = true
        })
        FakeLagRecieve = FakeLag:CreateToggle({
            Name = "Recieving",
            Function = function() end,
            Default = false
        })
    end)

    runFunction(function()
        Tabs.Private:CreateToggle({
            Name = "HackerDetector(Beta)",
            Keybind = nil,
            Callback = function(callback)
                if callback then
                    spawn(function()
                        repeat
                            task.wait()
                            if (not callback) then return end
                            for i, v in pairs(Players:GetChildren()) do
                                if v:FindFirstChild("HumanoidRootPart") then
                                    local oldpos = v.Character.HumanoidRootPart.Position
                                    task.wait(0.5)
                                    local newpos = Vector3.new(v.Character.HumanoidRootPart.Position.X, 0, v.Character.HumanoidRootPart.Position.Z)
                                    local realnewpos = math.floor((newpos - Vector3.new(oldpos.X, 0, oldpos.Z)).magnitude) * 2
                                    if realnewpos > 32 then
                                        title = v.Name .. " is cheating"
                                        text =  tostring(math.floor((newpos - Vector3.new(oldpos.X, 0, oldpos.Z)).magnitude))
                                        CreateCoreNotification(title, text, 5)
                                    end
                                end
                            end
                        until (not callback)
                    end)
                end
            end
        })
    end)

    --PrivateTabDivider = Tabs.Private:CreateDivider("Tools")

    runFunction(function()
        DarkDex = Tabs.Private:CreateToggle({
            Name = "DarkDex",
            Keybind = nil,
            Callback = function(callback)
                if callback then
                    loadstring(game:HttpGet('https://ithinkimandrew.site/scripts/tools/dark-dex.lua'))()
                end
            end
        })
    end)

    runFunction(function()
        Hydroxide = Tabs.Private:CreateToggle({
            Name = "Hydroxide",
            Keybind = nil,
            Callback = function(callback)
                if callback then
                    local owner = "Upbolt"
                    local branch = "revision"

                    local function webImport(file)
                        return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
                    end

                    webImport("init")
                    webImport("ui/main")
                end
            end
        })
    end)

    runFunction(function()
        InfiniteYeld = Tabs.Private:CreateToggle({
            Name = "InfiniteYeld",
            Keybind = nil,
            Callback = function(callback)
                if callback then
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
                end
            end
        })
    end)

    print("[ManaV2ForRoblox/Universal.lua]: Loaded private version in " .. tostring(tick() - PrivateStartTick) .. ". \n Loaded with private features in " .. tostring(tick() - startTick) .. ".")
end
]]