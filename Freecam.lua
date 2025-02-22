local Player = game:GetService("Players").LocalPlayer

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver1mod/NewGui/main/UI_Library.lua", true))()
local example = library.new("Freecam")

local Main = {Status = false, Connections = {}}
_G.MainFly = Main
Main.__index = Main

Main.Config = {
	Speed = 1,
	LimitYRotation = true,
	Higher = Enum.KeyCode.E,
	Lower = Enum.KeyCode.Q
}

Main.FlyPart = Instance.new("Part")
Main.FlyPart.Size = Vector3.new(0,0,0)
Main.FlyPart.Transparency = 1
Main.FlyPart.CanCollide = false

local Camera = workspace.CurrentCamera
function Main:EnableFly()
    Camera.CameraSubject = self.FlyPart
	local FlyC: CFrame
	FlyC = Camera.CFrame

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

		if x ~= 0 then
			if z ~= 0 and y ~= 0 then
                x /= math.sqrt(3)
                y /= math.sqrt(3)
			    z /= math.sqrt(3)
            elseif y ~= 0 then
                x /= math.sqrt(2)
			    y /= math.sqrt(2)
            elseif z ~= 0 then
                x /= math.sqrt(2)
			    z /= math.sqrt(2)
            end
		elseif y ~= 0 and z ~= 0 then
            y /= math.sqrt(2)
			z /= math.sqrt(2)
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
		for _, part in pairs(Player.Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.AssemblyLinearVelocity = Vector3.new()
			end
		end
		Player.Character.Humanoid.PlatformStand = true
		
		if self.Config.LimitYRotation then
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
		self.FlyPart.CFrame = FlyC
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
    Camera.CameraSubject = Player.Character.Humanoid
	if self.OldAnchored ~= nil then
		Player.Character.PrimaryPart.Anchored = self.OldAnchored
	end
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

local Box = example:AddBox("Limit Y rotation", function(State: string)
	Main.Config.LimitYRotation = State == "true"
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
		if actionName == "LimitYRotation" then
			if inputState == Enum.UserInputState.Begin then
				Main.Config.LimitYRotation = not Main.Config.LimitYRotation
				Box.Instance.PlaceholderText = string.format("%s | %*", "Limit Y rotation", Main.Config.LimitYRotation)
			end
		end
	end
	ContextActionService:BindAction("LimitYRotation", handleAction, false, Enum.KeyCode[string.upper(Key)])
end)

example:AddBox("Higher", function(Key: string)
	Main.Config.Higher = Enum.KeyCode[string.upper(Key)]
end)

example:AddBox("Lower", function(Key: string)
	Main.Config.Lower = Enum.KeyCode[string.upper(Key)]
end)
