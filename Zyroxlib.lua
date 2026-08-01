-- [[
-- ============================================================
-- ZyroxHub UI Library | iOS Premium VIP Edition (v1.5 Extended)
-- Sistema Dinámico de Scroll + Degradados Premium Neon/iOS
-- ============================================================
-- ]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

if game:GetService("CoreGui"):FindFirstChild("DDOS_VENOM") then
    game:GetService("CoreGui").DDOS_VENOM:Destroy()
end

local T = {
    bg = Color3.fromRGB(10, 22, 40),
    panel = Color3.fromRGB(5, 14, 28),
    panel2 = Color3.fromRGB(8, 20, 36),
    border = Color3.fromRGB(0, 166, 255),
    acc = Color3.fromRGB(0, 180, 255),
    text = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(160, 185, 215),
    red = Color3.fromRGB(255, 65, 85),
    green = Color3.fromRGB(45, 225, 120),
    sep = Color3.fromRGB(15, 38, 65),
    switchOff = Color3.fromRGB(12, 26, 45),
    bgTrans = 0.05,
    tabSize = 190,
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
    return New("UIStroke", { Color = col or T.border, Thickness = th or 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = obj }) 
end

local function List(obj, dir, pad) 
    return New("UIListLayout", { FillDirection = dir or Enum.FillDirection.Vertical, Padding = UDim.new(0, pad or 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = obj }) 
end

local function Pad(obj, t, b, l, r) 
    return New("UIPadding", { PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = obj }) 
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
-- CREAR VENTANA PRINCIPAL
-- ============================================================
function Library:CreateWindow(hubTitle)
    local self = setmetatable({}, Library)

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

    -- ========== BOTÓN FLOTANTE (OPEN MENU) ==========
    local floatIcon = New("TextButton", { 
        Name = "FloatIcon", 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        Size = UDim2.new(0, 140, 0, 42), 
        Position = UDim2.new(0.5, 0, 0, 50), 
        BackgroundColor3 = Color3.fromRGB(10, 18, 32), 
        BackgroundTransparency = 0.2, 
        Text = "Open Menu", 
        TextColor3 = Color3.fromRGB(255, 255, 255), 
        Font = Enum.Font.GothamBold, 
        TextSize = 14, 
        AutoButtonColor = false, 
        ZIndex = 999999990, 
        Parent = self.GUI 
    }) 
    Cor(floatIcon, 21) 

    local floatGrad = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 30, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 12, 25))
        }),
        Rotation = 45,
        Parent = floatIcon
    })

    local lightStroke = New("UIStroke", { 
        Name = "LightStroke", 
        Thickness = 2.5, 
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
        Color = Color3.fromRGB(255, 255, 255), 
        Parent = floatIcon 
    }) 
    
    New("UIGradient", { 
        Color = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 255)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 90)) 
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

    -- ========== VENTANA PRINCIPAL ==========
    local targetMenuWidth, targetMenuHeight = 630, 370 
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
    Cor(self.WinMain, 24) 

    local winGradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 28, 52)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 18, 34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 10, 20))
        }),
        Rotation = 135,
        Parent = self.WinMain
    })

    local winScale = New("UIScale", { Scale = 1, Parent = self.WinMain }) 
    local winInner = New("Frame", { 
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, 
        ClipsDescendants = true, 
        Parent = self.WinMain 
    }) 

    local borderStroke = New("UIStroke", { 
        Name = "BorderStroke", 
        Thickness = 2.5, 
        Color = Color3.fromRGB(255, 255, 255), 
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
        Parent = self.WinMain 
    }) 
    
    New("UIGradient", { 
        Color = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 255)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 230)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 100)) 
        }), 
        Rotation = 225, 
        Parent = borderStroke 
    }) 

    -- Header / Title Bar
    local titleBar = New("Frame", { 
        Size = UDim2.new(1, 0, 0, 48), 
        BackgroundTransparency = 1, 
        ZIndex = 5, 
        Parent = winInner 
    }) 
    
    New("TextLabel", { 
        Size = UDim2.new(1, -24, 1, 0), 
        Position = UDim2.new(0, 16, 0, 0), 
        BackgroundTransparency = 1, 
        RichText = true, 
        Text = hubTitle or 'Zyrox Scripts <font color="#00E6FF">V1.5 VIP</font>', 
        TextColor3 = Color3.fromRGB(255, 255, 255), 
        Font = Enum.Font.GothamBold, 
        TextSize = 16, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        ZIndex = 7, 
        Parent = titleBar 
    }) 

    -- SIDEBAR (TABS - CON SCROLL DINÁMICO CORREGIDO)
    self.Sidebar = New("ScrollingFrame", { 
        Position = UDim2.new(0, 10, 0, 52), 
        Size = UDim2.new(0, T.tabSize - 20, 1, -62), 
        BackgroundTransparency = 1, 
        ScrollBarThickness = 2, 
        ScrollBarImageColor3 = T.border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, 
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 3, 
        Parent = winInner 
    }) 
    List(self.Sidebar, Enum.FillDirection.Vertical, 6) 
    Pad(self.Sidebar, 2, 6, 2, 4) 

    -- CONTENT AREA (PÁGINAS)
    self.ContentArea = New("Frame", { 
        Position = UDim2.new(0, T.tabSize, 0, 52), 
        Size = UDim2.new(1, -T.tabSize - 10, 1, -62), 
        BackgroundColor3 = T.panel, 
        BackgroundTransparency = 0.2, 
        ClipsDescendants = true, 
        ZIndex = 3, 
        Parent = winInner 
    }) 
    Cor(self.ContentArea, 16) 
    Stk(self.ContentArea, Color3.fromRGB(20, 50, 85), 1.2)

    local contentGrad = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 20, 38)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 12, 24))
        }),
        Rotation = 90,
        Parent = self.ContentArea
    })

    self.Tabs = {} 
    self.Pages = {} 
    self.ActivePage = nil 
    self.winOpen = false 

    -- LÓGICA ABRIR / CERRAR
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

            Tween(self.WinMain, 0.75, { Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, targetMenuWidth, 0, targetMenuHeight), BackgroundTransparency = T.bgTrans }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) 
            Tween(borderStroke, 0.5, { Transparency = 0 }) 
            Tween(winScale, 0.75, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) 
        end) 
    end 

    local function closeWin() 
        if not self.winOpen then return end 
        self.winOpen = false 
        local targetX = floatIcon.AbsolutePosition.X + (floatIcon.AbsoluteSize.X / 2) 
        local targetY = floatIcon.AbsolutePosition.Y + (floatIcon.AbsoluteSize.Y / 2) 

        Tween(borderStroke, 0.4, { Transparency = 1 }) 
        Tween(winScale, 0.65, { Scale = 0.01 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In) 
        local collapse = Tween(self.WinMain, 0.65, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, targetX, 0, targetY), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In) 
        
        collapse.Completed:Connect(function() 
            if not self.winOpen then 
                self.WinMain.Visible = false 
                floatIcon.Visible = true 
                floatScale.Scale = 0 
                Tween(floatScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) 
                Tween(lightStroke, 0.35, { Transparency = 0 }) 
                Tween(floatIcon, 0.35, { BackgroundTransparency = 0.2 }) 
                Tween(innerShine, 0.35, { BackgroundTransparency = 0.9 }) 
            end 
        end) 
    end 

    floatIcon.MouseButton1Click:Connect(function() if not self.winOpen then openWin() end end) 

    -- SISTEMA DRAGGABLE SUAVE
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
                local duration = tick() - inputBeganTime 
                if duration < 0.22 and clickCallback then clickCallback() end 
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
-- NOTIFICACIÓN CON DEGRADADO
-- ============================================================
function Library:Notify(feature, state)
    local accent = state and T.green or T.red
    local titleTxt = state and "SISTEMA ACTIVO" or "SISTEMA DESACTIVADO"

    local card = New("Frame", { 
        Size = UDim2.new(1, 0, 0, 50), 
        BackgroundColor3 = T.panel, 
        BackgroundTransparency = 0.1, 
        ZIndex = 999999996, 
        Parent = self.NotifLayer 
    }) 
    Cor(card, 12) 

    local cardGrad = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 30, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 14, 26))
        }),
        Rotation = 45,
        Parent = card
    })

    local st = Stk(card, accent, 1.2) 
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

    Tween(cs, 0.35, { Scale = 1 }, Enum.EasingStyle.Back) 
    Tween(card, 0.3, { BackgroundTransparency = 0.1 }) 
    Tween(st, 0.3, { Transparency = 0 }) 
    Tween(sh, 0.3, { ImageTransparency = 0.6 }) 
    Tween(bar, 0.3, { BackgroundTransparency = 0 }) 
    Tween(title, 0.3, { TextTransparency = 0 }) 
    Tween(sub, 0.3, { TextTransparency = 0 }) 
    Tween(track, 0.3, { BackgroundTransparency = 0.5 }) 
    Tween(fill, 0.3, { BackgroundTransparency = 0 }) 
    Tween(fill, 2.0, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear) 

    task.delay(2.1, function() 
        if not card or not card.Parent then return end 
        Tween(cs, 0.3, { Scale = 0.85 }, Enum.EasingStyle.Quad) 
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
-- CREAR TAB (PESTAÑA) CON AUTO-SCROLL
-- ============================================================
function Library:CreateTab(name, iconId)
    local tabBtn = New("TextButton", { 
        Size = UDim2.new(1, 0, 0, 38), 
        BackgroundColor3 = Color3.fromRGB(15, 30, 55), 
        BackgroundTransparency = 0.8, 
        Text = "", 
        AutoButtonColor = false, 
        ZIndex = 4, 
        Parent = self.Sidebar 
    }) 
    Cor(tabBtn, 12) 

    local tabGrad = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 70, 180))
        }),
        Rotation = 45,
        Transparency = NumberSequence.new(1),
        Parent = tabBtn
    })

    local tabStroke = Stk(tabBtn, Color3.fromRGB(30, 70, 110), 1) 
    tabStroke.Transparency = 0.5 

    local icon = New("ImageLabel", { 
        Size = UDim2.new(0, 20, 0, 20), 
        Position = UDim2.new(0, 10, 0.5, -10), 
        BackgroundTransparency = 1, 
        Image = iconId or "", 
        ImageColor3 = T.textMuted, 
        ZIndex = 5, 
        Parent = tabBtn 
    }) 

    local txt = New("TextLabel", { 
        Size = UDim2.new(1, -38, 1, 0), 
        Position = UDim2.new(0, 36, 0, 0), 
        BackgroundTransparency = 1, 
        Text = name, 
        TextColor3 = T.textMuted, 
        Font = Enum.Font.GothamMedium, 
        TextSize = 13, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        ZIndex = 5, 
        Parent = tabBtn 
    }) 

    -- PÁGINA ASOCIADA (CON SCROLL DINÁMICO CORREGIDO)
    local page = New("ScrollingFrame", { 
        Size = UDim2.fromScale(1, 1), 
        BackgroundTransparency = 1, 
        Visible = false, 
        ScrollBarThickness = 2, 
        ScrollBarImageColor3 = T.border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, 
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.ContentArea 
    }) 
    List(page, Enum.FillDirection.Vertical, 8) 
    Pad(page, 10, 10, 10, 10) 

    -- EVENTO CAMBIAR DE TAB
    tabBtn.MouseButton1Click:Connect(function() 
        for _, t in pairs(self.Tabs) do 
            Tween(t.btn, 0.2, { BackgroundTransparency = 0.8 }) 
            t.grad.Transparency = NumberSequence.new(1)
            t.txt.TextColor3 = T.textMuted 
            t.icon.ImageColor3 = T.textMuted
            t.stroke.Color = Color3.fromRGB(30, 70, 110)
        end 

        for _, p in pairs(self.Pages) do 
            p.Visible = false 
        end 

        Tween(tabBtn, 0.2, { BackgroundTransparency = 0 }) 
        tabGrad.Transparency = NumberSequence.new(0)
        txt.TextColor3 = Color3.fromRGB(255, 255, 255) 
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Color = T.border
        page.Visible = true 
        self.ActivePage = page 
    end) 

    -- SELECCIÓN AUTOMÁTICA DE PRIMERA TAB
    if not self.ActivePage then 
        self.ActivePage = page 
        page.Visible = true 
        tabBtn.BackgroundTransparency = 0
        tabGrad.Transparency = NumberSequence.new(0)
        txt.TextColor3 = Color3.fromRGB(255, 255, 255) 
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Color = T.border
    end 

    table.insert(self.Tabs, { btn = tabBtn, grad = tabGrad, stroke = tabStroke, txt = txt, icon = icon }) 
    table.insert(self.Pages, page) 

    local TabMethods = { Library = self, Page = page } 

    -- ============================================================ 
    -- SECCIÓN 
    -- ============================================================ 
    function TabMethods:CreateSection(title) 
        local container = New("Frame", { 
            Size = UDim2.new(1, 0, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y, 
            BackgroundTransparency = 1, 
            ZIndex = 5, 
            Parent = page 
        }) 
        List(container, Enum.FillDirection.Vertical, 6) 

        New("TextLabel", { 
            Size = UDim2.new(1, 0, 0, 22), 
            BackgroundTransparency = 1, 
            Text = string.upper(title), 
            TextColor3 = Color3.fromRGB(0, 180, 255), 
            Font = Enum.Font.GothamBold, 
            TextSize = 11, 
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
        List(card, Enum.FillDirection.Vertical, 6) 

        local ElementMethods = { Card = card, Library = self.Library } 

        -- ========== TOGGLE ========== 
        function ElementMethods:AddToggle(lbl, def, cb) 
            local row = New("Frame", { 
                Size = UDim2.new(1, 0, 0, 38), 
                BackgroundColor3 = T.panel2, 
                ZIndex = 5, 
                Parent = card 
            }) 
            Cor(row, 10) 
            Stk(row, Color3.fromRGB(20, 45, 75), 1) 

            local rowGrad = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 26, 48)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 16, 32))
                }),
                Rotation = 90,
                Parent = row
            })

            New("TextLabel", { 
                Position = UDim2.new(0, 12, 0, 0), 
                Size = UDim2.new(1, -70, 1, 0), 
                BackgroundTransparency = 1, 
                Text = lbl, 
                TextColor3 = Color3.fromRGB(240, 245, 255), 
                Font = Enum.Font.GothamMedium, 
                TextSize = 12, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                ZIndex = 6, 
                Parent = row 
            }) 

            local switchBg = New("Frame", { 
                AnchorPoint = Vector2.new(1, 0.5), 
                Position = UDim2.new(1, -10, 0.5, 0), 
                Size = UDim2.new(0, 40, 0, 20), 
                BackgroundColor3 = def and T.acc or T.switchOff, 
                ZIndex = 6, 
                Parent = row 
            }) 
            Cor(switchBg, 10) 
            Stk(switchBg, Color3.fromRGB(30, 70, 110), 1) 

            local knob = New("Frame", { 
                AnchorPoint = Vector2.new(0, 0.5), 
                Size = UDim2.new(0, 14, 0, 14), 
                Position = def and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), 
                BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
                ZIndex = 7, 
                Parent = switchBg 
            }) 
            Cor(knob, 7) 

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
                Tween(switchBg, 0.25, { BackgroundColor3 = def and T.acc or T.switchOff })
                Tween(knob, 0.25, { Position = def and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }) 
            end) 
        end 

        -- ========== SLIDER ========== 
        function ElementMethods:AddSlider(lbl, mn, mx, def, cb) 
            local row = New("Frame", { 
                Size = UDim2.new(1, 0, 0, 42), 
                BackgroundColor3 = T.panel2, 
                ZIndex = 5, 
                Parent = card 
            }) 
            Cor(row, 10) 
            Stk(row, Color3.fromRGB(20, 45, 75), 1) 

            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 26, 48)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 16, 32))
                }),
                Rotation = 90,
                Parent = row
            })

            local valInput = New("TextBox", { 
                Position = UDim2.new(0, 10, 0.5, -10), 
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
                Position = UDim2.new(1, -10, 0.5, 0), 
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
                Position = UDim2.new(0, 50, 0.5, -3), 
                Size = UDim2.new(1, -190, 0, 6), 
                BackgroundColor3 = Color3.fromRGB(12, 24, 42), 
                ZIndex = 6, 
                Parent = row 
            }) 
            Cor(track, 3) 

            local fill = New("Frame", { 
                BackgroundColor3 = T.border, 
                Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0), 
                ZIndex = 7, 
                Parent = track 
            }) 
            Cor(fill, 3) 

            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 240))
                }),
                Parent = fill
            })

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

        -- ========== DROPDOWN ========== 
        function ElementMethods:AddDropdown(lbl, options, defaultIdx, cb) 
            local currIdx = defaultIdx or 1 
            local dropdownOpen = false 

            local row = New("Frame", { 
                Size = UDim2.new(1, 0, 0, 38), 
                BackgroundColor3 = T.panel2, 
                ClipsDescendants = true, 
                ZIndex = 5, 
                Parent = card 
            }) 
            Cor(row, 10) 
            Stk(row, Color3.fromRGB(20, 45, 75), 1) 

            local header = New("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, ZIndex = 6, Parent = row }) 

            New("TextLabel", { 
                Position = UDim2.new(0, 12, 0, 0), 
                Size = UDim2.new(0.5, 0, 1, 0), 
                BackgroundTransparency = 1, 
                Text = lbl, 
                TextColor3 = Color3.fromRGB(240, 245, 255), 
                Font = Enum.Font.GothamMedium, 
                TextSize = 12, 
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
                TextColor3 = Color3.fromRGB(240, 245, 255), 
                Font = Enum.Font.GothamBold, 
                TextSize = 11, 
                ZIndex = 6, 
                Parent = header 
            }) 
            Cor(selectBtn, 8) 
            Stk(selectBtn, T.border, 1) 

            local optionsHolder = New("ScrollingFrame", { 
                Position = UDim2.new(0, 10, 0, 42), 
                Size = UDim2.new(1, -20, 0, 100), 
                BackgroundTransparency = 1, 
                ScrollBarThickness = 2, 
                ScrollBarImageColor3 = T.border,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0,0,0,0),
                ZIndex = 6, 
                Parent = row 
            }) 
            List(optionsHolder, Enum.FillDirection.Vertical, 4) 
            Pad(optionsHolder, 2, 2, 2, 2) 

            for i, opt in ipairs(options) do 
                local isSelected = (i == currIdx) 
                local optBtn = New("TextButton", { 
                    Size = UDim2.new(1, -4, 0, 24), 
                    BackgroundColor3 = isSelected and Color3.fromRGB(20, 50, 90) or Color3.fromRGB(12, 22, 38), 
                    Text = opt, 
                    TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 230), 
                    Font = Enum.Font.GothamBold, 
                    TextSize = 11, 
                    ZIndex = 7, 
                    Parent = optionsHolder 
                }) 
                Cor(optBtn, 6) 

                optBtn.MouseButton1Click:Connect(function() 
                    currIdx = i 
                    cb(opt) 
                    dropdownOpen = false 
                    selectBtn.Text = options[currIdx] .. " ▼" 
                    Tween(row, 0.25, { Size = UDim2.new(1, 0, 0, 38) }) 
                end) 
            end 

            selectBtn.MouseButton1Click:Connect(function() 
                dropdownOpen = not dropdownOpen 
                local contentHeight = (#options * 28) + 8 
                local holderHeight = math.min(contentHeight, 100) 
                optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight) 
                selectBtn.Text = options[currIdx] .. (dropdownOpen and " ▲" or " ▼") 
                Tween(row, 0.25, { Size = UDim2.new(1, 0, 0, dropdownOpen and (44 + holderHeight + 6) or 38) }) 
            end) 
        end 

        -- ========== COLOR PICKER ========== 
        function ElementMethods:AddColorPicker(lbl, defaultColor, cb) 
            local savedColor = defaultColor or Color3.fromRGB(255, 255, 255) 
            local tempColor = savedColor 

            local row = New("Frame", { 
                Size = UDim2.new(1, 0, 0, 38), 
                BackgroundColor3 = T.panel2, 
                ZIndex = 5, 
                Parent = card 
            }) 
            Cor(row, 10) 
            Stk(row, Color3.fromRGB(20, 45, 75), 1) 

            New("TextLabel", { 
                Position = UDim2.new(0, 12, 0, 0), 
                Size = UDim2.new(0.6, 0, 1, 0), 
                BackgroundTransparency = 1, 
                Text = lbl, 
                TextColor3 = Color3.fromRGB(240, 245, 255), 
                Font = Enum.Font.GothamMedium, 
                TextSize = 12, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                ZIndex = 6, 
                Parent = row 
            }) 

            local colorPreview = New("TextButton", { 
                AnchorPoint = Vector2.new(1, 0.5), 
                Position = UDim2.new(1, -10, 0.5, 0), 
                Size = UDim2.new(0, 36, 0, 20), 
                BackgroundColor3 = savedColor, 
                Text = "", 
                ZIndex = 6, 
                Parent = row 
            }) 
            Cor(colorPreview, 6) 
            Stk(colorPreview, T.border, 1) 

            local screenGui = card:FindFirstAncestorOfClass("ScreenGui") 
            local modalOverlay = New("Frame", { 
                Position = UDim2.new(0, -200, 0, -200), 
                Size = UDim2.new(1, 400, 1, 400), 
                BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
                BackgroundTransparency = 0.5, 
                Visible = false, 
                ZIndex = 100, 
                Parent = screenGui 
            }) 

            local modalFrame = New("Frame", { 
                AnchorPoint = Vector2.new(0.5, 0.5), 
                Position = UDim2.fromScale(0.5, 0.5), 
                Size = UDim2.new(0, 320, 0, 260), 
                BackgroundColor3 = Color3.fromRGB(8, 16, 30), 
                ZIndex = 101, 
                Parent = modalOverlay 
            }) 
            Cor(modalFrame, 16) 
            Stk(modalFrame, T.border, 1.5) 

            New("TextLabel", { 
                Position = UDim2.new(0, 16, 0, 12), 
                Size = UDim2.new(1, -32, 0, 20), 
                BackgroundTransparency = 1, 
                Text = lbl, 
                TextColor3 = Color3.fromRGB(255, 255, 255), 
                Font = Enum.Font.GothamBold, 
                TextSize = 14, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                ZIndex = 102, 
                Parent = modalFrame 
            }) 

            local svBox = New("TextButton", { 
                Position = UDim2.new(0, 16, 0, 40), 
                Size = UDim2.new(0, 140, 0, 130), 
                BackgroundColor3 = Color3.fromRGB(255, 0, 0), 
                Text = "", 
                AutoButtonColor = false, 
                ZIndex = 102, 
                Parent = modalFrame 
            }) 
            Cor(svBox, 8) 

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
            Cor(blackOverlay, 8) 

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
                Size = UDim2.new(0, 10, 0, 10), 
                BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
                ZIndex = 104, 
                Parent = svBox 
            }) 
            Cor(pickerCursor, 5) 
            Stk(pickerCursor, Color3.fromRGB(0, 0, 0), 1.2) 

            local hueBar = New("TextButton", { 
                Position = UDim2.new(0, 168, 0, 40), 
                Size = UDim2.new(0, 14, 0, 130), 
                BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
                Text = "", 
                AutoButtonColor = false, 
                ZIndex = 102, 
                Parent = modalFrame 
            }) 
            Cor(hueBar, 6) 

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

            local cancelBtn = New("TextButton", { 
                Position = UDim2.new(0, 16, 0, 190), 
                Size = UDim2.new(0, 136, 0, 36), 
                BackgroundColor3 = Color3.fromRGB(14, 25, 45), 
                Text = "Cancel", 
                TextColor3 = Color3.fromRGB(220, 230, 255), 
                Font = Enum.Font.GothamBold, 
                TextSize = 13, 
                ZIndex = 102, 
                Parent = modalFrame 
            }) 
            Cor(cancelBtn, 10) 
            Stk(cancelBtn, Color3.fromRGB(30, 80, 150), 1) 

            local applyBtn = New("TextButton", { 
                Position = UDim2.new(0, 160, 0, 190), 
                Size = UDim2.new(0, 136, 0, 36), 
                BackgroundColor3 = Color3.fromRGB(0, 130, 240), 
                Text = "Apply", 
                TextColor3 = Color3.fromRGB(255, 255, 255), 
                Font = Enum.Font.GothamBold, 
                TextSize = 13, 
                ZIndex = 102, 
                Parent = modalFrame 
            }) 
            Cor(applyBtn, 10) 

            local h, s, v = Color3.toHSV(savedColor) 
            local function refreshUI() 
                tempColor = Color3.fromHSV(h, s, v) 
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) 
            end 

            colorPreview.MouseButton1Click:Connect(function() 
                tempColor = savedColor 
                h, s, v = Color3.toHSV(savedColor) 
                pickerCursor.Position = UDim2.fromScale(s, 1 - v) 
                refreshUI() 
                modalOverlay.Visible = true 
            end) 

            cancelBtn.MouseButton1Click:Connect(function() modalOverlay.Visible = false end) 
            applyBtn.MouseButton1Click:Connect(function() 
                savedColor = tempColor 
                colorPreview.BackgroundColor3 = savedColor 
                cb(savedColor) 
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
        end 

        return ElementMethods 
    end 

    return TabMethods 
end

return Library
