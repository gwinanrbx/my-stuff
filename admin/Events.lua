local Events = {} -- client

local rs = game:GetService('ReplicatedStorage')
local admin_folder = rs:FindFirstChild('Admin')
if not admin_folder then
	admin_folder = rs:WaitForChild('Admin', 5)
end

local events = admin_folder:WaitForChild('Events')
local client = events:WaitForChild('client')
local initialize_event = client:WaitForChild('Initialize')
local announce_event = client:WaitForChild('Announcement')

local client_modules = admin_folder:WaitForChild('ClientModules')

--// modules

local client_data = require(client_modules:WaitForChild('ClientData'))
local UI_DATA = require(client_modules:WaitForChild('UserInterface'))
local Announcement = require(client_modules:WaitForChild('Commands'):WaitForChild('Announcement'))

--// functions

function Events.Init()
	initialize_event.OnClientEvent:Connect(function()
		local AdminUI = UI_DATA.Init() -- clones ui
		client_data.Init(AdminUI)
	end)
	announce_event.OnClientEvent:Connect(function(plr, msg) -- plr = sender
		Announcement.Server(plr, msg)
	end)
end

return Events
