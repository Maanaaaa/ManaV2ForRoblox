--[[
    Credits to anyones code i used or looked at
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
local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local workspace = workspace
local Workspace = workspace
local game = game -- just don't ask what i'm doing oaky?
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
local CurrentTool = nil

local GuiLibrary = Mana.GuiLibrary
local Tabs = Mana.Tabs
local Functions = Mana.Functions
local RunLoops = Mana.RunLoops
local EntityLibrary = Mana.EntityLibrary

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

--[[
while IsAlive() and wait(0.1) do
    local Tool = Character:FindFirstChildWhichIsA("Tool")
    if Tool then
        CurrentTool = Tool
    end
end
]]

local function IsAlive(Player, headCheck)
    local Player = Player or LocalPlayer
    if Player and Player.Character and ((Player.Character:FindFirstChildOfClass("Humanoid")) and (Player.Character:FindFirstChild("HumanoidRootPart")) and (headCheck and Player.Character:FindFirstChild("Head") or not headCheck)) then
        return true
    else
        return false
    end
end

local function TargetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function IsPlayerTargetable(plr, target)
    return plr ~= LocalPlayer and plr and IsAlive(plr) and TargetCheck(plr, target)
end

local function GetClosestPlayer(MaxDisance, TeamCheck)
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
    local Precent = (Health / MaxHealth) * 100
    if Precent < 70 then 
        return Color3.fromRGB(255, 196, 0)
    elseif Precent < 45 then
        return Color3.fromRGB(255, 71, 71)
    end
    return Color3.fromRGB(96, 253, 48)
end

function IsVisible(Position, WallCheck, ...)
    if not WallCheck then
        return true
    end
    return #Camera:GetPartsObscuringTarget({Position}, {Camera, LocalPlayer.Character, ...}) == 0
end

function GetClosestPlayerToMouse(Fov, TeamCheck, AimPart, WallCheck)
    local AimFov = Fov
    local TargetPosition = nil
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if IsAlive(Player) and Character:FindFirstChild(AimPart) then
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

local ToolAddedConnection = LocalPlayer.Character.ChildAdded:Connect(function(Child)
    if Child:IsA("Tool") then
        CurrentTool = Child
    end
end)

local ToolRemovedConnection = LocalPlayer.Character.ChildRemoved:Connect(function(Child)
    if Child:IsA("Tool") then
        CurrentTool = nil
    end
end)

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

--[[
    ToDo list:
    Add SilentAim - Done
    Rewrite Reach - Done
    Rewrite FastFall - Next update
    Rewrite ForwardTP - Next update
    Rewrite HighJump + LongJump - Next update
    Rewrite SpinBot - Next update
    Rewrite ESP - Done
    Rewrite Tracers - Next update
    Rewrite AntiVoid - Next update

]]
-- Combat tab

runFunction(function()
    local SilentAim = {Enabled = false}
    local AimPart = {Value = "Head"}
    local AimHeld = {Value = "RMB"}
    local SilentAimSmoothness = {Value = 100}
    local SilentAimCircle = {Value = false}
    local SilentAimCircleFilled = {Value = false}
    local SilentAimFov = {Value = 70}
    local SilentAimWallCheck = {Value = false}
    local SilentAimTeamCheck = {Value = false}
    local SilentAimAutoFire = {Value = false}
    local SilentAimAutoFireToolCheck = {Value = false}
    local Circle
    local CircleUpdateConnection
    local MouseClicked

    --FireShoot is from vape

    local function FireShoot(ToolCheck)
        local Player = GetClosestPlayerToMouse(SilentAimFov.Value, SilentAimTeamCheck.Value, AimPart.Value, SilentAimWallCheck.Value)

        if ToolCheck then
            if CurrentTool == nil then
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
                            local Player = GetClosestPlayerToMouse(SilentAimFov.Value, SilentAimTeamCheck.Value, AimPart.Value, SilentAimWallCheck.Value)
                            if Player then
                                AimAt(Player, SilentAimSmoothness.Value, AimPart.Value)
                                if SilentAimAutoFire.Value then
                                    FireShoot(SilentAimAutoFireToolCheck.Value)
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
    
end)

runFunction(function()
    local AutoClickerMode = {Value = "Click"}
    local AutoClickerCPS = {Value = 15}
    AutoClicker = Tabs.Combat:CreateToggle({
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
                        if CurrentTool == not nil and CanClick() then
                            CurrentTool:Active()
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
    local PlayerAddedConnection

    local function UpdatePlayer(Player)
        if IsPlayerTargetable(Player, true) then
            if ReachExpandPart.Value == "HumanoidRootPart" then
                Player.Character.HumanoidRootPart.Size = Vector3.new(2 * (ReachExpand.Value / 10), 2 * (ReachExpand.Value / 10), 1 * (ReachExpand.Value / 10))
            elseif ReachExpandPart.Value == "Head" then
                Player.Character.Head.Size = Vector3.new((ReachExpand.Value / 10), (ReachExpand.Value / 10), (ReachExpand.Value / 10))
            end
        end
    end

    Reach = Tabs.Combat:CreateToggle({
        Name = "Reach",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for _, Player in next, Players:GetPlayers() do
                    UpdatePlayer(Player)
                end
                PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
                    UpdatePlayer(Player)
                end)
            else
                for _, Player in next, Players:GetPlayers() do
                    Player.Character.HumanoidRootPart.Size = Vector3.new(2 * (ReachExpand.Value / 10), 2 * (ReachExpand.Value / 10), 1 * (ReachExpand.Value / 10))
                    Player.Character.Head.Size = Vector3.new((ReachExpand.Value / 10), (ReachExpand.Value / 10), (ReachExpand.Value / 10))
                end
                if PlayerAddedConnection then
                    PlayerAddedConnection:Disconnect()
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
    AutoWalk = Tabs.Movement:CreateToggle({
        Name = "AutoWalk",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToRenderStep("AutoWalk", function()
                    if IsAlive() then
                        LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, -1), true)
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
                        if IsAlive() and callback then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                elseif ClickTPMode.Value == "Click" then
                    MouseConnection1 = Mouse.Button1Down:Connect(function()
                        if IsAlive() and callback and ClickTPMode.Value == "Click" then 
                            LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end)
                elseif ClickTPMode.Value == "RightClick" then
                    MouseConnection2 = Mouse.Button2Down:Connect(function()
                        if IsAlive() and callback and ClickTPMode.Value == "RightClick" then 
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
                if IsAlive() then
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
                if IsAlive() then
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
    local JumpMode = {Value = "Toggle"}
    local HighJumpHeight = {Value = 20}
    local HighJumpForce = {Value = 25}

    HighJump = Tabs.Movement:CreateToggle({
        Name = "HighJump",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                local Character = LocalPlayer.Character
                local Humanoid = Character.Humanoid
                local HumanoidRootPart = Character.HumanoidRootPart
                local VelocityX = HumanoidRootPart.Velocity.X
                local VelocityY = HumanoidRootPart.Velocity.Y
                local VelocityZ = HumanoidRootPart.Velocity.Z

                if JumpMode.Value == "Toggle" then
                    if HighJumpMode.Value == "Jump" then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait()
                        workspace.Gravity = 5
                        spawn(function()
                            for i = 1, HighJumpForce.Value do
                                wait()
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end)
                        spawn(function()
                            for i = 1, HighJumpForce.Value / 28 do
                                task.wait(0.1)
                                Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                                task.wait(0.1)
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end)
                        HighJump:Toggle(false, false)
                    elseif HighJumpMode.Value == "Velocity" then
                        HumanoidRootPart.Velocity = Vector3.new(VelocityX, VelocityY + HighJumpHeight.Value, VelocityZ)
                        HighJump:Toggle(false, false)
                    elseif HighJumpMode.Value == "TP" then
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, HighJumpHeight.Value / 1.5, 0)
                        HighJump:Toggle(false, false)
                    end
                elseif JumpMode.Value == "Normal" then
                    RunLoops:BindToRenderStep("HighJump", function()
                        UserInputService.JumpRequest:Connect(function()
                            if HighJumpMode.Value == "Jump" then
                                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                task.wait()
                                workspace.Gravity = 5
                                spawn(function()
                                    for i = 1, HighJumpForce.Value do
                                        wait()
                                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                    end
                                end)
                                spawn(function()
                                    for i = 1, HighJumpForce.Value / 28 do
                                        task.wait(0.1)
                                        Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                                        task.wait(0.1)
                                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                    end
                                end)
                            elseif HighJumpMode.Value == "Velocity" then
                                HumanoidRootPart.Velocity = Vector3.new(VelocityX, VelocityY + HighJumpHeight.Value, VelocityZ)
                            elseif HighJumpMode.Value == "TP" then
                                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, HighJumpHeight.Value / 1.5, 0)
                            end
                        end)
                    end)
                end
            else
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
            elseif v == "Jump" then
                if HighJumpHeight.MainObject then
                    HighJumpHeight.MainObject.Visible = false
                end
                if HighJumpForce.MainObject then
                    HighJumpForce.MainObject.Visible = true
                end
            end
        end,
        List = {"Jump", "Velocity", "TP"},
        Default = "Velocity"
    })

    JumpMode = HighJump:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Toggle", "Normal"},
        Default = "Toggle"
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
                    if not callback then return end
                    Humanoid.WalkSpeed = 15
                    workspace.Gravity = 23
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -0.2, -2.1)
                    Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                    wait(0.1)
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -0.5, -2.1)
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    wait(0.1)
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0.2, 0)
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    LongJump:Toggle(false)
                elseif LongJumpMode.Value == "Velocity" then
                    local NewVelocity = (OldVelocity * LongJumpPower.Value) / 2.5
                    local NewVelocityY = OldVelocity.Y
                    HumanoidRootPart.Velocity = Vector3.new(NewVelocity.X, NewVelocityY, NewVelocity.X)
                    LongJump:Toggle(false)
                end
            else
                workspace.Gravity = 196.19999694824
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
                if IsAlive() then
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
                                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, AutoJumpPower.Value, HumanoidRootPart.Velocity.Z)
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
                    if IsAlive() then
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
						if IsAlive() then
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
    local ChinaHatTrail
    local ChinaHatEnabled = false
    ChinaHat = Tabs.Render:CreateToggle({
        Name = "ChinaHat",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                RunLoops:BindToHeartbeat("ChinaHat", function()
					if IsAlive() then
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

runFunction(function()
    local EspMode = {Value = "SelectionBox"}
    local EspAdorneePart = {Value = "HumanoidRootPart"}
    local EspSelectionBoxLineThickness = {Value = 0}
    local EspSelectionBoxSurfaceTransparency = {Value = 0}
    local EspBoxHandleAdornmentSizeX = {Value = 1}
    local EspBoxHandleAdornmentSizeY = {Value = 1}
    local EspBoxHandleAdornmentSizeZ = {Value = 1}
    local EspBoxHandleAdornmentAlwaysOnTop = {Value = true}
    local EspHighlightOutline = {Value = true}
    local EspHighlightOutlineTransparency = {Value = 0}
    local EspHighlightFill = {Value = false}
    local EspHighlightFillTransparency = {Value = 0}
    local EspTransparency = {Value = 0.6}
    local EspTeamColor = {Value = false}
    local EspTeammates = {Value = false}
    local PlayerAddedConnection

    local ESPFolder = Instance.new("Folder")
    ESPFolder.Parent = workspace
    ESPFolder.Name = "ESPFolder"

    local ObjectsName = {
        "SelectionBoxObject",
        "BoxHandleAdornmentObject",
        "HighlightObject"
    }

    local function RemoveEsp(Player)
        local Character = Player.Character
        if not Character then return end

        for _, Object in ipairs(ObjectsName) do
            local Object = Character:FindFirstChild(Object)
            if Object then
                Object:Destroy()
            end
        end
    end

    local function UpdateEsp(Player)
        if IsAlive(Player) then
            local Character = Player.Character
            if not Character then return end
            local AdorneePart = EspAdorneePart.Value == "Full Character" and Character or Character:FindFirstChild(EspAdorneePart.Value)
            local color = EspTeamColor.Value and Player.Team and Player.TeamColor or Color3.fromRGB(255, 0, 0)

            if EspMode.Value == "SelectionBox" then
                local BoxObject = Character:FindFirstChild("SelectionBoxObject")
                if not BoxObject then
                    BoxObject = Instance.new("SelectionBox")
                    BoxObject.Name = "SelectionBoxObject"
                    BoxObject.Parent = Character
                end
                BoxObject.Adornee = AdorneePart
                BoxObject.LineThickness = EspSelectionBoxLineThickness.Value
                BoxObject.SurfaceColor3 = color
                BoxObject.SurfaceTransparency = EspSelectionBoxSurfaceTransparency.Value
                BoxObject.Transparency = EspTransparency.Value
            elseif EspMode.Value == "BoxHandleAdornment" then
                local BoxObject = Character:FindFirstChild("BoxHandleAdornmentObject")
                if not BoxObject then
                    BoxObject = Instance.new("BoxHandleAdornment")
                    BoxObject.Name = "BoxHandleAdornmentObject"
                    BoxObject.Parent = Character
                end
                BoxObject.Adornee = AdorneePart
                BoxObject.Size = Vector3.new(EspBoxHandleAdornmentSizeX.Value, EspBoxHandleAdornmentSizeY.Value, EspBoxHandleAdornmentSizeZ.Value)
                BoxObject.AlwaysOnTop = EspBoxHandleAdornmentAlwaysOnTop.Value
                BoxObject.Color3 = color
                BoxObject.Transparency = EspTransparency.Value
            elseif EspMode.Value == "Highlight" then
                local HighlightObject = Character:FindFirstChild("HighlightObject")
                if not HighlightObject then
                    HighlightObject = Instance.new("Highlight")
                    HighlightObject.Name = "HighlightObject"
                    HighlightObject.Parent = Character
                end
                HighlightObject.Adornee = AdorneePart
                HighlightObject.FillColor = EspHighlightFill.Value and color or Color3.fromRGB(255, 255, 255)
                HighlightObject.FillTransparency = EspHighlightFillTransparency.Value
                HighlightObject.OutlineColor = color
                HighlightObject.OutlineTransparency = EspHighlightOutline.Value and EspHighlightOutlineTransparency.Value or 1
            end
        end
    end

    local Esp = Tabs.Render:CreateToggle({
        Name = "ESP",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                for _, Player in next, Players:GetPlayers() do
                    UpdateEsp(Player)
                end

                PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
                    UpdateEsp(Player)
                end)
            else
                for _, Player in next, Players:GetPlayers() do
                    RemoveEsp(Player)
                end
                if PlayerAddedConnection then
                    PlayerAddedConnection:Disconnect()
                end
            end
        end
    })

    EspAdorneePart = Esp:CreateDropDown({
        Name = "Attach Part",
        List = {"Head", "HumanoidRootPart", "Full Character"},
        Default = "Full Character",
        Callback = function(v) end
    })

    EspMode = Esp:CreateDropDown({
        Name = "Mode",
        List = {"SelectionBox", "BoxHandleAdornment", "Highlight"},
        Default = "SelectionBox",
        Callback = function(v)
            local modeVisibility = {
                SelectionBox = {EspSelectionBoxLineThickness, EspSelectionBoxSurfaceTransparency},
                BoxHandleAdornment = {EspBoxHandleAdornmentSizeX, EspBoxHandleAdornmentSizeY, EspBoxHandleAdornmentSizeZ},
                Highlight = {EspHighlightOutline, EspHighlightFill}
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

    EspSelectionBoxLineThickness = Esp:CreateSlider({
        Name = "Line Thickness",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    EspSelectionBoxSurfaceTransparency = Esp:CreateSlider({
        Name = "Surface Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 10,
        Default = 1,
        Round = 1
    })

    EspBoxHandleAdornmentSizeX = Esp:CreateSlider({
        Name = "Box Size X",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    EspBoxHandleAdornmentSizeY = Esp:CreateSlider({
        Name = "Box Size Y",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    EspBoxHandleAdornmentSizeZ = Esp:CreateSlider({
        Name = "Box Size Z",
        Function = function(v) end,
        Min = 1,
        Max = 10,
        Default = 1,
        Round = 1
    })

    EspHighlightOutline = Esp:CreateToggle({
        Name = "Outline",
        Default = true,
        Function = function(v)
            EspHighlightOutlineTransparency.MainObject.Visible = v
        end
    })

    EspHighlightOutlineTransparency = Esp:CreateSlider({
        Name = "Outline Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    EspHighlightFill = Esp:CreateToggle({
        Name = "Fill",
        Default = true,
        Function = function(v)
            EspHighlightFillTransparency.MainObject.Visible = v
        end
    })

    EspHighlightFillTransparency = Esp:CreateSlider({
        Name = "Fill Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    EspTransparency = Esp:CreateSlider({
        Name = "ESP Transparency",
        Function = function(v) end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    EspTeammates = Esp:CreateToggle({
        Name = "Teammates",
        Default = false,
        Function = function(v) end
    })

    EspTeamColor = Esp:CreateToggle({
        Name = "TeamColor",
        Default = false,
        Function = function(v) end
    })
end)

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
                Lighting.Changed:Connect(function()
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
                end)
            else
                for Name, Value in pairs(LightingParameters) do
                    Lighting[Name] = Value
                end
            end
        end
    })  
end)

runFunction(function()
    local Hours = {Value = 13}
    local Minutes = {Value = 0}
    local Seconds = {Value = 0}
    local TimeOfDayEnabled = false
    local Connection
    TimeOfDay = Tabs.Render:CreateToggle({
        Name = "TimeOfDay",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                TimeOfDayEnabled = true
                Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value.. ":" .. Seconds.Value
                LightingChangedConnection = Lighting.Changed:Connect(function()
                    Lighting.TimeOfDay = Hours.Value .. ":" .. Minutes.Value.. ":" .. Seconds.Value
                end)
            else
                TimeOfDayEnabled = false
                Lighting.TimeOfDay = LightingTime

                if LightingChangedConnection then
                    LightingChangedConnection:Disconnect()
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

--[[next update
runFunction(function()
    local TracerStartPoint = {Value = "Mouse"}
    local TracerThickness = {Value = 2}
    local TracerTransparency = {Value = 0}
    local TracerTeamCheck = {Value = true}
    local Lines = {}
    local PlayerRemovingConnection

    local function UpdateTracers()
        for _, Player in pairs(Players:GetPlayers()) do
            if IsAlive(Player) and Player ~= LocalPlayer and (not TracerTeamCheck.Value or Player.Team ~= LocalPlayer.Team) then
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

--[[ next update
runFunction(function()
    local Tracers = {Enabled = false}

    Tracers = Tabs.Render:CreateToggle({
        Name = "Tracers",
        Keybind = nil,
        Callback = function(callback)
            if callback then

            else

            end
        end
    })
end)
]]

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
                    AntiKick:Toggle(true)
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
                    GuiLibrary:CreateNotification("AntiKick", "Missing hookmetamethod function.", 10, false, "error")
                    AntiKick:Toggle(true)
                    return
                end
            end
        end
    })
end)

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

--[[
runFunction(function()
    local SpamMessage = {Value = ""}
    local Delay  = {Value = 1}
    ChatSpammer = Tabs.Utility:CreateToggle({
        Name = "ChatSpammer",
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
]]

if Animate and CheckForAllAnimateParams(Animate) == true then
    print("CustomAnimations running.")
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
                if IsAlive() then 
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

--[[
runFunction(function()
    local AntiVoidMode = {Value = "Part"}
    local AntiVoidPartMode = {Value = "Velocity"}
    local AntiVoidPartTransparency = {Value = 0}
    local AntiVoidJumpDelay = {Value = 0.2}
    local AntiVoidEnabled = false
    local AntiVoidPart

    AntiVoid = Tabs.World:CreateToggle({
        Name = "AntiVoid",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                AntiVoidEnabled = true
                spawn(function()
                    RunLoops:BindToHeartbeat("AntiVoid", function()
                        if IsAlive() then
                            local Character = LocalPlayer.Character
                            local HumanoidRootPart = Character.HumanoidRootPart
                            local Humanoid = Character.Humanoid
                            
                            local RaycastParams = RaycastParams.new()
                            RaycastParams.RespectCanCollide = true
                            local LastRaycast

                            if AntiVoidMode.Value == "Part" then
                                if not AntiVoidPart or not AntiVoidPart.Parent then
                                    AntiVoidPart = Instance.new("Part")
                                    AntiVoidPart.Parent = workspace
                                    AntiVoidPart.Size = Vector3.new(2100, 0.5, 2000)
                                    AntiVoidPart.CFrame = HumanoidRootPart.CFrame - Vector3.new(0, 20, 0)
                                    AntiVoidPart.Transparency = AntiVoidPartTransparency.Value
                                    AntiVoidPart.Anchored = true
                                    AntiVoidPart.Touched:Connect(function(Toucher)
                                        if AntiVoidPartMode.Value == "Jump" then
                                            if Toucher.Parent.Name == LocalPlayer.Name then
                                                Humanoid:ChangeState("Jumping")
                                                wait(AntiVoidJumpDelay.Value)
                                                Humanoid:ChangeState("Jumping")
                                                wait(AntiVoidJumpDelay.Value)
                                                Humanoid:ChangeState("Jumping")
                                                Humanoid:ChangeState("Jumping")
                                            end
                                        elseif AntiVoidPartMode.Value == "Veocity" then
                                            if Character:WaitForChild("HumanoidRootPart").Position.Y < 20 then
                                                local BodyVelocity = Instance.new("BodyVelocity", HumanoidRootPart)
                                                workspace.Gravity = 0
                                                BodyVelocity.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 300, HumanoidRootPart.Velocity.Z)
                                                task.wait(0.5)
                                                BodyVelocity:Destroy()
                                                workspace.Gravity = 196.2
                                            end
                                        end
                                    end)
                                end
                            elseif AntiVoidMode.Value == "BodyVelocity" then
                                if Character:WaitForChild("HumanoidRootPart").Position.Y < 20 then
                                    local BodyVelocity = Instance.new("BodyVelocity", HumanoidRootPart)
                                    workspace.Gravity = 0
                                    BodyVelocity.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 300, HumanoidRootPart.Velocity.Z)
                                    task.wait(0.5)
                                    BodyVelocity:Destroy()
                                    workspace.Gravity = 196.2
                                end
                            end
                        end
                    end)
                end)
            else
                AntiVoidEnabled = false
                RunLoops:UnbindFromHeartbeat("AntiVoid")

                if AntiVoidPart then
                    AntiVoidPart:Destroy()
                end
            end
        end
    })

    AntiVoidMode = AntiVoid:CreateDropDown({
        Name = "Mode",
        Function = function(v) end,
        List = {"Part", "BodyVelocity"},
        Default = "Velocity"
    })

    AntiVoidPartMode = AntiVoid:CreateDropDown({
        Name = "PartMode",
        Function = function(v) 
            if v == "Jump" then
                if AntiVoidJumpDelay.MainObject then
                    AntiVoidJumpDelay.MainObject.Visible = true
                end
            elseif v == "Velocity" then
                if AntiVoidJumpDelay.MainObject then
                    AntiVoidJumpDelay.MainObject.Visible = false
                end
            end
        end,
        List = {"Jump", "Velocity"},
        Default = "Velocity"
    })

    AntiVoidPartTransparency = AntiVoid:CreateSlider({
        Name = "Part Transparency",
        Function = function(v)
            if AntiVoidEnabled and AntiVoidPart then
                AntiVoidPart.Transparency = v
            end
        end,
        Min = 0,
        Max = 1,
        Default = 0,
        Round = 1
    })

    AntiVoidJumpDelay = AntiVoid:CreateSlider({
        Name = "Jump Delay",
        Function = function(v) end,
        Min = 0,
        Max = 5,
        Default = 0.2,
        Round = 1
    })
end)
]]

runFunction(function()
    local AntiVoid = {Enabled = false}
    local AntiVoidMode = {Value = ""}
    local AntiVoidPartTransparency = {Value = 0.5}
    local AntiVoidPart

    AntiVoid = Tabs.World:CreateToggle({
        Name = "AntiVoid",
        Keybind = nil,
        Callback = function(callback)
            if callback then
                local AntiVoidPart = Instance.new("Part", Workspace)
                AntiVoidPart.Name = "AntiVoid"
                AntiVoidPart.Size = Vector3.new(2100, 0.5, 2000)
                AntiVoidPart.Position = Vector3.new(160.5, 25, 247.5)
                AntiVoidPart.Transparency = 0.4
                AntiVoidPart.Anchored = true
                AntiVoidPart.Touched:connect(function(Part)
                if Part.Parent:WaitForChild("Humanoid") and Part.Parent.Name == LocalPlayer.Name then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                    wait(0.2)
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                    wait(0.2)
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
            else

            end
        end
    })
end)

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

                Lighting.LightingChanged:Connect(function()
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

                SkyObject.Changed:Connect(function()
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

print("[ManaV2ForRoblox/Universal.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")

-- Private part

if Mana.Developer or Mana.Whitelisted then
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
                            if IsAlive() and sethiddenproperty then
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