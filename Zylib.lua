local RayfieldLibrary = {
	Flags = {},
	Theme = {
		Default = {
			Text = Color3.fromRGB(240, 240, 240),
			SubText = Color3.fromRGB(160, 160, 160),
			Background = Color3.fromRGB(25, 25, 25),
			Topbar = Color3.fromRGB(30, 30, 30),
			TabBackground = Color3.fromRGB(32, 32, 32),
			TabBackgroundSelected = Color3.fromRGB(45, 45, 45),
			ElementBackground = Color3.fromRGB(35, 35, 35),
			ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
			Accent = Color3.fromRGB(0, 122, 255)
		}
	}
}

-- Servicios de Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local SelectedTheme = RayfieldLibrary.Theme.Default
local keybindConnections = {}
local globalLoaded = false
local rayfieldDestroyed = false

function RayfieldLibrary:CreateWindow(Settings)
	local Window = {Tabs = {}}
	local Hidden = false
	local Minimised = false

	-- Creación de ScreenGui principal
	local Rayfield = Instance.new("ScreenGui")
	Rayfield.Name = Settings.Name or "Rayfield"
	Rayfield.ResetOnSpawn = false

	local success, err = pcall(function()
		Rayfield.Parent = CoreGui
	end)
	if not success then
		Rayfield.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	-- Marco Principal
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.BackgroundColor3 = SelectedTheme.Background
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = Rayfield

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = Main

	-- Sistema de Arraste (Dragging)
	local Dragging, DragInput, DragStart, StartPos
	local function UpdateDrag(input)
		local delta = input.Position - DragStart
		Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
	end

	-- Topbar (Barra Superior)
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 35)
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Topbar.BorderSizePixel = 0
	Topbar.Parent = Main

	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			UpdateDrag(input)
		end
	end)

	-- Título
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -90, 1, 0)
	Title.Position = UDim2.new(0, 12, 0, 0)
	Title.Text = Settings.Name or "Rayfield Interface"
	Title.TextColor3 = SelectedTheme.Text
	Title.TextSize = 15
	Title.Font = Enum.Font.SourceSansBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1
	Title.Parent = Topbar

	-- Botones de Control Topbar (Únicamente Minimizar '-' y Cerrar 'X')
	local Controls = Instance.new("Frame")
	Controls.Name = "Controls"
	Controls.Size = UDim2.new(0, 60, 1, 0)
	Controls.Position = UDim2.new(1, -65, 0, 0)
	Controls.BackgroundTransparency = 1
	Controls.Parent = Topbar

	local ControlsLayout = Instance.new("UIListLayout")
	ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
	ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	ControlsLayout.Padding = UDim.new(0, 5)
	ControlsLayout.Parent = Controls

	-- Botón Minimizar (-)
	local ChangeSize = Instance.new("TextButton")
	ChangeSize.Name = "ChangeSize"
	ChangeSize.Size = UDim2.new(0, 24, 0, 24)
	ChangeSize.BackgroundColor3 = SelectedTheme.ElementBackground
	ChangeSize.Text = "-"
	ChangeSize.TextColor3 = SelectedTheme.Text
	ChangeSize.TextSize = 16
	ChangeSize.Font = Enum.Font.SourceSansBold
	ChangeSize.Parent = Controls

	local SizeCorner = Instance.new("UICorner")
	SizeCorner.CornerRadius = UDim.new(0, 4)
	SizeCorner.Parent = ChangeSize

	-- Botón Cerrar (X)
	local HideBtn = Instance.new("TextButton")
	HideBtn.Name = "Hide"
	HideBtn.Size = UDim2.new(0, 24, 0, 24)
	HideBtn.BackgroundColor3 = SelectedTheme.ElementBackground
	HideBtn.Text = "X"
	HideBtn.TextColor3 = SelectedTheme.Text
	HideBtn.TextSize = 13
	HideBtn.Font = Enum.Font.SourceSansBold
	HideBtn.Parent = Controls

	local HideCorner = Instance.new("UICorner")
	HideCorner.CornerRadius = UDim.new(0, 4)
	HideCorner.Parent = HideBtn

	--------------------------------------------------------------------
	-- REORGANIZACIÓN: Contenedor Izquierdo (Tabs) y Derecho (Pages)
	--------------------------------------------------------------------
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, 0, 1, -35)
	ContentContainer.Position = UDim2.new(0, 0, 0, 35)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = Main

	-- Menú Lateral Izquierdo de Pestañas (Tabs)
	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.Size = UDim2.new(0, 130, 1, -10)
	TabList.Position = UDim2.new(0, 5, 0, 5)
	TabList.BackgroundTransparency = 1
	TabList.BorderSizePixel = 0
	TabList.ScrollBarThickness = 2
	TabList.Parent = ContentContainer

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 4)
	TabListLayout.Parent = TabList

	-- Contenedor Derecho de Páginas (Elements)
	local Elements = Instance.new("Frame")
	Elements.Name = "Elements"
	Elements.Size = UDim2.new(1, -145, 1, -10)
	Elements.Position = UDim2.new(0, 140, 0, 5)
	Elements.BackgroundTransparency = 1
	Elements.ClipsDescendants = true
	Elements.Parent = ContentContainer

	-- Animaciones de Ocultado / Minimizado preservadas
	local function Hide(playTween)
		if playTween then
			TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 500, 0, 0),
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.4)
			Main.Visible = false
		else
			Main.Visible = false
		end
	end

	local function Unhide()
		Main.Visible = true
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 500, 0, 350),
			BackgroundTransparency = 0
		}):Play()
	end

	local function Minimise()
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 500, 0, 35)
		}):Play()
	end

	local function Maximise()
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 500, 0, 350)
		}):Play()
	end

	HideBtn.MouseButton1Click:Connect(function()
		Hide(true)
		Hidden = true
	end)

	ChangeSize.MouseButton1Click:Connect(function()
		if Minimised then
			Maximise()
			Minimised = false
		else
			Minimise()
			Minimised = true
		end
	end)

	-- Lógica de Generación de Tabs
	local firstTab = true

	function Window:CreateTab(TabName)
		local Tab = {}

		-- Botón en la lista lateral
		local TabButton = Instance.new("TextButton")
		TabButton.Name = TabName
		TabButton.Size = UDim2.new(1, -4, 0, 30)
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.Text = TabName
		TabButton.TextColor3 = SelectedTheme.SubText
		TabButton.TextSize = 13
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Parent = TabList

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton

		-- Página correspondiente a la pestaña
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = TabName .. "Page"
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 3
		TabPage.Visible = false
		TabPage.Parent = Elements

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 6)
		PageLayout.Parent = TabPage

		-- Selección de pestaña
		local function Select()
			for _, child in ipairs(Elements:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					child.Visible = false
				end
			end
			for _, child in ipairs(TabList:GetChildren()) do
				if child:IsA("TextButton") then
					TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = SelectedTheme.TabBackground,
						TextColor3 = SelectedTheme.SubText
					}):Play()
				end
			end

			TabPage.Visible = true
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				BackgroundColor3 = SelectedTheme.TabBackgroundSelected,
				TextColor3 = SelectedTheme.Text
			}):Play()
		end

		TabButton.MouseButton1Click:Connect(Select)

		if firstTab then
			firstTab = false
			Select()
		end

		-- Ejemplo de creador de botón dentro de la pestaña
		function Tab:CreateButton(ButtonSettings)
			local Button = Instance.new("TextButton")
			Button.Name = ButtonSettings.Name or "Button"
			Button.Size = UDim2.new(1, -8, 0, 32)
			Button.BackgroundColor3 = SelectedTheme.ElementBackground
			Button.Text = ButtonSettings.Name or "Button"
			Button.TextColor3 = SelectedTheme.Text
			Button.TextSize = 13
			Button.Font = Enum.Font.SourceSans
			Button.Parent = TabPage

			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 5)
			BtnCorner.Parent = Button

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Button.MouseButton1Click:Connect(function()
				pcall(ButtonSettings.Callback)
			end)
		end

		return Tab
	end

	return Window
end

-- Limpieza
function RayfieldLibrary:Destroy()
	for _, conn in ipairs(keybindConnections) do
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
	table.clear(keybindConnections)

	if CoreGui:FindFirstChild("Rayfield") then
		CoreGui.Rayfield:Destroy()
	end
end

return RayfieldLibrary
