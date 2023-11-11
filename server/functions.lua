RegisterNetEvent('zaps:kick')
AddEventHandler('zaps:kick', function(reason)
    DropPlayer(source, reason) 
    logKickToDiscord(GetPlayerName(source), reason)
end)
function logKickToDiscord(playerName, kickReason)
    local discordWebhookUrl = GetConvar("vac:webhook", "")
    if discordWebhookUrl == "" or == discordWebhookUrl "https://discord.com/api/webhooks/" then
        print("[VulcanAC]: Edit webhook.cfg Or Add this to your ccfg @vulcan-ac/webhook.cfg")
        return
    end
    local discordMessage = {
        username = "Vulcan Anticheat", 
        embeds = {{
            title = "Suspected Cheater Kicked",
            description = "Player **" .. playerName .. "** was kicked for suspected cheating.\n**Reason:** " .. kickReason,
            color = 16711680 
        }}
    }

    PerformHttpRequest(discordWebhookUrl, function(err, text, headers)
    end, 'POST', json.encode(discordMessage), { ['Content-Type'] = 'application/json' })
end
function zapsupdatee()
    local githubRawUrl = "https://raw.githubusercontent.com/Zaps6000/base/main/api.json"
    local resourceName = "anticheat" 
    
    PerformHttpRequest(githubRawUrl, function(statusCode, responseText, headers)
        if statusCode == 200 then
            local responseData = json.decode(responseText)
    
            if responseData[resourceName] then
                local remoteVersion = responseData[resourceName].version
                local description = responseData[resourceName].description
                local changelog = responseData[resourceName].changelog
    
                local manifestVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    
                print("Resource: " .. resourceName)
                print("Manifest Version: " .. manifestVersion)
                print("Remote Version: " .. remoteVersion)
                print("Description: " .. description)
    
                if manifestVersion ~= remoteVersion then
                    print("Status: Out of Date (New Version: " .. remoteVersion .. ")")
                    print("Changelog:")
                    for _, change in ipairs(changelog) do
                        print("- " .. change)
                    end
                    print("Link to Updates:  https://discord.gg/cfxdev")
                else
                    print("Status: Up to Date")
                end
            else
                print("Resource name not found in the response.")
            end
        else
            print("HTTP request failed with status code: " .. statusCode)
        end
    end, "GET", nil, json.encode({}), {})
    end
    AddEventHandler('onResourceStart', function(resource)
        if resource == 'vulcan-ac' then
            zapsupdatee()
        else 
            print("[ALERT!!! Please rename your resource to vulcan-ac") -- Please do not edit this is how I keep track of how many servers use it.
        end
    end)
