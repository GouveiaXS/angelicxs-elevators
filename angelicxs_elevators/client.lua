ESX = nil
QBCore = nil
PlayerJob = nil
PlayerGrade = nil

-- if Config.UseESX then

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(0)
	end

	while not ESX.IsPlayerLoaded() do
		Wait(100)
	end

	local playerData = ESX.GetPlayerData()
	PlayerJob = playerData.job.name
	PlayerGrade = playerData.job.grade
end)

RegisterNetEvent("esx:setJob", function(job)
	PlayerJob = job.name
	PlayerGrade = job.grade
end)

-- elseif Config.UseQBCore then

-- 	QBCore = exports["qb-core"]:GetCoreObject()

-- 	local playerData = QBCore.Functions.GetPlayerData()
-- 	PlayerJob = playerData.job.name
-- 	PlayerGrade = playerData.job.grade

-- 	RegisterNetEvent("QBCore:Client:OnJobUpdate", function(job)
-- 		PlayerJob = job.name
-- 		PlayerGrade = job.grade
-- 	end)

-- end

CreateThread(function()
	for elevatorName, elevatorFloors in pairs(Config.Elevators) do
		for index, floor in pairs(elevatorFloors) do
			exports["qtarget"]:AddBoxZone(elevatorName .. index, floor.coords, 5, 4, {
				name = elevatorName,
				heading = floor.heading,
				debugPoly = false,
				minZ = floor.coords.z - 1.5,
				maxZ = floor.coords.z + 1.5
			},
			{
				options = {
					{
						event = "angelicxs_elevator:showFloors",
						icon = "fas fa-hand-point-up",
						label = "Use Elevator From " .. floor.level,
						elevator = elevatorName,
						level = floor.level
					},
				},
				distance = 5.5 
			})
		end
	end
end)

RegisterNetEvent("angelicxs_elevator:showFloors", function(data)
	local elevator = {}
	local levels = floor
	for index, floor in pairs(Config.Elevators[data.elevator]) do
		if index ~= data.index then
			table.insert(elevator, {
				id = index,
				header = floor.level,
				txt = floor.label,
				disabled = index,
				params = {
					event = "angelicxs_elevator:movement",
					args = {
						floor = floor
					}
				}
			})
		end
	end
	TriggerEvent("nh-context:createMenu", elevator)
end)

RegisterNetEvent("angelicxs_elevator:movement", function(data)
	if hasRequiredJob(data.floor.jobs) then
		local ped = PlayerPedId()
		DoScreenFadeOut(1500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		RequestCollisionAtCoord(data.floor.coords.x, data.floor.coords.y, data.floor.coords.z)
		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(0)
		end
		SetEntityCoords(ped, data.floor.coords.x, data.floor.coords.y, data.floor.coords.z, false, false, false, false)
		SetEntityHeading(ped, data.floor.heading and data.floor.heading or 0.0)
		Wait(3000)
		DoScreenFadeIn(1500)
	else
		-- TriggerEvent("angelicxs_elevator:notify", "You don't have clearance for this floor!", "error")
		print("No Work")
	end
end)

RegisterNetEvent("angelicxs_elevator:notify", function(message, type)
	if Config.UseMythicNotify then
		exports.mythic_notify:DoLongHudText(type, message, 4000)
	elseif Config.UseESX then
		ESX.ShowNotification(message)
	elseif Config.UseQBCore then
		QBCore.Functions.Notify(message, type)
	end
end)

function hasRequiredJob(jobs)
	if next(jobs) then
		for jobName, gradeLevel in pairs(jobs) do
			if PlayerJob == jobName and PlayerGrade == gradeLevel then
				return true
			end
		end
		return false
	end
	return true
end