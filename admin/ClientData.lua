local players = game:GetService('Players')
local player = players.LocalPlayer
local user_id = player.UserId

local rs = game:GetService('ReplicatedStorage')
local admin_folder = rs:FindFirstChild('Admin')
if not admin_folder then
	admin_folder = rs:WaitForChild('Admin', 5)
end
local libraries = admin_folder:WaitForChild('ClientModules'):WaitForChild('Libraries')

--// modules

local Icon = require(libraries.Icon)
local Tweens = require(script.Parent:WaitForChild('Tweens'))

local PlayerData = {}

-- // functions

function PlayerData.LOAD_ICONS(ADMIN_UI : ScreenGui)
	local holder = ADMIN_UI:FindFirstChild('Holder')
	if not holder then return end
	local Main = holder:WaitForChild('Main')
	local PLAYER_DATA_FRAME = Main:WaitForChild('PlayerData')
	local icon_frame = PLAYER_DATA_FRAME:WaitForChild('Icon')
	local icon_data = icon_frame:WaitForChild('IconData')
	local thumb_type = Enum.ThumbnailType.HeadShot
	local thumb_size = Enum.ThumbnailSize.Size420x420
	local content, is_ready = players:GetUserThumbnailAsync(user_id, thumb_type, thumb_size)
	
	icon_data.Image = content
end

function PlayerData.TopBar(gui) -- admin button
	local icon_ = Icon:new():setName('Admin Panel'):setImage('104776382428665'):setLabel('Admin Panel', 'Viewing')
	icon_.selected:Connect(function()
		if Tweens.IsOpen() then
			Tweens.Close(gui)
		else
			Tweens.Open(gui)
		end
	end)
end


function PlayerData.LOAD_NAMES(ADMIN_UI : ScreenGui)
	local holder = ADMIN_UI:FindFirstChild('Holder')
	if not holder then return end
	
	local Main = holder:WaitForChild('Main')
	local PLAYER_DATA_FRAME = Main:WaitForChild('PlayerData')
	local DISPLAY_NAME  = PLAYER_DATA_FRAME:WaitForChild('DisplayName')
	local NAME = PLAYER_DATA_FRAME:WaitForChild('Username')
	
	DISPLAY_NAME.Text = player.DisplayName
	NAME.Text = '@' .. player.Name
end

function PlayerData.Init(ADMIN_UI : ScreenGui)
	PlayerData.LOAD_ICONS(ADMIN_UI)
	PlayerData.LOAD_NAMES(ADMIN_UI)
	PlayerData.TopBar(ADMIN_UI)
end

return PlayerData
