-- join https://discord.gg/cfxdev for support
local Loaded  = false
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
    AddEventHandler('playerSpawned', function(spawn)
	  Loaded = true
    end)
if Config.SuperJump.Enabled then
if Loaded then 
CreateThread(function()
    while true do
        Wait(1500)
        if IsPedJumping(PlayerPedId()) then
            local firstCoord = GetEntityCoords(PlayerPedId())
            while IsPedJumping(PlayerPedId()) do
                Wait(0)
            end
            local secondCoord = GetEntityCoords(PlayerPedId())
            local Length = GetDistanceBetweenCoords(firstCoord, secondCoord, false)
            if Config.SuperJump.LengthThreshold > 15 then 
                        if Config.Debug then 
                            print('Detected  jump: Length = ' .. jumplength)
                        end
            TriggerServerEvent('zaps:kick', Config.SuperJump.Message)
            end
        end
    end
end)
end
end
