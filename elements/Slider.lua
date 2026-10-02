local SliderModule = {}

function SliderModule.Add(Library, card, lbl, mn, mx, def, cb)
    local T = Library.T
    local UserInputService = game:GetService("UserInputService")
    if mx < mn then mn, mx = mx, mn end
    if mx == mn then mx = mn + 1 end
    def = math.clamp(tonumber(def) or mn, mn, mx)

    local row = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = T.panel2,
        ZIndex = 5,
        Parent = card
    })
    Library.Cor(row, 21)
    local rowStroke = Library.Stk(row, T.border, 1)

    local valInput = Library.New("TextBox", {
        Position = UDim2.new(0, 12, 0.5, -10),
        Size = UDim2.new(0, 35, 0, 20),
        BackgroundTransparency = 1,
        Text = tostring(def),
        TextColor3 = T.acc,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ZIndex = 8,
        Parent = row
    })

    Library.New("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 130, 0, 20),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = T.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 6,
        Parent = row
    })

    local track = Library.New("Frame", {
        Position = UDim2.new(0, 52, 0.5, -2),
        Size = UDim2.new(1, -200, 0, 6),
        ZIndex = 6,
        Parent = row
    })
    Library.Cor(track, 3)

    local trackStroke = Library.Stk(track, T.border, 1)

    local fill = Library.New("Frame", {
        BackgroundColor3 = T.acc,
        Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0),
        ZIndex = 7,
        Parent = track
    })
    Library.Cor(fill, 3)

    local thumb = Library.New("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((def - mn) / (mx - mn), 0, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = T.onAccent,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 8,
        Parent = track
    })
    Library.Cor(thumb, 7)
    Library:BindTheme(row, "BackgroundColor3", "panel2")
    Library:BindTheme(rowStroke, "Color", "border")
    Library:BindTheme(valInput, "TextColor3", "acc")
    local labels = row:GetChildren()
    for _, child in ipairs(labels) do
        if child:IsA("TextLabel") then Library:BindTheme(child, "TextColor3", "text") end
    end
    Library:BindTheme(track, "BackgroundColor3", "panel")
    Library:BindTheme(trackStroke, "Color", "border")
    Library:BindTheme(fill, "BackgroundColor3", "acc")
    Library:BindTheme(thumb, "BackgroundColor3", "onAccent")

    local function setVal(newVal)
        newVal = math.clamp(math.floor(newVal + 0.5), mn, mx)
        def = newVal
        valInput.Text = tostring(newVal)
        local tt = (newVal - mn) / (mx - mn)
        Library.Tween(fill, 0.15, { Size = UDim2.new(tt, 0, 1, 0) })
        Library.Tween(thumb, 0.15, { Position = UDim2.new(tt, 0, 0.5, 0) })
        if cb then cb(newVal) end
    end

    local dragging = false
    local function update(posX)
        local t = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        setVal(math.clamp(math.floor(mn + t * (mx - mn) + 0.5), mn, mx))
    end

    Library:Track(thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end))
    Library:Track(track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end))

    Library:Track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end))

    Library:Track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    Library:Track(valInput.FocusLost:Connect(function()
        local num = tonumber(valInput.Text)
        setVal(num or def)
    end))
end

return SliderModule
