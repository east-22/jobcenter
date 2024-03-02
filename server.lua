RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.setJob(job.name, job.grade)
        TriggerClientEvent('okokNotify:Alert', source, 'Job Center', 'You have been hired to a new job!', 3000, 'success', true) -- use your own notification. one is below
        --TriggerClientEvent('chatMessage', source, 'JOB CENTER', {255,0,0}, "You have been hired to a new job!") 
    end
end)
