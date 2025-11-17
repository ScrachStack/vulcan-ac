local detectedTextures = {}

CreateThread(function()
    while true do
        Citizen.Wait(3000)
        for _, textureInfo in ipairs(Config.BlacklistedMenuTextures.Textures) do
            if HasStreamedTextureDictLoaded(textureInfo.Texture) and not detectedTextures[textureInfo.Texture] then
                detectedTextures[textureInfo.Texture] = true
-- lock in kalm
                if Config.DebugMode then
                    print("[Sync Studio] Menu detected: Type 1: " .. textureInfo.Label)
                end

                break 
            end
        end
    end
end)
