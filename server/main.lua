local fxCounts = {}  

local function isInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
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
if IsAceAllowed(sender, Config.AntiFX.ACEPermission) then 
    if not isInTable(Config.AntiFX.fxWhitelist, eventName) then
        fxCounts[sender] = (fxCounts[sender] or 0) + 1

        if fxCounts[sender] > Config.AntiFX.limit then
            CancelEvent()
TriggerEvent('zaps:kick', Config.AntiFX.Message)
        end
    end
end
end)
end

    local entityCreationCounts = {}

    if Config.AntiEntityTamper.Enabled then 
AddEventHandler('entityCreating', function(entity)
    local _src = NetworkGetEntityOwner(entity)
    if IsAceAllowed(source, Config.AntiEntityTamper.ACEPermission) then 
    if not entityCreationCounts[_src] then
        entityCreationCounts[_src] = { count = 0, timer = nil }
    end
    local data = Config.AntiEntityTamper.EntityCreation_Limit[_src]
    data.count = data.count + 1
    if data.count > ENTITY_CREATION_LIMIT then
            CancelEvent()
 TriggerEvent('zaps:kick', Config.AntiEntityTamper.Message)
        end
    if not data.timer then
        data.timer = SetTimer(function()
            data.count = 0
            data.timer = nil
        end, TIME_WINDOW, 1)
    end
end
end)
end
if Config.BlacklistedEvents.Enabled then
    for _, event in pairs(Config.BlacklistedEvents.Events) do
        if event.type == 'server' then
            AddEventHandler(event.Name, function()
                if not hasBypassPermission(source, Config.BlacklistedEvents.ACEPermission) then
                    CancelEvent()
                    TriggerEvent('zaps:kick', Config.BlacklistedEvents.Message)
                end
            end)
        end
    end
end
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
        TriggerEvent('zaps:kick', "Blocked Explosion Type: "..exp.explosionType)
        return
    end
    explosionsSpawned[sender] = (explosionsSpawned[sender] or 0) + 1
    if explosionsSpawned[sender] > Config.ExplosionEvent.MassExplosionsLimit then
        TriggerEvent('zaps:kick', "Mass explosions detected: "..explosionsSpawned[sender])
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
