-- https://forum.cfx.re/t/server-event-protector-2-lines-to-use/905048
local eventPrefix = GetCurrentResourceName() .. ':'
local events = {}

if IsDuplicityVersion() then
    local registerServerEvent, registerNetEvent, addEventHandler = RegisterServerEvent, RegisterNetEvent, AddEventHandler

    function RegisterNetEvent(event)
        if not events[event] then
            local code = math.random(0xdeadbea7)
            events[event] = code

            print(string.format('resource event %s has a security key of %s', event, code))
        end

        return registerNetEvent(event)
    end

    RegisterServerEvent = RegisterNetEvent

    local exceptions = {}

    function AddEventHandler(event, func)
        if events[event] then
            return addEventHandler(event, function(code, ...)
                if code ~= events[event] then
                    if exceptions[source] and code == 1 then
                        exceptions[source] = nil
                    else
                        DropPlayer('')
                        print('🐧 [Vulcan AC]  event triggered via executor or lua mod menu: ' .. event)
                        DropPlayer(source, "🐧 [Vulcan AC] Triggering Event: " .. event)
                        return
                    end
                end

                return func(...)
            end)
        end

        return addEventHandler(event, func)
    end

    registerNetEvent(eventPrefix .. 'ready')
    addEventHandler(eventPrefix .. 'ready', function()
        exceptions[source] = true
        TriggerClientEvent(eventPrefix .. 'recv', source, events)
    end)
else
    local triggerServerEvent = TriggerServerEvent

    RegisterNetEvent(eventPrefix .. 'recv')
    AddEventHandler(eventPrefix .. 'recv', function(_events)
        if #events == 0 then
            events = _events
        else
            while true do
            end
        end
    end)

    function TriggerServerEvent(event, ...)
        if #events == 0 or not events[event] then
            events = {}
            triggerServerEvent(eventPrefix .. 'ready')
        end

        return triggerServerEvent(event, events[event] or 1, ...)
    end
end
