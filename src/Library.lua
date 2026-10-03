local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- 🔴 CAMBIA ESTA URL POR TU RUTA DE GITHUB RAW
local GITHUB_RAW_BASE = "https://raw.githubusercontent.com/CodeVoult/ImperialUI-/main/elements/"

local function LoadElement(name)
    local success, result = pcall(function()
        -- ModuleScript layout also supports Studio without loadstring/HTTP.
        if script then
            local root = script.Parent.Parent
            local folder = root:FindFirstChild("elements")
            local module = folder and folder:FindFirstChild(name)
            if module then return require(module) end
        end
        local url = GITHUB_RAW_BASE .. name .. ".lua?v=" .. tostring(os.time())
        local source = game:HttpGet(url)
        local chunk, compileError = loadstring(source)
        if not chunk then error("Lua syntax error: " .. tostring(compileError)) end
        return chunk()
    end)
    if not success or not result then
        error("[ImperialUI] No se pudo cargar el módulo " .. name .. ": " .. tostring(result)
            .. ". Confirma que el archivo exista en GitHub y que el repositorio esté actualizado.", 2)
    end
    return result
end

-- Cargar módulos
local Spring           = LoadElement("Spring")
local SpringAnimations = LoadElement("SpringAnimations")
local TabsModule       = LoadElement("Tabs")
local ToggleModule     = LoadElement("Toggle")
local ButtonModule     = LoadElement("Button")
local SliderModule     = LoadElement("Slider")
local DropdownModule   = LoadElement("Dropdown")
local ColorPickerModule = LoadElement("ColorPicker")
local Themes = LoadElement("Themes")
local Icons = LoadElement("Icons")

local Library = {}
Library.__index = Library

-- ================================================================= --
-- CONFIGURACIÓN DE COLORES Y UTILIDADES
-- ================================================================= --
local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end
Library.New = New

local function Cor(obj, r) return New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj }) end
Library.Cor = Cor

local function Stk(obj, col, th) return New("UIStroke", { Color = col or T.border, Thickness = th or 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = obj }) end
Library.Stk = Stk

local function List(obj, dir, pad) return New("UIListLayout", { FillDirection = dir or Enum.FillDirection.Vertical, Padding = UDim.new(0, pad or 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = obj }) end
Library.List = List

local function Pad(obj, t, b, l, r) New("UIPadding", { PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = obj }) end
Library.Pad = Pad

local function Tween(obj, t, props, style, dir) 
    local anim = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props) 
    anim:Play() 
    return anim 
end
Library.Tween = Tween

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
Library.Shadow = Shadow

function Library:Track(connection)
    table.insert(self.Connections, connection)
    return connection
end

function Library:BindTheme(object, property, token)
    local binding = {object = object, property = property, token = token}
    table.insert(self.ThemeBindings, binding)
    object[property] = type(token) == "function" and token(self.T) or self.T[token]
    return object
end

function Library:SetTheme(name)
    local palette = Themes.Get(name) -- Validate before modifying the current theme.
    for key, value in pairs(palette) do self.T[key] = value end
    self.ThemeName = name
    for i = #self.ThemeBindings, 1, -1 do
        local binding = self.ThemeBindings[i]
        if binding.object.Parent then
            binding.object[binding.property] = type(binding.token) == "function"
                and binding.token(self.T) or self.T[binding.token]
        else
            table.remove(self.ThemeBindings, i)
        end
    end
end

function Library:GetThemes()
    local names = {}
    for i, name in ipairs(Themes.Names) do names[i] = name end
    return names
end

function Library:SetIcon(image, value, fallback)
    return Icons.Set(self, image, value, fallback)
end

function Library:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    for _, connection in ipairs(self.Connections) do connection:Disconnect() end
    self.Connections = {}
    self.ThemeBindings = {}
    if self.GUI then self.GUI:Destroy() end
end

-- ================================================================= --
-- CREACIÓN DE LA VENTANA (con título limpio)
-- ================================================================= --
function Library:CreateWindow(hubTitle)
    local options = type(hubTitle) == "table" and hubTitle or {Title = hubTitle}
    local self = setmetatable({}, Library)
    self.LogoLocked = false
    self.Pages = {}
    self.Tabs = {}
    self.Connections = {}
    self.ThemeBindings = {}
    self.ThemeName = options.Theme or "Midnight"
    self.T = Themes.Get(self.ThemeName)
    local T = self.T

    -- Limpiar el título de cualquier etiqueta HTML para que sea texto plano
    local cleanTitle = tostring(options.Title or "ImperialUI"):gsub("<[^>]*>", "")

    local parent = options.Parent
    if not parent then
        local ok, hidden = pcall(function() return gethui and gethui() end)
        parent = ok and hidden or nil
        if not parent then
            local coreOk, core = pcall(function() return game:GetService("CoreGui") end)
            parent = coreOk and core or nil
        end
        if not parent then
            local player = Players.LocalPlayer
            assert(player, "[ImperialUI] CreateWindow debe ejecutarse desde un cliente Roblox.")
            parent = player:WaitForChild("PlayerGui")
        end
    end

    -- GUI principal
    self.GUI = New("ScreenGui", {
        Name = "ImperialUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        DisplayOrder = 100,
        Parent = parent
    })
    self:Track(self.GUI.Destroying:Connect(function() self:Destroy() end))

    -- Sonido de clic
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://4590657391"
    clickSound.Volume = 0.5
    clickSound.Parent = self.GUI

    self:Track(self.GUI.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            self:Track(obj.MouseButton1Click:Connect(function() clickSound:Play() end))
        end
    end))

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

    -- Ícono flotante
    self.FloatIcon = New("TextButton", {
        Name = "FloatIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 140, 0, 42),
        Position = UDim2.new(0.5, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(10, 14, 23),
        BackgroundTransparency = 0.35,
        Text = "Abrir menú",
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

    -- Etiqueta para animación de cierre (se usa desde el módulo de animación)
    self.closeTextLabel = New("TextLabel", {
        Name = "CloseTextAnim",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 140, 0, 42),
        BackgroundTransparency = 1,
        Text = "Abrir menú",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextTransparency = 1,
        Visible = false,
        ZIndex = 999999998,
        Parent = self.GUI
    })

    -- Ventana principal
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
    self.WinCorner = Cor(self.WinMain, 21)
    self.WinScale = New("UIScale", { Scale = 1, Parent = self.WinMain })

    local winInner = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        Parent = self.WinMain
    })
    Cor(winInner, 16)
    winInner.BackgroundTransparency = 0
    self:BindTheme(winInner, "BackgroundColor3", "bg")

    local bgGradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 132, 230)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(16, 66, 132)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 14, 38))
        }),
        Rotation = 45,
        Parent = winInner
    })
    bgGradient:Destroy()

    self.borderStroke = New("UIStroke", {
        Name = "BorderStroke",
        Thickness = 1,
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
        Parent = self.borderStroke
    })
    borderGradient:Destroy()

    -- Contenido (se muestra cuando la ventana está abierta)
    self.ContentGroup = New("CanvasGroup", {
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

    -- Barra de título
    self.titleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = self.ContentGroup
    })

    -- Título en texto plano (sin formato)
    local titleLabel = New("TextLabel", {
        Size = UDim2.new(1, -170, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = cleanTitle,   -- <-- título limpio
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = self.titleBar
    })
    self:BindTheme(titleLabel, "TextColor3", "text")
    local minimize = New("TextButton", {
        Name = "Minimize", Text = "—", Font = Enum.Font.GothamMedium, TextSize = 18,
        Position = UDim2.new(1, -80, 0, 10), Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1, ZIndex = 8, Parent = self.titleBar,
    })
    local close = New("TextButton", {
        Name = "Close", Text = "×", Font = Enum.Font.GothamMedium, TextSize = 22,
        Position = UDim2.new(1, -44, 0, 10), Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1, ZIndex = 8, Parent = self.titleBar,
    })
    self:BindTheme(minimize, "TextColor3", "muted")
    self:BindTheme(close, "TextColor3", "muted")
    minimize.MouseButton1Click:Connect(function() self:Close() end)
    close.MouseButton1Click:Connect(function() self:Destroy() end)

    -- Sidebar
    self.Sidebar = New("ScrollingFrame", {
    Position = UDim2.new(0, 6, 0, 50),
    Size = UDim2.new(0, T.tabSize - 30, 1, -60),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ScrollBarThickness = 4,          -- <-- ahora se ve el scroll
    ScrollBarImageColor3 = Color3.fromRGB(0, 166, 255),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 3,
    Parent = self.ContentGroup
})
    List(self.Sidebar, Enum.FillDirection.Vertical, 6)
    Pad(self.Sidebar, 4, 12, 2, 6)

    -- Área de contenido
    self.ContentArea = New("Frame", {
        Position = UDim2.new(0, T.tabSize - 20, 0, 50),
        Size = UDim2.new(1, -T.tabSize + 14, 1, -56),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        ZIndex = 3,
        Parent = self.ContentGroup
    })
    Cor(self.ContentArea, 16)

    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
    local targetWidth = math.clamp(math.min(options.Width or 720, viewport.X - 24), 300, 760)
    local targetHeight = math.clamp(math.min(options.Height or 460, viewport.Y - 24), 280, 600)

    self:BindTheme(self.WinMain, "BackgroundColor3", "bg")
    self:BindTheme(self.borderStroke, "Color", "border")
    self:BindTheme(self.ContentArea, "BackgroundColor3", "panel")
    self:BindTheme(self.Sidebar, "ScrollBarImageColor3", "acc")
    self:BindTheme(self.FloatIcon, "BackgroundColor3", "panel2")
    self:BindTheme(self.FloatIcon, "TextColor3", "text")
    self:BindTheme(self.closeTextLabel, "TextColor3", "text")
    lightStroke:ClearAllChildren()
    lightStroke.Thickness = 1
    self:BindTheme(lightStroke, "Color", "acc")

    -- Conectar animaciones (separa la lógica de animación)
    self.Animations = SpringAnimations.Setup(self, {
        targetWidth = targetWidth,
        targetHeight = targetHeight,
    }, Spring)

    -- Métodos para controlar la ventana desde fuera
    function self:Open()
        self.Animations.Open()
    end

    function self:Close()
        self.Animations.Close()
    end

    function self:Toggle()
        self.Animations.Toggle()
    end

    function self:IsOpen()
        return self.Animations.IsOpen()
    end

    -- Funciones de arrastre para el ícono flotante
    local function makeDraggable(obj, target)
        local dragStart, startPos, dragging
        obj.InputBegan:Connect(function(i)
            if self.LogoLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = i.Position
                startPos = target.Position
            end
        end)
        self:Track(UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local del = i.Position - dragStart
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + del.X, startPos.Y.Scale, startPos.Y.Offset + del.Y)
            end
        end))
        self:Track(UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                local parentSize = self.GUI.AbsoluteSize
                if parentSize.X > 0 and parentSize.Y > 0 then
                    local absPos = target.AbsolutePosition
                    local absSize = target.AbsoluteSize
                    target.Position = UDim2.new((absPos.X + (absSize.X / 2)) / parentSize.X, 0, (absPos.Y + (absSize.Y / 2)) / parentSize.Y, 0)
                end
            end
        end))
    end

    makeDraggable(self.FloatIcon, self.FloatIcon)

    -- Métodos de utilidad
    function self:SetScale(scaleValue)
        assert(type(scaleValue) == "number" and scaleValue == scaleValue, "Scale must be a number")
        scaleValue = math.clamp(scaleValue, 0.5, 1.5)
        if self.WinScale then self.WinScale.Scale = scaleValue end
    end

    function self:SetLogoVisible(visible)
        if self.FloatIcon then self.FloatIcon.Visible = visible end
    end

    function self:SetLogoLocked(locked)
        self.LogoLocked = locked
    end

    self:Track(UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and not UserInputService:GetFocusedTextBox()
            and input.KeyCode == (options.ToggleKey or Enum.KeyCode.RightShift) then
            self:Toggle()
        end
    end))
    if options.AutoOpen ~= false then self:Open() end
    return self
end

-- ================================================================= --
-- NOTIFICACIONES (sin cambios)
-- ================================================================= --
function Library:Notify(feature, state)
    local T = self.T
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
    self:BindTheme(card, "BackgroundColor3", "panel")
    self:BindTheme(st, "Color", "border")
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
    self:BindTheme(sub, "TextColor3", "text")

    local track = New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = T.sep,
        BackgroundTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })
    self:BindTheme(track, "BackgroundColor3", "sep")

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

-- ================================================================= --
-- CREACIÓN DE PESTAÑAS (CORREGIDO: acepta iconId)
-- ================================================================= --
function Library:CreateTab(name, iconId)
    -- Pasar el iconId al módulo TabsModule
    local page = TabsModule.Create(self, name, iconId)

    local TabMethods = { Library = self, Page = page }

    function TabMethods:Select()
        for _, tab in ipairs(self.Library.Tabs) do
            if tab.page == self.Page then tab.select() return end
        end
    end

    function TabMethods:CreateSection(title)
        local container = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = page
        })
        List(container, Enum.FillDirection.Vertical, 8)

        local heading = New("TextLabel", {
            Size = UDim2.new(1, -4, 0, 26),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = self.Library.T.text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Parent = container
        })
        self.Library:BindTheme(heading, "TextColor3", "text")

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
            ToggleModule.Add(self.Library, card, lbl, def, cb)
        end

        function ElementMethods:AddButton(lbl, cb)
            ButtonModule.Add(self.Library, card, lbl, cb)
        end

        function ElementMethods:AddSlider(lbl, mn, mx, def, cb)
            SliderModule.Add(self.Library, card, lbl, mn, mx, def, cb)
        end

        function ElementMethods:AddDropdown(lbl, options, defaultIdx, cb)
            DropdownModule.Add(self.Library, card, lbl, options, defaultIdx, cb)
        end

        function ElementMethods:AddColorPicker(lbl, defaultColor, cb)
            ColorPickerModule.Add(self.Library, card, lbl, defaultColor, cb)
        end

        return ElementMethods
    end

    return TabMethods
end

return Library
