-- join https://discord.gg/cfxdev for support
local loaded = false
if Config.BlacklistedMenuTextures.Enabled then
    CreateThread(function()
        while true do
            Citizen.Wait(3000) 
            for _, textureInfo in ipairs(Config.BlacklistedMenuTextures.Textures) do
                if HasStreamedTextureDictLoaded(textureInfo.Texture) then
                        TriggerServerEvent('zaps:kick',  Config.BlacklistedMenuTextures.Message .. " (" .. textureInfo.Label .. ")") -- Plan on reworking event
                        if Config.DebugMode then 
                            print(textureInfo.Label)
                        end
                end
            end
        end
    end)
end

if Config.BlacklistedKeys.Enabled then
    CreateThread(function()
        while true do
            Citizen.Wait(10) 
            for _, key in pairs(Config.BlacklistedKeys.Keys) do
                if IsControlJustPressed(0, tonumber(key.KeyCode)) then
                    if Config.DebugMode then 
                        print("Pressed blacklisted key: " .. key.Label)
                    end
                end
            end
        end
    end)
end

if Config.BlacklistedEvents.Enabled then
    for _, event in pairs(Config.BlacklistedEvents.Events) do
        if event.type == 'client' then
            AddEventHandler(event.Name, function()
            --    if not hasBypassPermission(source, Config.BlacklistedEvents.ACEPermission) then need to finish said function
                    CancelEvent()
                    TriggerServerEvent('zaps:kick', Config.BlacklistedEvents.Message)
              --  end
            end)
        end
    end
end

if Config.Spectate.Enabled then 
    CreateThread(function()
        while true do
            Citizen.Wait(Config.Spectate.CheckInterval) 
            local Spectate = Citizen.InvokeNative('0x048746E388762E11') -- NetworkIsInSpectatorMode()
               
            if Spectate == 1 then 
                if Config.Debug then 
                    print(Spectate)
                end
                TriggerServerEvent('zaps:kick', Config.Spectate.Message)
                TriggerEvent('logKickToDiscordEvent', GetPlayerName(PlayerId()), Config.Spectate.Message)
            end
        end
    end)
end

if Config.AntiNoClip.Enabled then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(3000)
            local ped = PlayerPedId()
            local posx,posy,posz = table.unpack(GetEntityCoords(ped, true))
            local still = IsPedStill(ped)
            local vel = GetEntitySpeed(ped)
            local ped = PlayerPedId()
            local veh = IsPedInAnyVehicle(ped, true)
            local speed = GetEntitySpeed(ped)
            local para = GetPedParachuteState(ped)
            local flyveh = IsPedInFlyingVehicle(ped)
            local rag = IsPedRagdoll(ped)
            local fall = IsPedFalling(ped)
            local parafall = IsPedInParachuteFreeFall(ped)
    
            local more = speed - 9.0
    
            local rounds = tonumber(string.format("%.2f", speed))
            local roundm = tonumber(string.format("%.2f", more))
    
            newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
            newPed = PlayerPedId()
                                
            if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 200 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
                if Config.Debug then 
                    print(GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
                end
                    
                TriggerServerEvent('zaps:kick', Config.Spectate.Message)
                TriggerEvent('logKickToDiscordEvent', GetPlayerName(PlayerId()), Config.Spectate.Message .. " - Distance change in 3 second - " .. GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
            end
        end
    end)
end
AddEventHandler('playerSpawned', function(spawn)
	loaded = true
    end)

    if Config.AntiResourceTamper.Enabled then 
    AddEventHandler('onResourceStop', function(resourceName)
    if not loaded then return end
		if resourceName == GetCurrentResourceName() then
            CancelEvent()
            TriggerServerEvent('zaps:kick', Config.AntiResourceTamper.KickMessage)
            TriggerEvent('logKickToDiscordEvent', GetPlayerName(PlayerId()), Config.AntiResourceTamper.Message)
                else
            CancelEvent()
            TriggerServerEvent('zaps:kick', Config.AntiResourceTamper.Message)
            TriggerEvent('logKickToDiscordEvent', GetPlayerName(PlayerId()), Config.AntiResourceTamper.KickMessage)
		    end
	    end)
    end
