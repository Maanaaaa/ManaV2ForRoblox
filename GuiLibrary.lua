--[[ 
    Credits to anyones code i used or looked at 
]]

repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local getasset = getsynasset or getcustomasset
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local configsaving = true
local LastPress = 0
local Functions = Mana.CustomFileSystem
local Developer = Mana.Developer
local OnMobile
local TabsFrame
local Tabs = {}
local Fonts = {}
local Keybinds = {}
local Library = {
    Device = "None",
    Scale = 1,
    MobileScale = 0.45,
    Sounds = true,
    GuiKeybind = "N",
    Font = Enum.Font.Arial,
    Notifications = true,
    ChatNotifications = true,
    ArrayListObject = {},
    Objects = {},
    Functions = {},
    OriginalTabs = {
        Combat,
        Movement,
        Render,
        Utility,
        World,
        Other
    },
    ThemeManager = {
        CurrentTheme = {},
        ThemeColor = { -- here is default theme
            Tab = {
                TabTitleTextColor3 = "TabData.Color",
                TabTopColor3 = {14, 14, 23}
            },
            TabToggle = {
                UnToggledBackgroundColor3 = {0, 0, 0},
                ToggledBackgroundColor3 = "tabname.TextColor3",
                OptionFrameBackgroundColor3 = {},
                BindTextBackgroundColor3 = {255, 255, 255},
                OptionFrameButton = {255, 255, 255}
            },
            OptionElements = {
                OptionObjectsBackgroundColor3 = {},
                Slider = {
                    SliderBackgroundColor3 = {47, 48, 64},
                    Slider2BackgroundColor3 = "tabname.TextColor3"
                },
                DropDown = {
                    BackgroundColor3 = {255, 255, 255}
                },
                OptionToggle = {
                    ToggledAcativeFrameBackgroundColor3 = "tabname.TextColor3",
                    UnToggledActiveFrameBackgroundColor3 = {68, 68, 60},
                    ToggleButtonBackgroundColor3 = {66, 68, 66}
                },
                TextBox = {
                    TextBoxBackgroundColor3 = "tabname.TextColor3",
                    TextBox2BackgroundColor3 = {47, 48, 64},
                    PlaceholderColor3 = {0, 0, 0}
                }
            },
            TextColor3 = {255, 255, 255},
            Font = Enum.Font.Arial
        }    
    }
}

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Mana"
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.OnTopOfCoreBlur = true -- so if you even get kicked or banned you'll still see gui :)
local ClickGui = Instance.new("Frame", ScreenGui)
ClickGui.Name = "ClickGui"
local NotificationGui = Instance.new("Frame", ScreenGui)
NotificationGui.Name = "NotificationGui"
NotificationGui.BackgroundTransparency = 0
NotificationGui.Size = UDim2.new(0, 100, 0, 10)
NotificationGui.Position = UDim2.new(0, 1735, 0, 820)
NotificationGui.Active = true
NotificationGui.Draggable = true

Library.ScreenGui = ScreenGui
Library.ClickGui = ClickGui
Library.NotificationGui = NotificationGui

if UserInputService.TouchEnabled then
    Library.Device = "Mobile"
end

for i, v in pairs(Enum.Font:GetEnumItems()) do
    Fonts[v.Name] = v
end

Library.FontsList = Fonts

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

-- Config System
if isfolder("Mana") == false then
    makefolder("Mana")
end

if isfolder("Mana/Assets") == false then
    makefolder("Mana/Assets")
end

if isfolder("Mana/Config") == false then
    makefolder("Mana/Config")
end

if isfolder("Mana/Scripts") == false then
    makefolder("Mana/Scripts")
end

if isfolder("Mana/Modules") == false then
    makefolder("Mana/Modules")
end

if isfolder("Mana/Libraries") == false then
    makefolder("Mana/Libraries")
end

local foldername = "Mana/Config"
local conf = {
    file = foldername .. "/" .. game.PlaceId .. ".json",
    functions = {}
}

function conf.functions:MakeFile()
    if isfile("Mana/Config/" .. game.PlaceId .. ".json") then return end
        if not isfolder(foldername) then
            makefolder(foldername)
        end
    writefile("Mana/Config/" .. game.PlaceId .. ".json", "{}")
end

function conf.functions:LoadConfigs()
    if not isfile("Mana/Config/" .. game.PlaceId .. ".json") then
        conf.functions:MakeFile()
    end
    wait(0.5)
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("Mana/Config/" .. game.PlaceId .. ".json"))
    end)
    if success then
        warn("[ManaV2ForRoblox/ConfigSystem]: successfully decoded JSON.")
        return data
    else
        warn("[ManaV2ForRoblox/ConfigSystem]: error in decoding JSON:", data, ".")
        return {}
    end
end

function conf.functions:WriteConfigs(tab)
    conf.functions:MakeFile()
    writefile("Mana/Config/" .. game.PlaceId .. ".json", HttpService:JSONEncode((tab or {})))
end
local configtable = (conf.functions:LoadConfigs() or {})

Library.ConfigSystem = conf
Library.ConfigTable = configtable

--[[ Old AutoSave
spawn(function()
    repeat
        conf.functions:WriteConfigs(configtable)
        task.wait(30)
    until (not configsaving)
end)
]]

-- Themes System
local Themes
local success, err = pcall(function()
    Themes = HttpService:JSONDecode(readfile("NewMana/Themes/OriginalThemes.json"))
end)

if not success then
    warn("[ManaV2ForRoblox]: Failed to load themes: " .. err .. ".")
end

--[[coming soon
function Library.ThemeManager:GetThemes(Type)
    local Themes
    if tostring(string.lower(Type)) == "original" then -- dont ask why
        local success, err = pcall(function()
            Themes = HttpService:JSONDecode(readfile("NewMana/Themes/OriginalThemes.json"))
        end)

        if not success then
            warn("[ManaV2ForRoblox/ThemeManager]: Failed to get original themes: " .. err .. ".")
        end
    elseif tostring(string.lower(Type)) == "custom" then -- dont ask why
        local success, err = pcall(function()
            Themes = HttpService:JSONDecode(readfile("NewMana/Themes/CustomThemes.json"))
        end)

        if not success then
            warn("[ManaV2ForRoblox/ThemeManager]: Failed to get custom themes: " .. err .. ".")
        end
    else
        warn("[ManaV2ForRoblox/ThemeManager]: Failed to get themes, unknown type: " .. Type .. ".")
        return {}
    end
    return Themes
end
]]

--[[release: winter
function Library.ThemeManager:ApplyTheme(ThemeName) -- (Type, ThemeName) 
    local Theme = Themes[ThemeName]
    if not Theme then
        warn("[ManaV2ForRoblox/ThemeManager]: Theme not found: " .. ThemeName or Theme)
        return
    end

    Library.CurrentTheme = Theme
    local ThemeTable = Library.ThemeManager.ThemeColor

    if ThemeName == not "DefaultTheme" then
        -- TabTop
        ThemeTable.Tab.TabTitleTextColor3 = Color3.fromRGB(unpack(Theme.Tab.TabTitleTextColor3))
        ThemeTable.Tab.TabTopColor3 = Color3.fromRGB(unpack(Theme.Tab.TabTopColor3))

        -- Toggle
        ThemeTable.TabToggle.UnToggledBackgroundColor3 = Color3.fromRGB(unpack(Theme.TabToggle.UnToggledBackgroundColor3))
        ThemeTable.TabToggle.ToggledBackgroundColor3 = Color3.fromRGB(unpack(Theme.TabToggle.ToggledBackgroundColor3))
        ThemeTable.TabToggle.OptionFrameBackgroundColor3 = Color3.fromRGB(unpack(Theme.TabToggle.OptionFrameBackgroundColor3))
        ThemeTable.TabToggle.BindTextBackgroundColor3 = Color3.fromRGB(unpack(Theme.TabToggle.BindTextBackgroundColor3))
        ThemeTable.TabToggle.OptionFrameButton = Color3.fromRGB(unpack(Theme.TabToggle.OptionFrameButton))

        -- Slider
        ThemeTable.OptionElements.Slider.SliderBackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.Slider.SliderBackgroundColor3))
        ThemeTable.OptionElements.Slider.Slider2BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.Slider.Slider2BackgroundColor3))

        -- DropDown
        ThemeTable.OptionElements.DropDown.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.DropDown.BackgroundColor3))

        -- OptionToggle
        ThemeTable.OptionElements.OptionToggle.ToggledAcativeFrameBackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.OptionToggle.ToggledAcativeFrameBackgroundColor3))
        ThemeTable.OptionElements.OptionToggle.UnToggledActiveFrameBackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.OptionToggle.UnToggledActiveFrameBackgroundColor3))
        ThemeTable.OptionElements.OptionToggle.ToggleButtonBackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.OptionToggle.ToggleButtonBackgroundColor3))

        -- TextBox
        ThemeTable.OptionElements.TextBox.TextBoxBackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.TextBox.TextBoxBackgroundColor3))
        ThemeTable.OptionElements.TextBox.TextBox2BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.TextBox.TextBox2BackgroundColor3))
        ThemeTable.OptionElements.TextBox.PlaceholderColor3 = Color3.fromRGB(unpack(Theme.OptionElements.TextBox.PlaceholderColor3))

        -- For everything
        ThemeTable.TextColor3 = Color3.fromRGB(unpack(Theme.TextColor3))
    end

    -- Objects updating
    for _, Object in pairs(ScreenGui:GetDescendants()) do
        --print("Applying obj  " .. Object.Name)
        if ThemeName == "DefaultTheme" then
            if Object.Name:find("TabTop") then
                for i, v in pairs(Library.OriginalTabs) do
                    if Object.Name:find(v) then
                        print("Applying tab " .. v.Name)
                        Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.Tab.Tabs[v .. "Tab"]))
                    end
                end
                Object.TextColor3 = Color3.fromRGB(255, 255, 255)
            elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
                Object.TextColor3 = Color3.fromRGB()
                if Object.Name == "Dropdown" then
                    Object.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                elseif Object.Name == "Slider" then
                    Object.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                elseif Object.Name == "ToggleButton" then
                    Object.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
                else
                    --warn("[ManaV2ForRoblox/ThemeManager]: Can't change object's background because it's unknown, object name: " .. Object.Name .. ". (TextLabel or TextButton type, DefaultTheme)")
                end
            elseif Object:IsA("Frame") then
                if Object.Name == "Slider_2" then
                    Object.BackgroundColor3 = tabname.TextColor3
                elseif Object.Name == "ActiveFrame" then
                    Object.BackgroundColor3 = Color3.fromRGB(68, 68, 60)
                elseif Object.Name == "textboxbackground" then
                    Object.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                else
                    --warn("[ManaV2ForRoblox/ThemeManager]: Can't change object's background because it's unknown, object name: " .. Object.Name .. ". (Frame type, DefaultTheme)")
                end
            elseif Object:IsA("TextBox") then
                Object.BackgroundColor3 = tabname.TextColor3
                Object.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            if Object.Name == "TabTop" then
                Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.Tab.TabTopColor3))
                Object.TextColor3 = Color3.fromRGB(unpack(Theme.Tab.TabTopColor3))
            elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
                Object.TextColor3 = Color3.fromRGB(unpack(Theme.TextColor3))
                if Object.Name == "Dropdown" then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.DropDown.BackgroundColor3))
                elseif Object.Name == "Slider" then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.Slider.SliderBackgroundColor3))
                elseif Object.Name == "ToggleButton" then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.OptionToggle.ToggleButtonBackgroundColor3))
                elseif Object.Name:find("_TabbToggleButton") then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.TabToggle.UnToggledBackgroundColor3)) -- // 255, 182, 193
                else
                    --warn("[ManaV2ForRoblox/ThemeManager]: Can't change object's background because it's unknown, object name: " .. Object.Name .. ". (TextLabel or TextButton type, " .. ThemeName .. " theme)")
                end
            elseif Object:IsA("Frame") then
                if Object.Name == "Slider_2" then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.Slider.Slider2BackgroundColor3))
                elseif Object.Name == "ActiveFrame" then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.OptionToggle.ToggledAcativeFrameBackgroundColor3))
                elseif Object.Name == "textboxbackground" then
                    Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.TextBox.TextBoxBackgroundColor3))
                else
                    --warn("[ManaV2ForRoblox/ThemeManager]: Can't change object's background because it's unknown, object name: " .. Object.Name .. " (Frame type, " .. ThemeName .. " theme)")
                end
            elseif Object:IsA("TextBox") then
                Object.BackgroundColor3 = Color3.fromRGB(unpack(Theme.OptionElements.TextBox.TextBox2BackgroundColor3))
                Object.PlaceholderColor3 = Color3.fromRGB(unpack(Theme.OptionElements.TextBox.PlaceholderColor3))
            end
        end
    end
end

--Library.ThemeManager:ApplyTheme("Kawaii :3")
]]

-- Other functions
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

local ColorBox
function Library:MakeRainbowText(Text, Bool)
    local Text = Text or Instance.new("TextLabel")
    spawn(function()
        ColorBox = Color3.fromRGB(170, 0, 170)
        local x = 0
        while wait() do
            ColorBox = Color3.fromHSV(x, 1, 1)
            x = x + 4.5 / 255
            if x >= 1 then
                x = 0
            end
        end
    end)
    spawn(function()
        repeat
            wait()
            if Bool then
                Text.TextColor3 = ColorBox
            end
        until true == false
    end)
end

function Library:MakeRainbowObjectBackground(Object, Bool)
    spawn(function()
        repeat
            wait()
            if Bool then
                Object.BackgroundColor3 = ColorBox
            end
        until true == false
    end)
end

--bettertween and bettertween2 are from future
local function BetterTween(obj, newpos, dir, style, tim, override)
    spawn(function()
        local frame = Instance.new("Frame")
        frame.Visible = false
        frame.Position = obj.Position
        frame.Parent = ScreenGui
        frame:GetPropertyChangedSignal("Position"):Connect(function()
            obj.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
        end)
        pcall(function()
            frame:TweenPosition(newpos, dir, style, tim, override)
        end)
        frame.Parent = nil
        task.wait(tim)
        frame:Remove()
    end)
end

local function BetterTween2(obj, newpos, dir, style, tim, override)
    spawn(function()
        local frame = Instance.new("Frame")
        frame.Visible = false
        frame.Position = obj.Position
        frame.Parent = ScreenGui
        frame:GetPropertyChangedSignal("Position"):Connect(function()
            obj.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, obj.Position.Y.Scale, obj.Position.Y.Offset)
        end)
        pcall(function()
            frame:TweenPosition(newpos, dir, style, tim, override)
        end)
        frame.Parent = nil
        task.wait(tim)
        frame:Remove()
    end)
end

function Library:UpdateFont(NewFont)
    local font = "Enum.Font." .. NewFont
    for i, v in pairs(ScreenGui:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            v.Font = font
        end
    end
end

function Library:RandomString() -- from vape
    local randomlength = math.random(10,100)
    local array = {}

    for i = 1, randomlength do
        array[i] = string.char(math.random(32, 126))
    end

    return table.concat(array)
end

function Library:ToggleLibrary()
    if UserInputService:GetFocusedTextBox() == nil then
        if ClickGui.Visible then
            ClickGui.Visible = false
        else
            ClickGui.Visible = true
        end
    end
end

function Library:RemoveObject(ObjectName) 
    pcall(function()
        if Library.Objects[ObjectName] and Library.Objects[ObjectName].Type == "Toggle" then 
            Library.Objects[ObjectName].Instance:Destroy()
            Library.Objects[ObjectName].OptionFrame:Destroy()
            Library.Objects[ObjectName] = nil
        end
    end)
end

function Library:playsound(id, volume) 
    if Library.Sounds == true then
        local sound = Instance.new("Sound")
        sound.Parent = workspace
        sound.SoundId = id
        if volume then 
            sound.Volume = volume
        end
        sound:Play()
        wait(sound.TimeLength + 2)
        sound:Destroy()
    end
end

function Library:CreateGuiNotification(title, text, delay2, toggled)
    spawn(function()
        if NotificationGui:FindFirstChild("Background") then NotificationGui:FindFirstChild("Background"):Destroy() end
		if Library.Notifications == true then
	        local frame = Instance.new("Frame")
            local frameborder = Instance.new("Frame")
            local frametitle = Instance.new("TextLabel")
            local frametext = Instance.new("TextLabel")

	        frame.Size = UDim2.new(0, 100, 0, 115)
	        frame.Position = UDim2.new(0.5, 0, 0, -115)
	        frame.BorderSizePixel = 0
	        frame.AnchorPoint = Vector2.new(0.5, 0)
	        frame.BackgroundTransparency = 0.5
	        frame.BackgroundColor3 = Color3.new(0, 0, 0)
	        frame.Name = "Background"
	        frame.Parent = NotificationGui

	        frameborder.Size = UDim2.new(1, 0, 0, 8)
	        frameborder.BorderSizePixel = 0
	        frameborder.BackgroundColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frameborder.Parent = frame

	        frametitle.Font = Enum.Font.SourceSansLight
	        frametitle.BackgroundTransparency = 1
	        frametitle.Position = UDim2.new(0, 0, 0, 30)
	        frametitle.TextColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frametitle.Size = UDim2.new(1, 0, 0, 28)
	        frametitle.Text = "          " .. title
	        frametitle.TextSize = 24
	        frametitle.TextXAlignment = Enum.TextXAlignment.Left
	        frametitle.TextYAlignment = Enum.TextYAlignment.Top
	        frametitle.Parent = frame

	        frametext.Font = Enum.Font.SourceSansLight
	        frametext.BackgroundTransparency = 1
	        frametext.Position = UDim2.new(0, 0, 0, 68)
	        frametext.TextColor3 = Color3.new(1, 1, 1)
	        frametext.Size = UDim2.new(1, 0, 0, 28)
	        frametext.Text = "          " .. text
	        frametext.TextSize = 24
	        frametext.TextXAlignment = Enum.TextXAlignment.Left
	        frametext.TextYAlignment = Enum.TextYAlignment.Top
	        frametext.Parent = frame

	        local textsize = TextService:GetTextSize(frametitle.Text, frametitle.TextSize, frametitle.Font, Vector2.new(100000, 100000))
	        local textsize2 = TextService:GetTextSize(frametext.Text, frametext.TextSize, frametext.Font, Vector2.new(100000, 100000))

	        if textsize2.X > textsize.X then textsize = textsize2 end

	        frame.Size = UDim2.new(0, textsize.X + 38, 0, 115)

	        pcall(function()
	            frame:TweenPosition(UDim2.new(0.5, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15)

	            Debris:AddItem(frame, delay2 + 0.15)
	        end)
	    end
    end)
end

local NotificationSize = UDim2.new(0, 300, 0, 100)
local function CreateNewGuiNotification(Titlte, Text, ShowTime, Toggled)
    local Toggled = string.lower(Toggled)

    spawn(function()
		if Library.Notifications == true then
	        local NotificationBackground = Instance.new("Frame")
            local frametitle = Instance.new("TextLabel")
            local frametext = Instance.new("TextLabel")

	        NotificationBackground.Size = UDim2.new(0, 100, 0, 115)
	        NotificationBackground.Position = UDim2.new(0.5, 0, 0, -115)
	        NotificationBackground.BorderSizePixel = 0
	        NotificationBackground.AnchorPoint = Vector2.new(0.5, 0)
	        NotificationBackground.BackgroundTransparency = 0
	        NotificationBackground.BackgroundColor3 = Color3.new(0, 0, 0)
	        NotificationBackground.Name = "Background"
	        NotificationBackground.Parent = NotificationGui

	        frametitle.Font = Enum.Font.SourceSansLight
	        frametitle.BackgroundTransparency = 1
	        frametitle.Position = UDim2.new(0, 0, 0, 30)
	        frametitle.TextColor3 = (toggled and Color3.fromRGB(102, 205, 67) or Color3.fromRGB(205, 64, 78))
	        frametitle.Size = UDim2.new(1, 0, 0, 28)
	        frametitle.Text = "          " .. title
	        frametitle.TextSize = 24
	        frametitle.TextXAlignment = Enum.TextXAlignment.Left
	        frametitle.TextYAlignment = Enum.TextYAlignment.Top
	        frametitle.Parent = NotificationBackground

	        frametext.Font = Enum.Font.SourceSansLight
	        frametext.BackgroundTransparency = 1
	        frametext.Position = UDim2.new(0, 0, 0, 68)
	        frametext.TextColor3 = Color3.new(1, 1, 1)
	        frametext.Size = UDim2.new(1, 0, 0, 28)
	        frametext.Text = "          " .. text
	        frametext.TextSize = 24
	        frametext.TextXAlignment = Enum.TextXAlignment.Left
	        frametext.TextYAlignment = Enum.TextYAlignment.Top
	        frametext.Parent = NotificationBackground

	        local textsize = TextService:GetTextSize(frametitle.Text, frametitle.TextSize, frametitle.Font, Vector2.new(100000, 100000))
	        local textsize2 = TextService:GetTextSize(frametext.Text, frametext.TextSize, frametext.Font, Vector2.new(100000, 100000))

	        if textsize2.X > textsize.X then textsize = textsize2 end

	        NotificationBackground.Size = UDim2.new(0, textsize.X + 38, 0, 115)

            --[[
	        pcall(function()
	            NotificationBackground:TweenPosition(UDim2.new(0.5, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.15)

	            Debris:AddItem(frame, delay2 + 0.15)
	        end)
            ]]
            BetterTween2(NotificationBackground, UDim2.new(1, -(NotificationSize.X.Offset + 10), 1, -((5 + NotificationSize.Y.Offset) * (offset + 1))), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
            task.wait(0.15)
            --pcall(function()
                --Bottombar:TweenSize(UDim2.new(0, 0, 0, 5), Enum.EasingDirection.In, Enum.EasingStyle.Linear, showtime, true)
            --end)
            task.wait(ShowTime)
            BetterTween2(NotificationBackground, UDim2.new(1, 0, 1, NotificationBackground.Position.Y.Offset), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
            task.wait(0.15)
            NotificationBackground:Destroy()
	    end
    end)
end

NotificationGui.ChildRemoved:Connect(function()
    for i,v in pairs(NotificationGui:GetChildren()) do
        BetterTween(v, UDim2.new(1, v.Position.X.Offset, 1, -((5 + NotificationSize.Y.Offset) * (i - 1))), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
    end
end)

function Library:CreateChatNotification(NotificationText, NotificationType) -- type: warning, error, print
    local Text = NotificationText or "nil"
    local NotificationType = NotificationType or "print"
    local NewText

    if NotificationType == "print" then
        NewText = Text
    else
        NewText = "[" .. NotificationType .. "]: " .. Text
    end
    
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Font = Library.Font,
        Text = NewText,
    })
end

function Library:CreateNotification(NotificationTitle, NotificationText, Delay, Toggled, NotificationType)
    if Library.Notifications then
        Library:CreateGuiNotification(NotificationTitle, NotificationText, Delay, Toggled)
    end

    if Library.ChatNotifications then
        Library:CreateChatNotification(NotificationText, NotificationType)
    end
end

function Library:CreateSessionInfo()
    local SessionInfoTable = {
        Rainbow = false,
        Objects = {}
    }

    local SessionInfo = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local RainbowTop = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local RainbowTopFix = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local SessionInfoTitle = Instance.new("TextLabel")
    
    SessionInfo.Name = "SessionInfo"
    SessionInfo.Parent = ScreenGui
    SessionInfo.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
    SessionInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionInfo.BorderSizePixel = 0
    SessionInfo.Position = UDim2.new(0, 0, 0.318777293, 0)
    SessionInfo.Size = UDim2.new(0, 150, 0, 25)

    dragGUI(SessionInfo)
    
    UIListLayout.Parent = SessionInfo
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    RainbowTop.Name = "RainbowTop"
    RainbowTop.Parent = SessionInfo
    RainbowTop.BackgroundColor3 = Color3.fromRGB(215, 255, 140)
    RainbowTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RainbowTop.BorderSizePixel = 0
    RainbowTop.Size = UDim2.new(0, 150, 0, 10)
    
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = RainbowTop
    
    RainbowTopFix.Name = "RainbowTopFix"
    RainbowTopFix.Parent = RainbowTop
    RainbowTopFix.BackgroundColor3 = Color3.fromRGB(215, 255, 140)
    RainbowTopFix.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RainbowTopFix.BorderSizePixel = 0
    RainbowTopFix.Position = UDim2.new(0, 0, 0.670000017, 0)
    RainbowTopFix.Size = UDim2.new(0, 150, 0, 4)
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = SessionInfo
    
    SessionInfoTitle.Name = "SessionInfoLabel"
    SessionInfoTitle.Parent = SessionInfo
    SessionInfoTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SessionInfoTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SessionInfoTitle.BorderSizePixel = 0
    SessionInfoTitle.LayoutOrder = 1
    SessionInfoTitle.Position = UDim2.new(0, 0, 0.200000003, 0)
    SessionInfoTitle.Size = UDim2.new(0, 150, 0, 15)
    SessionInfoTitle.Font = Enum.Font.Arial
    SessionInfoTitle.Text = "   SessionInfo"
    SessionInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SessionInfoTitle.TextSize = 14.000
    SessionInfoTitle.TextXAlignment = Enum.TextXAlignment.Left

    function SessionInfoTable:CreateStatisticLabel(Name)
        local Name = Name or "Hello"
        local LabelTable = {
            Name = Name
        }

        local Label = Instance.new("TextLabel")

        Label.Name = Name
        Label.Parent = SessionInfo
        Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Label.BorderSizePixel = 0
        Label.LayoutOrder = 1
        Label.Position = UDim2.new(0, 0, 0.200000003, 0)
        Label.Size = UDim2.new(0, 150, 0, 15)
        Label.Font = Enum.Font.Arial
        Label.Text = "   " .. Name .. ": "
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 14.000
        Label.TextXAlignment = Enum.TextXAlignment.Left

        LabelTable.TextLabel = Label

        table.insert(SessionInfoTable.Objects, Label)

        return LabelTable
    end

    function SessionInfoTable:RemoveStatisticLabel(Name)
        if SessionInfo:FindFirstChild(Name) then
            SessionInfo:FindFirstChild(Name):Destroy()
        end
    end

    function SessionInfoTable:Rainbow(Bool)
        Library:MakeRainbowObjectBackground(RainbowTop, Bool)
        Library:MakeRainbowObjectBackground(RainbowTopFix, Bool)
    end

    function SessionInfoTable:RemoveSessionInfo()
        if SessionInfo then
            SessionInfo:Destroy()
        end
    end

    return SessionInfoTable
end

--[[
    ToDo:
    Make tabs scrollable
    Make tabs dragable
    Add TargetInfo
]]

function Library:CreateWindow()
    ScreenGui.Name = Library:RandomString() -- like protect ok?
    
    --local TabsFrame = Instance.new("Frame")
    local TabsFrame = Instance.new("ScrollingFrame")
    local uilistthingy = Instance.new("UIListLayout")
    local UIScale = Instance.new("UIScale")
    local HoverText = Instance.new("TextLabel")
    local UIGridLayout = Instance.new("UIGridLayout")

    --[[
    TabsFrame.Name = "Tabs"
    TabsFrame.Parent = ClickGui
    TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsFrame.BackgroundTransparency = 1.000
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Position = UDim2.new(0.010, 0, 0.010, 0)
    TabsFrame.Size = UDim2.new(0, 207, 0, 40)
    TabsFrame.AutomaticSize = "X"
    ]]

    TabsFrame.Name = "Tabs"
    TabsFrame.Parent = ClickGui
    TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsFrame.BackgroundTransparency = 1.000
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
    TabsFrame.Size = UDim2.new(0.98, 0, 0, 150)
    TabsFrame.ClipsDescendants = true
    TabsFrame.ScrollBarThickness = 8
    TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    uilistthingy.Parent = TabsFrame
    uilistthingy.FillDirection = Enum.FillDirection.Horizontal
    uilistthingy.SortOrder = Enum.SortOrder.LayoutOrder
    uilistthingy.Padding = UDim.new(0, 40)
    
    local screenSize = Camera.ViewportSize
    local Width = screenSize.X
    local Height = screenSize.Y

    if Width <= 1280 then -- Small screens
        Library.Scale = 0.7
    elseif Width <= 1920 then -- Mid-sized screens
        Library.Scale = 0.7
    elseif Width <= 2560 then -- Large screens
        Library.Scale = 1.0
    else -- Ultra-wide or 4K monitors
        Library.Scale = 1.25
    end

    UIGridLayout.Parent = TabsFrame
    UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    UIGridLayout.CellSize = UDim2.new(0, 150, 0, 40)

    Library.TabsFrame = TabsFrame
    Library.UIScale = UIScale

    UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabsFrame.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y)
    end)

    function Library:CreateTab(TabData)
        local TabName = TabData.Name
        local Color = TabData.Color or Color3.fromRGB(83, 214, 110)
        local TabIcon = TabData.TabIcon
        local Callback = TabData.Callback or function() end
        local tab = Instance.new("TextButton")
        local tabname = Instance.new("TextLabel")
        local assetthing = Instance.new("ImageLabel")
        local uilistlayout = Instance.new("UIListLayout")
    
        local tabtable = {
            Name = TabName,
            Color = Color,
            Visible = true,
            Callback = (TabData.Callback or function() end),
            Toggles = {}
        }

        table.insert(Tabs, #Tabs)
    
        local TabPosition = configtable[TabData.Name] and configtable[TabData.Name].Position or {X = 0, Y = 247 * #Tabs, W = 0, H = 0}
        
        tab.Modal = true
        tab.Name = TabName .. "_TabTop"
        tab.Selectable = true
        tab.ZIndex = 1
        tab.Parent = TabsFrame
        tab.BackgroundColor3 = Color3.fromRGB(14, 14, 23)
        tab.BorderSizePixel = 0
        tab.Position = UDim2.new(TabPosition.X, TabPosition.W, TabPosition.Y, TabPosition.H)
        tab.Size = UDim2.new(0, 207, 0, 40)
        tab.Active = true
        tab.LayoutOrder = 1 + #Tabs
        tab.AutoButtonColor = false
        tab.Text = ""
        
        tabname.Name = TabName
        tabname.Parent = tab
        tabname.ZIndex = tab.ZIndex + 1
        tabname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabname.BackgroundTransparency = 1.000
        tabname.BorderSizePixel = 0
        tabname.Position = UDim2.new(0, 199, 0, 40)
        tabname.Size = UDim2.new(0, 199, 0, 40)
        tabname.Font = Enum.Font.SourceSansLight
        tabname.Text = " " .. TabName
        tabname.TextColor3 = Color
        tabname.TextSize = 22.000
        tabname.TextWrapped = true
        tabname.TextXAlignment = Enum.TextXAlignment.Left
        tabname.Selectable = true
        
        assetthing.Parent = tabname
        assetthing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        assetthing.BackgroundTransparency = 1.000
        assetthing.BorderSizePixel = 0
        assetthing.Position = UDim2.new(0, 0, 0.5, 0)
        assetthing.Size = UDim2.new(0, 20, 0, 20)
        --assetthing.Image = getcustomasset("NewMana/Assets/" .. TabIcon)
        
        uilistlayout.Parent = tab
        uilistlayout.FillDirection = Enum.FillDirection.Vertical
        uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
        uilistlayout.Padding = UDim.new(0, 0)
        
        Tabs[TabName] = tabtable
        
        dragGUI(tab) 

        function tabtable:ChangeVisibility(bool)
            bool = bool or not tab.Visible
            tab.Visible = bool
            Callback(bool)
        end

        function tabtable:CreateDivider(DividerText)
            local DividerFrame = Instance.new("Frame")
            local Divider = Instance.new("TextLabel")
            local DividerFrame2 = Instance.new("Frame")
            DividerFrame.Name = title .. "_FrameDivider"
            DividerFrame.Parent = tab
            DividerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            DividerFrame.BorderSizePixel = 0
            DividerFrame.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            DividerFrame.Size = UDim2.new(0, 207, 0, 2)
            Divider.Name = title .. "_TextLabelDivider"
            Divider.Parent = tab
            Divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Divider.BorderSizePixel = 0
            Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            Divider.Size = UDim2.new(0, 207, 0, 20)
            Divider.Font = Enum.Font.SourceSansLight --Library.Font
            Divider.Text = DividerText
            Divider.TextColor3 = Color3.fromRGB(255, 255, 255)
            Divider.TextSize = 18
            Divider.TextXAlignment = Enum.TextXAlignment.Center
            DividerFrame2.Name = title .. "_FrameDivider"
            DividerFrame2.Parent = tab
            DividerFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            DividerFrame2.BorderSizePixel = 0
            DividerFrame2.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            DividerFrame2.Size = UDim2.new(0, 207, 0, 2)
            return Divider
        end

        function tabtable:CreateToggle(data)
            local info = {
                Name = data.Name,
                --HoverText = data.HoverText,
                Keybind = (configtable[data.Name.Keybind] or data.Keybind),
                Callback = (data.Callback or function() end)
            }

            configtable[data.Name] = {
                Keybind = ((configtable[info.Name] and configtable[info.Name].Keybind) or "none"),
                IsToggled = ((configtable[info.Name] and configtable[info.Name].IsToggled) or false)
            }

            local title = info.Name
            --local ToolTip = info.HoverText
            local keybind = info.Keybind
            local Callback = info.Callback

            keybind = (keybind or {Name = nil})
            Keybinds[(keybind.Name or "%*")] = (keybind.Name == nil and false or true)

            local focus = {
                Elements = {}
            }

            local ToggleTable = {
                Name = data.Name or "",
                Enabled = false,
                Visible = true,
                Callback = data.Callback or function() end
            }

            Library.Objects[title] = ToggleTable
            table.insert(tabtable.Toggles, #tabtable.Toggles)
            oldkey = keybind.Name

            local toggle = Instance.new("TextButton")
            local BindText = Instance.new("TextButton")
            local optionsframebutton = Instance.new("TextButton")
            local togname = Instance.new("TextLabel")
            local optionframe = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")

            toggle.Name = title .. "_TabbToggleButton"
            toggle.Parent = tab
            toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0) --Color3.fromRGB(unpack(Library.ThemeManager.ThemeColor.TabToggle.UnToggledBackgroundColor3))
            toggle.BorderSizePixel = 0
            toggle.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            toggle.Size = UDim2.new(0, 207, 0, 40)
            toggle.Text = ""

            togname.Parent = toggle
            togname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            togname.BackgroundTransparency = 1.000
            togname.BorderSizePixel = 0
            togname.Position = UDim2.new(0.0338164233, 0, 0.163378686, 0)
            togname.Size = UDim2.new(0, 192, 0, 26)
            togname.Font = Enum.Font.SourceSansLight
            togname.Text = title
            togname.TextColor3 = Color3.fromRGB(255, 255, 255)
            togname.TextSize = 22.000
            togname.TextWrapped = true
            togname.TextXAlignment = Enum.TextXAlignment.Left

            optionsframebutton.Parent = toggle
            optionsframebutton.Position = UDim2.new(0, 170, 0, 0)
            optionsframebutton.Size = UDim2.new(0, 37, 0, 39)
            optionsframebutton.BackgroundTransparency = 1
            optionsframebutton.Text = "."
            optionsframebutton.TextSize = "30"

            optionframe.Name = "OptionFrame" .. info.Name
            optionframe.Parent = tab
            optionframe.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
            optionframe.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
            optionframe.Size = UDim2.new(0, 207, 0, 0)
            optionframe.AutomaticSize = "Y"
            optionframe.Visible = false

            UIListLayout.Parent = optionframe
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 8)

            BindText.Name = "BindText"
            BindText.Parent = optionframe
            BindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindText.BackgroundTransparency = 1.000
            BindText.Position = UDim2.new(0.0989583358, 0, 0, 0)
            BindText.Size = UDim2.new(0, 175, 0, 33)
            BindText.Font = Enum.Font.SourceSansLight
            BindText.Text = "Bind: none"
            BindText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindText.TextSize = 22.000
            BindText.TextXAlignment = Enum.TextXAlignment.Left
            BindText.TextYAlignment = Enum.TextYAlignment.Center

            ToggleTable.MainObject = toggle

            BindText.MouseEnter:Connect(function()
                focus.Elements["toggle_" .. title] = true
            end)

            BindText.MouseLeave:Connect(function()
                focus.Elements["toggle_" .. title] = false
            end)

            conf.functions:WriteConfigs(configtable)

            local configData = HttpService:JSONDecode(readfile(conf.file))

            if isfile(conf.file) and configData[title].Keybind and configData[title].Keybind ~= "none" then
                local keybind = configData[title].Keybind

                if Keybinds[keybind] then
                    BindText.Text = "Bind: " .. keybind
                    isclicked = false
                    return
                end

                if oldkey then
                    Keybinds[oldkey] = nil
                end

                oldkey = keybind
                BindText.Text = "Bind: " .. keybind
                configtable[title].Keybind = keybind
                isclicked = false
                cooldown = true
                wait(0.5)
                cooldown = false
            end

            BindText.MouseButton1Click:Connect(function()
                if not focus.Elements["toggle_" .. title] or isclicked then return end
                isclicked = true
                BindText.Text = "Bind: ..."

                UserInputService.InputBegan:Connect(function(input)
                    local inputName = input.KeyCode.Name
                    if inputName == "Unknown" and input.UserInputType == Enum.UserInputType.MouseButton2 then
                        isclicked = true
                        BindText.Text = "Bind: " .. configtable[title].Keybind or "none"
                        print("Binding canceled.")
                    elseif inputName ~= "Unknown" and inputName ~= oldkey then
                        if not isclicked then return end
                        if Keybinds[inputName] then
                            BindText.Text = "Bind: " .. oldkey
                            isclicked = false
                            return
                        end

                        if oldkey then
                            Keybinds[oldkey] = nil
                        end

                        print("Pressed keybind: " .. inputName)

                        oldkey = inputName
                        BindText.Text = "Bind: " .. oldkey
                        configtable[title].Keybind = oldkey
                        isclicked = false
                        cooldown = true
                        wait(0.5)
                        cooldown = false
                    end
                end)
            end)

            toggle.MouseButton2Click:Connect(function()
                optionframe.Visible = not optionframe.Visible
            end)

            optionsframebutton.MouseButton1Click:Connect(function()
                optionframe.Visible = not optionframe.Visible
            end)

            toggle.MouseButton1Click:Connect(function()
                local currentTime = tick()
            
                if currentTime - LastPress < 0.5 and OnMobile then
                    optionframe.Visible = not optionframe.Visible
                end
            
                LastPress = currentTime
            end)
            
            if not isfile(conf.file) then
                configtable[title].IsToggled = false
            end
            
            function ToggleTable:Toggle(silent, bool)
                bool = bool or (not ToggleTable.Enabled)
                silent = silent or false
                ToggleTable.Enabled = bool
                if not bool then
                    spawn(function()
                        Callback(false)
                    end)
                    spawn(function()
                        Library:CreateNotification(title, "Disabled " .. title, 4, false)
                        configtable[title].IsToggled = false
                    end)
                    toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0) --Color3.fromRGB(unpack(Library.ThemeManager.ThemeColor.TabToggle.UnToggledBackgroundColor3))
                    if not silent then
                        Library:playsound("rbxassetid://421058925", 1)
                    end
                else
                    spawn(function()
                        Callback(true)
                    end)
                    spawn(function()
                        Library:CreateNotification(title, "Enabled " .. title, 4, true)
                        configtable[title].IsToggled = true
                    end)
                    toggle.BackgroundColor3 = Color --Color3.fromRGB(unpack(Library.ThemeManager.ThemeColor.TabToggle.ToggledBackgroundColor3))
                    if not silent then
                        Library:playsound("rbxassetid://421058925", 1)
                    end
                end
            end
            
            toggle.MouseButton1Click:Connect(function()
                ToggleTable:Toggle()
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if oldkey and not cooldown and not isclicked and input.KeyCode.Name == oldkey and not UserInputService:GetFocusedTextBox() then
                    ToggleTable:Toggle()
                end
            end)
            
            if configtable[title].IsToggled then
                ToggleTable:Toggle(true)
            end

            function ToggleTable:ChangeVisibility(Bool)
                bool = bool or not toggle.Visible
                toggle.Visible = bool
                Callback(bool)
            end

            function ToggleTable:CreateSlider(argstable)
                local sliderapi = {Value = (configtable[argstable.Name .. ToggleTable.Name] and configtable[argstable.Name .. ToggleTable.Name].Value or argstable.Default or argstable.Min)}
                local min = argstable.Min
                local max = argstable.Max
                local round = argstable.Round or 2

                local slider = Instance.new("TextButton")
                local slidertext = Instance.new("TextLabel")
                local slider_2 = Instance.new("Frame")
            
                slider.Name = "Slider"
                slider.Parent = optionframe
                slider.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                slider.BorderSizePixel = 0
                slider.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                slider.Size = UDim2.new(0, 180, 0, 34)
                slider.Text = ""
                slider.AutoButtonColor = false
            
                slidertext.Name = "SliderText"
                slidertext.Parent = slider
                slidertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.BackgroundTransparency = 1.000
                slidertext.BorderSizePixel = 0
                slidertext.Position = UDim2.new(0.0188679248, 0, 0, 0)
                slidertext.Size = UDim2.new(0, 180, 0, 33)
                slidertext.ZIndex = 3
                slidertext.Font = Enum.Font.SourceSansLight
                slidertext.Text = ""
                slidertext.TextColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.TextSize = 22.000
                slidertext.TextXAlignment = Enum.TextXAlignment.Left
            
                slider_2.Name = "Slider_2"
                slider_2.Parent = slider
                slider_2.BackgroundColor3 = Color
                slider_2.BorderSizePixel = 0
                slider_2.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                slider_2.Size = UDim2.new(0, 0, 0, 34)
                slider_2.ZIndex = 2

                sliderapi.MainObject = slider
            
                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {Value = sliderapi.Value}
                end
            
                local function slide(input)
                    local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    local value = math.floor(((((max - min) * sizeX) + min) * (10 ^ round)) + 0.5) / (10 ^ round)

                    slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
                    sliderapi.Value = value
                    slidertext.Text = argstable.Name .. ": " .. tostring(value)
                    configtable[argstable.Name .. ToggleTable.Name].Value = sliderapi.Value

                    if not argstable.OnInputEnded then
                        argstable.Function(value)
                    end
                end
            
                local sliding = false
            
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        slide(input)
                    end
                end)
                
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if argstable.OnInputEnded then
                            argstable.Function(sliderapi.Value)
                            configtable[argstable.Name .. ToggleTable.Name].Value = sliderapi.Value
                        end
                        sliding = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService.MouseEnabled) or (input.UserInputType == Enum.UserInputType.Touch) then
                        if sliding then
                            slide(input)
                        end
                    end
                end)                
            
                sliderapi.Set = function(value)
                    local value = math.floor((math.clamp(value, min, max) * (10 ^ round)) + 0.5) / (10 ^ round)

                    sliderapi.Value = value
                    slider_2.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    slidertext.Text = argstable.Name .. ": " .. tostring(value)

                    argstable.Function(value)
                end

                sliderapi.Set(sliderapi.Value)
            
                Library.Objects[argstable.Name .. "Slider"] = {
                    API = sliderapi,
                    Instance = slider,
                    Type = "Slider",
                    OptionsButton = argstable.Name,
                    Window = TabsFrame.Name
                }
                return sliderapi
            end
            function ToggleTable:CreateDropDown(argstable)
                local ddname = argstable.Name
                local dropdownapi = {
                    Value = nil,
                    List = {}
                }
            
                for i,v in next, argstable.List do 
                    table.insert(dropdownapi.List, v)
                end
            
                if configtable[ddname] == nil then
                    configtable[ddname] = {
                        Value = dropdownapi.Value
                    }
                end
            
                dropdownapi.Value = (configtable[ddname] and configtable[ddname].Value) or argstable.Default or dropdownapi.List[1]
            
                local function stringtablefind(table1, key)
                    for i,v in next, table1 do
                        if tostring(v) == tostring(key) then
                            return i
                        end
                    end
                end
            
                local function getvalue(index) 
                    local realindex
                    if index > #dropdownapi.List then
                        realindex = 1 
                    elseif index < 1 then
                        realindex = #dropdownapi.List
                    else
                        realindex = index
                    end
                    return realindex
                end
            
                local Dropdown = Instance.new("TextButton")

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = optionframe
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 1.000
                Dropdown.BorderSizePixel = 0
                Dropdown.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
                Dropdown.Size = UDim2.new(0, 175, 0, 25)
                Dropdown.Font = Enum.Font.SourceSansLight
                Dropdown.Text = argstable.Name .. ": " .. argstable.Default
                Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.TextSize = 22.000
                Dropdown.TextWrapped = true
                Dropdown.TextXAlignment = Enum.TextXAlignment.Left
                Dropdown.TextYAlignment = Enum.TextYAlignment.Bottom

                dropdownapi.MainObject = Dropdown
            
                dropdownapi.Select = function(_select) 
                    if dropdownapi.List[_select] or stringtablefind(dropdownapi.List, _select) then
                        dropdownapi.Value = dropdownapi.List[_select] or dropdownapi.List[stringtablefind(dropdownapi.List, _select)]
                        Dropdown.Text =  argstable.Name .. ":" .. tostring(dropdownapi.Value)
                        configtable[ddname].Value = dropdownapi.Value
                        if argstable.Function then
                            argstable.Function(dropdownapi.Value)
                        elseif argstable.Callback then
                            argstable.Callback(dropdownapi.Value)
                        end
                    end
                end
                
                dropdownapi.SelectNext = function()
                    local currentIndex = table.find(dropdownapi.List, dropdownapi.Value)
                    if currentIndex then
                        local newIndex = (currentIndex % #dropdownapi.List) + 1
                        dropdownapi.Select(newIndex)
                    else
                        warn("Index in selector (" .. argstable.Name .. ") in function `SelectNext` was not found!")
                        Library:CreateNotification("NewIndex in selector (" .. argstable.Name .. ") in function `SelectNext` was not found!", "If this keeps happening, go to your exploit's folder\nthen go to workspace/rektsky/config\nand delete everything inside of that folder", 10, false, "Warning")
                    end
                end
                
                dropdownapi.SelectPrevious = function()
                    local currentIndex = table.find(dropdownapi.List, dropdownapi.Value)
                    if currentIndex then
                        local newIndex = currentIndex - 1
                        if newIndex < 1 then
                            newIndex = #dropdownapi.List
                        end
                        dropdownapi.Select(newIndex)
                    else
                        warn("Index in selector (" .. argstable.Name .. ") in function `SelectPrevious` was not found!")
                        Library:CreateNotification("NewIndex in selector (" .. argstable.Name .. ") in function `SelectPrevious` was not found!", "If this keeps happening, go to your exploit's folder\nthen go to workspace/rektsky/config\nand delete everything inside of that folder", 10, false, "Warning")
                    end
                end
            
                if configtable[ddname] and configtable[ddname].Value then
                    dropdownapi.Select(stringtablefind(dropdownapi.List,configtable[ddname].Value))
                end
            
                Dropdown.MouseButton1Click:Connect(dropdownapi.SelectNext)
                Dropdown.MouseButton2Click:Connect(dropdownapi.SelectPrevious)
            
                Library.Objects[argstable.Name .. "Selector"] = {
                    API = dropdownapi,
                    Instance = Selector,
                    Type = "Selector",
                    OptionsButton = argstable.Name,
                    Window = TabsFrame.Name
                }
                
                return dropdownapi
            end               
            function ToggleTable:CreateToggle(argstable)
                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {IsToggled = argstable.Default}
                end
            
                local optionToggle = {
                    Name = argstable.Name,
                    Enabled = configtable[argstable.Name .. ToggleTable.Name].IsToggled or argstable.Default,
                    Function = argstable.Function
                }
            
                local Label = Instance.new("TextLabel")
                local ActiveFrame = Instance.new("Frame")
                local ToggleButton = Instance.new("TextButton")
            
                Label.Name = "Label"
                Label.Parent = optionframe
                Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0.091, 0, 0.503, 0)
                Label.Size = UDim2.new(0, 170, 0, 32)
                Label.Font = Enum.Font.SourceSansLight
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextSize = 22
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Text = argstable.Name
            
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Label
                ToggleButton.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(0.817, 0, 0.074, 0)
                ToggleButton.Size = UDim2.new(0, 29, 0, 29)
                ToggleButton.ZIndex = 2
                ToggleButton.AutoButtonColor = false
            
                ActiveFrame.Name = "ActiveFrame"
                ActiveFrame.Parent = Label
                ActiveFrame.BackgroundColor3 = Color3.fromRGB(66, 68, 66)
                ActiveFrame.BorderSizePixel = 0
                ActiveFrame.Position = UDim2.new(0, 141, 0, 5)
                ActiveFrame.Size = UDim2.new(0, 24, 0, 24)
                ActiveFrame.ZIndex = 3
            
                optionToggle.MainObject = Label
            
                function optionToggle:Toggle(state)
                    state = state or not optionToggle.Enabled
                    optionToggle.Enabled = state
                    configtable[argstable.Name .. ToggleTable.Name].IsToggled = state
            
                    if argstable.Function then
                        spawn(function()
                            argstable.Function(state)
                        end)
                    end
            
                    ActiveFrame.BackgroundColor3 = state and tabname.TextColor3 or Color3.fromRGB(68, 68, 60)
                end
            
                optionToggle:Toggle(configtable[argstable.Name .. ToggleTable.Name].IsToggled)
            
                if argstable.Default then
                    optionToggle:Toggle(true)
                end
            
                ToggleButton.MouseButton1Click:Connect(function()
                    optionToggle:Toggle()
                end)
            
                return optionToggle
            end            
            function ToggleTable:CreateTextBox(argstable)
                local TextBoxAPI = {
                    Name = argstable.Name,
                    Value = (configtable[argstable.Name .. ToggleTable.Name] and configtable[argstable.Name .. ToggleTable.Name].Value or argstable.DefaultValue),
                    PlaceholderText = argstable.PlaceholderText,
                    Function = argstable.Function
                }
                
                local textbox_background = Instance.new("Frame")
                local textbox = Instance.new("TextBox")

                textbox_background.Name = "textboxbackground"
                textbox_background.Parent = optionframe
                textbox_background.BackgroundColor3 = Color
                textbox_background.BorderSizePixel = 0
                textbox_background.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                textbox_background.Size = UDim2.new(0, 180, 0, 34)

                textbox.Name = argstable.Name .. "TextBox"
                textbox.Parent = textbox_background
                textbox.BackgroundColor3 = Color3.fromRGB(47, 48, 64)
                textbox.BackgroundTransparency = 1
                textbox.BorderSizePixel = 0
                textbox.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                textbox.Size = UDim2.new(0, 180, 0, 34)
                textbox.Font = Enum.Font.SourceSansLight
                textbox.Text = TextBoxAPI.Value
                textbox.TextColor3 = Color3.fromRGB(0, 0, 0)
                textbox.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
                textbox.TextSize = 22.000
                textbox.PlaceholderText = TextBoxAPI.PlaceholderText or ""

                TextBoxAPI.MainObject = textbox_background
            
                textbox.Changed:Connect(function(property)
                    if property == "Text" then
                        TextBoxAPI.Value = textbox.Text
                        argstable.Function(property)
                    end
                end)
            
                if configtable[argstable.Name .. ToggleTable.Name] == nil then
                    configtable[argstable.Name .. ToggleTable.Name] = {Value = TextBoxAPI.Value}
                end
            
                Library.Objects[argstable.Name .. "TextBox"] = {
                    API = TextBoxAPI, 
                    Data = Data,
                    Instance = textbox, 
                    Type = "TextBox", 
                    OptionsButton = argstable.Name, 
                    Window = TabsFrame.Name
                }
                
                return TextBoxAPI
            end

            -- Note: this is still ToggleTable:CreateToggle function
            -- Idk what is this but if i remove it something will break 100%
            local thngylol = Instance.new("Frame")
            local thngyloltwo = Instance.new("Frame")

            thngylol.Parent = optionframe
            thngylol.Transparency = 1
            thngylol.Size = UDim2.new(0, 0, 0, 0.7)
            thngylol.LayoutOrder = 99999

            thngyloltwo.Parent = optionframe
            thngyloltwo.Transparency = 1
            thngyloltwo.Size = UDim2.new(0, 0, 0, 0.7)
            thngyloltwo.LayoutOrder = -9999

            Library.Objects[data.Name] = {
                Instance = Toggle, 
                OptionFrame = optionframe,
                Type = "Toggle", 
            }
            return ToggleTable
        end
        
        return tabtable
    end
end

return Library