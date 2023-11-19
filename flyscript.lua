local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver1mod/NewGui/main/UI_Library.lua", true))()
local example = library:CreateWindow({
	text = "Test"
})

local _Flight = (function()
	--// Variables
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	  local Player = Players.LocalPlayer
	    local character = Player.Character
	local camera = workspace.CurrentCamera
	
	local module = {}
	module.Options = {
		Speed = 5,
		Smoothness = 0.2,
	}
	
	local lib, connections = {}, {}
	lib.connect = function(name, connection)
		connections[name .. tostring(math.random(1000000, 9999999))] = connection
		return connection
	end
	lib.disconnect = function(name)
		for title, connection in pairs(connections) do
			if title:find(name) == 1 then
				connection:Disconnect()
			end
		end
	end
	
	--// Functions
	local flyPart
	
	module.flyend = function()
		lib.disconnect("fly")
		if flyPart then
			flyPart:Destroy()
		end
		character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
	end
	
	module.flyStart = function(enabled)
		if not enabled then flyEnd() return end
		local dir = {w = false, a = false, s = false, d = false}
		local cf = Instance.new("CFrameValue")
		
		flyPart = flyPart or Instance.new("Part")
		flyPart.Anchored = true
		pcall(function()
			flyPart.CFrame = character.HumanoidRootPart.CFrame
		end)
		
		lib.connect("fly", RunService.Heartbeat:Connect(function()
			if not character or not character.Parent or not character:FindFirstChild("HumanoidRootPart") then return end
	
			local primaryPart = character.HumanoidRootPart
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			local speed = module.Options.Speed
			
			local x, y, z = 0, 0, 0
			if dir.w then z = -1 * speed end
			if dir.a then x = -1 * speed end
			if dir.s then z = 1 * speed end
			if dir.d then x = 1 * speed end
			if dir.q then y = 1 * speed end
			if dir.e then y = -1 * speed end
			
			flyPart.CFrame = CFrame.new(
				flyPart.CFrame.p,
				(camera.CFrame * CFrame.new(0, 0, -2048)).p
			)
			
			for _, part in pairs(character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new()
				end
			end
			
			local moveDir = CFrame.new(x,y,z)
			cf.Value = cf.Value:lerp(moveDir, module.Options.Smoothness)
			flyPart.CFrame = flyPart.CFrame:lerp(flyPart.CFrame * cf.Value, module.Options.Smoothness)
			primaryPart.CFrame = flyPart.CFrame
			humanoid.PlatformStand = true
		end))
		lib.connect("fly", UserInputService.InputBegan:Connect(function(input, event)
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
			end
		end))
		lib.connect("fly", UserInputService.InputEnded:Connect(function(input, event)
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
			end
		end))
	end
	
	--// Events
	Player.CharacterAdded:Connect(function(char)
		character = char
	end)
	
	return module
end)()

example:AddToggle("Flight", function(state)
	if fly_enabled == true then
		_G.Flight = fly_enabled
		fly_enabled = false
	else
		_G.Flight = state
	end
    if _G.Flight then
		local enabled = true
        _Flight.flyStart(enabled)
    else
        _Flight.flyend()
    end
end)

example:AddBox("Speed", function(object, focus)
	if focus then
        _Flight.Options["Speed"] = 5
		pcall(function()
            _Flight.Options["Speed"] = tonumber(object.Text)
        end)
	end
end)

example:AddBox("Smoothness", function(object, focus)
	if focus then
        _Flight.Options["Smoothness"] = 0.2
        pcall(function()
            _Flight.Options["Smoothness"] = tonumber(object.Text)
        end)
	end
end)
