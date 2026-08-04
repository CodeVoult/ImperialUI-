return function(self, lbl, options, defaultIdx, cb)
    local H, T, card = self.Helpers, self.Theme, self.Card
    local currIdx = defaultIdx
    local dropdownOpen = false

    local row = H.New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.panel2, ClipsDescendants = true, Parent = card })
    H.Cor(row, 20); H.Stk(row, T.border, 1.5)

    local header = H.New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = row })
    H.New("TextLabel", { Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = lbl, TextColor3 = Color3.fromRGB(240, 245, 255), Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })

    local selectBtn = H.New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 110, 0, 26), BackgroundColor3 = T.switchOff, Text = options[defaultIdx] .. " ▼", TextColor3 = Color3.fromRGB(240, 245, 255), Font = Enum.Font.GothamBold, TextSize = 11, Parent = header })
    H.Cor(selectBtn, 13); H.Stk(selectBtn, T.border, 1.5)

    local optionsHolder = H.New("ScrollingFrame", { Position = UDim2.new(0, 10, 0, 44), Size = UDim2.new(1, -20, 0, 110), BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 0, (#options * 32) + 6), ScrollBarThickness = 3, Parent = row })
    H.New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = optionsHolder })

    for i, opt in ipairs(options) do
        local optBtn = H.New("TextButton", { Size = UDim2.new(0.96, 0, 0, 26), BackgroundColor3 = (i == currIdx) and Color3.fromRGB(25, 35, 60) or Color3.fromRGB(15, 20, 30), Text = opt, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 11, Parent = optionsHolder })
        H.Cor(optBtn, 13); H.Stk(optBtn, T.border, 1.2)

        optBtn.MouseButton1Click:Connect(function()
            currIdx = i
            cb(opt)
            dropdownOpen = false
            selectBtn.Text = options[currIdx] .. " ▼"
            H.Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, 40) })
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        local holderHeight = math.min((#options * 32) + 12, 110)
        optionsHolder.Size = UDim2.new(1, -20, 0, holderHeight)
        selectBtn.Text = options[currIdx] .. (dropdownOpen and " ▲" or " ▼")
        H.Tween(row, 0.3, { Size = UDim2.new(1, 0, 0, dropdownOpen and (48 + holderHeight + 8) or 40) })
    end)
end
