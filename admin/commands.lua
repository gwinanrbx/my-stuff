--// services

local RS = game:GetService('ReplicatedStorage')
local MessagingService = game:GetService('MessagingService')

--// variables
local admin = RS:WaitForChild('Admin')
local events = admin:WaitForChild('Events')
local server_events = events:WaitForChild('server')
local client_events = events:WaitForChild('client')

local commands = {}

function commands.ServerAnnouncement(player, text)
	if text == '' then return end
	if typeof(text) ~= 'string' then return end

	print('announcement:' .. text)
	client_events:WaitForChild('Announcement'):FireAllClients(player.Name, text)
	text = ''
end

function commands.GlobalAnnouncement(player, text)
	if text == '' then return end
	if typeof(text) ~= 'string' then return end

	print('global announcement:' .. text)

	local success, err = pcall(function()
		MessagingService:PublishAsync('GlobalAnnouncement', {sender = player.Name,message = text})
	end)

end

return commands
