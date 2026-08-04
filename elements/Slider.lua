local UserInputService = game:GetService("UserInputService")

return function(self, lbl, mn, mx, def, cb)
    local H, T, card = self.Helpers, self.Theme, self.Card

    local row = H.New("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = T.panel2, ZIndex = 5, Parent = card })
    H.Cor(row, 21); H.Stk(row, T.border, 1)

    local valInput = H.New("TextBox", { Position = UDim2.new(0, 12, 0.5, -10), Size = UDim2.new(0, 35, 0, 20), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = T.border, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false, Parent = row })
    H.New("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 130, 0, 20), BackgroundTransparency = 1, Text = lbl, TextColor3 = Color3.fromRGB(240, 245, 255), Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = row })

    local track = H.New("Frame", { Position = UDim2.new(0, 52, 0.5, -2), Size = UDim2.new(1, -200, 0, 6), BackgroundColor3 = Color3.fromRGB(12, 22, 38), Parent = row })
    H.Cor(track, 3)

    local fill = H.New("Frame", { BackgroundColor3 = T.border, Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0), Parent = track })
    H.Cor(fill, 3)

    local thumb = H.New("TextButton", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((def - mn) / (mx - mn), 0, 0.5, 0), Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Text = "", AutoButtonColor = false, Parent = track })
    H.Cor(thumb, 7)

    local function setVal(newVal)
        newVal = math.clamp(newVal, mn, mx)
        valInput.Text = tostring(newVal)
        local tt = (newVal - mn) / (mx - mn)
        H.Tween(fill, 0.15, { Size = UDim2.new(tt, 0, 1, 0) })
        H.Tween(thumb, 0.15, { Position = UDim2.new(tt, 0, 0.5, 0) })
        cb(newVal)
    end

    local dragging = false
    local function update(posX)
        local t = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        setVal(math.clamp(math.floor(mn + t * (mx - mn) + 0.5), mn, mx))
    end

    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
