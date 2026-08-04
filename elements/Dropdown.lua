local TweenService = game:GetService("TweenService")
local T = require(script.Parent.Parent.T)

local Dropdown = {}

function Dropdown.Create(row, lbl, options, defaultIdx, cb)
    local currIdx = defaultIdx
    local dropdownOpen = false

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundTransparency = 1
    header.ZIndex = 6
    header.Parent = row

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = lbl
    label.TextColor3 = Color3.fromRGB(240, 245, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = header

    local selectBtn = Instance.new("TextButton")
    selectBtn.AnchorPoint = Vector2.new(1, 0.5)
    selectBtn.Position = UDim2.new(1, -10, 0.5, 0)
    selectBtn.Size = UDim2.new(0, 110, 0, 26)
    selectBtn.BackgroundColor3 = T.switchOff
    selectBtn.Text = options[defaultIdx] .. " ▼"
    selectBtn.TextColor3 = Color3.fromRGB(240, 245, 255)
    selectBtn.Font = Enum.Font.GothamBold
    selectBtn.TextSize = 11
    selectBtn.ZIndex = 6
    selectBtn.Parent = header
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 13)
    selectCorner.Parent = selectBtn
    
    local selectStroke = Instance.new("UIStroke")
    selectStroke.Color = T.border
    selectStroke.Thickness = 1.5
    selectStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    selectStroke.Parent = selectBtn

    local optionsHolder = Instance.new("ScrollingFrame")
    optionsHolder.Position = UDim2.new(0, 10, 0, 44)
    optionsHolder.Size = UDim2.new(1, -20, 0, 110)
    optionsHolder.BackgroundTransparency = 1
    optionsHolder.CanvasSize = UDim2.new(0, 0, 0, (#options * 32) + 6)
    optionsHolder.ScrollBarThickness = 3
    optionsHolder.ZIndex = 6
    optionsHolder.Parent = row
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.FillDirection = Enum.FillDirection.Vertical
    optionsList.Padding = UDim.new(0, 6)
    optionsList.SortOrder = Enum.SortOrder.LayoutOrder
    optionsList.Parent = optionsHolder
    
    local optionsPad = Instance.new("UIPadding")
    optionsPad.PaddingTop = UDim.new(0, 2)
    optionsPad.PaddingBottom = UDim.new(0, 2)
    optionsPad.PaddingLeft = UDim.new(0, 2)
    optionsPad.PaddingRight = UDim.new(0, 2)
    optionsPad.Parent = optionsHolder

    for i, opt in ipairs(options) do
        local isSelected = (i == currIdx)
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(0.96, 0, 0, 26)
        optBtn.AnchorPoint = Vector2.new(0.5, 0)
        optBtn.Position = UDim2.new(0.5, 0, 0, 0)
        optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(25, 35, 60) or Color3.fromRGB(15, 20, 30)
        optBtn.Text = opt
        optBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 230)
        optBtn.Font = Enum.Font.GothamBold
        optBtn.TextSize = 11
        optBtn.ZIndex = 7
        optBtn.Parent = optionsHolder
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 13)
        optCorner.Parent = optBtn
        
        local optStroke = Instance.new("UIStroke")
        optStroke.Color = T.border
        optStroke.Thickness = 1.2
        optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        optStroke.Parent = optBtn

        optBtn.MouseButton1Click:Connect(function()
            currIdx = i
            cb(opt)
            dropdownOpen = false
            selectBtn.Text = options[currIdx] .. " ▼"
            local tween = TweenService:Create(row, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 40)
            })
            tween:Play()
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        local contentHeight = (#options * 32) + 12
        local holderHeight = math.min(contentHeight, 110)
        optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight)
        selectBtn.Text = options[currIdx] .. (dropdownOpen and " ▲" or " ▼")
        local tween = TweenService:Create(row, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, dropdownOpen and (48 + holderHeight + 8) or 40)
        })
        tween:Play()
    end)
end

return Dropdown
