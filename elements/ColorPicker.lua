local UserInputService = game:GetService("UserInputService")

return function(self, lbl, defaultColor, cb)
    local H, T, card = self.Helpers, self.Theme, self.Card
    local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
    local tempColor = savedColor

    local row = H.New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.panel2, Parent = card })
    H.Cor(row, 20); H.Stk(row, T.border, 1.5)

    H.New("TextLabel", { Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), BackgroundTransparency = 1, Text = lbl, TextColor3 = Color3.fromRGB(240, 245, 255), Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })

    local colorPreview = H.New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 40, 0, 22), BackgroundColor3 = savedColor, Text = "", Parent = row })
    H.Cor(colorPreview, 11); H.Stk(colorPreview, T.border, 1.2)

    local screenGui = card:FindFirstAncestorOfClass("ScreenGui")
    local modalOverlay = H.New("Frame", { Position = UDim2.new(0, -200, 0, -200), Size = UDim2.new(1, 400, 1, 400), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.5, Visible = false, ZIndex = 100, Parent = screenGui })
    local modalFrame = H.New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, 340, 0, 280), BackgroundColor3 = Color3.fromRGB(8, 14, 26), ZIndex = 101, Parent = modalOverlay })
    H.Cor(modalFrame, 20)

    local svBox = H.New("TextButton", { Position = UDim2.new(0, 16, 0, 44), Size = UDim2.new(0, 150, 0, 130), BackgroundColor3 = Color3.fromRGB(255, 0, 0), Text = "", ZIndex = 102, Parent = modalFrame })
    H.Cor(svBox, 10)

    local applyBtn = H.New("TextButton", { Position = UDim2.new(0, 176, 0, 222), Size = UDim2.new(0, 148, 0, 42), BackgroundColor3 = Color3.fromRGB(24, 100, 230), Text = "Apply", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 102, Parent = modalFrame })
    H.Cor(applyBtn, 21)

    colorPreview.MouseButton1Click:Connect(function() modalOverlay.Visible = true end)
    applyBtn.MouseButton1Click:Connect(function()
        savedColor = tempColor
        colorPreview.BackgroundColor3 = savedColor
        cb(savedColor)
        modalOverlay.Visible = false
    end)
end
