Config = {}

RegisterNetEvent('angelicxs_elevator:notify')
AddEventHandler('angelicxs_elevator:notify', function(type, message)    
    
-- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    exports.mythic_notify:SendAlert(type, message, 4000)

end)

--[[ USAGE DETAILS

-- Utilizes the following dependencies:
qtarget
nh-context
nh-keyboard
These can easily be swapped out if you know what you are doing.


Copy the below table and replace details as required.
For Config.VPDMainElevator change VPDMainElevator to your prefered name. Will be needed in client side.
coords = enter vector3 coords of center of elevator
heading = this wll be the direction facting out of the elevator
level = What floor are they going to
detail = what is on that floor
jobrestriction = name of jobs allowed to access that floor. To allow ANYONE access to that floor put nil on first jobrestriction and leave others as ''. You can have up to 4 jobs per floor.

Additional requirements detailed in client side.

Ensure that you increase the table number sequentially. If you do not do so (example have two lines with [1] it will only allow the second line with [1] to work)

]]

Config.VPDMainElevator = {

    [0] = {coords = vector3(-1096.22, -850.763, 4.80), heading = 36.8,
    level = 'Floor -1', detail = 'Detention Cells & Interrogation', jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    [1] = {coords = vector3(-1096.22, -850.763, 10.20), heading = 36.8,
    level = 'Floor -2', detail = 'Crime Lab & Evidence Rooms',jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    [2] = {coords = vector3(-1096.22, -850.763, 13.70), heading = 36.8,
    level = 'Floor -3', detail = 'Garage & Armory', jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    [3] = {coords = vector3(-1096.22, -850.763, 19.00), heading = 36.8,
    level = 'Floor 1', detail = 'Main Hall', jobrestriction = nil,
    jobrestriction2 = 'ambulance',jobrestriction3 = '',jobrestriction3 = '',},

    [4] = {coords = vector3(-1096.22, -850.763, 23.00), heading = 36.8,
    level = 'Floor 2', detail = 'Cafe', jobrestriction = nil,
    jobrestriction2 = 'ambulance',jobrestriction3 = '',jobrestriction3 = '',},

    [5] = {coords = vector3(-1096.22, -850.763, 27.00), heading = 36.8,
    level = 'Floor 3', detail = 'Division Offices & Briefing Room', jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    [6] = {coords = vector3(-1096.22, -850.763, 30.80), heading = 36.8,
    level = 'Floor 4', detail = 'Operations Center', jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    [7] = {coords = vector3(-1096.22, -850.763, 34.40), heading = 36.8,
    level = 'Floor 5', detail = 'Detective Bureau',jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    [8] = {coords = vector3(-1096.22, -850.763, 38.20), heading = 36.8,
    level = 'Floor 6', detail = 'Roof Access',jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},

    }

Config.VPDPublicElevator = {

    [9] = {coords = vector3(-1066.05, -833.71, 4.88), heading = 36.1,
    level = 'Floor -1', detail = 'Detention Cells & Interrogation', jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = 'hclaw',},
    
    [10] = {coords = vector3(-1066.05, -833.71, 10.27282), heading = 36.1,
    level = 'Floor -2', detail = 'Crime Lab & Evidence Rooms',jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},
    
    [11] = {coords = vector3(-1066.05, -833.71, 13.69069), heading = 36.1,
    level = 'Floor -3', detail = 'Garage & Armory', jobrestriction = 'police',
    jobrestriction2 = 'ambulance',jobrestriction3 = 'sheriff',jobrestriction3 = '',},
    
    [12] = {coords = vector3(-1066.05, -833.713, 18.9964), heading = 36.1,
    level = 'Floor 1', detail = 'Main Hall', jobrestriction = nil,
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},
    
    [13] = {coords = vector3(-1066.05, -833.71, 23.03471), heading = 36.1,
    level = 'Floor 2', detail = 'UNDER RENOVATIONS', jobrestriction = '',
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},
    
    [14] = {coords = vector3(-1066.05, -833.71, 26.82318), heading = 36.1,
    level = 'Floor 3', detail = 'Division Offices', jobrestriction = nil,
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},
    
        
    }

Config.SkybarElevatorSouth = {

    [15] = {coords = vector3(315.49, -929.32, 29.47), heading = 176.67,
    level = 'Skybar Ground', detail = 'Street Level for Skybar', jobrestriction = nil,
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},

    [16] = {coords = vector3(315.49, -929.32, 52.81), heading = 176.67,
    level = 'Skybar 5th Floor', detail = 'Bar Level for Skybar',jobrestriction = nil,
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},

    }

Config.SkybarElevatorNorth = {

    [17] = {coords = vector3(309.81, -929.05, 29.47), heading = 176.67,
    level = 'Skybar Ground', detail = 'Street Level for Skybar', jobrestriction = nil,
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},

    [18] = {coords = vector3(309.81, -929.05, 52.81), heading = 176.67,
    level = 'Skybar 5th Floor', detail = 'Bar Level for Skybar',jobrestriction = nil,
    jobrestriction2 = '',jobrestriction3 = '',jobrestriction3 = '',},

    }