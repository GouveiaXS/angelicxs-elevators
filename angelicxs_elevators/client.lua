ESX = nil
QBCore = nil
PlayerData = nil
PlayerJob = nil
PlayerGrade = nil

CreateThread(function()
	if Config.UseESX then
		while ESX == nil do
			TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
			Wait(0)
		end
	
		while not ESX.IsPlayerLoaded() do
			Wait(100)
		end
	
		PlayerData = ESX.GetPlayerData()
		PlayerJob = PlayerData.job.name
		PlayerGrade = PlayerData.job.grade

		RegisterNetEvent("esx:setJob", function(job)
			PlayerJob = job.name
			PlayerGrade = job.grade
		end)

	elseif Config.UseQBCore then

		QBCore = exports["qb-core"]:GetCoreObject()

		PlayerData = QBCore.Functions.GetPlayerData()
		PlayerJob = PlayerData.job.name
		PlayerGrade = PlayerData.job.grade.level

		RegisterNetEvent("QBCore:Client:OnJobUpdate", function(job)
			PlayerJob = job.name
			PlayerGrade = job.grade.level
		end)
	end
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
						level = index
					},
				},
				distance = 1.5 
			})
		end
	end
end)

RegisterNetEvent("angelicxs_elevator:showFloors", function(data)
	local elevator = {}
	if Config.UseESX then
		PlayerData = ESX.GetPlayerData()
	elseif Config.UseQBCore then
		PlayerData = QBCore.Functions.GetPlayerData()
	end	
	for index, floor in pairs(Config.Elevators[data.elevator]) do
		table.insert(elevator, {
			header = floor.level,
			context = floor.label,
			disabled = isDisabled(index, floor, data),
			event = "angelicxs_elevator:movement",
			args = { floor }
		})
	end
	TriggerEvent("nh-context:createMenu", elevator)
end)

RegisterNetEvent("angelicxs_elevator:movement", function(floor)
	local ped = PlayerPedId()
	DoScreenFadeOut(1500)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	RequestCollisionAtCoord(floor.coords.x, floor.coords.y, floor.coords.z)
	while not HasCollisionLoadedAroundEntity(ped) do
		Wait(0)
	end
	SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z, false, false, false, false)
	SetEntityHeading(ped, floor.heading and floor.heading or 0.0)
	Wait(3000)
	DoScreenFadeIn(1500)
end)

function isDisabled(index, floor, data)
	if index == data.level then return true end
	local hasJob = floor.jobs == nil or next(floor.jobs)
	local hasItem = next(floor.items) or true
	if hasJob then
		for jobName, gradeLevel in pairs(floor.jobs) do
			if PlayerJob == jobName and PlayerGrade >= gradeLevel then
				hasJob = false
				break
			end
		end
	end
	
	if hasItem and (floor.jobAndItem or hasJob) then
		if Config.UseESX then
			for i = 1, #floor.items, 1 do
				for k, v in ipairs(PlayerData.inventory) do
					if v.name == floor.items[i] and v.count > 0 then
						hasItem = false
						break
					end
				end
			end
		elseif Config.UseQBCore then
			--hasItem = QBCore.Functions.HasItem(floor.items)
			for i = 1, #floor.items, 1 do
				for slot, item in pairs(PlayerData.items) do
					if PlayerData.items[slot] then
						if item.name == floor.items[i] then
							hasItem = false
							break
						end
					end
				end
			end
		end
	end
	
	if floor.jobAndItem then
		if not hasJob and not hasItem then
			return false
		else
			return true
		end
	end
	if not hasJob or not hasItem then
		return false
	else
		return true
	end
end
