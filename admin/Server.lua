-- // services

local players = game:GetService('Players')
local SSS = game:GetService('ServerScriptService')
local MessagingService = game:GetService('MessagingService')
local Admin = SSS:WaitForChild('Admin')
local Modules = Admin:WaitForChild('Modules')

local RS = game:GetService('ReplicatedStorage')
local admin = RS:WaitForChild('Admin')
local events = admin:WaitForChild('Events')
local server_events = events:WaitForChild('server')
local client_events = events:WaitForChild('client')

-- // modules

local InitializeModule = require(Modules:WaitForChild('Initialize'))
local CommandsModule = require(Modules:WaitForChild('Commands'))

-- // main

players.PlayerAdded:Connect(function(player)
	if InitializeModule.Admins(player) then
		print('[INITIALIZED ADMIN DATA]')
		InitializeModule.SendData(player)
	else
		warn('[USER NOT ADMIN]')
		return
	end
end)

-- // announcement

server_events:WaitForChild('ServerAnnouncement').OnServerEvent:Connect(function(plr, text)
	if InitializeModule.Admins(plr) then
		CommandsModule.ServerAnnouncement(plr, text)
	end
end)

server_events:WaitForChild('GlobalAnnouncement').OnServerEvent:Connect(function(plr, text)
	if InitializeModule.Admins(plr) then
		CommandsModule.GlobalAnnouncement(plr, text)
	end
end)

local success, connection = pcall(function()
	return MessagingService:SubscribeAsync('GlobalAnnouncement', function(message)
		local data = message.Data
		client_events:WaitForChild('Announcement'):FireAllClients(data.sender, data.message)
	end)
end)
