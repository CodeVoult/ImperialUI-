
--23333

-- [[ ZyroxHub UI Library | iOS Premium VIP Edition (YARHM Style - Elastic Tab Animation) ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- ================================================================= --
-- 1. MOTOR DE RESORTES
-- ================================================================= --
local Spring = {}
Spring.__index = Spring

function Spring.new(mass, damping, constant, initialPos)
    local self = setmetatable({}, Spring)
    self.m = mass
    self.d = damping
    self.k = constant
    self.x = initialPos
    self.v = 0
    self.target = initialPos
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
    self.colorPickerActive = false
    self.buildSelectorActive = false

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

    local floatScale = New("UIScale", { Scale = 1, Parent = self.FloatIcon })
    local innerShine = New("Frame", {
        Name = "InnerShine",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        ClipsDescendants = true,
        ZIndex = 999999992,
        Parent = self.FloatIcon
    })
    Cor(innerShine, 21)

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

    -- EFECTO DE FONDO GRADIENTE ANIMADO
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

    local sheen = New("Frame", {
        Name = "Sheen",
        Size = UDim2.new(2, 0, 2, 0),
        Position = UDim2.new(-0.5, 0, -0.5, 0),
        BackgroundColor3 = Color3.fromRGB(120, 190, 255),
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = winInner
    })
    local sheenGradient = New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.5, 0.35),
            NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 45,
        Offset = Vector2.new(-1, -1),
        Parent = sheen
    })

    task.spawn(function()
        while sheenGradient and sheenGradient.Parent do
            sheenGradient.Offset = Vector2.new(-1, -1)
            Tween(sheenGradient, 2.2, { Offset = Vector2.new(1, 1) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(4.5)
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
    local sidebarList = List(self.Sidebar, Enum.FillDirection.Vertical, 6)
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

    -- ✅ CONFIGURACIÓN DE SPRINGS (Animación lenta y suave)
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
        if self.winOpen then return end
        self.winOpen = true
        springing = true

        closeTextLabel.Visible = false
        closeTextLabel.TextTransparency = 1

        local fx, fy = getFloatScalePos()

        self.FloatIcon.Visible = false
        self.WinMain.Visible = true
        
        MenuPosXScale.x = fx
        MenuPosXScale.v = 0
        MenuPosXScale.target = 0.5
        
        MenuPosYScale.x = fy
        MenuPosYScale.v = 0
        MenuPosYScale.target = 0.5
        
        MenuSizeXOffset.x = 140
        MenuSizeXOffset.v = 0
        MenuSizeXOffset.target = targetMenuWidth
        
        MenuSizeYOffset.x = 42
        MenuSizeYOffset.v = 0
        MenuSizeYOffset.target = targetMenuHeight
        
        MenuCorner.x = 21
        MenuCorner.v = 0
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
        if not self.winOpen then return end
        self.winOpen = false
        springing = true

        contentGroup.Visible = false
        contentGroup.GroupTransparency = 1

        local fx, fy = getFloatScalePos()
        
        closeTextLabel.Position = self.WinMain.Position
        closeTextLabel.Visible = true
        closeTextLabel.TextTransparency = 0

        MenuPosXScale.x = self.WinMain.Position.X.Scale
        MenuPosXScale.v = 0
        MenuPosXScale.target = fx
        
        MenuPosYScale.x = self.WinMain.Position.Y.Scale
        MenuPosYScale.v = 0
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
        if winCorner then
            winCorner.CornerRadius = UDim.new(0, currR)
        end

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
            
            if not self.winOpen then
                closeTextLabel.Position = self.WinMain.Position
            end

            if self.winOpen then
                if math.abs(currW - targetMenuWidth) < 1.5 and 
                   math.abs(currH - targetMenuHeight) < 1.5 and 
                   math.abs(MenuSizeXOffset.v) < 2 then
                    springing = false
                end
            else
                if math.abs(currW - 140) < 2 and math.abs(currH - 42) < 2 then
                    springing = false
                    self.WinMain.Visible = false
                    self.FloatIcon.Visible = true
                    
                    Tween(closeTextLabel, 0.15, { TextTransparency = 1 })
                    task.delay(0.15, function()
                        closeTextLabel.Visible = false
                    end)
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
            if springing then return end
            if self.colorPickerActive or self.buildSelectorActive then return end
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
            if self.LogoLocked then return end
            if self.colorPickerActive or self.buildSelectorActive then return end
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

    function self:SetScale(scaleValue)
        if self.WinScale then self.WinScale.Scale = scaleValue end
    end

    function self:SetLogoVisible(visible)
        if self.FloatIcon then self.FloatIcon.Visible = visible end
    end

    function self:SetLogoLocked(locked)
        self.LogoLocked = locked
    end

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
    tabStroke.Transparency = 0

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
        for _, p in pairs(self.Pages) do
            p.Visible = false
        end
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
        
        task.wait(0.1)
        if page and page.Parent then
            local layout = page:FindFirstChildOfClass("UIListLayout")
            if layout then
                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
            end
            page.CanvasPosition = Vector2.zero
        end
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

        function ElementMethods:AddToggle(lbl, def, cb)
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
                BackgroundColor3 = T.switchOff,
                ZIndex = 6,
                Parent = row
            })
            Cor(switchBg, 13)
            Stk(switchBg, T.border, 1.5)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 20, 0, 20),
                Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
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
                def = not def
                cb(def)
                self.Library:Notify(lbl, def)
                
                local targetPos = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                Tween(knob, 0.6, { Position = targetPos }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end)
        end

        function ElementMethods:AddButton(lbl, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            local btn = New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 0.15,
                BackgroundColor3 = Color3.fromRGB(10, 30, 60),
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                ZIndex = 6,
                Parent = row
            })
            Cor(btn, 20)
            
            local btnStroke = Stk(btn, T.border, 1.8)
            local btnGrad = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = btnStroke
            })
            task.spawn(function()
                while btnGrad and btnGrad.Parent do
                    btnGrad.Rotation = (btnGrad.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            btn.MouseButton1Click:Connect(function()
                Tween(btn, 0.1, { BackgroundTransparency = 0 })
                task.delay(0.1, function()
                    Tween(btn, 0.2, { BackgroundTransparency = 0.15 })
                end)
                cb()
            end)
        end

        function ElementMethods:AddSlider(lbl, mn, mx, def, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 21)
            Stk(row, T.border, 1)

            local valInput = New("TextBox", {
                Position = UDim2.new(0, 12, 0.5, -10),
                Size = UDim2.new(0, 35, 0, 20),
                BackgroundTransparency = 1,
                Text = tostring(def),
                TextColor3 = T.border,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = false,
                ZIndex = 8,
                Parent = row
            })

            New("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 130, 0, 20),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6,
                Parent = row
            })

            local track = New("Frame", {
                Position = UDim2.new(0, 52, 0.5, -2),
                Size = UDim2.new(1, -200, 0, 6),
                BackgroundColor3 = Color3.fromRGB(12, 22, 38),
                ZIndex = 6,
                Parent = row
            })
            Cor(track, 3)

            local trackStroke = Stk(track, Color3.fromRGB(255, 255, 255), 1.6)
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = trackStroke
            })

            local fill = New("Frame", {
                BackgroundColor3 = T.border,
                Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0),
                ZIndex = 7,
                Parent = track
            })
            Cor(fill, 3)

            local thumb = New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((def - mn) / (mx - mn), 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 8,
                Parent = track
            })
            Cor(thumb, 8)

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

            thumb.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
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
                    dragging = false
                end
            end)

            valInput.FocusLost:Connect(function()
                local num = tonumber(valInput.Text)
                if num then setVal(math.round(num)) end
            end)
        end

        -- ✅ BUILD SELECTOR MEJORADO - MISMA ANIMACIÓN QUE EL MENÚ PRINCIPAL
        function ElementMethods:AddDropdown(lbl, options, defaultIdx, cb)
            local currIdx = defaultIdx or 1
            local isOpen = false
            
            local targetWidth = 280
            local targetHeight = 180
            
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = T.panel2,
                ClipsDescendants = false,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local selectBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 120, 0, 30),
                BackgroundColor3 = Color3.fromRGB(10, 30, 60),
                Text = options[currIdx] .. " ▼",
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                ZIndex = 6,
                Parent = row
            })
            Cor(selectBtn, 13)
            Stk(selectBtn, T.border, 1.8)
            
            local selectGrad = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = selectBtn:FindFirstChildOfClass("UIStroke")
            })
            task.spawn(function()
                while selectGrad and selectGrad.Parent do
                    selectGrad.Rotation = (selectGrad.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            -- ✅ VENTANA DESPLEGABLE CON ANIMACIÓN ELÁSTICA (IGUAL QUE EL MENÚ)
            local dropdownContainer = New("Frame", {
                Name = "DropdownContainer",
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 1, 4),
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = T.bg,
                BackgroundTransparency = T.bgTrans,
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 20,
                Parent = row
            })
            Cor(dropdownContainer, 12)
            
            local dropdownCorner = dropdownContainer:FindFirstChildOfClass("UICorner")
            
            -- Borde del dropdown
            local dropStroke = New("UIStroke", {
                Thickness = 2.5,
                Color = Color3.fromRGB(255, 255, 255),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = dropdownContainer
            })
            local dropGrad = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = dropStroke
            })
            task.spawn(function()
                while dropGrad and dropGrad.Parent do
                    dropGrad.Rotation = (dropGrad.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            local dropContent = New("CanvasGroup", {
                Name = "DropContent",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                GroupTransparency = 1,
                ClipsDescendants = true,
                ZIndex = 21,
                Parent = dropdownContainer
            })

            local optionsScroller = New("ScrollingFrame", {
                Size = UDim2.new(1, -8, 1, -8),
                Position = UDim2.new(0, 4, 0, 4),
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(0, 0, 0, (#options * 38) + 4),
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                ZIndex = 22,
                Parent = dropContent
            })
            List(optionsScroller, Enum.FillDirection.Vertical, 4)
            Pad(optionsScroller, 4, 4, 4, 4)

            -- SPRINGS PARA LA ANIMACIÓN
            local DropXScale = Spring.new(1.2, 14, 25, 0.5)
            local DropYScale = Spring.new(1.2, 14, 25, 0.5)
            local DropWidth = Spring.new(1.5, 14, 25, 0)
            local DropHeight = Spring.new(1.5, 14, 25, 0)
            local DropCorner = Spring.new(1.2, 14, 25, 12)

            local dropSpringing = false

            -- Crear opciones
            for i, opt in ipairs(options) do
                local isSelected = (i == currIdx)
                local optBtn = New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = isSelected and Color3.fromRGB(25, 35, 60) or Color3.fromRGB(10, 20, 35),
                    Text = opt,
                    TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 210, 230),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    ZIndex = 23,
                    Parent = optionsScroller
                })
                Cor(optBtn, 10)
                Stk(optBtn, T.border, 1.2)

                optBtn.MouseButton1Click:Connect(function()
                    currIdx = i
                    cb(opt)
                    isOpen = false
                    selectBtn.Text = options[currIdx] .. " ▼"
                    self.Library.buildSelectorActive = false
                    
                    -- Cerrar con animación elástica
                    dropSpringing = true
                    DropWidth.target = 0
                    DropHeight.target = 0
                    DropCorner.target = 12
                    
                    task.delay(0.5, function()
                        dropdownContainer.Visible = false
                        dropSpringing = false
                    end)
                end)
            end

            -- Función para abrir con animación
            local function openDropdown()
                if isOpen then return end
                isOpen = true
                self.Library.buildSelectorActive = true
                dropSpringing = true
                
                dropdownContainer.Visible = true
                dropdownContainer.Size = UDim2.new(0, 0, 0, 0)
                dropContent.GroupTransparency = 1
                
                DropWidth.x = 0
                DropWidth.v = 0
                DropWidth.target = targetWidth
                
                DropHeight.x = 0
                DropHeight.v = 0
                DropHeight.target = targetHeight
                
                DropCorner.x = 12
                DropCorner.v = 0
                DropCorner.target = 16
                
                DropXScale.x = 0.5
                DropXScale.v = 0
                DropXScale.target = 0.5
                
                DropYScale.x = 0
                DropYScale.v = 0
                DropYScale.target = 0
            end

            -- Función para cerrar con animación
            local function closeDropdown()
                if not isOpen then return end
                isOpen = false
                self.Library.buildSelectorActive = false
                dropSpringing = true
                
                DropWidth.target = 0
                DropHeight.target = 0
                DropCorner.target = 12
                
                task.delay(0.5, function()
                    dropdownContainer.Visible = false
                    dropSpringing = false
                end)
            end

            -- Loop de animación del dropdown
            local dropConnection
            dropConnection = RunService.RenderStepped:Connect(function(dt)
                if not dropdownContainer then 
                    if dropConnection then dropConnection:Disconnect() end
                    return 
                end
                
                local currW = DropWidth:Update(dt)
                local currH = DropHeight:Update(dt)
                local currR = DropCorner:Update(dt)
                
                dropdownContainer.Size = UDim2.fromOffset(currW, currH)
                if dropdownCorner then
                    dropdownCorner.CornerRadius = UDim.new(0, currR)
                end
                
                if isOpen then
                    if currW > 50 then
                        dropContent.GroupTransparency = math.clamp(1 - ((currW - 50) / (targetWidth - 50)), 0, 1)
                    end
                    
                    if currW > targetWidth - 5 and math.abs(DropWidth.v) < 2 and not dropSpringing then
                        dropContent.GroupTransparency = 0
                    end
                end
                
                if dropSpringing then
                    if not isOpen then
                        if math.abs(currW) < 5 and math.abs(currH) < 5 then
                            dropSpringing = false
                            dropdownContainer.Visible = false
                        end
                    else
                        if math.abs(currW - targetWidth) < 2 and math.abs(currH - targetHeight) < 2 and math.abs(DropWidth.v) < 2 then
                            dropSpringing = false
                            dropContent.GroupTransparency = 0
                        end
                    end
                end
            end)

            -- Eventos de los botones
            selectBtn.MouseButton1Click:Connect(function()
                if isOpen then
                    closeDropdown()
                else
                    openDropdown()
                    selectBtn.Text = options[currIdx] .. " ▲"
                end
            end)

            -- Actualizar texto al seleccionar
            local originalCallback = cb
            cb = function(selected)
                selectBtn.Text = selected .. " ▼"
                originalCallback(selected)
            end

            -- Limpiar conexión al destruir
            row.AncestryChanged:Connect(function()
                if not row.Parent then
                    if dropConnection then dropConnection:Disconnect() end
                end
            end)
        end

        -- ✅ COLOR PICKER CON MISMA ANIMACIÓN QUE EL MENÚ PRINCIPAL
        function ElementMethods:AddColorPicker(lbl, defaultColor, cb)
            local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
            local tempColor = savedColor
            local isOpen = false
            
            local targetWidth = 380
            local targetHeight = 320

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
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
                Size = UDim2.new(0, 44, 0, 24),
                BackgroundColor3 = savedColor,
                Text = "",
                ZIndex = 6,
                Parent = row
            })
            Cor(colorPreview, 11)
            Stk(colorPreview, T.border, 1.8)
            
            local previewGrad = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = colorPreview:FindFirstChildOfClass("UIStroke")
            })
            task.spawn(function()
                while previewGrad and previewGrad.Parent do
                    previewGrad.Rotation = (previewGrad.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            local colorCodeText = New("TextLabel", {
                Position = UDim2.new(0.5, 10, 0, 0),
                Size = UDim2.new(0.4, -60, 1, 0),
                BackgroundTransparency = 1,
                Text = tostring(savedColor),
                TextColor3 = Color3.fromRGB(180, 200, 220),
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6,
                Parent = row
            })

            -- ✅ VENTANA DEL COLOR PICKER CON MISMA ANIMACIÓN
            local modalContainer = New("Frame", {
                Name = "ColorPickerContainer",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = T.bg,
                BackgroundTransparency = T.bgTrans,
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 100,
                Parent = row:FindFirstAncestorOfClass("ScreenGui")
            })
            Cor(modalContainer, 12)
            
            local modalCorner = modalContainer:FindFirstChildOfClass("UICorner")
            
            -- Fondo oscuro detrás
            local backdrop = New("Frame", {
                Position = UDim2.new(0, -1000, 0, -1000),
                Size = UDim2.new(1, 2000, 1, 2000),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.6,
                Visible = false,
                ZIndex = 99,
                Parent = modalContainer
            })
            
            -- Borde
            local modalStroke = New("UIStroke", {
                Thickness = 2.2,
                Color = Color3.fromRGB(255, 255, 255),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = modalContainer
            })
            local modalGrad = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
                }),
                Rotation = 225,
                Parent = modalStroke
            })
            task.spawn(function()
                while modalGrad and modalGrad.Parent do
                    modalGrad.Rotation = (modalGrad.Rotation + 1.2) % 360
                    task.wait(0.03)
                end
            end)

            local modalContent = New("CanvasGroup", {
                Name = "ModalContent",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                GroupTransparency = 1,
                ClipsDescendants = true,
                ZIndex = 101,
                Parent = modalContainer
            })

            -- SPRINGS PARA LA ANIMACIÓN DEL COLOR PICKER
            local ColorWidth = Spring.new(1.5, 14, 25, 0)
            local ColorHeight = Spring.new(1.5, 14, 25, 0)
            local ColorCorner = Spring.new(1.2, 14, 25, 12)
            local colorSpringing = false

            -- CONTENIDO DEL COLOR PICKER
            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 12),
                Size = UDim2.new(1, -32, 0, 24),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 102,
                Parent = modalContent
            })

            -- INPUT DE CÓDIGO HEX
            local hexInput = New("TextBox", {
                Position = UDim2.new(0, 16, 0, 44),
                Size = UDim2.new(0, 100, 0, 24),
                BackgroundColor3 = Color3.fromRGB(14, 25, 45),
                Text = tostring(savedColor),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = true,
                ZIndex = 102,
                Parent = modalContent
            })
            Cor(hexInput, 11)
            Stk(hexInput, T.border, 1.5)

            local svBox = New("TextButton", {
                Position = UDim2.new(0, 16, 0, 76),
                Size = UDim2.new(0, 180, 0, 140),
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 102,
                Parent = modalContent
            })
            Cor(svBox, 10)

            New("UIGradient", {
                Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Parent = svBox
            })

            local blackOverlay = New("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 103,
                Parent = svBox
            })
            Cor(blackOverlay, 10)

            New("UIGradient", {
                Color = ColorSequence.new(Color3.fromRGB(0,0,0)),
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Parent = blackOverlay
            })

            local pickerCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 14, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 104,
                Parent = svBox
            })
            Cor(pickerCursor, 7)
            Stk(pickerCursor, Color3.fromRGB(0, 0, 0), 1.5)

            local hueBar = New("TextButton", {
                Position = UDim2.new(0, 204, 0, 76),
                Size = UDim2.new(0, 16, 0, 140),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 102,
                Parent = modalContent
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

            -- PREVISUALIZACIÓN
            local previewColorFrame = New("Frame", {
                Position = UDim2.new(0, 228, 0, 44),
                Size = UDim2.new(0, 80, 0, 24),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 102,
                Parent = modalContent
            })
            Cor(previewColorFrame, 11)
            Stk(previewColorFrame, T.border, 1.5)

            local previewText = New("TextLabel", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "Preview",
                TextColor3 = Color3.fromRGB(0, 0, 0),
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                ZIndex = 103,
                Parent = previewColorFrame
            })

            local cancelBtn = New("TextButton", {
                Position = UDim2.new(0, 16, 0, 262),
                Size = UDim2.new(0, 170, 0, 42),
                BackgroundColor3 = Color3.fromRGB(14, 25, 45),
                Text = "Cancel",
                TextColor3 = Color3.fromRGB(220, 230, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                ZIndex = 102,
                Parent = modalContent
            })
            Cor(cancelBtn, 21)
            Stk(cancelBtn, Color3.fromRGB(30, 100, 210), 1.8)

            local applyBtn = New("TextButton", {
                Position = UDim2.new(0, 194, 0, 262),
                Size = UDim2.new(0, 170, 0, 42),
                BackgroundColor3 = Color3.fromRGB(24, 100, 230),
                Text = "Apply",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                ZIndex = 102,
                Parent = modalContent
            })
            Cor(applyBtn, 21)
            Stk(applyBtn, Color3.fromRGB(60, 140, 255), 1.8)

            local h, s, v = Color3.toHSV(savedColor)

            local function updateHexInput()
                local r = math.round(tempColor.R * 255)
                local g = math.round(tempColor.G * 255)
                local b = math.round(tempColor.B * 255)
                hexInput.Text = string.format("#%02X%02X%02X", r, g, b)
            end

            local function refreshUI()
                tempColor = Color3.fromHSV(h, s, v)
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                previewColorFrame.BackgroundColor3 = tempColor
                local brightness = (tempColor.R * 0.299 + tempColor.G * 0.587 + tempColor.B * 0.114)
                previewText.TextColor3 = brightness > 0.5 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
                updateHexInput()
            end

            -- FUNCIONES DE APERTURA Y CIERRE
            local function openColorPicker()
                if isOpen then return end
                isOpen = true
                self.Library.colorPickerActive = true
                colorSpringing = true
                
                tempColor = savedColor
                h, s, v = Color3.toHSV(savedColor)
                pickerCursor.Position = UDim2.fromScale(s, 1 - v)
                refreshUI()
                
                modalContainer.Visible = true
                backdrop.Visible = true
                modalContainer.Size = UDim2.new(0, 0, 0, 0)
                modalContent.GroupTransparency = 1
                
                ColorWidth.x = 0
                ColorWidth.v = 0
                ColorWidth.target = targetWidth
                
                ColorHeight.x = 0
                ColorHeight.v = 0
                ColorHeight.target = targetHeight
                
                ColorCorner.x = 12
                ColorCorner.v = 0
                ColorCorner.target = 20
            end

            local function closeColorPicker()
                if not isOpen then return end
                isOpen = false
                self.Library.colorPickerActive = false
                colorSpringing = true
                
                ColorWidth.target = 0
                ColorHeight.target = 0
                ColorCorner.target = 12
                
                task.delay(0.5, function()
                    modalContainer.Visible = false
                    backdrop.Visible = false
                    colorSpringing = false
                end)
            end

            -- LOOP DE ANIMACIÓN DEL COLOR PICKER
            local colorConnection
            colorConnection = RunService.RenderStepped:Connect(function(dt)
                if not modalContainer then
                    if colorConnection then colorConnection:Disconnect() end
                    return
                end
                
                local currW = ColorWidth:Update(dt)
                local currH = ColorHeight:Update(dt)
                local currR = ColorCorner:Update(dt)
                
                modalContainer.Size = UDim2.fromOffset(currW, currH)
                if modalCorner then
                    modalCorner.CornerRadius = UDim.new(0, currR)
                end
                
                if isOpen then
                    if currW > 50 then
                        modalContent.GroupTransparency = math.clamp(1 - ((currW - 50) / (targetWidth - 50)), 0, 1)
                    end
                    
                    if currW > targetWidth - 5 and math.abs(ColorWidth.v) < 2 and not colorSpringing then
                        modalContent.GroupTransparency = 0
                    end
                end
                
                if colorSpringing then
                    if not isOpen then
                        if math.abs(currW) < 5 and math.abs(currH) < 5 then
                            colorSpringing = false
                            modalContainer.Visible = false
                            backdrop.Visible = false
                        end
                    else
                        if math.abs(currW - targetWidth) < 2 and math.abs(currH - targetHeight) < 2 and math.abs(ColorWidth.v) < 2 then
                            colorSpringing = false
                            modalContent.GroupTransparency = 0
                        end
                    end
                end
            end)

            -- EVENTOS
            colorPreview.MouseButton1Click:Connect(function()
                openColorPicker()
            end)

            cancelBtn.MouseButton1Click:Connect(function()
                closeColorPicker()
            end)

            applyBtn.MouseButton1Click:Connect(function()
                savedColor = tempColor
                colorPreview.BackgroundColor3 = savedColor
                colorCodeText.Text = tostring(savedColor)
                cb(savedColor)
                closeColorPicker()
            end)

            -- INPUT DE HEX
            hexInput.FocusLost:Connect(function()
                local hex = hexInput.Text
                if hex and hex ~= "" then
                    local r, g, b
                    if string.sub(hex, 1, 1) == "#" then hex = string.sub(hex, 2) end
                    if #hex == 6 then
                        r = tonumber(string.sub(hex, 1, 2), 16)
                        g = tonumber(string.sub(hex, 3, 4), 16)
                        b = tonumber(string.sub(hex, 5, 6), 16)
                        if r and g and b then
                            tempColor = Color3.fromRGB(r, g, b)
                            h, s, v = Color3.toHSV(tempColor)
                            pickerCursor.Position = UDim2.fromScale(s, 1 - v)
                            refreshUI()
                        end
                    end
                end
            end)

            -- DRAG PARA EL COLOR
            local draggingSV, draggingHue = false, false

            svBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = true
                end
            end)

            hueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
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
                        refreshUI()
                    elseif draggingHue then
                        local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        h = relY
                        refreshUI()
                    end
                end
            end)

            -- Limpiar conexión
            row.AncestryChanged:Connect(function()
                if not row.Parent then
                    if colorConnection then colorConnection:Disconnect() end
                end
            end)
        end

        return ElementMethods
    end

    return TabMethods
end

return Library
