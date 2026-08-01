-- [[ -- ============================================================
-- ZyroxHub UI Library | iOS Premium VIP Edition (v1.5 Fixed)
-- ============================================================ -- ]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- Limpiar instancias previas
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("DDOS_VENOM")
    if old then old:Destroy() end
end)

-- ====================== TEMA ======================
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
    bgTrans = 0.08,
    tabSize = 200,
}

-- ====================== HELPERS OPTIMIZADOS ======================
local function New(cls, props)
    local o = Instance.new(cls)
    if props then
        for k, v in pairs(props) do o[k] = v end
    end
    return o
end

local function Cor(obj, r) New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj }) end
local function Stk(obj, col, th) return New("UIStroke", { Color = col or T.border, Thickness = th or 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = obj }) end
local function List(obj, dir, pad) return New("UIListLayout", { FillDirection = dir or Enum.FillDirection.Vertical, Padding = UDim.new(0, pad or 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = obj }) end
local function Pad(obj, t, b, l, r) New("UIPadding", { PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = obj }) end
local function Tween(obj, t, props, style, dir)
    local info = TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local anim = TweenService:Create(obj, info, props)
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

-- ====================== CREAR VENTANA ======================
function Library:CreateWindow(hubTitle)
    local self = setmetatable({}, Library)
    
    self.GUI = New("ScreenGui", {
        Name = "DDOS_VENOM",
        ResetOnSpawn = false,
        DisplayOrder = 999999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui() or game:GetService("CoreGui"))
    })

    -- Sonido click
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://4590657391"
    clickSound.Volume = 0.4
    clickSound.Parent = self.GUI

    self.GUI.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.MouseButton1Click:Connect(function() clickSound:Play() end)
        end
    end)

    -- Notificaciones
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

    -- ========== BOTÓN FLOTANTE ==========
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

    New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 220, 255)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(0.70, Color3.fromRGB(0, 90, 210)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 25, 70))
        }),
        Rotation = 135,
        Parent = lightStroke
    })

    local floatScale = New("UIScale", { Scale = 1, Parent = floatIcon })
    local innerShine = New("Frame", {
        Name = "InnerShine",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(0, 180, 255),
        ZIndex = 999999992,
        Parent = floatIcon
    })
    Cor(innerShine, 21)

    -- ========== VENTANA PRINCIPAL ==========
    local targetMenuWidth, targetMenuHeight = 620, 380
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
    Cor(self.WinMain, 28)

    local winScale = New("UIScale", { Scale = 1, Parent = self.WinMain })
    local winInner = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.bg,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        Parent = self.WinMain
    })
    Cor(winInner, 28)

    local borderStroke = New("UIStroke", {
        Name = "BorderStroke",
        Thickness = 3.4,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = self.WinMain
    })

    New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 230, 255)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 160, 255)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 100, 220)),
            ColorSequenceKeypoint.new(0.80, Color3.fromRGB(10, 50, 140)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 20, 60))
        }),
        Rotation = 135,
        Parent = borderStroke
    })

    -- ========== TÍTULO PREMIUM ==========
    local titleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = winInner
    })

    local accentBar = New("Frame", {
        Size = UDim2.new(0, 4, 0, 22),
        Position = UDim2.new(0, 14, 0.5, -11),
        BackgroundColor3 = T.border,
        BorderSizePixel = 0,
        ZIndex = 7,
        Parent = titleBar
    })
    Cor(accentBar, 2)

    New("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        RichText = true,
        Text = hubTitle or 'Zyrox Hub <font color="#00D4FF">VIP</font>',
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = titleBar
    })

    -- ========== SIDEBAR ==========
    self.Sidebar = New("ScrollingFrame", {
        Position = UDim2.new(0, 8, 0, 56),
        Size = UDim2.new(0, T.tabSize - 28, 1, -68),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 3,
        Parent = winInner
    })
    List(self.Sidebar, Enum.FillDirection.Vertical, 5)
    Pad(self.Sidebar, 4, 10, 2, 4)

    -- ========== CONTENT AREA ==========
    self.ContentArea = New("Frame", {
        Position = UDim2.new(0, T.tabSize - 14, 0, 56),
        Size = UDim2.new(1, -T.tabSize + 6, 1, -64),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        ZIndex = 3,
        Parent = winInner
    })
    Cor(self.ContentArea, 14)
    Stk(self.ContentArea, T.border, 1.4)

    self.Tabs = {}
    self.Pages = {}
    self.ActivePage = nil
    self.winOpen = false

    -- ========== APERTURA / CIERRE ==========
    local function openWin()
        if self.winOpen then return end
        self.winOpen = true
        Tween(floatScale, 0.4, { Scale = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(lightStroke, 0.3, { Transparency = 1 })
        Tween(innerShine, 0.3, { BackgroundTransparency = 1 })
        task.delay(0.28, function()
            floatIcon.Visible = false
            local startX = floatIcon.AbsolutePosition.X + floatIcon.AbsoluteSize.X * 0.5
            local startY = floatIcon.AbsolutePosition.Y + floatIcon.AbsoluteSize.Y * 0.5
            self.WinMain.Size = UDim2.new(0, 0, 0, 0)
            self.WinMain.Position = UDim2.new(0, startX, 0, startY)
            self.WinMain.BackgroundTransparency = 1
            borderStroke.Transparency = 1
            self.WinMain.Visible = true
            winScale.Scale = 0.01
            Tween(self.WinMain, 0.85, { Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, targetMenuWidth, 0, targetMenuHeight), BackgroundTransparency = T.bgTrans }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            Tween(borderStroke, 0.55, { Transparency = 0.15 })
            Tween(winScale, 0.85, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
    end

    local function closeWin()
        if not self.winOpen then return end
        self.winOpen = false
        local targetX = floatIcon.AbsolutePosition.X + floatIcon.AbsoluteSize.X * 0.5
        local targetY = floatIcon.AbsolutePosition.Y + floatIcon.AbsoluteSize.Y * 0.5
        Tween(borderStroke, 0.4, { Transparency = 1 })
        Tween(winScale, 0.75, { Scale = 0.01 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local collapse = Tween(self.WinMain, 0.75, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, targetX, 0, targetY), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        collapse.Completed:Connect(function()
            if not self.winOpen then
                self.WinMain.Visible = false
                floatIcon.Visible = true
                floatScale.Scale = 0
                Tween(floatScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                Tween(lightStroke, 0.3, { Transparency = 0 })
                Tween(floatIcon, 0.3, { BackgroundTransparency = 0.35 })
                Tween(innerShine, 0.3, { BackgroundTransparency = 0.9 })
            end
        end)
    end

    floatIcon.MouseButton1Click:Connect(function()
        if not self.winOpen then openWin() end
    end)

    -- ========== ARRASTRE SUAVE ==========
    local function makeSmoothDrag(handle, target, scaleObj, clickCallback)
        local dragging = false
        local dragStart, startPos
        local targetX, targetY, currentX, currentY = 0, 0, 0, 0
        local lerpConnection = nil
        local suavizado = 0.18
        local inputBeganTime = 0

        handle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            inputBeganTime = tick()
            dragStart = input.Position
            startPos = target.Position
            currentX = target.AbsolutePosition.X + target.AbsoluteSize.X * target.AnchorPoint.X
            currentY = target.AbsolutePosition.Y + target.AbsoluteSize.Y * target.AnchorPoint.Y
            targetX, targetY = currentX, currentY

            if scaleObj then Tween(scaleObj, 0.15, { Scale = 1.015 }) end

            if not lerpConnection then
                lerpConnection = RunService.RenderStepped:Connect(function()
                    if dragging or math.abs(currentX - targetX) > 0.15 or math.abs(currentY - targetY) > 0.15 then
                        currentX = currentX + (targetX - currentX) * suavizado
                        currentY = currentY + (targetY - currentY) * suavizado
                        target.Position = UDim2.new(0, math.round(currentX), 0, math.round(currentY))
                    else
                        if lerpConnection then
                            lerpConnection:Disconnect()
                            lerpConnection = nil
                        end
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
                if scaleObj then Tween(scaleObj, 0.2, { Scale = 1 }) end
                if (tick() - inputBeganTime) < 0.22 and clickCallback then
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

-- ====================== NOTIFICACIÓN ======================
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
    local sh = Shadow(card, 1, 22)
    local cs = New("UIScale", { Scale = 0.85, Parent = card })

    local bar = New("Frame", {
        Position = UDim2.new(0, 10, 0.5, -11),
        Size = UDim2.new(0, 3, 0, 22),
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

    Tween(cs, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
    Tween(card, 0.3, { BackgroundTransparency = T.bgTrans })
    Tween(st, 0.3, { Transparency = 0 })
    Tween(sh, 0.3, { ImageTransparency = 0.55 })
    Tween(bar, 0.3, { BackgroundTransparency = 0 })
    Tween(title, 0.3, { TextTransparency = 0 })
    Tween(sub, 0.3, { TextTransparency = 0 })
    Tween(track, 0.3, { BackgroundTransparency = 0.45 })
    Tween(fill, 0.3, { BackgroundTransparency = 0 })

    Tween(fill, 1.9, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear)

    task.delay(2.0, function()
        if not card or not card.Parent then return end
        Tween(cs, 0.25, { Scale = 0.85 }, Enum.EasingStyle.Quad)
        Tween(card, 0.25, { BackgroundTransparency = 1 })
        Tween(st, 0.25, { Transparency = 1 })
        Tween(sh, 0.25, { ImageTransparency = 1 })
        Tween(bar, 0.25, { BackgroundTransparency = 1 })
        Tween(title, 0.25, { TextTransparency = 1 })
        Tween(sub, 0.25, { TextTransparency = 1 })
        
        task.delay(0.3, function()
            if card then card:Destroy() end
        end)
    end)
end

-- ====================== CREAR TAB ======================
function Library:CreateTab(name, iconId)
    local tabBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
        Parent = self.Sidebar
    })
    Cor(tabBtn, 18)

    local tabStroke = Stk(tabBtn, T.border, 1.3)
    tabStroke.Transparency = 0.3

    local icon = New("ImageLabel", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 11, 0.5, -11),
        BackgroundTransparency = 1,
        Image = iconId or "",
        ImageColor3 = Color3.fromRGB(220, 235, 255),
        ZIndex = 5,
        Parent = tabBtn
    })

    local txt = New("TextLabel", {
        Size = UDim2.new(1, -42, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(170, 195, 220),
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = tabBtn
    })

    local page = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = 0,
        Visible = false,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = self.ContentArea
    })
    Cor(page, 10)
    List(page, Enum.FillDirection.Vertical, 7)
    Pad(page, 10, 12, 10, 10)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            Tween(t.btn, 0.18, { BackgroundTransparency = 1 })
            t.txt.TextColor3 = Color3.fromRGB(170, 195, 220)
            t.stroke.Transparency = 0.3
            t.icon.ImageColor3 = Color3.fromRGB(220, 235, 255)
        end
        for _, p in ipairs(self.Pages) do
            p.Visible = false
        end

        Tween(tabBtn, 0.18, { BackgroundTransparency = 0.82 })
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Transparency = 0
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)

        page.Visible = true
        self.ActivePage = page
    end)

    if not self.ActivePage then
        self.ActivePage = page
        page.Visible = true
        tabBtn.BackgroundTransparency = 0.82
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Transparency = 0
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(self.Tabs, { btn = tabBtn, stroke = tabStroke, txt = txt, icon = icon })
    table.insert(self.Pages, page)

    local TabMethods = { Library = self, Page = page }

    -- ====================== SECCIÓN ======================
    function TabMethods:CreateSection(title)
        local container = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = page
        })
        List(container, Enum.FillDirection.Vertical, 7)

        New("TextLabel", {
            Size = UDim2.new(1, -4, 0, 24),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 16,
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
        List(card, Enum.FillDirection.Vertical, 7)

        local ElementMethods = { Card = card, Library = self.Library }

        -- ========== TOGGLE (FIXED) ==========
        function ElementMethods:AddToggle(lbl, def, cb)
            local toggleState = def or false

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 18)
            Stk(row, T.border, 1.3)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -78, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(235, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local switchBg = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 42, 0, 22),
                BackgroundColor3 = T.switchOff,
                ZIndex = 6,
                Parent = row
            })
            Cor(switchBg, 11)
            Stk(switchBg, T.border, 1.3)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                Position = toggleState and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 7,
                Parent = switchBg
            })
            Cor(knob, 4)

            local click = New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 9,
                Parent = row
            })

            click.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                if cb then cb(toggleState) end
                self.Library:Notify(lbl, toggleState)
                Tween(knob, 0.25, { Position = toggleState and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
            end)
        end

        -- ========== SLIDER (FIXED ZERO-DIVISION) ==========
        function ElementMethods:AddSlider(lbl, mn, mx, def, cb)
            mn = mn or 0
            mx = mx or 100
            def = math.clamp(def or mn, mn, mx)

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 18)
            Stk(row, T.border, 1.2)

            local valInput = New("TextBox", {
                Position = UDim2.new(0, 12, 0.5, -9),
                Size = UDim2.new(0, 34, 0, 18),
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
                Size = UDim2.new(0, 120, 0, 18),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(235, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6,
                Parent = row
            })

            local track = New("Frame", {
                Position = UDim2.new(0, 50, 0.5, -2),
                Size = UDim2.new(1, -190, 0, 5),
                BackgroundColor3 = Color3.fromRGB(12, 22, 38),
                ZIndex = 6,
                Parent = row
            })
            Cor(track, 3)

            local trackStroke = Stk(track, Color3.fromRGB(255, 255, 255), 1.4)
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 130, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 40, 100))
                }),
                Rotation = 135,
                Parent = trackStroke
            })

            local initialPct = (mx - mn == 0) and 0 or math.clamp((def - mn) / (mx - mn), 0, 1)

            local fill = New("Frame", {
                BackgroundColor3 = T.border,
                Size = UDim2.new(initialPct, 0, 1, 0),
                ZIndex = 7,
                Parent = track
            })
            Cor(fill, 3)

            local thumb = New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(initialPct, 0, 0.5, 0),
                Size = UDim2.new(0, 13, 0, 13),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 8,
                Parent = track
            })
            Cor(thumb, 6)

            local function setVal(newVal)
                newVal = math.clamp(math.floor(newVal + 0.5), mn, mx)
                valInput.Text = tostring(newVal)
                
                local range = mx - mn
                local tt = (range == 0) and 0 or math.clamp((newVal - mn) / range, 0, 1)

                Tween(fill, 0.12, { Size = UDim2.new(tt, 0, 1, 0) })
                Tween(thumb, 0.12, { Position = UDim2.new(tt, 0, 0.5, 0) })

                if cb then cb(newVal) end
            end

            local dragging = false
            thumb.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local t = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setVal(mn + t * (mx - mn))
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            valInput.FocusLost:Connect(function()
                local num = tonumber(valInput.Text)
                if num then setVal(num) end
            end)
        end

        -- ========== DROPDOWN ==========
        function ElementMethods:AddDropdown(lbl, options, defaultIdx, cb)
            options = options or {}
            local currIdx = defaultIdx or 1
            local dropdownOpen = false

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = T.panel2,
                ClipsDescendants = true,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 18)
            Stk(row, T.border, 1.3)

            local header = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = row
            })

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(235, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = header
            })

            local selectBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 110, 0, 24),
                BackgroundColor3 = T.switchOff,
                Text = (options[currIdx] or "Select") .. " ▼",
                TextColor3 = Color3.fromRGB(235, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                ZIndex = 6,
                Parent = header
            })
            Cor(selectBtn, 12)
            Stk(selectBtn, T.border, 1.2)

            local optionsHolder = New("ScrollingFrame", {
                Position = UDim2.new(0, 10, 0, 42),
                Size = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 3,
                ZIndex = 6,
                Parent = row
            })
            List(optionsHolder, Enum.FillDirection.Vertical, 5)
            Pad(optionsHolder, 2, 2, 2, 2)

            for i, opt in ipairs(options) do
                local isSelected = (i == currIdx)
                local optBtn = New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = isSelected and Color3.fromRGB(20, 35, 60) or Color3.fromRGB(12, 18, 30),
                    Text = opt,
                    TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 230),
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    ZIndex = 7,
                    Parent = optionsHolder
                })
                Cor(optBtn, 10)
                Stk(optBtn, T.border, 1.1)

                optBtn.MouseButton1Click:Connect(function()
                    currIdx = i
                    if cb then cb(opt) end
                    dropdownOpen = false
                    selectBtn.Text = options[currIdx] .. " ▼"
                    Tween(row, 0.25, { Size = UDim2.new(1, 0, 0, 38) })
                end)
            end

            selectBtn.MouseButton1Click:Connect(function()
                dropdownOpen = not dropdownOpen
                local maxH = math.min(#options * 31 + 8, 120)
                optionsHolder.Size = UDim2.new(1, -20, 0, maxH)
                selectBtn.Text = (options[currIdx] or "Select") .. (dropdownOpen and " ▲" or " ▼")
                Tween(row, 0.25, { Size = UDim2.new(1, 0, 0, dropdownOpen and (46 + maxH) or 38) })
            end)
        end

        -- ========== COLOR PICKER ==========
        function ElementMethods:AddColorPicker(lbl, defaultColor, cb)
            local savedColor = defaultColor or Color3.fromRGB(0, 166, 255)
            local tempColor = savedColor
            local h, s, v = Color3.toHSV(savedColor)

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 18)
            Stk(row, T.border, 1.3)

            New("TextLabel", {
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(235, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local colorPreview = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 38, 0, 22),
                BackgroundColor3 = savedColor,
                Text = "",
                ZIndex = 6,
                Parent = row
            })
            Cor(colorPreview, 10)
            Stk(colorPreview, T.border, 1.2)

            local screenGui = self.Library.GUI
            local modalOverlay = New("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.55,
                Visible = false,
                ZIndex = 200,
                Parent = screenGui
            })

            local modalFrame = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(0, 320, 0, 270),
                BackgroundColor3 = Color3.fromRGB(8, 14, 26),
                ZIndex = 201,
                Parent = modalOverlay
            })
            Cor(modalFrame, 18)
            Stk(modalFrame, Color3.fromRGB(0, 140, 255), 2)

            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 12),
                Size = UDim2.new(1, -32, 0, 22),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 202,
                Parent = modalFrame
            })

            local svBox = New("TextButton", {
                Position = UDim2.new(0, 16, 0, 42),
                Size = UDim2.new(0, 150, 0, 130),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 202,
                Parent = modalFrame
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
                ZIndex = 203,
                Parent = svBox
            })
            Cor(blackOverlay, 10)

            New("UIGradient", {
                Color = ColorSequence.new(Color3.fromRGB(0, 0, 0)),
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Parent = blackOverlay
            })

            local pickerCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(s, 1 - v),
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 204,
                Parent = svBox
            })
            Cor(pickerCursor, 6)
            Stk(pickerCursor, Color3.fromRGB(0, 0, 0), 1.4)

            local hueBar = New("TextButton", {
                Position = UDim2.new(0, 176, 0, 42),
                Size = UDim2.new(0, 14, 0, 130),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 202,
                Parent = modalFrame
            })
            Cor(hueBar, 7)

            New("UIGradient", {
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                }),
                Parent = hueBar
            })

            local cancelBtn = New("TextButton", {
                Position = UDim2.new(0, 16, 0, 210),
                Size = UDim2.new(0, 140, 0, 38),
                BackgroundColor3 = Color3.fromRGB(14, 25, 45),
                Text = "Cancel",
                TextColor3 = Color3.fromRGB(220, 230, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                ZIndex = 202,
                Parent = modalFrame
            })
            Cor(cancelBtn, 14)
            Stk(cancelBtn, Color3.fromRGB(40, 100, 200), 1.5)

            local applyBtn = New("TextButton", {
                Position = UDim2.new(0, 164, 0, 210),
                Size = UDim2.new(0, 140, 0, 38),
                BackgroundColor3 = Color3.fromRGB(0, 130, 255),
                Text = "Apply",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                ZIndex = 202,
                Parent = modalFrame
            })
            Cor(applyBtn, 14)
            Stk(applyBtn, Color3.fromRGB(80, 180, 255), 1.5)

            local function refreshUI()
                tempColor = Color3.fromHSV(h, s, v)
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            end

            colorPreview.MouseButton1Click:Connect(function()
                h, s, v = Color3.toHSV(savedColor)
                pickerCursor.Position = UDim2.fromScale(s, 1 - v)
                refreshUI()
                modalOverlay.Visible = true
            end)

            cancelBtn.MouseButton1Click:Connect(function() modalOverlay.Visible = false end)

            applyBtn.MouseButton1Click:Connect(function()
                savedColor = tempColor
                colorPreview.BackgroundColor3 = savedColor
                if cb then cb(savedColor) end
                modalOverlay.Visible = false
            end)

            local draggingSV, draggingHue = false, false
            svBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true end
            end)

            hueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = false
                    draggingHue = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not (draggingSV or draggingHue) then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

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
            end)
        end

        return ElementMethods
    end

    return TabMethods
end

return Library
