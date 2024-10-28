local Player = game:GetService("Players").LocalPlayer

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver1mod/NewGui/main/UI_Library.lua", true))()
local example = library.new("FlyScript")

local Main = {Status = false, Connections = {}}
_G.MainFly = Main
Main.__index = Main

Main.Config = {
	Speed = 1,
	ToCameraSpace = true,
	Higher = Enum.KeyCode.E,
	Lower = Enum.KeyCode.Q
}

function Main:EnableFly()
	local FlyC: CFrame
	FlyC = FlyC or game.Players.LocalPlayer.Character:GetPivot()
	
	local dir = {w = false, a = false, s = false, d = false, q = false, e = false}
	
	local function GetDirection()
		local x, y, z = 0, 0, 0
		local Speed = self.Config.Speed
		if dir.w then z += -1 * Speed end
		if dir.a then x += -1 * Speed end
		if dir.s then z += 1 * Speed end
		if dir.d then x += 1 * Speed end
		if dir.e then y += 1 * Speed end
		if dir.q then y += -1 * Speed end

		if x ~= 0 and z ~= 0 then
			x /= 2
			z /= 2
		end
		return CFrame.new(x,y,z)
	end
	local Direction = CFrame.new()

	self.Connections["InputBegan"] = UserInputService.InputBegan:Connect(function(input, event)
		if event then return end
		local code, codes = input.KeyCode, Enum.KeyCode
		if code == codes.W then
			dir.w = true
		elseif code == codes.A then
			dir.a = true
		elseif code == codes.S then
			dir.s = true
		elseif code == codes.D then
			dir.d = true
		elseif code == self.Config.Lower then
			dir.q = true
		elseif code == self.Config.Higher then
			dir.e = true
		end
		Direction = GetDirection()
	end)

	self.Connections["InputEnded"] = UserInputService.InputEnded:Connect(function(input, event)
		if event then return end
		local code, codes = input.KeyCode, Enum.KeyCode
		if code == codes.W then
			dir.w = false
		elseif code == codes.A then
			dir.a = false
		elseif code == codes.S then
			dir.s = false
		elseif code == codes.D then
			dir.d = false
		elseif code == self.Config.Lower then
			dir.q = false
		elseif code == self.Config.Higher then
			dir.e = false
		end
		Direction = GetDirection()
	end)

	self.Connections["Move"] = RunService.Heartbeat:Connect(function()
		Player.Character.Humanoid.PlatformStand = true
		if self.Config.ToCameraSpace then
			local CameraP = (workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -2048)).Position
			FlyC = CFrame.new(
				FlyC.Position,
				Vector3.new(CameraP.X, FlyC.Y, CameraP.Z)
			)
		else
			FlyC = CFrame.new(
				FlyC.Position,
				(workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -2048)).Position
			)
		end

		FlyC = FlyC*Direction
		Player.Character:PivotTo(FlyC)
	end)
end

function Main:DisableFly()
	self.Connections["Move"]:Disconnect()
	self.Connections["Move"] = nil

	self.Connections["InputBegan"]:Disconnect()
	self.Connections["InputBegan"] = nil

	self.Connections["InputEnded"]:Disconnect()
	self.Connections["InputEnded"] = nil

	Player.Character.Humanoid.PlatformStand = false
end

local Toggle = example:AddToggle("Fly", function(State: boolean)
	if State then
		Main:EnableFly()
	else
		Main:DisableFly()
	end
end)

example:AddBox("Speed", function(Speed: string)
	Main.Config.Speed = tostring(Speed)
end)

local Box = example:AddBox("ToCameraSpace", function(State: string)
	Main.Config.ToCameraSpace = State == "true"
end)

example:AddBox("Key", function(Key: string)
	local ContextActionService = game:GetService("ContextActionService")
	local function handleAction(actionName, inputState, inputObject)
		if actionName == "FlyScript" then
			if inputState == Enum.UserInputState.Begin then
				if Toggle.State then
					Main:DisableFly()
					Toggle:ChangeState(false)
				else
					Main:EnableFly()
					Toggle:ChangeState(true)
				end
			end
		end
	end
	ContextActionService:BindAction("FlyScript", handleAction, false, Enum.KeyCode[string.upper(Key)])
end)

example:AddBox("Key0", function(Key: string)
	local ContextActionService = game:GetService("ContextActionService")
	local function handleAction(actionName, inputState, inputObject)
		if actionName == "ToCameraSpace" then
			if inputState == Enum.UserInputState.Begin then
				Main.Config.ToCameraSpace = not Main.Config.ToCameraSpace
				Box.Instance.PlaceholderText = string.format("%s | %*", "ToCameraSpace", Main.Config.ToCameraSpace)
			end
		end
	end
	ContextActionService:BindAction("ToCameraSpace", handleAction, false, Enum.KeyCode[string.upper(Key)])
end)

example:AddBox("Higher", function(Key: string)
	Main.Config.Higher = Enum.KeyCode[string.upper(Key)]
end)

example:AddBox("Lower", function(Key: string)
	Main.Config.Lower = Enum.KeyCode[string.upper(Key)]
end)
