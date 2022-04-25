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
		 
		CreateThread(function()
			while true do
				PlayerData = QBCore.Functions.GetPlayerData()
				if PlayerData.citizenid ~= nil then
					PlayerJob = PlayerData.job.name
					PlayerGrade = PlayerData.job.grade.level
					break
				end
				Wait(100)
			end
		end)

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

	if Config.Notify.enabled then
		local wasNotified = false
		while true do
			local sleep = 3000
			local nearElevator = false
			local playerCoords = GetEntityCoords(PlayerPedId())
			for elevatorName, elevatorFloors in pairs(Config.Elevators) do
				for index, floor in pairs(elevatorFloors) do
					local distance = #(playerCoords - floor.coords)
					if distance <= 10.0 then
						sleep = 10
						if distance <= Config.Notify.distance then
							nearElevator = true
							break
						end
					end
				end
			end
			if nearElevator then
				if not wasNotified then
					NotifyHint()
					wasNotified = true
				end
			else
				wasNotified = false
			end
			Wait(sleep)
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
	local hasJob, hasItem = false, false
	if floor.jobs ~= nil and next(floor.jobs) then
		for jobName, gradeLevel in pairs(floor.jobs) do
			if PlayerJob == jobName and PlayerGrade >= gradeLevel then
				hasJob = true
				break
			end
		end
	end
	if floor.items ~= nil and next(floor.items) then
		if Config.UseESX then
			for i = 1, #floor.items, 1 do
				for k, v in ipairs(PlayerData.inventory) do
					if v.name == floor.items[i] and v.count > 0 then
						hasItem = true
						break
					end
				end
			end
		elseif Config.UseQBCore then
			for i = 1, #floor.items, 1 do
				for slot, item in pairs(PlayerData.items) do
					if PlayerData.items[slot] then
						if item.name == floor.items[i] then
							hasItem = true
							break
						end
					end
				end
			end
		end
	end
	if floor.jobs == nil and floor.items == nil then return false end 
	return floor.jobAndItem and not (hasJob and hasItem) or not (hasJob or hasItem)
end

function NotifyHint()
	AddTextEntry('elevatorHelp', Config.Notify.message)
	BeginTextCommandDisplayHelp('elevatorHelp')
	EndTextCommandDisplayHelp(0, false, true, -1)
end
