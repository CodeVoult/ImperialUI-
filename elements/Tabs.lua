local TweenService = game:GetService("TweenService")
local T = require(script.Parent.Parent.T) -- Esto debería ser definido en el script principal

local Tabs = {}

function Tabs.Create(library, name, iconId)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 42)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 4
    tabBtn.Parent = library.Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 21)
    corner.Parent = tabBtn
    
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Thickness = 1.6
    tabStroke.Color = Color3.fromRGB(255, 255, 255)
    tabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tabStroke.Parent = tabBtn
    tabStroke.Transparency = 0

    local tabGradient = Instance.new("UIGradient")
    tabGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
    })
    tabGradient.Rotation = 225
    tabGradient.Parent = tabStroke
    
    -- Animación del gradiente
    task.spawn(function()
        while tabGradient and tabGradient.Parent do
            tabGradient.Rotation = (tabGradient.Rotation + 1.2) % 360
            task.wait(0.03)
        end
    end)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 12, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or ""
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.ZIndex = 5
    icon.Parent = tabBtn

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -46, 1, 0)
    txt.Position = UDim2.new(0, 44, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(180, 200, 220)
    txt.Font = Enum.Font.GothamMedium
    txt.TextSize = 16
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.ZIndex = 5
    txt.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.fromScale(1, 1)
    page.ClipsDescendants = true
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = library.ContentArea
    
    local pageCorner = Instance.new("UICorner")
    pageCorner.CornerRadius = UDim.new(0, 8)
    pageCorner.Parent = page
    
    local pageList = Instance.new("UIListLayout")
    pageList.FillDirection = Enum.FillDirection.Vertical
    pageList.Padding = UDim.new(0, 6)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Parent = page
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = page

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if page and page.Parent then
            page.CanvasSize = UDim2.fromOffset(0, pageList.AbsoluteContentSize.Y + 10)
        end
    end)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(library.Tabs) do
            local tween = TweenService:Create(t.btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
            tween:Play()
            t.txt.TextColor3 = Color3.fromRGB(180, 200, 220)
            t.stroke.Transparency = 0
        end
        for _, p in pairs(library.Pages) do
            p.Visible = false
        end
        
        local tween = TweenService:Create(tabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 0.85 })
        tween:Play()
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabStroke.Transparency = 0
        
        page.Visible = true
        
        page.Position = UDim2.new(0, 0, -0.1, 0)
        page.Size = UDim2.new(1, 0, 1.2, 0)
        
        local tween = TweenService:Create(page, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0)
        })
        tween:Play()
        
        library.ActivePage = page
        
        task.wait(0.1)
        if page and page.Parent then
            local layout = page:FindFirstChildOfClass("UIListLayout")
            if layout then
                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
            end
            page.CanvasPosition = Vector2.zero
        end
    end)

    if not library.ActivePage then
        library.ActivePage = page
        page.Visible = true
        tabBtn.BackgroundTransparency = 0.85
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    table.insert(library.Tabs, { btn = tabBtn, stroke = tabStroke, txt = txt, icon = icon })
    table.insert(library.Pages, page)

    return { Library = library, Page = page }
end

function Tabs.CreateSection(library, page, title)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.ZIndex = 5
    container.Parent = page
    
    local containerList = Instance.new("UIListLayout")
    containerList.FillDirection = Enum.FillDirection.Vertical
    containerList.Padding = UDim.new(0, 8)
    containerList.SortOrder = Enum.SortOrder.LayoutOrder
    containerList.Parent = container

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -4, 0, 26)
    titleLabel.Position = UDim2.new(0, 4, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 6
    titleLabel.Parent = container

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundTransparency = 1
    card.ZIndex = 5
    card.Parent = container
    
    local cardList = Instance.new("UIListLayout")
    cardList.FillDirection = Enum.FillDirection.Vertical
    cardList.Padding = UDim.new(0, 8)
    cardList.SortOrder = Enum.SortOrder.LayoutOrder
    cardList.Parent = card

    return { Card = card, Library = library }
end

return Tabs
