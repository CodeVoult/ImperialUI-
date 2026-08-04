local TabsModule = {}

function TabsModule.Create(Library, name, iconId)
    local tabBtn = Library.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
        Parent = Library.Sidebar
    })
    Library.Cor(tabBtn, 21)
    
    local tabStroke = Library.New("UIStroke", {
        Thickness = 1.6,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = tabBtn
    })

    local tabGradient = Library.New("UIGradient", {
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

    local icon = Library.New("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 12, 0.5, -12),
        BackgroundTransparency = 1,
        Image = iconId or "",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 5,
        Parent = tabBtn
    })

    local txt = Library.New("TextLabel", {
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

    local page = Library.New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Library.ContentArea
    })
    Library.Cor(page, 8)
    local pageList = Library.List(page, Enum.FillDirection.Vertical, 6)
    Library.Pad(page, 8, 8, 8, 8)

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if page and page.Parent then
            page.CanvasSize = UDim2.fromOffset(0, pageList.AbsoluteContentSize.Y + 10)
        end
    end)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Library.Tabs) do
            Library.Tween(t.btn, 0.2, { BackgroundTransparency = 1 })
            t.txt.TextColor3 = Color3.fromRGB(180, 200, 220)
            t.stroke.Transparency = 0
        end
        for _, p in pairs(Library.Pages) do
            p.Visible = false
        end
        Library.Tween(tabBtn, 0.2, { BackgroundTransparency = 0.85 })
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Transparency = 0
        
        page.Visible = true
        page.Position = UDim2.new(0, 0, -0.1, 0)
        page.Size = UDim2.new(1, 0, 1.2, 0)
        
        Library.Tween(page, 0.6, {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0)
        }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        Library.ActivePage = page
        
        task.wait(0.1)
        if page and page.Parent then
            local layout = page:FindFirstChildOfClass("UIListLayout")
            if layout then
                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
            end
            page.CanvasPosition = Vector2.zero
        end
    end)

    if not Library.ActivePage then
        Library.ActivePage = page
        page.Visible = true
        tabBtn.BackgroundTransparency = 0.85
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(Library.Tabs, { btn = tabBtn, stroke = tabStroke, txt = txt, icon = icon })
    table.insert(Library.Pages, page)

    return page
end

return TabsModule
