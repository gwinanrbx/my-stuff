--// variables

local players = game:GetService('Players')
local player = players.LocalPlayer
local player_gui = player:WaitForChild('PlayerGui')

--// modules

local events_module  = require(script:WaitForChild('Modules'):WaitForChild('Events'))

--// init

events_module.Init()
