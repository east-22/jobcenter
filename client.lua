-- if the code is messy, sorry. third script ive ever made.

-- you can add more jobs if you want to and know how to.
local jobmenu = {
    {label = "Taxi", value = "taxijob"}, 
    {label = "Trucker", value = "truckerjob"}, 
}
local Coords = vector3(-260.22, -965.54, 31.22)
local Coords2 = vector4(-260.22, -965.54, 30.22, 97.64)
local Radius = 1.5

local config = {}
config.npcModel = "a_m_m_prolhost_01"
config.blipEnabled = true
config.blipSprite = 408
config.blipColor = 11

-- NPC & blip
Citizen.CreateThread(function()
	RequestModel(GetHashKey(config.npcModel))
	while not HasModelLoaded(GetHashKey(config.npcModel)) do
		Wait(1)
	end
	RequestAnimDict("mini@strip_club@idles@bouncer@base")
	while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
		Wait(1)
	end
	config.npc = CreatePed(4, config.npcModel, Coords2, false, true)
	PlaceObjectOnGroundProperly(config.npc, true)
    FreezeEntityPosition(config.npc, true)
    SetEntityInvincible(config.npc, true)
    SetBlockingOfNonTemporaryEvents(config.npc, true)
    TaskPlayAnim(config.npc,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)

	Citizen.CreateThread(function()
		if config.blipEnabled then
			local blip = AddBlipForCoord(Coords)
			SetBlipSprite(blip, config.blipSprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.7)
			SetBlipColour(blip, config.blipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Job Center')
			EndTextCommandSetBlipName(blip)
		end
	end)
end)

function OpenMenu()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, Coords.x, Coords.y, Coords.z, true)

        if distance <= Radius then
            DrawText3D(Coords.x, Coords.y, Coords.z + 1.0, "Press [~g~E~s~] to open the job center")

            -- Replace the control with the key you want to use
            if IsControlJustPressed(1, 51) then -- E
                JobMenu()
            end
        end
    end
end

Citizen.CreateThread(OpenMenu)

function JobMenu()
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "JobMenu", {
        title = "Job Center", -- can change
        align = 'left-center', -- can change
        elements = jobmenu
    }, function (data, menu)

        if data.current.value == "taxijob" then
            taxi()
        elseif data.current.value == "truckerjob" then
            trucker()
        end
    end, function (data, menu)
        menu.close()
    end)
end

function taxi() -- set taxi job
    TriggerServerEvent('esx:setJob', {name = 'taxi', grade = 0})
end

function trucker() -- set truck job
    TriggerServerEvent('esx:setJob', {name = 'trucker', grade = 0})
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 450
        DrawRect(_x,_y+0.0125, 0.012+ factor, 0.03, 0, 0, 0, 90)
    end
end

-- suggest more ideas in the github! this is just a simple one, and i just want to learn.
