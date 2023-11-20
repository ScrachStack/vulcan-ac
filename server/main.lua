local fxCounts = {}  

local function isInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end
local function inTable(table, item)
    for k,v in pairs(table) do
        if v == item then return k end
    end
    return false
end
local function tableToString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            v = tableToString(v)
        else
            v = tostring(v)
        end
        result = result .. string.format("[%s] = %s, ", tostring(k), v)
    end
    if result ~= "{" then
        result = result:sub(1, -3) 
    end
    return result .. "}"
end
if Config.AntiFX.Enabled then 
AddEventHandler('ptFxEvent', function(sender, eventName, eventData)
    local eventDataString = (type(eventData) == "table") and tableToString(eventData) or tostring(eventData)
if IsPlayerAceAllowed(sender, Config.AntiFX.ACEPermission) then 
    if not isInTable(Config.AntiFX.fxWhitelist, eventName) then
        fxCounts[sender] = (fxCounts[sender] or 0) + 1

        if fxCounts[sender] > Config.AntiFX.limit then
            CancelEvent()
TriggerEvent('zaps:kick', Config.AntiFX.Message)
TriggerEvent('logKickToDiscordEvent', Config.AntiFX.Message)
        end
    end
end
end)
end
local entityCreationCounts = {}
local entitiesSpawned = {}
if Config.AntiEntityTamper.Enabled then 
    AddEventHandler('entityCreating', function(entity)
        local _src = NetworkGetEntityOwner(entity)
        local _entitytype = GetEntityPopulationType(entity)
        local model = GetEntityModel(entity)
        if not IsPlayerAceAllowed(_src, Config.AntiEntityTamper.ACEPermission) then 
            if _src == nil then
                CancelEvent()
                return
            end
            if _entitytype == 0 then
                if not inTable(Config.AntiEntityTamper.WhitelistedModels, model) then
                    if model ~= 0 and model ~= 225514697 then
                    TriggerEvent('logKickToDiscordEvent', _src, Config.AntiEntityTamper.Message)
                        DropPlayer(_src, "🐧[VulcanAC] Kicked Reason: " .. Config.AntiEntityTamper.Message)
                        CancelEvent()
                        entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                        if entitiesSpawned[_src] > 10 then
                            TriggerEvent('logKickToDiscordEvent', _src, Config.AntiEntityTamper.Message)
                            DropPlayer(_src, "🐧[VulcanAC] Kicked Reason: " .. Config.AntiEntityTamper.Message)
                            CancelEvent()
                            return
                        end
                    end
                end
            end
        end
    end)
end

if Config.BlacklistedEvents.Enabled then
    for _, event in pairs(Config.BlacklistedEvents.Events) do
        if event.type == 'server' then
            AddEventHandler(event.Name, function()
                if not IsPlayerAceAllowed(source, Config.BlacklistedEvents.ACEPermission) then
                    CancelEvent()
                    TriggerEvent('zaps:kick', Config.BlacklistedEvents.Message)
                    TriggerEvent('logKickToDiscordEvent', Config.BlacklistedEvents.Message)
                end
            end)
        end
    end
end
local explosionsSpawned = {}
AddEventHandler("explosionEvent", function(sender, exp)
    if not Config.ExplosionEvent.Enabled or exp.damageScale == 0.0 then
        return
    end
 local function isBlacklisted(expType)
    local blacklistedTypes = Config.ExplosionEvent.RestrictCertainTypes
    return inTable(blacklistedTypes, expType) ~= false
end
    if isBlacklisted(exp.explosionType) then
        CancelEvent()
        TriggerEvent('logKickToDiscordEvent', sender, "Blocked Explosion Type: "..exp.explosionType)
        DropPlayer(sender, "🐧[VulcanAC] Kicked Reason: " .. Config.ExplosionEvent.Message)
        return
    end
    explosionsSpawned[sender] = (explosionsSpawned[sender] or 0) + 1
    if explosionsSpawned[sender] > 5 then
        TriggerEvent('logKickToDiscordEvent', sender, "Mass explosions detected: "..explosionsSpawned[sender])
        DropPlayer(sender, "🐧[VulcanAC] Kicked Reason: " .. Config.ExplosionEvent.Message)
        CancelEvent()
        return
    end
    CancelEvent()
end)
    AddEventHandler("chatMessage", function(source, name, message)
    if Config.BlacklistedWords.Enabled then
        for _, word in pairs(Config.BlacklistedWords.Words) do
            if string.match(message:lower(), "%f[%a]"..word:lower().."%f[%A]") then
                CancelEvent()
                TriggerEvent('logKickToDiscordEvent', source, "Tried to say a blacklisted word: " .. word, "Full Message", message)
                TriggerEvent('zaps:kick', "Tried to say a blacklisted word: " .. word, "Full Message", message)
                TriggerClientEvent('chat:clear', -1)
                return
            end
        end
    end
    if Config.AntiFakeChatMessages.Enabled then
        local _playername = GetPlayerName(source)
        if name ~= _playername then
            CancelEvent()
            TriggerEvent('zaps:kick', "Tried to fake a chat message: " .. message)
            return
        end
    end
end)
if Config.SuperJump.Enabled then
    CreateThread(function()
        while true do
            Wait(1500)
            local players = GetPlayers()
            for i = 1, #players do
                local playerId = players[i]
                if IsPlayerUsingSuperJump(playerId) then
		if IsPlayerAceAllowed(playerId, Config.SuperJump.ACEPermission) then 
                    if Config.Debug then 
                        print('Super jump detected for player: ' .. playerId)
                    end
                    TriggerEvent('logKickToDiscordEvent', playerId, Config.SuperJump.Message)
                    DropPlayer(playerId, Config.SuperJump.Message)
                    break
                end
            end
        end
    end)
end
end
if GetResourceState('es_extended') ~= 'missing' then
    ESX = exports["es_extended"]:getSharedObject()
    local UseEsx = nil
    UseEsx = true
end
if GetResourceState('qb-core') ~= 'missing' then
	local UseQB = nil
	QBCore = exports['qb-core']:GetCoreObject()
    	UseQB = true
end

AddEventHandler("weaponDamageEvent", function(sender, data)
    if UseEsx and Config.Antitaze.Enabled then
        local _src = sender   
        local xPlayer = ESX.GetPlayerFromId(_src)
        if xPlayer ~= nil and not Config.Antitaze.WhitelistedJobs[xPlayer.job.name] and data.weaponType == 911657153 or data.weaponType == joaat(`WEAPON_STUNGUN`) then
            TriggerEvent('logKickToDiscordEvent', GetPlayerName(_src), Config.Antitaze.Message)
            DropPlayer(_src, Config.Antitaze.KickMessage)
            CancelEvent()
        end
    end
end)

AddEventHandler("weaponDamageEvent", function(sender, data)
    if UseQB and Config.Antitaze.Enabled then
        local _src = sender
        local xPlayer = QBCore.Functions.GetPlayer(_src)
        if xPlayer ~= nil and not Config.Antitaze.WhitelistedJobs[xPlayer.job.name] and data.weaponType == 911657153 or data.weaponType == joaat(`WEAPON_STUNGUN`) then
            TriggerEvent('logKickToDiscordEvent', GetPlayerName(_src), Config.Antitaze.Message)
            DropPlayer(_src, Config.Antitaze.KickMessage)
            CancelEvent()
        end
    end
end)
