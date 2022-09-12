# Elevators
Elevator script for FiveM
Please check out other scripts by me on CFX (https://forum.cfx.re/u/angelicxs/activity/topics) or my paid stuff on Tebex (https://angelicxs.tebex.io/)

I wanted to make something to utilize elevators that have open interiors without going into additional UIs for the clients, while also making it easy to add new elevators as needeed. This is the result.

### Dependencies:
 - ESX or QBCore
 - qtarget
 - nh-context

### Usage:
Choose between ESX & QBCore and set an optional help notification in `config.lua`.
```lua
Config.UseESX = true                            -- Use ESX Framework
Config.UseQBCore = false                        -- Use QBCore Framework (Ignored if Config.UseESX = true)

Config.Notify = {
	enabled = true,                         -- Display hint notification?
	distance = 3.0,                         -- Distance from elevator that the hint will show
	message = "Target the elevator to use"  -- Text of the hint notification
}
```
I have provided a few preset elevators to utilize as examples and have heavily commented the config.lua file on how to add additional elevators. Here is one example.
```lua
Config.Elevators = {
	ExampleElevator = {
		{
			coords = vector3(111, 111, 111),
			heading = 0.0,
			level = "Floor 1",
			label = "Upstairs",
			jobs = {
				["police"] = 0,
				["ambulance"] = 0,
				["casino"] = 0
			},
			items = {
				"casino_pass_bronze",
				"casino_pass_silver",
				"casino_pass_gold",
			}
		},
		{
			coords = vector3(222, 222, 222),
			heading = 0.0,
			level = "Floor 0",
			label = "Ground"
		},
	},
}
```
Here is a break down of the table options.

	coords: vector3 coords of center of elevator
	heading: Direction facing out of the elevator
	level: What floor are they going to
	label: What is on that floor
	jobs: [OPTIONAL] Table of job keys that are allowed to access that floor and value of minimum grade of each job
	items: [OPTIONAL] Any items that are required to access that floor (only requires one of the items listed)
	jobAndItem: [OPTIONAL] If true, you must you have a required job AND a required items. If false or nil no items are needed

### Preview:

https://youtu.be/NhtnfgziWSA

### Credits:

 - DrAceMisanthrope
 - Geerdodagr8
 - wasabirobby
 - smokiiee
