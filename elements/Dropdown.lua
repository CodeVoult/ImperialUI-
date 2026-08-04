local DropdownModule = {}

function DropdownModule.Add(Library, card, lbl, options, defaultIdx, cb)
    local T = Library.T
    local currIdx = defaultIdx or 1
    local dropdownOpen = false

    local row = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.panel2,
        ClipsDescendants = true,
        ZIndex = 5,
        Parent = card
    })
    Library.Cor(row, 20)
    Library.Stk(row, T.border, 1.5)

    local header = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = row
    })

    Library.New("TextLabel", {
        Position = UDim2.new(0, 14, 0, 0),
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

    local selectBtn = Library.New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 110, 0, 26),
        BackgroundColor3 = T.switchOff,
        Text = (options[currIdx] or "") .. " ▼",
        TextColor3 = Color3.fromRGB(240, 245, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 6,
        Parent = header
    })
    Library.Cor(selectBtn, 13)
    Library.Stk(selectBtn, T.border, 1.5)

    local optionsHolder = Library.New("ScrollingFrame", {
        Position = UDim2.new(0, 10, 0, 44),
        Size = UDim2.new(1, -20, 0, 110),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, (#options * 32) + 6),
        ScrollBarThickness = 3,
        ZIndex = 6,
        Parent = row
    })
    Library.List(optionsHolder, Enum.FillDirection.Vertical, 6)
    Library.Pad(optionsHolder, 2, 2, 2, 2)

    for i, opt in ipairs(options) do
        local isSelected = (i == currIdx)
        local optBtn = Library.New("TextButton", {
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
        Library.Cor(optBtn, 13)
        Library.Stk(optBtn, T.border, 1.2)

        optBtn.MouseButton1Click:Connect(function()
            currIdx = i
            if cb then cb(opt) end
            dropdownOpen = false
            selectBtn.Text = options[currIdx] .. " ▼"
            Library.Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, 40) })
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        local contentHeight = (#options * 32) + 12
        local holderHeight = math.min(contentHeight, 110)
        optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight)
        selectBtn.Text = options[currIdx] .. (dropdownOpen and " ▲" or " ▼")
        Library.Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, dropdownOpen and (48 + holderHeight + 8) or 40) })
    end)
end

return DropdownModule
