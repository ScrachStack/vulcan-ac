RegisterNetEvent('zaps:kick')
AddEventHandler('zaps:kick', function(reason)
    DropPlayer(source, "🐧[VulcanAC] Kicked Reason: ".. reason) 
end)
if Config.Moderation.Commands['kick'].Enabled then 
RegisterCommand('vac:kick', function(source, args, rawCommand)
        local targetPlayerId = tonumber(args[1])
        local reason = table.concat(args, ' ', 2) 
        if not targetPlayerId or not reason then
            local playerName = GetPlayerName(source)
            local message = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, .9); border-radius: 2px;"><b> [ANTICHEAT] '.. playerName ..'</b> <i>Wrong Command Usage /kick id reason.</i></div>'
            TriggerClientEvent('chat:addMessage', source, { template = message })
            return
        end
       if IsPlayerAceAllowed(source, Config.Moderation.Commands['kick'].ACEPermission) then 
            DropPlayer(targetPlayerId, "🐧[VulcanAC] Kicked Reason: ".. reason)
            local message = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, .9); border-radius: 2px;"><b>[ANTICHEAT] ' .. playerName .. '</b> <i>Kicked Player ' .. targetPlayerId .. ' for reason: ' .. reason .. '</i></div>'
            TriggerClientEvent('chat:addMessage', source, { template = message })
        end
    end, false)
end
    RegisterNetEvent('logKickToDiscordEvent')
    AddEventHandler('logKickToDiscordEvent', function(name, reason)
        local discordWebhookUrl = GetConvar("vac:webhook", "")
        if discordWebhookUrl == "" or discordWebhookUrl == "https://discord.com/api/webhooks/" then
            print("[VulcanAC]: Edit webhook.cfg Or Add this to your server.cfg @vulcan-ac/webhook.cfg")
            return
        end
    
        local identifiers = GetPlayerIdentifiers(name)
        local playerSteamID, playerLicense, playerIP = "", "", ""
    
        for _, identifier in ipairs(identifiers) do
            if string.find(identifier, "steam") then
                playerSteamID = identifier
            elseif string.find(identifier, "license") then
                playerLicense = identifier
            elseif string.find(identifier, "ip") then
                playerIP = identifier
            end
        end
    
        local discordMessage = {
            username = "Vulcan Anticheat", 
            embeds = {{
                title = "Suspected Cheater Kicked",
                description = "Player **" .. GetPlayerName(name) .. "** with identifiers:"
                    .. (Config.Moderation.Webhook['webhook'].SteamHex and "\n- **Steam ID:** " .. playerSteamID or "")
                    .. (Config.Moderation.Webhook['webhook'].License and "\n- **License:** " .. playerLicense or "")
                    .. (Config.Moderation.Webhook['webhook'].IP and "\n- **IP:** " .. playerIP or "")
                    .. "\nwas kicked for suspected cheating.\n**Reason:** " .. reason,
                color = 16711680,
            }}
        }
    
        PerformHttpRequest(discordWebhookUrl, function(err, text, headers)
        end, 'POST', json.encode(discordMessage), { ['Content-Type'] = 'application/json' })
    end)

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
    if resource == 'vulcan-ac' or resource == GetCurrentResourceName() then
        zapsupdatee()
    else 
        print("[ALERT!!! Please rename your resource to vulcan-ac") -- Please do not edit this is how I keep track of how many servers use it.
    end
end)
