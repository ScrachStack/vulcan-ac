-- join https://discord.gg/cfxdev for support
if Config.BlacklistedMenuTextures.Enabled then
    CreateThread(function()
        while true do
            Citizen.Wait(3000) 

            for _, textureInfo in ipairs(Config.BlacklistedMenuTextures.Textures) do
                if HasStreamedTextureDictLoaded(textureInfo.Texture) then
                        TriggerServerEvent('zaps:kick',  Config.BlacklistedMenuTextures.Message .. " (" .. textureInfo.Label .. ")")
                        if Config.DebugMode then 
                        print(textureInfo.Label)
                        end
                end
            end
        end
    end)
end
