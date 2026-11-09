-- OnyxLib.lua
local OnyxLib = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

local CoreGui = (function()
    if gethui then local ok, h = pcall(gethui) if ok and h then return h end end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end)()

local Themes = {
    purple = {
        Name = "purple", MainColor = Color3.fromRGB(150, 100, 255), MainColorLight = Color3.fromRGB(200, 150, 255),
        BgDeep = Color3.fromRGB(25, 15, 35), BgMain = Color3.fromRGB(30, 20, 40), BgPanel = Color3.fromRGB(40, 30, 55),
        BgItem = Color3.fromRGB(35, 25, 45), BgHover = Color3.fromRGB(45, 35, 55), BgTabOff = Color3.fromRGB(50, 40, 65),
        BgTabOn = Color3.fromRGB(80, 60, 100), BgToggleOff = Color3.fromRGB(60, 50, 70), BgIcon = Color3.fromRGB(60, 45, 80),
        BgIconHover = Color3.fromRGB(80, 65, 100), BgOpenCloseOff = Color3.fromRGB(50, 35, 65), BgScrollbar = Color3.fromRGB(120, 100, 150),
        BgGradientStart = Color3.fromRGB(50, 40, 70), BgGradientEnd = Color3.fromRGB(35, 25, 50), BgTaskHover = Color3.fromRGB(50, 40, 75),
        TextMain = Color3.fromRGB(245, 235, 255), TextBright = Color3.fromRGB(250, 240, 255), TextSub = Color3.fromRGB(220, 210, 230),
        TextDim = Color3.fromRGB(200, 200, 200), TextLabel = Color3.fromRGB(240, 230, 250),
    },
    negro = {
        Name = "negro", MainColor = Color3.fromRGB(160, 160, 160), MainColorLight = Color3.fromRGB(210, 210, 210),
        BgDeep = Color3.fromRGB(15, 15, 15), BgMain = Color3.fromRGB(20, 20, 20), BgPanel = Color3.fromRGB(32, 32, 32),
        BgItem = Color3.fromRGB(28, 28, 28), BgHover = Color3.fromRGB(42, 42, 42), BgTabOff = Color3.fromRGB(42, 42, 42),
        BgTabOn = Color3.fromRGB(85, 85, 85), BgToggleOff = Color3.fromRGB(55, 55, 55), BgIcon = Color3.fromRGB(55, 55, 55),
        BgIconHover = Color3.fromRGB(75, 75, 75), BgOpenCloseOff = Color3.fromRGB(45, 45, 45), BgScrollbar = Color3.fromRGB(100, 100, 100),
        BgGradientStart = Color3.fromRGB(45, 45, 45), BgGradientEnd = Color3.fromRGB(25, 25, 25), BgTaskHover = Color3.fromRGB(55, 55, 55),
        TextMain = Color3.fromRGB(240, 240, 240), TextBright = Color3.fromRGB(255, 255, 255), TextSub = Color3.fromRGB(200, 200, 200),
        TextDim = Color3.fromRGB(180, 180, 180), TextLabel = Color3.fromRGB(230, 230, 230),
    },
}

OnyxLib.Theme = Themes.purple
OnyxLib.GuiRefs = { ScreenGui = nil, OpenCloseGui = nil, MainFrame = nil, TabButtonsContainer = nil, ContentFrame = nil, Tabs = {} }
OnyxLib.NotificationsList = {}

local function createInstance(className, parent, props)
    local inst = Instance.new(className, parent)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function createStaticStroke(parent)
    local s = createInstance("UIStroke", parent, { Thickness = 2, Color = Color3.fromRGB(255, 255, 255), Transparency = 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
    createInstance("UIGradient", s, {
        Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, OnyxLib.Theme.MainColor), ColorSequenceKeypoint.new(0.3, OnyxLib.Theme.MainColor), ColorSequenceKeypoint.new(0.7, OnyxLib.Theme.MainColor), ColorSequenceKeypoint.new(1, OnyxLib.Theme.MainColor) }),
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(0.8, 0.8), NumberSequenceKeypoint.new(1, 1) }),
        Rotation = 0,
    })
    return s
end

function OnyxLib.createWithStaticStroke(className, parent, props)
    local inst = createInstance(className, parent, props)
    if className == "Frame" or className == "TextButton" or className == "ScrollingFrame" then createStaticStroke(inst) end
    return inst
end

function OnyxLib.playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://138656262630730"
    sound.Volume = 0.7
    sound.Parent = SoundService
    sound:Play()
    Debris:AddItem(sound, 2)
end

function OnyxLib.showNotification(title, message, duration)
    duration = duration or 5
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://106553517979212"
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    Debris:AddItem(sound, 3)

    if not OnyxLib.GuiRefs.ScreenGui then
        OnyxLib.GuiRefs.ScreenGui = createInstance("ScreenGui", CoreGui, { Name = "MM2GUI", ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false, DisplayOrder = 100 })
    end

    local function reposition()
        for i, n in ipairs(OnyxLib.NotificationsList) do
            if n and n.Parent then
                local total = #OnyxLib.NotificationsList
                TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -300, 1, -105 - (total - i) * 85) }):Play()
            end
        end
    end

    local function dismiss(frame)
        local idx = table.find(OnyxLib.NotificationsList, frame)
        if idx then
            table.remove(OnyxLib.NotificationsList, idx)
            frame:TweenPosition(UDim2.new(1, 300, frame.Position.Y.Scale, frame.Position.Y.Offset), "In", "Quad", 0.4, true, function()
                frame:Destroy()
                reposition()
            end)
        end
    end

    if #OnyxLib.NotificationsList >= 5 then
        local oldest = OnyxLib.NotificationsList[1]
        if oldest then dismiss(oldest) task.wait(0.1) end
    end

    local card = OnyxLib.createWithStaticStroke("Frame", OnyxLib.GuiRefs.ScreenGui, {
        Name = "Notification", Size = UDim2.new(0, 280, 0, 75), Position = UDim2.new(1, 20, 1, -105),
        BackgroundColor3 = OnyxLib.Theme.BgDeep, BackgroundTransparency = 0.1, ZIndex = 100, ClipsDescendants = true,
    })
    createInstance("UICorner", card, { CornerRadius = UDim.new(0, 10) })

    createInstance("TextLabel", card, { Text = title, Size = UDim2.new(1, -40, 0, 22), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, TextColor3 = OnyxLib.Theme.MainColor, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101 })
    createInstance("TextLabel", card, { Text = message, Size = UDim2.new(1, -40, 0, 28), Position = UDim2.new(0, 10, 0, 28), BackgroundTransparency = 1, TextColor3 = OnyxLib.Theme.TextMain, TextSize = 13, Font = Enum.Font.Gotham, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, RichText = true, ZIndex = 101 })

    local progressBg = createInstance("Frame", card, { Name = "ProgressContainer", Size = UDim2.new(1, -70, 0, 3), Position = UDim2.new(0, 10, 1, -10), BackgroundColor3 = OnyxLib.Theme.BgPanel, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 102 })
    createInstance("UICorner", progressBg, { CornerRadius = UDim.new(1, 0) })
    local progressFill = createInstance("Frame", progressBg, { Name = "ProgressBar", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = OnyxLib.Theme.MainColor, BorderSizePixel = 0, ZIndex = 103 })
    createInstance("UICorner", progressFill, { CornerRadius = UDim.new(1, 0) })

    local timeText = createInstance("TextLabel", card, { Name = "TimeText", Size = UDim2.new(0, 40, 0, 14), Position = UDim2.new(1, -50, 1, -20), BackgroundTransparency = 1, Text = tostring(duration) .. "s", TextColor3 = OnyxLib.Theme.TextSub, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 102 })

    local closeBtn = createInstance("TextButton", card, { Name = "CloseButton", Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -28, 0, 6), BackgroundColor3 = OnyxLib.Theme.BgIcon, BackgroundTransparency = 0.3, Text = "×", TextColor3 = OnyxLib.Theme.TextSub, TextSize = 18, Font = Enum.Font.GothamBold, ZIndex = 105, AutoButtonColor = false })
    createInstance("UICorner", closeBtn, { CornerRadius = UDim.new(1, 0) })

    closeBtn.MouseButton1Click:Connect(function() OnyxLib.playClickSound() dismiss(card) end)
    table.insert(OnyxLib.NotificationsList, card)
    reposition()

    local startTime = tick()
    local c1, c2
    c1 = RunService.Heartbeat:Connect(function()
        if not card or not card.Parent then c1:Disconnect() return end
        local elapsed = tick() - startTime
        local ratio = math.max(0, duration - elapsed) / duration
        progressFill.Size = UDim2.new(ratio, 0, 1, 0)
        progressFill.BackgroundColor3 = ratio < 0.3 and Color3.fromRGB(OnyxLib.Theme.MainColor.R * 255 * (math.sin(tick() * 8) * 0.3 + 0.7), OnyxLib.Theme.MainColor.G * 255 * (math.sin(tick() * 8) * 0.3 + 0.7), OnyxLib.Theme.MainColor.B * 255 * (math.sin(tick() * 8) * 0.3 + 0.7)) or OnyxLib.Theme.MainColor
    end)
    c2 = RunService.Heartbeat:Connect(function()
        if not card or not card.Parent then c2:Disconnect() return end
        timeText.Text = math.ceil(math.max(0, duration - (tick() - startTime))) .. "s"
    end)

    task.delay(duration, function()
        if card and card.Parent then dismiss(card) end
        if c1 then c1:Disconnect() end
        if c2 then c2:Disconnect() end
    end)
    return card
end

function OnyxLib.createToggle(parent, text, yPos, stateTable, stateKey, callback)
    local card = OnyxLib.createWithStaticStroke("Frame", parent, { Name = text .. "Toggle", Size = UDim2.new(1, -20, 0, 45), Position = UDim2.new(0, 10, 0, yPos), BackgroundColor3 = OnyxLib.Theme.BgItem, BackgroundTransparency = 0.5, ZIndex = 5 })
    createInstance("UICorner", card, { CornerRadius = UDim.new(0, 8) })
    createInstance("TextLabel", card, { Text = text, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = OnyxLib.Theme.TextMain, TextSize = 14, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 })

    local track = createInstance("Frame", card, { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -55, 0.5, -10), BackgroundColor3 = stateTable[stateKey] and OnyxLib.Theme.MainColor or OnyxLib.Theme.BgToggleOff, ZIndex = 6 })
    createInstance("UICorner", track, { CornerRadius = UDim.new(1, 0) })
    local knob = createInstance("Frame", track, { Size = UDim2.new(0, 16, 0, 16), Position = stateTable[stateKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 7 })
    createInstance("UICorner", knob, { CornerRadius = UDim.new(1, 0) })

    local btn = createInstance("TextButton", card, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 8 })
    btn.MouseButton1Click:Connect(function()
        stateTable[stateKey] = not stateTable[stateKey]
        local on = stateTable[stateKey]
        TweenService:Create(track, TweenInfo.new(0.3), { BackgroundColor3 = on and OnyxLib.Theme.MainColor or OnyxLib.Theme.BgToggleOff }):Play()
        TweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play()
        TweenService:Create(card, TweenInfo.new(0.1), { Size = UDim2.new(1, -20, 0, 43) }):Play()
        task.wait(0.1)
        TweenService:Create(card, TweenInfo.new(0.1), { Size = UDim2.new(1, -20, 0, 45) }):Play()
        if callback then task.spawn(callback, on) end
        OnyxLib.playClickSound()
    end)
    btn.MouseEnter:Connect(function() TweenService:Create(card, TweenInfo.new(0.2), { BackgroundColor3 = OnyxLib.Theme.BgHover, BackgroundTransparency = 0.3 }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(card, TweenInfo.new(0.2), { BackgroundColor3 = OnyxLib.Theme.BgItem, BackgroundTransparency = 0.5 }):Play() end)
    return card, btn
end

function OnyxLib.createSlider(fill, valueLabel, minVal, maxVal, initVal, callback)
    local dragging = false
    local curVal = initVal or minVal
    local initRatio = (initVal - minVal) / (maxVal - minVal)

    local thumb = createInstance("Frame", fill.Parent, { Name = "SliderThumb", Size = UDim2.new(0, 20, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(initRatio, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 15 })
    createInstance("UICorner", thumb, { CornerRadius = UDim.new(1, 0) })
    createInstance("UIStroke", thumb, { Thickness = 2, Color = OnyxLib.Theme.MainColor })
    fill.Size = UDim2.new(initRatio, 0, 1, 0)

    local function applyFromInput(input)
        local barLeft = fill.Parent.AbsolutePosition.X
        local width = fill.Parent.AbsoluteSize.X
        if width <= 0 then return end
        local ratio = math.clamp((input.Position.X - barLeft) / width, 0, 1)
        local rounded = math.floor(minVal + (maxVal - minVal) * ratio + 0.5)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        thumb.Position = UDim2.new(ratio, 0, 0.5, 0)
        valueLabel.Text = tostring(rounded)
        curVal = rounded
        if callback then callback(rounded) end
    end

    local btn = createInstance("TextButton", fill.Parent, { Name = "SliderButton", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", AutoButtonColor = false, ZIndex = 10 })
    local thumbBtn = createInstance("TextButton", thumb, { Name = "ThumbButton", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", AutoButtonColor = false, ZIndex = 20 })

    local function onBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            thumb.BackgroundColor3 = OnyxLib.Theme.MainColorLight
            fill.BackgroundColor3 = OnyxLib.Theme.MainColor
            applyFromInput(input)
        end
    end

    btn.InputBegan:Connect(onBegan)
    thumbBtn.InputBegan:Connect(onBegan)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then applyFromInput(input) end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            fill.BackgroundColor3 = OnyxLib.Theme.BgTabOn
        end
    end)

    local function setValue(v)
        local clamped = math.clamp(v, minVal, maxVal)
        local ratio = (clamped - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        thumb.Position = UDim2.new(ratio, 0, 0.5, 0)
        valueLabel.Text = tostring(clamped)
        curVal = clamped
        if callback then callback(clamped) end
    end
    setValue(initVal)
    return { setValue = setValue, getValue = function() return curVal end, thumb = thumb }
end

function OnyxLib.createTabButton(parent, text, yPos, tabName, contentFrame)
    local frame = OnyxLib.createWithStaticStroke("Frame", parent, { BorderSizePixel = 0, BackgroundColor3 = OnyxLib.Theme.BgTabOff, Size = UDim2.new(0, 116, 0, 48), Position = UDim2.new(0, 4, 0, yPos), Name = "Tab_" .. tabName, BackgroundTransparency = 0.7, ZIndex = 12 })
    createInstance("UICorner", frame, { CornerRadius = UDim.new(0, 5) })
    local btn = createInstance("TextButton", frame, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Name = "TabButton_" .. tabName, ZIndex = 15 })
    local label = createInstance("TextLabel", frame, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = OnyxLib.Theme.TextLabel, Font = Enum.Font.GothamMedium, TextSize = 13, TextWrapped = true, ZIndex = 13 })
    local scroll = createInstance("ScrollingFrame", contentFrame, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Name = "content_" .. tabName, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 4, ScrollBarImageColor3 = OnyxLib.Theme.BgScrollbar, CanvasSize = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, ZIndex = 5 })
    local inner = createInstance("Frame", scroll, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Name = "contentContainer_" .. tabName, ZIndex = 5 })
    return btn, frame, inner, label, scroll
end

function OnyxLib.init()
    OnyxLib.GuiRefs.ScreenGui = createInstance("ScreenGui", CoreGui, { Name = "MM2GUI", ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false, DisplayOrder = 100 })
    OnyxLib.GuiRefs.OpenCloseGui = createInstance("ScreenGui", CoreGui, { Name = "MM2OpenCloseGUI", ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false, DisplayOrder = 99 })

    local openFrame = OnyxLib.createWithStaticStroke("Frame", OnyxLib.GuiRefs.OpenCloseGui, { BorderSizePixel = 0, BackgroundColor3 = OnyxLib.Theme.BgMain, Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 20, 0, 20), Name = "open close", BackgroundTransparency = 0.5, ZIndex = 5 })
    createInstance("UICorner", openFrame, { CornerRadius = UDim.new(0, 8) })
    local openBtn = createInstance("TextButton", openFrame, { Name = "OpenCloseButton", Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 6 })
    
    openBtn.MouseButton1Click:Connect(function()
        OnyxLib.playClickSound()
        OnyxLib.GuiRefs.MainFrame.Visible = not OnyxLib.GuiRefs.MainFrame.Visible
        openFrame.BackgroundColor3 = OnyxLib.GuiRefs.MainFrame.Visible and OnyxLib.Theme.BgMain or OnyxLib.Theme.BgOpenCloseOff
    end)
    openBtn.MouseEnter:Connect(function() openFrame.BackgroundColor3 = OnyxLib.GuiRefs.MainFrame.Visible and OnyxLib.Theme.BgHover or OnyxLib.Theme.BgIconHover end)
    openBtn.MouseLeave:Connect(function() openFrame.BackgroundColor3 = OnyxLib.GuiRefs.MainFrame.Visible and OnyxLib.Theme.BgMain or OnyxLib.Theme.BgOpenCloseOff end)

    OnyxLib.GuiRefs.MainFrame = OnyxLib.createWithStaticStroke("Frame", OnyxLib.GuiRefs.ScreenGui, {
        BorderSizePixel = 0, BackgroundColor3 = OnyxLib.Theme.BgMain, Size = UDim2.new(0, 522, 0, 306),
        Position = UDim2.new(0.5, -261, 0, 15), Name = "mainFrame", BackgroundTransparency = 0.5, Visible = true, ZIndex = 5,
    })
    createInstance("UICorner", OnyxLib.GuiRefs.MainFrame, { CornerRadius = UDim.new(0, 5) })

    OnyxLib.GuiRefs.TabButtonsContainer = OnyxLib.createWithStaticStroke("ScrollingFrame", OnyxLib.GuiRefs.MainFrame, {
        ScrollingDirection = Enum.ScrollingDirection.Y, BorderSizePixel = 0, BackgroundColor3 = OnyxLib.Theme.BgPanel, Name = "tabButtonsContainer",
        Size = UDim2.new(0, 124, 0, 258), Position = UDim2.new(0, 390, 0, 40), ScrollBarThickness = 6, ScrollBarImageColor3 = OnyxLib.Theme.BgScrollbar,
        BackgroundTransparency = 0.3, CanvasSize = UDim2.new(0, 0, 0, 0), ClipsDescendants = true, ZIndex = 10,
    })
    createInstance("UICorner", OnyxLib.GuiRefs.TabButtonsContainer, { CornerRadius = UDim.new(0, 5) })

    OnyxLib.GuiRefs.ContentFrame = OnyxLib.createWithStaticStroke("Frame", OnyxLib.GuiRefs.MainFrame, {
        BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 376, 0, 258), Position = UDim2.new(0, 6, 0, 40), Name = "contentFrame", BackgroundTransparency = 1, ZIndex = 5,
    })
    createInstance("UICorner", OnyxLib.GuiRefs.ContentFrame, { CornerRadius = UDim.new(0, 5) })

    local header = OnyxLib.createWithStaticStroke("Frame", OnyxLib.GuiRefs.MainFrame, { BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 510, 0, 26), Position = UDim2.new(0, 6, 0, 6), Name = "header", BackgroundTransparency = 1, ZIndex = 5 })
    createInstance("UICorner", header, { CornerRadius = UDim.new(0, 5) })
    createInstance("TextLabel", header, { BorderSizePixel = 0, TextSize = 16, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextColor3 = OnyxLib.Theme.TextLabel, BackgroundTransparency = 1, Size = UDim2.new(0, 144, 0, 30), Text = "Murder Mystery 2 | OnyxHub", Position = UDim2.new(0, 44, 0, -2), ZIndex = 6 })
end

return OnyxLib
