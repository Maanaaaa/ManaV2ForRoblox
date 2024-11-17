
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local StartSuffix
local EndSuffix
local Functions = _G.Functions

if isfile("NewMana/Modules/KeyStartSuffix.lua") and isfile("NewMana/Modules/KeyEndSuffix.lua") then
    StartSuffix = loadstring(readfile("NewMana/Modules/KeyStartSuffix.lua"))()
    EndSuffix = loadstring(readfile("NewMana/Modules/KeyEndSuffix.lua"))()
elseif isfile("Mana/Modules/KeyStartSuffix.lua") and isfile("Mana/Modules/KeyEndSuffix.lua") then
    StartSuffix = loadstring(readfile("Mana/Modules/KeyStartSuffix.lua"))()
    EndSuffix = loadstring(readfile("Mana/Modules/KeyEndSuffix.lua"))()
else
    StartSuffix = Functions:RunFile("Modules/KeyStartSuffix.lua")
    EndSuffix = Functions:RunFile("Modules/KeyEndSuffix.lua")
end

_G.KeySystemDone = false

local Library = {}

function dragGUI(gui)
    task.spawn(function()
        local dragging
        local dragInput
        local dragStart = Vector3.new(0,0,0)
        local startPos
        local function update(input)
            local delta = input.Position - dragStart
            local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
        end
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end)
end

function Toggle(Button)
    if Button.BackgroundColor3 == Color3.fromRGB(68, 68, 60) then
        Button.BackgroundColor3 = Color3.fromRGB(252, 60, 68)
    else
        Button.BackgroundColor3 = Color3.fromRGB(68, 68, 60)
    end
end

function Library:Create(Argstable)
    local Key = Argstable.Key or "Pomidiros"
    local Callback = Argstable.Callback or function() end
    local VerifiedKeyValue = " " .. StartSuffix .. ":" .. Key .. ":" .. EndSuffix

    local KeySystem = Instance.new("ScreenGui")
    local Background = Instance.new("Frame")
    local TextButton = Instance.new("TextButton")
    local ImageButton = Instance.new("ImageButton")
    local UIListLayout = Instance.new("UIListLayout")
    local OptionFrame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local textboxbackground = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local Label = Instance.new("TextLabel")
    local ActiveFrame = Instance.new("Frame")
    local TextButton_2 = Instance.new("TextButton")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local Label_2 = Instance.new("TextLabel")
    local ActiveFrame_2 = Instance.new("Frame")
    local TextButton_3 = Instance.new("TextButton")

    KeySystem.Name = "KeySystem"
    KeySystem.Parent = CoreGui
    KeySystem.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Background.Name = "Background"
    Background.Parent = KeySystem
    Background.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
    Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Background.BorderSizePixel = 0
    Background.Position = UDim2.new(0.359934866, 0, 0.292452842, 0)
    Background.Size = UDim2.new(0, 207, 0, 40)

    TextButton.Parent = Background
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.BackgroundTransparency = 1.000
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Size = UDim2.new(0, 199, 0, 40)
    TextButton.AutoButtonColor = false
    TextButton.Font = Enum.Font.SourceSans
    TextButton.Text = " Key System | Guest"
    TextButton.TextColor3 = Color3.fromRGB(176, 176, 176)
    TextButton.TextSize = 22.000
    TextButton.TextWrapped = true
    TextButton.TextXAlignment = Enum.TextXAlignment.Left

    ImageButton.Parent = TextButton
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.BackgroundTransparency = 1.000
    ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0.947000027, 0, 0, 5)
    ImageButton.Size = UDim2.new(0, 15, 0, 15)
    ImageButton.Image = "http://www.roblox.com/asset/?id=1411424682"
    ImageButton.ImageColor3 = Color3.fromRGB(154, 154, 154)
    ImageButton.ImageTransparency = 0.300

    UIListLayout.Parent = Background
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    OptionFrame.Name = "OptionFrame"
    OptionFrame.Parent = Background
    OptionFrame.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
    OptionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    OptionFrame.BorderSizePixel = 0
    OptionFrame.Size = UDim2.new(0, 207, 0, 0)
    OptionFrame.AutomaticSize = Enum.AutomaticSize.Y

    TextLabel.Parent = OptionFrame
    TextLabel.Name = "NeededTextLabel"
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(0, 199, 0, 30)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "Welcome " .. LocalPlayer.Name
    TextLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    TextLabel.TextSize = 22.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.LayoutOrder = 1

    textboxbackground.Name = "textboxbackground"
    textboxbackground.Parent = OptionFrame
    textboxbackground.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
    textboxbackground.BackgroundTransparency = 0.500
    textboxbackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
    textboxbackground.BorderSizePixel = 0
    textboxbackground.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
    textboxbackground.Size = UDim2.new(0, 180, 0, 34)
    textboxbackground.LayoutOrder = 2

    TextBox.Parent = textboxbackground
    TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundTransparency = 1.000
    TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.BorderSizePixel = 0
    TextBox.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
    TextBox.Size = UDim2.new(0, 180, 0, 34)
    TextBox.ClearTextOnFocus = false
    TextBox.Font = Enum.Font.SourceSans
    TextBox.PlaceholderText = "Key..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 22.000

    Label.Name = "Label"
    Label.Parent = OptionFrame
    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1.000
    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Label.BorderSizePixel = 0
    Label.Size = UDim2.new(0, 170, 0, 32)
    Label.Font = Enum.Font.SourceSans
    Label.Text = "Check Key"
    Label.TextColor3 = Color3.fromRGB(176, 176, 176)
    Label.TextSize = 22.000
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.LayoutOrder = 3

    ActiveFrame.Name = "ActiveFrame"
    ActiveFrame.Parent = Label
    ActiveFrame.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
    ActiveFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ActiveFrame.BorderSizePixel = 0
    ActiveFrame.Position = UDim2.new(0, 141, 0, 5)
    ActiveFrame.Size = UDim2.new(0, 24, 0, 24)
    ActiveFrame.ZIndex = -3

    TextButton_2.Parent = Label
    TextButton_2.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
    TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_2.BorderSizePixel = 0
    TextButton_2.Position = UDim2.new(0.816999972, 0, 0.074000001, 0)
    TextButton_2.Size = UDim2.new(0, 29, 0, 29)
    TextButton_2.ZIndex = 2
    TextButton_2.AutoButtonColor = false
    TextButton_2.Font = Enum.Font.SourceSans
    TextButton_2.Text = ""
    TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_2.TextSize = 14.000

    UIListLayout_2.Parent = OptionFrame
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 8)

    UIPadding.Parent = OptionFrame
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)

    Label_2.Name = "Label"
    Label_2.Parent = OptionFrame
    Label_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label_2.BackgroundTransparency = 1.000
    Label_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Label_2.BorderSizePixel = 0
    Label_2.Size = UDim2.new(0, 170, 0, 32)
    Label_2.Font = Enum.Font.SourceSans
    Label_2.Text = "Copy Discord Link"
    Label_2.TextColor3 = Color3.fromRGB(176, 176, 176)
    Label_2.TextSize = 22.000
    Label_2.TextXAlignment = Enum.TextXAlignment.Left
    Label_2.LayoutOrder = 4

    ActiveFrame_2.Name = "ActiveFrame"
    ActiveFrame_2.Parent = Label_2
    ActiveFrame_2.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
    ActiveFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ActiveFrame_2.BorderSizePixel = 0
    ActiveFrame_2.Position = UDim2.new(0, 141, 0, 5)
    ActiveFrame_2.Size = UDim2.new(0, 24, 0, 24)
    ActiveFrame_2.ZIndex = -3

    TextButton_3.Parent = Label_2
    TextButton_3.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
    TextButton_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_3.BorderSizePixel = 0
    TextButton_3.Position = UDim2.new(0.816999972, 0, 0.074000001, 0)
    TextButton_3.Size = UDim2.new(0, 29, 0, 29)
    TextButton_3.ZIndex = 2
    TextButton_3.AutoButtonColor = false
    TextButton_3.Font = Enum.Font.SourceSans
    TextButton_3.Text = ""
    TextButton_3.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_3.TextSize = 14.000

    function RemoveAll(ByFile)
        for _, child in ipairs(OptionFrame:GetChildren()) do
            if child.Name ~= "NeededTextLabel" then
                child:Destroy()
            elseif child.Name == "NeededTextLabel" then
                child.Size = UDim2.new(0, 199, 0, 40)
                child.TextColor3 = Color3.fromRGB(140, 220, 140)
                if ByFile then
                    child.Text = "Already was done! Loading.."
                else
                    child.Text = "Correct key! Loading.."
                end
            elseif child == not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
    end
    
    if isfile("Mana/VerifiedKey.lua") then
        print("There's a useful file.")
        local VerifiedKey = loadstring(readfile("Mana/VerifiedKey.lua"))()
        local RealKey = StartSuffix .. ":" .. Key .. ":" .. EndSuffix

        print("RealKey: " .. RealKey)
        print("VerifiedKey: &91%4:Pomidoros:4%19&")
    
        print("Got values.")
        if VerifiedKey == RealKey then
            _G.KeySystemDone = true
            print("Everything is right.")
            RemoveAll(true)
            Callback(true)
            KeySystem:Destroy()
        end
    end

    TextButton_2.MouseButton1Click:Connect(function()
        Toggle(TextButton)
        if TextBox.Text == Key then
            _G.KeySystemDone = true
            TextBox.Text = ""
            writefile("Mana/VerifiedKey.lua", ("return " .. [["]] .. StartSuffix .. ":" .. Key .. ":" .. EndSuffix .. [["]]))
            RemoveAll()
            Callback(true)
            KeySystem:Destroy()
        else
            TextBox.Text = "Invalid key :("
            wait(2)
            TextBox.Text = ""
        end
        Toggle(TextButton)
    end)

    TextButton_3.MouseButton1Click:Connect(function()
        toclipboard("https://discord.gg/gPkD8BdbMA")
    end)

    ImageButton.MouseButton1Click:Connect(function()
        KeySystem:Destroy()
    end)

    return KeySystem
end

return Library