local UI = {}

-- // vars

local RS = game:GetService('ReplicatedStorage')
local ADMIN_FOLDER = RS:WaitForChild('Admin')
local UI_FOLDER  =ADMIN_FOLDER:WaitForChild('UI')

local players = game:GetService('Players')
local player = players.LocalPlayer
local player_gui = player:WaitForChild('PlayerGui')

local hoverer = require(script.Hovering)
local tweens = require(script.Parent.Tweens)
local tabs = require(script.Tabs)

-- // funcs

function UI.Load()
	local ADMIN_UI_TEMPLATE = UI_FOLDER:WaitForChild('AdminUI')
	local ADMIN_UI = ADMIN_UI_TEMPLATE:Clone()
	ADMIN_UI.Parent = player_gui
	hoverer.Init(ADMIN_UI)
	
	return ADMIN_UI
end

function UI.Funcs(GUI : ScreenGui) -- buttons
	local Holder = GUI:WaitForChild('Holder')
	local Main = Holder:WaitForChild('Main')
	local Topbar = Main:WaitForChild('Topbar')
	local buttons = {close=Topbar:WaitForChild('Close')}
	
	buttons.close.MouseButton1Down:Connect(function()
		tweens.Close(GUI)
	end)
end

function UI.Init()
	print('loaded')
	local admin_ui = UI.Load()
	UI.Funcs(admin_ui)
	tabs.Server(admin_ui)
	return admin_ui
end

return UI
