local test = {}
test.__index = test

local Player = game:GetService("Players").LocalPlayer

local CoreGui: PlayerGui = game:GetService("CoreGui")
local NewUI: ScreenGui
if not game.CoreGui:FindFirstChild("NewUI") then
	NewUI = Instance.new("ScreenGui", CoreGui)
	NewUI.Name = "NewUI"
else
	NewUI = CoreGui.NewUI
end

test.ElementOrder = {
	Button = 0,
	Toggle = 1,
	Label = 2,
	Box = 3
}
test.ElementSize = UDim2.new(1, 0, 0, 20)
test.Colors = {
	MainColor = Color3.fromRGB(14, 14, 14),
	ButtonColor = Color3.fromRGB(80,80,80),
	TextBoxColor = Color3.fromRGB(20,20,20),
	TextBoxBorder = Color3.fromRGB(36,36,36),
	LabelColor = Color3.fromRGB(24,24,24),
	ElementTransparency = 1,
	ElementHoverTransparency = 0
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
		local Timer = Timer
		while Timer > 0 do
			Timer -= task.wait()
		end
		Callback()
	end)
	coroutine.resume(self.TimerThread)
	return self.TimerThread
end

local ToggleObject = setmetatable({}, GuiObject)
ToggleObject.__index = ToggleObject
function ToggleObject.new(Object: Instance, Source)
	local new = setmetatable(GuiObject.new(Object, Source), ToggleObject)
	new.State = false
	return new
end

function ToggleObject:ChangeState(State: boolean)
	self.State = State
	local Status: Frame = self.Instance:FindFirstChildWhichIsA("Frame")
	if State then
		Status.BackgroundColor3 = Color3.fromRGB(70, 255, 28)
	else
		Status.BackgroundColor3 = Color3.fromRGB(255, 34, 45)
	end
end

function test.Create(ClassName: string, Properties): Instance
	local new = Instance.new(ClassName)
	for i, v in Properties do
		new[i] = v
	end
	return new
end

function test.new(TitleText: string)
	local NewTest = setmetatable({}, test)
	NewTest.MainUI = false
	-- MainWindow
	local Width: number = 0
	for i,v: Frame in CoreGui.NewUI:GetChildren() do
		if v:IsA("Frame") then
			Width += v.AbsoluteSize.X + 4
		end
	end
	
	NewTest.MainWindow = test.Create("Frame", {
		Parent = CoreGui.NewUI,
		Name = TitleText,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 200, 0, 20),
		Position = UDim2.new(0, Width, 0, 0)
	})
	
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
	
	DragModule(NewTest.MainWindow)
	
	-- Body
	local Body: Frame = test.Create("Frame", {
		Parent = NewTest.MainWindow,
		Name = "Body",
		BackgroundColor3 = NewTest.Colors.MainColor,
		BorderSizePixel = 0,
		Size = UDim2.new(1,0,0,0),
		Position = UDim2.new(0,0,0,20),
		BackgroundTransparency = 0.2
	})
	
	-- Title
	local Title: TextLabel = test.Create("TextLabel", {
		Parent = NewTest.MainWindow,
		Name = "Title",
		BackgroundColor3 = NewTest.Colors.MainColor,
		Size = UDim2.new(0,200,0,20),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.2,
		TextColor3 = Color3.fromRGB(255,255,255),
		Text = TitleText
	})
	
	-- TitleGrid
	test.Create("UIGridLayout", {
		Parent = Title,
		CellSize = UDim2.new(0,20,0,20),
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	
	-- UIListLayout
	test.Create("UIListLayout", {
		Parent = Body,
		Padding = UDim.new(0, 1),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	
	-- Hide button
	local HideButton = test.Create("TextButton", {
		Parent = Title,
		Name = "Hide",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 20, 0, 20),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = "-"
	})
	
	HideButton.MouseButton1Up:Connect(function()
		Body.Visible = not Body.Visible
		if Body.Visible then
			HideButton.Text = "-"
		else
			HideButton.Text = "+"
		end
	end)
	
	-- UIGridLayout
	--local Grid = Instance.new("UIGridLayout", Body)
	--Grid.CellPadding = UDim2.new(0,0,0,2)
	--Grid.CellSize = UDim2.new(1,0,0,20)
	--Grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
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
	local Element: TextButton = Instance.new("TextButton", Body)
	Element.LayoutOrder = self.Lines
	Element.BackgroundColor3 = self.Colors.ButtonColor
	Element.BorderSizePixel = 0
	Element.TextColor3 = Color3.fromRGB(255,255,255)
	Element.Text = Text
	Element.Size = self.ElementSize
	Element.BackgroundTransparency = self.Colors.ElementTransparency
	-- Status
	local Status: Frame = Instance.new("Frame", Element)
	Status.Position = UDim2.new(0,180,0,0)
	Status.Size = UDim2.new(0,20,0,20)
	Status.BackgroundColor3 = Color3.fromRGB(255, 34, 45)
	Status.BorderSizePixel = 0
	-- Register toggle
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	-- Connect button
	Element.MouseEnter:Connect(function()
		Element.BackgroundTransparency = self.Colors.ElementHoverTransparency
	end)
	Element.MouseLeave:Connect(function()
		Element.BackgroundTransparency = self.Colors.ElementTransparency
	end)
	
	local State = false
	local ToggleObject = ToggleObject.new(Element, self)
	ToggleObject.State = false
	Element.MouseButton1Up:Connect(function()
		ToggleObject:ChangeState(not ToggleObject.State)
		Callback(ToggleObject.State)
	end)
	return ToggleObject
end
function test:AddButton(Text:string, Callback)
	local Body = self.MainWindow.Body
	-- Toggle
	local Element: TextButton = Instance.new("TextButton", Body)
	Element.LayoutOrder = self.Lines
	Element.BackgroundColor3 = self.Colors.ButtonColor
	Element.BorderSizePixel = 0
	Element.TextColor3 = Color3.fromRGB(255,255,255)
	Element.Text = Text
	Element.Size = self.ElementSize
	Element.BackgroundTransparency = self.Colors.ElementTransparency
	Element.AutoButtonColor = false
	
	-- Register button
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	-- Connect button
	Element.MouseEnter:Connect(function()
		Element.BackgroundTransparency = self.Colors.ElementHoverTransparency
	end)
	Element.MouseLeave:Connect(function()
		Element.BackgroundTransparency = self.Colors.ElementTransparency
	end)
	Element.MouseButton1Up:Connect(function()
		Callback()
	end)
	return GuiObject.new(Element, self)
end

function test:AddLabel(Text:string)
	local Body = self.MainWindow.Body
	-- Toggle
	local Element: TextLabel = Instance.new("TextLabel", Body)
	Element.LayoutOrder = self.Lines
	Element.BackgroundColor3 = self.Colors.LabelColor
	Element.BorderSizePixel = 0
	Element.TextColor3 = Color3.fromRGB(255,255,255)
	Element.Text = Text
	Element.Size = self.ElementSize
	Element.BackgroundTransparency = self.Colors.ElementTransparency
	-- Register button
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	return GuiObject.new(Element, self)
end

function test:AddBox(Text:string, Callback)
	local Body = self.MainWindow.Body
	-- Toggle
	local Element: TextBox = Instance.new("TextBox", Body)
	Element.LayoutOrder = self.Lines
	Element.BackgroundColor3 = self.Colors.TextBoxColor
	Element.BorderColor3 = self.Colors.TextBoxBorder
	Element.BorderMode = Enum.BorderMode.Inset
	Element.BorderSizePixel = 1
	Element.TextColor3 = Color3.fromRGB(255,255,255)
	Element.PlaceholderText = Text
	Element.Text = ""
	Element.Size = self.ElementSize
	Element.BackgroundTransparency = self.Colors.ElementTransparency
	-- Register button
	self.Lines += 1
	Body.Size += UDim2.new(0,0,0,20)

	Element.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			Callback(Element.Text)
			Element.PlaceholderText = string.format("%s | %s", Text, Element.Text)
		end
		Element.Text = ""
	end)

	return GuiObject.new(Element, self)
end
return test
