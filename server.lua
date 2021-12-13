--[[ Gets the ESX library ]]--
ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('i:PoliceOnDutyShop', function(source, cb)
    local police = 0
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer.job.name == nil then
                elseif xPlayer.job.name == 'police' then
                    police = police +1
            end
        end
        cb(police)
end)

RegisterServerEvent('Infram:RobberyWin')
AddEventHandler('Infram:RobberyWin', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    --todo
    --xPlayer.addMoney(math.random(18000,20000))
end)
