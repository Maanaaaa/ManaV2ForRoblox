local Functions = {}
_G.Functions = Functions -- for KeySystemLibrary.lua
local httprequest = (request and http and http.request or http_request or fluxus and fluxus.request)

function Functions:RunFile(filepath)
    if isfile("NewMana/" .. filepath) then
        return loadstring(readfile("NewMana/" .. filepath))()
    elseif isfile("Mana/" .. filepath) then
        return loadstring(readfile("Mana/" .. filepath))()
    else
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath))()
    end
end

local KeySystemLibrary = Functions:RunFile("Modules/KeySystemLibrary.lua")

local Window = KeySystemLibrary:Create({
    Key = "$Dy71b0o4a(*g)!g%",
    Callback = function(callback)
        if callback then
            Functions:RunFile("NewMainScript.lua")
        else
            print("[ManaV2ForRoblox/NewestMainScript.lua]: Something went wrong, try again or message the developer on discord - @mankacoder.")
        end
    end
})