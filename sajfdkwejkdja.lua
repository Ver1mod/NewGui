-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver1mod/temp/main/test1.lua?token=GHSAT0AAAAAACSBTNMHMJBMHUYGDIKOBKHSZUTHV5A", true))()
-- v10 Super (Perfomance)
-- Global Variables
local Aimbot = {}
Aimbot.__index = Aimbot

local Player = game.Players.LocalPlayer
local Use_Storage = game:GetService("ReplicatedStorage").Remotes.UseStorage
local NPCs = game.Workspace.NPCs
local ContextActionService = game:GetService("ContextActionService")
local BulletReplication = game:GetService("ReplicatedStorage").BulletReplication.ReplicateClient

local function merge_tables(arg, value0)
	local value = arg
	for i, v in value0 do
		table.insert(value, v)
	end
	return value
end

-- The start
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver1mod/NewGui/Ver1mod-patch-1/UI_Library.lua", true))()
local example = library.new("The red lake")
local example0 = library.new("Items")

-- Auto potions
local auto_strength = false
local auto_absorb = false
local auto_mixture = false
example0:AddToggle("Strength Mixture", function(state)
	auto_strength = state
	local ohString2 = "Strength Mixture"
	while auto_strength do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				if not Player.Backpack:FindFirstChild("Strength Mixture") and not Player.Character:FindFirstChild("Strength Mixture") then
					Use_Storage:FireServer("WITHDRAW", ohString2)
				end
				Player.Backpack:WaitForChild("Strength Mixture").Parent = Player.Character
				Player.Character:WaitForChild("Strength Mixture").Use:FireServer(Vector3.new(0,0,0))
				wait(16)
			end
		end)
		task.wait()
	end
end)
example0:AddToggle("Absorb Mixture", function(state)
	auto_absorb = state
	local ohString2 = "Absorb Mixture"
	while auto_absorb do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				if not Player.Backpack:FindFirstChild("Absorb Mixture") and not Player.Character:FindFirstChild("Strength Mixture") then
					Use_Storage:FireServer("WITHDRAW", ohString2)
					Player.Backpack:WaitForChild("Absorb Mixture").Parent = Player.Character
				elseif Player.Backpack:FindFirstChild("Absorb Mixture") then
					Player.Backpack["Absorb Mixture"].Parent = Player.Character
				end
				Player.Character["Absorb Mixture"].Use:FireServer(Vector3.new(0,0,0))
				wait(31)
			end
		end)
		task.wait()
	end
end)
example0:AddToggle("Mixture", function(state)
	auto_mixture = state
	while auto_mixture do
		pcall(function()
			if Player.Character.Humanoid.Health ~= 0 then
				if not Player.Backpack:FindFirstChild("Mixture") and not Player.Character:FindFirstChild("Mixture") then
					Use_Storage:FireServer("WITHDRAW", "Mixture")
					Player.Backpack:WaitForChild("Mixture").Parent = Player.Character
				elseif Player.Backpack:FindFirstChild("Mixture") then
					Player.Backpack.Mixture.Parent = Player.Character
				end
				Player.Character:WaitForChild("Mixture").Use:FireServer(Vector3.new(0,0,0))
				task.wait(2.8)
			end
		end)
		task.wait()
	end
end)

-- Auto bring items
example0:AddButton("Teleport Device", function()
	local ohString2 = "Teleport Device"
	Use_Storage:FireServer("WITHDRAW", ohString2)
	Player.Backpack:WaitForChild(ohString2).Parent = Player.Character
	Player.Character:WaitForChild(ohString2).Use:FireServer(Vector3.new(0,0,0))
end)

example0:AddButton("Smoke Grenade", function()
	local ohString2 = "Smoke Grenade"
	Use_Storage:FireServer("WITHDRAW", ohString2)
end)

example0:AddButton("Scan Grenade", function()
	local ohString2 = "Scan Grenade"
	Use_Storage:FireServer("WITHDRAW", ohString2)
end)

example0:AddButton("Aura Grenade", function()
	local ohString2 = "Aura Grenade"
	Use_Storage:FireServer("WITHDRAW", ohString2)
end)

example0:AddButton("Deposit", function()
	local tool = Player.Character:FindFirstChildOfClass("Tool")
	if tool:GetAttribute("FromStorage") == true then
		Use_Storage:FireServer("DEPOSIT", tool.Name)
	end
end)

example0:AddButton("Bulk scrap", function()
	Player.PlayerGui.BulkScrap.Enabled = true
end)

local BuyWeapon = {}
BuyWeapon.__index = BuyWeapon
BuyWeapon.Window = example0:AddButton("buyBlackmarket", function()
	game:GetService("ReplicatedStorage").buyBlackmarket:FireServer(BuyWeapon.Target)
    BuyWeapon.Window.Text = "Bought " .. BuyWeapon.Target
    task.wait(5)
    BuyWeapon.Window.Text = "buyBlackmarket"
end)

example0:AddBox("Target weapon", function(object, focus)
	if focus then
		BuyWeapon.Target = object.Text
	end
end)

-- Aimbot settings
local RPM = 0
example:AddBox("Delay", function(object, focus)
	if focus then
		RPM = 0
		pcall(function()
			RPM = tonumber(object.Text)
		end)
	end
end)

local Range = 2
example:AddBox("Range", function(object, focus)
	if focus then
		Range = 2
		pcall(function()
			Range = tonumber(object.Text)
		end)
	end
end)

local Hardness = 5
example:AddBox("Hardness", function(object, focus)
	if focus then
		Hardness = 5
		pcall(function()
			Hardness = tonumber(object.Text)
		end)
	end
end)

Aimbot.BulletType = "NONE"
example:AddBox("Bullet type", function(object, focus)
	if focus then
		pcall(function()
			Aimbot.BulletType = string.upper(object.Text)
		end)
	end
end)

-- Backpack hack
local backpack_hack = false
example:AddToggle("Enable backpack bag", function(state)
	backpack_hack = state
	while backpack_hack do
		pcall(function()
			fireproximityprompt(Player.Character.BackpackBag.Handle.Template)
		end)
		task.wait(1)
	end
end)

-- Aimbot modules
local function auto_equip()
	for _, v in Player.Backpack:GetChildren() do
		if v:GetAttribute("Ammo") then
			v.Parent = Player.Character
		end
	end
end

Aimbot.InstaKill = false
example:AddToggle("Insta kill", function(state)
	if state then
		Aimbot.InstaKill = true
	else
		Aimbot.InstaKill = false
	end
end)

Aimbot.DIT = false -- Dont insta tango, false means insta, true means dont
example:AddToggle("Don't insta tango", function(state)
	Aimbot.DIT = state
end)

Aimbot.DIB = false -- false means insta, true means dont
example:AddToggle("Don't insta bosses", function(state) -- Dont insta Bosses
	Aimbot.DIB = state
end)

Aimbot.BulletType = "NONE"
local function shot(weapon, enemy)
	-- enemy.parent is parented to workspace.NPCs.Monsters
	-- enemy = enemy.Head
	local target = enemy.Parent
	if weapon:GetAttribute("Ammo") then
		if Player:DistanceFromCharacter(enemy.Position) < weapon:GetAttribute("Range")*Range and not target:GetAttribute("ImmortalWishSpawn") and not target:GetAttribute("Protector") and not target:GetAttribute("OnVehicle") then
			if Aimbot.BulletType ~= "NONE" then
				game:GetService("ReplicatedStorage").Remotes.GOCModeSwitch:FireServer(weapon, Aimbot.BulletType)
			end
			weapon.Main:FireServer("MUZZLE", weapon.Handle.Barrel)
			
			local StandPoints
            local Bosses = Player.PlayerGui.GameMain2.Topbar.ListBoss.Templates
			if Aimbot.InstaKill and not (target.Parent.Name == "Tango" and Aimbot.DIT) and not (Bosses:FindFirstChild(target.Name) and Aimbot.DIB) then
				StandPoints = 0/0
			else
				StandPoints = 100
			end
			
			weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=StandPoints, [4] = true})
			weapon.Main:FireServer("AMMO")
		end
	end
end

-- Aimbot modes
local autofarm = false
local autofarm_experimental = false
local selected_part

example:AddToggle("Auto Farm Mobs(Hard)", function(state)
	autofarm_experimental = state
	local i0 = 1
	local tools = {}
	local enemies = merge_tables(
		NPCs.Monsters:GetChildren(), 
		NPCs.Tango:GetChildren()
	)
	local tools = {}
	for _, tool in Player.Character:GetChildren() do
		if tool:GetAttribute("Ammo") then
			table.insert(tools, tool)
		end
	end

	local connections = {}
	local function set_tools(character)
		connections[5] = character.ChildAdded:Connect(function(tool)
			if tool:GetAttribute("Ammo") then
				table.insert(tools, tool)
			end
		end)
		connections[6] = character.ChildRemoved:Connect(function(tool)
			if tool:GetAttribute("Ammo") then
				local target = table.find(tools, tool)
				table.remove(tools, target)
			end
		end)
	end
	set_tools(Player.Character)
	connections[7] = Player.CharacterAdded:Connect(set_tools)
	connections[8] = Player.CharacterRemoving:Connect(function()
		connections[5]:Disconnect()
		connections[6]:Disconnect()
	end)

	connections[1] = NPCs.Monsters.ChildAdded:Connect(function(child)
		table.insert(enemies, child)
	end)
	connections[2] = NPCs.Tango.ChildAdded:Connect(function(child)
		table.insert(enemies, child)
	end)
	connections[3] = NPCs.Monsters.ChildRemoved:Connect(function(child)
		local target = table.find(enemies, child)
		table.remove(enemies, target)
	end)
	connections[4] = NPCs.Tango.ChildRemoved:Connect(function(child)
		local target = table.find(enemies, child)
		table.remove(enemies, target)
	end)

	local i = 1
	local i1 = 1
	while autofarm_experimental do
		auto_equip()
		if enemies[1] == nil or tools[1] == nil then
			task.wait()
			continue
		end
		if enemies[i] == nil then
			i = 1
		end
		if tools[i0] == nil then
			i0 = 1
		end
		local enemy = enemies[i]
		local weapon = tools[i0]
		if enemy.Parent.Name ~= "Deceased" and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
			if enemy:FindFirstChild("Head") then
				shot(weapon, enemy.Head)
				i0 += 1
			elseif enemy:FindFirstChild("HumanoidRootPart") then
				shot(weapon, enemy.HumanoidRootPart)
				i0 += 1
			end
		end
		if i1 >= Hardness then
			i1 = 1
			task.wait(RPM)
		end
		i1 += 1
		i += 1
	end

	for _, v in connections do
		v:Disconnect()
	end
end)

local test = {}
test.__index = test

test.KeyCode = Enum.KeyCode.B
example:AddBox("Key", function(object, focus)
	if focus then
		test.KeyCode = Enum.KeyCode.B
		pcall(function()
			test.KeyCode = Enum.KeyCode[string.upper(object.Text)]
		end)
		ContextActionService:UnbindAction("SelectedPart")
		test.BindAction()
	end
end)

example:AddToggle("Auto Farm Mobs", function(state)
	autofarm = state
	while autofarm do
		task.wait()
		if test.part and test.part:IsDescendantOf(game) then
			pcall(function()
				if test.UnusualEnemy then
					while autofarm and test.part and test.part:IsDescendantOf(game) do
						auto_equip()
						for _, tool in Player.Character:GetChildren() do
							shot(tool, test.part)
						end
						task.wait(RPM)
					end
				else
					while test.part and test.part:IsDescendantOf(game) and test.part.Humanoid.Health > 0 and autofarm do
						auto_equip()
						for _, tool in Player.Character:GetChildren() do
							if test.part:FindFirstChild("Head") then
								shot(tool, test.part.Head)
							elseif test.part:FindFirstChild("HumanoidRootPart") then
								shot(tool, test.part.HumanoidRootPart)
							end
						end
						task.wait(RPM)
					end
				end
			end)
		end
	end
end)

function test:create_highlight()
	local function SetUp()
		self.HighlightInstance = Instance.new("Highlight")
		self.HighlightInstance.Name = "TestHighlight"
		self.HighlightInstance.Parent = self.part
		self.HighlightInstance.FillTransparency = 0.6
		self.HighlightInstance.FillColor = Color3.fromRGB(8, 136, 255)
	end
	if self.HighlightInstance then
		if self.HighlightInstance.Parent ~= self.part then
			self.HighlightInstance:Destroy()
			SetUp()
		else
			self.HighlightInstance:Destroy()
			self.part = nil
		end
	else
		SetUp()
	end 
end

function test.getPart()
	-- Player
	local mouse = Player:GetMouse()

	-- Detect part
	local UserInputService = game:GetService("UserInputService")
	local MAX_MOUSE_DISTANCE = 2400

	local mouseLocation = UserInputService:GetMouseLocation()

	-- Create a ray from the 2D mouseLocation
	local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

	-- The unit direction vector of the ray multiplied by a maximum distance
	local directionVector = screenToWorldRay.Direction * MAX_MOUSE_DISTANCE

	-- Raycast from the ray's origin towards its direction
	local raycastResult = workspace:Raycast(screenToWorldRay.Origin, directionVector)

	if raycastResult then
		return raycastResult.Instance
	end
end

function test:SelectTarget()
	self.part = self.getPart()
	if self.part and (self.part:IsDescendantOf(NPCs) or self.SelectNonLiving) then
		if not self.SelectNonLiving then
			while self.part.Parent.Parent ~= NPCs do
				self.part = self.part.Parent
			end
			self.UnusualEnemy = false
		else
			self.UnusualEnemy = true
		end
		test:create_highlight()
	end
end

example:AddToggle("Select non-living", function(state)
	test.SelectNonLiving = state
end)

function test.BindAction()
	local function handleAction(actionName, inputState, inputObject)
		if actionName == "SelectedPart" then
			if inputState == Enum.UserInputState.Begin then
				test:SelectTarget()
			end
		end
	end
	ContextActionService:BindAction("SelectedPart", handleAction, false, test.KeyCode)
end

function _G.ChangeHardness(Arg: IntValue)
	Hardness = Arg
end

function _G.ChangeRPM(Arg: IntValue)
	RPM = Arg
end
