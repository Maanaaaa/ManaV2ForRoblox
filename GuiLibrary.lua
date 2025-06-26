--[[ 
    Credits to vape's old + new guilibrary and others script that i used/looked at

    Made by Maanaaaa and Wowzers
]]

repeat task.wait() until game:IsLoaded()

local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local htppservice = game:GetService("HttpService")
local textService = game:GetService("TextService")
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
    Loaded = false,
    Device = "None",
    Scale = 1,
    MobileScale = 0.45,
    Sounds = true,
    SoundsVolume = 1,
    GuiKeybind = "RightShift",
    Toggled = false,
    CurrentProfile = "Default",
    ProfilePath = "",
    Rainbow = false,
    RaibowSpeed = 0,
    AllowNotifications = true,
    TouchEnabled = false,
    SliderDoubleClick = true,
    textlist = {
        lmb = false,
        rmb = false
    },
    uiCornersRadius = 0,
    SliderCanOverride = false,
    ArrayList = {},
    Objects = {},
    Functions = {},
    FontsList = {},
    uiCorners = {},
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
    NormalNotificationColor = Color3.fromRGB(102, 205, 67),
    ErrorNotificationColor = Color3.fromRGB(205, 64, 78),
    Font = Enum.Font.Arial
}
guilibrary.GuiPallet = guipallet

local guiObjects = {
    Color1 = {},
    Color2 = {},
    Color3 = {},
    Color4 = {},
    Color5 = {},
    ToggleColor = {},
    ToggleColor2 = {},
    TextColor = {},
    GrayTextColor = {},
    Font = {}
}
guilibrary.GuiObjects = guiObjects

local symbols = {
    checkMark = "✓",
    xMark = "✗",
    arrow = "➤",
    arrowUp = "↑",
	arrowDown = "↓",
	arrowLeft = "←",
	arrowRight = "→",
	arrowSpace = "⏎"
}
guilibrary.Symbols = symbols

local tweens = {
	notification = {
		show = function(obj, y)
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Circular)
			return tweenService:Create(obj, tweenInfo, {AnchorPoint = Vector2.new(1, 0)})--{Position = UDim2.new(0.9, 0, 1, y)}) --0.85
		end,
        move = function(obj, y)
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Circular)
            return tweenService:Create(obj, tweenInfo, {Position = UDim2.new(1, 0, 1, y)})
        end,
		hide = function(obj, y)
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Circular)
			return tweenService:Create(obj, tweenInfo, {Position = UDim2.new(1, 900, 1, y)})
		end,
		progress = function(obj, obj2, delay, height, height2)
			local tweenInfo = TweenInfo.new(delay, Enum.EasingStyle.Quad)
			return {
				tweenService:Create(obj, tweenInfo, {Size = UDim2.new(0, 0, 0, height)}),
				tweenService:Create(obj2, tweenInfo, {Size = UDim2.new(0, 0, 0, height2)})
			}
		end
	},
    keyStroke = {
		highlight = function(obj)
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Exponential)
			return tweenService:Create(obj, tweenInfo, {
				BackgroundColor3 = guipallet.Color1,
				BackgroundTransparency = 0
			})
		end,
		unHighlight = function(obj)
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Exponential)
			return tweenService:Create(obj, tweenInfo, {
				BackgroundColor3 = guipallet.Color2,
				BackgroundTransparency = 0.5
			})
		end
	},
    toggle = {
        enable = function(obj, color)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Circular)
            return tweenService:Create(obj, tweenInfo, {
                BackgroundColor3 = color or guipallet.ToggleColor2
            })
        end,
        disable = function(obj)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Circular)
            return tweenService:Create(obj, tweenInfo, {
                BackgroundColor3 = guipallet.ToggleColor
            })
        end
    },
}
guilibrary.Tweens = tweens

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Mana"
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.OnTopOfCoreBlur = true -- so if you even get kicked or banned you'll still see gui :)
local ClickGui = Instance.new("Frame", ScreenGui)
ClickGui.Name = "ClickGui"
local Notifications = Instance.new("Folder", ScreenGui)
local KeyStrokesGui = Instance.new("Folder", ScreenGui)
local TextListGui = Instance.new("Folder", ScreenGui)
guilibrary.ScreenGui = ScreenGui
guilibrary.ClickGui = ClickGui
guilibrary.KeyStrokesGui = KeyStrokesGui

local manaObjects = Instance.new("Folder")
manaObjects.Parent = ScreenGui
local toggleRemote = Instance.new("BindableEvent")
toggleRemote.Parent = manaObjects

if userInputService.TouchEnabled then
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

--// start of cool config system
local function createFolder(name)
    if isfolder(name) == false then
        makefolder(name)
    end
end

createFolder("Mana")
createFolder("Mana/Assets")
createFolder("Mana/Config")
createFolder("Mana/Config/Universal")
createFolder("Mana/Scripts")
createFolder("Mana/Modules")

-- made this by looking at old vape's saving system + new one
function guilibrary:SaveConfig()
    local savedata = {}
    local path = "Mana/Config/"..game.PlaceId..guilibrary.CurrentProfile
    guilibrary.ProfilePath = path

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
    writefile(path..".json", htppservice:JSONEncode(savedata))
    writefile("Mana/CurrentProfile.txt", guilibrary.CurrentProfile)
end

function guilibrary:LoadConfig()
    local success, profile = pcall(function()
        return readfile("Mana/CurrentProfile.txt")
    end)

    if success and profile ~= nil then
        guilibrary.CurrentProfile = profile
    else
        guilibrary.CurrentProfile = "Default"
    end

    local success, result = pcall(function()
        return htppservice:JSONDecode(readfile("Mana/Config/"..game.PlaceId..guilibrary.CurrentProfile..".json"))
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
        warn("[ManaV2ForRoblox/GuiLibrary.lua]: an error occured while loading config: "..result.."\n happens when profile is just created.")
    end
end

function guilibrary:switchProfile(profile)
    if isfile("Mana/Config/"..game.PlaceId..guilibrary.CurrentProfile..".json") then
        guilibrary.CurrentProfile = profile
    else
        warn("[ManaV2ForRoblox/Guilibrary.lua]: Unable to load profile "..profile.." - not found, instead creating it.")
        guilibrary.CurrentProfile = profile
        writefile("Mana/Config/"..game.PlaceId..guilibrary.CurrentProfile..".json", "{}")
    end
    if isfile("Mana/CurrentProfile.txt") then
        delfile("Mana/CurrentProfile.txt")
        writefile("Mana/CurrentProfile.txt", guilibrary.CurrentProfile)
    end
    guilibrary:LoadConfig()
end
--// end of cool config system

--// start of cool theme system
function guilibrary:sortObjects()
    for _, obj in next, ScreenGui:GetDescendants() do
        if obj.BackgroundColor3 == guipallet.Color1 then
            if not table.find(guiObjects.Color1, obj) then
                table.insert(guiObjects.Color1, obj)
            end
        elseif obj.BackgroundColor3 == guipallet.Color2 then
            if not table.find(guiObjects.Color2, obj) then
                table.insert(guiObjects.Color2, obj)
            end
        elseif obj.BackgroundColor3 == guipallet.Color3 then
            if not table.find(guiObjects.Color3, obj) then
                table.insert(guiObjects.Color3, obj)
            end
        elseif obj.BackgroundColor3 == guipallet.Color4 then
            if not table.find(guiObjects.Color4, obj) then
                table.insert(guiObjects.Color4, obj)
            end
        elseif obj.BackgroundColor3 == guipallet.Color5 then
            if not table.find(guiObjects.Color5, obj) then
                table.insert(guiObjects.Color5, obj)
            end
        elseif obj.BackgroundColor3 == guipallet.ToggleColor then
            if not table.find(guiObjects.ToggleColor, obj) then
                table.insert(guiObjects.ToggleColor, obj)
            end
        elseif obj.BackgroundColor3 == guipallet.ToggleColor2 then
            if not table.find(guiObjects.ToggleColor2, obj) then
                table.insert(guiObjects.ToggleColor2, obj)
            end
        elseif obj.TextColor3 == guipallet.TextColor then
            if not table.find(guiObjects.TextColor, obj) then
                table.insert(guiObjects.TextColor, obj)
            end
        elseif obj.TextColor3 == guipallet.GrayTextColor then
            if not table.find(guiObjects.GrayTextColor, obj) then
                table.insert(guiObjects.GrayTextColor, obj)
            end
        elseif obj.Font == guipallet.Font then
            if not table.find(guiObjects.Font, obj) then
                table.insert(guiObjects.Font, obj)
            end
        end
    end
end

function guilibrary:updateObjects()
    for i, v in pairs(guiObjects.Color1) do
        v.BackgroundColor3 = guipallet.Color1
    end
    for i, v in pairs(guiObjects.Color2) do
        v.BackgroundColor3 = guipallet.Color2
    end
    for i, v in pairs(guiObjects.Color3) do
        v.BackgroundColor3 = guipallet.Color3
    end
    for i, v in pairs(guiObjects.Color4) do
        v.BackgroundColor3 = guipallet.Color4
    end
    for i, v in pairs(guiObjects.Color5) do
        v.BackgroundColor3 = guipallet.Color5
    end
    for i, v in pairs(guiObjects.ToggleColor) do
        v.BackgroundColor3 = guipallet.ToggleColor
    end
    for i, v in pairs(guiObjects.ToggleColor2) do
        v.BackgroundColor3 = guipallet.ToggleColor2
    end
    for i, v in pairs(guiObjects.TextColor) do
        v.TextColor3 = guipallet.TextColor
    end
    for i, v in pairs(guiObjects.GrayTextColor) do
        v.TextColor3 = guipallet.GrayTextColor
    end
    for i, v in pairs(guiObjects.Font) do
        v.Font = guipallet.Font
    end
end

function guilibrary:setColor(colorName, color)
    guipallet[colorName] = color
end
--// end of cool theme system

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
    if shared.Mana then shared.Mana = nil end
    if _G.Mana then _G.Mana = nil end
    if getgenv().Mana then getgenv().Mana = nil end
end

function guilibrary:Toggle(state)
    local state = state or not guilibrary.Toggled
    guilibrary.Toggled = state

    for _, v in pairs(guilibrary.ObjectsThatCanBeSaved) do
        if v.Type == "Tab" and not v.Table.Pinned and not v.CustomTab then
            v.mainobject.Visible = state
        elseif v.CustomTab and v.Toggleable then
            v.mainobject.Visible = state
        end
    end

    if guilibrary.APIs.KeyStrokes then
        guilibrary.APIs.KeyStrokes:toggleDragButton(state)
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

local function dragGUI(gui, button)
	if not button then button = gui end
	task.spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			tweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		button.InputBegan:Connect(function(input)
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
		button.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		userInputService.InputChanged:Connect(function(input)
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

-- makeColorDarker is from roblox devforum
function guilibrary:makeColorDarker(color)
    local h, s, v = color:ToHSV()
    v = math.clamp(v * 0.7, 0, 1) -- Reduce the brightness (value) by multiplying it, ensuring it stays within [0, 1]
    return Color3.fromHSV(h, s, v)
end

function guilibrary:HSVtoRGB(h, s, v)
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

local function getTextWidth(text, fontSize)
    return #text * fontSize * 0.6
end

function guilibrary:UpdateFont(newFont)
    newFont = Enum.Font[newFont] or guipallet.Font
    guipallet.Font = newFont
    for i, v in pairs(ScreenGui:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            v.Font = Enum.Font[newFont]
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

function guilibrary:RemoveObject(ObjectName) 
    pcall(function()
        if guilibrary.Objects[ObjectName] and guilibrary.Objects[ObjectName].Type == "Toggle" then 
            guilibrary.Objects[ObjectName].Instance:Destroy()
            guilibrary.Objects[ObjectName].OptionFrame:Destroy()
            guilibrary.Objects[ObjectName] = nil
        end
    end)
end

function guilibrary:updateUICorners(radius)
    for i, v in pairs(guilibrary.uiCorners) do
        v.CornerRadius = UDim.new(0, radius)
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

function guilibrary:getIndex(table, obj)
    for i, v in ipairs(table) do
        if v == obj then
            return i
        end
    end
    return
end

-- // notifications
function guilibrary:CreateNotification(notifTitle, notifText, delay, normal)
    if not guilibrary.Notifications then return end
    if not guilibrary.Loaded and (notifText:find("Enabled") or notifText:find("Disabled")) then return end
	local order = #Notifications:GetChildren() + 1
	local Background = Instance.new("Frame")
	local top = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local fixer = Instance.new("Frame")
	local title = Instance.new("TextLabel")
	local text = Instance.new("TextLabel")
	local progressbar = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local fixer_2 = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")

	Background.Name = "Background"
	Background.Parent = Notifications
	Background.AnchorPoint = Vector2.new(0.5, 0)
	Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Background.BackgroundTransparency = 0.5
	Background.BorderSizePixel = 0
	Background.Position = UDim2.new(1, 900, 0.8, 0)
	Background.Size = UDim2.new(0, 100, 0, 115)

	top.Name = "top"
	top.Parent = Background
	top.BackgroundColor3 = (normal and guipallet.NormalNotificationColor or guipallet.ErrorNotificationColor)
	top.BorderSizePixel = 0
	top.Size = UDim2.new(1, 0, 0, 8)

	UICorner.Parent = top

	fixer.Name = "fixer"
	fixer.Parent = top
	fixer.BackgroundColor3 = (normal and guipallet.NormalNotificationColor or guipallet.ErrorNotificationColor)
	fixer.BorderSizePixel = 0
	fixer.Position = UDim2.new(0, 0, 0, 6)
	fixer.Size = UDim2.new(1, 0, 0, 2)

	title.Name = "title"
	title.Parent = Background
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 0, 0, 30)
	title.Size = UDim2.new(1, 0, 0, 28)
	title.Font = guipallet.Font
	title.Text = "          "..notifTitle
	title.TextColor3 = (normal and guipallet.NormalNotificationColor or guipallet.ErrorNotificationColor)
	title.TextSize = 24.000
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top

	text.Name = "text"
	text.Parent = Background
	text.BackgroundTransparency = 1
	text.Position = UDim2.new(0, 0, 0, 68)
	text.Size = UDim2.new(1, 0, 0, 28)
	text.Font = guipallet.Font
	text.Text = "          "..notifText
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextSize = 24
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextYAlignment = Enum.TextYAlignment.Top

	progressbar.Name = "progressbar"
	progressbar.Parent = Background
	progressbar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	progressbar.BorderSizePixel = 0
	progressbar.Position = UDim2.new(0, 0, 0.930000007, 0)
	progressbar.Size = UDim2.new(1, 0, 0, 8)

	UICorner_2.Parent = progressbar

	fixer_2.Name = "fixer"
	fixer_2.Parent = progressbar
	fixer_2.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	fixer_2.BorderSizePixel = 0
	fixer_2.Size = UDim2.new(1, 0, 0, 2)

	UICorner_3.Parent = Background

	local textsize = textService:GetTextSize(title.Text, title.TextSize, title.Font, Vector2.new(100000, 100000))
	local textsize2 = textService:GetTextSize(text.Text, text.TextSize, text.Font, Vector2.new(100000, 100000))
	local y = -(5 + 120 * order)
	local position = UDim2.new(1, 0, 1, y)
	Background.Position = position

	if textsize2.X > textsize.X then textsize = textsize2 end

	Background.Size = UDim2.new(0, textsize.X + 38, 0, 115)

	Debris:AddItem(Background, delay + 0.9)
	
	tweens.notification.show(Background, y):Play()
	for _, tween in next, tweens.notification.progress(progressbar, fixer_2, delay, 8, 2) do
		tween:Play()
	end

	task.wait(delay)

	tweens.notification.hide(Background, y):Play()
end

Notifications.ChildRemoved:Connect(function()
    for index, notification in next, Notifications:GetChildren() do
        if notification:IsA("Frame") then
            local order = #Notifications:GetChildren() + 1
            local y = -(5 + 120 * index) --(index - 1)
            tweens.notification.move(notification, y):Play()
        end
    end
end)

-- // text list
function guilibrary:CreateTextList()
	local api = {
		textXAlignment = Enum.TextXAlignment.Right,
        autoChanceXAlignment = false,
		backgroundTransparency = 0.7,
		textSize = 19,
        customTextText = "Hello world!",
        customTextSize = 20,
		sortingMode = "lenght",
        lenghtSortingMode = "descending",
		labels = {}
	}

	local tab = guilibrary:CreateTab({
        Name = "TextList",
        CustomTab = true,
        Color = Color3.fromRGB(49, 204, 90)
    })

    api.tab = tab

    tab:Toggle()

    function api:sort()
        table.sort(api.labels, function(a, b)
			if api.sortingMode == "lenght" then
                if api.lenghtSortingMode == "ascending" then
				    return #a.Text < #b.Text
                elseif api.lenghtSortingMode == "descending" then
                    return #a.Text > #b.Text
                end
			elseif api.sortingMode == "alphabetical" then
				return a.Text < b.Text
			end
		end)

		for index, label in pairs(api.labels) do
			label.LayoutOrder = index + 1
		end
    end

    function api:updateTextXAlignment(x)
        api.textXAlignment = x
        if api.customText then api.customText.TextXAlignment = x end
        for _, label in pairs(api.labels) do
            label.TextXAlignment = Enum.TextXAlignment[x]
        end
    end

	function api:addLabel(text)
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Parent = tab:getContainer()
		label.BackgroundColor3 = guipallet.Color2
		label.BackgroundTransparency = api.backgroundTransparency
		label.BorderSizePixel = 0
		label.Position = UDim2.new(0.32367149, 0, 0, 0)
		label.Size = UDim2.new(0, 140, 0, 30)
		label.Font = guipallet.Font
		label.Text = text
		label.TextColor3 = guipallet.TextColor
		label.TextSize = api.textSize
		label.TextXAlignment = api.textXAlignment
		table.insert(api.labels, label)

        local size = textService:GetTextSize(text, api.textSize, guipallet.Font, Vector2.new(1000, 1000))
        label.Size = UDim2.new(0, size.X, 0, size.Y)
	end

    function api:updateBackgroundTransparency(transparency)
        api.backgroundTransparency = transparency
        for _, label in pairs(api.labels) do
            label.BackgroundTransparency = transparency
        end
    end

    function api:updateTextSize(size)
        api.textSize = size
        for _, label in pairs(api.labels) do
            label.TextSize = size
            local textsize = textService:GetTextSize(label.Text, size, guipallet.Font, Vector2.new(1000, 1000))
            label.Size = UDim2.new(0, textsize.X, 0, textsize.Y)
        end
    end

	function api:removeLabel(text)
		api.labels[text]:Destroy()
		table.remove(api.labels, text)
	end

	function api:addCustomText(text)
        local text = text or api.customTextText
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Parent = tab:getContainer()
		label.BackgroundColor3 = guipallet.Color2
		label.BackgroundTransparency = 0.7
		label.BorderSizePixel = 0
		label.Position = UDim2.new(0.32367149, 0, 0, 0)
		label.Size = UDim2.new(0, 140, 0, 30)
		label.Font = guipallet.Font
		label.Text = text
		label.TextColor3 = guipallet.TextColor
		label.TextSize = api.customTextSize
		label.TextXAlignment = api.textXAlignment or Enum.TextXAlignment.Right
		label.LayoutOrder = 1
		api.customText = label

        local size = textService:GetTextSize(text, api.customTextSize, guipallet.Font, Vector2.new(1000, 1000))
        label.Size = UDim2.new(0, size.X + 5, 0, size.Y + 5)
	end

	function api:updateCustomText(text)
        api.customTextText = text
		api.customText.Text = text
	end

    function api:updateCustomTextSize(size)
        if api.customText then
            api.customTextSize = size
            api.customText.TextSize = size
            local textsize = textService:GetTextSize(api.customText.Text, size, guipallet.Font, Vector2.new(1000, 1000))
            api.customText.Size = UDim2.new(0, textsize.X + 5, 0, textsize.Y + 5)
        end
    end

	function api:removeCustomText()
		if api.customText then
			api.customText:Destroy()
			api.customText = nil
		end
	end

    function api:updateSortingMode(mode)
        api.sortingMode = mode
        api:sort()
    end

	function api:fullUpdate()
		for _, label in pairs(api.labels) do
			api:removeLabel(label.Text)
			api:removeCustomText()
		end
	end

    function api:updateAutoTextXAlignment(bool)
        bool = bool or not api.autoUpdateTextXAllignment
        api.autoUpdateTextXAllignment = bool
    end

    table.insert(connections, tab:GetMainObject():GetPropertyChangedSignal("Position"):Connect(function()
        if not api.autoUpdateTextXAllignment then return end
        if tab.Position.Y.Scale >= 0.5 then
            api:updateTextXAlignment("Left")
        else
            api:updateTextXAlignment("Right")
        end
    end))

	return api
end

-- // key strokes
function guilibrary:CreateKeyStrokes()
	local api = {
        uiScale = 1,
        textSize = 15,
        spaceTextSize = 17,
        textXAllignment = Enum.TextXAlignment.Left,
        textYAllignment = Enum.TextYAlignment.Top,
        backgroundTransparency = 0.5,
		keys = {}
	}
    guilibrary.APIs.KeyStrokes = api

	local Frame = Instance.new("Frame")
    local uiScale = Instance.new("UIScale")
	local a = Instance.new("Frame")
	local aCorner = Instance.new("UICorner")
	local aLabel = Instance.new("TextLabel")
	local s = Instance.new("Frame")
	local sCorner = Instance.new("UICorner")
	local sLabel = Instance.new("TextLabel")
	local w = Instance.new("Frame")
	local wCorner = Instance.new("UICorner")
	local wLabel = Instance.new("TextLabel")
	local d = Instance.new("Frame")
	local dCorner = Instance.new("UICorner")
	local dLabel = Instance.new("TextLabel")
	local space = Instance.new("Frame")
	local spaceCorner = Instance.new("UICorner")
	local spaceLabel = Instance.new("TextLabel")
	local lmb = Instance.new("Frame")
	local lmbCorner = Instance.new("UICorner")
	local lmbLabel = Instance.new("TextLabel")
	local rmb = Instance.new("Frame")
	local rmbCorner = Instance.new("UICorner")
	local rmbLabel = Instance.new("TextLabel")
	local dragButton = Instance.new("TextButton")
	local dragCorner = Instance.new("UICorner")

	Frame.Parent = KeyStrokesGui
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.244107738, 0, 0.493589729, 0)
	Frame.Size = UDim2.new(0, 130, 0, 120)

    uiScale.Parent = Frame
    uiScale.Scale = 1
	
	a.Name = "a"
	a.Parent = Frame
	a.BackgroundColor3 = guipallet.Color2
	a.BackgroundTransparency = 0.5
	a.BorderSizePixel = 0
	a.Position = UDim2.new(0, 0, 0, 45)
	a.Size = UDim2.new(0, 40, 0, 40)
	api.keys.A = a

	aCorner.CornerRadius = UDim.new(0, 4)
	aCorner.Parent = a

	aLabel.Parent = a
	aLabel.BackgroundTransparency = 1
	aLabel.BorderSizePixel = 0
	aLabel.Size = UDim2.new(1, 0, 1, 0)
	aLabel.Font = guipallet.Font
	aLabel.Text = "A"
	aLabel.TextColor3 = guipallet.TextColor
	aLabel.TextSize = api.textSize
	aLabel.TextXAlignment = api.textXAllignment
	aLabel.TextYAlignment = api.textYAllignment

	s.Name = "s"
	s.Parent = Frame
	s.BackgroundColor3 = guipallet.Color2
	s.BackgroundTransparency = 0.5
	s.BorderSizePixel = 0
	s.Position = UDim2.new(0, 45, 0, 45)
	s.Size = UDim2.new(0, 40, 0, 40)
	api.keys.S = s

	aCorner.CornerRadius = UDim.new(0, 4)
	aCorner.Parent = s

	sLabel.Parent = s
	sLabel.BackgroundTransparency = 1
	sLabel.BorderSizePixel = 0
	sLabel.Size = UDim2.new(1, 0, 1, 0)
	sLabel.Font = guipallet.Font
	sLabel.Text = "S"
	sLabel.TextColor3 = guipallet.TextColor
	sLabel.TextSize = api.textSize
	sLabel.TextXAlignment = api.textXAllignment
	sLabel.TextYAlignment = api.textYAllignment

	w.Name = "w"
	w.Parent = Frame
	w.BackgroundColor3 = guipallet.Color2
	w.BackgroundTransparency = 0.5
	w.BorderSizePixel = 0
	w.Position = UDim2.new(0, 45, 0, 0)
	w.Size = UDim2.new(0, 40, 0, 40)
	api.keys.W = w

	wCorner.CornerRadius = UDim.new(0, 4)
	wCorner.Parent = w

	wLabel.Parent = w
	wLabel.BackgroundTransparency = 1
	wLabel.BorderSizePixel = 0
	wLabel.Size = UDim2.new(1, 0, 1, 0)
	wLabel.Font = guipallet.Font
	wLabel.Text = "W"
	wLabel.TextColor3 = guipallet.TextColor
	wLabel.TextSize = api.textSize
	wLabel.TextXAlignment = api.textXAllignment
	wLabel.TextYAlignment = api.textYAllignment

	d.Name = "d"
	d.Parent = Frame
	d.BackgroundColor3 = guipallet.Color2
	d.BackgroundTransparency = 0.5
	d.BorderSizePixel = 0
	d.Position = UDim2.new(0, 90, 0, 45)
	d.Size = UDim2.new(0, 40, 0, 40)
	api.keys.D = d

	dCorner.CornerRadius = UDim.new(0, 4)
	dCorner.Parent = d

	dLabel.Parent = d
	dLabel.BackgroundTransparency = 1
	dLabel.BorderSizePixel = 0
	dLabel.Size = UDim2.new(1, 0, 1, 0)
	dLabel.Font = guipallet.Font
	dLabel.Text = "D"
	dLabel.TextColor3 = guipallet.TextColor
	dLabel.TextSize = api.textSize
	dLabel.TextXAlignment = api.textXAllignment
	dLabel.TextYAlignment = api.textYAllignment

	space.Name = "space"
	space.Parent = Frame
	space.BackgroundColor3 = guipallet.Color2
	space.BackgroundTransparency = 0.5
	space.BorderSizePixel = 0
	space.Position = UDim2.new(0, 0, 0, 90)
	space.Size = UDim2.new(0, 130, 0, 30)
	api.keys.Space = space

	spaceCorner.CornerRadius = UDim.new(0, 4)
	spaceCorner.Parent = space

	spaceLabel.Parent = space
	spaceLabel.BackgroundTransparency = 1
	spaceLabel.BorderSizePixel = 0
	spaceLabel.Size = UDim2.new(1, 0, 1, 0)
	spaceLabel.Font = guipallet.Font
	spaceLabel.Text = "_________"
	spaceLabel.TextColor3 = guipallet.TextColor
	spaceLabel.TextSize = api.spaceTextSize
    spaceLabel.TextXAlignment = Enum.TextXAlignment.Center
    spaceLabel.TextYAlignment = Enum.TextYAlignment.Center

	lmb.Name = "leftMouseButton"
	lmb.Parent = Frame
	lmb.BackgroundColor3 = guipallet.Color2
	lmb.BackgroundTransparency = 0.5
	lmb.BorderSizePixel = 0
	lmb.Size = UDim2.new(0, 40, 0, 40)
	lmb.Position = UDim2.new(0, 0, 0, 0)
	api.keys.LMB = lmb

	lmbCorner.CornerRadius = UDim.new(0, 4)
	lmbCorner.Parent = lmb

	lmbLabel.Parent = lmb
	lmbLabel.BackgroundTransparency = 1
	lmbLabel.BorderSizePixel = 0
	lmbLabel.Size = UDim2.new(1, 0, 1, 0)
	lmbLabel.Font = guipallet.Font
	lmbLabel.Text = "LMB"
	lmbLabel.TextColor3 = guipallet.TextColor
	lmbLabel.TextSize = api.textSize
	lmbLabel.TextXAlignment = api.textXAllignment
	lmbLabel.TextYAlignment = api.textYAllignment

	rmb.Name = "rightMouseButton"
	rmb.Parent = Frame
	rmb.BackgroundColor3 = guipallet.Color2
	rmb.BackgroundTransparency = 0.5
	rmb.BorderSizePixel = 0
	rmb.Position = UDim2.new(0, 90, 0, 0)
	rmb.Size = UDim2.new(0, 40, 0, 40)
	api.keys.RMB = rmb

	rmbCorner.CornerRadius = UDim.new(0, 4)
	rmbCorner.Parent = rmb

	rmbLabel.Parent = rmb
	rmbLabel.BackgroundTransparency = 1
	rmbLabel.BorderSizePixel = 0
	rmbLabel.Size = UDim2.new(1, 0, 1, 0)
	rmbLabel.Font = guipallet.Font
	rmbLabel.Text = "RMB"
	rmbLabel.TextColor3 = guipallet.TextColor
	rmbLabel.TextSize = api.textSize
	rmbLabel.TextXAlignment = api.textXAllignment
	rmbLabel.TextYAlignment = api.textYAllignment

	dragButton.Parent = Frame
	dragButton.BackgroundColor3 = Color3.fromRGB(98, 255, 0)
	dragButton.BackgroundTransparency = 0.5
	dragButton.BorderSizePixel = 0
	dragButton.Position = UDim2.new(0, -45, 0, 0)
	dragButton.Size = UDim2.new(0, 40, 0, 40)
	dragButton.Font = Enum.Font.SourceSans
	dragButton.Text = ""
	dragButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	dragButton.TextSize = api.textSize
    dragButton.Visible = false

	dragCorner.CornerRadius = UDim.new(0, 4)
	dragCorner.Parent = dragButton

	dragGUI(Frame, dragButton)

	function api:toggle()
		Frame.Visible = not Frame.Visible
	end

	function api:toggleMouseButtons(bool)
        bool = bool or not lmb.Visible
		lmb.Visible = bool
		rmb.Visible = bool
		local x = bool and -45 or 0
		dragButton.Position = UDim2.new(0, x, 0, 0)
	end

	function api:toggleDragButton(bool)
        bool = bool or not dragButton.Visible
		dragButton.Visible = bool
	end

	function api:changeSymbol(keyButton, symbol)
		for index, key in next, api.keys do
			if index == keyButton then
                key.TextLabel.Text = symbol
            end
		end
	end

	function api:changeSymbols(type)
		if type:lower() == "letters" then
			api:changeSymbol("LMB", "LMB")
			api:changeSymbol("RMB", "RMB")
			api:changeSymbol("W", "W")
			api:changeSymbol("A", "A")
			api:changeSymbol("S", "S")
			api:changeSymbol("D", "D")
			api:changeSymbol("Space", "_________")
		elseif type:lower() == "directions" then
			api:changeSymbol("MouseButton1", "LMB")
			api:changeSymbol("MouseButton2", "RMB")
			api:changeSymbol("W", "Up")
			api:changeSymbol("A", "Left")
			api:changeSymbol("S", "Down")
			api:changeSymbol("D", "Right")
			api:changeSymbol("Space", "Jump")
        elseif type:lower() == "directions2" then
			api:changeSymbol("MouseButton1", "LMB")
			api:changeSymbol("MouseButton2", "RMB")
			api:changeSymbol("W", "Go")
			api:changeSymbol("A", "Left")
			api:changeSymbol("S", "Back")
			api:changeSymbol("D", "Right")
			api:changeSymbol("Space", "Jump")
		elseif type:lower() == "arrows" then
			api:changeSymbol("MouseButton1", symbols.arrowLeft)
			api:changeSymbol("MouseButton2", symbols.arrowRight)
			api:changeSymbol("W", symbols.arrowUp)
			api:changeSymbol("A", symbols.arrowLeft)
			api:changeSymbol("S", symbols.arrowDown)
			api:changeSymbol("D", symbols.arrowRight)
			api:changeSymbol("Space", symbols.arrowSpace)
		elseif type:lower() == "custom" then
			api:changeSymbol("MouseButton1", "LMB")
			api:changeSymbol("MouseButton2", "RMB")
			api:changeSymbol("W", "W")
			api:changeSymbol("A", "A")
			api:changeSymbol("S", "S")
			api:changeSymbol("D", "D")
			api:changeSymbol("Space", "_________")
		end
	end

	function api:updateColors()
		for _, key in next, api.keys do
			key.BackgroundColor3 = guipallet.Color2
			key.TextLabel.TextColor3 = guilibrary.TextColor
		end
	end

    function api:updateBackgroundTransparency(transparency)
        api.backgroundTransparency = transparency or 0.5
        for _, key in next, api.keys do
            key.BackgroundTransparency = transparency or api.backgroundTransparency
        end
    end

	function api:updateTextPosition(x, y)
        for _, key in next, api.keys do
            if key.Name ~= "space" then
                local x = Enum.TextXAlignment[x] or Enum.TextXAlignment.Left
                local y = Enum.TextYAlignment[y] or Enum.TextYAlignment.Top
                key.TextLabel.TextXAlignment = x
                key.TextLabel.TextYAlignment = y
            end
        end
    end

    function api:updateTextSize(size)
        api.textSize = size or 15
        for _, key in next, api.keys do
            if key.Name ~= "space" then
                key.TextLabel.TextSize = api.textSize
            end
        end
    end

    function api:updateSpaceTextSize(size)
        api.spaceTextSize = size or 17
        spaceLabel.TextSize = api.spaceTextSize
    end

    function api:updateSize(scale)
        api.uiScale = scale or 1
        uiScale.Scale = api.uiScale
    end

	userInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.A then
			tweens.keyStroke.highlight(a):Play()
		elseif input.KeyCode == Enum.KeyCode.S then
			tweens.keyStroke.highlight(s):Play()
		elseif input.KeyCode == Enum.KeyCode.W then
			tweens.keyStroke.highlight(w):Play()
		elseif input.KeyCode == Enum.KeyCode.D then
			tweens.keyStroke.highlight(d):Play()
		elseif input.KeyCode == Enum.KeyCode.Space then
			tweens.keyStroke.highlight(space):Play()
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			tweens.keyStroke.highlight(lmb):Play()
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			tweens.keyStroke.highlight(rmb):Play()
		end
	end)

	userInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.A then
			tweens.keyStroke.unHighlight(a):Play()
		elseif input.KeyCode == Enum.KeyCode.S then
			tweens.keyStroke.unHighlight(s):Play()
		elseif input.KeyCode == Enum.KeyCode.W then
			tweens.keyStroke.unHighlight(w):Play()
		elseif input.KeyCode == Enum.KeyCode.D then
			tweens.keyStroke.unHighlight(d):Play()
		elseif input.KeyCode == Enum.KeyCode.Space then
			tweens.keyStroke.unHighlight(space):Play()
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			tweens.keyStroke.unHighlight(lmb):Play()
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			tweens.keyStroke.unHighlight(rmb):Play()
		end
	end)

	return api
end

-- this is so shit
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

    function guilibrary:CreateCustomTab(argstable)
        local name = argstable.Name
        local color = argstable.Color or guilibrary.TextColor
        local tab = Instance.new("TextButton")
        local tabtext = Instance.new("TextLabel")
        local container = Instance.new("Frame")
        local optionsbutton = Instance.new("TextButton")
        local optionframe = Instance.new("Frame")
        local pinbutton = Instance.new("TextButton")
        local uiListLayout = Instance.new("UIListLayout")
        local uiCorner = Instance.new("UICorner")

        local tabtable = {
            Name = name,
            Pinned = false,
            ObjectsVisible = true,
            Toggled = false,
            Position = UDim2.new(0, 40, 0, 40),
            Order = #Tabs
        }

        table.insert(Tabs, #Tabs)

        tab.Modal = true
        tab.Name = name
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
        tab.Visible = false
        tabtable.MainObject = tab
        dragGUI(tab)
    
        tabtext.Name = name
        tabtext.Parent = tab
        tabtext.ZIndex = tab.ZIndex + 1
        tabtext.BackgroundColor3 = guipallet.Color1
        tabtext.BorderSizePixel = 0
        tabtext.Position = UDim2.new(0, 0, 0, 0)
        tabtext.Size = UDim2.new(0, 207, 0, 32)
        tabtext.Font = guipallet.Font
        tabtext.Text = " " .. name
        tabtext.TextColor3 = color
        tabtext.TextSize = 22
        tabtext.TextWrapped = true
        tabtext.TextXAlignment = Enum.TextXAlignment.Left
        tabtext.TextYAlignment = Enum.TextYAlignment.Top
        tabtext.Selectable = true

        optionsbutton.Parent = tab
        optionsbutton.Position = UDim2.new(0, 170, 0, 2)
        optionsbutton.Size = UDim2.new(0, 32, 0, 32)
        optionsbutton.BackgroundTransparency = 1
        optionsbutton.Image = "http://www.roblox.com/asset/?id=12809025337"
        optionsbutton.Rotation = 90

        optionframe.Name = "OptionFrame"
        optionframe.Parent = tab
        optionframe.BackgroundColor3 = guipallet.Color2
        optionframe.Position = UDim2.new(0.102424242, 0, 0.237059206, 0)
        optionframe.Size = UDim2.new(0, 207, 0, 0)
        optionframe.AutomaticSize = "Y"
        optionframe.Visible = false

        pinbutton.Parent = tabtext
        pinbutton.BackgroundTransparency = 1
        pinbutton.BorderSizePixel = 0
        pinbutton.Position = UDim2.new(0, 150, 0, 4)
        pinbutton.Size = UDim2.new(0, 20, 0, 20)
        pinbutton.Font = guipallet.Font
        pinbutton.Text = "📍"
        pinbutton.TextColor3 = guilibrary.TextColor
        pinbutton.TextTransparency = 0.4
        pinbutton.TextSize = 22
        
        uiListLayout.Parent = tab
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 0)

        uiCorner.Parent = tab
        uiCorner.CornerRadius = UDim.new(0, guilibrary.uiCornersRadius)
        table.insert(guilibrary.uiCorners, uiCorner)

        function tabtable:getContainer()
            return container
        end

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

        function tabtable:Toggle(bool)
            bool = bool or not tabtable.Toggled
            tabtable.Toggled = bool
            tab.Visible = bool
        end

        table.insert(connections, optionsbutton.MouseButton1Click:Connect(function()
            optionframe.Visible = not optionframe.Visible
        end))

        table.insert(connections, pinbutton.MouseButton1Click:Connect(function()
			tabtable:Pin()
		end))
    end

    function guilibrary:CreateTab(argstable)
        local tabname = argstable.Name
        local color = argstable.Color or Color3.fromRGB(83, 214, 110)
        local customTab = argstable.CustomTab or false
        local Callback = argstable.Callback or function() end
        local tab = Instance.new("TextButton")
        local tabnametext = Instance.new("TextLabel")
        local showunshowbutton = Instance.new("TextButton")
        local UIListLayout2 = Instance.new("UIListLayout")
        local UICorner = Instance.new("UICorner")
        local TopPadding = Instance.new("UIPadding")
        local pinbutton = Instance.new("TextButton")
        local togglesTable = {}
        local ActualScrollingFrame
        local ScrollingFrame

        local tabtable = {
            Name = tabname,
            CustomTab = customTab,
            BaseColor = color,
            Pinned = false,
            ObjectsVisible = true,
            Toggled = false,
            Callback = Callback,
            Position = UDim2.new(0, 40, 0, 40),
            Order = #Tabs,
            Toggles = {}
        }

        table.insert(Tabs, tabtable)

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
        tab.Visible = false
        tabtable.MainObject = tab
        dragGUI(tab)

        tabnametext.Name = tabname
        tabnametext.Parent = tab
        tabnametext.ZIndex = tab.ZIndex + 1
        tabnametext.BackgroundColor3 = guipallet.Color1
        tabnametext.BackgroundTransparency = 0
        tabnametext.BorderSizePixel = 0
        tabnametext.Size = UDim2.new(0, 207, 0, 30)
        tabnametext.Font = guipallet.Font
        tabnametext.Text = " " .. tabname
        tabnametext.TextColor3 = color
        tabnametext.TextSize = 22
        tabnametext.TextWrapped = true
        tabnametext.TextXAlignment = Enum.TextXAlignment.Left
        tabnametext.TextYAlignment = Enum.TextYAlignment.Top
        tabnametext.Selectable = true

        UICorner.Parent = tab
        UICorner.CornerRadius = UDim.new(0, guilibrary.uiCornersRadius)
        table.insert(guilibrary.uiCorners, UICorner)

        TopPadding.Parent = tab
        TopPadding.PaddingTop = UDim.new(0, 10)

        if customTab then
            tabtable.Toggleable = false

            local container = Instance.new("Frame")
            local background = Instance.new("Frame")
            local optionsbutton = Instance.new("ImageButton")
            local pinbutton = Instance.new("TextButton")
            local uiListLayout = Instance.new("UIListLayout")
            local uilistLayout2 = Instance.new("UIListLayout")

            container.Name = "Container"
            container.Parent = tab
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0
            container.Position = UDim2.new(0, 0, 1, 0)
            container.Size = UDim2.new(1, 0, 0, 0)

            background.Name = "background"
            background.Parent = tab
            background.BackgroundColor3 = guipallet.Color2
            background.Position = UDim2.new(0, 0, 1, 0)--UDim2.new(0.102424242, 0, 0.237059206, 0)
            background.Size = UDim2.new(0, 207, 0, 0)
            background.AutomaticSize = Enum.AutomaticSize.Y
            background.Visible = false
            ActualScrollingFrame = background

            uiListLayout.Parent = background
            uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Padding = UDim.new(0, 8)
            
            uilistLayout2.Parent = container
            uilistLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            uilistLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            uilistLayout2.Padding = UDim.new(0, 0)

            optionsbutton.Parent = tab
            optionsbutton.Position = UDim2.new(0, 170, 0, -6)
            optionsbutton.Size = UDim2.new(0, 32, 0, 32)
            optionsbutton.BackgroundTransparency = 1
            optionsbutton.Image = "http://www.roblox.com/asset/?id=12809025337"
            optionsbutton.Rotation = 90
            optionsbutton.ZIndex = 2

            pinbutton.Parent = tabnametext
            pinbutton.BackgroundTransparency = 1
            pinbutton.BorderSizePixel = 0
            pinbutton.Position = UDim2.new(0, 150, 0, 4)
            pinbutton.Size = UDim2.new(0, 20, 0, 20)
            pinbutton.Font = guipallet.Font
            pinbutton.Text = "📍"
            pinbutton.TextColor3 = guipallet.TextColor
            pinbutton.TextTransparency = 0.4
            pinbutton.TextSize = 22
            pinbutton.ZIndex = 2

            tabnametext.Position = UDim2.new(0, 0, 0, -4) -- so the ui corner at the bottom will work 

            function tabtable:Pin(bool)
                bool = bool or not tabtable.Pinned
                tabtable.Pinned = bool
                pinbutton.TextTransparency = bool and 0 or 0.4
                if bool then
                    table.insert(guilibrary.pinnedobjects, tabtable)
                else
                    table.remove(guilibrary.pinnedobjects, table.find(guilibrary.pinnedobjects, tabtable))
                end
            end

            function tabtable:getContainer()
                return container
            end

            function tabtable:getUIListLayout()
                return uilistLayout2
            end

            function tabtable:Toggle(bool, toggleable)
                bool = bool or not tabtable.Toggled
                tabtable.Toggled = bool
                tabtable.Toggleable = toggleable or false
                if not toggleable then
                    tab.Visible = false
                else
                    tab.Visible = bool
                end
            end

            table.insert(connections, pinbutton.MouseButton1Click:Connect(function()
                tabtable:Pin()
            end))

            table.insert(connections, optionsbutton.MouseButton1Click:Connect(function()
                background.Visible = not background.Visible
                container.Visible = not container.Visible
            end))
        else
            ActualScrollingFrame = Instance.new("ScrollingFrame")
            ActualScrollingFrame.Name = "TabToggles"
            ActualScrollingFrame.Parent = tab
            ActualScrollingFrame.BackgroundTransparency = 1
            ActualScrollingFrame.BorderSizePixel = 0
            ActualScrollingFrame.Position = UDim2.new(0, 0, 0.97, 0)
            ActualScrollingFrame.Size = UDim2.new(0, 207, 0, 600)
            ActualScrollingFrame.ScrollBarThickness = 1
            ActualScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            ActualScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

            showunshowbutton.Parent = tabnametext
            showunshowbutton.BackgroundTransparency = 1
            showunshowbutton.BorderSizePixel = 0
            showunshowbutton.Position = UDim2.new(0, 178, 0, 2.5)
            showunshowbutton.Size = UDim2.new(0, 20, 0, 20)
            showunshowbutton.Font = guipallet.Font
            showunshowbutton.Text = "-"
            showunshowbutton.TextColor3 = guipallet.TextColor
            showunshowbutton.TextTransparency = 0
            showunshowbutton.TextSize = 22

            if tabname == "Settings" or tabname == "Friends" or tabname == "Profiles" then
                local background = Instance.new("Frame")
                local uiListLayout = Instance.new("UIListLayout")

                background.Name = "background"
                background.Parent = ActualScrollingFrame
                background.BackgroundColor3 = guipallet.Color2
                background.Position = UDim2.new(0, 0, 0, 0)--UDim2.new(0.102424242, 0, 0.237059206, 0)
                background.Size = UDim2.new(0, 207, 0, 0)
                background.AutomaticSize = "Y"
                ActualScrollingFrame = background

                uiListLayout.Parent = background
                uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiListLayout.Padding = UDim.new(0, 8)
            else
                UIListLayout2.Parent = ActualScrollingFrame
                UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout2.Padding = UDim.new(0, 0)
                
                table.insert(connections, UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    local height = math.max(UIListLayout2.AbsoluteContentSize.Y, 600)
                    ActualScrollingFrame.CanvasSize = UDim2.new(0, UIListLayout2.AbsoluteContentSize.X, 0, height)
                end))
            end

            table.insert(connections, showunshowbutton.MouseButton1Click:Connect(function()
                tabtable.ObjectsVisible = not tabtable.ObjectsVisible
                ActualScrollingFrame.Visible = not ActualScrollingFrame.Visible
                showunshowbutton.Text = tabtable.ObjectsVisible and "-" or "+"
            end))
        end

        ScrollingFrame = ActualScrollingFrame

        function tabtable:GetMainObject()
            return tab
        end

        function tabtable:CreateDivider(DividerText)
            local DividerFrame = Instance.new("Frame")
            local Divider = Instance.new("TextLabel")
            local DividerFrame2 = Instance.new("Frame")
            DividerFrame.Name = tabname .. "_FrameDivider"
            DividerFrame.Parent = ScrollingFrame
            DividerFrame.BackgroundColor3 = guipallet.Color5
            DividerFrame.BorderSizePixel = 0
            DividerFrame.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            DividerFrame.Size = UDim2.new(0, 207, 0, 2)
            Divider.Name = tabname .. "_TextLabelDivider"
            Divider.Parent = ScrollingFrame
            Divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Divider.BorderSizePixel = 0
            Divider.Position = UDim2.new(0.0827946085, -17, 0.133742347, 33)
            Divider.Size = UDim2.new(0, 207, 0, 20)
            Divider.Font = guipallet.Font
            Divider.Text = DividerText
            Divider.TextColor3 = guipallet.TextColor
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
            Divider.TextColor3 = guipallet.TextColor
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
            table.insert(togglesTable, togglesTable.Name)

            table.sort(togglesTable, function(a, b)
                return a < b
            end)

            local order = guilibrary:getIndex(togglesTable, data.Name)

            if order == nil then
                order = #togglesTable + 1
            end

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
            toggle.LayoutOrder = order

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
            optionframe.LayoutOrder = order

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
                connection = userInputService.InputBegan:Connect(function(input)
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
            
            function ToggleTable:Toggle(silent, bool)
                bool = bool or (not ToggleTable.Enabled)
                silent = silent or false
                ToggleTable.Enabled = bool
                local tweenName = (bool and "enable") or "disable"
            
                spawn(function()
                    guilibrary:CreateNotification(title, (bool and "Enabled " or "Disabled ") .. title, 4, bool)
                end)

                if bool then
                    tweens.toggle.enable(toggle, guipallet.ThemeMode == "Default" and tabnametext.TextColor3 or guipallet.ToggleColor2):Play()
                else
                    tweens.toggle.disable(toggle):Play()
                end

                if not silent then
                    guilibrary:playsound("rbxassetid://421058925", 1)
                end

                spawn(function()
                    Callback(bool)
                end)
            end

            function ToggleTable:ReToggle(silent)
                ToggleTable:Toggle(silent)
                ToggleTable:Toggle(silent)
            end
            
            table.insert(connections, toggle.MouseButton1Click:Connect(function()
                ToggleTable:Toggle()
            end))
            
            table.insert(connections, userInputService.InputBegan:Connect(function(input)
                if oldkey and not cooldown and not isclicked and input.KeyCode.Name == oldkey and not userInputService:GetFocusedTextBox() then
                    ToggleTable:Toggle()
                end
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

            -- ColorSlider made by Wowzers and changed to ManaV2 style by Maanaaaa
            function ToggleTable:CreateColorSlider(argstable)
                local name = argstable.Name
                local value = argstable.Default or Color3.fromRGB(255, 255, 255)
                local rainbow = argstable.Rainbow or false
                local callback = argstable.Callback or argstable.Function or function() end
                local hue, sat, val = 0, 1, 1
                local dragging = nil
                local visible = false
                local optionObjects = {}
                local colorsliderapi = {
                    Name = name,
                    Value = value,
                    RawColorTable = {R = 255, G = 255, B = 255},
                    Rainbow = rainbow,
                    Callback = callback
                }
            
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
                colorsliderapi.MainObject = colorPickerFrame

                moreButton.Name = "MoreButton"
                moreButton.Size = UDim2.new(0, 12, 0, 6)
                moreButton.Position = UDim2.new(0, textService:GetTextSize(name, 15, guipallet.Font, Vector2.new(1000, 1000)).X + 15, 0, 5)
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
                    ColorSequenceKeypoint.new(1, guilibrary:HSVtoRGB(0, 1, 1))
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
                    ColorSequenceKeypoint.new(1, guilibrary:HSVtoRGB(0, 1, 1))
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
                    local color = guilibrary:HSVtoRGB(hue, sat, val)
                    rainbow = rainbow or false
                    value = color
                    local newColorTable = {
                        R = math.floor(color.R * 255 + 0.5),
                        G = math.floor(color.G * 255 + 0.5),
                        B = math.floor(color.B * 255 + 0.5)
                    }
                    colorsliderapi.RawColorTable = newColorTable

                    saturationGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, guilibrary:HSVtoRGB(hue, 1, val))
                    })
                    valueGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, guilibrary:HSVtoRGB(hue, sat, 1))
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
                    colorsliderapi.Value = color
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
            
                table.insert(connections, userInputService.InputChanged:Connect(function(input)
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
                
                table.insert(connections, userInputService.InputEnded:Connect(function(input)
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
                
                table.insert(connections, userInputService.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement and userInputService.MouseEnabled) or (input.UserInputType == Enum.UserInputType.Touch) then
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
                --Dropdown.Position = UDim2.new(0.0859375, 0, 0.491620123, 0)
                Dropdown.Size = UDim2.new(0, 175, 0, 25)
                Dropdown.Font = guipallet.Font
                Dropdown.Text = name .. ": " .. value
                Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.TextSize = 22
                Dropdown.TextWrapped = true
                Dropdown.TextXAlignment = Enum.TextXAlignment.Left
                Dropdown.TextYAlignment = Enum.TextYAlignment.Bottom
                --Dropdown.ZIndex = 5

                DropdownOptions.Name = "DropdownOptions"
                DropdownOptions.Parent = optionframe
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.BorderSizePixel = 0
                DropdownOptions.Position = UDim2.new(0, 0, 0, 25)
                DropdownOptions.Size = UDim2.new(0, 175, 0, 25)
                DropdownOptions.Visible = false
                DropdownOptions.ZIndex = 500
                --DropdownOptions.ZIndexBehavior = Enum.ZIndexBehavior.Global

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
                    button.BackgroundColor3 = guipallet.Color1
                    button.BackgroundTransparency = 0.8
                    button.BorderSizePixel = 0
                    button.Size = UDim2.new(0, 175, 0, 25)
                    button.Font = guipallet.Font
                    button.Text = name
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextSize = 22
                    button.TextWrapped = true
                    button.TextXAlignment = Enum.TextXAlignment.Left
                    button.ZIndex = 500

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

                table.insert(connections, DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    local count = 0
                    for _, child in pairs(DropdownOptions:GetChildren()) do
                        if child:IsA("TextButton") then
                            count = count + 1
                        end
                    end
                    --ListFrame.CanvasSize = UDim2.new(0, uiListLayout.AbsoluteContentSize.X, 0, uiListLayout.AbsoluteContentSize.Y)
                    DropdownOptions.Size = UDim2.new(0, 175, 0, count * 25)
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
                    Value = value,
                    Type = "OptionToggle",
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
                Label.TextSize = 22 --#name > 12 and 22 or 22 - #name
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
                    optiontoggleapi.Value = bool
            
                    spawn(function()
                        Callback(bool)
                    end)
            
                    ActiveFrame.BackgroundColor3 = (bool and ((guipallet.ThemeMode == "Default" and tabnametext.TextColor3) or guipallet.ToggleColor2)) or guipallet.Color3
                end

                function optiontoggleapi:ReToggle()
                    optiontoggleapi:Toggle()
                    optiontoggleapi:Toggle()
                end

                optiontoggleapi:Toggle(value)
            
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
                local choose = argstable.Choose or false
                local multiChoose = argstable.MultiChoose or false
                local default = argstable.Default or false
                local current = "none"
                local choosedTable = {}
                local choosedObjectsTable = {}
                local Callback = argstable.Callback or argstable.Function or function() end
                local count = 0
                local textlistapi = {
                    Name = argstable.Name,
                    List = list,
                    PlaceholderText = PlaceholderText,
                    Choose = choose,
                    MultiChoose = multiChoose,
                    Default = default,
                    Choosed = "none",
                    ChoosedTable = {},
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

                function textlistapi:Set(name, obj)
                    if obj then
                        if multiChoose == false then
                            -- here it's disabling the previous selected one
                            Callback(choosedTable[1], false)
                            choosedObjectsTable[1].BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                            table.clear(choosedTable)
                            table.clear(choosedObjectsTable)

                            -- and here it's enabling the current selected one
                            obj.BackgroundColor3 = guilibrary:makeColorDarker((guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2)
                            table.insert(choosedTable, name)
                            table.insert(choosedObjectsTable, obj)
                            Callback(name, true)
                        elseif obj.BackgroundColor3 == (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2 then
                            obj.BackgroundColor3 =  guilibrary:makeColorDarker((guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2)
                            table.insert(choosedTable, name)
                            table.insert(choosedObjectsTable, obj)
                            Callback(name, true)
                        else
                            obj.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                            table.remove(choosedTable, name)
                            table.remove(choosedObjectsTable, obj)
                            Callback(name, false)
                        end
                    end
                    for _, listobj in next, listFrame do
                        if not listobj:IsA("UIListLayout") and listobj.Name == not name and not table.find(choosedObjectsTable, obj) then
                            listobj.BackgroundColor3 =(guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                        end
                    end
                end

                function textlistapi:CreateListObject(text)
                    if not textlistobjects[text] then
                        local listobject = Instance.new("TextButton")
                        local uicorner = Instance.new("UICorner")
                        local removebutton = Instance.new("TextButton")
                        listobject.Name = text
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
                        uicorner.Parent = listobject
                        uicorner.CornerRadius = UDim.new(0, guilibrary.UICornersRadius)
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
                            if choose then
                                textlistapi:Select(text, listobject)
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

                function textlistapi:ResetListObjects()
                    for _, object in next, listFrame do
                        if not object:IsA("UIListLayout") then
                            table.remove(list, guilibrary:findStringInTable(list, object.text))
                            object:Destroy()
                        end
                    end
                    textlistobjects = {}
                    count = 0
                    for _, name in next, list do
                        textlistapi:CreateListObject(name)
                    end
                end

                addToListButton.MouseButton1Click:Connect(function()
                    textlistapi:CreateListObject(textListBox.Text)
                    textListBox.Text = ""
                end)

                for _, name in next, list do
                    textlistapi:CreateListObject(name)
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
            
            table.insert(connections, userInputService.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseMovement and userInputService.MouseEnabled) or (input.UserInputType == Enum.UserInputType.Touch) then
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

            optiontoggleapi:Toggle(value)
        
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
            local list = argstable.DefaultList or argstable.List or {}
            local PlaceholderText = argstable.PlaceholderText or "enter something..."
            local choose = argstable.Choose or false
            local multiChoose = argstable.MultiChoose or false
            local default = argstable.Default or false
            local current = "none"
            local choosedTable = {}
            local choosedObjectsTable = {}
            local Callback = argstable.Callback or argstable.Function or function() end
            local count = 0
            local textlistapi = {
                Name = argstable.Name,
                List = list,
                PlaceholderText = PlaceholderText,
                Choose = choose,
                MultiChoose = multiChoose,
                Default = default,
                Choosed = "none",
                ChoosedTable = {},
                Callback = Callback
            }
            
            local textListBackground = Instance.new("Frame")
            local textListBox = Instance.new("TextBox")
            local addToListButton = Instance.new("TextButton")
            local listFrame = Instance.new("ScrollingFrame")
            local uiListLayout = Instance.new("UIListLayout")

            textListBackground.Name = "textboxbackground"
            textListBackground.Parent = ScrollingFrame
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
            listFrame.Parent = ScrollingFrame
            listFrame.BackgroundTransparency = 1
            listFrame.BorderSizePixel = 0
            listFrame.Position = UDim2.new(0, 0, 0, 0)
            listFrame.Size = UDim2.new(0, 180, 0, 1)
            listFrame.ScrollBarThickness = 1
            listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            listFrame.ScrollingDirection = Enum.ScrollingDirection.Y

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

            function textlistapi:Set(name, obj)
                if obj then
                    if multiChoose == false then
                        -- here it's disabling the previous selected one
                        if choosedObjectsTable[1] then
                            Callback(choosedTable[1], false)
                            choosedObjectsTable[1].BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                        end
                        table.clear(choosedTable)
                        table.clear(choosedObjectsTable)

                        -- and here it's enabling the current selected one
                        obj.BackgroundColor3 = guilibrary:makeColorDarker((guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2)
                        table.insert(choosedTable, name)
                        table.insert(choosedObjectsTable, obj)
                        Callback(name, true)
                    elseif obj.BackgroundColor3 == (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2 then
                        obj.BackgroundColor3 =  guilibrary:makeColorDarker((guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2)
                        table.insert(choosedTable, name)
                        table.insert(choosedObjectsTable, obj)
                        Callback(name, true)
                    else
                        obj.BackgroundColor3 = (guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                        table.remove(choosedTable, name)
                        table.remove(choosedObjectsTable, obj)
                        Callback(name, false)
                    end
                end
                for _, listobj in next, listFrame do
                    if not listobj:IsA("UIListLayout") and listobj.Name == not name and not table.find(choosedObjectsTable, obj) then
                        listobj.BackgroundColor3 =(guipallet.ThemeMode == "Default" and tabname.TextColor3) or guipallet.Color2
                    end
                end
            end

            function textlistapi:CreateListObject(text)
                if not textlistobjects[text] then
                    local listobject = Instance.new("TextButton")
                    local uicorner = Instance.new("UICorner")
                    local removebutton = Instance.new("TextButton")
                    listobject.Name = text
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
                    uicorner.Parent = listobject
                    uicorner.CornerRadius = UDim.new(0, guilibrary.UICornersRadius)
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
                        if choose then
                            textlistapi:Set(text, listobject)
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

            function textlistapi:ResetListObjects()
                for _, object in next, listFrame do
                    if not object:IsA("UIListLayout") then
                        table.remove(list, guilibrary:findStringInTable(list, object.text))
                        object:Destroy()
                    end
                end
                textlistobjects = {}
                count = 0
                for _, name in next, list do
                    textlistapi:CreateListObject(name)
                end
            end

            addToListButton.MouseButton1Click:Connect(function()
                textlistapi:CreateListObject(textListBox.Text)
                textListBox.Text = ""
            end)

            for _, name in next, list do
                textlistapi:CreateListObject(name)
            end
        
            guilibrary.ObjectsThatCanBeSaved[argstable.Name .. "TextList"] = {
                Table = textlistapi, 
                mainobject = textListBackground, 
                textbox = textListBox,
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
        BottomCorner.Size = UDim2.new(0, 207, 0, 12)
        BottomCorner.Position = UDim2.new(0, 0, 0, 500)
        BottomCorner.LayoutOrder = 99999

        BottomFix.Parent = BottomCorner
        BottomFix.BackgroundColor3 = Color3.fromRGB(guipallet.Color1)
        BottomFix.BorderSizePixel = 0
        BottomFix.Transparency = 0
        BottomFix.Size = UDim2.new(0, 207, 0, 3)

        UICorner.Parent = BottomCorner
        UICorner.CornerRadius = UDim.new(0, guilibrary.uiCornersRadius)
        table.insert(guilibrary.uiCorners, UICorner)
        
        guilibrary.ObjectsThatCanBeSaved[tabname.."Tab"] = {
            Table = tabtable,
            mainobject = tab, 
            Type = "Tab"
        }
        return tabtable
    end
end

return guilibrary
