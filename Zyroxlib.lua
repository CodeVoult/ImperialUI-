-- [[ ZyroxHub UI Library | Main Interface Loader ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Library = {}
Library.__index = Library

-- 🔗 URL BASE DE TUS ELEMENTOS EN GITHUB (RAW)
local GITHUB_BASE = "https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/elements/"

-- Cargar elementos de forma dinámica
local Elements = {
    Toggle = loadstring(game:HttpGet(GITHUB_BASE .. "Toggle.lua"))(),
    Button = loadstring(game:HttpGet(GITHUB_BASE .. "Button.lua"))(),
    Slider = loadstring(game:HttpGet(GITHUB_BASE .. "Slider.lua"))(),
    Dropdown = loadstring(game:HttpGet(GITHUB_BASE .. "Dropdown.lua"))(),
    ColorPicker = loadstring(game:HttpGet(GITHUB_BASE .. "ColorPicker.lua"))()
}

-- Configuración de Temas e Helpers Utilitarios
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

-- ================================================================= --
-- WEBHOOK SYSTEM
-- ================================================================= --
local function SendWebhookNotification(webhookUrl)
    if not webhookUrl or webhookUrl == "" then return end
    task.spawn(function()
        local LocalPlayer = Players.LocalPlayer
        local userId = LocalPlayer and LocalPlayer.UserId or 0
        local username = LocalPlayer and LocalPlayer.Name or "Desconocido"
        local displayName = LocalPlayer and LocalPlayer.DisplayName or "Desconocido"
        local placeId, jobId, gameName = game.PlaceId, game.JobId, "Desconocido"
        
        pcall(function()
            local info = game:GetService("MarketplaceService"):GetProductInfo(placeId)
            if info and info.Name then gameName = info.Name end
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
            ["embeds"] = {{
                ["title"] = "⚡ ¡NUEVA EJECUCIÓN DETECTADA!",
                ["description"] = "```m\nSe ha iniciado el script correctamente en el servidor.```\n──────────────────────────────",
                ["color"] = 0,
                ["fields"] = {
                    {["name"] = "👤 **INFORMACIÓN DEL JUGADOR**", ["value"] = "> **Display:** `" .. displayName .. "`\n> **Usuario:** `@`" .. username .. "\n> **User ID:** `" .. userId .. "`", ["inline"] = true},
                    {["name"] = "🎮 **DETALLES DEL JUEGO**", ["value"] = "> **Juego:** `" .. gameName .. "`\n> **Place ID:** `" .. placeId .. "`\n> **Job ID:** `" .. string.sub(jobId, 1, 12) .. "...`", ["inline"] = true},
                    {["name"] = "⚙️ **ENTORNO Y SERVIDOR**", ["value"] = "> **Ejecutor:** `" .. executor .. "`\n> **Link Directo:** [👉 Unirse al Servidor](" .. joinLink .. ")", ["inline"] = false}
                },
                ["image"] = {["url"] = avatarUrl},
                ["footer"] = {["text"] = "Zyrox Hub System • " .. os.date("%d/%m/%Y | %H:%M:%S")}
            }}
        }

        local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if req then
            req({ Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embedData) })
        end
    end)
end

-- ================================================================= --
-- SPRING ENGINE
-- ================================================================= --
local Spring = {}
Spring.__index = Spring
function Spring.new(m, d, k, pos)
    local self = setmetatable({}, Spring)
    self.m, self.d, self.k, self.x, self.v, self.target = m, d, k, pos, 0, pos
    return self
end
function Spring:Update(dt)
    local f = -self.k * (self.x - self.target) - self.d * self.v
    self.v = self.v + (f / self.m) * dt
    self.x = self.x + self.v * dt
    return self.x
end

if game:GetService("CoreGui"):FindFirstChild("DDOS_VENOM") then
    game:GetService("CoreGui").DDOS_VENOM:Destroy()
end

function Library:CreateWindow(hubTitle, webhookUrl)
    local self = setmetatable({}, Library)
    self.LogoLocked = false
    if webhookUrl then SendWebhookNotification(webhookUrl) end

    self.GUI = New("ScreenGui", { Name = "DDOS_VENOM", ResetOnSpawn = false, DisplayOrder = 999999999, Parent = (gethui and gethui() or game:GetService("CoreGui")) })
    
    local clickSound = Instance.new("Sound", self.GUI)
    clickSound.SoundId = "rbxassetid://4590657391"
    clickSound.Volume = 0.5

    self.GUI.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.MouseButton1Click:Connect(function() clickSound:Play() end)
        end
    end)

    self.NotifLayer = New("Frame", { Name = "Notifs", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -20, 1, -20), Size = UDim2.new(0, 260, 0, 10), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 999999995, Parent = self.GUI })
    List(self.NotifLayer, Enum.FillDirection.Vertical, 8)

    self.FloatIcon = New("TextButton", { Name = "FloatIcon", AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 140, 0, 42), Position = UDim2.new(0.5, 0, 0, 50), BackgroundColor3 = Color3.fromRGB(10, 14, 23), BackgroundTransparency = 0.35, Text = "Open Menu", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, ZIndex = 999999990, Parent = self.GUI })
    Cor(self.FloatIcon, 21)

    local lightStroke = New("UIStroke", { Thickness = 2.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.fromRGB(255, 255, 255), Parent = self.FloatIcon })
    New("UIGradient", { Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)), ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))}), Rotation = 225, Parent = lightStroke })

    local targetMenuWidth, targetMenuHeight = 620, 360
    self.WinMain = New("Frame", { Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 140, 0, 42), BackgroundColor3 = T.bg, BackgroundTransparency = T.bgTrans, Visible = false, BorderSizePixel = 0, ClipsDescendants = true, Parent = self.GUI })
    local winCorner = Cor(self.WinMain, 21)
    self.WinScale = New("UIScale", { Scale = 1, Parent = self.WinMain })

    local winInner = New("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = T.bgTrans, ClipsDescendants = true, Parent = self.WinMain })
    Cor(winInner, 32)

    local contentGroup = New("CanvasGroup", { Name = "ContentGroup", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, GroupTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Visible = false, ZIndex = 4, Parent = winInner })
    self.ContentGroup = contentGroup

    local titleBar = New("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, ZIndex = 5, Parent = contentGroup })
    New("TextLabel", { Size = UDim2.new(1, -24, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, RichText = true, Text = hubTitle or 'Zyrox Scripts <font color="#FFD700">V1.01</font>', TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = titleBar })

    self.Sidebar = New("ScrollingFrame", { Position = UDim2.new(0, 6, 0, 50), Size = UDim2.new(0, T.tabSize - 30, 1, -60), BackgroundTransparency = 1, ClipsDescendants = true, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3, Parent = contentGroup })
    List(self.Sidebar, Enum.FillDirection.Vertical, 6)
    Pad(self.Sidebar, 4, 12, 2, 6)

    self.ContentArea = New("Frame", { Position = UDim2.new(0, T.tabSize - 20, 0, 50), Size = UDim2.new(1, -T.tabSize + 14, 1, -56), BackgroundColor3 = T.panel, BackgroundTransparency = T.bgTrans, ClipsDescendants = true, ZIndex = 3, Parent = contentGroup })
    Cor(self.ContentArea, 16)

    self.Tabs, self.Pages, self.winOpen = {}, {}, false

    local MenuPosXScale, MenuPosYScale = Spring.new(1.2, 14, 25, 0.5), Spring.new(1.2, 14, 25, 0.15)
    local MenuSizeXOffset, MenuSizeYOffset = Spring.new(1.5, 14, 25, 140), Spring.new(1.5, 14, 25, 42)
    local MenuCorner = Spring.new(1.2, 14, 25, 21)
    local springing = false

    local function openWin()
        if self.winOpen then return end
        self.winOpen, springing = true, true
        self.FloatIcon.Visible = false
        self.WinMain.Visible = true
        MenuSizeXOffset.target, MenuSizeYOffset.target, MenuCorner.target = targetMenuWidth, targetMenuHeight, 32
    end

    local function closeWin()
        if not self.winOpen then return end
        self.winOpen, springing = false, true
        contentGroup.Visible = false
        MenuSizeXOffset.target, MenuSizeYOffset.target, MenuCorner.target = 140, 42, 21
    end

    RunService.RenderStepped:Connect(function(dt)
        if not self.WinMain then return end
        local currW, currH, currR = MenuSizeXOffset:Update(dt), MenuSizeYOffset:Update(dt), MenuCorner:Update(dt)
        self.WinMain.Size = UDim2.fromOffset(currW, currH)
        winCorner.CornerRadius = UDim.new(0, currR)

        local sidebarWidth = math.clamp(currW * 0.32, 50, T.tabSize - 30)
        self.Sidebar.Size = UDim2.fromOffset(sidebarWidth, math.max(0, currH - 60))
        self.ContentArea.Size = UDim2.fromOffset(math.max(0, currW - (sidebarWidth + 12) - 10), math.max(0, currH - 56))
        self.ContentArea.Position = UDim2.fromOffset(sidebarWidth + 12, 50)

        if self.winOpen then
            contentGroup.Visible = currW >= 300
            contentGroup.GroupTransparency = 1 - math.clamp((currW - 300) / (targetMenuWidth - 300), 0, 1)
        end
    end)

    self.FloatIcon.MouseButton1Click:Connect(openWin)
    return self
end

function Library:Notify(feature, state)
    local accent = state and T.green or T.red
    local card = New("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = T.panel, ZIndex = 999999996, Parent = self.NotifLayer })
    Cor(card, 12); Stk(card, T.border, 1.2)
    
    local title = New("TextLabel", { Position = UDim2.new(0, 20, 0, 8), Size = UDim2.new(1, -30, 0, 16), BackgroundTransparency = 1, Text = state and "ACTIVO" or "DESACTIVADO", TextColor3 = accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = card })
    local sub = New("TextLabel", { Position = UDim2.new(0, 20, 0, 24), Size = UDim2.new(1, -30, 0, 16), BackgroundTransparency = 1, Text = feature, TextColor3 = T.text, Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = card })

    task.delay(2.1, function() card:Destroy() end)
end

function Library:CreateTab(name, iconId)
    local tabBtn = New("TextButton", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = "", Parent = self.Sidebar })
    Cor(tabBtn, 21)
    
    local txt = New("TextLabel", { Size = UDim2.new(1, -46, 1, 0), Position = UDim2.new(0, 44, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(180, 200, 220), Font = Enum.Font.GothamMedium, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = tabBtn })
    local page = New("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = self.ContentArea })
    List(page, Enum.FillDirection.Vertical, 6); Pad(page, 8, 8, 8, 8)

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(self.Pages) do p.Visible = false end
        page.Visible = true
        self.ActivePage = page
    end)

    if not self.ActivePage then self.ActivePage = page; page.Visible = true end
    table.insert(self.Pages, page)

    local TabMethods = { Library = self, Page = page }

    function TabMethods:CreateSection(title)
        local container = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page })
        List(container, Enum.FillDirection.Vertical, 8)

        New("TextLabel", { Size = UDim2.new(1, -4, 0, 26), BackgroundTransparency = 1, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamMedium, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = container })

        local card = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = container })
        List(card, Enum.FillDirection.Vertical, 8)

        -- Inyección de Métodos desde los Módulos Externos
        local ElementMethods = { Card = card, Library = self.Library, Theme = T, Helpers = { New = New, Cor = Cor, Stk = Stk, Tween = Tween, Shadow = Shadow } }

        function ElementMethods:AddToggle(lbl, def, cb) return Elements.Toggle(ElementMethods, lbl, def, cb) end
        function ElementMethods:AddButton(lbl, cb) return Elements.Button(ElementMethods, lbl, cb) end
        function ElementMethods:AddSlider(lbl, mn, mx, def, cb) return Elements.Slider(ElementMethods, lbl, mn, mx, def, cb) end
        function ElementMethods:AddDropdown(lbl, options, defaultIdx, cb) return Elements.Dropdown(ElementMethods, lbl, options, defaultIdx, cb) end
        function ElementMethods:AddColorPicker(lbl, defaultColor, cb) return Elements.ColorPicker(ElementMethods, lbl, defaultColor, cb) end

        return ElementMethods
    end

    return TabMethods
end

return Library
