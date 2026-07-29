local LeehHub = {}
LeehHub.__index = LeehHub

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LP               = Players.LocalPlayer

local T = {
bg      = Color3.fromRGB(5, 5, 5),     
panel   = Color3.fromRGB(15, 15, 15), 
panel2  = Color3.fromRGB(22, 22, 22),  
border  = Color3.fromRGB(45, 45, 45),  
acc     = Color3.fromRGB(255, 255, 255), 
text    = Color3.fromRGB(250, 250, 250),
muted   = Color3.fromRGB(100, 100, 100),
darkRed = Color3.fromRGB(30, 30, 30), 
red     = Color3.fromRGB(200, 30, 30),
green   = Color3.fromRGB(34, 197, 94),
bgTrans = 0.1,
tabSize = 160,
iconSize = 24,
}

local function New(cls, props)
local o = Instance.new(cls)
for k, v in pairs(props or {}) do o[k] = v end
return o
end

local function Cor(obj, r)
New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj })
end

local function Stk(obj, col, th)
New("UIStroke", { Color = col or T.border, Thickness = th or 1.5, Parent = obj })
end

local function List(obj, dir, pad)
New("UIListLayout", {
FillDirection = dir or Enum.FillDirection.Vertical,
Padding       = UDim.new(0, pad or 8),
SortOrder     = Enum.SortOrder.LayoutOrder,
Parent        = obj,
})
end

local function Pad(obj, t, b, l, r)
New("UIPadding", {
PaddingTop    = UDim.new(0, t or 0),
PaddingBottom = UDim.new(0, b or 0),
PaddingLeft   = UDim.new(0, l or 0),
PaddingRight  = UDim.new(0, r or 0),
Parent        = obj,
})
end

local function TW(obj, t, props)
local anim = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
anim:Play()
return anim
end

local function styleButton(btn)
Cor(btn, 6)
Stk(btn, Color3.fromRGB(0,0,0), 2)
btn.MouseEnter:Connect(function()
TW(btn, 0.15, { BackgroundColor3 = T.acc })
TW(btn, 0.15, { TextColor3 = Color3.new(1,1,1) })
end)
btn.MouseLeave:Connect(function()
TW(btn, 0.15, { BackgroundColor3 = T.panel })
TW(btn, 0.15, { TextColor3 = T.text })
end)
end

function LeehHub:Window(cfg)
cfg = cfg or {}
local title   = cfg.Title   or "LeehHub"
local creator = cfg.Creator or ""
local game_   = cfg.Game    or ""
local key     = cfg.Key     or Enum.KeyCode.RightShift
local icon    = cfg.Icon    or ""

local GUI = New("ScreenGui", {  
	Name         = "LeehHub_" .. title,  
	ResetOnSpawn = false,  
	Parent       = (gethui and gethui()) or game:GetService("CoreGui"),  
})  

	--// NOTIFY SYSTEM

local notifyHolder = New("Frame", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -10, 1, -10),
	Size = UDim2.new(0, 220, 1, -20),
	BackgroundTransparency = 1,
	Parent = GUI
})

local layout = New("UIListLayout", {
	FillDirection = Enum.FillDirection.Vertical,
	Padding = UDim.new(0, 12),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Parent = notifyHolder,
})
	local notifyCount = 0

local function Notify(text)

	notifyCount += 1

	local box = New("Frame", {
		Size = UDim2.new(0, 260, 0, 0),
		BackgroundColor3 = T.panel2,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = notifyCount,
		Parent = notifyHolder
	})

	Cor(box, 10)
	Stk(box, T.acc, 1.5)

	local glow = New("UIStroke", {
		Color = T.acc,
		Thickness = 0,
		Transparency = 0.3,
		Parent = box
	})

	local title = New("TextLabel", {
		Position = UDim2.new(0, 14, 0, 10),
		Size = UDim2.new(1, -28, 0, 22),
		BackgroundTransparency = 1,
		Text = text or "Activado",
		TextColor3 = T.text,
		TextTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = box
	})

	local barBg = New("Frame", {
		Position = UDim2.new(0, 14, 1, -14),
		Size = UDim2.new(1, -28, 0, 5),
		BackgroundColor3 = T.panel,
		BackgroundTransparency = 1,
		Parent = box
	})

	Cor(barBg, 6)

	local bar = New("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = T.acc,
		Parent = barBg
	})

	Cor(bar, 6)

	-- ENTRADA
	TW(box, 0.25, {
		Size = UDim2.new(0, 200, 0, 45),
		BackgroundTransparency = 0.05
	})

	TW(title, 0.25, {
		TextTransparency = 0
	})

	TW(barBg, 0.25, {
		BackgroundTransparency = 0
	})

	TW(glow, 0.25, {
		Thickness = 2
	})

	task.wait(0.05)

	-- LOADER
	local loadTween = TW(bar, 2.8, {
		Size = UDim2.new(1, 0, 1, 0)
	})

	loadTween.Completed:Connect(function()

		-- SALIDA
		TW(box, 0.3, {
			Size = UDim2.new(0, 260, 0, 55),
			BackgroundTransparency = 1
		})

		TW(title, 0.25, {
			TextTransparency = 1
		})

		TW(barBg, 0.25, {
			BackgroundTransparency = 1
		})

		TW(bar, 0.25, {
			BackgroundTransparency = 1
		})

		TW(glow, 0.25, {
			Thickness = 0
		})

		task.delay(0.35, function()
			box:Destroy()
		end)

	end)

end



	
--// TAB SOUND (GITHUB)

local success, err = pcall(function()

local tabSound = New("Sound", {  
	Name = "TabSound",  
	Volume = 1,  
	Parent = GUI,  
})  

local audioFile = "ClickTab.wav"  

if not isfile(audioFile) then  
	writefile(  
		audioFile,  
		game:HttpGet("https://github.com/leeh10/LeeHubMax/raw/refs/heads/main/ClicksSound/ClickTab.wav")  
	)  
end  

tabSound.SoundId = (getsynasset or getcustomasset)(audioFile)  

function playTabSound()  
	tabSound:Play()  
end

end)

if not success then
warn("TabSound Error:", err)

function playTabSound()  
end

end


	--// TOGGLE SOUND

local success2, err2 = pcall(function()

	local toggleSound = New("Sound", {
		Name = "ToggleSound",
		Volume = 1,
		Parent = GUI,
	})

	local audioFile2 = "ToggleClick.wav"

	if not isfile(audioFile2) then
		writefile(
			audioFile2,
			game:HttpGet("https://github.com/leeh10/LeeHubMax/raw/refs/heads/main/ClicksSound/ToggleClick.wav")
		)
	end

	toggleSound.SoundId = (getsynasset or getcustomasset)(audioFile2)

	function playToggleSound()
		toggleSound:Play()
	end

end)

if not success2 then
	warn("ToggleSound Error:", err2)

	function playToggleSound()
	end
	end

local winMain = New("Frame", {  
	Name                   = "Window",  
	AnchorPoint            = Vector2.new(0.5, 0.5),  
	Position               = UDim2.fromScale(0.5, 0.5),  
	Size                   = UDim2.new(0, 600, 0, 320),  
	BackgroundColor3       = T.bg,  
	BackgroundTransparency = T.bgTrans,  
	Visible                = false,  
	Parent                 = GUI,  
})  
Cor(winMain, 10)  
Stk(winMain, Color3.new(0,0,0), 3)  

local titleBar = New("Frame", {  
	Size = UDim2.new(1, -12, 0, 45),  
	Position = UDim2.new(0, 6, 0, 6),  
	BackgroundColor3       = Color3.fromRGB(20, 20, 20),  
	BackgroundTransparency = 0.2,  
	Parent                 = winMain,  
})  
Cor(titleBar, 8)  
Stk(titleBar, T.border, 1.5) -- <--- ¡Cambiado de T.acc a T.border para que sea gris!


local titleText = (game_ ~= "" and creator ~= "")  
	and (game_ .. " | By " .. creator)  
	or (creator ~= "" and ("By " .. creator) or title)  

New("TextLabel", {  
	Position               = UDim2.new(0, 15, 0, 0),  
	Size                   = UDim2.new(1, -60, 1, 0),  
	BackgroundTransparency = 1,  
	Text                   = titleText,  
	TextColor3             = T.text,  
	Font                   = Enum.Font.GothamBold,  
	TextSize               = 16,  
	TextXAlignment         = Enum.TextXAlignment.Left,  
	Parent                 = titleBar,  
})  

local closeBtn = New("TextButton", {  
	AnchorPoint      = Vector2.new(1, 0.5),  
	Position         = UDim2.new(1, -10, 0.5, 0),  
	Size             = UDim2.new(0, 32, 0, 32),  
	BackgroundColor3 = T.red,  
	Text             = "-",  
	TextColor3       = Color3.new(1,1,1),  
	Font             = Enum.Font.GothamBold,  
	TextSize         = 20,  
	Parent           = titleBar,  
})  
Cor(closeBtn, 8)  
Stk(closeBtn, Color3.new(0,0,0), 1.5)  

local sidebar = New("ScrollingFrame", {  
	Position               = UDim2.new(0, 10, 0, 58),  
	Size                   = UDim2.new(0, T.tabSize, 1, -66),  
	BackgroundTransparency = 1,  
	ScrollBarThickness     = 0,  
	CanvasSize             = UDim2.new(0,0,0,0),  
	AutomaticCanvasSize    = Enum.AutomaticSize.Y,  
	Parent                 = winMain,  
})  
List(sidebar, Enum.FillDirection.Vertical, 18)  
Pad(sidebar, 10, 10, 5, 5)  

local contentArea = New("Frame", {  
	Position               = UDim2.new(0, T.tabSize + 25, 0, 58),  
	Size                   = UDim2.new(1, -(T.tabSize + 25), 1, -66),  
	BackgroundTransparency = 1,  
	Parent                 = winMain,  
})  

local floatIcon = New("TextButton", {  
Size                   = UDim2.new(0, 60, 0, 60),  
Position               = UDim2.new(0, 20, 0.5, 0),  
BackgroundColor3       = Color3.new(1, 1, 1),  
BackgroundTransparency = 1,  
Text                   = "OPEN",  
TextColor3             = Color3.new(0, 0, 0),  
Font                   = Enum.Font.GothamBold,  
TextSize               = 16,  
Parent                 = GUI,

})

Cor(floatIcon, 12)
Stk(floatIcon, Color3.new(0, 0, 0), 2.5)

if icon ~= "" then
New("ImageLabel", {
Size                   = UDim2.new(0.8, 0, 0.8, 0),
AnchorPoint            = Vector2.new(0.5, 0.5),
Position               = UDim2.fromScale(0.5, 0.5),
BackgroundTransparency = 1,
Image                  = icon,
ScaleType              = Enum.ScaleType.Fit,
Parent                 = floatIcon,
})
else
New("TextLabel", {
Size                   = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
Text                   = title:sub(1, 1):upper(),
TextColor3             = T.acc,
Font                   = Enum.Font.GothamBold,
TextSize               = 28,
Parent                 = floatIcon,
})
end

local winOpen = false

local function toggleWindow()
		winOpen = not winOpen
		if winOpen then
			winMain.Visible  = true
			winMain.Position = UDim2.fromScale(0.5, 1.5)
			TW(winMain, 0.4, { Position = UDim2.fromScale(0.5, 0.5) })
		else
			local a = TW(winMain, 0.4, { Position = UDim2.fromScale(0.5, 1.5) })
			a.Completed:Connect(function()
				if not winOpen then winMain.Visible = false end
			end)
		end
	end
	floatIcon.MouseButton1Click:Connect(toggleWindow)
	closeBtn.MouseButton1Click:Connect(toggleWindow)

	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == key then toggleWindow() end
	end)

local function makeDraggable(handle, target)  
	local dragStart, startPos, dragging  
	handle.InputBegan:Connect(function(i)  
		if i.UserInputType == Enum.UserInputType.MouseButton1  
		or i.UserInputType == Enum.UserInputType.Touch then  
			dragging  = true  
			dragStart = i.Position  
			startPos  = target.Position  
		end  
	end)  
	UserInputService.InputChanged:Connect(function(i)  
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement  
		or i.UserInputType == Enum.UserInputType.Touch) then  
			local d = i.Position - dragStart  
			target.Position = UDim2.new(  
				startPos.X.Scale, startPos.X.Offset + d.X,  
				startPos.Y.Scale, startPos.Y.Offset + d.Y  
			)  
		end  
	end)  
	handle.InputEnded:Connect(function() dragging = false end)  
end  
makeDraggable(floatIcon, floatIcon)  
makeDraggable(titleBar, winMain)  

local pages  = {}  
local Window = {}  

function Window:Tab(tabCfg)  
	tabCfg = tabCfg or {}  
	local nm     = tabCfg.Name or "Tab"  
	local iconId = tabCfg.Icon or ""  

	local page = New("ScrollingFrame", {  
		Size                   = UDim2.fromScale(1, 1),  
		BackgroundTransparency = 1,  
		Visible                = false,  
		ScrollBarThickness     = 0,  
		AutomaticCanvasSize    = Enum.AutomaticSize.Y,  
		Parent                 = contentArea,  
	})  
	List(page, Enum.FillDirection.Vertical, 16)  
	Pad(page, 2, 10, 5, 5)  
	pages[nm] = page  

	local b = New("TextButton", {  
		Size                   = UDim2.new(1, 0, 0, 58),  
		BackgroundTransparency = 1,  
		Text                   = "",  
		Parent                 = sidebar,  
	})  
	Cor(b, 8)  
	local btnBg = New("Frame", {  
		Size                   = UDim2.fromScale(1, 1),  
		BackgroundColor3       = T.panel2,  
		BackgroundTransparency = 0.15,  
		Parent                 = b,  
	})  
	Cor(btnBg, 8)  
	local stroke = New("UIStroke", {  
		Color           = T.border,  
		Thickness       = 2,  
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,  
		Parent          = btnBg,  
	})  
	local iconLabel = New("ImageLabel", {  
		Size                   = UDim2.new(0, T.iconSize, 0, T.iconSize),  
		Position               = UDim2.new(0, 12, 0.5, 0),  
		AnchorPoint            = Vector2.new(0, 0.5),  
		BackgroundTransparency = 1,  
		Image                  = iconId,  
		ImageColor3            = T.muted,  
		ZIndex                 = 2,  
		Parent                 = btnBg,  
	})  
	local txtLabel = New("TextLabel", {  
		Size                   = UDim2.new(1, -(T.iconSize + 30), 1, 0),  
		Position               = UDim2.new(0, T.iconSize + 20, 0, 0),  
		BackgroundTransparency = 1,  
		Text                   = nm,  
		TextColor3             = T.muted,  
		Font                   = Enum.Font.GothamBold,  
		TextSize               = 16,  
		TextXAlignment         = Enum.TextXAlignment.Left,  
		Parent                 = btnBg,  
	})  

	b.MouseButton1Click:Connect(function()  
    playTabSound()  

for _, obj in ipairs(sidebar:GetChildren()) do  
			if obj:IsA("TextButton") then  
				local bg = obj:FindFirstChildOfClass("Frame")  
				if bg then  
					TW(bg, 0.2, { BackgroundTransparency = 0.3 })  
					local s2  = bg:FindFirstChildOfClass("UIStroke")  
					local img = bg:FindFirstChildOfClass("ImageLabel")  
					local lbl = bg:FindFirstChildOfClass("TextLabel")  
					if s2  then TW(s2,  0.2, { Color = T.border, Thickness = 2 }) end  
					if img then TW(img, 0.2, { ImageColor3 = T.muted }) end  
					if lbl then TW(lbl, 0.2, { TextColor3  = T.muted }) end  
				end  
			end  
		end  
		for name, pg in pairs(pages) do pg.Visible = (name == nm) end  
		TW(stroke,    0.2, { Color = T.acc, Thickness = 2.5 })  
		TW(iconLabel, 0.2, { ImageColor3 = T.acc })  
		TW(txtLabel,  0.2, { TextColor3  = T.acc })  
		TW(btnBg,     0.2, { BackgroundTransparency = 0.1 })  
	end)  

	local tabCount = 0  
	for _ in pairs(pages) do tabCount += 1 end  
	if tabCount == 1 then  
		page.Visible                  = true  
		stroke.Color                  = T.acc  
		iconLabel.ImageColor3         = T.acc  
		txtLabel.TextColor3           = T.acc  
		btnBg.BackgroundTransparency  = 0.1  
	end  

	local Tab = {}  

	function Tab:Section(ttl)  
		local container = New("Frame", {  
			Size                   = UDim2.new(1, 0, 0, 0),  
			AutomaticSize          = Enum.AutomaticSize.Y,  
			BackgroundTransparency = 1,  
			Parent                 = page,  
		})  
		List(container, Enum.FillDirection.Vertical, 8)  

		local titleBox = New("Frame", {  
			Size             = UDim2.new(1, 0, 0, 28),  
			BackgroundColor3 = T.panel2,  
			Parent           = container,  
		})  
		Cor(titleBox, 8)  
		Stk(titleBox, Color3.fromRGB(0,0,0), 2)  
		New("TextLabel", {  
			Size                   = UDim2.new(1, -10, 1, 0),  
			Position               = UDim2.new(0, 10, 0, 0),  
			BackgroundTransparency = 1,  
			Text                   = tostring(ttl):upper(),  
			TextColor3             = T.acc,  
			Font                   = Enum.Font.GothamBold,  
			TextSize               = 13,  
			TextXAlignment         = Enum.TextXAlignment.Left,  
			Parent                 = titleBox,  
		})  

		local Section = {}  

		function Section:Toggle(cfg)  
			cfg = cfg or {}  
			local lbl = cfg.Name     or "Toggle"  
			local def = cfg.Default  or false  
			local cb  = cfg.Callback or function() end  

			local row = New("Frame", {  
            Size             = UDim2.new(1, 0, 0, 55),  
            BackgroundColor3 = T.panel2,  
            Parent           = container,  
            })  
            Cor(row, 10)  
            Stk(row, T.border, 1.2) -- <--- Cambiado de Negro a Gris  

			New("TextLabel", {  
				Position               = UDim2.new(0, 12, 0, 0),  
				Size                   = UDim2.new(1, -70, 1, 0),  
				BackgroundTransparency = 1,  
				Text                   = lbl,  
				TextColor3             = T.text,  
				Font                   = Enum.Font.GothamMedium,  
				TextSize               = 14,  
				TextXAlignment         = Enum.TextXAlignment.Left,  
				Parent                 = row,  
			})  

			local switchBg = New("Frame", {  
				AnchorPoint      = Vector2.new(1, 0.5),  
				Position         = UDim2.new(1, -12, 0.5, 0),  
				Size             = UDim2.new(0, 50, 0, 26),  
				BackgroundColor3 = def and T.green or T.red,  
				Parent           = row,  
			})  
			Cor(switchBg, 6)  
			Stk(switchBg, Color3.new(0,0,0), 1.5)  

			local knob = New("Frame", {  
				Size             = UDim2.new(0, 18, 0, 18),  
				Position         = def and UDim2.new(1,-22,0.5,-9) or UDim2.new(0,4,0.5,-9),  
				BackgroundColor3 = Color3.new(1,1,1),  
				Parent           = switchBg,  
			})  
			Cor(knob, 4)  

			local click = New("TextButton", {  
				Size                   = UDim2.fromScale(1,1),  
				BackgroundTransparency = 1,  
				Text                   = "",  
				Parent                 = row,  
			})  
			click.MouseButton1Click:Connect(function()

	playToggleSound()

	def = not def  

	Notify(def and "Activado" or "Desactivado")

	TW(switchBg, 0.2, { 
		BackgroundColor3 = def and T.green or T.red 
	})  

	TW(knob, 0.2, { 
		Position = def 
			and UDim2.new(1,-22,0.5,-9) 
			or UDim2.new(0,4,0.5,-9) 
	})  

	cb(def)

end)
			local obj = {}  
			function obj:Set(val)  
				def = val  
				TW(switchBg, 0.2, { BackgroundColor3 = def and T.green or T.red })  
				TW(knob,     0.2, { Position = def and UDim2.new(1,-22,0.5,-9) or UDim2.new(0,4,0.5,-9) })  
				cb(def)  
			end  
			function obj:Get() return def end  
			return obj  
		end  

		function Section:Slider(cfg)  
			cfg = cfg or {}  
			local lbl = cfg.Name     or "Slider"  
			local mn  = cfg.Min      or 0  
			local mx  = cfg.Max      or 100  
			local def = cfg.Default  or mn  
			local cb  = cfg.Callback or function() end  

			local row = New("Frame", {  
				Size             = UDim2.new(1, 0, 0, 65),  
				BackgroundColor3 = T.panel2,  
				Parent           = container,  
			})  
			Cor(row, 8)  
			Stk(row, Color3.fromRGB(0,0,0), 2)  

			New("TextLabel", {  
				Size                   = UDim2.new(1, 0, 0, 20),  
				Position               = UDim2.new(0, 12, 0, 6),  
				BackgroundTransparency = 1,  
				Text                   = lbl,  
				TextColor3             = T.text,  
				Font                   = Enum.Font.GothamBold,  
				TextSize               = 13,  
				TextXAlignment         = Enum.TextXAlignment.Left,  
				Parent                 = row,  
			})  

			local btnMinus = New("TextButton", {  
				Position         = UDim2.new(0, 12, 0, 28),  
				Size             = UDim2.new(0, 26, 0, 26),  
				BackgroundColor3 = T.panel,  
				Text             = "-",  
				TextColor3       = T.text,  
				Font             = Enum.Font.GothamBold,  
				TextSize         = 18,  
				Parent           = row,  
			})  
			styleButton(btnMinus)  

			local valueBox = New("Frame", {  
				Position         = UDim2.new(0, 46, 0, 28),  
				Size             = UDim2.new(0, 80, 0, 26),  
				BackgroundColor3 = T.panel,  
				Parent           = row,  
			})  
			Cor(valueBox, 6)  
			Stk(valueBox, Color3.fromRGB(0,0,0), 2)  

			local valText = New("TextLabel", {  
				Size                   = UDim2.fromScale(1,1),  
				BackgroundTransparency = 1,  
				Text                   = tostring(def),  
				TextColor3             = T.acc,  
				Font                   = Enum.Font.GothamBold,  
				TextSize               = 13,  
				Parent                 = valueBox,  
			})  

			local btnPlus = New("TextButton", {  
				Position         = UDim2.new(0, 134, 0, 28),  
				Size             = UDim2.new(0, 26, 0, 26),  
				BackgroundColor3 = T.panel,  
				Text             = "+",  
				TextColor3       = T.text,  
				Font             = Enum.Font.GothamBold,  
				TextSize         = 18,  
				Parent           = row,  
			})  
			styleButton(btnPlus)  

			local dragging, startX, startVal = false, 0, def  

			local function changeValue(delta)  
				local newVal = math.clamp(tonumber(valText.Text) + delta, mn, mx)  
				if newVal ~= tonumber(valText.Text) then  
					valText.Text = tostring(newVal)  
					cb(newVal)  
				end  
			end  

			btnMinus.MouseButton1Click:Connect(function() changeValue(-1) end)  
			btnPlus.MouseButton1Click:Connect(function()  changeValue( 1) end)  

			valueBox.InputBegan:Connect(function(i)  
				if i.UserInputType == Enum.UserInputType.MouseButton1  
				or i.UserInputType == Enum.UserInputType.Touch then  
					dragging = true  
					startX   = i.Position.X  
					startVal = tonumber(valText.Text)  
				end  
			end)  
			UserInputService.InputChanged:Connect(function(i)  
				if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement  
				or i.UserInputType == Enum.UserInputType.Touch) then  
					local newVal = math.clamp(math.floor(startVal + (i.Position.X - startX) * ((mx - mn) / 300)), mn, mx)  
					if tonumber(valText.Text) ~= newVal then  
						valText.Text = tostring(newVal)  
						cb(newVal)  
					end  
				end  
			end)  
			UserInputService.InputEnded:Connect(function() dragging = false end)  

			local obj = {}  
			function obj:Set(val)  
				val = math.clamp(val, mn, mx)  
				valText.Text = tostring(val)  
				cb(val)  
			end  
			function obj:Get() return tonumber(valText.Text) end  
			return obj  
		end  

		function Section:LineSlider(cfg)  
			cfg = cfg or {}  
			local lbl = cfg.Name     or "Slider"  
			local mn  = cfg.Min      or 0  
			local mx  = cfg.Max      or 100  
			local def = cfg.Default  or mn  
			local cb  = cfg.Callback or function() end  

			local row = New("Frame", {  
				Size             = UDim2.new(1, 0, 0, 65),  
				BackgroundColor3 = T.panel2,  
				Parent           = container,  
			})  
			Cor(row, 8)  
			Stk(row, Color3.fromRGB(0,0,0), 2)  

			New("TextLabel", {  
				Size                   = UDim2.new(1, 0, 0, 20),  
				Position               = UDim2.new(0, 12, 0, 6),  
				BackgroundTransparency = 1,  
				Text                   = lbl,  
				TextColor3             = T.text,  
				Font                   = Enum.Font.GothamBold,  
				TextSize               = 13,  
				TextXAlignment         = Enum.TextXAlignment.Left,  
				Parent                 = row,  
			})  

			local track = New("Frame", {  
				Position         = UDim2.new(0, 12, 0, 36),  
				Size             = UDim2.new(1, -170, 0, 4),  
				BackgroundColor3 = T.panel,  
				Parent           = row,  
			})  
			Cor(track, 4)  

			local t0   = (def - mn) / (mx - mn)  
			local fill = New("Frame", {  
				BackgroundColor3 = T.acc,  
				Size             = UDim2.new(t0, 0, 1, 0),  
				Parent           = track,  
			})  
			Cor(fill, 4)  

			local thumb = New("TextButton", {  
				Position         = UDim2.new(t0, -10, 0.5, -10),  
				Size             = UDim2.new(0, 20, 0, 20),  
				BackgroundColor3 = T.acc,  
				Text             = "",  
				Parent           = track,  
			})  
			Cor(thumb, 10)  

			local btnMinus = New("TextButton", {  
				Position         = UDim2.new(1, -145, 0, 25),  
				Size             = UDim2.new(0, 26, 0, 26),  
				BackgroundColor3 = T.panel,  
				Text             = "-",  
				TextColor3       = T.text,  
				Font             = Enum.Font.GothamBold,  
				TextSize         = 18,  
				Parent           = row,  
			})  
			styleButton(btnMinus)  

			local valueBox = New("Frame", {  
				Position         = UDim2.new(1, -112, 0, 25),  
				Size             = UDim2.new(0, 50, 0, 26),  
				BackgroundColor3 = T.panel,  
				Parent           = row,  
			})  
			Cor(valueBox, 6)  
			Stk(valueBox, Color3.fromRGB(0,0,0), 2)  

			local valueLabel = New("TextLabel", {  
				Size                   = UDim2.fromScale(1,1),  
				BackgroundTransparency = 1,  
				Text                   = tostring(def),  
				TextColor3             = T.acc,  
				Font                   = Enum.Font.GothamBold,  
				TextSize               = 13,  
				Parent                 = valueBox,  
			})  

			local btnPlus = New("TextButton", {  
				Position         = UDim2.new(1, -55, 0, 25),  
				Size             = UDim2.new(0, 26, 0, 26),  
				BackgroundColor3 = T.panel,  
				Text             = "+",  
				TextColor3       = T.text,  
				Font             = Enum.Font.GothamBold,  
				TextSize         = 18,  
				Parent           = row,  
			})  
			styleButton(btnPlus)  

			local dragging = false  

			local function applyVal(newVal)  
				newVal = math.clamp(newVal, mn, mx)  
				if tonumber(valueLabel.Text) == newVal then return end  
				valueLabel.Text = tostring(newVal)  
				local t = (newVal - mn) / (mx - mn)  
				fill.Size      = UDim2.new(t, 0, 1, 0)  
				thumb.Position = UDim2.new(t, -10, 0.5, -10)  
				cb(newVal)  
			end  

			local function updateFromX(posX)  
				local t = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)  
				applyVal(math.floor(mn + t * (mx - mn)))  
			end  

			local function onStart(input)  
				if input.UserInputType == Enum.UserInputType.MouseButton1  
				or input.UserInputType == Enum.UserInputType.Touch then  
					dragging = true  
					updateFromX(input.Position.X)  
				end  
			end  
			thumb.InputBegan:Connect(onStart)  
			track.InputBegan:Connect(onStart)  
			UserInputService.InputChanged:Connect(function(i)  
				if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement  
				or i.UserInputType == Enum.UserInputType.Touch) then  
					updateFromX(i.Position.X)  
				end  
			end)  
			UserInputService.InputEnded:Connect(function() dragging = false end)  
			btnMinus.MouseButton1Click:Connect(function() applyVal(tonumber(valueLabel.Text) - 1) end)  
			btnPlus.MouseButton1Click:Connect(function()  applyVal(tonumber(valueLabel.Text) + 1) end)  

			local obj = {}  
			function obj:Set(val) applyVal(val) end  
			function obj:Get() return tonumber(valueLabel.Text) end  
			return obj  
		end  

		function Section:Button(cfg)  
			cfg = cfg or {}  
			local lbl = cfg.Name     or "Button"  
			local cb  = cfg.Callback or function() end  

			local btn = New("TextButton", {  
				Size             = UDim2.new(1, 0, 0, 40),  
				BackgroundColor3 = T.panel,  
				Text             = lbl,  
				TextColor3       = T.text,  
				Font             = Enum.Font.GothamBold,  
				TextSize         = 14,  
				Parent           = container,  
			})  
			Cor(btn, 8)  
			Stk(btn, Color3.fromRGB(0,0,0), 2)  
			btn.MouseEnter:Connect(function() TW(btn, 0.15, { BackgroundColor3 = T.acc }) end)  
			btn.MouseLeave:Connect(function()  TW(btn, 0.15, { BackgroundColor3 = T.panel }) end)  
			btn.MouseButton1Click:Connect(function()  
				TW(btn, 0.08, { BackgroundColor3 = Color3.fromRGB(255,60,60) })  
				task.delay(0.12, function() TW(btn, 0.15, { BackgroundColor3 = T.panel }) end)  
				cb()  
			end)  
		end  

		return Section  
	end  

	function Tab:Label(text)  
		local container = New("Frame", {  
			Size             = UDim2.new(1, 0, 0, 28),  
			BackgroundColor3 = T.panel2,  
			Parent           = page,  
		})  
		Cor(container, 8)  
		Stk(container, Color3.fromRGB(0,0,0), 2)  
		New("TextLabel", {  
			Size                   = UDim2.new(1, -10, 1, 0),  
			Position               = UDim2.new(0, 10, 0, 0),  
			BackgroundTransparency = 1,  
			Text                   = tostring(text):upper(),  
			TextColor3             = T.acc,  
			Font                   = Enum.Font.GothamBold,  
			TextSize               = 13,  
			TextXAlignment         = Enum.TextXAlignment.Left,  
			Parent                 = container,  
		})  
	end  

	return Tab  
end  

function Window:SetSize(w, h)  
	winMain.Size = UDim2.new(0, w, 0, h or math.floor(w * 0.53))  
end  

return Window

end

return LeehHub
