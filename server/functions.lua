RegisterNetEvent('zaps:kick')
AddEventHandler('zaps:kick', function(reason)
    DropPlayer(source, reason)
end)

