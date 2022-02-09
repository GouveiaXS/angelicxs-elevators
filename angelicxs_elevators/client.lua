ESX = nil
QBCore = nil
PlayerJob = nil
PlayerGrade = nil


Citizen.CreateThread(function()
	if Config.UseESX then
		
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(0)
		

		while not ESX.IsPlayerLoaded() do
			Wait(100)
		end

		local playerData = ESX.GetPlayerData()
		PlayerJob = playerData.job.name
		PlayerGrade = playerData.job.grade

	elseif Config.UseQBCore then

		QBCore = exports["qb-core"]:GetCoreObject()

		local playerData = QBCore.Functions.GetPlayerData()
		PlayerJob = playerData.job.name
		PlayerGrade = playerData.job.grade
	end
end)

RegisterNetEvent("esx:setJob", function(job)
	PlayerJob = job.name
	PlayerGrade = job.grade
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(job)
	PlayerJob = job.name
	PlayerGrade = job.grade
end)


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
				distance = 1.5 
			})
		end
	end
end)

RegisterNetEvent("angelicxs_elevator:showFloors", function(data)
	local elevator = {}
	for index, floor in pairs(Config.Elevators[data.elevator]) do
		table.insert(elevator, {
			header = floor.level,
			context = floor.label,
			disabled = index == data.level,
			event = "angelicxs_elevator:movement",
			args = { floor }
		})
	end
	TriggerEvent("nh-context:createMenu", elevator)
end)

RegisterNetEvent("angelicxs_elevator:movement", function(data)
	if hasRequiredJob(floor.jobs) then
		local ped = PlayerPedId()
		DoScreenFadeOut(1500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		RequestCollisionAtCoord(floor.coords.x, floor.coords.y, floor.coords.z)
		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(0)
		end
		SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z, false, false, false, false)
		SetEntityHeading(ped, floor.heading and floor.heading or 0.0)
		Wait(3000)
		DoScreenFadeIn(1500)
	else
		-- TriggerEvent("angelicxs_elevator:notify", "You don't have clearance for this floor!", "error")
		print("No Work")
	end
end)

RegisterNetEvent("angelicxs_elevator:notify", function(message, type)
	if Config.UseMythicNotify then
		exports.mythic_notify:SendAlert(type, message, 4000)
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