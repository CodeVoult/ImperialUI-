return function(self, lbl, cb)
    local H, T, card = self.Helpers, self.Theme, self.Card

    local row = H.New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.panel2, ZIndex = 5, Parent = card })
    H.Cor(row, 20); H.Stk(row, T.border, 1.5)

    local btn = H.New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = lbl, TextColor3 = Color3.fromRGB(240, 245, 255), Font = Enum.Font.GothamBold, TextSize = 13, Parent = row })

    btn.MouseButton1Click:Connect(function()
        H.Tween(row, 0.1, { BackgroundColor3 = T.border })
        task.delay(0.1, function()
            H.Tween(row, 0.2, { BackgroundColor3 = T.panel2 })
        end)
        cb()
    end)
end
