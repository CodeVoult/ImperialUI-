local ColorPickerModule = {}

function ColorPickerModule.Add(Library, card, lbl, defaultColor, cb)
    local T = Library.T
    local UserInputService = game:GetService("UserInputService")
    local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
    local tempColor = savedColor

    local row = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.panel2,
        ZIndex = 5,
        Parent = card
    })
    Library.Cor(row, 20)
    local rowStroke = Library.Stk(row, T.border, 1)

    Library.New("TextLabel", {
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = T.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = row
    })
    Library:BindTheme(row, "BackgroundColor3", "panel2")
    Library:BindTheme(rowStroke, "Color", "border")
    local rowLabel = row:FindFirstChildOfClass("TextLabel")
    Library:BindTheme(rowLabel, "TextColor3", "text")

    local colorPreview = Library.New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 40, 0, 22),
        BackgroundColor3 = savedColor,
        Text = "",
        ZIndex = 6,
        Parent = row
    })
    Library.Cor(colorPreview, 11)
    local previewStroke = Library.Stk(colorPreview, T.border, 1)
    Library:BindTheme(previewStroke, "Color", "border")

    local screenGui = card:FindFirstAncestorOfClass("ScreenGui")
    local modalOverlay = Library.New("Frame", {
        Position = UDim2.new(0, -200, 0, -200),
        Size = UDim2.new(1, 400, 1, 400),
        BackgroundColor3 = T.bg,
        BackgroundTransparency = 0.5,
        Visible = false,
        ZIndex = 100,
        Parent = screenGui
    })

    local modalFrame = Library.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 340, 0, 280),
        BackgroundColor3 = T.panel,
        ZIndex = 101,
        Parent = modalOverlay
    })
    Library.Cor(modalFrame, 20)
    modalFrame.Size = UDim2.new(0.9, 0, 0, 280)
    Library.New("UISizeConstraint", {
        MinSize = Vector2.new(280, 260),
        MaxSize = Vector2.new(380, 300),
        Parent = modalFrame
    })
    Library:BindTheme(modalOverlay, "BackgroundColor3", "bg")
    Library:BindTheme(modalFrame, "BackgroundColor3", "panel")

    local modalShadow = Library.Shadow(modalFrame, 0.5, 30)
    modalShadow.ZIndex = 100

    local modalStroke = Library.New("UIStroke", {
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = modalFrame
    })
    Library:BindTheme(modalStroke, "Color", "border")

    Library.New("TextLabel", {
        Position = UDim2.new(0, 16, 0, 12),
        Size = UDim2.new(1, -32, 0, 24),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = T.text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library:BindTheme(modalFrame:FindFirstChildOfClass("TextLabel"), "TextColor3", "text")

    local svBox = Library.New("TextButton", {
        Position = UDim2.new(0, 16, 0, 44),
        Size = UDim2.new(0.5, -28, 0, 130),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library.Cor(svBox, 10)

    Library.New("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = svBox
    })

    local blackOverlay = Library.New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 103,
        Parent = svBox
    })
    Library.Cor(blackOverlay, 10)

    Library.New("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(0,0,0)),
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Parent = blackOverlay
    })

    local pickerCursor = Library.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = T.onAccent,
        ZIndex = 104,
        Parent = svBox
    })
    Library.Cor(pickerCursor, 6)
    local cursorStroke = Library.Stk(pickerCursor, T.text, 1)
    Library:BindTheme(pickerCursor, "BackgroundColor3", "onAccent")
    Library:BindTheme(cursorStroke, "Color", "text")

    local hueBar = Library.New("TextButton", {
        Position = UDim2.new(0.5, -4, 0, 44),
        Size = UDim2.new(0, 14, 0, 130),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library.Cor(hueBar, 7)

    Library.New("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Parent = hueBar
    })

    local cancelBtn = Library.New("TextButton", {
        Position = UDim2.new(0, 16, 0, 222),
        Size = UDim2.new(0.5, -24, 0, 42),
        BackgroundColor3 = T.panel2,
        Text = "Cancel",
        TextColor3 = T.text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library.Cor(cancelBtn, 21)
    local cancelStroke = Library.Stk(cancelBtn, T.border, 1)
    Library:BindTheme(cancelBtn, "BackgroundColor3", "panel2")
    Library:BindTheme(cancelBtn, "TextColor3", "text")
    Library:BindTheme(cancelStroke, "Color", "border")

    local applyBtn = Library.New("TextButton", {
        Position = UDim2.new(0.5, 4, 0, 222),
        Size = UDim2.new(0.5, -24, 0, 42),
        BackgroundColor3 = T.acc,
        Text = "Apply",
        TextColor3 = T.onAccent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library.Cor(applyBtn, 21)
    local applyStroke = Library.Stk(applyBtn, T.border, 1)
    Library:BindTheme(applyBtn, "BackgroundColor3", "acc")
    Library:BindTheme(applyBtn, "TextColor3", "onAccent")
    Library:BindTheme(applyStroke, "Color", "border")

    local h, s, v = Color3.toHSV(savedColor)

    local function refreshUI()
        tempColor = Color3.fromHSV(h, s, v)
        svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    end

    Library:Track(colorPreview.MouseButton1Click:Connect(function()
        tempColor = savedColor
        h, s, v = Color3.toHSV(savedColor)
        pickerCursor.Position = UDim2.fromScale(s, 1 - v)
        refreshUI()
        modalOverlay.Visible = true
    end))

    Library:Track(cancelBtn.MouseButton1Click:Connect(function()
        modalOverlay.Visible = false
    end))

    Library:Track(applyBtn.MouseButton1Click:Connect(function()
        savedColor = tempColor
        colorPreview.BackgroundColor3 = savedColor
        if cb then cb(savedColor) end
        modalOverlay.Visible = false
    end))

    local draggingSV, draggingHue = false, false

    Library:Track(svBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
            local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
            s, v = relX, 1 - relY
            pickerCursor.Position = UDim2.fromScale(relX, relY)
            refreshUI()
        end
    end))

    Library:Track(hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            h = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
            refreshUI()
        end
    end))

    Library:Track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = false
            draggingHue = false
        end
    end))

    Library:Track(UserInputService.InputChanged:Connect(function(input)
        if (draggingSV or draggingHue) and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if draggingSV then
                local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                s = relX
                v = 1 - relY
                pickerCursor.Position = UDim2.fromScale(relX, relY)
                refreshUI()
            elseif draggingHue then
                local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                h = relY
                refreshUI()
            end
        end
    end))
end

return ColorPickerModule
