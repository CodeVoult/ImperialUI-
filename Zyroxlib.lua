-- [[
--     ============================================================
--       ZyroxHub UI Library | iOS Premium VIP Edition (v1.3)
--     ============================================================
-- ]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Destruir ejecuciones previas
if game:GetService("CoreGui"):FindFirstChild("DDOS_VENOM") then
    game:GetService("CoreGui").DDOS_VENOM:Destroy()
end

-- ============================================================
--   TEMA
-- ============================================================
local T = {
    bg        = Color3.fromRGB(14, 38, 70),
    panel     = Color3.fromRGB(4, 20, 38),
    panel2    = Color3.fromRGB(6, 26, 48),
    border    = Color3.fromRGB(0, 166, 255),
    acc       = Color3.fromRGB(0, 166, 255),
    text      = Color3.fromRGB(255, 255, 255),
    red       = Color3.fromRGB(255, 60, 60),
    green     = Color3.fromRGB(50, 255, 100),
    sep       = Color3.fromRGB(10, 35, 60),
    switchOff = Color3.fromRGB(10, 30, 50),
    bgTrans   = 0.1,
    tabSize   = 200,
}

-- ============================================================
--   HELPERS
-- ============================================================
local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Cor(obj, r)
    New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj })
end

local function Stk(obj, col, th)
    return New("UIStroke", {
        Color = col or T.border,
        Thickness = th or 1.2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

local function List(obj, dir, pad)
    New("UIListLayout", {
        FillDirection = dir or Enum.FillDirection.Vertical,
        Padding = UDim.new(0, pad or 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = obj
    })
end

local function Pad(obj, t, b, l, r)
    New("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = obj
    })
end

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

-- ============================================================
--   CREAR VENTANA PRINCIPAL
-- ============================================================
function Library:CreateWindow(hubTitle)
    local self = setmetatable({}, Library)

    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")

    self.GUI = New("ScreenGui", {
        Name = "DDOS_VENOM",
        ResetOnSpawn = false,
        DisplayOrder = 999999999,
        Parent = targetParent
    })

    -- Sonido de click
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://4590657391"
    clickSound.Volume = 0.5
    clickSound.Parent = self.GUI

    self.GUI.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.MouseButton1Click:Connect(function() clickSound:Play() end)
        end
    end)

    -- Capa de notificaciones
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

    -- Botón Flotante
    local floatIcon = New("TextButton", {
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
    Cor(floatIcon, 21)

    local lightStroke = New("UIStroke", {
        Name = "LightStroke",
        Thickness = 2.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
        Parent = floatIcon
    })

    local blueGradient = New("UIGradient", {
        Name = "BlueGradient",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = lightStroke
    })

    local floatScale = New("UIScale", { Scale = 1, Parent = floatIcon })

    local innerShine = New("Frame", {
        Name = "InnerShine",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        ZIndex = 999999992,
        Parent = floatIcon
    })
    Cor(innerShine, 21)

    -- Ventana Principal
    local targetMenuWidth, targetMenuHeight = 620, 360

    self.WinMain = New("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, targetMenuWidth, 0, targetMenuHeight),
        BackgroundColor3 = T.bg,
        BackgroundTransparency = T.bgTrans,
        Visible = false,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.GUI
    })
    Cor(self.WinMain, 32)

    local winScale = New("UIScale", { Scale = 1, Parent = self.WinMain })

    local winInner = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.bg,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        Parent = self.WinMain
    })
    Cor(winInner, 32)

    local borderStroke = New("UIStroke", {
        Name = "BorderStroke",
        Thickness = 3.2,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = self.WinMain
    })

    local borderGradient = New("UIGradient", {
        Name = "BorderGradient",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = borderStroke
    })

    task.spawn(function()
        while borderGradient and borderGradient.Parent do
            borderGradient.Rotation = (borderGradient.Rotation + 1.4) % 360
            task.wait(0.03)
        end
    end)

    local titleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = winInner
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
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3,
        Parent = winInner
    })
    List(self.Sidebar, Enum.FillDirection.Vertical, 6)
    Pad(self.Sidebar, 4, 8, 2, 6)

    self.ContentArea = New("Frame", {
        Position = UDim2.new(0, T.tabSize - 20, 0, 50),
        Size = UDim2.new(1, -T.tabSize + 14, 1, -56),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        ZIndex = 3,
        Parent = winInner
    })
    Cor(self.ContentArea, 16)
    Stk(self.ContentArea, T.border, 1.5)

    self.Tabs = {}
    self.Pages = {}
    self.ActivePage = nil
    self.winOpen = false

    local function openWin()
        if self.winOpen then return end
        self.winOpen = true

        Tween(floatScale, 0.45, { Scale = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(lightStroke, 0.35, { Transparency = 1 })
        Tween(innerShine, 0.35, { BackgroundTransparency = 1 })

        task.delay(0.3, function()
            floatIcon.Visible = false
            local startX = floatIcon.AbsolutePosition.X + (floatIcon.AbsoluteSize.X / 2)
            local startY = floatIcon.AbsolutePosition.Y + (floatIcon.AbsoluteSize.Y / 2)

            self.WinMain.Size = UDim2.new(0, 0, 0, 0)
            self.WinMain.Position = UDim2.new(0, startX, 0, startY)
            self.WinMain.BackgroundTransparency = 1
            borderStroke.Transparency = 1
            self.WinMain.Visible = true
            winScale.Scale = 0.01

            Tween(self.WinMain, 0.9, {
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(0, targetMenuWidth, 0, targetMenuHeight),
                BackgroundTransparency = T.bgTrans
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            Tween(borderStroke, 0.6, { Transparency = 0.2 })
            Tween(winScale, 0.9, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
    end

    local function closeWin()
        if not self.winOpen then return end
        self.winOpen = false

        local targetX = floatIcon.AbsolutePosition.X + (floatIcon.AbsoluteSize.X / 2)
        local targetY = floatIcon.AbsolutePosition.Y + (floatIcon.AbsoluteSize.Y / 2)

        Tween(borderStroke, 0.5, { Transparency = 1 })
        Tween(winScale, 0.85, { Scale = 0.01 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

        local collapse = Tween(self.WinMain, 0.85, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, targetX, 0, targetY),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

        collapse.Completed:Connect(function()
            if not self.winOpen then
                self.WinMain.Visible = false
                floatIcon.Visible = true
                floatScale.Scale = 0
                Tween(floatScale, 0.55, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                Tween(lightStroke, 0.35, { Transparency = 0 })
                Tween(floatIcon, 0.35, { BackgroundTransparency = 0.35 })
                Tween(innerShine, 0.35, { BackgroundTransparency = 0.9 })
            end
        end)
    end

    floatIcon.MouseButton1Click:Connect(function()
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
            dragging = true
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
                if scaleObj then Tween(scaleObj, 0.25, { Scale = 1 }) end
                if (tick() - inputBeganTime) < 0.25 and clickCallback then
                    clickCallback()
                end
            end
        end)
    end

    local function makeDraggable(obj, target)
        local dragStart, startPos, dragging
        obj.InputBegan:Connect(function(i)
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
            end
        end)
    end

    makeDraggable(floatIcon, floatIcon)
    makeSmoothDrag(titleBar, self.WinMain, winScale, closeWin)

    return self
end

-- ============================================================
--   NOTIFICACIÓN
-- ============================================================
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

-- ============================================================
--   CREAR PESTAÑAS
-- ============================================================
function Library:CreateTab(name)
    local tabBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = T.panel2,
        BackgroundTransparency = 0.5,
        Text = name,
        TextColor3 = Color3.fromRGB(180, 200, 220),
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        ZIndex = 4,
        Parent = self.Sidebar
    })
    Cor(tabBtn, 10)
    local tabStroke = Stk(tabBtn, T.border, 1)
    tabStroke.Transparency = 1

    local page = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = 0,
        Visible = false,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.ContentArea
    })
    Cor(page, 8)
    List(page, Enum.FillDirection.Vertical, 6)
    Pad(page, 8, 8, 8, 8)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            Tween(t.btn, 0.2, {
                BackgroundTransparency = 0.5,
                TextColor3 = Color3.fromRGB(180, 200, 220)
            })
            t.stroke.Transparency = 1
        end
        for _, p in pairs(self.Pages) do p.Visible = false end

        Tween(tabBtn, 0.2, {
            BackgroundTransparency = 0,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        tabStroke.Transparency = 0
        page.Visible = true
        self.ActivePage = page
    end)

    if not self.ActivePage then
        self.ActivePage = page
        page.Visible = true
        tabStroke.Transparency = 0
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(self.Tabs, { btn = tabBtn, stroke = tabStroke })
    table.insert(self.Pages, page)

    local TabMethods = { Library = self, Page = page }

    -- ============================================================
    --   SECCIÓN
    -- ============================================================
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

        -- Toggle
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
                Size = UDim2.new(0, 44, 0, 22),
                BackgroundColor3 = T.switchOff,
                ZIndex = 6,
                Parent = row
            })
            Cor(switchBg, 11)
            Stk(switchBg, T.border, 1.5)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 15, 0, 15),
                Position = def and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 7,
                Parent = switchBg
            })
            Cor(knob, 3)

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
                Tween(knob, 0.3, {
                    Position = def and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                })
            end)
        end

        -- Slider
        function ElementMethods:AddSlider(lbl, mn, mx, def, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
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
                Size = UDim2.new(0, 14, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 8,
                Parent = track
            })
            Cor(thumb, 7)

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

        -- Dropdown
        function ElementMethods:AddDropdown(lbl, options, defaultIdx, cb)
            local currIdx = defaultIdx
            local dropdownOpen = false

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = T.panel2,
                ClipsDescendants = true,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 20)
            Stk(row, T.border, 1.5)

            local header = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = row
            })

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
                Parent = header
            })

            local selectBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 110, 0, 26),
                BackgroundColor3 = T.switchOff,
                Text = options[defaultIdx] .. "  ▼",
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                ZIndex = 6,
                Parent = header
            })
            Cor(selectBtn, 13)
            Stk(selectBtn, T.border, 1.5)

            local optionsHolder = New("ScrollingFrame", {
                Position = UDim2.new(0, 10, 0, 44),
                Size = UDim2.new(1, -20, 0, 110),
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(0, 0, 0, (#options * 32) + 6),
                ScrollBarThickness = 3,
                ZIndex = 6,
                Parent = row
            })
            List(optionsHolder, Enum.FillDirection.Vertical, 6)
            Pad(optionsHolder, 2, 2, 2, 2)

            for i, opt in ipairs(options) do
                local isSelected = (i == currIdx)
                local optBtn = New("TextButton", {
                    Size = UDim2.new(0.96, 0, 0, 26),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundColor3 = isSelected and Color3.fromRGB(25, 35, 60) or Color3.fromRGB(15, 20, 30),
                    Text = opt,
                    TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 230),
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    ZIndex = 7,
                    Parent = optionsHolder
                })
                Cor(optBtn, 13)
                Stk(optBtn, T.border, 1.2)

                optBtn.MouseButton1Click:Connect(function()
                    currIdx = i
                    cb(opt)
                    dropdownOpen = false
                    selectBtn.Text = options[currIdx] .. "  ▼"
                    Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, 40) })
                end)
            end

            selectBtn.MouseButton1Click:Connect(function()
                dropdownOpen = not dropdownOpen
                local contentHeight = (#options * 32) + 12
                local holderHeight = math.min(contentHeight, 110)
                optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight)
                selectBtn.Text = options[currIdx] .. (dropdownOpen and "  ▲" or "  ▼")
                Tween(row, 0.3, {
                    Size = UDim2.new(1, 0, 0, dropdownOpen and (48 + holderHeight + 8) or 40)
                })
            end)
        end

        -- ColorPicker (NUEVO / AGREGADO)
        function ElementMethods:AddColorPicker(lbl, defColor, cb)
            local currentColor = defColor or Color3.fromRGB(255, 255, 255)

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
                Size = UDim2.new(1, -70, 1, 0),
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
                Size = UDim2.new(0, 44, 0, 22),
                BackgroundColor3 = currentColor,
                Text = "",
                ZIndex = 6,
                Parent = row
            })
            Cor(colorPreview, 11)
            Stk(colorPreview, Color3.fromRGB(255, 255, 255), 1.2)

            colorPreview.MouseButton1Click:Connect(function()
                -- Ejemplo de ciclado rápido o toggle de paleta
                cb(currentColor)
            end)
        end

        return ElementMethods
    end

    return TabMethods
end

return Library
