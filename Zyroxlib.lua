-- Hola muchas gracias


-- [[ ZyroxHub UI Library | iOS Premium VIP Edition (YARHM Style - Springs & Elastic Animations) ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- ================================================================= --
-- 1. MOTOR DE RESORTES (SPRINGS SYSTEM)
-- ================================================================= --
local Spring = {}
Spring.__index = Spring

function Spring.new(mass, damping, constant, initialPos)
    local self = setmetatable({}, Spring)
    self.m = mass or 1
    self.d = damping or 12
    self.k = constant or 20
    self.x = initialPos or 0
    self.v = 0
    self.target = initialPos or 0
    return self
end

function Spring:Update(dt)
    local f = -self.k * (self.x - self.target) - self.d * self.v
    local a = f / self.m
    self.v = self.v + a * dt
    self.x = self.x + self.v * dt
    return self.x
end

function Spring:SetGoal(target)
    self.target = target
end

function Spring:Reset(pos)
    self.x = pos or 0
    self.v = 0
    self.target = pos or 0
end

if game:GetService("CoreGui"):FindFirstChild("DDOS_VENOM") then
    game:GetService("CoreGui").DDOS_VENOM:Destroy()
end

local T = {
    bg = Color3.fromRGB(14, 38, 70),
    panel = Color3.fromRGB(4, 20, 38),
    panel2 = Color3.fromRGB(6, 26, 48),
    border = Color3.fromRGB(0, 166, 255),
    acc = Color3.fromRGB(0, 166, 255),
    text = Color3.fromRGB(255, 255, 255),
    red = Color3.fromRGB(255, 60, 60),
    green = Color3.fromRGB(50, 255, 100),
    sep = Color3.fromRGB(10, 35, 60),
    switchOff = Color3.fromRGB(10, 30, 50),
    bgTrans = 0.1,
    tabSize = 200,
}

local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Cor(obj, r) return New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj }) end
local function Stk(obj, col, th) return New("UIStroke", { Color = col or T.border, Thickness = th or 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = obj }) end
local function List(obj, dir, pad) return New("UIListLayout", { FillDirection = dir or Enum.FillDirection.Vertical, Padding = UDim.new(0, pad or 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = obj }) end
local function Pad(obj, t, b, l, r) New("UIPadding", { PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = obj }) end
local function Tween(obj, t, props, style, dir) 
    local anim = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props) 
    anim:Play() 
    return anim 
end

local function Shadow(obj, transparency, expand)
    return New("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, expand or 24, 1, expand or 24),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.55,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = obj
    })
end

function Library:CreateWindow(hubTitle)
    local self = setmetatable({}, Library)
    self.LogoLocked = false
    self.IsModalOpen = false

    self.GUI = New("ScreenGui", {
        Name = "DDOS_VENOM",
        ResetOnSpawn = false,
        DisplayOrder = 999999999,
        Parent = (gethui and gethui() or game:GetService("CoreGui"))
    })

    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://4590657391"
    clickSound.Volume = 0.5
    clickSound.Parent = self.GUI

    self.GUI.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.MouseButton1Click:Connect(function() clickSound:Play() end)
        end
    end)

    self.NotifLayer = New("Frame", {
        Name = "Notifs",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 260, 0, 10),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 999999995,
        Parent = self.GUI
    })
    List(self.NotifLayer, Enum.FillDirection.Vertical, 8)

    self.FloatIcon = New("TextButton", {
        Name = "FloatIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 140, 0, 42),
        Position = UDim2.new(0.5, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(10, 14, 23),
        BackgroundTransparency = 0.35,
        Text = "Open Menu",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        ZIndex = 999999990,
        Parent = self.GUI
    })
    Cor(self.FloatIcon, 21)

    local lightStroke = New("UIStroke", {
        Name = "LightStroke",
        Thickness = 2.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
        Parent = self.FloatIcon
    })

    New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = lightStroke
    })

    local closeTextLabel = New("TextLabel", {
        Name = "CloseTextAnim",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 140, 0, 42),
        BackgroundTransparency = 1,
        Text = "Open Menu",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextTransparency = 1,
        Visible = false,
        ZIndex = 999999998,
        Parent = self.GUI
    })

    local targetMenuWidth, targetMenuHeight = 620, 360

    self.WinMain = New("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 140, 0, 42),
        BackgroundColor3 = T.bg,
        BackgroundTransparency = T.bgTrans,
        Visible = false,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.GUI
    })
    local winCorner = Cor(self.WinMain, 21)
    self.WinScale = New("UIScale", { Scale = 1, Parent = self.WinMain })

    local winInner = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        Parent = self.WinMain
    })
    Cor(winInner, 32)

    local bgGradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 132, 230)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(16, 66, 132)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 14, 38))
        }),
        Rotation = 45,
        Parent = winInner
    })

    task.spawn(function()
        local t = 0
        while bgGradient and bgGradient.Parent do
            t = t + 0.02
            bgGradient.Rotation = 45 + math.sin(t) * 4
            bgGradient.Offset = Vector2.new(math.sin(t * 0.6) * 0.04, math.cos(t * 0.6) * 0.04)
            task.wait(0.03)
        end
    end)

    local borderStroke = New("UIStroke", {
        Name = "BorderStroke",
        Thickness = 3.2,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = self.WinMain
    })

    local borderGradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = borderStroke
    })
    task.spawn(function()
        while borderGradient and borderGradient.Parent do
            borderGradient.Rotation = (borderGradient.Rotation + 1.2) % 360
            task.wait(0.03)
        end
    end)

    local contentGroup = New("CanvasGroup", {
        Name = "ContentGroup",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 4,
        Parent = winInner
    })
    self.ContentGroup = contentGroup

    local titleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = contentGroup
    })

    New("TextLabel", {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        RichText = true,
        Text = hubTitle or 'Zyrox Scripts <font color="#FFD700">V1.01</font>',
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = titleBar
    })

    self.Sidebar = New("ScrollingFrame", {
        Position = UDim2.new(0, 6, 0, 50),
        Size = UDim2.new(0, T.tabSize - 30, 1, -60),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3,
        Parent = contentGroup
    })
    List(self.Sidebar, Enum.FillDirection.Vertical, 6)
    Pad(self.Sidebar, 4, 12, 2, 6)

    self.ContentArea = New("Frame", {
        Position = UDim2.new(0, T.tabSize - 20, 0, 50),
        Size = UDim2.new(1, -T.tabSize + 14, 1, -56),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        ZIndex = 3,
        Parent = contentGroup
    })
    Cor(self.ContentArea, 16)

    New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 44, 84)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 14, 34))
        }),
        Rotation = 45,
        Parent = self.ContentArea
    })

    local contentStroke = New("UIStroke", {
        Thickness = 1.8,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = self.ContentArea
    })
    local contentGradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = contentStroke
    })
    task.spawn(function()
        while contentGradient and contentGradient.Parent do
            contentGradient.Rotation = (contentGradient.Rotation + 1.2) % 360
            task.wait(0.03)
        end
    end)

    self.Tabs = {}
    self.Pages = {}
    self.ActivePage = nil
    self.winOpen = false

    local MenuPosXScale = Spring.new(1.2, 14, 25, 0.5)
    local MenuPosYScale = Spring.new(1.2, 14, 25, 0.15)
    local MenuSizeXOffset = Spring.new(1.5, 14, 25, 140)
    local MenuSizeYOffset = Spring.new(1.5, 14, 25, 42)
    local MenuCorner = Spring.new(1.2, 14, 25, 21)

    local springing = false

    local function getFloatScalePos()
        local parentSize = self.GUI.AbsoluteSize
        if parentSize.X == 0 or parentSize.Y == 0 then return 0.5, 0.15 end
        local absPos = self.FloatIcon.AbsolutePosition
        local absSize = self.FloatIcon.AbsoluteSize
        local centerX = absPos.X + (absSize.X / 2)
        local centerY = absPos.Y + (absSize.Y / 2)
        return centerX / parentSize.X, centerY / parentSize.Y
    end

    local function openWin()
        if self.winOpen or self.IsModalOpen then return end
        self.winOpen = true
        springing = true

        closeTextLabel.Visible = false
        closeTextLabel.TextTransparency = 1

        local fx, fy = getFloatScalePos()

        self.FloatIcon.Visible = false
        self.WinMain.Visible = true
        
        MenuPosXScale:Reset(fx)
        MenuPosXScale.target = 0.5
        MenuPosYScale:Reset(fy)
        MenuPosYScale.target = 0.5
        MenuSizeXOffset:Reset(140)
        MenuSizeXOffset.target = targetMenuWidth
        MenuSizeYOffset:Reset(42)
        MenuSizeYOffset.target = targetMenuHeight
        MenuCorner:Reset(21)
        MenuCorner.target = 32

        self.WinMain.Position = UDim2.new(fx, 0, fy, 0)
        self.WinMain.BackgroundTransparency = T.bgTrans

        contentGroup.Visible = false
        contentGroup.GroupTransparency = 1
        borderStroke.Transparency = 0.2

        task.delay(0.35, function()
            for _, page in ipairs(self.Pages) do
                page.CanvasPosition = Vector2.zero
            end
        end)
    end

    local function closeWin()
        if not self.winOpen or self.IsModalOpen then return end
        self.winOpen = false
        springing = true

        contentGroup.Visible = false
        contentGroup.GroupTransparency = 1

        local fx, fy = getFloatScalePos()
        
        closeTextLabel.Position = self.WinMain.Position
        closeTextLabel.Visible = true
        closeTextLabel.TextTransparency = 0

        MenuPosXScale:Reset(self.WinMain.Position.X.Scale)
        MenuPosXScale.target = fx
        MenuPosYScale:Reset(self.WinMain.Position.Y.Scale)
        MenuPosYScale.target = fy
        
        MenuSizeXOffset.target = 140
        MenuSizeYOffset.target = 42
        MenuCorner.target = 21
    end

    RunService.RenderStepped:Connect(function(dt)
        if not self.WinMain then return end

        local currW = MenuSizeXOffset:Update(dt)
        local currH = MenuSizeYOffset:Update(dt)
        local currR = MenuCorner:Update(dt)

        self.WinMain.Size = UDim2.fromOffset(currW, currH)
        if winCorner then winCorner.CornerRadius = UDim.new(0, currR) end

        local sidebarWidth = math.clamp(currW * 0.32, 50, T.tabSize - 30)
        local availH = math.max(0, currH - 60)
        
        self.Sidebar.Size = UDim2.fromOffset(sidebarWidth, availH)
        self.Sidebar.Position = UDim2.fromOffset(6, 50)

        local contentX = sidebarWidth + 12
        local contentW = math.max(0, currW - contentX - 10)
        local contentH = math.max(0, currH - 56)

        self.ContentArea.Size = UDim2.fromOffset(contentW, contentH)
        self.ContentArea.Position = UDim2.fromOffset(contentX, 50)

        if self.winOpen then
            if currW < 300 then
                contentGroup.Visible = false
                contentGroup.GroupTransparency = 1
            else
                contentGroup.Visible = true
                local p = math.clamp((currW - 300) / (targetMenuWidth - 300), 0, 1)
                contentGroup.GroupTransparency = 1 - p
                
                if currW > targetMenuWidth - 10 and not springing then
                    contentGroup.GroupTransparency = 0
                    for _, page in ipairs(self.Pages) do
                        if page and page.Parent == self.ContentArea then
                            page.Size = UDim2.fromOffset(contentW, contentH - 8)
                            local layout = page:FindFirstChildOfClass("UIListLayout")
                            if layout then
                                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
                            end
                        end
                    end
                end
            end
        elseif not self.winOpen then
            contentGroup.Visible = false
        end

        if springing then
            local currX = MenuPosXScale:Update(dt)
            local currY = MenuPosYScale:Update(dt)
            self.WinMain.Position = UDim2.new(currX, 0, currY, 0)
            
            if not self.winOpen then closeTextLabel.Position = self.WinMain.Position end

            if self.winOpen then
                if math.abs(currW - targetMenuWidth) < 1.5 and math.abs(currH - targetMenuHeight) < 1.5 and math.abs(MenuSizeXOffset.v) < 2 then
                    springing = false
                end
            else
                if math.abs(currW - 140) < 2 and math.abs(currH - 42) < 2 then
                    springing = false
                    self.WinMain.Visible = false
                    self.FloatIcon.Visible = true
                    Tween(closeTextLabel, 0.15, { TextTransparency = 1 })
                    task.delay(0.15, function() closeTextLabel.Visible = false end)
                end
            end
        end
    end)

    self.FloatIcon.MouseButton1Click:Connect(function()
        if not self.winOpen then openWin() end
    end)

    local function makeSmoothDrag(handle, target, scaleObj, clickCallback)
        local dragging = false
        local dragStart, startPos
        local targetX, targetY, currentX, currentY = 0, 0, 0, 0
        local lerpConnection = nil
        local suavizado = 0.15
        local inputBeganTime = 0

        handle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if springing or self.IsModalOpen then return end
            dragging = true
            self.dragging = true
            inputBeganTime = tick()
            dragStart = input.Position
            startPos = target.Position
            currentX = target.AbsolutePosition.X + (target.AbsoluteSize.X * target.AnchorPoint.X)
            currentY = target.AbsolutePosition.Y + (target.AbsoluteSize.Y * target.AnchorPoint.Y)
            targetX, targetY = currentX, currentY

            if scaleObj then Tween(scaleObj, 0.2, { Scale = 1.01 }) end

            if not lerpConnection then
                lerpConnection = RunService.RenderStepped:Connect(function()
                    if dragging or math.abs(currentX - targetX) > 0.1 or math.abs(currentY - targetY) > 0.1 then
                        currentX = currentX + (targetX - currentX) * suavizado
                        currentY = currentY + (targetY - currentY) * suavizado
                        target.Position = UDim2.new(0, math.round(currentX), 0, math.round(currentY))
                    else
                        lerpConnection:Disconnect()
                        lerpConnection = nil
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local originX = (target.Parent.AbsoluteSize.X * startPos.X.Scale) + startPos.X.Offset
                local originY = (target.Parent.AbsoluteSize.Y * startPos.Y.Scale) + startPos.Y.Offset
                targetX = originX + delta.X
                targetY = originY + delta.Y
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if dragging then
                dragging = false
                self.dragging = false
                if scaleObj then Tween(scaleObj, 0.25, { Scale = 1 }) end

                local parentSize = self.GUI.AbsoluteSize
                if parentSize.X > 0 and parentSize.Y > 0 then
                    local newScaleX = currentX / parentSize.X
                    local newScaleY = currentY / parentSize.Y
                    target.Position = UDim2.new(newScaleX, 0, newScaleY, 0)
                end

                local duration = tick() - inputBeganTime
                if duration < 0.25 and clickCallback then clickCallback() end
            end
        end)
    end

    local function makeDraggable(obj, target)
        local dragStart, startPos, dragging
        obj.InputBegan:Connect(function(i)
            if self.LogoLocked or self.IsModalOpen then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = i.Position
                startPos = target.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local del = i.Position - dragStart
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + del.X, startPos.Y.Scale, startPos.Y.Offset + del.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                local parentSize = self.GUI.AbsoluteSize
                if parentSize.X > 0 and parentSize.Y > 0 then
                    local absPos = target.AbsolutePosition
                    local absSize = target.AbsoluteSize
                    local centerX = absPos.X + (absSize.X / 2)
                    local centerY = absPos.Y + (absSize.Y / 2)
                    target.Position = UDim2.new(centerX / parentSize.X, 0, centerY / parentSize.Y, 0)
                end
            end
        end)
    end

    makeDraggable(self.FloatIcon, self.FloatIcon)
    makeSmoothDrag(titleBar, self.WinMain, self.WinScale, closeWin)

    function self:SetScale(scaleValue) if self.WinScale then self.WinScale.Scale = scaleValue end end
    function self:SetLogoVisible(visible) if self.FloatIcon then self.FloatIcon.Visible = visible end end
    function self:SetLogoLocked(locked) self.LogoLocked = locked end

    return self
end

function Library:Notify(feature, state)
    local accent = state and T.green or T.red
    local titleTxt = state and "SISTEMA ACTIVO" or "SISTEMA DESACTIVADO"

    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = 1,
        ZIndex = 999999996,
        Parent = self.NotifLayer
    })
    Cor(card, 12)

    local st = Stk(card, T.border, 1.2)
    st.Transparency = 1
    local sh = Shadow(card, 1, 24)
    local cs = New("UIScale", { Scale = 0.8, Parent = card })

    local bar = New("Frame", {
        Position = UDim2.new(0, 10, 0.5, -12),
        Size = UDim2.new(0, 3, 0, 24),
        BackgroundColor3 = accent,
        BackgroundTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })
    Cor(bar, 2)

    local title = New("TextLabel", {
        Position = UDim2.new(0, 20, 0, 8),
        Size = UDim2.new(1, -30, 0, 16),
        BackgroundTransparency = 1,
        Text = titleTxt,
        TextColor3 = accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })

    local sub = New("TextLabel", {
        Position = UDim2.new(0, 20, 0, 24),
        Size = UDim2.new(1, -30, 0, 16),
        BackgroundTransparency = 1,
        Text = feature,
        TextColor3 = T.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })

    local track = New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = T.sep,
        BackgroundTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })

    local fill = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accent,
        BackgroundTransparency = 1,
        ZIndex = 999999998,
        Parent = track
    })
    Cor(fill, 1)

    Tween(cs, 0.4, { Scale = 1 }, Enum.EasingStyle.Back)
    Tween(card, 0.35, { BackgroundTransparency = T.bgTrans })
    Tween(st, 0.35, { Transparency = 0 })
    Tween(sh, 0.35, { ImageTransparency = 0.6 })
    Tween(bar, 0.35, { BackgroundTransparency = 0 })
    Tween(title, 0.35, { TextTransparency = 0 })
    Tween(sub, 0.35, { TextTransparency = 0 })
    Tween(track, 0.35, { BackgroundTransparency = 0.5 })
    Tween(fill, 0.35, { BackgroundTransparency = 0 })
    Tween(fill, 2.0, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear)

    task.delay(2.1, function()
        if not card or not card.Parent then return end
        Tween(cs, 0.3, { Scale = 0.8 }, Enum.EasingStyle.Quad)
        Tween(card, 0.3, { BackgroundTransparency = 1 })
        Tween(st, 0.3, { Transparency = 1 })
        Tween(sh, 0.3, { ImageTransparency = 1 })
        Tween(bar, 0.3, { BackgroundTransparency = 1 })
        Tween(title, 0.3, { TextTransparency = 1 })
        Tween(sub, 0.3, { TextTransparency = 1 })
        track:Destroy()
        task.delay(0.35, function() if card then card:Destroy() end end)
    end)
end

function Library:CreateTab(name, iconId)
    local tabBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
        Parent = self.Sidebar
    })
    Cor(tabBtn, 21)
    local tabStroke = New("UIStroke", {
        Thickness = 1.6,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = tabBtn
    })

    local tabGradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = tabStroke
    })
    task.spawn(function()
        while tabGradient and tabGradient.Parent do
            tabGradient.Rotation = (tabGradient.Rotation + 1.2) % 360
            task.wait(0.03)
        end
    end)

    local icon = New("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 12, 0.5, -12),
        BackgroundTransparency = 1,
        Image = iconId or "",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 5,
        Parent = tabBtn
    })

    local txt = New("TextLabel", {
        Size = UDim2.new(1, -46, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(180, 200, 220),
        Font = Enum.Font.GothamMedium,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = tabBtn
    })

    local page = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.ContentArea
    })
    Cor(page, 8)
    local pageList = List(page, Enum.FillDirection.Vertical, 6)
    Pad(page, 8, 8, 8, 8)

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if page and page.Parent then
            page.CanvasSize = UDim2.fromOffset(0, pageList.AbsoluteContentSize.Y + 10)
        end
    end)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            Tween(t.btn, 0.2, { BackgroundTransparency = 1 })
            t.txt.TextColor3 = Color3.fromRGB(180, 200, 220)
            t.stroke.Transparency = 0
        end
        for _, p in pairs(self.Pages) do p.Visible = false end

        Tween(tabBtn, 0.2, { BackgroundTransparency = 0.85 })
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Transparency = 0
        
        page.Visible = true
        page.Position = UDim2.new(0, 0, -0.1, 0)
        page.Size = UDim2.new(1, 0, 1.2, 0)
        
        Tween(page, 0.6, {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0)
        }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        self.ActivePage = page
    end)

    if not self.ActivePage then
        self.ActivePage = page
        page.Visible = true
        tabBtn.BackgroundTransparency = 0.85
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(self.Tabs, { btn = tabBtn, stroke = tabStroke, txt = txt, icon = icon })
    table.insert(self.Pages, page)

    local TabMethods = { Library = self, Page = page }

    function TabMethods:CreateSection(title)
        local container = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = page
        })
        List(container, Enum.FillDirection.Vertical, 8)

        New("TextLabel", {
            Size = UDim2.new(1, -4, 0, 26),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamMedium,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Parent = container
        })

        local card = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = container
        })
        List(card, Enum.FillDirection.Vertical, 8)

        local ElementMethods = { Card = card, Library = self.Library }

        -- ================================================================= --
        -- TOGGLE ELÁSTICO
        -- ================================================================= --
        function ElementMethods:AddToggle(lbl, def, cb)
            local state = def or false

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local switchBg = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 50, 0, 26),
                BackgroundColor3 = state and Color3.fromRGB(0, 166, 255) or T.switchOff,
                ZIndex = 6,
                Parent = row
            })
            Cor(switchBg, 13)
            Stk(switchBg, T.border, 1.5)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = state and UDim2.new(0, 22, 0, 20) or UDim2.new(0, 20, 0, 20),
                Position = state and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 7,
                Parent = switchBg
            })
            Cor(knob, 8)

            local click = New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 9,
                Parent = row
            })

            click.MouseButton1Click:Connect(function()
                state = not state
                cb(state)
                self.Library:Notify(lbl, state)

                Tween(switchBg, 0.4, { BackgroundColor3 = state and Color3.fromRGB(0, 166, 255) or T.switchOff })

                if state then
                    Tween(knob, 0.25, { Position = UDim2.new(1, -27, 0.5, 0), Size = UDim2.new(0, 26, 0, 18) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    task.delay(0.2, function()
                        Tween(knob, 0.55, { Position = UDim2.new(1, -23, 0.5, 0), Size = UDim2.new(0, 20, 0, 20) }, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    end)
                else
                    Tween(knob, 0.25, { Position = UDim2.new(0, 5, 0.5, 0), Size = UDim2.new(0, 24, 0, 18) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    task.delay(0.2, function()
                        Tween(knob, 0.55, { Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.new(0, 20, 0, 20) }, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    end)
                end
            end)
        end

        function ElementMethods:AddButton(lbl, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            local btnStroke = Stk(row, T.border, 1.5)

            local btn = New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                ZIndex = 6,
                Parent = row
            })

            btn.MouseButton1Click:Connect(function()
                Tween(row, 0.1, { BackgroundColor3 = T.border })
                Tween(btnStroke, 0.1, { Color = Color3.fromRGB(255, 255, 255) })
                task.delay(0.12, function()
                    Tween(row, 0.3, { BackgroundColor3 = T.panel2 })
                    Tween(btnStroke, 0.3, { Color = T.border })
                end)
                cb()
            end)
        end

        -- ================================================================= --
        -- SLIDERS
        -- ================================================================= --
        function ElementMethods:AddSlider(lbl, mn, mx, def, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 21)
            Stk(row, T.border, 1.2)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 4),
                Size = UDim2.new(0.6, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local valInput = New("TextBox", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -14, 0, 4),
                Size = UDim2.new(0, 50, 0, 18),
                BackgroundTransparency = 1,
                Text = tostring(def),
                TextColor3 = T.border,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                ClearTextOnFocus = false,
                ZIndex = 8,
                Parent = row
            })

            local track = New("Frame", {
                Position = UDim2.new(0, 14, 0, 28),
                Size = UDim2.new(1, -28, 0, 8),
                BackgroundColor3 = Color3.fromRGB(10, 18, 32),
                ZIndex = 6,
                Parent = row
            })
            Cor(track, 4)

            local trackStroke = Stk(track, Color3.fromRGB(255, 255, 255), 1.2)
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = trackStroke
            })

            local alpha = (def - mn) / (mx - mn)
            local fill = New("Frame", {
                BackgroundColor3 = T.border,
                Size = UDim2.new(alpha, 0, 1, 0),
                ZIndex = 7,
                Parent = track
            })
            Cor(fill, 4)

            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
                }),
                Parent = fill
            })

            local thumb = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(alpha, 0, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 8,
                Parent = track
            })
            Cor(thumb, 7)
            Stk(thumb, Color3.fromRGB(0, 140, 255), 1.5)

            local function setVal(newVal)
                newVal = math.clamp(newVal, mn, mx)
                valInput.Text = tostring(newVal)
                local tt = (newVal - mn) / (mx - mn)
                Tween(fill, 0.15, { Size = UDim2.new(tt, 0, 1, 0) })
                Tween(thumb, 0.15, { Position = UDim2.new(tt, 0, 0.5, 0) })
                cb(newVal)
            end

            local dragging = false
            local function update(posX)
                local t = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                setVal(math.clamp(math.floor(mn + t * (mx - mn) + 0.5), mn, mx))
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Tween(thumb, 0.2, { Size = UDim2.new(0, 18, 0, 18) })
                    update(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        Tween(thumb, 0.2, { Size = UDim2.new(0, 14, 0, 14) })
                    end
                end
            end)

            valInput.FocusLost:Connect(function()
                local num = tonumber(valInput.Text)
                if num then setVal(math.round(num)) end
            end)
        end

        -- ================================================================= --
        -- BUILDSELECTOR CORREGIDO
        -- ================================================================= --
        function ElementMethods:AddBuildSelector(lbl, items, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local openBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 110, 0, 26),
                BackgroundColor3 = T.switchOff,
                Text = "Seleccionar",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                ZIndex = 6,
                Parent = row
            })
            Cor(openBtn, 13)
            Stk(openBtn, T.border, 1.2)

            local screenGui = self.Library.GUI
            local modalOverlay = New("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Visible = false,
                ZIndex = 999999991,
                Parent = screenGui
            })

            local modalFrame = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(0, 80, 0, 80),
                BackgroundColor3 = Color3.fromRGB(8, 14, 26),
                ClipsDescendants = true,
                ZIndex = 999999992,
                Parent = modalOverlay
            })
            Cor(modalFrame, 24)
            Shadow(modalFrame, 0.5, 30).ZIndex = 999999991

            local modalStroke = Stk(modalFrame, Color3.fromRGB(255, 255, 255), 2.2)
            local modalGradient = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = modalStroke
            })
            task.spawn(function()
                while modalGradient and modalGradient.Parent do
                    modalGradient.Rotation = (modalGradient.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 12),
                Size = UDim2.new(1, -32, 0, 24),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 999999993,
                Parent = modalFrame
            })

            local scrollHolder = New("ScrollingFrame", {
                Position = UDim2.new(0, 14, 0, 44),
                Size = UDim2.new(1, -28, 1, -100),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            List(scrollHolder, Enum.FillDirection.Vertical, 8)
            Pad(scrollHolder, 2, 2, 2, 2)

            for _, item in ipairs(items or {}) do
                local titleText = type(item) == "table" and item.Title or tostring(item)
                local descText = type(item) == "table" and item.Description or "Sin descripción disponible"

                local itemCard = New("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundColor3 = Color3.fromRGB(12, 22, 40),
                    ZIndex = 999999994,
                    Parent = scrollHolder
                })
                Cor(itemCard, 14)
                Stk(itemCard, Color3.fromRGB(20, 80, 160), 1.2)

                New("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 6),
                    Size = UDim2.new(1, -24, 0, 18),
                    BackgroundTransparency = 1,
                    Text = titleText,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 999999995,
                    Parent = itemCard
                })

                New("TextLabel", {
                    Position = UDim2.new(0, 12, 0, 24),
                    Size = UDim2.new(1, -24, 0, 18),
                    BackgroundTransparency = 1,
                    Text = descText,
                    TextColor3 = Color3.fromRGB(150, 180, 210),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 999999995,
                    Parent = itemCard
                })

                local selectClick = New("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 999999996,
                    Parent = itemCard
                })

                selectClick.MouseButton1Click:Connect(function()
                    openBtn.Text = titleText
                    if cb then cb(titleText, item) end
                    self.Library.IsModalOpen = false
                    Tween(modalOverlay, 0.3, { BackgroundTransparency = 1 })
                    local springW = Spring.new(1.2, 14, 25, 360)
                    local springH = Spring.new(1.2, 14, 25, 280)
                    springW.target = 80
                    springH.target = 80
                    
                    local conn
                    conn = RunService.RenderStepped:Connect(function(dt)
                        local w = springW:Update(dt)
                        local h = springH:Update(dt)
                        modalFrame.Size = UDim2.fromOffset(w, h)
                        if math.abs(w - 80) < 2 then
                            conn:Disconnect()
                            modalOverlay.Visible = false
                        end
                    end)
                end)
            end

            local closeBtn = New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -12),
                Size = UDim2.new(1, -28, 0, 38),
                BackgroundColor3 = Color3.fromRGB(16, 32, 58),
                Text = "Cerrar",
                TextColor3 = Color3.fromRGB(220, 230, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(closeBtn, 19)
            Stk(closeBtn, Color3.fromRGB(40, 120, 220), 1.5)

            local function animateModal(open)
                if open then
                    self.Library.IsModalOpen = true
                    modalOverlay.Visible = true
                    Tween(modalOverlay, 0.3, { BackgroundTransparency = 0.5 })

                    local springW = Spring.new(1.2, 14, 25, 80)
                    local springH = Spring.new(1.2, 14, 25, 80)
                    springW.target = 360
                    springH.target = 280

                    local conn
                    conn = RunService.RenderStepped:Connect(function(dt)
                        local w = springW:Update(dt)
                        local h = springH:Update(dt)
                        modalFrame.Size = UDim2.fromOffset(w, h)
                        if math.abs(w - 360) < 1.5 then
                            conn:Disconnect()
                        end
                    end)
                else
                    self.Library.IsModalOpen = false
                    Tween(modalOverlay, 0.3, { BackgroundTransparency = 1 })
                    local springW = Spring.new(1.2, 14, 25, 360)
                    local springH = Spring.new(1.2, 14, 25, 280)
                    springW.target = 80
                    springH.target = 80

                    local conn
                    conn = RunService.RenderStepped:Connect(function(dt)
                        local w = springW:Update(dt)
                        local h = springH:Update(dt)
                        modalFrame.Size = UDim2.fromOffset(w, h)
                        if math.abs(w - 80) < 2 then
                            conn:Disconnect()
                            modalOverlay.Visible = false
                        end
                    end)
                end
            end

            openBtn.MouseButton1Click:Connect(function() animateModal(true) end)
            closeBtn.MouseButton1Click:Connect(function() animateModal(false) end)
        end

        -- ================================================================= --
        -- COLORPICKER CORREGIDO Y MEJORADO
        -- ================================================================= --
        function ElementMethods:AddColorPicker(lbl, defaultColor, cb)
            local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
            local tempColor = savedColor

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local colorPreview = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 22),
                BackgroundColor3 = savedColor,
                Text = "",
                ZIndex = 6,
                Parent = row
            })
            Cor(colorPreview, 11)
            Stk(colorPreview, T.border, 1.2)

            local screenGui = self.Library.GUI
            local modalOverlay = New("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Visible = false,
                ZIndex = 999999991,
                Parent = screenGui
            })

            local modalFrame = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(0, 80, 0, 80),
                BackgroundColor3 = Color3.fromRGB(8, 14, 26),
                ClipsDescendants = true,
                ZIndex = 999999992,
                Parent = modalOverlay
            })
            Cor(modalFrame, 24)
            Shadow(modalFrame, 0.5, 30).ZIndex = 999999991

            local modalStroke = Stk(modalFrame, Color3.fromRGB(255, 255, 255), 2.2)
            local modalGradient = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = modalStroke
            })
            task.spawn(function()
                while modalGradient and modalGradient.Parent do
                    modalGradient.Rotation = (modalGradient.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 10),
                Size = UDim2.new(0.5, 0, 0, 24),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 999999993,
                Parent = modalFrame
            })

            local previewBox = New("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -16, 0, 12),
                Size = UDim2.new(0, 24, 0, 20),
                BackgroundColor3 = savedColor,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(previewBox, 6)
            Stk(previewBox, Color3.fromRGB(255, 255, 255), 1)

            local hexInput = New("TextBox", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -46, 0, 12),
                Size = UDim2.new(0, 70, 0, 20),
                BackgroundColor3 = Color3.fromRGB(14, 24, 42),
                Text = "#" .. savedColor:ToHex(),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                ClearTextOnFocus = false,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(hexInput, 6)
            Stk(hexInput, T.border, 1)

            local svBox = New("Frame", {
                Position = UDim2.new(0, 16, 0, 42),
                Size = UDim2.new(0, 150, 0, 130),
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Active = true,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(svBox, 10)

            local satGradient = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Parent = svBox
            })

            local valOverlay = New("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 999999994,
                Parent = svBox
            })
            Cor(valOverlay, 10)

            New("UIGradient", {
                Color = ColorSequence.new(Color3.fromRGB(0,0,0)),
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Parent = valOverlay
            })

            local pickerCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 999999995,
                Parent = svBox
            })
            Cor(pickerCursor, 6)
            Stk(pickerCursor, Color3.fromRGB(0, 0, 0), 1.5)

            local hueBar = New("Frame", {
                Position = UDim2.new(0, 176, 0, 42),
                Size = UDim2.new(0, 16, 0, 130),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Active = true,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(hueBar, 8)

            New("UIGradient", {
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Parent = hueBar
            })

            local hueCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(1, 4, 0, 6),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 999999995,
                Parent = hueBar
            })
            Cor(hueCursor, 3)
            Stk(hueCursor, Color3.fromRGB(0, 0, 0), 1)

            local cancelBtn = New("TextButton", {
                Position = UDim2.new(0, 16, 0, 182),
                Size = UDim2.new(0, 84, 0, 34),
                BackgroundColor3 = Color3.fromRGB(14, 25, 45),
                Text = "Cancelar",
                TextColor3 = Color3.fromRGB(220, 230, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(cancelBtn, 17)
            Stk(cancelBtn, Color3.fromRGB(30, 100, 210), 1.5)

            local applyBtn = New("TextButton", {
                Position = UDim2.new(0, 108, 0, 182),
                Size = UDim2.new(0, 84, 0, 34),
                BackgroundColor3 = Color3.fromRGB(24, 100, 230),
                Text = "Aplicar",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                ZIndex = 999999993,
                Parent = modalFrame
            })
            Cor(applyBtn, 17)
            Stk(applyBtn, Color3.fromRGB(60, 140, 255), 1.5)

            local h, s, v = Color3.toHSV(savedColor)

            local function updateVisuals()
                tempColor = Color3.fromHSV(h, s, v)
                previewBox.BackgroundColor3 = tempColor
                hexInput.Text = "#" .. tempColor:ToHex()
                satGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                })
            end

            local function animateModal(open)
                if open then
                    self.Library.IsModalOpen = true
                    tempColor = savedColor
                    h, s, v = Color3.toHSV(savedColor)
                    pickerCursor.Position = UDim2.fromScale(s, 1 - v)
                    hueCursor.Position = UDim2.new(0.5, 0, h, 0)
                    updateVisuals()

                    modalOverlay.Visible = true
                    Tween(modalOverlay, 0.3, { BackgroundTransparency = 0.5 })

                    local springW = Spring.new(1.2, 14, 25, 80)
                    local springH = Spring.new(1.2, 14, 25, 80)
                    springW.target = 210
                    springH.target = 230

                    local conn
                    conn = RunService.RenderStepped:Connect(function(dt)
                        local w = springW:Update(dt)
                        local h = springH:Update(dt)
                        modalFrame.Size = UDim2.fromOffset(w, h)
                        if math.abs(w - 210) < 1.5 then
                            conn:Disconnect()
                        end
                    end)
                else
                    self.Library.IsModalOpen = false
                    Tween(modalOverlay, 0.3, { BackgroundTransparency = 1 })
                    local springW = Spring.new(1.2, 14, 25, 210)
                    local springH = Spring.new(1.2, 14, 25, 230)
                    springW.target = 80
                    springH.target = 80

                    local conn
                    conn = RunService.RenderStepped:Connect(function(dt)
                        local w = springW:Update(dt)
                        local h = springH:Update(dt)
                        modalFrame.Size = UDim2.fromOffset(w, h)
                        if math.abs(w - 80) < 2 then
                            conn:Disconnect()
                            modalOverlay.Visible = false
                        end
                    end)
                end
            end

            colorPreview.MouseButton1Click:Connect(function() animateModal(true) end)
            cancelBtn.MouseButton1Click:Connect(function() animateModal(false) end)

            applyBtn.MouseButton1Click:Connect(function()
                savedColor = tempColor
                colorPreview.BackgroundColor3 = savedColor
                if cb then cb(savedColor) end
                animateModal(false)
            end)

            hexInput.FocusLost:Connect(function()
                local cleanHex = hexInput.Text:gsub("#", "")
                local success, parsedColor = pcall(function() return Color3.fromHex(cleanHex) end)
                if success and parsedColor then
                    tempColor = parsedColor
                    h, s, v = Color3.toHSV(tempColor)
                    pickerCursor.Position = UDim2.fromScale(s, 1 - v)
                    hueCursor.Position = UDim2.new(0.5, 0, h, 0)
                    updateVisuals()
                else
                    hexInput.Text = "#" .. tempColor:ToHex()
                end
            end)

            local draggingSV, draggingHue = false, false

            svBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = true
                    local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    s = relX
                    v = 1 - relY
                    pickerCursor.Position = UDim2.fromScale(relX, relY)
                    updateVisuals()
                end
            end)

            hueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                    local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                    h = relY
                    hueCursor.Position = UDim2.new(0.5, 0, relY, 0)
                    updateVisuals()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = false
                    draggingHue = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if (draggingSV or draggingHue) and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    if draggingSV then
                        local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        pickerCursor.Position = UDim2.fromScale(relX, relY)
                        updateVisuals()
                    elseif draggingHue then
                        local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        h = relY
                        hueCursor.Position = UDim2.new(0.5, 0, relY, 0)
                        updateVisuals()
                    end
                end
            end)
        end

        return ElementMethods
    end

    return TabMethods
end

return Library
