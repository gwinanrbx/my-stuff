--// services

local RS = game:GetService('ReplicatedStorage')
local MessagingService = game:GetService('MessagingService')
local players = game:GetService('Players')
local DSS = game:GetService('DataStoreService')

--// variables
local admin = RS:WaitForChild('Admin')
local events = admin:WaitForChild('Events')
local server_events = events:WaitForChild('server')
local client_events = events:WaitForChild('client')

local admins_module = require(admin:WaitForChild('Settings'))

-- // stores

local bans = DSS:GetDataStore('Bans_') -- Ban data store

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

function commands.Kick(player, text) -- text = player being kicked i hope
	local victim = nil
	local lower = string.lower(text) -- not case sensitive

	for _, plr in pairs(players:GetPlayers()) do
		if string.lower(plr.Name) == lower or string.lower(plr.DisplayName) == lower then
			victim = plr
			break
		end
	end

	if not victim then 
		for _, plr in pairs(players:GetPlayers()) do
			if string.find(string.lower(plr.Name), lower, 1, true) or string.find(string.lower(plr.DisplayName), lower, 1, true) then
				victim = plr
				break
			end
		end
	end

	if not victim then warn('failed') return end
	if admins_module.Admins[victim.UserId] then warn('found in admin module') return end -- cant kick an admin

	if player ~= victim then
		print('kicked')
		victim:Kick('You have been kicked by an admin.')
	else
		warn('is the admin')
	end
end

function commands.Ban(player, text, duration) -- text = player, duration_text = duration
	local victim = nil
	local lower = string.lower(text) -- not case sensitive
	
	for _, plr in pairs(players:GetPlayers()) do -- // FIND VICTIM
		if string.lower(plr.Name) == lower or string.lower(plr.DisplayName) == lower then
			victim = plr
			break
		end
	end
	
	if not victim then 
		for _, plr in pairs(players:GetPlayers()) do -- // FIND
			if string.find(string.lower(plr.Name), lower, 1, true) or string.find(string.lower(plr.DisplayName), lower, 1, true) then
				victim = plr
				break
			end
		end
	end

	if not victim then warn('player not found') return end
	if admins_module.Admins[victim.UserId] then warn('cannot ban admin') return end
	if player == victim then warn('cannot ban yourself') return end
	
	-- // actual banning
	local ban_duration = tonumber(duration)
	if not ban_duration then print('failed') return end
	
	local date = os.time() + (ban_duration * 86400) -- days
	
	local suc, err = pcall(function()
		bans:SetAsync('Ban_' .. victim.UserId, {end_date = date, banned_by = player.Name, reason = 'Banned by an admin'}) -- key
	end)
	
	if suc then
		print('banned')
		victim:Kick('You have been banned by an admin for ' .. ban_duration .. ' days')
	else
		warn('failed')
	end
end

function commands.check_ban(userID)
	local succ, ban_data = pcall(function()
		return bans:GetAsync('Ban_' .. userID)
	end)
	
	if succ and ban_data then
		if os.time() < ban_data.end_date then
			local time_left = math.ceil((ban_data.end_date - os.time()) / 86400)
			return true, time_left
		end
	else
		pcall(function()
			bans:RemoveAsync('Ban_' .. userID) -- remove if it expired
		end)
	end
	
	return false, 0
end

function commands.Unban(player, text)
	local target_userid = tonumber(text)

	if not target_userid then
		local success, userid = pcall(function()
			return players:GetUserIdFromNameAsync(text)
		end)
		if success then
			target_userid = userid
		else
			warn('player not found')
			return
		end
	end

	local succ, ban_data = pcall(function()
		return bans:GetAsync('Ban_' .. target_userid) -- find data
	end)

	if succ and ban_data then
		local remove_success = pcall(function()
			bans:RemoveAsync('Ban_' .. target_userid) -- remove current data
		end)

		if remove_success then -- unban
			print('unbanned ' .. target_userid)
		else
			warn('failed to unban')
		end
	else
		warn('user is not banned')
	end
end


return commands
