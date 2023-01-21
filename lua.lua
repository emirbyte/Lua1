repeat task.wait() until game:IsLoaded()

getgenv().Fondra    = {}
Fondra.Buttons      = {}
Fondra.Cooldowns    = {}
Fondra.Visuals      = {}
Fondra.StartTick    = tick()

Fondra.Services = setmetatable({}, {
    __index = function(self, key)
        return game.GetService(game, key)
    end
})

Fondra.SecureGet = function(Link)
    local Method            = (syn and syn.request) or request
    local Success, Result   = pcall(Method, {
        Url         = Link,
        Method      = "GET"
    })

    makefolder("Fondra")
    makefolder("Fondra/Logs")

    if not Success then
        writefile("Fondra/Logs/Fondra-[" .. os.time() .. "]-.log", Result)

        game:Shutdown()
    end

    if not typeof(Result) == "table" then
        writefile("Fondra/Logs/Fondra-[" .. os.time() .. "]-.log", Result)

        game:Shutdown()
    end
    
    return Result.Body
end

Fondra.Init = function()
    local HTTPData      = Fondra.SecureGet("https://api.fondra.xyz/GameData/" .. game.GameId)

    if not HTTPData then
        Fondra.Services.Players.LocalPlayer:Kick('[Fondra]\n\nYour exploit is not supported by Fondra!\ntry moving into Synapse X or KRNL.')
    else
        local GameData  = Fondra.Services.HttpService:JSONDecode(HTTPData)

        if GameData.ServerVersion == 0 then
            getgenv().Fondra    = nil
    
            return messagebox("This game is currently unsupported by Fondra at the moment\n\nIncase you want support for it by Fondra, please make it a suggestion on the Discord server (discord.gg/2t5sAcgyWP)", "Fondra", 0)
        end

        if (os.time() - GameData.ServerVersion) > 2629800 then
            local WarningMessage    = messagebox("This game hasn't been updated or reviewed in over a month, this mean that features could have been patched or broken.\n\nDo you want to continue?", "Fondra", 4)
    
            if WarningMessage == 7 then
                getgenv().Fondra    = nil
    
                return
            end
        end
            
        loadstring(Fondra.SecureGet(GameData[DLCMode and DLCMode or "V2Modules"].USER_UI))()
        loadstring(Fondra.SecureGet(GameData[DLCMode and DLCMode or "V2Modules"].ESP_Module))()
        loadstring(Fondra.SecureGet(GameData[DLCMode and DLCMode or "V2Modules"].MAIN_Module))()
    end
end

Fondra.Init()
