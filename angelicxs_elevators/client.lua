ESX = nil

--[[ USAGE DETAILS

Details on what to copy are found as examples here.

TO ADD A NEW ELEVATOR SYSTEM

Copy and paste the following and replace XXXX with the appropriate name from the config:

CreateThread(function()
    for k, v in pairs (Config.XXXX) do
    exports['qtarget']:AddBoxZone(k, v.coords, 4.4, 3.7, {
        name=k,
        heading=v.heading,
        debugPoly=false,
        minZ=v.coords.z-1.5,
        maxZ=v.coords.z+2
    }, {
        options = {
            {
                event = "angelicxs_elevator:XXXX",
                icon = "fas fa-hand-point-up",
                label = 'Use Elevator',
            },

        },
            distance = 1.5 
    })
    end
end)

RegisterNetEvent("angelicxs_elevator:XXXX",function()
    local elevator = {}
    for k, v in pairs (Config.XXXX) do
        table.insert(elevator,
    {
        id = k,
        header = v.level,
        txt = v.detail,
        params = {
            event = "angelicxs_elevator:movement",
            arg1 = {
                location = v.coords,
                face = v.heading,
                job = v.jobrestriction,
                job2 = v.jobrestriction2,
                job3 = v.jobrestriction3,
                job4 = v.jobrestriction4,
            }
        }
    })
    end
    TriggerEvent('nh-context:sendMenu', elevator)
end)    

]]


CreateThread(function()
    while true do
        Wait(1000)
        if ESX ~= nil then
            PlayerData = ESX.GetPlayerData()
            if PlayerData.job ~= nil then
                PlayerJob = PlayerData.job.name
            end
        else
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end
end)

CreateThread(function()
    for k, v in pairs (Config.VPDMainElevator) do
    exports['qtarget']:AddBoxZone(k, v.coords, 5, 4, {
        name=k,
        heading=v.heading,
        debugPoly= false,
        minZ=v.coords.z-1.5,
        maxZ=v.coords.z+1.5
    }, {
        options = {
            {
                event = "angelicxs_elevator:VPDMainElevator",
                icon = "fas fa-hand-point-up",
                label = 'Use Elevator',
            },

        },
            distance = 1.5 
    })
    end
    for k, v in pairs (Config.VPDPublicElevator) do
        exports['qtarget']:AddBoxZone(k, v.coords, 5, 4, {
            name=k,
            heading=v.heading,
            debugPoly= false,
            minZ=v.coords.z-1.5,
            maxZ=v.coords.z+1.5
        }, {
            options = {
                {
                    event = "angelicxs_elevator:VPDPublicElevator",
                    icon = "fas fa-hand-point-up",
                    label = 'Use Elevator',
                },
    
            },
                distance = 1.5 
        })
    end
    for k, v in pairs (Config.SkybarElevatorSouth) do
        exports['qtarget']:AddBoxZone(k, v.coords, 4.4, 3.7, {
            name=k,
            heading=v.heading,
            debugPoly=false,
            minZ=v.coords.z-1.5,
            maxZ=v.coords.z+2
        }, {
            options = {
                {
                    event = "angelicxs_elevator:SkybarElevatorSouth",
                    icon = "fas fa-hand-point-up",
                    label = 'Use Elevator',
                },
    
            },
                distance = 1.5 
        })
    end
    for k, v in pairs (Config.SkybarElevatorNorth) do
        exports['qtarget']:AddBoxZone(k, v.coords, 4.4, 3.7, {
            name=k,
            heading=v.heading,
            debugPoly=false,
            minZ=v.coords.z-1.5,
            maxZ=v.coords.z+2
        }, {
            options = {
                {
                    event = "angelicxs_elevator:SkybarElevatorNorth",
                    icon = "fas fa-hand-point-up",
                    label = 'Use Elevator',
                },
    
            },
                distance = 1.5 
        })
    end
end)

RegisterNetEvent('angelicxs_elevator:movement', function(data)
    local newcoords = data.location
    local heading = data.face
    local floor = data.header
    local info = data.txt
    local job = data.job
    local job2 = data.job2
    local job3 = data.job3
    local job4 = data.job4
    if job ~= nil then
        if PlayerJob == job or PlayerJob == job2 or PlayerJob == job3 or PlayerJob == job4 then
            Wait(0)
            ElevatorMovement(newcoords,heading,floor,info)
        elseif PlayerJob ~= job then
            TriggerEvent('angelicxs_elevator:notify','error',"You do not have clearance to go to this floor!")
        end
    else
        Wait(0)
        ElevatorMovement(newcoords,heading,floor,info)
    end
end)

function ElevatorMovement(coords,heading,floor,info)
    DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Wait(10)
        end
    ESX.Game.Teleport(PlayerPedId(),coords)
--    SetEntityCoords(PlayerPedId(),coords)
    if heading then
        SetEntityHeading(PlayerPedId(), heading)
    end
    DoScreenFadeIn(800)
 --   TriggerEvent('angelicxs_elevator:notify', 'inform', "You have taken the elevator to " .. floor .. ". The " .. info .. " can be found here.")
end

RegisterNetEvent("angelicxs_elevator:VPDMainElevator",function()
    local elevator = {}
    for k, v in pairs (Config.VPDMainElevator) do
        table.insert(elevator,
    {
        id = k,
        header = v.level,
        txt = v.detail,
        params = {
            event = "angelicxs_elevator:movement",
            arg1 = {
                location = v.coords,
                face = v.heading,
                job = v.jobrestriction,
                job2 = v.jobrestriction2,
                job3 = v.jobrestriction3,
                job4 = v.jobrestriction4,
            }
        }
    })
    end
    TriggerEvent('nh-context:sendMenu', elevator)
end)   

RegisterNetEvent("angelicxs_elevator:VPDPublicElevator",function()
    local elevator = {}
    for k, v in pairs (Config.VPDPublicElevator) do
        table.insert(elevator,
    {
        id = k,
        header = v.level,
        txt = v.detail,
        params = {
            event = "angelicxs_elevator:movement",
            arg1 = {
                location = v.coords,
                face = v.heading,
                job = v.jobrestriction,
                job2 = v.jobrestriction2,
                job3 = v.jobrestriction3,
                job4 = v.jobrestriction4,
            }
        }
    })
    end
    TriggerEvent('nh-context:sendMenu', elevator)
end) 

RegisterNetEvent("angelicxs_elevator:SkybarElevatorSouth",function()
    local elevator = {}
    for k, v in pairs (Config.SkybarElevatorSouth) do
        table.insert(elevator,
    {
        id = k,
        header = v.level,
        txt = v.detail,
        params = {
            event = "angelicxs_elevator:movement",
            arg1 = {
                location = v.coords,
                face = v.heading,
                job = v.jobrestriction,
                job2 = v.jobrestriction2,
                job3 = v.jobrestriction3,
                job4 = v.jobrestriction4,
            }
        }
    })
    end
    TriggerEvent('nh-context:sendMenu', elevator)
end)    

RegisterNetEvent("angelicxs_elevator:SkybarElevatorNorth",function()
    local elevator = {}
    for k, v in pairs (Config.SkybarElevatorNorth) do
        table.insert(elevator,
    {
        id = k,
        header = v.level,
        txt = v.detail,
        params = {
            event = "angelicxs_elevator:movement",
            arg1 = {
                location = v.coords,
                face = v.heading,
                job = v.jobrestriction,
                job2 = v.jobrestriction2,
                job3 = v.jobrestriction3,
                job4 = v.jobrestriction4,
            }
        }
    })
    end
    TriggerEvent('nh-context:sendMenu', elevator)
end)    