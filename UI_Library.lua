local test = {}
test.__index = test

local Player = game:GetService("Players").LocalPlayer

local CoreGui = game:GetService("CoreGui")
if not game.CoreGui:FindFirstChild("NewUI") then
	local NewUI = Instance.new("ScreenGui", CoreGui)
	NewUI.Name = "NewUI"
end

local function DragModule(Gui: Frame)
	local Mouse: PlayerMouse = game:GetService("Players").LocalPlayer:GetMouse()
	local UIS = game:GetService("UserInputService")
	Gui.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local Difference = Vector2.new(Mouse.X, Mouse.Y) - Gui.AbsolutePosition
			while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and task.wait() do
				local result = Vector2.new(Mouse.X, Mouse.Y) - Difference
				Gui.Position = UDim2.new(0, result.X, 0, result.Y)
			end
		end
	end)
end

test.Colors = {
	MainColor = Color3.fromRGB(18, 18, 18),
	FirstLayer = Color3.fromRGB(22, 22, 22),
	ButtonColor = Color3.fromRGB(30,30,30),
	TextBoxColor = Color3.fromRGB(27,27,27),
	TextBoxBorder = Color3.fromRGB(38,38,38)
}
test.Lines = 0

local GuiObject = {}
GuiObject.__index = GuiObject
function GuiObject.new(Object: Instance, Source)
	local new = {}
	setmetatable(new, GuiObject)
	new.Instance = Object
	new.Source = Source
	return new
end

function GuiObject:ChangeOrder(Order: number)
	self.Source:GetElement("order", Order, self.Source).LayoutOrder = self.Instance.LayoutOrder
	self.Instance.LayoutOrder = Order
end

function GuiObject:Remove()
	local Body: Frame = self.Source.MainWindow.Body -- self.MainWindow.Body
	local Order = self.Instance.LayoutOrder
	self.Instance:Destroy()
	Body.Size -= UDim2.new(0,0,0,20)
	self.Source.Lines -= 1
	for _, v: TextButton in Body:GetChildren() do
		if v:IsA("GuiObject") and v.LayoutOrder > Order then
			v.LayoutOrder -= 1
		end
	end
end

function GuiObject:Timer(Timer: number, Callback): thread
	if self.TimerThread and coroutine.status(self.TimerThread) then
		coroutine.close(self.TimerThread)
	end
	self.TimerThread = coroutine.create(function()
		local Time = 0
		while Time < Timer do
			Time += task.wait()
		end
		Callback()
	end)
	coroutine.resume(self.TimerThread)
	return self.TimerThread
end

function test.Create(ClassName: string, Properties): Instance
	local new = Instance.new(ClassName)
	for i, v in Properties do
		pcall(function()
			new[i] = v
		end)
	end
	return new
end

function test.new(TitleText: string)
	local NewTest = setmetatable({}, test)
	NewTest.MainUI = false
	-- MainWindow
	local MainWindow = Instance.new("Frame", CoreGui.NewUI)
	NewTest.MainWindow = MainWindow
	MainWindow.Name = TitleText
	MainWindow.BackgroundTransparency = 1
	MainWindow.BorderSizePixel = 0
	MainWindow.Size = UDim2.new(0, 200, 0, 20)
	DragModule(MainWindow)

	-- Body
	local Body = Instance.new("Frame", MainWindow)
	Body.Name = "Body"
	Body.BackgroundColor3 = NewTest.Colors.MainColor
	Body.BorderSizePixel = 0
	Body.Size = UDim2.new(1,0,0,0)
	Body.Position = UDim2.new(0,0,0,20)

	-- Title
	local Title = Instance.new("TextLabel", MainWindow)
	Title.Name = "Title"
	Title.BackgroundColor3 = NewTest.Colors.MainColor
	Title.Size = UDim2.new(0,200,0,20)
	Title.BorderSizePixel = 0
	Title.BackgroundTransparency = 0.2
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.Text = TitleText

	-- TitleGrid
	local TitleGrid = Instance.new("UIGridLayout", Title)
	TitleGrid.CellSize = UDim2.new(0,20,0,20)
	TitleGrid.HorizontalAlignment = Enum.HorizontalAlignment.Right
	TitleGrid.VerticalAlignment = Enum.VerticalAlignment.Center

	-- Hide button
	local HideButton = Instance.new("TextButton", Title)
	HideButton.Name = "Hide"
	HideButton.BackgroundTransparency = 1
	HideButton.BorderSizePixel = 0
	HideButton.Size = UDim2.new(0, 20, 0, 20)
	HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	HideButton.Text = "◉"

	HideButton.MouseButton1Up:Connect(function()
		Body.Visible = not Body.Visible
		if Body.Visible then
			HideButton.Text = "◉"
		else
			HideButton.Text = "●"
		end
	end)
	
	-- UIGridLayout
	local Grid = Instance.new("UIGridLayout", Body)
	Grid.CellPadding = UDim2.new(0,0,0,2)
	Grid.CellSize = UDim2.new(1,0,0,20)
	Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
	return NewTest
end

-- AddToggle
function test:GetElement(Way2Get, Value, Source)
	local Body = Source.MainWindow.Body
	local Way2Get = string.lower(Way2Get)
	if Way2Get == "name" then
		for _, v:TextButton in Body:GetChildren() do
			if string.lower(v.Text) == string.lower(Value) then
				return v
			end
		end
	elseif Way2Get == "order" then
		for _, v:TextButton in Body:GetChildren() do
			if v:IsA("GuiObject") and v.LayoutOrder == Value then
				return v
			end
		end
	end
end
function test:RemoveElement(v: TextButton)
	local Body: Frame = self.MainWindow.Body -- self.MainWindow.Body
	local Order = v.LayoutOrder
	v:Destroy()
	Body.Size -= UDim2.new(0,0,0,20)
	self.Lines -= 2
	for _, v: TextButton in Body:GetChildren() do
		if v:IsA("GuiObject") and v.LayoutOrder > Order then
			v.LayoutOrder -= 1
		end
	end
end
function test:AddToggle(Text: string, Callback)
	local Body = self.MainWindow.Body
	-- Toggle
	local Toggle: TextButton = Instance.new("TextButton", Body)
	Toggle.LayoutOrder = self.Lines
	Toggle.BackgroundColor3 = self.Colors.ButtonColor
	Toggle.BorderSizePixel = 0
	Toggle.TextColor3 = Color3.fromRGB(255,255,255)
	Toggle.Text = Text
	-- Status
	local Status: Frame = Instance.new("Frame", Toggle)
	Status.Position = UDim2.new(0,180,0,0)
	Status.Size = UDim2.new(0,20,0,20)
	Status.BackgroundColor3 = Color3.fromRGB(255, 34, 45)
	Status.BorderSizePixel = 0
	-- Register toggle
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	-- Connect button
	local State = false
	Toggle.MouseButton1Up:Connect(function()
		State = not State
		Callback(State)
		if State then
			Status.BackgroundColor3 = Color3.fromRGB(70, 255, 28)
		else
			Status.BackgroundColor3 = Color3.fromRGB(255, 34, 45)
		end
	end)
	return GuiObject.new(Toggle, self)
end
function test:AddButton(Text:string, Callback)
	local Body = self.MainWindow.Body
	-- Toggle
	local Button: TextButton = Instance.new("TextButton", Body)
	Button.LayoutOrder = self.Lines
	Button.BackgroundColor3 = self.Colors.ButtonColor
	Button.BorderSizePixel = 0
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.Text = Text
	-- Register button
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	-- Connect button
	Button.MouseButton1Up:Connect(function()
		Callback()
	end)
	return GuiObject.new(Button, self)
end

function test:AddLabel(Text:string)
	local Body = self.MainWindow.Body
	-- Toggle
	local Label: TextLabel = Instance.new("TextLabel", Body)
	Label.LayoutOrder = self.Lines
	Label.BackgroundColor3 = self.Colors.ButtonColor
	Label.BorderSizePixel = 0
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.Text = Text
	-- Register button
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	return GuiObject.new(Label, self)
end

function test:AddBox(Text:string, Callback)
	local Body = self.MainWindow.Body
	-- Toggle
	local Box: TextBox = Instance.new("TextBox", Body)
	Box.LayoutOrder = self.Lines
	Box.BackgroundColor3 = self.Colors.TextBoxColor
	Box.BorderColor3 = self.Colors.TextBoxBorder
	Box.BorderMode = Enum.BorderMode.Inset
	Box.BorderSizePixel = 1
	Box.TextColor3 = Color3.fromRGB(255,255,255)
	Box.PlaceholderText = Text
	Box.Text = ""
	-- Register button
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	Box.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			Callback(Box.Text)
			Box.PlaceholderText = string.format("%s | %s", Text, Box.Text)
		end
		Box.Text = ""
	end)

	return GuiObject.new(Box, self)
end
return test
