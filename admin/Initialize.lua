local Server = {}

local RS = game:GetService('ReplicatedStorage')
local ADMIN_FOLDER = RS:WaitForChild('Admin')

local events = ADMIN_FOLDER:WaitForChild('Events')
local client = events:WaitForChild('client')
local initialize_event = client:WaitForChild('Initialize')

--// require

local ADMINS_MODULE = require(ADMIN_FOLDER:WaitForChild('Settings'))

--// module

function Server.Admins(player : Player)
	--print('is admin')
	return ADMINS_MODULE.Admins[player.UserId] -- is player admin?	
end

function Server.SendData(player : Player)
	print('[LOADED SERVER] Succesfully sent data to client')
	initialize_event:FireClient(player)
end

return Server
