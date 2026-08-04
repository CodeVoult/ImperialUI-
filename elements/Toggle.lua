return function(self, lbl, def, cb)
    local H, T, card = self.Helpers, self.Theme, self.Card

    local row = H.New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.panel2, ZIndex = 5, Parent = card })
    H.Cor(row, 20); H.Stk(row, T.border, 1.5)

    H.New("TextLabel", { Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -80, 1, 0), BackgroundTransparency = 1, Text = lbl, TextColor3 = Color3.fromRGB(240, 245, 255), Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })

    local switchBg = H.New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 50, 0, 26), BackgroundColor3 = T.switchOff, Parent = row })
    H.Cor(switchBg, 13); H.Stk(switchBg, T.border, 1.5)

    local knob = H.New("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 20, 0, 20), Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = switchBg })
    H.Cor(knob, 8)

    local click = H.New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = row })

    click.MouseButton1Click:Connect(function()
        def = not def
        cb(def)
        self.Library:Notify(lbl, def)
        H.Tween(knob, 0.3, { Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
    end)
end

