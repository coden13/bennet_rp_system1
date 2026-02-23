ESX = exports["es_extended"]:getSharedObject()
local firstSpawn = true
local cam = nil

local jobMarkers = {
    police = vector3(425.1, -979.5, 30.7),
    fire = vector3(1200.0, -1470.0, 35.0),
    medic = vector3(300.0, -600.0, 43.0),
    crane = vector3(1000.0, -900.0, 35.0)
}

-- Ladebildschirm beim ersten Spawn
AddEventHandler('playerSpawned', function()
    if firstSpawn then
        firstSpawn = false
        SetNuiFocus(true,true)
        SendNUIMessage({action="open"})
    end
end)

-- Charakter erstellen
RegisterNUICallback("createCharacter", function(data, cb)
    TriggerServerEvent("bennet:saveCharacter", data)
    SetNuiFocus(false,false)
    cb("ok")
    TriggerEvent('bennet:openSkinMenu')
end)

-- Skin Menü
RegisterNetEvent('bennet:openSkinMenu')
AddEventHandler('bennet:openSkinMenu', function()
    local playerPed = PlayerPedId()
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local pos = GetEntityCoords(playerPed)
    SetCamCoord(cam, pos.x+2.0, pos.y+2.0, pos.z+1.0)
    PointCamAtEntity(cam, playerPed)
    SetCamActive(cam,true)
    RenderScriptCams(true,false,0,true,true)

    TriggerEvent('esx_skin:openSaveableMenu', function()
        SetNuiFocus(true,true)
    end,{
        allow_change_model = true,
        allow_hair = true,
        allow_clothes = true,
        allow_accessories = true,
        allow_facepaint = true
    })
end)

-- Job Marker Interaktion
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        for job,pos in pairs(jobMarkers) do
            local dist = #(coords - pos)
            if dist < 10 then
                DrawMarker(1, pos.x,pos.y,pos.z-1,0,0,0,0,0,0,1.5,1.5,1.0,0,0,255,100,false,true,2,true)
            end
            if dist < 1.5 then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um dich für "..job.." zu bewerben")
                if IsControlJustReleased(0,38) then
                    TriggerServerEvent("bennet:applyJob", job)
                end
            end
        end
    end
end)

-- Automatische Uniform beim Job
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        local outfit = {}
        if job.name == "police" then
            outfit = {tshirt_1=58, torso_1=55, pants_1=25, shoes_1=25}
        elseif job.name == "fire" then
            outfit = {tshirt_1=15, torso_1=11, pants_1=31, shoes_1=25}
        elseif job.name == "medic" then
            outfit = {tshirt_1=15, torso_1=11, pants_1=31, shoes_1=25}
        elseif job.name == "crane" then
            outfit = {tshirt_1=15, torso_1=5, pants_1=21, shoes_1=26}
        end
        TriggerEvent('esx_skin:loadClothes', skin, outfit)
    end)
end)
