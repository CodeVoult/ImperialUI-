-- ================================================================= --
-- ANIMACIONES CON RESORTES PARA LA VENTANA
-- ================================================================= --
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local SpringAnimations = {}

function SpringAnimations.Setup(window, config, Spring)
    -- Verificar que Spring no sea nil
    if not Spring then
        error("SpringAnimations.Setup: Spring module is nil")
    end

    local targetWidth = config.targetWidth or 620
    local targetHeight = config.targetHeight or 360

    local GUI = window.GUI
    local WinMain = window.WinMain
    local FloatIcon = window.FloatIcon
    local ContentGroup = window.ContentGroup
    local WinScale = window.WinScale
    local WinCorner = window.WinCorner
    local closeTextLabel = window.closeTextLabel
    local borderStroke = window.borderStroke
    local Pages = window.Pages or {}

    -- Crear resortes usando el módulo Spring recibido
    local MenuPosXScale   = Spring.new(1, 20, 100, 0.5)
    local MenuPosYScale   = Spring.new(1, 20, 100, 0.15)
    local MenuSizeXOffset = Spring.new(1, 20, 100, 140)
    local MenuSizeYOffset = Spring.new(1, 20, 100, 42)
    local MenuCorner      = Spring.new(1, 20, 100, 21)

    local springing = false
    local winOpen = false

    -- Funciones auxiliares
    local function getFloatScalePos()
        local parentSize = GUI.AbsoluteSize
        if parentSize.X == 0 or parentSize.Y == 0 then return 0.5, 0.15 end
        local absPos = FloatIcon.AbsolutePosition
        local absSize = FloatIcon.AbsoluteSize
        return (absPos.X + (absSize.X / 2)) / parentSize.X, (absPos.Y + (absSize.Y / 2)) / parentSize.Y
    end

    local function openWin()
        if winOpen then return end
        winOpen = true
        springing = true

        closeTextLabel.Visible = false
        closeTextLabel.TextTransparency = 1

        local fx, fy = getFloatScalePos()

        FloatIcon.Visible = false
        WinMain.Visible = true
        
        MenuPosXScale.x, MenuPosXScale.v, MenuPosXScale.target = fx, 0, 0.5
        MenuPosYScale.x, MenuPosYScale.v, MenuPosYScale.target = fy, 0, 0.5
        MenuSizeXOffset.x, MenuSizeXOffset.v, MenuSizeXOffset.target = 140, 0, targetWidth
        MenuSizeYOffset.x, MenuSizeYOffset.v, MenuSizeYOffset.target = 42, 0, targetHeight
        MenuCorner.x, MenuCorner.v, MenuCorner.target = 21, 0, 32

        WinMain.Position = UDim2.new(fx, 0, fy, 0)
        WinMain.BackgroundTransparency = window.T.bgTrans

        ContentGroup.Visible = false
        ContentGroup.GroupTransparency = 1
        if borderStroke then borderStroke.Transparency = 0.2 end

        task.delay(0.35, function()
            for _, page in ipairs(Pages) do
                if page then
                    pcall(function() page.CanvasPosition = Vector2.zero end)
                end
            end
        end)
    end

    local function closeWin()
        if not winOpen then return end
        winOpen = false
        springing = true

        ContentGroup.Visible = false
        ContentGroup.GroupTransparency = 1

        local fx, fy = getFloatScalePos()
        
        closeTextLabel.Position = WinMain.Position
        closeTextLabel.Visible = true
        closeTextLabel.TextTransparency = 0

        MenuPosXScale.x, MenuPosXScale.v, MenuPosXScale.target = WinMain.Position.X.Scale, 0, fx
        MenuPosYScale.x, MenuPosYScale.v, MenuPosYScale.target = WinMain.Position.Y.Scale, 0, fy
        
        MenuSizeXOffset.target = 140
        MenuSizeYOffset.target = 42
        MenuCorner.target = 21
    end

    -- Bucle de animación
    local renderConnection = RunService.RenderStepped:Connect(function(dt)
        if not WinMain then return end

        local currW = MenuSizeXOffset:Update(dt)
        local currH = MenuSizeYOffset:Update(dt)
        local currR = MenuCorner:Update(dt)

        WinMain.Size = UDim2.fromOffset(currW, currH)
        if WinCorner then WinCorner.CornerRadius = UDim.new(0, currR) end

        -- Actualizar sidebar y content area (si existen)
        if window.Sidebar and window.ContentArea then
            local sidebarWidth = math.clamp(currW * 0.32, 50, window.T.tabSize - 30)
            local availH = math.max(0, currH - 60)
            window.Sidebar.Size = UDim2.fromOffset(sidebarWidth, availH)
            window.Sidebar.Position = UDim2.fromOffset(6, 50)

            local contentX = sidebarWidth + 12
            local contentW = math.max(0, currW - contentX - 10)
            local contentH = math.max(0, currH - 56)
            window.ContentArea.Size = UDim2.fromOffset(contentW, contentH)
            window.ContentArea.Position = UDim2.fromOffset(contentX, 50)
        end

        -- Mostrar contenido solo cuando la ventana es lo suficientemente grande
        if winOpen then
            if currW < 300 then
                ContentGroup.Visible = false
                ContentGroup.GroupTransparency = 1
            else
                ContentGroup.Visible = true
                local p = math.clamp((currW - 300) / math.max(targetWidth - 300, 1), 0, 1)
                ContentGroup.GroupTransparency = 1 - p
                
                if currW > targetWidth - 10 and not springing then
                    ContentGroup.GroupTransparency = 0
                    for _, page in ipairs(Pages) do
                        if page and page.Parent == window.ContentArea then
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
            ContentGroup.Visible = false
        end

        if springing then
            local currX = MenuPosXScale:Update(dt)
            local currY = MenuPosYScale:Update(dt)
            WinMain.Position = UDim2.new(currX, 0, currY, 0)
            
            if not winOpen then closeTextLabel.Position = WinMain.Position end

            if winOpen then
                if math.abs(currW - targetWidth) < 1.5 and math.abs(currH - targetHeight) < 1.5 and math.abs(MenuSizeXOffset.v) < 2 then
                    springing = false
                end
            else
                if math.abs(currW - 140) < 2 and math.abs(currH - 42) < 2 then
                    springing = false
                    WinMain.Visible = false
                    FloatIcon.Visible = true
                    
                    local Tween = window.Tween or TweenService.Create
                    Tween(closeTextLabel, 0.15, { TextTransparency = 1 })
                    task.delay(0.15, function() closeTextLabel.Visible = false end)
                end
            end
        end
    end)
    window:Track(renderConnection)

    -- Evento de clic en el ícono flotante
    window:Track(FloatIcon.MouseButton1Click:Connect(function()
        if not winOpen then openWin() end
    end))

    -- Función de arrastre suave (para la barra de título)
    local function makeSmoothDrag(handle, target, scaleObj)
        local dragging = false
        local dragStart, startPos
        local targetX, targetY, currentX, currentY = 0, 0, 0, 0
        local lerpConnection = nil
        local suavizado = 0.15

        window:Track(handle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if springing then return end
            dragging = true
            window.dragging = true
            dragStart = input.Position
            startPos = target.Position
            currentX = target.AbsolutePosition.X + (target.AbsoluteSize.X * target.AnchorPoint.X)
            currentY = target.AbsolutePosition.Y + (target.AbsoluteSize.Y * target.AnchorPoint.Y)
            targetX, targetY = currentX, currentY

            if scaleObj then TweenService:Create(scaleObj, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Scale = 1.01 }):Play() end

            if not lerpConnection then
                lerpConnection = RunService.RenderStepped:Connect(function(dt)
                    if dragging or math.abs(currentX - targetX) > 0.1 or math.abs(currentY - targetY) > 0.1 then
                        local alpha = 1 - math.exp(-dt / suavizado)
                        currentX = currentX + (targetX - currentX) * alpha
                        currentY = currentY + (targetY - currentY) * alpha
                        target.Position = UDim2.new(0, math.round(currentX), 0, math.round(currentY))
                    else
                        lerpConnection:Disconnect()
                        lerpConnection = nil
                    end
                end)
                window:Track(lerpConnection)
            end
        end))

        window:Track(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local originX = (target.Parent.AbsoluteSize.X * startPos.X.Scale) + startPos.X.Offset
                local originY = (target.Parent.AbsoluteSize.Y * startPos.Y.Scale) + startPos.Y.Offset
                local halfX, halfY = target.AbsoluteSize.X / 2, target.AbsoluteSize.Y / 2
                targetX = math.clamp(originX + delta.X, halfX + 8, GUI.AbsoluteSize.X - halfX - 8)
                targetY = math.clamp(originY + delta.Y, halfY + 8, GUI.AbsoluteSize.Y - halfY - 8)
            end
        end))

        window:Track(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if dragging then
                dragging = false
                window.dragging = false
                if scaleObj then TweenService:Create(scaleObj, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Scale = 1 }):Play() end

                local parentSize = GUI.AbsoluteSize
                if parentSize.X > 0 and parentSize.Y > 0 then
                    target.Position = UDim2.new(currentX / parentSize.X, 0, currentY / parentSize.Y, 0)
                end

            end
        end))
    end

    -- Conectar arrastre en la barra de título (si existe)
    if window.titleBar then
        makeSmoothDrag(window.titleBar, WinMain, WinScale)
    end

    -- Devolver métodos públicos
    return {
        Open = openWin,
        Close = closeWin,
        Toggle = function()
            if winOpen then closeWin() else openWin() end
        end,
        IsOpen = function() return winOpen end,
        Springing = function() return springing end,
        RenderConnection = renderConnection,
    }
end

return SpringAnimations
