local TabsModule = {}

function TabsModule.Create(Library, name, iconId)
    Library.Tabs = Library.Tabs or {}
    Library.Pages = Library.Pages or {}
    local tabRecord = { selected = false, hovered = false }
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
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = tabBtn
    })

    local icon = Library.New("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 12, 0.5, -12),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = tabBtn
    })
    Library:SetIcon(icon, iconId or "home", "home")

    local txt = Library.New("TextLabel", {
        Size = UDim2.new(1, -46, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Library.T.muted,
        Font = Enum.Font.GothamMedium,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = tabBtn
    })
    Library:BindTheme(tabBtn, "BackgroundColor3", function(theme)
        return tabRecord.selected and theme.acc or theme.panel
    end)
    Library:BindTheme(tabBtn, "BackgroundTransparency", function(theme)
        return tabRecord.selected and 0.84 or (tabRecord.hovered and 0.94 or 1)
    end)
    Library:BindTheme(tabStroke, "Color", function(theme)
        return tabRecord.selected and theme.acc or theme.border
    end)
    Library:BindTheme(tabStroke, "Transparency", function(theme)
        return tabRecord.selected and 0.15 or (tabRecord.hovered and 0.4 or 0.65)
    end)
    Library:BindTheme(txt, "TextColor3", function(theme)
        return tabRecord.selected and theme.text or (tabRecord.hovered and theme.text or theme.muted)
    end)
    Library:BindTheme(icon, "ImageColor3", function(theme)
        return tabRecord.selected and theme.acc or (tabRecord.hovered and theme.text or theme.muted)
    end)

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

    Library:Track(pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if page and page.Parent then
            page.CanvasSize = UDim2.fromOffset(0, pageList.AbsoluteContentSize.Y + 10)
        end
    end))

    -- Función para seleccionar esta pestaña
    local function selectTab()
        -- Ocultar todas las pestañas
        for _, t in pairs(Library.Tabs) do
            t.selected = false
            t.hovered = false
            t.btn.BackgroundTransparency = 1
            t.stroke.Color = Library.T.border
            t.stroke.Transparency = 0.65
            t.txt.TextColor3 = Library.T.muted
            t.icon.ImageColor3 = Library.T.muted
        end
        for _, p in pairs(Library.Pages) do
            p.Visible = false
        end
        -- Mostrar esta
        tabRecord.selected = true
        tabBtn.BackgroundTransparency = 0.84
        tabStroke.Color = Library.T.acc
        tabStroke.Transparency = 0.15
        txt.TextColor3 = Library.T.text
        icon.ImageColor3 = Library.T.acc
        -- Theme-bound functions read this mutable per-tab state.
        
        page.Visible = true
        page.Position = UDim2.new(0, 0, -0.1, 0)
        page.Size = UDim2.new(1, 0, 1.2, 0)
        
        Library.Tween(page, 0.22, {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        Library.ActivePage = page
        
        task.wait(0.1)
        if page and page.Parent then
            local layout = page:FindFirstChildOfClass("UIListLayout")
            if layout then
                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
            end
            page.CanvasPosition = Vector2.zero
        end
    end

    Library:Track(tabBtn.MouseButton1Click:Connect(selectTab))
    Library:Track(tabBtn.MouseEnter:Connect(function()
        tabRecord.hovered = true
        if not tabRecord.selected then
            Library.Tween(tabBtn, 0.14, { BackgroundTransparency = 0.94 })
            txt.TextColor3 = Library.T.text
            icon.ImageColor3 = Library.T.text
            tabStroke.Transparency = 0.4
        end
    end))
    Library:Track(tabBtn.MouseLeave:Connect(function()
        tabRecord.hovered = false
        if not tabRecord.selected then
            Library.Tween(tabBtn, 0.14, { BackgroundTransparency = 1 })
            txt.TextColor3 = Library.T.muted
            icon.ImageColor3 = Library.T.muted
            tabStroke.Transparency = 0.65
        end
    end))

    tabRecord.btn = tabBtn
    tabRecord.stroke = tabStroke
    tabRecord.txt = txt
    tabRecord.icon = icon
    tabRecord.page = page
    tabRecord.select = selectTab
    table.insert(Library.Tabs, tabRecord)
    table.insert(Library.Pages, page)

    -- Si es la primera pestaña, seleccionarla automáticamente
    if not Library.ActivePage then
        selectTab()
    end

    -- Refresh the sidebar canvas after adding the tab.
    if Library.Sidebar then
        local sidebarLayout = Library.Sidebar:FindFirstChildOfClass("UIListLayout")
        if sidebarLayout then
            Library.Sidebar.CanvasSize = UDim2.fromOffset(0, sidebarLayout.AbsoluteContentSize.Y + 10)
        end
    end

    return page
end

return TabsModule
