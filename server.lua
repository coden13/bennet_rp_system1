ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("bennet:saveCharacter")
AddEventHandler("bennet:saveCharacter", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    print("Charakter erstellt: "..data.firstname.." "..data.lastname.." ("..data.age.." Jahre, "..data.gender..")")
end)

RegisterNetEvent("bennet:applyJob")
AddEventHandler("bennet:applyJob", function(job)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "unemployed" then
        xPlayer.setJob(job,0)
        TriggerClientEvent('esx:showNotification', source, "Du bist jetzt bei "..job.."!")
    else
        TriggerClientEvent('esx:showNotification', source, "Du hast bereits einen Job!")
    end
end)
