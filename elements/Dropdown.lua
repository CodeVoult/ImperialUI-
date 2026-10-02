local DropdownModule = {}

function DropdownModule.Add(Library, card, lbl, options, defaultIdx, cb)
    local T = Library.T
    options = options or {}
    local currIdx = math.clamp(tonumber(defaultIdx) or 1, 1, math.max(1, #options))
    local dropdownOpen = false

    local row = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.panel2,
        ClipsDescendants = true,
        ZIndex = 5,
        Parent = card
    })
    Library.Cor(row, 20)
    local rowStroke = Library.Stk(row, T.border, 1)

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
        TextColor3 = T.text,
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
        Text = (options[currIdx] or "Choose…") .. "  ▾",
        TextColor3 = T.text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 6,
        Parent = header
    })
    Library.Cor(selectBtn, 13)
    local selectStroke = Library.Stk(selectBtn, T.border, 1)

    local optionsHolder = Library.New("ScrollingFrame", {
        Position = UDim2.new(0, 10, 0, 44),
        Size = UDim2.new(1, -20, 0, 110),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, (#options * 32) + 6),
        ScrollBarThickness = 3,
        ZIndex = 8,
        Parent = row
    })
    local optionLayout = Library.List(optionsHolder, Enum.FillDirection.Vertical, 4)
    Library.Pad(optionsHolder, 2, 2, 2, 2)
    Library:BindTheme(row, "BackgroundColor3", "panel2")
    Library:BindTheme(rowStroke, "Color", "border")
    local title = header:FindFirstChildOfClass("TextLabel")
    Library:BindTheme(title, "TextColor3", "text")
    Library:BindTheme(selectBtn, "BackgroundColor3", "switchOff")
    Library:BindTheme(selectBtn, "TextColor3", "text")
    Library:BindTheme(selectStroke, "Color", "border")
    Library:BindTheme(optionsHolder, "ScrollBarImageColor3", "acc")
    local optionButtons = {}
    local function refreshOptions()
        for index, button in ipairs(optionButtons) do
            local selected = index == currIdx
            button.BackgroundColor3 = selected and Library.T.acc or Library.T.panel
            button.TextColor3 = selected and Library.T.onAccent or Library.T.text
        end
    end
    local function closeDropdown()
        dropdownOpen = false
        selectBtn.Text = (options[currIdx] or "Choose…") .. "  ▾"
        Library.Tween(row, 0.2, { Size = UDim2.new(1, 0, 0, 40) })
    end

    for i, opt in ipairs(options) do
        local optBtn = Library.New("TextButton", {
            Size = UDim2.new(1, -4, 0, 28),
            BackgroundColor3 = T.panel,
            Text = opt,
            TextColor3 = T.text,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            ZIndex = 9,
            Parent = optionsHolder
        })
        Library.Cor(optBtn, 13)
        local optStroke = Library.Stk(optBtn, T.border, 1)
        Library:BindTheme(optStroke, "Color", "border")
        table.insert(optionButtons, optBtn)
        local optionIndex = i
        Library:BindTheme(optBtn, "BackgroundColor3", function(theme)
            return optionIndex == currIdx and theme.acc or theme.panel
        end)
        Library:BindTheme(optBtn, "TextColor3", function(theme)
            return optionIndex == currIdx and theme.onAccent or theme.text
        end)

        Library:Track(optBtn.MouseButton1Click:Connect(function()
            currIdx = i
            if cb then cb(opt) end
            refreshOptions()
            closeDropdown()
        end))
    end
    Library:Track(optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsHolder.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y + 4)
    end))
    refreshOptions()

    Library:Track(selectBtn.MouseButton1Click:Connect(function()
        if #options == 0 then return end
        dropdownOpen = not dropdownOpen
        local contentHeight = optionLayout.AbsoluteContentSize.Y + 8
        local holderHeight = math.min(contentHeight, 132)
        optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight)
        selectBtn.Text = (options[currIdx] or "Choose…") .. (dropdownOpen and "  ▴" or "  ▾")
        Library.Tween(row, 0.2, { Size = UDim2.new(1, 0, 0, dropdownOpen and (52 + holderHeight) or 40) })
    end))
end

return DropdownModule
