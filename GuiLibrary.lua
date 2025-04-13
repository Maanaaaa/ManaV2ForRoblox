--[[ 
    Credits to vape's old guilibrary and others script that i used/looked at

    Made by Maanaaaa and Wowzers
]]

repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local htppservice = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local getasset = getcustomasset
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local configsaving = true
local LastPress = 0
local SliderLastPress = 0
local Developer = shared.ManaDeveloepr
local connections = shared.Mana.Connections
local OnMobile
local TabsFrame
local Tabs = {}
local Fonts = {}
local Keybinds = {}
local guilibrary = {
    Device = "None",
    Scale = 1,
    MobileScale = 0.45,
    Sounds = true,
    SoundsVolume = 1,
    GuiKeybind = "RightShift",
    Toggled = true,
    CurrentConfig = "Default",
    Rainbow = false,
    RaibowSpeed = 0,
    AllowNotifications = true,
    TouchEnabled = false,
    SliderDoubleClick = true,
    SliderDoubleClickLeft = false,
    SliderDoubleClickRight = false,
    SliderDoubleClickTouch = false,
    textlist = {
        lmb = false,
        rmb = false
    },
    UICorners = false,
    UICornersRadius = 0,
    SliderCanOverride = false,
    ArrayList = {},
    Objects = {},
    Functions = {},
    FontsList = {},
    UICornersTable = {},
    APIs = {},
    pinnedobjects = {},
    rainbowObjects = {},
    ObjectsThatCanBeSaved = {}
}

local guipallet = {
    ThemeMode = "Default",
    Color1 = Color3.fromRGB(14, 14, 23),
    Color2 = Color3.fromRGB(47, 48, 64),
    Color3 = Color3.fromRGB(66, 68, 66),
    Color4 = Color3.fromRGB(49, 51, 64),
    Color5 = Color3.fromRGB(20, 20, 20),
    ToggleColor = Color3.fromRGB(0, 0, 0),
    ToggleColor2 = Color3.fromRGB(52, 235, 58),
    TextColor = Color3.fromRGB(255, 255, 255),
    GrayTextColor = Color3.fromRGB(220, 220, 220),
    Font = Enum.Font.Arial
}
guilibrary.GuiPallet = guipallet

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Mana"
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.OnTopOfCoreBlur = true -- so if you even get kicked or banned you'll still see gui :)
local ClickGui = Instance.new("Frame", ScreenGui)
ClickGui.Name = "ClickGui"
local NotificationWindow = Instance.new("Frame", ScreenGui)
NotificationWindow.Name = "NotificationGui"
NotificationWindow.BackgroundTransparency = 1
NotificationWindow.Size = UDim2.new(0, 100, 0, 10)
NotificationWindow.Position = UDim2.new(0, 1840, 0, 860)
--NotificationWindow.Active = true
--NotificationWindow.Draggable = true
local KeyStrokesGui = Instance.new("Frame", ScreenGui)
KeyStrokesGui.Name = "KeyStrokesGui"
KeyStrokesGui.BackgroundTransparency = 1
KeyStrokesGui.Size = UDim2.new(0, 100, 0, 10)
KeyStrokesGui.Position = UDim2.new(0.0220729373, 0, 0.0688000023, 0)

guilibrary.ScreenGui = ScreenGui
guilibrary.ClickGui = ClickGui
guilibrary.NotificationGui = NotificationWindow
guilibrary.KeyStrokesGui = KeyStrokesGui

local manaObjects = Instance.new("Folder")
manaObjects.Parent = ScreenGui
local toggleRemote = Instance.new("BindableEvent")
toggleRemote.Parent = manaObjects

if UserInputService.TouchEnabled then
    guilibrary.Device = "Mobile"
    guilibrary.TouchEnabled = true
    OnMobile = true
end

for i, v in pairs(Enum.Font:GetEnumItems()) do
    Fonts[v.Name] = v
end

guipallet.FontsList = Fonts

local spawn = function(func) 
    return coroutine.wrap(func)()
end

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
            textlabel.Font = guipallet.Font
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


local configtable = {}

function guilibrary:isObjectInTable(table, object) -- from old vape
    for i,v in pairs(table) do
        if i == object or v == object then
            return true
        end
    end
    return false
end

function guilibrary:findStringInTable(table1, key)
    for i,v in next, table1 do
        if tostring(v) == tostring(key) then
            return i
        end
    end
end

-- made this by looking at old vape's saving system
function guilibrary:SaveConfig(universal)
    local savedata = {}
    local path = "Mana/"--shared.ManaDeveloper and "NewMana/" or "Mana/"

    for objtable, obj in pairs(guilibrary.ObjectsThatCanBeSaved) do
        if obj.Type == "Tab" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "Tab",
                --Pinned = obj.Table.Pinned,
                Position = {obj.mainobject.Position.X.Scale, obj.mainobject.Position.X.Offset, obj.mainobject.Position.Y.Scale, obj.mainobject.Position.Y.Offset}
            }
        elseif obj.Type == "CustomTab" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "CustomTab",
                Pinned = obj.Table.Pinned,
                Position = {obj.mainobject.Position.X.Scale, obj.mainobject.Position.X.Offset, obj.mainobject.Position.Y.Scale, obj.mainobject.Position.Y.Offset}
            }
        elseif obj.Type == "Toggle" then
            if obj.Table.Name == not "UnInject" and "ReInject" and "DeleteConfig" then
                savedata[objtable] = {
                    Name = obj.Table.Name,
                    Type = "Toggle",
                    value = obj.Table.Value,
                    Keybind = obj.Table.Keybind
                }
            end
        elseif obj.Type == "ColorSlider" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "ColorSlider",
                value = obj.Table.Value
            }
        elseif obj.Type == "Slider" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "Slider",
                value = obj.Table.Value
            }
        elseif obj.Type == "Dropdown" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "Dropdown",
                value = obj.Table.Value
            }
        elseif obj.Type == "OptionToggle" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "OptionToggle",
                value = obj.Table.Value
            }
        elseif obj.Type == "TextBox" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "TextBox",
                value = obj.Table.Text
            }
        elseif obj.Type == "TextList" then
            savedata[objtable] = {
                Name = obj.Table.Name,
                Type = "TextList",
                list = obj.Table.List
            }
        else
            warn("[ManaV2ForRoblox/Guilibrary.lua]: can't save config from unknown object: "..obj.Type.." (objtype).")
            --warn("[ManaV2ForRoblox/Guilibrary.lua]: can't save config from unknown object: "..obj.Name or obj.Table.Name.."-"..obj.Type.." (name - obj).")
        end
    end
    --if universal then
        --writefile(path.."Config/Universal.json", htppservice:JSONEncode(savedata))
    --else
        writefile(path.."Config/"..game.PlaceId..".json", htppservice:JSONEncode(savedata))
    --end
end

function guilibrary:SaveTable(table, name)
    local path = shared.ManaDeveloper and "NewMana/" or "Mana/"
    writefile(path.."Config/"..name.."TABLE.json", htppservice:JSONEncode(table))
end

function guilibrary:LoadConfig(universal)
    local path = "Mana/"--shared.ManaDeveloper and "NewMana/" or "Mana/"
    local success, result = pcall(function()
        --[[
        if universal then
            return htppservice:JSONDecode(readfile(path.."Config/Universal.json"))
        else
            return htppservice:JSONDecode(readfile(path.."/Config/"..game.PlaceId..".json"))
        end
        ]]
        return htppservice:JSONDecode(readfile(path.."Config/"..game.PlaceId..".json"))
    end)

    if success and type(result) == "table" then
        for objtable, obj in pairs(result) do
            spawn(function()
                if obj.Type == "Tab" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    guilibrary.ObjectsThatCanBeSaved[objtable].mainobject.Position = UDim2.new(table.unpack(obj.Position))
                    --guilibrary.ObjectsThatCanBeSaved[objtable].Table:Pin(obj.Pinned or false)
                elseif obj.Type == "CustomTab" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    guilibrary.ObjectsThatCanBeSaved[objtable].mainobject.Position = UDim2.new(table.unpack(obj.Position))
                    guilibrary.ObjectsThatCanBeSaved[objtable].Table:Pin(obj.Pinned or false)
                elseif obj.Type == "Toggle" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    if obj.Table.Name == not "UnInject" and "ReInject" and "DeleteConfig" then
                        guilibrary.ObjectsThatCanBeSaved[objtable].Table:Toggle(true, obj.value)
                        guilibrary.ObjectsThatCanBeSaved[objtable].Table:UpdateKeybind(obj.Keybind)
                    end
                elseif obj.Type == "OptionToggle" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    guilibrary.ObjectsThatCanBeSaved[objtable].Table:Toggle(obj.value)
                elseif obj.Type == "ColorSlider" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then

                elseif obj.Type == "Slider" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    guilibrary.ObjectsThatCanBeSaved[objtable].Table:Set(obj.value, guilibrary.SliderCanOverride)
                elseif obj.Type == "Dropdown" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    guilibrary.ObjectsThatCanBeSaved[objtable].Table:Select(obj.value)
                elseif obj.Type == "TextBox" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    guilibrary.ObjectsThatCanBeSaved[objtable].Table:Set(obj.value)
                elseif obj.Type == "TextList" and guilibrary:isObjectInTable(guilibrary.ObjectsThatCanBeSaved, objtable) then
                    for i, v in pairs(obj.list) do
                        guilibrary.ObjectsThatCanBeSaved[objtable].Table:CreateListObject(v)
                    end
                else
                    warn("[ManaV2ForRoblox/Guilibrary.lua]: can't load config from unknown object: "..obj.Type.." (objtype).")
                end
            end)
        end
    else
        warn("[ManaV2ForRoblox/GuiLibrary.lua]: an error occured while loading config: " .. result)
    end
end

function guilibrary:LoadTable(name)
    local path = shared.ManaDeveloper and "NewMana/" or "Mana/"
    local success, result = pcall(function()
        return htppservice:JSONDecode(readfile(path.."Config/"..name.."TABLE.json"))
    end)
    if not suc then warn("[ManaV2ForRoblox/Guilibrary.lua]: an error occured while loading table: " .. result); return nil end
    return result
end

function guilibrary:Destruct()
    for i, v in pairs(connections) do
        v:Disconnect()
        v:disconnect()
        v = nil
    end
    for i, v in pairs(guilibrary.Objects) do
        if v.Type == "Toggle" then
            if v.Enabled then
                v:Toggle(true, false)
            end
        end
    end
    ScreenGui:Destroy()
end

function guilibrary:Toggle(bool)
    local bool = bool or not guilibrary.Toggled
    guilibrary.Toggled = bool

    for i, v in pairs(guilibrary.ObjectsThatCanBeSaved) do
        if v.Type == "Tab" and v.Table.Pinned == false then
            v.mainobject.Visible = bool
        end
    end
end

--[[old autosave
spawn(function()
    repeat
        conf.functions:WriteConfigs(configtable)
        task.wait(30)
    until (not configsaving)
end)
]]

local function dragGUI(gui)
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
function guilibrary:MakeRainbowText(Text, Bool)
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

function guilibrary:MakeRainbowObjectBackground(Object, Bool)
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

local function getTextWidth(text, fontSize)
    return #text * fontSize * 0.6
end

function guilibrary:UpdateFont(NewFont)
    local font = "Enum.Font." .. NewFont
    for i, v in pairs(ScreenGui:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            v.Font = font
        end
    end
end

function guilibrary:RandomString() -- from vape
    local randomlength = math.random(10,100)
    local array = {}

    for i = 1, randomlength do
        array[i] = string.char(math.random(32, 126))
    end

    return table.concat(array)
end

function guilibrary:Toggleguilibrary()
    if UserInputService:GetFocusedTextBox() == nil then
        if ClickGui.Visible then
            ClickGui.Visible = false
        else
            ClickGui.Visible = true
        end
    end
end

function guilibrary:RemoveObject(ObjectName) 
    pcall(function()
        if guilibrary.Objects[ObjectName] and guilibrary.Objects[ObjectName].Type == "Toggle" then 
            guilibrary.Objects[ObjectName].Instance:Destroy()
            guilibrary.Objects[ObjectName].OptionFrame:Destroy()
            guilibrary.Objects[ObjectName] = nil
        end
    end)
end

function guilibrary:updateGuiLibraryCorners(NewRadius)
    for i, v in pairs(guilibrary.UICornersTable) do
        v.CornerRadius = UDim.new(0, NewRadius)
    end
end

function guilibrary:playsound(id, volume) 
    if guilibrary.Sounds == true then
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

function guilibrary:CreateNotification(title, text, delay2, toggled)
    spawn(function()
        if NotificationWindow:FindFirstChild("Background") then NotificationWindow:FindFirstChild("Background"):Destroy() end
		if guilibrary.Notifications == true then
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
	        frame.Parent = NotificationWindow

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

function guilibrary:CreateSessionInfo()
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
    SessionInfo.BackgroundColor3 = Color3.fromRGB(guipallet.Color1)
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

    function SessionInfoTable:CreateLabel(Name)
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

    function SessionInfoTable:RemoveLabel(Name)
        if SessionInfo:FindFirstChild(Name) then
            SessionInfo:FindFirstChild(Name):Destroy()
        end
    end

    function SessionInfoTable:Rainbow(Bool)
        guilibrary:MakeRainbowObjectBackground(RainbowTop, Bool)
        guilibrary:MakeRainbowObjectBackground(RainbowTopFix, Bool)
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
    Add TargetInfo
]]

function guilibrary:CreateStatLabel(text)
    local statTable = {
        text = text
    }

    local background = Instance.new("Frame")
    local text = Instance.new("TextLabel")
    local ui_corner = Instance.new("UICorner")
    local dragg = Instance.new("TextLabel")
    
    background.Name = "background"
    background.Parent = ClickGui
    background.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
    background.BackgroundTransparency = 1.000
    background.Position = UDim2.new(0.0220729373, 0, 0.0688000023, 0)
    background.Size = UDim2.new(0, 100, 0, 40)
    background.Draggable = true
    background.Active = true
    statTable.mainobject = background
    dragGUI(background)
    
    text.Name = "text"
    text.Parent = background
    text.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
    text.BackgroundTransparency = 0.500
    text.BorderSizePixel = 0
    text.Position = UDim2.new(0.400000006, 0, 0, 0)
    text.Size = UDim2.new(0, 60, 0, 40)
    text.Font = guilibrary.Font
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 20
    
    ui_corner.CornerRadius = UDim.new(0, 3)
    ui_corner.Parent = text
    
    dragg.Name = "dragg"
    dragg.Parent = background
    dragg.BackgroundColor3 = Color3.fromRGB(141, 255, 121)
    dragg.BackgroundTransparency = 0.500
    dragg.BorderSizePixel = 0
    dragg.Position = UDim2.new(0.0599999987, 0, 0, 0)
    dragg.Size = UDim2.new(0, 35, 0, 40)
    dragg.Font = guilibrary.Font
    dragg.Text = text
    dragg.TextColor3 = Color3.fromRGB(0, 0, 0)
    dragg.TextSize = 14

    function statTable:update(text)
        text.Text = text
    end
end

function guilibrary:CreateWindow()
    ScreenGui.Name = guilibrary:RandomString() -- like protect ok?
    
    local TabsFrame = Instance.new("Frame")
    local UIScale = Instance.new("UIScale")

    TabsFrame.Name = "Tabs"
    TabsFrame.Parent = ClickGui
    TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsFrame.BackgroundTransparency = 1
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Position = UDim2.new(0.010, 0, 0.010, 0)
    TabsFrame.Size = UDim2.new(0, 207, 0, 40)
    TabsFrame.AutomaticSize = "X"
    
    UIScale.Parent = TabsFrame
    UIScale.Scale = guilibrary.Scale

    guilibrary.TabsFrame = TabsFrame
    guilibrary.UIScale = UIScale

    if guilibrary.Device == "Mobile" then
        UIScale.Scale = guilibrary.MobileScale
        guilibrary.Scale = 0.45
    end

    function guilibrary:CreateTab(TabData)
        local tabname = TabData.Name
        local color = TabData.Color or Color3.fromRGB(83, 214, 110)
        local tabicon = TabData.TabIcon
        local Callback = TabData.Callback or function() end
        local tab = Instance.new("TextButton")
        local tabnametext = Instance.new("TextLabel")
        --local assetimage = Instance.new("ImageLabel")
        local showunshowbutton = Instance.new("TextButton")
        --local pinbutton = Instance.new("TextButton")
        local UIListLayout = Instance.new("UIListLayout")
        local UIListLayout2 = Instance.new("UIListLayout")
        local ActualScrollingFrame = Instance.new("ScrollingFrame")
        local background = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local TopPadding = Instance.new("UIPadding")
        local ScrollingFrame
    
        local tabtable = {
            Name = tabname,
            BaseColor = color,
            Pinned = false,
            ObjectsVisible = true,
            Callback =  (TabData.Callback or function() end),
            Position = UDim2.new(0, 40, 0, 40),
            Order = #Tabs,
            Toggles = {}
        }

        table.insert(Tabs, #Tabs)
    
        tab.Modal = true
        tab.Name = tabname .. "_TabTop"
        tab.Selectable = true
        tab.ZIndex = 1
        tab.Parent = TabsFrame
        tab.BackgroundColor3 = guipallet.Color1
        tab.BorderSizePixel = 0
        tab.Position = UDim2.new(0, 40, 0, 40)
        tab.Size = UDim2.new(0, 207, 0, 40)
        tab.Active = true
        tab.LayoutOrder = 1 + #Tabs
        tab.AutoButtonColor = false
        tab.Text = ""
        tabtable.MainObject = tab
        dragGUI(tab)
    
        tabnametext.Name = tabname
        tabnametext.Parent = tab
        tabnametext.ZIndex = tab.ZIndex + 1
        tabnametext.BackgroundColor3 = guipallet.Color1
        tabnametext.BorderSizePixel = 0
        tabnametext.Position = UDim2.new(0, 0, 0, 0)
        tabnametext.Size = UDim2.new(0, 207, 0, 32)
        tabnametext.Font = guipallet.Font
        tabnametext.Text = " " .. tabname
        tabnametext.TextColor3 = color
        tabnametext.TextSize = 22
        tabnametext.TextWrapped = true
        tabnametext.TextXAlignment = Enum.TextXAlignment.Left
        tabnametext.TextYAlignment = Enum.TextYAlignment.Top
        tabnametext.Selectable = true

        showunshowbutton.Parent = tabnametext
        showunshowbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        showunshowbutton.BackgroundTransparency = 1
        showunshowbutton.BorderSizePixel = 0
        showunshowbutton.Position = UDim2.new(0, 178, 0, 2.5)
        showunshowbutton.Size = UDim2.new(0, 20, 0, 20)
        showunshowbutton.Font = guipallet.Font
        showunshowbutton.Text = "-"
        showunshowbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
        showunshowbutton.TextTransparency = 0
        showunshowbutton.TextSize = 22

        --[[
        pinbutton.Parent = tabnametext
        pinbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        pinbutton.BackgroundTransparency = 1
        pinbutton.BorderSizePixel = 0
        pinbutton.Position = UDim2.new(0, 150, 0, 4)
        pinbutton.Size = UDim2.new(0, 20, 0, 20)
        pinbutton.Font = guipallet.Font
        pinbutton.Text = "📍"
        pinbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
        pinbutton.TextTransparency = 0.4
        pinbutton.TextSize = 22
        ]]
        
        --[[
        UIListLayout.Parent = tab
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 0)
        ]]

        UICorner.Parent = tab
        UICorner.CornerRadius = guilibrary.UICorners and guilibrary.UICornersRadius or UDim.new(0, 0)
        table.insert(guilibrary.UICornersTable, UICorner)

        TopPadding.Parent = tab
        TopPadding.PaddingTop = UDim.new(0, 10)

        ActualScrollingFrame.Name = "TabToggles"
        ActualScrollingFrame.Parent = tab
        ActualScrollingFrame.BackgroundTransparency = 1
        ActualScrollingFrame.BorderSizePixel = 0
        ActualScrollingFrame.Position = UDim2.new(0, 0, 1.08, 0)
        ActualScrollingFrame.Size = UDim2.new(0, 207, 0, 600)
        ActualScrollingFrame.ScrollBarThickness = 1
        ActualScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ActualScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

        if tabname == "Settings" or tabname == "Friends" then
            background.Name = "background"
            background.Parent = ActualScrollingFrame
            background.BackgroundColor3 = guipallet.Color2
            background.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
            background.Size = UDim2.new(0, 207, 0, 0)
            background.AutomaticSize = "Y"

            UIListLayout.Parent = background
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 8)
        end

        UIListLayout2.Parent = ActualScrollingFrame
        UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout2.Padding = UDim.new(0, 0)

        --[[
        function tabtable:Pin(bool)
            bool = bool or not tabtable.Pinned
            if bool then
                tabtable.Pinned = true
                pinbutton.TextTransparency = 0
                table.insert(guilibrary.pinnedobjects, tabtable)
            else
                tabtable.Pinned = false
                pinbutton.TextTransparency = 0.4
                table.remove(guilibrary.pinnedobjects, table.find(guilibrary.pinnedobjects, tabtable))
            end
        end
        ]]

        table.insert(connections, UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ActualScrollingFrame.CanvasSize = UDim2.new(0, UIListLayout2.AbsoluteContentSize.X, 0, UIListLayout2.AbsoluteContentSize.Y)
            if UIListLayout2.AbsoluteContentSize.Y < 600 then
                ActualScrollingFrame.CanvasSize = UDim2.new(0, UIListLayout2.AbsoluteContentSize.X, 0, 600)
            else
                ActualScrollingFrame.CanvasSize = UDim2.new(0, UIListLayout2.AbsoluteContentSize.X, 0, UIListLayout2.AbsoluteContentSize.Y)
            end
        end))

        table.insert(connections, showunshowbutton.MouseButton1Click:Connect(function()
            tabtable.ObjectsVisible = not tabtable.ObjectsVisible
            ActualScrollingFrame.Visible = not ActualScrollingFrame.Visible
            showunshowbutton.Text = (tabtable.ObjectsVisible and "-" or "+")
        end))

        --[[
        table.insert(connections, pinbutton.MouseButton1Click:Connect(function()
			tabtable:Pin()
		end))
        ]]

        if tabname == "Settings" or tabname == "Friends" then
            ScrollingFrame = background
        else
            ScrollingFrame = ActualScrollingFrame
        end

        function tabtable:CreateDivider(DividerText)
            local DividerFrame = Instance.new("Frame")
            local Divider = Instance.new("TextLabel")
            local DividerFrame2 = Instance.new("Frame")
            DividerFrame.Name = tabname .. "_FrameDivider"
            DividerFrame.Parent = ScrollingFrame or ScrollingFrame
            DividerFrame.BackgroundColor3 = guipallet.Color5
            DividerFrame.BorderSizePixel = 0
            DividerFrame.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            DividerFrame.Size = UDim2.new(0, 207, 0, 2)
            Divider.Name = tabname .. "_TextLabelDivider"
            Divider.Parent = ScrollingFrame or ScrollingFrame
            Divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Divider.BorderSizePixel = 0
            Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            Divider.Size = UDim2.new(0, 207, 0, 20)
            Divider.Font = guipallet.Font
            Divider.Text = DividerText
            Divider.TextColor3 = Color3.fromRGB(255, 255, 255)
            Divider.TextSize = 18
            Divider.TextXAlignment = Enum.TextXAlignment.Center
            DividerFrame2.Name = tabname .. "_FrameDivider"
            DividerFrame2.Parent = ScrollingFrame or ScrollingFrame
            DividerFrame2.BackgroundColor3 = guipallet.Color5
            DividerFrame2.BorderSizePixel = 0
            DividerFrame2.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            DividerFrame2.Size = UDim2.new(0, 207, 0, 2)
            return Divider
        end

        function tabtable:CreateSecondDivider(DividerText)
            local Divider = Instance.new("TextLabel")
            Divider.Name = tabname .. "_TextLabelDivider"
            Divider.Parent = ScrollingFrame
            Divider.BackgroundTransparency = 1
            Divider.BorderSizePixel = 0
            Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            Divider.Size = UDim2.new(0, 180, 0, 18)
            Divider.Font = guipallet.Font
            Divider.Text = DividerText
            Divider.TextColor3 = Color3.fromRGB(255, 255, 255)
            Divider.TextSize = 20
            Divider.TextXAlignment = Enum.TextXAlignment.Center
            Divider.TextYAlignment = Enum.TextYAlignment.Center
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
                Keybind = keybind,
                Callback = data.Callback or function() end,
                Instance = "Toggle"
            }

            table.insert(tabtable.Toggles, #tabtable.Toggles)

            local toggle = Instance.new("TextButton")
            local BindText = Instance.new("TextButton")
            local optionsframebutton = Instance.new("ImageButton")
            local togname = Instance.new("TextLabel")
            local optionframe = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")

            toggle.Name = title .. "_Toggle"
            toggle.Parent = ScrollingFrame
            toggle.BackgroundColor3 = guipallet.ToggleColor
            toggle.BorderSizePixel = 0
            toggle.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            toggle.Size = UDim2.new(0, 207, 0, 40)
            toggle.Text = ""

            togname.Parent = toggle
            togname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            togname.BackgroundTransparency = 1
            togname.BorderSizePixel = 0
            togname.Position = UDim2.new(0.0338164233, 0, 0.163378686, 0)
            togname.Size = UDim2.new(0, 192, 0, 26)
            togname.Font = guipallet.Font
            togname.Text = title
            togname.TextColor3 = Color3.fromRGB(255, 255, 255)
            togname.TextSize = 22.000
            togname.TextWrapped = true
            togname.TextXAlignment = Enum.TextXAlignment.Left

            optionsframebutton.Parent = toggle
            optionsframebutton.Position = UDim2.new(0, 170, 0, 2)
            optionsframebutton.Size = UDim2.new(0, 32, 0, 32)
            optionsframebutton.BackgroundTransparency = 1
            optionsframebutton.Image = "http://www.roblox.com/asset/?id=12809025337"
            optionsframebutton.Rotation = 90

            optionframe.Name = "OptionFrame" .. info.Name
            optionframe.Parent = ScrollingFrame
            optionframe.BackgroundColor3 = guipallet.Color2
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
            BindText.BackgroundTransparency = 1
            BindText.Position = UDim2.new(0.0989583358, 0, 0, 0)
            BindText.Size = UDim2.new(0, 175, 0, 33)
            BindText.Font = guipallet.Font
            BindText.Text = "Bind: none"
            BindText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindText.TextSize = 22
            BindText.TextXAlignment = Enum.TextXAlignment.Left
            BindText.TextYAlignment = Enum.TextYAlignment.Center

            ToggleTable.MainObject = toggle

            BindText.MouseEnter:Connect(function()
                focus.Elements["toggle_" .. title] = true
            end)
            
            BindText.MouseLeave:Connect(function()
                focus.Elements["toggle_" .. title] = false
            end)
            
            local oldkey = keybind.Name
            local isclicked
            local cooldown
            
            function ToggleTable:UpdateKeybind(remove, keybind)
                if remove then
                    oldkey = keybind
                    keybind = "none"
                    BindText.Text = "Bind: " .. keybind
                else
                    oldkey = keybind
                    keybind = keybind or "none"
                    BindText.Text = "Bind: " .. keybind
                end
            end
            
            BindText.MouseButton1Click:Connect(function()
                if not focus.Elements["toggle_" .. title] or isclicked then return end
                isclicked = true
                BindText.Text = "Bind: ..."
            
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    local inputName = input.KeyCode.Name
                    if inputName == "Unknown" and input.UserInputType == Enum.UserInputType.MouseButton2 then
                        isclicked = true
                        BindText.Text = "Bind: " .. (oldkey ~= nil and oldkey or "none")
                        connection:Disconnect()
                    elseif inputName == oldkey then
                        ToggleTable:UpdateKeybind(true)
                        connection:Disconnect()
                    elseif inputName ~= "Unknown" and inputName ~= oldkey then
                        if not isclicked then return end
                        ToggleTable:UpdateKeybind(false, inputName)
                        isclicked = false
                        cooldown = true
                        wait(0.5)
                        cooldown = false
                        connection:Disconnect()
                    end
                end)
            end)

            table.insert(connections, toggle.MouseButton2Click:Connect(function()
                optionframe.Visible = not optionframe.Visible
            end))

            table.insert(connections, optionsframebutton.MouseButton1Click:Connect(function()
                optionframe.Visible = not optionframe.Visible
            end))

            table.insert(connections, toggle.MouseButton1Click:Connect(function()
                local currentTime = tick()
            
                if currentTime - LastPress < 0.5 and OnMobile then
                    optionframe.Visible = not optionframe.Visible
                end
            
                LastPress = currentTime
            end))

            function ToggleTable:CreateDivider(DividerText)
                local Divider = Instance.new("TextLabel")
                Divider.Name = title .. "_TextLabelDivider"
                Divider.Parent = optionframe
                Divider.BackgroundTransparency = 1
                Divider.BorderSizePixel = 0
                Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
                Divider.Size = UDim2.new(0, 180, 0, 18)
                Divider.Font = guipallet.Font
                Divider.Text = DividerText
                Divider.TextColor3 = Color3.fromRGB(255, 255, 255)
                Divider.TextSize = 18
                Divider.TextXAlignment = Enum.TextXAlignment.Center
                Divider.TextYAlignment = Enum.TextYAlignment.Center
                return Divider
            end
            
            function ToggleTable:Toggle(silent, bool)
                bool = bool or (not ToggleTable.Enabled)
                silent = silent or false
                ToggleTable.Enabled = bool
            
                spawn(function()
                    Callback(bool)
                end)
            
                spawn(function()
                    --guilibrary:CreateNotification(title, (bool and "Enabled " or "Disabled ") .. title, 4, bool)
                end)
            
                toggle.BackgroundColor3 = (bool and ((guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2)) or guipallet.ToggleColor
            
                if not silent then
                    guilibrary:playsound("rbxassetid://421058925", 1)
                end
            end
            
            table.insert(connections, toggle.MouseButton1Click:Connect(function()
                ToggleTable:Toggle()
            end))
            
            table.insert(connections, UserInputService.InputBegan:Connect(function(input)
                if oldkey and not cooldown and not isclicked and input.KeyCode.Name == oldkey and not UserInputService:GetFocusedTextBox() then
                    ToggleTable:Toggle()
                end
            end))

            -- ColorSlider made by Wowzers abd Maanaaaa
            function ToggleTable:CreateColorSlider(argstable)
                local name = argstable.Name
                local value = argstable.Default or Color3.fromRGB(255, 255, 255)
                local rainbow = argstable.Rainbow or false
                local callback = argstable.Callback or argstable.Function or function() print(1) end
                local hue, sat, val = 0, 1, 1
                local dragging = nil
                local visible = false
                local optionObjects = {}
                local colorsliderapi = {
                    Name = name,
                    Value = value,
                    Rainbow = rainbow,
                    Callback = callback
                }
            
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
            
                local colorPickerFrame = Instance.new("Frame")
                local moreButton = Instance.new("ImageButton")
                local rainbowButton = Instance.new("TextButton")
                local hueSlider = Instance.new("Frame")
                local hueUICorner = Instance.new("UICorner")
                local hueText = Instance.new("TextLabel")
                local hueGradient = Instance.new("UIGradient")
                local hueKnob = Instance.new("Frame")
                local hueUICorner2 = Instance.new("UICorner")
                local saturationSlider = Instance.new("Frame")
                local saturationUICorner = Instance.new("UICorner")
                local saturationText = Instance.new("TextLabel")
                local saturationGradient = Instance.new("UIGradient")
                local saturationKnob = Instance.new("Frame")
                local saturationUICorner2 = Instance.new("UICorner")
                local valueSlider = Instance.new("Frame")
                local valueUICorner = Instance.new("UICorner")
                local valueText = Instance.new("TextLabel")
                local valueGradient = Instance.new("UIGradient")
                local valueKnob = Instance.new("Frame")
                local valueUICorner2 = Instance.new("UICorner")
                local currentColor = Instance.new("Frame")
                local currentColorUICorner = Instance.new("UICorner")
            
                colorPickerFrame.Name = "ColorPicker"
                colorPickerFrame.Size = UDim2.new(1, 0, 0, 132)
                colorPickerFrame.BackgroundTransparency = 1
                colorPickerFrame.Parent = optionframe

                moreButton.Name = "MoreButton"
                moreButton.Size = UDim2.new(0, 10, 0, 5)
                moreButton.Position = UDim2.new(0, 10 + getTextWidth(name, 15) + 5, 0, 5)
                moreButton.Rotation = 180
                moreButton.BackgroundTransparency = 1
                moreButton.Image = "rbxassetid://14368317595" -- arrow from vapev4
                moreButton.Parent = colorPickerFrame

                --[[next update
                rainbowButton.Name = "RainbowButton"
                rainbowButton.Size = UDim2.new(1, -30, 0, 5)
                rainbowButton.Position = UDim2.new(0, 20, 0, 5)
                rainbowButton.BackgroundTransparency = 1
                rainbowButton.Font = guipallet.Font
                rainbowButton.Text = "++"
                rainbowButton.TextSize = 25
                rainbowButton.TextColor3 = guipallet.TextColor
                rainbowButton.Parent = colorPickerFrame
                ]]
            
                hueSlider.Name = "HueSlider"
                hueSlider.Size = UDim2.new(1, -20, 0, 3)
                hueSlider.Position = UDim2.new(0, 10, 0, 29)
                hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                hueSlider.BorderSizePixel = 0
                hueSlider.Parent = colorPickerFrame

                hueUICorner.CornerRadius = UDim.new(0, 2)
                hueUICorner.Parent = hueSlider

                hueText.Name = "HueText"
                hueText.Size = UDim2.new(0, 30, 0, 15)
                hueText.Position = UDim2.new(0, 10, 0, 0)
                hueText.BackgroundTransparency = 1
                hueText.Text = name
                hueText.TextColor3 = guipallet.GrayTextColor
                hueText.Font = guipallet.Font
                hueText.TextSize = 15
                hueText.TextXAlignment = Enum.TextXAlignment.Left
                hueText.Parent = colorPickerFrame
            
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
                
                hueKnob.Name = "HueKnob"
                hueKnob.Size = UDim2.new(0, 15, 0, 15)
                hueKnob.Position = UDim2.new(0, 184.5, 0, -6)
                hueKnob.BorderSizePixel = 0
                hueKnob.Parent = hueSlider

                hueUICorner2.CornerRadius = UDim.new(1, 0)
                hueUICorner2.Parent = hueKnob
            
                saturationSlider.Name = "SaturationSlider"
                saturationSlider.Size = UDim2.new(1, -20, 0, 3)
                saturationSlider.Position = UDim2.new(0, 10, 0, 73)
                saturationSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                saturationSlider.BorderSizePixel = 0
                saturationSlider.Parent = colorPickerFrame
                table.insert(optionObjects, saturationSlider)

                saturationUICorner.CornerRadius = UDim.new(0, 2)
                saturationUICorner.Parent = saturationSlider

                saturationText.Name = "SaturationText"
                saturationText.Size = UDim2.new(0, 30, 0, 15)
                saturationText.Position = UDim2.new(0, 10, 0, 44)
                saturationText.BackgroundTransparency = 1
                saturationText.Text = "Saturation"
                saturationText.TextColor3 = guipallet.GrayTextColor
                saturationText.Font = guipallet.Font
                saturationText.TextSize = 15
                saturationText.TextXAlignment = Enum.TextXAlignment.Left
                saturationText.Parent = colorPickerFrame
                table.insert(optionObjects, saturationText)
            
                saturationGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, HSVtoRGB(0, 1, 1))
                })
                saturationGradient.Parent = saturationSlider
            
                saturationKnob.Name = "SaturationKnob"
                saturationKnob.Size = UDim2.new(0, 15, 0, 15)
                saturationKnob.Position = UDim2.new(0, 184.5, 0, -6)
                saturationKnob.BorderSizePixel = 0
                saturationKnob.Parent = saturationSlider
                table.insert(optionObjects, saturationKnob)

                saturationUICorner2.CornerRadius = UDim.new(1, 0)
                saturationUICorner2.Parent = saturationKnob

                valueSlider.Name = "valueSlider"
                valueSlider.Size = UDim2.new(1, -20, 0, 3)
                valueSlider.Position = UDim2.new(0, 10, 0, 117)
                valueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                valueSlider.BorderSizePixel = 0
                valueSlider.Parent = colorPickerFrame
                table.insert(optionObjects, valueSlider)

                valueUICorner.CornerRadius = UDim.new(0, 2)
                valueUICorner.Parent = valueSlider

                valueText.Name = "ValueText"
                valueText.Size = UDim2.new(0, 30, 0, 15)
                valueText.Position = UDim2.new(0, 10, 0, 88)
                valueText.BackgroundTransparency = 1
                valueText.Text = "Value"
                valueText.TextColor3 = guipallet.GrayTextColor
                valueText.Font = guipallet.Font
                valueText.TextSize = 15
                valueText.TextXAlignment = Enum.TextXAlignment.Left
                valueText.Parent = colorPickerFrame
                table.insert(optionObjects, valueText)
            
                valueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, HSVtoRGB(0, 1, 1))
                })
                valueGradient.Parent = valueSlider
            
                valueKnob.Name = "ValueKnob"
                valueKnob.Size = UDim2.new(0, 15, 0, 15)
                valueKnob.Position = UDim2.new(0, 184.5, 0, -6)
                valueKnob.BorderSizePixel = 0
                valueKnob.Parent = valueSlider
                table.insert(optionObjects, valueKnob)

                valueUICorner2.CornerRadius = UDim.new(1, 0)
                valueUICorner2.Parent = valueKnob

                currentColor.Name = "CurrentColor"
                currentColor.Size = UDim2.new(0, 18, 0, 18)
                currentColor.Position = UDim2.new(1, -30, 0, 0)
                currentColor.BackgroundColor3 = value
                currentColor.BorderColor3 = Color3.fromRGB(30, 30, 30)
                currentColor.BorderSizePixel = 0
                currentColor.Parent = colorPickerFrame

                currentColorUICorner.CornerRadius = UDim.new(0, 5)
                currentColorUICorner.Parent = currentColor

                --[[
                local function updateHue(hueValue)
                    hue = hueValue
                    saturationGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, HSVtoRGB(hue, 1, 1))
                    })
                    valueGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, HSVtoRGB(hue, 1, 1))
                    })
                    local color = HSVtoRGB(hue, sat, val)
                    currentColor.BackgroundColor3 = color
                    colorsliderapi.Value = color
                    colorsliderapi.Callback(color)
                end
            
                local function updateSaturation(satValue)
                    sat = satValue
                    local color = HSVtoRGB(hue, sat, val)
                    currentColor.BackgroundColor3 = color
                    colorsliderapi.Value = color
                    colorsliderapi.Callback(color)
                end
            
                local function updateValue(valValue)
                    val = valValue
                    local color = HSVtoRGB(hue, sat, val)
                    currentColor.BackgroundColor3 = color
                    colorsliderapi.Value = color
                    colorsliderapi.Callback(color)
                end
                ]]

                function colorsliderapi:Set(hueValue, satValue, valValue, rainbow)
                    hue = hueValue
                    sat = satValue or sat
                    val = valValue or val
                    local color = HSVtoRGB(hue, sat, val)
                    rainbow = rainbow or false

                    saturationGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, HSVtoRGB(hue, 1, val))
                    })
                    valueGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, HSVtoRGB(hue, sat, 1))
                    })
                    currentColor.BackgroundColor3 = color
                    if rainbow then
                        colorsliderapi.Rainbow = true
                        table.insert(guilibrary.rainbowObjects, colorsliderapi)
                    else
                        if guilibrary.rainbowObjects[colorsliderapi] then
                            table.remove(guilibrary.rainbowObjects, table.find(guilibrary.rainbowObjects, colorsliderapi))
                        end
                    end
                    callback(color)
                end

                table.insert(connections, moreButton.MouseButton1Click:Connect(function()
                    visible = not visible
                    for _, object in next, optionObjects do
                        object.Visible = visible
                    end
                    if visible then
                        colorPickerFrame.Size = UDim2.new(1, 0, 0, 132)
                        moreButton.Rotation = 0
                    else
                        colorPickerFrame.Size = UDim2.new(1, 0, 0, 44)
                        moreButton.Rotation = 180
                    end
                end))
            
                table.insert(connections, hueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = "hue"
                        local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                        hueKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                        colorsliderapi:Set(relativeX, sat, val)
                    end
                end))

                table.insert(connections, hueKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = "hue"
                        local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                        hueKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                        colorsliderapi:Set(relativeX, sat, val)
                    end
                end))
            
                table.insert(connections, saturationSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = "saturation"
                        local relativeX = math.clamp((input.Position.X - saturationSlider.AbsolutePosition.X) / saturationSlider.AbsoluteSize.X, 0, 1)
                        saturationKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                        colorsliderapi:Set(hue, relativeX, val)
                    end
                end))

                table.insert(connections, saturationKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = "saturation"
                        local relativeX = math.clamp((input.Position.X - saturationSlider.AbsolutePosition.X) / saturationSlider.AbsoluteSize.X, 0, 1)
                        saturationKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                        colorsliderapi:Set(hue, relativeX, val)
                    end
                end))
            
                table.insert(connections, valueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = "value"
                        local relativeX = math.clamp((input.Position.X - valueSlider.AbsolutePosition.X) / valueSlider.AbsoluteSize.X, 0, 1)
                        valueKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                        colorsliderapi:Set(hue, sat, relativeX)
                    end
                end))

                table.insert(connections, valueKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = "value"
                        local relativeX = math.clamp((input.Position.X - valueSlider.AbsolutePosition.X) / valueSlider.AbsoluteSize.X, 0, 1)
                        valueKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                        colorsliderapi:Set(hue, sat, relativeX)
                    end
                end))
            
                table.insert(connections, UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        if dragging == "hue" then
                            local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                            hueKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                            colorsliderapi:Set(relativeX, sat, val)
                        elseif dragging == "saturation" then
                            local relativeX = math.clamp((input.Position.X - saturationSlider.AbsolutePosition.X) / saturationSlider.AbsoluteSize.X, 0, 1)
                            saturationKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                            colorsliderapi:Set(hue,  relativeX, val)
                        elseif dragging == "value" then
                            local relativeX = math.clamp((input.Position.X - valueSlider.AbsolutePosition.X) / valueSlider.AbsoluteSize.X, 0, 1)
                            valueKnob.Position = UDim2.new(relativeX, -2.5, 0, -6)
                            colorsliderapi:Set(hue, sat, relativeX)
                        end
                    end
                end))
                
                table.insert(connections, UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = nil
                    end
                end))

                colorsliderapi:Set(0, 1, 1, false)

                for _, object in next, optionObjects do
                    object.Visible = visible
                end
                colorPickerFrame.Size = UDim2.new(1, 0, 0, 44)
            
                guilibrary.ObjectsThatCanBeSaved[name .. "ColorSlider"] = {
                    Table = colorsliderapi,
                    mainobject = colorPickerFrame,
                    Type = "ColorSlider"
                }
                return colorsliderapi
            end
            function ToggleTable:CreateSlider(argstable)
                local Value = argstable.Default or argstable.Min
                local min = argstable.Min
                local max = argstable.Max
                local round = argstable.Round or 0
                local Callback = argstable.Callback or argstable.Function or function() end
                local sliderapi = {
                    Value = Value,
                    Min = min,
                    Max = max,
                    Round = round,
                    Callback = Callback
                }

                local slider = Instance.new("TextButton")
                local SliderTextBox = Instance.new("TextBox")
                local slidertext = Instance.new("TextLabel")
                local slider_2 = Instance.new("Frame")
            
                slider.Name = "Slider"
                slider.Parent = optionframe
                slider.BackgroundColor3 = guipallet.Color2
                slider.BorderSizePixel = 0
                slider.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                slider.Size = UDim2.new(0, 180, 0, 34)
                slider.Text = ""
                slider.AutoButtonColor = false
            
                SliderTextBox.Name = "SliderTextBox"
                SliderTextBox.Parent = slider
                SliderTextBox.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2
                SliderTextBox.BackgroundTransparency = 1
                SliderTextBox.BorderSizePixel = 0
                SliderTextBox.Position = UDim2.new(0.0188679248, 0, 0, 0)
                SliderTextBox.Size = UDim2.new(0, 180, 0, 33)
                SliderTextBox.ZIndex = 1
                SliderTextBox.Font = guipallet.Font
                SliderTextBox.PlaceholderText = ""
                SliderTextBox.Text = ""
                SliderTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderTextBox.TextSize = 22
                SliderTextBox.TextXAlignment = Enum.TextXAlignment.Left
                SliderTextBox.TextEditable = false
                SliderTextBox.Visible = false

                slidertext.Name = "SliderText"
                slidertext.Parent = slider
                slidertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.BackgroundTransparency = 1
                slidertext.BorderSizePixel = 0
                slidertext.Position = UDim2.new(0.0188679248, 0, 0, 0)
                slidertext.Size = UDim2.new(0, 180, 0, 33)
                slidertext.ZIndex = 3
                slidertext.Font = guipallet.Font
                slidertext.Text = ""
                slidertext.TextColor3 = Color3.fromRGB(255, 255, 255)
                slidertext.TextSize = 22
                slidertext.TextXAlignment = Enum.TextXAlignment.Left
            
                slider_2.Name = "Slider_2"
                slider_2.Parent = slider
                slider_2.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2
                slider_2.BorderSizePixel = 0
                slider_2.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                slider_2.Size = UDim2.new(0, 0, 0, 34)
                slider_2.ZIndex = 2

                sliderapi.MainObject = slider
            
                local function slide(input)
                    local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    local value = math.floor(((((max - min) * sizeX) + min) * (10 ^ round)) + 0.5) / (10 ^ round)

                    slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
                    sliderapi.Value = value
                    slidertext.Text = argstable.Name .. ": " .. tostring(value)

                    if not argstable.OnInputEnded then
                        Callback(value)
                    end
                end
            
                local sliding = false
            
                table.insert(connections, slider.InputBegan:Connect(function(input)
                    local currentTime = tick()
                    local function HandleFocusLost(enter)
                        if enter then
                            local value = tonumber(SliderTextBox.Text)
                            if value then
                                sliderapi:Set(value, guilibrary.SliderCanOverride)
                            end
                        end
                        slidertext.Visible = true
                        SliderTextBox.Visible = false
                        SliderTextBox.TextEditable = false
                    end
                
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                        if guilibrary.SliderDoubleClick and currentTime - SliderLastPress < 0.5 then
                            slidertext.Visible = false
                            SliderTextBox.Visible = true
                            SliderTextBox.TextEditable = true
                            SliderTextBox:CaptureFocus()
                            SliderTextBox.FocusLost:Connect(HandleFocusLost)
                        else
                            SliderLastPress = currentTime
                            sliding = true
                            slide(input)
                        end
                    end
                end))
                
                table.insert(connections, SliderTextBox.FocusLost:Connect(function(enter)
                    if enter then
                        local value = tonumber(SliderTextBox.Text)
                        if value then
                            sliderapi:Set(value, guilibrary.SliderCanOverride)
                        end
                    end
                    slidertext.Visible = true
                    SliderTextBox.Visible = false
                    SliderTextBox.TextEditable = false
                end))
                
                table.insert(connections, slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if argstable.OnInputEnded then
                            Callback(sliderapi.Value)
                        end
                        sliding = false
                    end
                end))
                
                table.insert(connections, UserInputService.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService.MouseEnabled) or (input.UserInputType == Enum.UserInputType.Touch) then
                        if sliding then
                            slide(input)
                        end
                    end
                end))
            
                function sliderapi:Set(value, CanOverride)
                    local SizeValue = math.floor((math.clamp(value, min, max) * (10 ^ round)) + 0.5) / (10 ^ round)
                    if CanOverride then
                        value = value
                    else
                        value = SizeValue
                    end

                    sliderapi.Value = value
                    slider_2.Size = UDim2.new((SizeValue - min) / (max - min), 0, 1, 0)
                    slidertext.Text = argstable.Name .. ": " .. tostring(value)

                    Callback(value)
                end

                sliderapi:Set(sliderapi.Value)
            
                guilibrary.ObjectsThatCanBeSaved[argstable.Name.."Slider"] = {
                    Table = sliderapi,
                    mainobject = slider,
                    Type = "Slider"
                }
                return sliderapi
            end
            function ToggleTable:CreateDropDown(argstable)
                local name = argstable.Name
                local list = argstable.List or {}
                local value = argstable.Default or list[1] and list[1] or "nothing"
                local Callback = argstable.Callback or argstable.Function or function() end
                local dropdownapi = {
                    Name = name,
                    Value = value,
                    List = list,
                    Callback = Callback
                }
            
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
            
                local Dropdown = Instance.new("TextLabel")
                local DropdownOptions = Instance.new("Frame")
                local DropdownList = Instance.new("UIListLayout")
                local DropdownOptionsButton = Instance.new("TextButton")

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = optionframe
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 1
                Dropdown.BorderSizePixel = 0
                Dropdown.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
                Dropdown.Size = UDim2.new(0, 175, 0, 25)
                Dropdown.Font = guipallet.Font
                Dropdown.Text = name .. ": " .. value
                Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.TextSize = 22
                Dropdown.TextWrapped = true
                Dropdown.TextXAlignment = Enum.TextXAlignment.Left
                Dropdown.TextYAlignment = Enum.TextYAlignment.Bottom
                Dropdown.ZIndex = 5

                DropdownOptions.Name = "DropdownOptions"
                DropdownOptions.Parent = Dropdown
                DropdownOptions.BackgroundColor3 = Color3.new(255, 255, 255)
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.BorderSizePixel = 0
                DropdownOptions.Position = UDim2.new(0, 0, 1, 0)
                DropdownOptions.Size = UDim2.new(0, 175, 0, 25)
                DropdownOptions.Visible = false
                DropdownOptions.ZIndex = 50

                DropdownList.Name = "DropdownList"
                DropdownList.Parent = DropdownOptions
                DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
                DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownList.Padding = UDim.new(0, 0)

                DropdownOptionsButton.Name = "DropdownOptionsButton"
                DropdownOptionsButton.Parent = Dropdown
                DropdownOptionsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownOptionsButton.BackgroundTransparency = 1
                DropdownOptionsButton.BorderSizePixel = 0
                DropdownOptionsButton.Position = UDim2.new(0.942857146, 0, 0, 0)
                DropdownOptionsButton.Size = UDim2.new(0, 25, 0, 25)
                DropdownOptionsButton.Font = guipallet.Font
                DropdownOptionsButton.Text = ">"
                DropdownOptionsButton.Rotation = 90
                DropdownOptionsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownOptionsButton.TextSize = 22
                DropdownOptionsButton.TextWrapped = true

                dropdownapi.MainObject = Dropdown
            
                function dropdownapi:CreateOptionButton(name)
                    local button = Instance.new("TextButton")

                    button.Name = name
                    button.Parent = DropdownOptions
                    button.BackgroundColor3 = guipallet.Color4
                    button.BorderSizePixel = 0
                    button.Size = UDim2.new(0, 175, 0, 25)
                    button.Font = guipallet.Font
                    button.Text = name
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextSize = 22
                    button.TextWrapped = true
                    button.TextXAlignment = Enum.TextXAlignment.Left
                    button.ZIndex = 55

                    button.MouseButton1Click:Connect(function()
                        dropdownapi:Select(name)
                        DropdownOptions.Visible = false
                    end)
                end

                for i, v in pairs(list) do
                    dropdownapi:CreateOptionButton(v)
                end

                table.insert(connections, DropdownOptionsButton.MouseButton1Click:Connect(function()
                    if DropdownOptions.Visible then
                        DropdownOptions.Visible = false
                        DropdownOptionsButton.Rotation = 90
                    else
                        DropdownOptions.Visible = true
                        DropdownOptionsButton.Rotation = -90
                    end
                end))

                function dropdownapi:Select(name)
                    if dropdownapi.List[name] or guilibrary:findStringInTable(dropdownapi.List, name) then
                        dropdownapi.Value = dropdownapi.List[name] or dropdownapi.List[guilibrary:findStringInTable(dropdownapi.List, name)]
                        Dropdown.Text =  argstable.Name .. ": " .. tostring(name)
                        Callback(name)
                    end
                end

                dropdownapi:Select(value)
            
                guilibrary.ObjectsThatCanBeSaved[argstable.Name.."Dropdown"] = {
                    Table = dropdownapi,
                    mainobject = Dropdown,
                    Type = "Dropdown",
                    Tab = TabsFrame.Name
                }
                
                return dropdownapi
            end               
            function ToggleTable:CreateToggle(argstable)
                local name = argstable.Name
                local value = argstable.Default or false
                local Callback = argstable.Callback or argstable.Function or function() end
                local optiontoggleapi = {
                    Name = name,
                    Enabled = value,
                    Callback = Callback
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
                Label.Font = guipallet.Font
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextSize = #name > 12 and 22 or 22 - #name
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Text = name
            
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Label
                ToggleButton.BackgroundColor3 = guipallet.Color3
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(0.817, 0, 0.074, 0)
                ToggleButton.Size = UDim2.new(0, 29, 0, 29)
                ToggleButton.ZIndex = 2
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false
            
                ActiveFrame.Name = "ActiveFrame"
                ActiveFrame.Parent = Label
                ActiveFrame.BackgroundColor3 = guipallet.Color3
                ActiveFrame.BorderSizePixel = 0
                ActiveFrame.Position = UDim2.new(0, 141, 0, 5)
                ActiveFrame.Size = UDim2.new(0, 24, 0, 24)
                ActiveFrame.ZIndex = 3
            
                optiontoggleapi.MainObject = Label
            
                function optiontoggleapi:Toggle(bool)
                    bool = bool or not optiontoggleapi.Enabled
                    value = bool
                    optiontoggleapi.Enabled = bool
            
                    spawn(function()
                        Callback(bool)
                    end)
            
                    ActiveFrame.BackgroundColor3 = (bool and ((guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2)) or guipallet.Color3
                end

                optiontoggleapi:Toggle(false)
            
                table.insert(connections, ToggleButton.MouseButton1Click:Connect(function()
                    optiontoggleapi:Toggle()
                end))

                guilibrary.ObjectsThatCanBeSaved[argstable.Name.."Toggle"] = {
                    Table = optiontoggleapi,
                    mainobject = Label,
                    Type = "OptionToggle"
                }
            
                return optiontoggleapi
            end
            function ToggleTable:CreateButton(argstable)
                local name = argstable.Name
                local Callback = argstable.Callback or argstable.Function or function() end
                local buttontable = {
                    Name = name,
                    Callback = Callback
                }

                local button = Instance.new("TextButton")

                button.Name = name.."_Button"
                button.Parent = optionframe
                button.BackgroundColor3 = guipallet.ToggleColor
                button.BackgroundTransparency = 0.5
                button.BorderSizePixel = 0
                button.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
                button.Size = UDim2.new(0, 175, 0, 25)
                button.Font = guipallet.Font
                button.Text = name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 22.000
                button.TextWrapped = true
                button.TextXAlignment = Enum.TextXAlignment.Center
                button.TextYAlignment = Enum.TextYAlignment.Center

                table.insert(connections, button.MouseButton1Click:Connect(function()
                    Callback()
                end))

                return buttontable
            end
            function ToggleTable:CreateTextBox(argstable)
                local name = argstable.Name
                local value = argstable.DefaultValue or ""
                local PlaceholderText = argstable.PlaceholderText or "nil"
                local Callback = argstable.Callback or argstable.Function or function() end
                local textboxapi = {
                    Name = name,
                    Value = value,
                    PlaceholderText = argstable.PlaceholderText,
                    Callback = Callback
                }
                
                local textbox_background = Instance.new("Frame")
                local textbox = Instance.new("TextBox")

                textbox_background.Name = "textboxbackground"
                textbox_background.Parent = optionframe
                textbox_background.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                textbox_background.BorderSizePixel = 0
                textbox_background.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
                textbox_background.Size = UDim2.new(0, 180, 0, 33)

                textbox.Name = argstable.Name .. "TextBox"
                textbox.Parent = textbox_background
                textbox.BackgroundColor3 = guipallet.Color2
                textbox.BackgroundTransparency = 1
                textbox.BorderSizePixel = 0
                textbox.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
                textbox.Size = UDim2.new(0, 180, 0, 33)
                textbox.Font = guipallet.Font
                textbox.Text = value
                textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
                textbox.TextSize = 22
                textbox.PlaceholderText = PlaceholderText

                textboxapi.MainObject = textbox_background

                local focused = false
                function textboxapi:Set(value)
                    textbox.Text = value
                    textboxapi.Value = value
                    Callback(value)
                end
                
                table.insert(connections, textbox.FocusLost:Connect(function()
                    textboxapi:Set(textbox.Text)
                end))
            
                guilibrary.Objects[argstable.Name.."TextBox"] = {
                    Table = textboxapi,
                    mainobject = textbox,
                    Type = "TextBox"
                }
                
                return textboxapi
            end

            function ToggleTable:CreateTextList(argstable)
                local name = argstable.Name
                local list = argstable.DefaultList or {}
                local PlaceholderText = argstable.PlaceholderText or "enter something..."
                local Callback = argstable.Callback or argstable.Function or function() end
                local count = 0
                local textlistapi = {
                    Name = argstable.Name,
                    List = list,
                    PlaceholderText = PlaceholderText,
                    Callback = Callback
                }
                
                local textListBackground = Instance.new("Frame")
                local textListBox = Instance.new("TextBox")
                local addToListButton = Instance.new("TextButton")
                local listFrame = Instance.new("ScrollingFrame")
                local uiListLayout = Instance.new("UIListLayout")

                textListBackground.Name = "textboxbackground"
                textListBackground.Parent = optionframe
                textListBackground.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                textListBackground.BorderSizePixel = 0
                textListBackground.Position = UDim2.new(0, 0, 0, 0)
                textListBackground.Size = UDim2.new(0, 190, 0, 33)
                textlistapi.MainObject = textListBackground

                textListBox.Name = argstable.Name .. "TextBox"
                textListBox.Parent = textListBackground
                textListBox.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                textListBox.BackgroundTransparency = 1
                textListBox.BorderSizePixel = 0
                textListBox.Position = UDim2.new(0, 0, 0, 0)
                textListBox.Size = UDim2.new(0, 150, 0, 33)
                textListBox.Font = guipallet.Font
                textListBox.Text = ""
                textListBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textListBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
                textListBox.TextSize = 22
                textListBox.PlaceholderText = "  "..PlaceholderText

                addToListButton.Name = "AddToListButton"
                addToListButton.Parent = textListBackground
                addToListButton.BackgroundColor3 = guipallet.Color2
                addToListButton.BackgroundTransparency = 1
                addToListButton.BorderSizePixel = 0
                addToListButton.Position = UDim2.new(0.888888895, 0, 0, 0)
                addToListButton.AutoButtonColor = false
                addToListButton.Size = UDim2.new(0, 25, 0, 33)
                addToListButton.Font = guipallet.Font
                addToListButton.Text = "+"
                addToListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                addToListButton.TextSize = 25

                listFrame.Name = "ListFrame"
                listFrame.Parent = optionframe
                listFrame.BackgroundTransparency = 1
                listFrame.BorderSizePixel = 0
                listFrame.Position = UDim2.new(0, 0, 0, 0)
                listFrame.Size = UDim2.new(0, 180, 0, 1)
                listFrame.ScrollBarThickness = 1
                listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

                uiListLayout.Parent = listFrame
                uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiListLayout.Padding = UDim.new(0, 3)

                table.insert(connections, uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    --ListFrame.CanvasSize = UDim2.new(0, uiListLayout.AbsoluteContentSize.X, 0, uiListLayout.AbsoluteContentSize.Y)
                    if uiListLayout.AbsoluteContentSize.Y > 99 then
                        listFrame.Size = UDim2.new(0, uiListLayout.AbsoluteContentSize.X, 0, 99)
                        listFrame.CanvasSize = UDim2.new(0, uiListLayout.AbsoluteContentSize.X, 0, count * 28)
                    else
                        listFrame.Size = UDim2.new(0, uiListLayout.AbsoluteContentSize.X, 0, uiListLayout.AbsoluteContentSize.Y)
                    end
                end))

                local textlistobjects = {}

                function textlistapi:CreateListObject(text)
                    if not textlistobjects[text] then
                        local listobject = Instance.new("TextButton")
                        local removebutton = Instance.new("TextButton")
                        listobject.Name = "ListObject"
                        listobject.Parent = listFrame
                        listobject.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                        listobject.BorderSizePixel = 0
                        listobject.Size = UDim2.new(0, 180, 0, 25)
                        listobject.Font = guipallet.Font
                        listobject.Text = "  " .. text
                        listobject.TextColor3 = Color3.fromRGB(255, 255, 255)
                        listobject.TextSize = 22
                        listobject.TextXAlignment = Enum.TextXAlignment.Left
                        listobject.TextYAlignment = Enum.TextYAlignment.Top
                        removebutton.Parent = listobject
                        removebutton.BackgroundTransparency = 1
                        removebutton.Size = UDim2.new(0, 25, 0, 25)
                        removebutton.Position = UDim2.new(0.888888895, 0, 0, 0)
                        removebutton.Font = guipallet.Font
                        removebutton.Text = "-"
                        removebutton.TextColor3 = guipallet.TextColor
                        removebutton.TextSize = 22
                        textlistobjects[text] = listobject
                        table.insert(list, text)
                        count = count + 1

                        Callback(text)

                        table.insert(connections, listobject.MouseButton1Click:Connect(function()
                            if guilibrary.textlist.lmb then
                                listobject:Destroy()
                                textlistobjects[text] = nil
                                count = count - 1
                                table.remove(list, guilibrary:findStringInTable(list, text))
                            end
                        end))

                        table.insert(connections, listobject.MouseButton2Click:Connect(function()
                            if guilibrary.textlist.rmb then
                                listobject:Destroy()
                                textlistobjects[text] = nil
                                count = count - 1
                                table.remove(list, guilibrary:findStringInTable(list, text))
                            end
                        end))

                        table.insert(connections, removebutton.MouseButton1Click:Connect(function()
                            listobject:Destroy()
                            textlistobjects[text] = nil
                            count = count - 1
                            table.remove(list, guilibrary:findStringInTable(list, text))
                        end))
                    end
                end

                addToListButton.MouseButton1Click:Connect(function()
                    textlistapi:CreateListObject(textListBox.Text)
                    textListBox.Text = ""
                end)

                for _, Name in next, list do
                    textlistapi:CreateListObject(Name)
                end
            
                guilibrary.ObjectsThatCanBeSaved[argstable.Name .. "TextList"] = {
                    Table = textlistapi, 
                    mainobject = textListBackground, 
                    textbox = textListBox,
                    Type = "TextList"
                }
                return textlistapi
            end

            -- Note: this is still ToggleTable:CreateToggle function
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

            guilibrary.ObjectsThatCanBeSaved[data.Name.."Toggle"] = {
                Table = ToggleTable,
                mainobject = toggle, 
                OptionFrame = optionframe,
                Type = "Toggle",
            }
            return ToggleTable
        end

        function tabtable:CreateSlider(argstable)
            local Value = argstable.Default or argstable.Min
            local min = argstable.Min
            local max = argstable.Max
            local round = argstable.Round or 0
            local Callback = argstable.Callback or argstable.Function or function() end
            local sliderapi = {
                Value = Value,
                Min = min,
                Max = max,
                Round = round,
                Callback = Callback
            }

            local slider = Instance.new("TextButton")
            local SliderTextBox = Instance.new("TextBox")
            local slidertext = Instance.new("TextLabel")
            local slider_2 = Instance.new("Frame")
        
            slider.Name = "Slider"
            slider.Parent = ScrollingFrame
            slider.BackgroundColor3 = guipallet.ToggleColor
            slider.BorderSizePixel = 0
            slider.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
            slider.Size = UDim2.new(0, 180, 0, 34)
            slider.Text = ""
            slider.AutoButtonColor = false
        
            SliderTextBox.Name = "SliderTextBox"
            SliderTextBox.Parent = slider
            SliderTextBox.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2
            SliderTextBox.BackgroundTransparency = 1
            SliderTextBox.BorderSizePixel = 0
            SliderTextBox.Position = UDim2.new(0.0188679248, 0, 0, 0)
            SliderTextBox.Size = UDim2.new(0, 180, 0, 33)
            SliderTextBox.ZIndex = 4
            SliderTextBox.Font = guipallet.Font
            SliderTextBox.PlaceholderText = ""
            SliderTextBox.Text = ""
            SliderTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTextBox.TextSize = 22
            SliderTextBox.TextXAlignment = Enum.TextXAlignment.Left
            SliderTextBox.TextEditable = false
            SliderTextBox.Visible = false

            slidertext.Name = "SliderText"
            slidertext.Parent = slider
            slidertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            slidertext.BackgroundTransparency = 1
            slidertext.BorderSizePixel = 0
            slidertext.Position = UDim2.new(0.0188679248, 0, 0, 0)
            slidertext.Size = UDim2.new(0, 180, 0, 33)
            slidertext.ZIndex = 3
            slidertext.Font = guipallet.Font
            slidertext.Text = ""
            slidertext.TextColor3 = Color3.fromRGB(255, 255, 255)
            slidertext.TextSize = 22
            slidertext.TextXAlignment = Enum.TextXAlignment.Left
        
            slider_2.Name = "Slider_2"
            slider_2.Parent = slider
            slider_2.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2
            slider_2.BorderSizePixel = 0
            slider_2.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
            slider_2.Size = UDim2.new(0, 0, 0, 34)
            slider_2.ZIndex = 2

            sliderapi.MainObject = slider
        
            local function slide(input)
                local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local value = math.floor(((((max - min) * sizeX) + min) * (10 ^ round)) + 0.5) / (10 ^ round)

                slider_2.Size = UDim2.new(sizeX, 0, 1, 0)
                sliderapi.Value = value
                slidertext.Text = argstable.Name .. ": " .. tostring(value)

                if not argstable.OnInputEnded then
                    Callback(value)
                end
            end
        
            local sliding = false
        
            table.insert(connections, slider.InputBegan:Connect(function(input)
                local currentTime = tick()
                local function HandleFocusLost(enter)
                    if enter then
                        local value = tonumber(SliderTextBox.Text)
                        if value then
                            sliderapi:Set(value, guilibrary.SliderCanOverride)
                        end
                    end
                    slidertext.Visible = true
                    SliderTextBox.Visible = false
                    SliderTextBox.TextEditable = false
                end
            
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                    if guilibrary.SliderDoubleClick and currentTime - SliderLastPress < 0.5 then
                        slidertext.Visible = false
                        SliderTextBox.Visible = true
                        SliderTextBox.TextEditable = true
                        SliderTextBox:CaptureFocus()
                        SliderTextBox.FocusLost:Connect(HandleFocusLost)
                    else
                        SliderLastPress = currentTime
                        sliding = true
                        slide(input)
                    end
                end
            end))
            
            table.insert(connections, SliderTextBox.FocusLost:Connect(function(enter)
                if enter then
                    local value = tonumber(SliderTextBox.Text)
                    if value then
                        sliderapi:Set(value, guilibrary.SliderCanOverride)
                    end
                end
                slidertext.Visible = true
                SliderTextBox.Visible = false
                SliderTextBox.TextEditable = false
            end))
            
            table.insert(connections, slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if argstable.OnInputEnded then
                        Callback(sliderapi.Value)
                    end
                    sliding = false
                end
            end))
            
            table.insert(connections, UserInputService.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService.MouseEnabled) or (input.UserInputType == Enum.UserInputType.Touch) then
                    if sliding then
                        slide(input)
                    end
                end
            end))
        
            function sliderapi:Set(value, CanOverride)
                local SizeValue = math.floor((math.clamp(value, min, max) * (10 ^ round)) + 0.5) / (10 ^ round)
                if CanOverride then
                    value = value
                else
                    value = SizeValue
                end

                sliderapi.Value = value
                slider_2.Size = UDim2.new((SizeValue - min) / (max - min), 0, 1, 0)
                slidertext.Text = argstable.Name .. ": " .. tostring(value)

                Callback(value)
            end

            sliderapi:Set(sliderapi.Value)
        
            guilibrary.ObjectsThatCanBeSaved[argstable.Name.."Slider"] = {
                Table = sliderapi,
                mainobject = slider,
                Type = "Slider"
            }
            return sliderapi
        end
        function tabtable:CreateDropDown(argstable)
            local name = argstable.Name
            local list = argstable.List or {}
            local value = argstable.Default or list[1] and list[1] or "nothing"
            local Callback = argstable.Callback or argstable.Function or function() end
            local dropdownapi = {
                Name = name,
                Value = value,
                List = list,
                Callback = Callback
            }
        
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
        
            local Dropdown = Instance.new("TextLabel")
            local DropdownOptions = Instance.new("Frame")
            local DropdownList = Instance.new("UIListLayout")
            local DropdownOptionsButton = Instance.new("TextButton")

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = ScrollingFrame
            Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.BackgroundTransparency = 1
            Dropdown.BorderSizePixel = 0
            Dropdown.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
            Dropdown.Size = UDim2.new(0, 175, 0, 25)
            Dropdown.Font = guipallet.Font
            Dropdown.Text = name .. ": " .. value
            Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.TextSize = 22
            Dropdown.TextWrapped = true
            Dropdown.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.TextYAlignment = Enum.TextYAlignment.Bottom
            Dropdown.ZIndex = 5

            DropdownOptions.Name = "DropdownOptions"
            DropdownOptions.Parent = Dropdown
            DropdownOptions.BackgroundColor3 = Color3.new(255, 255, 255)
            DropdownOptions.BackgroundTransparency = 1
            DropdownOptions.BorderSizePixel = 0
            DropdownOptions.Position = UDim2.new(0, 0, 1, 0)
            DropdownOptions.Size = UDim2.new(0, 175, 0, 25)
            DropdownOptions.Visible = false
            DropdownOptions.ZIndex = 10

            DropdownList.Name = "DropdownList"
            DropdownList.Parent = DropdownOptions
            DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 0)

            DropdownOptionsButton.Name = "DropdownOptionsButton"
            DropdownOptionsButton.Parent = Dropdown
            DropdownOptionsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownOptionsButton.BackgroundTransparency = 1
            DropdownOptionsButton.BorderSizePixel = 0
            DropdownOptionsButton.Position = UDim2.new(0.942857146, 0, 0, 0)
            DropdownOptionsButton.Size = UDim2.new(0, 25, 0, 25)
            DropdownOptionsButton.Font = guipallet.Font
            DropdownOptionsButton.Text = ">"
            DropdownOptionsButton.Rotation = 90
            DropdownOptionsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownOptionsButton.TextSize = 22
            DropdownOptionsButton.TextWrapped = true

            dropdownapi.MainObject = Dropdown
        
            function dropdownapi:CreateOptionButton(name)
                local button = Instance.new("TextButton")

                button.Name = name
                button.Parent = DropdownOptions
                button.BackgroundColor3 = guipallet.Color4
                button.BorderSizePixel = 0
                button.Size = UDim2.new(0, 175, 0, 25)
                button.Font = guipallet.Font
                button.Text = name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 22
                button.TextWrapped = true
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.ZIndex = 12

                button.MouseButton1Click:Connect(function()
                    dropdownapi:Select(name)
                    DropdownOptions.Visible = false
                end)
            end

            for i, v in pairs(list) do
                dropdownapi:CreateOptionButton(v)
            end

            table.insert(connections, DropdownOptionsButton.MouseButton1Click:Connect(function()
                if DropdownOptions.Visible then
                    DropdownOptions.Visible = false
                    DropdownOptionsButton.Rotation = 90
                else
                    DropdownOptions.Visible = true
                    DropdownOptionsButton.Rotation = -90
                end
            end))

            function dropdownapi:Select(name)
                if dropdownapi.List[name] or stringtablefind(dropdownapi.List, name) then
                    dropdownapi.Value = dropdownapi.List[name] or dropdownapi.List[stringtablefind(dropdownapi.List, name)]
                    Dropdown.Text =  argstable.Name .. ": " .. tostring(name)
                    Callback(name)
                end
            end

            dropdownapi:Select(value)
        
            guilibrary.ObjectsThatCanBeSaved[argstable.Name.."Dropdown"] = {
                Table = dropdownapi,
                mainobject = Dropdown,
                Type = "Dropdown",
                Tab = TabsFrame.Name
            }
            
            return dropdownapi
        end               
        function tabtable:CreateSecondToggle(argstable)
            local name = argstable.Name
            local value = argstable.Default or false
            local Callback = argstable.Callback or argstable.Function or function() end
            local optiontoggleapi = {
                Name = name,
                Enabled = value,
                Callback = Callback
            }
        
            local Label = Instance.new("TextLabel")
            local ActiveFrame = Instance.new("Frame")
            local ToggleButton = Instance.new("TextButton")
        
            Label.Name = "Label"
            Label.Parent = ScrollingFrame
            Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0.091, 0, 0.503, 0)
            Label.Size = UDim2.new(0, 170, 0, 32)
            Label.Font = guipallet.Font
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 22
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text = argstable.Name
        
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = Label
            ToggleButton.BackgroundColor3 = guipallet.Color3
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(0.817, 0, 0.074, 0)
            ToggleButton.Size = UDim2.new(0, 29, 0, 29)
            ToggleButton.ZIndex = 2
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
        
            ActiveFrame.Name = "ActiveFrame"
            ActiveFrame.Parent = Label
            ActiveFrame.BackgroundColor3 = guipallet.Color3
            ActiveFrame.BorderSizePixel = 0
            ActiveFrame.Position = UDim2.new(0, 141, 0, 5)
            ActiveFrame.Size = UDim2.new(0, 24, 0, 24)
            ActiveFrame.ZIndex = 3
        
            optiontoggleapi.MainObject = Label
        
            function optiontoggleapi:Toggle(bool)
                bool = bool or not optiontoggleapi.Enabled
                value = bool
                optiontoggleapi.Enabled = bool
        
                spawn(function()
                    Callback(bool)
                end)
        
                ActiveFrame.BackgroundColor3 = (bool and ((guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2)) or guipallet.Color3
            end

            optiontoggleapi:Toggle(false)
        
            table.insert(connections, ToggleButton.MouseButton1Click:Connect(function()
                optiontoggleapi:Toggle()
            end))

            guilibrary.ObjectsThatCanBeSaved[argstable.Name.."Toggle"] = {
                Table = optiontoggleapi,
                mainobject = Label,
                Type = "OptionToggle"
            }
        
            return optiontoggleapi
        end
        function tabtable:CreateButton(argstable)
            local name = argstable.Name
            local Callback = argstable.Callback or argstable.Function or function() end
            local buttontable = {
                Name = name,
                Callback = Callback
            }

            local button = Instance.new("TextButton")

            button.Name = name.."_Button"
            button.Parent = ScrollingFrame
            button.BackgroundColor3 = guipallet.ToggleColor
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 0
            button.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
            button.Size = UDim2.new(0, 175, 0, 25)
            button.Font = guipallet.Font
            button.Text = name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 22.000
            button.TextWrapped = true
            button.TextXAlignment = Enum.TextXAlignment.Center
            button.TextYAlignment = Enum.TextYAlignment.Center

            table.insert(connections, button.MouseButton1Click:Connect(function()
                Callback()
            end))

            return buttontable
        end
        function tabtable:CreateTextBox(argstable)
            local name = argstable.Name
            local value = argstable.DefaultValue or ""
            local PlaceholderText = argstable.PlaceholderText or "nil"
            local Callback = argstable.Callback or argstable.Function or function() end
            local textboxapi = {
                Name = name,
                Value = value,
                PlaceholderText = argstable.PlaceholderText,
                Callback = Callback
            }
            
            local textbox_background = Instance.new("Frame")
            local textbox = Instance.new("TextBox")

            textbox_background.Name = "textboxbackground"
            textbox_background.Parent = ScrollingFrame
            textbox_background.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
            textbox_background.BorderSizePixel = 0
            textbox_background.Position = UDim2.new(0.0833333358, 0, 0.109391868, 0)
            textbox_background.Size = UDim2.new(0, 180, 0, 33)

            textbox.Name = argstable.Name .. "TextBox"
            textbox.Parent = textbox_background
            textbox.BackgroundColor3 = guipallet.ToggleColor
            textbox.BackgroundTransparency = 1
            textbox.BorderSizePixel = 0
            textbox.Position = UDim2.new(0.00786163565, 0, -0.00825500488, 0)
            textbox.Size = UDim2.new(0, 180, 0, 33)
            textbox.Font = guipallet.Font
            textbox.Text = value
            textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
            textbox.TextSize = 22
            textbox.PlaceholderText = PlaceholderText

            textboxapi.MainObject = textbox_background

            local focused = false
            function textboxapi:Set(value)
                textbox.Text = value
                textboxapi.Value = value
                Callback(value)
            end
            
            table.insert(connections, textbox.FocusLost:Connect(function()
                textboxapi:Set(textbox.Text)
            end))
        
            guilibrary.Objects[argstable.Name.."TextBox"] = {
                Table = textboxapi,
                mainobject = textbox,
                Type = "TextBox"
            }
            
            return textboxapi
        end

        function tabtable:CreateTextList(argstable)
            local name = argstable.Name
            local list = argstable.DefaultList or {}
            local PlaceholderText = argstable.PlaceholderText or "enter something..."
            local Callback = argstable.Callback or argstable.Function or function() end
            local count = 0
            local textlistapi = {
                Name = argstable.Name,
                List = list,
                PlaceholderText = PlaceholderText,
                Callback = Callback
            }
            
            local TextListBackground = Instance.new("Frame")
            local TextListBox = Instance.new("TextBox")
            local AddToListButton = Instance.new("TextButton")
            local ListFrame = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")

            TextListBackground.Name = "textboxbackground"
            TextListBackground.Parent = ScrollingFrame
            TextListBackground.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
            TextListBackground.BorderSizePixel = 0
            TextListBackground.Position = UDim2.new(0, 0, 0, 0)
            TextListBackground.Size = UDim2.new(0, 190, 0, 33)
            textlistapi.MainObject = TextListBackground

            TextListBox.Name = argstable.Name .. "TextBox"
            TextListBox.Parent = TextListBackground
            TextListBox.BackgroundColor3 = guipallet.ToggleColor
            TextListBox.BackgroundTransparency = 1
            TextListBox.BorderSizePixel = 0
            TextListBox.Position = UDim2.new(0, 0, 0, 0)
            TextListBox.Size = UDim2.new(0, 150, 0, 33)
            TextListBox.Font = guipallet.Font
            TextListBox.Text = ""
            TextListBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextListBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
            TextListBox.TextSize = 22
            TextListBox.PlaceholderText = PlaceholderText

            AddToListButton.Name = "AddToListButton"
            AddToListButton.Parent = TextListBackground
            AddToListButton.BackgroundColor3 = guipallet.ToggleColor
            AddToListButton.BackgroundTransparency = 1
            AddToListButton.BorderSizePixel = 0
            AddToListButton.Position = UDim2.new(0.8, 0, 0, 0)
            AddToListButton.AutoButtonColor = false
            AddToListButton.Size = UDim2.new(0, 25, 0, 33)
            AddToListButton.Font = guipallet.Font
            AddToListButton.Text = "+"
            AddToListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            AddToListButton.TextSize = 25

            ListFrame.Name = "ListFrame"
            ListFrame.Parent = ScrollingFrame
            ListFrame.BackgroundTransparency = 1
            ListFrame.BorderSizePixel = 0
            ListFrame.Position = UDim2.new(0, 0, 0, 0)
            ListFrame.Size = UDim2.new(0, 180, 0, 1)
            ListFrame.ScrollBarThickness = 1
            ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            ListFrame.ScrollingDirection = Enum.ScrollingDirection.Y

            UIListLayout.Parent = ListFrame
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 3)

            table.insert(connections, UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                --ListFrame.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y)
                if UIListLayout.AbsoluteContentSize.Y > 99 then
                    ListFrame.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, 99)
                    ListFrame.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, count * 28)
                else
                    ListFrame.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y)
                end
            end))

            local textlistobjects = {}

            function textlistapi:CreateListObject(text)
                if not textlistobjects[text] then
                    local listobject = Instance.new("TextButton")
                    local removebutton = Instance.new("TextButton")
                    listobject.Name = "ListObject"
                    listobject.Parent = ListFrame
                    listobject.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                    listobject.BorderSizePixel = 0
                    listobject.Size = UDim2.new(0, 180, 0, 25)
                    listobject.Font = guipallet.Font
                    listobject.Text = "  " .. text
                    listobject.TextColor3 = Color3.fromRGB(255, 255, 255)
                    listobject.TextSize = 22
                    listobject.TextXAlignment = Enum.TextXAlignment.Left
                    listobject.TextYAlignment = Enum.TextYAlignment.Top
                    textlistobjects[text] = listobject
                    table.insert(list, text)
                    count = count + 1

                    Callback(text)

                    table.insert(connections, listobject.MouseButton1Click:Connect(function()
                        if guilibrary.textlist.lmb then
                            listobject:Destroy()
                            textlistobjects[text] = nil
                            table.remove(list, text)
                        end
                    end))

                    table.insert(connections, listobject.MouseButton2Click:Connect(function()
                        if guilibrary.textlist.rmb then
                            listobject:Destroy()
                            textlistobjects[text] = nil
                            table.remove(list, text)
                        end
                    end))
                end
            end

            AddToListButton.MouseButton1Click:Connect(function()
                textlistapi:CreateListObject(TextListBox.Text)
                TextListBox.Text = ""
            end)

            for _, Name in next, list do
                textlistapi:CreateListObject(Name)
            end
        
            guilibrary.ObjectsThatCanBeSaved[argstable.Name .. "TextList"] = {
                Table = textlistapi, 
                mainobject = TextListBackground, 
                textbox = TextListBox,
                Type = "TextList"
            }
            return textlistapi
        end

        --Note: this is still guilibrary:CreateTab function
        local BottomCorner = Instance.new("Frame")
        local BottomFix = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")

        BottomCorner.Parent = ScrollingFrame
        BottomCorner.BackgroundColor3 = Color3.fromRGB(guipallet.Color1)
        BottomCorner.BorderSizePixel = 0
        BottomCorner.Transparency = 0
        BottomCorner.Size = UDim2.new(0, 207, 0, 10)
        BottomCorner.Position = UDim2.new(0, 0, 0, 500)
        BottomCorner.LayoutOrder = 99999

        BottomFix.Parent = BottomCorner
        BottomFix.BackgroundColor3 = Color3.fromRGB(guipallet.Color1)
        BottomFix.BorderSizePixel = 0
        BottomFix.Transparency = 0
        BottomFix.Size = UDim2.new(0, 207, 0, 3)

        UICorner.Parent = BottomCorner
        UICorner.CornerRadius = guilibrary.UICorners and guilibrary.UICornersRadius or UDim.new(0, 0)
        table.insert(guilibrary.UICornersTable, UICorner)
        
        guilibrary.ObjectsThatCanBeSaved[tabname.."Tab"] = {
            Table = tabtable,
            mainobject = tab, 
            Type = "Tab"
        }
        return tabtable
    end

    function guilibrary:CreateMainTab(argstable)
        local maintabname = argstable.Name or "Hello!"
        local maintabcolor = argstable.Color or Color3.new(255, 255, 255)

        local maintabtable = {
            Name = maintabname,
            Color = maintabcolor
        }

        local customtab = Instance.new("TextButton")
        local customtabnametext = Instance.new("TextLabel")
        local pinbutton = Instance.new("TextButton")
        local UIListLayout = Instance.new("UIListLayout")
        local background = Instance.new("Frame")

        table.insert(Tabs, #Tabs)
    
        customtab.Modal = true
        customtab.Name = customtabname .. "_TabTop"
        customtab.Selectable = true
        customtab.ZIndex = 1
        customtab.Parent = TabsFrame
        customtab.BackgroundColor3 = guipallet.Color1
        customtab.BorderSizePixel = 0
        customtab.Position = UDim2.new(0, 40, 0, 40)
        customtab.Size = UDim2.new(0, 207, 0, 40)
        customtab.Active = true
        customtab.LayoutOrder = 1 + #Tabs
        customtab.AutoButtonColor = false
        customtab.Text = ""
        maintabtable.mainboject = customtab
        dragGUI(customtab)
    
        customtabnametext.Name = customtabname
        customtabnametext.Parent = customtab
        customtabnametext.ZIndex = customtab.ZIndex + 1
        customtabnametext.BackgroundColor3 = guipallet.Color1
        customtabnametext.BorderSizePixel = 0
        customtabnametext.Position = UDim2.new(0, 0, 0, 10)
        customtabnametext.Size = UDim2.new(0, 207, 0, 32)
        customtabnametext.Font = guipallet.Font
        customtabnametext.Text = " " .. customtabname
        customtabnametext.TextColor3 = customtabcolor
        customtabnametext.TextSize = 22
        customtabnametext.TextWrapped = true
        customtabnametext.TextXAlignment = Enum.TextXAlignment.Left
        customtabnametext.TextYAlignment = Enum.TextYAlignment.Top
        customtabnametext.Selectable = true

        pinbutton.Parent = customtabnametext
        pinbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        pinbutton.BackgroundTransparency = 1
        pinbutton.BorderSizePixel = 0
        pinbutton.Position = UDim2.new(0, 150, 0, 4)
        pinbutton.Size = UDim2.new(0, 20, 0, 20)
        pinbutton.Font = guipallet.Font
        pinbutton.Text = "📍"
        pinbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
        pinbutton.TextTransparency = 0.4
        pinbutton.TextSize = 22

        background.Name = "background"
        background.Parent = customtab
        background.BackgroundColor3 = guipallet.Color2
        background.BackgroundTransparency = backgroundenabled and 0 or 1
        background.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
        background.Size = UDim2.new(0, 207, 0, 0)
        background.AutomaticSize = "Y" 
        background.Position = UDim2.new(0, 0, 1.08, 0)
        background.Size = UDim2.new(0, 207, 0, 600)

        if uilistenabled then
            UIListLayout.Parent = background
            UIListLayout.Padding = uilistpadding
        end

        function customtabtable:GetMainObject()
            return customtab
        end

        function customtabtable:Pin(bool)
            bool = bool or not customtabtable.Pinned
            if bool then
                customtabtable.Pinned = true
                pinbutton.TextTransparency = 0
                table.insert(guilibrary.pinnedobjects, customtabtable)
            else
                customtabtable.Pinned = false
                pinbutton.TextTransparency = 0.4
                table.remove(guilibrary.pinnedobjects, table.find(guilibrary.pinnedobjects, customtabtable))
            end
        end

        table.insert(connections, pinbutton.MouseButton1Click:Connect(function()
			customtabtable:Pin()
		end))

        guilibrary.ObjectsThatCanBeSaved[customtabname] = {
            Table = customtabtable,
            mainobject = customtab,
            Type = "CustomTab"
        }

        return customtabtable
    end

    function guilibrary:CreateCustomTab(argstable)
        local customtabname = argstable.Name or "Hello!"
        local customtabcolor = argstable.Color or Color3.new(255, 255, 255)
        local uilistenabled = argstable.UIListEnabled or false
        local uilistpadding = argstable.UIListPadding or 0
        local backgroundenabled = argstable.BackgroundEnabled or false

        local customtabtable = {
            Name = customtabname,
            Color = customtabcolor,
            UIListEnabled = uilistenabled
        }

        local customtab = Instance.new("TextButton")
        local customtabnametext = Instance.new("TextLabel")
        local pinbutton = Instance.new("TextButton")
        local UIListLayout = Instance.new("UIListLayout")
        local background = Instance.new("Frame")

        table.insert(Tabs, #Tabs)
    
        customtab.Modal = true
        customtab.Name = customtabname .. "_TabTop"
        customtab.Selectable = true
        customtab.ZIndex = 1
        customtab.Parent = TabsFrame
        customtab.BackgroundColor3 = guipallet.Color1
        customtab.BorderSizePixel = 0
        customtab.Position = UDim2.new(0, 40, 0, 40)
        customtab.Size = UDim2.new(0, 207, 0, 40)
        customtab.Active = true
        customtab.LayoutOrder = 1 + #Tabs
        customtab.AutoButtonColor = false
        customtab.Text = ""
        customtabtable.mainboject = customtab
        dragGUI(customtab)
    
        customtabnametext.Name = customtabname
        customtabnametext.Parent = customtab
        customtabnametext.ZIndex = customtab.ZIndex + 1
        customtabnametext.BackgroundColor3 = guipallet.Color1
        customtabnametext.BorderSizePixel = 0
        customtabnametext.Position = UDim2.new(0, 0, 0, 10)
        customtabnametext.Size = UDim2.new(0, 207, 0, 32)
        customtabnametext.Font = guipallet.Font
        customtabnametext.Text = " " .. customtabname
        customtabnametext.TextColor3 = customtabcolor
        customtabnametext.TextSize = 22
        customtabnametext.TextWrapped = true
        customtabnametext.TextXAlignment = Enum.TextXAlignment.Left
        customtabnametext.TextYAlignment = Enum.TextYAlignment.Top
        customtabnametext.Selectable = true

        pinbutton.Parent = customtabnametext
        pinbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        pinbutton.BackgroundTransparency = 1
        pinbutton.BorderSizePixel = 0
        pinbutton.Position = UDim2.new(0, 150, 0, 4)
        pinbutton.Size = UDim2.new(0, 20, 0, 20)
        pinbutton.Font = guipallet.Font
        pinbutton.Text = "📍"
        pinbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
        pinbutton.TextTransparency = 0.4
        pinbutton.TextSize = 22

        background.Name = "background"
        background.Parent = customtab
        background.BackgroundColor3 = guipallet.Color2
        background.BackgroundTransparency = backgroundenabled and 0 or 1
        background.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
        background.Size = UDim2.new(0, 207, 0, 0)
        background.AutomaticSize = "Y" 
        background.Position = UDim2.new(0, 0, 1.08, 0)
        background.Size = UDim2.new(0, 207, 0, 600)

        if uilistenabled then
            UIListLayout.Parent = background
            UIListLayout.Padding = uilistpadding
        end

        function customtabtable:GetMainObject()
            return customtab
        end

        function customtabtable:Pin(bool)
            bool = bool or not customtabtable.Pinned
            if bool then
                customtabtable.Pinned = true
                pinbutton.TextTransparency = 0
                table.insert(guilibrary.pinnedobjects, customtabtable)
            else
                customtabtable.Pinned = false
                pinbutton.TextTransparency = 0.4
                table.remove(guilibrary.pinnedobjects, table.find(guilibrary.pinnedobjects, customtabtable))
            end
        end

        table.insert(connections, pinbutton.MouseButton1Click:Connect(function()
			customtabtable:Pin()
		end))

        guilibrary.ObjectsThatCanBeSaved[customtabname] = {
            Table = customtabtable,
            mainobject = customtab,
            Type = "CustomTab"
        }

        return customtabtable
    end
end

return guilibrary