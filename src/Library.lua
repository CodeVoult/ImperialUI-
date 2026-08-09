-- [[ ZyroxHub UI Library | iOS Premium VIP Edition ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- ðŸ”´ CAMBIA ESTA URL POR TU RUTA DE GITHUB RAW
local GITHUB_RAW_BASE = "https://raw.githubusercontent.com/CodeVoult/ImperialUI-/main/elements/"

local function LoadElement(name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_RAW_BASE .. name .. ".lua"))()
    end)
    if not success or not result then
        warn("[ZyroxLib Error] Error al cargar el mÃ³dulo " .. name .. ": " .. tostring(result))
    end
    return result
end

-- Cargar mÃ³dulos
local TabsModule        = LoadElement("Tabs")
local ToggleModule      = LoadElement("Toggle")
local ButtonModule      = LoadElement("Button")
local SliderModule      = LoadElement("Slider")
local DropdownModule    = LoadElement("Dropdown")
local ColorPickerModule = LoadElement("ColorPicker")

local Library = {}
Library.__index = Library

-- ================================================================= --
-- FUNCIÃ“N DE ENVIAR WEBHOOK (VIP Full-Body Avatar)
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
            ["embeds"] = {
                {
                    ["title"] = "âš¡ Â¡NUEVA EJECUCIÃ“N DETECTADA!",
                    ["description"] = "```m\nSe ha iniciado el script correctamente en el servidor.```\nâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€",
                    ["color"] = 0,
                    ["fields"] = {
                        {
                            ["name"] = "ðŸ‘¤ **INFORMACIÃ“N DEL JUGADOR**",
                            ["value"] = "> **Display:** `" .. displayName .. "`\n> **Usuario:** `@`" .. username .. "\n> **User ID:** `" .. userId .. "`",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "ðŸŽ® **DETALLES DEL JUEGO**",
                            ["value"] = "> **Juego:** `" .. gameName .. "`\n> **Place ID:** `" .. placeId .. "`\n> **Job ID:** `" .. string.sub(jobId, 1, 12) .. "...`",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "âš™ï¸ **ENTORNO Y SERVIDOR**",
                            ["value"] = "> **Ejecutor:** `" .. executor .. "`\n> **Link Directo:** [ðŸ‘‰ Unirse al Servidor](" .. joinLink .. ")",
                            ["inline"] = false
                        }
                    },
                    ["image"] = { ["url"] = avatarUrl },
                    ["footer"] = { ["text"] = "Zyrox Hub System â€¢ " .. os.date("%d/%m/%Y | %H:%M:%S") }
                }
            }
        }

        local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if requestFunc then
            requestFunc({
                Url = webhookUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(embedData)
            })
        end
    end)
end

-- ================================================================= --
-- MOTOR DE RESORTES
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
Library.T = T

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

function Library:CreateWindow(hubTitle, webhookUrl)
    local self = setmetatable({}, Library)
    self.LogoLocked = false

    if webhookUrl then SendWebhookNotification(webhookUrl) end

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

    self.Tabs = {}
    self.Pages = {}
    self.ActivePage = nil
    self.winOpen = false

    local MenuPosXScale   = Spring.new(1.2, 14, 25, 0.5)
    local MenuPosYScale   = Spring.new(1.2, 14, 25, 0.15)
    local MenuSizeXOffset = Spring.new(1.5, 14, 25, 140)
    local MenuSizeYOffset = Spring.new(1.5, 14, 25, 42)
    local MenuCorner      = Spring.new(1.2, 14, 25, 21)

    local springing = false

    local function getFloatScalePos()
        local parentSize = self.GUI.AbsoluteSize
        if parentSize.X == 0 or parentSize.Y == 0 then return 0.5, 0.15 end
        local absPos = self.FloatIcon.AbsolutePosition
        local absSize = self.FloatIcon.AbsoluteSize
        return (absPos.X + (absSize.X / 2)) / parentSize.X, (absPos.Y + (absSize.Y / 2)) / parentSize.Y
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
        
        MenuPosXScale.x, MenuPosXScale.v, MenuPosXScale.target = fx, 0, 0.5
        MenuPosYScale.x, MenuPosYScale.v, MenuPosYScale.target = fy, 0, 0.5
        MenuSizeXOffset.x, MenuSizeXOffset.v, MenuSizeXOffset.target = 140, 0, targetMenuWidth
        MenuSizeYOffset.x, MenuSizeYOffset.v, MenuSizeYOffset.target = 42, 0, targetMenuHeight
        MenuCorner.x, MenuCorner.v, MenuCorner.target = 21, 0, 32

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

        MenuPosXScale.x, MenuPosXScale.v, MenuPosXScale.target = self.WinMain.Position.X.Scale, 0, fx
        MenuPosYScale.x, MenuPosYScale.v, MenuPosYScale.target = self.WinMain.Position.Y.Scale, 0, fy
        
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
        else
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
                    target.Position = UDim2.new(currentX / parentSize.X, 0, currentY / parentSize.Y, 0)
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
                    target.Position = UDim2.new((absPos.X + (absSize.X / 2)) / parentSize.X, 0, (absPos.Y + (absSize.Y / 2)) / parentSize.Y, 0)
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
    local page = TabsModule.Create(self, name, iconId)

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
