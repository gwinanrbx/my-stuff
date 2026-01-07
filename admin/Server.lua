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
	
	local banned, time_ = CommandsModule.check_ban(player.UserId)
	if banned then
		player:Kick('You are banned for ' .. time_ .. ' more days.')
		return
	end
	
	if InitializeModule.Admins(player) then
		print('[INITIALIZED ADMIN DATA]')
		InitializeModule.SendData(player)
	else
		warn('[USER NOT ADMIN]')
		return
	end
end)

-- // kick + ban

server_events:WaitForChild('Kick').OnServerEvent:Connect(function(plr, text)
	if InitializeModule.Admins(plr) then
		CommandsModule.Kick(plr, text)
	end
end)

server_events:WaitForChild('Ban').OnServerEvent:Connect(function(plr, text, duration)
	if InitializeModule.Admins(plr) then
		CommandsModule.Ban(plr, text, duration)
	end
end)

server_events:WaitForChild('Unban').OnServerEvent:Connect(function(plr, text)
	if InitializeModule.Admins(plr) then
		CommandsModule.Unban(plr, text)
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
