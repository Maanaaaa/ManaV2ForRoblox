local Functions = {}
_G.Functions = Functions -- for KeySystemLibrary.lua
local httprequest = (request and http and http.request or http_request or fluxus and fluxus.request)

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

function Functions:RunFile(filepath)
    local req = requestfunc({
        Url = "https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath,
        Method = "GET"
    })
    if not betterisfile(filepath) then
            local context = req.Body
            writefile(filepath, context)
        return loadstring(context)()
    else
        if isfile("NewMana/" .. filepath) then
            return loadstring(readfile("NewMana/" .. filepath))()
        elseif isfile("Mana/" .. filepath) then
            return loadstring(readfile("Mana/" .. filepath))()
        else
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Maanaaaa/ManaV2ForRoblox/main/" .. filepath))()
        end
    end
end

local KeySystemLibrary = Functions:RunFile("Modules/KeySystemLibrary.lua")

local Window = KeySystemLibrary:Create({
    Key = "$Dy71b0o4a(*g)!?g%",
    Callback = function(callback)
        if callback then
            Functions:RunFile("NewMainScript.lua")
        else
            print("[ManaV2ForRoblox/NewestMainScript.lua]: Something went wrong, try again or message the developer on discord - @mankacoder.")
        end
    end
})