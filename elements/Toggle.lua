local ToggleModule = {}

function ToggleModule.Add(Library, card, lbl, def, cb)
    local T = Library.T
    local row = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.panel2,
        ZIndex = 5,
        Parent = card
    })
    Library.Cor(row, 20)
    Library.Stk(row, T.border, 1.5)

    Library.New("TextLabel", {
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = Color3.fromRGB(240, 245, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = row
    })

    local switchBg = Library.New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 26),
        BackgroundColor3 = T.switchOff,
        ZIndex = 6,
        Parent = row
    })
    Library.Cor(switchBg, 13)
    Library.Stk(switchBg, T.border, 1.5)

    local knob = Library.New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 20, 0, 20),
        Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 7,
        Parent = switchBg
    })
    Library.Cor(knob, 8)

    local click = Library.New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 9,
        Parent = row
    })

    click.MouseButton1Click:Connect(function()
        def = not def
        if cb then cb(def) end
        Library:Notify(lbl, def)
        Library.Tween(knob, 0.3, { Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
    end)
end

return ToggleModule
