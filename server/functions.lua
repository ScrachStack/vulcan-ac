RegisterNetEvent('zaps:ban')
AddEventHandler('zaps:ban', function(reason, expiry)
        -- ban  logic 
    DropPlayer(source, "🐧[VulcanAC] Banned Reason: ".. reason .. " Ban Expires: ") 
end)



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
    if resource == GetCurrentResourceName() then
        zapsupdatee()
            print(" 🐧 [Vulcan AC] Make sure to run vac:install from the console to setup event tampering")
    end
end)
-- For client side perm checks
RegisterServerEvent("zaps:check")
AddEventHandler("zaps:check", function(permission)
    local source = source
    local hasPermission = IsPlayerAceAllowed(source, permission)
    TriggerClientEvent("zaps:Result", source, hasPermission)
end)

local function isSharedScriptAlreadyAdded(filePath)
    local file, err = io.open(filePath, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return content:find("shared_script '@vulcan-ac/module/shared.lua'") ~= nil
    else
        print("Error opening: " .. err)
        return false
    end
end

local function addSharedScript(filePath)
    if not isSharedScriptAlreadyAdded(filePath) then
        local file, err = io.open(filePath, "a")
        if file then
            file:write("\nshared_script '@vulcan-ac/module/shared.lua'\n")
            file:close()
            print("Added shared_script to: " .. filePath)
        else
            print("Error opening: " .. err)
        end
    else
        print("Shared script is already added to: " .. filePath)
    end
end

local function processResources(directory)
    local files = io.popen('dir "' .. directory .. '" /b'):read('*a')
    for fileName in files:gmatch("[^\r\n]+") do
        local filePath = directory .. "\\" .. fileName
        if fileName:lower() == "fxmanifest.lua" then
            addSharedScript(filePath)
        end
    end
end


RegisterCommand("vac:install", function(source, args, rawCommand)
    local isConsole = source == 0
    if isConsole then
        local currentDirectory = GetResourcePath(GetCurrentResourceName())
        local resourcesDirectory = currentDirectory:gsub("\\[^\\]+$", "") 
        processResources(resourcesDirectory)
    else
        print("This command can only be used from the server console.")
    end
end, false)
