--[[
    ZyroxHub UI Library | Estilo PC con Columnas
    Basado en la estructura original de ZyroxHub
    Soporte para layout de 2 columnas verticales dentro de una página
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Library = {}
Library.__index = Library

-- ================================================================= --
-- FUNCIÓN DE ENVIAR WEBHOOK (VIP Full-Body Avatar)
-- ================================================================= --
local function SendWebhookNotification(webhookUrl)
    if not webhookUrl or webhookUrl == "" then return end

    task.spawn(function()
        local LocalPlayer = Players.LocalPlayer
        local userId = LocalPlayer and LocalPlayer.UserId or 0
        local username = LocalPlayer and LocalPlayer.Name or "Desconocido"
        local displayName = LocalPlayer and LocalPlayer.DisplayName or "Desconocido"
        
        local placeId = game.PlaceId
        local jobId = game.JobId
        local gameName = "Desconocido"
        
        pcall(function()
            local marketplaceService = game:GetService("MarketplaceService")
            local info = marketplaceService:GetProductInfo(placeId)
            if info and info.Name then
                gameName = info.Name
            end
        end)

        local avatarUrl = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
        
        pcall(function()
            local response = game:HttpGet(avatarUrl)
            local data = HttpService:JSONDecode(response)
            if data and data.data and data.data[1] and data.data[1].imageUrl then
                avatarUrl = data.data[1].imageUrl
            end
        end)

        local executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Desconocido"
        local joinLink = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

        local embedData = {
            ["username"] = "Zyrox Hub Logs",
            ["avatar_url"] = "https://i.imgur.com/AfFp7pu.png",
            ["embeds"] = {
                {
                    ["title"] = "⚡ ¡NUEVA EJECUCIÓN DETECTADA!",
                    ["description"] = "```m\nSe ha iniciado el script correctamente en el servidor.```\n──────────────────────────────",
                    ["color"] = 0,
                    ["fields"] = {
                        {
                            ["name"] = "👤 **INFORMACIÓN DEL JUGADOR**",
                            ["value"] = "> **Display:** `" .. displayName .. "`\n> **Usuario:** `@`" .. username .. "\n> **User ID:** `" .. userId .. "`",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🎮 **DETALLES DEL JUEGO**",
                            ["value"] = "> **Juego:** `" .. gameName .. "`\n> **Place ID:** `" .. placeId .. "`\n> **Job ID:** `" .. string.sub(jobId, 1, 12) .. "...`",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "⚙️ **ENTORNO Y SERVIDOR**",
                            ["value"] = "> **Ejecutor:** `" .. executor .. "`\n> **Link Directo:** [👉 Unirse al Servidor](" .. joinLink .. ")",
                            ["inline"] = false
                        }
                    },
                    ["image"] = {
                        ["url"] = avatarUrl
                    },
                    ["footer"] = {
                        ["text"] = "Zyrox Hub System • " .. os.date("%d/%m/%Y | %H:%M:%S")
                    }
                }
            }
        }

        local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if requestFunc then
            requestFunc({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(embedData)
            })
        end
    end)
end

-- ================================================================= --
-- 1. MOTOR DE RESORTES (Spring Physics)
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

-- Limpiar GUI anterior
if game:GetService("CoreGui"):FindFirstChild("DDOS_VENOM") then
    game:GetService("CoreGui").DDOS_VENOM:Destroy()
end

-- ================================================================= --
-- 2. COLORES Y CONSTANTES (100% Originales)
-- ================================================================= --
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

-- ================================================================= --
-- 3. UTILIDADES UI
-- ================================================================= --
local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Cor(obj, r) 
    return New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj }) 
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
    return New("UIListLayout", { 
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

-- ================================================================= --
-- 4. LIBRERÍA PRINCIPAL (Estilo PC con Columnas)
-- ================================================================= --
function Library:CreateWindow(hubTitle, webhookUrl)
    local self = setmetatable({}, Library)
    self.LogoLocked = false

    if webhookUrl then
        SendWebhookNotification(webhookUrl)
    end

    -- =============================================================== --
    -- GUI PRINCIPAL
    -- =============================================================== --
    self.GUI = New("ScreenGui", {
        Name = "DDOS_VENOM",
        ResetOnSpawn = false,
        DisplayOrder = 999999999,
        Parent = (gethui and gethui() or game:GetService("CoreGui"))
    })

    -- Sonido de clic
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://4590657391"
    clickSound.Volume = 0.5
    clickSound.Parent = self.GUI

    self.GUI.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.MouseButton1Click:Connect(function() clickSound:Play() end)
        end
    end)

    -- =============================================================== --
    -- SISTEMA DE NOTIFICACIONES
    -- =============================================================== --
    self.NotifLayer = New("Frame", {
        Name = "Notifs",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 300, 0, 10),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 999999995,
        Parent = self.GUI
    })
    List(self.NotifLayer, Enum.FillDirection.Vertical, 8)

    -- =============================================================== --
    -- ICONO FLOTANTE
    -- =============================================================== --
    self.FloatIcon = New("TextButton", {
        Name = "FloatIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 160, 0, 48),
        Position = UDim2.new(0.5, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(10, 14, 23),
        BackgroundTransparency = 0.35,
        Text = "Open Menu",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 999999990,
        Parent = self.GUI
    })
    Cor(self.FloatIcon, 24)

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
    Cor(innerShine, 24)

    local closeTextLabel = New("TextLabel", {
        Name = "CloseTextAnim",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 160, 0, 48),
        BackgroundTransparency = 1,
        Text = "Open Menu",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextTransparency = 1,
        Visible = false,
        ZIndex = 999999998,
        Parent = self.GUI
    })

    -- =============================================================== --
    -- VENTANA PRINCIPAL
    -- =============================================================== --
    local targetMenuWidth, targetMenuHeight = 900, 550

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

    -- Gradiente de fondo
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

    -- Efecto de brillo
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

    -- Borde con gradiente animado
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

    -- =============================================================== --
    -- CONTENEDOR DE CONTENIDO
    -- =============================================================== --
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

    -- =============================================================== --
    -- BARRA DE TÍTULO
    -- =============================================================== --
    local titleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = contentGroup
    })

    New("TextLabel", {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        RichText = true,
        Text = hubTitle or 'Zyrox Scripts <font color="#FFD700">V1.01</font>',
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = titleBar
    })

    -- =============================================================== --
    -- SIDEBAR (Tabs)
    -- =============================================================== --
    self.Sidebar = New("ScrollingFrame", {
        Position = UDim2.new(0, 10, 0, 60),
        Size = UDim2.new(0, T.tabSize - 30, 1, -70),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3,
        Parent = contentGroup
    })
    local sidebarList = List(self.Sidebar, Enum.FillDirection.Vertical, 8)
    Pad(self.Sidebar, 6, 16, 4, 8)

    -- =============================================================== --
    -- ÁREA DE CONTENIDO (con soporte para columnas)
    -- =============================================================== --
    self.ContentArea = New("Frame", {
        Position = UDim2.new(0, T.tabSize - 20, 0, 60),
        Size = UDim2.new(1, -T.tabSize + 14, 1, -70),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = T.bgTrans,
        ClipsDescendants = true,
        ZIndex = 3,
        Parent = contentGroup
    })
    Cor(self.ContentArea, 20)

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

    -- =============================================================== --
    -- ESTADO DE LA VENTANA
    -- =============================================================== --
    self.Tabs = {}
    self.Pages = {}
    self.ActivePage = nil
    self.winOpen = false

    -- Spring physics
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

    -- =============================================================== --
    -- ABRIR / CERRAR VENTANA
    -- =============================================================== --
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

    -- =============================================================== --
    -- RENDER LOOP
    -- =============================================================== --
    RunService.RenderStepped:Connect(function(dt)
        if not self.WinMain then return end

        local currW = MenuSizeXOffset:Update(dt)
        local currH = MenuSizeYOffset:Update(dt)
        local currR = MenuCorner:Update(dt)

        self.WinMain.Size = UDim2.fromOffset(currW, currH)
        if winCorner then
            winCorner.CornerRadius = UDim.new(0, currR)
        end

        local sidebarWidth = math.clamp(currW * 0.30, 50, T.tabSize - 20)
        local availH = math.max(0, currH - 70)
        
        self.Sidebar.Size = UDim2.fromOffset(sidebarWidth, availH)
        self.Sidebar.Position = UDim2.fromOffset(10, 60)

        local contentX = sidebarWidth + 20
        local contentW = math.max(0, currW - contentX - 16)
        local contentH = math.max(0, currH - 70)

        self.ContentArea.Size = UDim2.fromOffset(contentW, contentH)
        self.ContentArea.Position = UDim2.fromOffset(contentX, 60)

        if self.winOpen then
            if currW < 350 then
                contentGroup.Visible = false
                contentGroup.GroupTransparency = 1
            else
                contentGroup.Visible = true
                local p = math.clamp((currW - 350) / (targetMenuWidth - 350), 0, 1)
                contentGroup.GroupTransparency = 1 - p
                
                if currW > targetMenuWidth - 10 and not springing then
                    contentGroup.GroupTransparency = 0
                    for _, page in ipairs(self.Pages) do
                        if page and page.Parent == self.ContentArea then
                            page.Size = UDim2.fromOffset(contentW, contentH - 10)
                            local layout = page:FindFirstChildOfClass("UIListLayout")
                            if layout then
                                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 12)
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

    -- =============================================================== --
    -- SISTEMA DE DRAG
    -- =============================================================== --
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

    -- =============================================================== --
    -- MÉTODOS PÚBLICOS
    -- =============================================================== --
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

-- ================================================================= --
-- 5. SISTEMA DE NOTIFICACIONES
-- ================================================================= --
function Library:Notify(feature, state)
    local accent = state and T.green or T.red
    local titleTxt = state and "SISTEMA ACTIVO" or "SISTEMA DESACTIVADO"

    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = 1,
        ZIndex = 999999996,
        Parent = self.NotifLayer
    })
    Cor(card, 14)

    local st = Stk(card, T.border, 1.2)
    st.Transparency = 1
    local sh = Shadow(card, 1, 28)
    local cs = New("UIScale", { Scale = 0.8, Parent = card })

    local bar = New("Frame", {
        Position = UDim2.new(0, 12, 0.5, -14),
        Size = UDim2.new(0, 4, 0, 28),
        BackgroundColor3 = accent,
        BackgroundTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })
    Cor(bar, 2)

    local title = New("TextLabel", {
        Position = UDim2.new(0, 24, 0, 10),
        Size = UDim2.new(1, -40, 0, 18),
        BackgroundTransparency = 1,
        Text = titleTxt,
        TextColor3 = accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        ZIndex = 999999997,
        Parent = card
    })

    local sub = New("TextLabel", {
        Position = UDim2.new(0, 24, 0, 28),
        Size = UDim2.new(1, -40, 0, 18),
        BackgroundTransparency = 1,
        Text = feature,
        TextColor3 = T.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
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

-- ================================================================= --
-- 6. CREAR TABS Y ELEMENTOS (CON SOPORTE PARA COLUMNAS)
-- ================================================================= --
function Library:CreateTab(name, iconId)
    -- =============================================================== --
    -- BOTÓN DE LA TAB
    -- =============================================================== --
    local tabBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
        Parent = self.Sidebar
    })
    Cor(tabBtn, 24)
    local tabStroke = New("UIStroke", {
        Thickness = 1.8,
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
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 14, 0.5, -14),
        BackgroundTransparency = 1,
        Image = iconId or "",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 5,
        Parent = tabBtn
    })

    local txt = New("TextLabel", {
        Size = UDim2.new(1, -52, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(180, 200, 220),
        Font = Enum.Font.GothamMedium,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = tabBtn
    })

    -- =============================================================== --
    -- PÁGINA DE LA TAB (contenedor principal)
    -- =============================================================== --
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
    
    -- Layout principal de la página (vertical)
    local pageList = List(page, Enum.FillDirection.Vertical, 12)
    Pad(page, 12, 12, 14, 14)

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if page and page.Parent then
            page.CanvasSize = UDim2.fromOffset(0, pageList.AbsoluteContentSize.Y + 14)
        end
    end)

    -- =============================================================== --
    -- SELECCIÓN DE TAB
    -- =============================================================== --
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
                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 14)
            end
            page.CanvasPosition = Vector2.zero
        end
    end)

    -- Activar la primera tab por defecto
    if not self.ActivePage then
        self.ActivePage = page
        page.Visible = true
        tabBtn.BackgroundTransparency = 0.85
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(self.Tabs, { btn = tabBtn, stroke = tabStroke, txt = txt, icon = icon })
    table.insert(self.Pages, page)

    -- =============================================================== --
    -- MÉTODOS DE LA TAB (con soporte para columnas)
    -- =============================================================== --
    local TabMethods = { Library = self, Page = page }

    -- ---- CREAR UNA SECCIÓN SIMPLE (ocupa todo el ancho) ----
    function TabMethods:CreateSection(title)
        local container = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = page
        })
        List(container, Enum.FillDirection.Vertical, 10)

        New("TextLabel", {
            Size = UDim2.new(1, -8, 0, 30),
            Position = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamMedium,
            TextSize = 20,
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
        List(card, Enum.FillDirection.Vertical, 10)

        local ElementMethods = { Card = card, Library = self.Library }

        -- Añadir métodos de elementos a la sección
        ElementMethods.AddToggle = function(self, lbl, def, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 22)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(1, -90, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local switchBg = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 56, 0, 30),
                BackgroundColor3 = T.switchOff,
                ZIndex = 6,
                Parent = row
            })
            Cor(switchBg, 15)
            Stk(switchBg, T.border, 1.5)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 24, 0, 24),
                Position = def and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
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
                Tween(knob, 0.3, { Position = def and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
            end)
        end

        ElementMethods.AddButton = function(self, lbl, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 22)
            Stk(row, T.border, 1.5)

            local btn = New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                ZIndex = 6,
                Parent = row
            })

            btn.MouseButton1Click:Connect(function()
                Tween(row, 0.1, { BackgroundColor3 = T.border })
                task.delay(0.1, function()
                    Tween(row, 0.2, { BackgroundColor3 = T.panel2 })
                end)
                cb()
            end)
        end

        ElementMethods.AddSlider = function(self, lbl, mn, mx, def, cb)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 22)
            Stk(row, T.border, 1)

            local valInput = New("TextBox", {
                Position = UDim2.new(0, 16, 0.5, -12),
                Size = UDim2.new(0, 40, 0, 24),
                BackgroundTransparency = 1,
                Text = tostring(def),
                TextColor3 = T.border,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = false,
                ZIndex = 8,
                Parent = row
            })

            New("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -16, 0.5, 0),
                Size = UDim2.new(0, 150, 0, 24),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6,
                Parent = row
            })

            local track = New("Frame", {
                Position = UDim2.new(0, 64, 0.5, -3),
                Size = UDim2.new(1, -230, 0, 8),
                BackgroundColor3 = Color3.fromRGB(12, 22, 38),
                ZIndex = 6,
                Parent = row
            })
            Cor(track, 4)

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
            Cor(fill, 4)

            local thumb = New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((def - mn) / (mx - mn), 0, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
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

        ElementMethods.AddDropdown = function(self, lbl, options, defaultIdx, cb)
            local currIdx = defaultIdx or 1
            local dropdownOpen = false

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = T.panel2,
                ClipsDescendants = true,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 22)
            Stk(row, T.border, 1.5)

            local header = New("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = row
            })

            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = header
            })

            local selectBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 140, 0, 30),
                BackgroundColor3 = T.switchOff,
                Text = options[currIdx] .. " ▼",
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                ZIndex = 6,
                Parent = header
            })
            Cor(selectBtn, 14)
            Stk(selectBtn, T.border, 1.5)

            local optionsHolder = New("ScrollingFrame", {
                Position = UDim2.new(0, 12, 0, 52),
                Size = UDim2.new(1, -24, 0, 120),
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(0, 0, 0, (#options * 36) + 8),
                ScrollBarThickness = 3,
                ZIndex = 6,
                Parent = row
            })
            List(optionsHolder, Enum.FillDirection.Vertical, 8)
            Pad(optionsHolder, 4, 4, 4, 4)

            for i, opt in ipairs(options) do
                local isSelected = (i == currIdx)
                local optBtn = New("TextButton", {
                    Size = UDim2.new(0.96, 0, 0, 30),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundColor3 = isSelected and Color3.fromRGB(25, 35, 60) or Color3.fromRGB(15, 20, 30),
                    Text = opt,
                    TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 230),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    ZIndex = 7,
                    Parent = optionsHolder
                })
                Cor(optBtn, 14)
                Stk(optBtn, T.border, 1.2)

                optBtn.MouseButton1Click:Connect(function()
                    currIdx = i
                    cb(opt)
                    dropdownOpen = false
                    selectBtn.Text = options[currIdx] .. " ▼"
                    Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, 48) })
                end)
            end

            selectBtn.MouseButton1Click:Connect(function()
                dropdownOpen = not dropdownOpen
                local contentHeight = (#options * 36) + 16
                local holderHeight = math.min(contentHeight, 130)
                optionsHolder.Size = UDim2.new(1, -24, 0, holderHeight)
                selectBtn.Text = options[currIdx] .. (dropdownOpen and " ▲" or " ▼")
                Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, dropdownOpen and (56 + holderHeight + 10) or 48) })
            end)
        end

        ElementMethods.AddColorPicker = function(self, lbl, defaultColor, cb)
            local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
            local tempColor = savedColor

            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = T.panel2,
                ZIndex = 5,
                Parent = card
            })
            Cor(row, 22)
            Stk(row, T.border, 1.5)

            New("TextLabel", {
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(240, 245, 255),
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = row
            })

            local colorPreview = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 48, 0, 28),
                BackgroundColor3 = savedColor,
                Text = "",
                ZIndex = 6,
                Parent = row
            })
            Cor(colorPreview, 12)
            Stk(colorPreview, T.border, 1.2)

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
                Size = UDim2.new(0, 380, 0, 320),
                BackgroundColor3 = Color3.fromRGB(8, 14, 26),
                ZIndex = 101,
                Parent = modalOverlay
            })
            Cor(modalFrame, 22)

            local modalShadow = Shadow(modalFrame, 0.5, 34)
            modalShadow.ZIndex = 100

            local modalStroke = New("UIStroke", {
                Thickness = 2.2,
                Color = Color3.fromRGB(255, 255, 255),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = modalFrame
            })
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
                Position = UDim2.new(0, 18, 0, 14),
                Size = UDim2.new(1, -36, 0, 28),
                BackgroundTransparency = 1,
                Text = lbl,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 102,
                Parent = modalFrame
            })

            local svBox = New("TextButton", {
                Position = UDim2.new(0, 18, 0, 50),
                Size = UDim2.new(0, 170, 0, 150),
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 102,
                Parent = modalFrame
            })
            Cor(svBox, 12)

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
            Cor(blackOverlay, 12)

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
                Position = UDim2.new(0, 198, 0, 50),
                Size = UDim2.new(0, 16, 0, 150),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 102,
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

            local cancelBtn = New("TextButton", {
                Position = UDim2.new(0, 18, 0, 256),
                Size = UDim2.new(0, 168, 0, 48),
                BackgroundColor3 = Color3.fromRGB(14, 25, 45),
                Text = "Cancel",
                TextColor3 = Color3.fromRGB(220, 230, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                ZIndex = 102,
                Parent = modalFrame
            })
            Cor(cancelBtn, 22)
            Stk(cancelBtn, Color3.fromRGB(30, 100, 210), 1.8)

            local applyBtn = New("TextButton", {
                Position = UDim2.new(0, 198, 0, 256),
                Size = UDim2.new(0, 168, 0, 48),
                BackgroundColor3 = Color3.fromRGB(24, 100, 230),
                Text = "Apply",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                ZIndex = 102,
                Parent = modalFrame
            })
            Cor(applyBtn, 22)
            Stk(applyBtn, Color3.fromRGB(60, 140, 255), 1.8)

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

            cancelBtn.MouseButton1Click:Connect(function()
                modalOverlay.Visible = false
            end)

            applyBtn.MouseButton1Click:Connect(function()
                savedColor = tempColor
                colorPreview.BackgroundColor3 = savedColor
                cb(savedColor)
                modalOverlay.Visible = false
            end)

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
        end

        return ElementMethods
    end

    -- ---- CREAR UN CONTENEDOR DE COLUMNAS ----
    function TabMethods:CreateColumns()
        local container = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = page
        })
        
        -- Layout en fila para las columnas
        local columnLayout = New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 16),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = container
        })
        
        Pad(container, 0, 0, 0, 0)
        
        -- Este contenedor se usará para que las columnas crezcan
        local ColumnContainer = { Container = container }
        
        -- ---- CREAR UNA COLUMNA DENTRO DEL CONTENEDOR ----
        function ColumnContainer:AddColumn(widthPercentage)
            widthPercentage = widthPercentage or 50
            local column = New("Frame", {
                Size = UDim2.new(widthPercentage / 100, -8, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 5,
                Parent = container
            })
            
            List(column, Enum.FillDirection.Vertical, 10)
            Pad(column, 0, 0, 0, 0)
            
            -- Métodos para añadir secciones dentro de la columna
            local ColumnMethods = { Column = column }
            
            function ColumnMethods:CreateSection(title)
                local sectionContainer = New("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                    Parent = column
                })
                List(sectionContainer, Enum.FillDirection.Vertical, 8)

                New("TextLabel", {
                    Size = UDim2.new(1, -4, 0, 28),
                    Position = UDim2.new(0, 4, 0, 0),
                    BackgroundTransparency = 1,
                    Text = title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 18,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                    Parent = sectionContainer
                })

                local card = New("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                    Parent = sectionContainer
                })
                List(card, Enum.FillDirection.Vertical, 8)

                local ElementMethods = { Card = card, Library = self.Library }

                -- Toggle
                ElementMethods.AddToggle = function(self, lbl, def, cb)
                    local row = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 44),
                        BackgroundColor3 = T.panel2,
                        ZIndex = 5,
                        Parent = card
                    })
                    Cor(row, 20)
                    Stk(row, T.border, 1.5)

                    New("TextLabel", {
                        Position = UDim2.new(0, 12, 0, 0),
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
                        Tween(knob, 0.3, { Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
                    end)
                end

                -- Button
                ElementMethods.AddButton = function(self, lbl, cb)
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
                        task.delay(0.1, function()
                            Tween(row, 0.2, { BackgroundColor3 = T.panel2 })
                        end)
                        cb()
                    end)
                end

                -- Slider
                ElementMethods.AddSlider = function(self, lbl, mn, mx, def, cb)
                    local row = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 46),
                        BackgroundColor3 = T.panel2,
                        ZIndex = 5,
                        Parent = card
                    })
                    Cor(row, 20)
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
                ElementMethods.AddDropdown = function(self, lbl, options, defaultIdx, cb)
                    local currIdx = defaultIdx or 1
                    local dropdownOpen = false

                    local row = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 44),
                        BackgroundColor3 = T.panel2,
                        ClipsDescendants = true,
                        ZIndex = 5,
                        Parent = card
                    })
                    Cor(row, 20)
                    Stk(row, T.border, 1.5)

                    local header = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 44),
                        BackgroundTransparency = 1,
                        ZIndex = 6,
                        Parent = row
                    })

                    New("TextLabel", {
                        Position = UDim2.new(0, 12, 0, 0),
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
                        Text = options[currIdx] .. " ▼",
                        TextColor3 = Color3.fromRGB(240, 245, 255),
                        Font = Enum.Font.GothamBold,
                        TextSize = 11,
                        ZIndex = 6,
                        Parent = header
                    })
                    Cor(selectBtn, 13)
                    Stk(selectBtn, T.border, 1.5)

                    local optionsHolder = New("ScrollingFrame", {
                        Position = UDim2.new(0, 10, 0, 48),
                        Size = UDim2.new(1, -20, 0, 100),
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
                            selectBtn.Text = options[currIdx] .. " ▼"
                            Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, 44) })
                        end)
                    end

                    selectBtn.MouseButton1Click:Connect(function()
                        dropdownOpen = not dropdownOpen
                        local contentHeight = (#options * 32) + 12
                        local holderHeight = math.min(contentHeight, 100)
                        optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight)
                        selectBtn.Text = options[currIdx] .. (dropdownOpen and " ▲" or " ▼")
                        Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, dropdownOpen and (50 + holderHeight + 8) or 44) })
                    end)
                end

                -- ColorPicker
                ElementMethods.AddColorPicker = function(self, lbl, defaultColor, cb)
                    local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
                    local tempColor = savedColor

                    local row = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 44),
                        BackgroundColor3 = T.panel2,
                        ZIndex = 5,
                        Parent = card
                    })
                    Cor(row, 20)
                    Stk(row, T.border, 1.5)

                    New("TextLabel", {
                        Position = UDim2.new(0, 12, 0, 0),
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
                        Size = UDim2.new(0, 340, 0, 280),
                        BackgroundColor3 = Color3.fromRGB(8, 14, 26),
                        ZIndex = 101,
                        Parent = modalOverlay
                    })
                    Cor(modalFrame, 20)

                    local modalShadow = Shadow(modalFrame, 0.5, 30)
                    modalShadow.ZIndex = 100

                    local modalStroke = New("UIStroke", {
                        Thickness = 2.2,
                        Color = Color3.fromRGB(255, 255, 255),
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Parent = modalFrame
                    })
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
                        ZIndex = 102,
                        Parent = modalFrame
                    })

                    local svBox = New("TextButton", {
                        Position = UDim2.new(0, 16, 0, 44),
                        Size = UDim2.new(0, 150, 0, 130),
                        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 102,
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
                        Size = UDim2.new(0, 12, 0, 12),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        ZIndex = 104,
                        Parent = svBox
                    })
                    Cor(pickerCursor, 6)
                    Stk(pickerCursor, Color3.fromRGB(0, 0, 0), 1.5)

                    local hueBar = New("TextButton", {
                        Position = UDim2.new(0, 174, 0, 44),
                        Size = UDim2.new(0, 14, 0, 130),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 102,
                        Parent = modalFrame
                    })
                    Cor(hueBar, 7)

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
                        Position = UDim2.new(0, 16, 0, 222),
                        Size = UDim2.new(0, 148, 0, 42),
                        BackgroundColor3 = Color3.fromRGB(14, 25, 45),
                        Text = "Cancel",
                        TextColor3 = Color3.fromRGB(220, 230, 255),
                        Font = Enum.Font.GothamBold,
                        TextSize = 14,
                        ZIndex = 102,
                        Parent = modalFrame
                    })
                    Cor(cancelBtn, 21)
                    Stk(cancelBtn, Color3.fromRGB(30, 100, 210), 1.8)

                    local applyBtn = New("TextButton", {
                        Position = UDim2.new(0, 176, 0, 222),
                        Size = UDim2.new(0, 148, 0, 42),
                        BackgroundColor3 = Color3.fromRGB(24, 100, 230),
                        Text = "Apply",
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        Font = Enum.Font.GothamBold,
                        TextSize = 14,
                        ZIndex = 102,
                        Parent = modalFrame
                    })
                    Cor(applyBtn, 21)
                    Stk(applyBtn, Color3.fromRGB(60, 140, 255), 1.8)

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

                    cancelBtn.MouseButton1Click:Connect(function()
                        modalOverlay.Visible = false
                    end)

                    applyBtn.MouseButton1Click:Connect(function()
                        savedColor = tempColor
                        colorPreview.BackgroundColor3 = savedColor
                        cb(savedColor)
                        modalOverlay.Visible = false
                    end)

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
                end

                return ElementMethods
            end

            return ColumnMethods
        end

        return ColumnContainer
    end

    return TabMethods
end

return Library
