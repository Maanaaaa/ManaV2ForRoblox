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
    local silentAim = {Enabled = false}
    local aimPart = {Value = "Head"}
    local held = {Value = "RMB"}
    local smoothness = {Value = 100}
    local circle = {Value = false}
    local circleTransparency = {Value = 0}
    local circleFilled = {Value = false}
    local fov = {Value = 70}
    local wallCheck = {Value = false}
    local teamCheck = {Value = false}
    local autoFire = {Value = false}
    local toolCheck = {Value = false}
    local circleObj
    local CircleUpdateConnection
    local MouseClicked
    local connection
    local LeftConnection
    local RightConnection

    --FireShoot is from vape
    local function fireShoot(ToolCheck)
        local Player = getClosestPlayerToMouse(fov.Value, teamCheck.Value, aimPart.Value, wallCheck.Value)

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

    silentAim = Tabs.Combat:CreateToggle({
        Name = "SilentAim",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                connection = UserInputService.InputBegan:Connect(function(Input)
                    if (held.Value == "RMB" and Input.UserInputType == Enum.UserInputType.MouseButton2) then
                        RightConnection = true
                        LeftConnection = false
                    elseif (held.Value == "LMB" and Input.UserInputType == Enum.UserInputType.MouseButton1) then
                        LeftConnection = true
                        RightConnection = false
                    end

                    RunService:BindToRenderStep("SilentAim", Enum.RenderPriority.Camera.Value + 1, function()
                        if (held.Value == "LMB" and LeftConnection) or (held.Value == "RMB" and RightConnection) then
                            local plr = getClosestPlayerToMouse(fov.Value, teamCheck.Value, aimPart.Value, wallCheck.Value)
                            if plr and isAlive(plr, aimPart.Value == "Head") then
                                AimAt(plr, smoothness.Value, aimPart.Value)
                                if autoFire.Value then
                                    fireShoot(toolCheck.Value)
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

    aimPart = silentAim:CreateDropDown({
        Name = "Aim Part",
        Function = function(v) end,
        List = {"Head", "HumanoidRootPart"},
        Default = "Head",
    })

    held = silentAim:CreateDropDown({
        Name = "Mouse Held",
        Function = function(v) end,
        List = {"LMB", "RMB"},
        Default = "RMB",
    })

    smoothness = silentAim:CreateSlider({
        Name = "Smoothness",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0,
    })

    fov = silentAim:CreateSlider({
        Name = "Fov",
        Function = function(v) end,
        Min = 1,
        Max = 120,
        Default = 70,
        Round = 0,
    })

    teamCheck = silentAim:CreateToggle({
        Name = "Team Check",
        Default = false,
        Function = function(v) end
    })

    wallCheck = silentAim:CreateToggle({
        Name = "Wall Check",
        Default = false,
        Function = function(v) end
    })

    circle = silentAim:CreateToggle({
        Name = "FOV Circle",
        Default = false,
        Function = function(v) 
            if circleTransparency.MainObject then circleTransparency.MainObject.Visible = v end
            if circleFilled.MainObject then circleFilled.MainObject.Visible = v end
			if v then
				UpdateCircle()
			end
        end
    })
    
    circleTransparency = silentAim:CreateSlider({
        Name = "Circle Transparency",
        Function = function(v) 
            UpdateCircle()
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1,
    })

    circleFilled = silentAim:CreateToggle({
        Name = "Circle Filled",
        Default = false,
        Function = function(v) 
            UpdateCircle()
        end
    })

    autoFire = silentAim:CreateToggle({
        Name = "Auto Fire",
        Default = false,
        Function = function(v) 
            if toolCheck.MainObject then toolCheck.MainObject.Visible = v end
        end
    })

    toolCheck = silentAim:CreateToggle({
        Name = "Tool Check",
        Default = false,
        Function = function(v) end
    })
end)

runFunction(function()
    local autoClicker = {Enabled = false}
    local mode = {Value = "Click"}
    local cps = {Value = 15}

    local autoClicker = Tabs.Combat:CreateToggle({
        Name = "AutoClicker",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                spawn(function()
                    repeat
                        if mode.Value == "Click" or mode.Value == "RightClick" then
                            if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
                                if GuiLibrary.ClickGui.Tabs.Visible == false and not UserInputService:GetFocusedTextBox() then
                                    local ClickFunction = (mode.Value == "Click" and mouse1click or mouse2click)
                                    ClickFunction()
                                end
                            end
                        elseif mode.Value == "Tool" then
                            if toolHandler.currentTool == not nil and CurrentTool:IsA("Tool") and CanClick() then
                                toolHandler.currentTool:Active()
                            end
                        end
                    until not autoClicker.Enabled
                end)
            end
        end
    })

    mode = autoClicker:CreateDropDown({
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
    local edited = {}

    local function updatePlayer(plr)
        if not edited[plr] then edited[plr] = true end
        if isAlive(plr, expandPart.Value == "Head") and isPlayerTargetable(plr, true) then
            local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
            if expandPart.Value == "HumanoidRootPart" then
                getHumanoidRootPart(LocalPlayer).Size = Vector3.new(2 * (expand.Value / 10), 2 * (expand.Value / 10), 1 * (expand.Value / 10))
            elseif expandPart.Value == "Head" then
                getHead(LocalPlayer).Size = Vector3.new((expand.Value / 10), (expand.Value / 10), (expand.Value / 10))
            end
        end
    end

    reach = Tabs.Combat:CreateToggle({
        Name = "Reach",
        Keybind = nil,
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
                    getHumanoidRootPart(plr).Size = Vector3.new(2, 2, 1)
                    getHead(plr).Size = Vector3.new(1, 1, 1)
                end
                for _, plr in next, playersHandler.players do
                    if edited[plr] then
                        edited[plr] = nil
                    end
                end
            end
        end
    })

    expandPart = reach:CreateDropDown({
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

-- Movement tab
runFunction(function()
    local autoWalk = {Enabled = false}
    autoWalk = Tabs.Movement:CreateToggle({
        Name = "AutoWalk",
        Keybind = nil,
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
    clickTP = Tabs.Movement:CreateToggle({
        Name = "ClickTP",
        Keybind = nil,
        Callback = function(callback) 
            if callback then
                if mode.Value == "Tool" then
                    tool = Instance.new("Tool")
                    tool.Name = "TPTool"
                    tool.Parent = Backpack
                    tool.RequiresHandle = false
                    tool.Activated:Connect(function()
                        if isAlive() and callback then
                            getHumanoidRootPart(LocalPlayer).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                elseif mode.Value == "Click" then
                    connection = Mouse.Button1Down:Connect(function()
                        if isAlive() and mode.Value == "Click" then 
                            getHumanoidRootPart(LocalPlayer).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                elseif mode.Value == "RightClick" then
                    connection2 = Mouse.Button2Down:Connect(function()
                        if isAlive() and mode.Value == "RightClick" then 
                            getHumanoidRootPart(LocalPlayer).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
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

    mode = clickTP:CreateDropDown({
        Name = "Mode",
        Function = function(v) 
            clickTP:ReToggle()
        end,
        List = {"Click", "RightLick", "Tool"},
        Default = "Click"
    })
end)

local FlyEnabled = false
runFunction(function()
    local mode = {Value = "Normal"}
    local keyboardMode = {Value = "LeftShift+Space"}
    local fly = {Enabled = false}
    local speed = {Value = 23}
    local verticalSpeed = {Value = 20}
    fly = Tabs.Movement:CreateToggle({
        Name = "Fly",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                FlyEnabled = callback
                RunLoops:BindToHeartbeat("Fly", function(Delta)
                    local Humanoid = getHumanoid(LocalPlayer)
                    local HumanoidRootPart = getHumanoidRootPart(LocalPlayer)
                    local MoveDirection = Humanoid.MoveDirection
                    local Velocity = HumanoidRootPart.Velocity
                    local XDirection = MoveDirection.X * speed.Value
                    local ZDirection = MoveDirection.Z * speed.Value
                    local YDirection = 0

                    if verticalSpeed.Value > 0 then
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and (keyboardMode.Value == "LeftShift+Space" or keyboardMode.Value == "LeftCtrl+Space") then 
                            YDirection = verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.E) and keyboardMode.Value == "Q+E" then
                            YDirection = verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and keyboardMode.Value == "LeftShift+Space" then
                            YDirection = -verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and keyboardMode.Value == "LeftShift+Space" then
                            YDirection = -verticalSpeed.Value
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) and keyboardMode.Value == "Q+E" then
                            YDirection = -verticalSpeed.Value
                        end
                    end

                    if mode.Value == "Velocity" then
                        HumanoidRootPart.Velocity = Vector3.new(XDirection, YDirection, ZDirection)
                    elseif mode.Value == "CFrame" then
                        local Factor = speed.Value - Humanoid.WalkSpeed
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

    mode = fly:CreateDropDown({
        Name = "FlyMode",
        Function = function(v) end,
        List = {"CFrame", "Velocity"},
        Default = "Velocity"
    })

    keyboardMode = fly:CreateDropDown({
        Name = "KeyboardMode",
        Function = function(v) end,
        List = {"LeftShift+Space", "Q+E", "LeftCtrl+Space"},
        Default = "LeftShift+Space"
    })

    speed = fly:CreateSlider({
        Name = "FlyWalkSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 23,
        Round = 0
    })

    verticalSpeed = fly:CreateSlider({
        Name = "FlyVerticalSpeed",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 20,
        Round = 0
    })
end)

runFunction(function()
    local fastFall = {Enabled = false}
    local height = {Value = 5}
    local ticks = {Value = 5}
    fastFall = Tabs.Movement:CreateToggle({
        Name = "FastFall",
        Keybind = nil,
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

runFunction(function()
    local forwardTP = {Enabled = false}
    local studs = {Value = 5}
    local teleporting = false
    forwardTP = Tabs.Movement:CreateToggle({
        Name = "ForwardTP",
        Keybind = nil,
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
    local highJump = {Enabled = false}
    local jumpMode = {Value = "Velocity"}
    local jumps = {Value = 5}
    local mode = {Value = "Toggle"}
    local height = {Value = 20}
    local force = {Value = 25}
    local connection

    local function jump()
        local humanoid = getHumanoid(LocalPlayer)
        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
        if mode.Value == "Jump" then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait()
            spawn(function()
                for i = 1, jumps.Value do
                    wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        elseif mode.Value == "Velocity" then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, height.Value, 0)
        elseif mode.Value == "TP" then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, height.Value, 0)
        end
    end

    highJump = Tabs.Movement:CreateToggle({
        Name = "HighJump",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                if mode.Value == "Toggle" then
                    jump()
                    highJump:Toggle(true) 
                elseif mode.Value == "Normal" then
                    RunLoops:BindToRenderStep("HighJump", function()
                        connection = table.insert(connections, UserInputService.JumpRequest:Connect(function()
                            jump()
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

    mode = highJump:CreateDropDown({
        Name = "JumpMode",
        Function = function(v) 
            if v == "Velocity" or v == "TP" then
                if force.MainObject then
                    force.MainObject.Visible = false
                end
                if height.MainObject then
                    height.MainObject.Visible = true
                end
                if jumps.MainObject then
                    jumps.MainObject.Visible = false
                end
            elseif v == "Jump" then
                if height.MainObject then
                    height.MainObject.Visible = false
                end
                if force.MainObject then
                    force.MainObject.Visible = true
                end
                if jumps.MainObject then
                    jumps.MainObject.Visible = true
                end
            end
        end,
        List = {"Jump", "Velocity", "TP"},
        Default = "Velocity"
    })

    mode = highJump:CreateDropDown({
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

    force = highJump:CreateSlider({
        Name = "Force",
        Function = function() end,
        Min = 0,
        Max = 50,
        Default = 25,
        Round = 0
    })
end)

runFunction(function()
    local longJump = {Enabled = false}
    local mode = {Value = "Velocity"}
    local power = {Value = 2}
    longJump = Tabs.Movement:CreateToggle({
        Name = "LongJump",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                local humanoid = getHumanoid(LocalPlayer)
                local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                local oldCFrame = humanoidRootPart.CFrame
                local OldVelocity = humanoidRootPart.Velocity
                if mode.Value == "CFrame" then
                    local newCFrame = oldCFrame * CFrame.new(power.Value, 0, power.Value)
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoidRootPart.CFrame = CFrame.new(newCFrame.X, oldCFrame.Y, newCFrame.Z)
                elseif mode.Value == "Velocity" then
                    local NewVelocity = OldVelocity * power.Value -- (OldVelocity * LongJumpPower.Value) / 2.5
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoidRootPart.Velocity = Vector3.new(NewVelocity.X, OldVelocity.Y, NewVelocity.X)
                end
                longJump:Toggle(true)
            end
        end
    })

    mode = longJump:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"CFrame", "Velocity"},
        Default = "Velocity"
    })

    power = longJump:CreateSlider({
        Name = "Studs",
        Function = function() end,
        Min = 1,
        Max = 10,
        Default = 2,
        Round = 0
    })
end)

runFunction(function()
    local phase = {Enabled = false}
    local parts = {}
    phase = Tabs.Movement:CreateToggle({
        Name = "Phase",
        Keybind = nil,
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
    local speedVal = {Value = 16}
    local autoJump = {Value = false}
    local jumpMode = {Value = "Normal"}
    local autoJumpPower = {Value = 25}
    local jumpPower = {Value = 50}
    local noAnim = {Value = false}
    speed = Tabs.Movement:CreateToggle({
        Name = "Speed",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("Speed", function(Delta)
                    if isAlive() then
                        local Humanoid = getHumanoid(LocalPlayer)
                        local HumanoidRootPart = getHumanoidRootPart(LocalPlayer)
                        local MoveDirection = Humanoid.MoveDirection
                        local VelocityX = HumanoidRootPart.Velocity.X
                        local VelocityZ = HumanoidRootPart.Velocity.Z

                        if jumpPower.Value > Humanoid.JumpPower then
                            Humanoid.JumpPower = jumpPower.Value
                            Humanoid.UseJumpPower = true
                        end

                        if mode.Value == "Velocity" then
                            local Velocity = Humanoid.MoveDirection * (speedVal.Value * 5) * Delta
                            local NewVelocity = Vector3.new(Velocity.X / 10, 0, Velocity.Z / 10)
                            Character:TranslateBy(NewVelocity)
                        elseif mode.Value == "CFrame" then
                            local Factor = speedVal.Value - Humanoid.WalkSpeed
                            local MoveDirection = (MoveDirection * Factor) * Delta
                            local NewCFrame = HumanoidRootPart.CFrame + Vector3.new(MoveDirection.X, 0, MoveDirection.Z)

                            HumanoidRootPart.CFrame = NewCFrame
                        elseif mode.Value == "Normal" then
                            Humanoid.WalkSpeed = speedVal.Value
                        end

                        if autoJump.Value and (Humanoid.FloorMaterial ~= Enum.Material.Air) and Humanoid.MoveDirection ~= Vector3.zero then
                            if jumpMode == "Normal" then
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            else
                                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, autoJumpPower.Value, HumanoidRootPart.Velocity.Z)
                            end
                        end

                        if noAnim.Value then
                            Character.Animate.Disabled = true
                        end

                    end
                end)
            else
                if RunLoops.HeartTable.Speed then
                    RunLoops:UnbindFromHeartbeat("Speed")
                end

                getHumanoid(LocalPlayer).WalkSpeed = PlayerWalkSpeed
                getHumanoid(LocalPlayer).JumpPower = PlayerJumpPower
                getCharacter(LocalPlayer).Animate.Disabled = true
            end
        end
    })

    mode = speed:CreateDropDown({
        Name = "Mode",
        Function = function(v) 
            speed:ReToggle(true)
        end,
        List = {"CFrame", "Normal", "Velocity"},
        Default = "Normal"
    })

    jumpMode = speed:CreateDropDown({
        Name = "AutoJumpMode",
        Function = function(v) 
            if autoJumpPower.MainObject then
                autoJumpPower.MainObject.Visible = v == "Velocity"
            end
            speed:ReToggle(true)
        end,
        List = {"Normal", "Velocity"},
        Default = "Normal"
    })

    speedVal = speed:CreateSlider({
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
                getHumanoid(getCharacter(LocalPlayer)).JumpPower = v
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
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("SpinBot", function()
                    if isAlive() then
                        local humanoid = getHumanoid(LocalPlayer)
                        local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                        local OldVelocity = humanoidRootPart.AssemblyAngularVelocity
                        velocityX = (spinBotX.Value and spinBotSpeed.Value) or OldVelocity.X
                        velocityY = (spinBotY.Value and spinBotSpeed.Value) or OldVelocity.Y
                        velocityZ = (spinBotZ.Value and spinBotSpeed.Value) or OldVelocity.Z
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

    mode = spinBot:CreateDropDown({
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


-- Render tab
runFunction(function()
    local breadcrumbs = {Enabled = false}
    local breadcrumbsStartColor = {Value = Color3.fromRGB(255, 255, 255)}
    local breadcrumbsEndColor = {Value = Color3.fromRGB(255, 255, 255)}
    local breadcrumbsLifeTime = {Value = 20}
    local breadcrumbsTransparency = {Value = 0}
    local breadcrumbsThick = {Value = 7}
    local breadcrumbsTrail
	local breadcrumbsAttachment
	local breadcrumbsAttachment2
    breadcrumbs = Tabs.Render:CreateToggle({
        Name = "Breadcrumbs",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                task.spawn(function()
					repeat
						if isAlive() then
                            local humanoidRootPart = getHumanoidRootPart(LocalPlayer)
                            if not breadcrumbsTrail then
                                breadcrumbsAttachment = Instance.new("Attachment")
                                breadcrumbsAttachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
                                breadcrumbsAttachment2 = Instance.new("Attachment")
                                breadcrumbsAttachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
                                breadcrumbsTrail = Instance.new("Trail")
                                breadcrumbsTrail.Attachment0 = breadcrumbsAttachment
                                breadcrumbsTrail.Attachment1 = breadcrumbsAttachment2
                                breadcrumbsTrail.Color = ColorSequence.new(breadcrumbsStartColor.Value, breadcrumbsEndColor.Value)
                                breadcrumbsTrail.FaceCamera = true
                                breadcrumbsTrail.Lifetime = breadcrumbsLifeTime.Value / 10
                                breadcrumbsTrail.Enabled = true
                            else
                                local Succes = pcall(function()
                                    breadcrumbsAttachment.Parent = humanoidRootPart
                                    breadcrumbsAttachment2.Parent = humanoidRootPart
                                    breadcrumbsTrail.Parent = Camera
                                end)
                                if not Succes then
                                    if breadcrumbsTrail then breadcrumbsTrail:Destroy() breadcrumbsTrail = nil end
                                    if breadcrumbsAttachment then breadcrumbsAttachment:Destroy() breadcrumbsAttachment = nil end
                                    if breadcrumbsAttachment2 then breadcrumbsAttachment2:Destroy() breadcrumbsAttachment2 = nil end
                                end
                            end
						end
						task.wait(0.3)
					until not breadcrumbs.Enabled
				end)
            else
                if breadcrumbsTrail then
                    breadcrumbsTrail:Destroy()
                    breadcrumbsTrail = nil
                end
				if breadcrumbsAttachment then
                    breadcrumbsAttachment:Destroy()
                    breadcrumbsAttachment = nil
                end
				if breadcrumbsAttachment2 then
                    breadcrumbsAttachment2:Destroy()
                    breadcrumbsAttachment2 = nil
                end
            end
        end
    })

    breadcrumbsStartColor = breadcrumbs:CreateColorSlider({
        Name = "Start color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) 
            if breadcrumbsTrail then
                breadcrumbsTrail.Color = ColorSequence.new(v, breadcrumbsEndColor.Value)
            end
        end
    })

    breadcrumbsEndColor = breadcrumbs:CreateColorSlider({
        Name = "End color",
        Default = Color3.fromRGB(255, 255, 255),
        Function = function(v) 
            if breadcrumbsTrail then
                breadcrumbsTrail.Color = ColorSequence.new(breadcrumbsStartColor.Value, v)
            end
        end
    })

    breadcrumbsLifeTime = breadcrumbs:CreateSlider({
        Name = "LifeTime",
        Function = function(v) end,
        Min = 1,
        Max = 100,
        Default = 10,
        Round = 0
    })

    breadcrumbsTransparency = breadcrumbs:CreateSlider({
        Name = "Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    breadcrumbsThick = breadcrumbs:CreateSlider({
        Name = "Thick",
        Function = function(v) end,
        Min = 1,
        Max = 50,
        Default = 7,
        Round = 2
    })
end)

runFunction(function()
    local camFix = {Enabled = false}
    camFix = Tabs.Render:CreateToggle({
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
    local chams = {Enabled = false}
    local mode = {Value = "SelectionBox"}
    local fillMode = {Value = "Team"}
    local adorneePart = {Value = "HumanoidRootPart"}
    local color = {Value = Color3.fromRGB(255, 0, 0)}
    local fillColor = {Value = Color3.fromRGB(255, 0, 0)}
    local lineThickness = {Value = 0}
    local surfaceTransparency = {Value = 0}
    local alwaysOnTop = {Value = true}
    local outline = {Value = true}
    local outlineColor = {Value = Color3.fromRGB(255, 0, 0)}
    local outlineTransparency = {Value = 0}
    local fill = {Value = false}
    local fillTransparency = {Value = 0}
    local transparency = {Value = 0.6}
    local useTeamColor = {Value = false}
    local teammates = {Value = false}
    local connection
    local connection2

    local chamsFolder = Instance.new("Folder")
    chamsFolder.Parent = workspace
    chamsFolder.Name = "chamsFolder"

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
        if chams.Enabled and isAlive(Player) then
            local Character = getCharacter(Player)
            local AdorneePart = adorneePart.Value == "Full Character" and Character or Character:FindFirstChild(adorneePart.Value)
            local teamColor = useTeamColor.Value and Player.Team and Player.TeamColor
            local color = useTeamColor.Value and Player.Team and Player.TeamColor or color.Value

            if mode.Value == "SelectionBox" then
                local BoxObject = Character:FindFirstChild("SelectionBoxObject")
                if not BoxObject then
                    BoxObject = Instance.new("SelectionBox")
                    BoxObject.Name = "SelectionBoxObject"
                    BoxObject.Parent = Character
                end
                BoxObject.Adornee = AdorneePart
                BoxObject.LineThickness = lineThickness.Value
                BoxObject.SurfaceColor3 = color
                BoxObject.SurfaceTransparency = surfaceTransparency.Value
                BoxObject.Transparency = transparency.Value
            elseif mode.Value == "BoxHandleAdornment" then
                local BoxObject = Character:FindFirstChild("BoxHandleAdornmentObject")
                if not BoxObject then
                    BoxObject = Instance.new("BoxHandleAdornment")
                    BoxObject.Name = "BoxHandleAdornmentObject"
                    BoxObject.Parent = Character
                end
                BoxObject.Adornee = AdorneePart
                BoxObject.Size = AdorneePart:GetExtentsSize()
                BoxObject.AlwaysOnTop = alwaysOnTop.Value
                BoxObject.Color3 = color
                BoxObject.Transparency = transparency.Value
            elseif mode.Value == "Highlight" then
                local HighlightObject = Character:FindFirstChild("HighlightObject")
                if not HighlightObject then
                    HighlightObject = Instance.new("Highlight")
                    HighlightObject.Name = "HighlightObject"
                    HighlightObject.Parent = Character
                end
                HighlightObject.Adornee = AdorneePart
                HighlightObject.FillColor = color
                HighlightObject.FillTransparency = (fill.Value and fillTransparency.Value) or 1
                HighlightObject.OutlineColor = color
                HighlightObject.OutlineTransparency = (outline.Value and outlineTransparency.Value) or 1
            end
        end
    end

    local function updateAll()
        for _, plr in next, Players:GetPlayers() do
            UpdateChams(plr)
        end
    end

    chams = Tabs.Render:CreateToggle({
        Name = "Chams",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for _, plr in next, Players:GetPlayers() do
                    UpdateChams(plr)
                    connection = plr.CharacterAdded:Connect(function()
                        UpdateChams(plr)
                    end)
                end
                connection2 = Players.PlayerAdded:Connect(function(plr)
                    UpdateChams(plr)
                end)
            else
                for _, plr in next, Players:GetPlayers() do
                    RemoveChams(plr)
                end
                if connection then
                    connection:Disconnect()
                end
                if connection2 then
                    connection2:Disconnect()
                end
            end
        end
    })

    mode = chams:CreateDropDown({
        Name = "Mode",
        List = {"SelectionBox", "BoxHandleAdornment", "Highlight"},
        Default = "SelectionBox",
        Callback = function(v)
            local modeVisibility = {
                SelectionBox = {lineThickness, surfaceTransparency, color, transparency},
                BoxHandleAdornment = {color, transparency},
                Highlight = {outline, outlineColor, outlineTransparency, fill, fillMode, fillColor, fillTransparency}
            }
    
            for _, group in pairs(modeVisibility) do
                for _, item in ipairs(group) do
                    if item.MainObject then
                        item.MainObject.Visible = false
                    end
                    if item.Type == "OptionToggle" then
                        item:ReToggle()
                    end
                end
            end
    
            for _, item in ipairs(modeVisibility[v]) do
                if item.MainObject then
                    item.MainObject.Visible = true
                end
            end
            if chams.Enabled then
                chams:ReToggle(true)
            end
        end
    })

    fillMode = chams:CreateDropDown({
        Name = "Fill color mode",
        List = {"Team", "Custom"},
        Default = "Team",
        Function = function(v) 
            if color.MainObject then
                color.MainObject.Visible = v == "Custom"
            end
            if teammates.MainObject then
                teammates.MainObject.Visible = v == "Custom"
            end
        end
    })

    color = chams:CreateColorSlider({
        Name = "Color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            updateAll()
        end
    })

    adorneePart = chams:CreateDropDown({
        Name = "Attach Part",
        List = {"Head", "HumanoidRootPart", "Full Character"},
        Default = "Full Character",
        Function = function(v) 
        end
    })

    lineThickness = chams:CreateSlider({
        Name = "Line Thickness",
        Function = function(v) 
            updateAll()
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    surfaceTransparency = chams:CreateSlider({
        Name = "Surface Transparency",
        Function = function(v) 
            updateAll()
        end,
        Min = 0,
        Max = 10,
        Default = 1,
        Round = 1
    })

    outline = chams:CreateToggle({
        Name = "Outline",
        Default = true,
        Function = function(v)
            if outlineColor.MainObject then
                outlineColor.MainObject.Visible = v
            end
            if outlineTransparency.MainObject then
                outlineTransparency.MainObject.Visible = v
            end
        end
    })
    outline.MainObject.Visible = false

    outlineColor = chams:CreateColorSlider({
        Name = "Outline color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v)
            updateAll()
        end
    })
    outlineColor.MainObject.Visible = false

    outlineTransparency = chams:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v) 
            updateAll()
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    outlineTransparency.MainObject.Visible = false

    fill = chams:CreateToggle({
        Name = "Fill",
        Default = true,
        Function = function(v)
            if fillColor.MainObject then
                fillColor.MainObject.Visible = v
            end
            if fillTransparency.MainObject then
                fillTransparency.MainObject.Visible = v
            end
        end
    })
    fill.MainObject.Visible = false

    fillColor = chams:CreateColorSlider({
        Name = "Fill color",
        Default = Color3.fromRGB(255, 0, 0),
        Function = function(v) 
            updateAll()
        end
    })
    fillColor.MainObject.Visible = false

    fillTransparency = chams:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v) 
            updateAll()
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })
    fillTransparency.MainObject.Visible = false

    transparency = chams:CreateSlider({
        Name = "Transparency",
        Function = function(v) 
            updateAll()
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    teammates = chams:CreateToggle({
        Name = "Teammates",
        Default = false,
        Function = function(v) 
            updateAll()
        end
    })

    useTeamColor = chams:CreateToggle({
        Name = "TeamColor",
        Default = false,
        Function = function(v) 
            updateAll()
        end
    })
end)

runFunction(function()
    local chinaHat = {Enabled = false}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local chinaHatTrail
    chinaHat = Tabs.Render:CreateToggle({
        Name = "ChinaHat",
        Keybind = nil,
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
						chinaHatTrail.LocalTransparencyModifier = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude <= 0.6 and 1 or 0)
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
        Keybind = nil,
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
    local fovChanger = {Enabled = false}
    local fov = {Value = 80}
    fovChanger = Tabs.Render:CreateToggle({
        Name = "FovChanger",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Camera.FieldOfView = fov.Value
            else
                Camera.FieldOfView = OldFov
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
        Keybind = nil,
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
        local rootPart = getHumanoidRootPart(plr)
        
        local textLabel = billboardGui:FindFirstChild("NameTagText")
        if not textLabel then return end
        
        local nameText = mode.Value == "Username" and plr.Name or plr.DisplayName
        local parts = {}

        table.insert(parts, string.format("<font color=\"rgb(%d, %d, %d)\">%d</font>", 
            color,
            color,
            color,
            nameText
        ))
        
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
        
        if showDistance.Value and isAlive(LocalPlayer) then
            local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
            table.insert(parts, string.format(" [%dm]", distance))
        end
        
        textLabel.Text = table.concat(parts)
        
        if showDistance.Value and isAlive(LocalPlayer) then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
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
    
    local function DisconnectAll()
        for _, connection in pairs(connections) do
            if typeof(connection) == "RBXScriptConnection" and connection.Connected then
                connection:Disconnect()
            end
        end
        connections = {}
    end

    nameTags = Tabs.Render:CreateToggle({
        Name = "NameTags",
        Keybind = nil,
        Callback = function(callback)
            RunLoops:UnbindFromRenderStep("NameTags")
            DisconnectAll()
            if callback then
                CleanupAllNameTags()
                local playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
                    if nameTags.Enabled then
                        CleanupPlayerNameTag(plr)
                    end
                end)
                table.insert(connections, playerRemovingConn)
                local lastFullUpdate = 0
                RunLoops:BindToRenderStep("NameTags", function()
                    local now = tick()
                    local LocalPlayer = Players.LocalPlayer
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
                    for name, gui in pairs(billboardGuis) do
                        local plr = Players:FindFirstChild(name)
                        if plr and gui.Parent and isAlive(plr) then
                            UpdateNameTag(plr)
                        end
                    end
                end)
            else
                CleanupAllNameTags()
            end
        end
    })

    mode = nameTags:CreateDropDown({
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
    local mode = {Value = "Random"}
    local color = {Value = Color3.fromRGB(255, 255, 255)}
    local delay = {Value = 0.1}
    rainbowSkin = Tabs.Render:CreateToggle({
        Name = "RainbowSkin",
        Keybind = nil,
        Callback = function(callback)
            repeat
                for _, part in pairs(getCharacter(LocalPlayer):GetDescendants()) do
                    if part:IsA("BasePart") then
                        local color = mode.Value == "Random" and Color3.new(math.random(), math.random(), math.random()) or color.Value
                        part.Color = color
                    end
                end
                wait(delay.Value)
            until not callback
        end
    })

    mode = rainbowSkin:CreateDropDown({
        Name = "Mode",
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

--[[not in this update
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
    spawnEsp = Tabs.Render:CreateToggle({
        Name = "SpawnESP",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for _, obj in pairs(workspace:GetDescendants()) do
                    --print("scanning object: " .. obj.Name)
                    if obj:IsA("SpawnLocation") then
                        print("adding")
                        local spawnESP = Instance.new("Highlight")
                        spawnESP.Name = "SpawnESP"
                        spawnESP.Parent = obj
                        spawnESP.Adornee = obj
                        spawnESP.FillColor = fillColor.Value
                        spawnESP.FillTransparency = (outline.Value and fillTransparency.Value) or 1
                        spawnESP.OutlineColor = outlineColor.Value
                        spawnESP.OutlineTransparency = (outline.Value and outlineTransparency.Value) or 1
                        spawnESP.DepthMode = "AlwaysOnTop"
                        table.insert(objects, spawnESP)
                        print("added")
                    end
                end
                connection = workspace.ChildAdded:Connect(function(child)
                    if child:IsA("SpawnLocation") then
                        local spawnESP = Instance.new("Highlight")
                        spawnESP.Name = "SpawnESP"
                        spawnESP.Parent = child
                        spawnESP.Adornee = child
                        spawnESP.FillColor = fillColor.Value
                        spawnESP.FillTransparency = (outline.Value and fillTransparency.Value) or 1
                        spawnESP.OutlineColor = outlineColor.Value
                        spawnESP.OutlineTransparency = (outline.Value and outlineTransparency.Value) or 1
                        spawnESP.DepthMode = "AlwaysOnTop"
                        table.insert(objects, spawnESP)
                    end
                end)
            else
                for _, obj in pairs(objects) do
                    if obj and obj.Parent then
                        obj:Destroy()
                    end
                end
                table.clear(objects)
            end
        end
    })

    outline = spawnEsp:CreateToggle({
        Name = "Outline",
        Default = true,
        Function = function(v)
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
                    obj.OutlineTransparency = v
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
                    obj.FillTransparency = v
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
]]

runFunction(function()
    local viewClip = {Enabled = false}
    viewClip = Tabs.Render:CreateToggle({
        Name = "ViewClip",
        Keybind = nil,
        Callback = function(callback) 
            LocalPlayer.DevCameraOcclusionMode = callback and "Invisicam" or "Zoom"
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
    local antiAFK = {Enabled = false}
    antiAFK = Tabs.Utility:CreateToggle({
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
                    antiAFK:Toggle(true)
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
    local antiFling = {Enabled = false}
    antiFling = Tabs.Utility:CreateToggle({
        Name = "AntiFling",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                RunLoops:BindToHeartbeat("AntiFling", function(Delta)
                    for _, part in next, getCharacter(LocalPlayer):GetChildren() do
                        if part:IsA("BasePart") and part.Name == not "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat("AntiFling")
                for _, part in next, getCharacter(LocalPlayer):GetChildren() do
                    if part:IsA("BasePart") and part.Name == not "HumanoidRootPart" then
                        part.CanCollide = true
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
    local antiKick = {Enabled = false}
	local first = false
    local OldNameCall
    antiKick = Tabs.Utility:CreateToggle({
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
                    if not first then
                        first = true
                    end
                else
                    GuiLibrary:CreateNotification("AntiKick", "Missing hookmetamethod function.", 10, false)
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
    local autoRejoin = {Enabled = false}
    local delay = {Value = 5}
    local sameServer = {Value = false}
    autoRejoin = Tabs.Utility:CreateToggle({
        Name = "AutoRejoin",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                repeat wait(delay.Value) until autoRejoin.Enabled == false or #CoreGui.RobloxPromptGui.promptOverlay:GetChildren() ~= 0
                if autoRejoin.Enabled and sameServer then 
                    if #Players:GetPlayers() <= 1 then
                        LocalPlayer:Kick("\nRejoining...")
                        task.wait()
                        TeleportService:Teleport(PlaceId, LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
                    end
                else
                    if #Players:GetPlayers() <= 1 then
                        LocalPlayer:Kick("\nRejoining...")
                        task.wait()
                        TeleportService:Teleport(PlaceId, LocalPlayer)
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
    cameraUnlock = Tabs.Utility:CreateToggle({
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
                    local ExperienceChat = CoreGui:FindFirstChild("ExperienceChat")
                    if ExperienceChat then
                        local RCTScrollContentView = ExperienceChat:FindFirstChild("RCTScrollContentView")
                        if RCTScrollContentView then
                            connection = RCTScrollContentView.ChildAdded:Connect(function(msg)
                                if msg.ContentText == "You must wait before sending another message." then
                                    msg.Visible = false
                                    print("detected flood message")
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
            Keybind = nil,
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

    mode = godMode:CreateDropDown({
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

runFunction(function()
    local fastProximityPrompts = {Enabled = false}
    local duration = {Value = 0.1}
    local objects = {}
    fastProximityPrompts = Tabs.Utility:CreateToggle({
        Name = "FastProximityPrompts",
        Keybind = nil,
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
        Keybind = nil,
        Callback = function(callback)
            if callback then
                if setfpscap then
                    setfpscap(10000000)
                else
                    GuiLibrary:CreateNotification("FPSUnlocker", "Missing setfpscap function.", 10, false, "error")
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
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                connection = UserInputService.JumpRequest:Connect(function()
                    if callback then
                        getHumanoid(LocalPlayer):ChangeState(3)
                    end
                end)
            else
                if connection then connection:Disconnect() end
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
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                rejoin:Toggle(false, false)
                TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
            end
        end
    })
end)

runFunction(function()
    local serverHop = {Enabled = false}
    serverHop = Tabs.Utility:CreateToggle({
        Name = "ServerHop",
        Keybind = nil,
        Callback = function(callback) 
            if callback then 
                serverHop:Toggle(false, false)
                TeleportService:Teleport(PlaceId)
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
        Keybind = nil,
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

    mode = antiVoid:CreateDropDown({
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
        Keybind = nil,
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
    local gravityValue = {Value = 18}
    local gravityEnabled = false
    gravity = Tabs.World:CreateToggle({
        Name = "Gravity",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                workspace.Gravity = gravityValue.Value
            else
                workspace.Gravity = workspaceGravity
            end
        end
    })
    
    gravityValue = gravity:CreateSlider({
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
        Keybind = nil,
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
    local skyUp = {Value = ""}
	local skyDown = {Value = ""}
	local skyLeft = {Value = ""}
	local skyRight = {Value = ""}
	local skyFront = {Value = ""}
	local skyBack = {Value = ""}
	local skySun = {Value = ""}
    local sunSize = {Value = 11}
	local skyMoon = {Value = ""}
    local moonSize = {Value = 11}
    local oldSkyObjects = {}
    local skyObject
    local connection
    customSky = Tabs.World:CreateToggle({
        Name = "Sky",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for i,v in pairs(Lighting:GetChildren()) do
					if v:IsA("PostEffect") or (v:IsA("Sky") and v.Name == not "SkyObject") then
						table.insert(oldSkyObjects, v)
						v.Parent = game
					end
				end
				skyObject = Instance.new("Sky")
                skyObject.Name = "SkyObject"
                skyObject.Parent = Lighting
				skyObject.SkyboxBk = "rbxassetid://"..skyBack.Value
                skyObject.SkyboxDn = "rbxassetid://"..skyDown.Value
                skyObject.SkyboxFt = "rbxassetid://"..skyFront.Value
                skyObject.SkyboxLf = "rbxassetid://"..skyLeft.Value
                skyObject.SkyboxRt = "rbxassetid://"..skyRight.Value
                skyObject.SkyboxUp = "rbxassetid://"..skyUp.Value
                skyObject.SunTextureId = "rbxassetid://"..skySun.Value
                skyObject.MoonTextureId = "rbxassetid://"..skyMoon.Value
                skyObject.SunAngularSize = sunSize.Value
                skyObject.MoonAngularSize = moonSize.Value

                connection = skyObject.Changed:Connect(function()
                    skyObject.Name = "SkyObject"
                    skyObject.Parent = Lighting
                    skyObject.SkyboxBk = "rbxassetid://"..skyBack.Value
                    skyObject.SkyboxDn = "rbxassetid://"..skyDown.Value
                    skyObject.SkyboxFt = "rbxassetid://"..skyFront.Value
                    skyObject.SkyboxLf = "rbxassetid://"..skyLeft.Value
                    skyObject.SkyboxRt = "rbxassetid://"..skyRight.Value
                    skyObject.SkyboxUp = "rbxassetid://"..skyUp.Value
                    skyObject.SunTextureId = "rbxassetid://"..skySun.Value
                    skyObject.MoonTextureId = "rbxassetid://"..skyMoon.Value
                    skyObject.SunAngularSize = sunSize.Value
                    skyObject.MoonAngularSize = moonSize.Value
                end)
			else
                connection:Disconnect()
				if skyObject then 
                    skyObject:Destroy() 
                end
				for i,v in pairs(oldSkyObjects) do
					v.Parent = Lighting
				end
				table.clear(oldSkyObjects)
            end
        end
    })

    skyBack = customSky:CreateTextBox({
        Name = "SkyBack",
        PlaceholderText = "Sky Back ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    skyDown = customSky:CreateTextBox({
        Name = "SkyDown",
        PlaceholderText = "Sky Down ID",
        DefaultValue = "6444884785",
        Function = function(v) end,
    })

    skyFront = customSky:CreateTextBox({
        Name = "SkyFront",
        PlaceholderText = "Sky Front ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    skyLeft = customSky:CreateTextBox({
        Name = "SkyLeft",
        PlaceholderText = "Sky Left ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    skyRight = customSky:CreateTextBox({
        Name = "SkyRight",
        PlaceholderText = "Sky Right ID",
        DefaultValue = "6444884337",
        Function = function(v) end,
    })

    skyUp = customSky:CreateTextBox({
        Name = "SkyUp",
        PlaceholderText = "Sky Up ID",
        DefaultValue = "6412503613",
        Function = function(v) end,
    })

    skySun = customSky:CreateTextBox({
        Name = "SkySun",
        PlaceholderText = "Sky Sun ID",
        DefaultValue = "6196665106",
        Function = function(v) end,
    })

    skyMoon = customSky:CreateTextBox({
        Name = "SkyMoon",
        PlaceholderText = "Sky Moon ID",
        DefaultValue = "6444320592",
        Function = function(v) end,
    })

    sunSize = customSky:CreateSlider({
        Name = "SunSize",
        Function = function(v) 
            if customSky.Enabled then
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
            if customSky.Enabled then
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
    local timeOfDayEnabled = false
    local connection
    timeOfDay = Tabs.World:CreateToggle({
        Name = "TimeOfDay",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                Lighting.TimeOfDay = hours.Value..":"..minutes.Value..":"..seconds.Value
                connection = Lighting.Changed:Connect(function()
                    Lighting.TimeOfDay = hours.Value..":"..minutes.Value..":"..seconds.Value
                end)
            else
                Lighting.TimeOfDay = LightingTime

                if connection then
                    connection:Disconnect()
                end
            end
        end
    })
        
    hours = timeOfDay:CreateSlider({
        Name = "Hours",
        Function = function(v)
            if timeOfDay then 
                Lighting.TimeOfDay = v..":"..minutes.Value..":"..seconds.Value
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
                Lighting.TimeOfDay = hours.Value..":"..v.. ":"..seconds.Value
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
                Lighting.TimeOfDay = hours.Value..":"..minutes.Value..":"..v
            end
        end,
        Min = 0,
        Max = 60,
        Default = 0,
        Round = 0
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

--Mana.GuiLibrary:LoadConfig()