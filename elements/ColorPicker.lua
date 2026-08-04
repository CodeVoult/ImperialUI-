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
    Library.Stk(row, T.border, 1.5)

    Library.New("TextLabel", {
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = Color3.fromRGB(240, 245, 255),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = row
    })

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
    Library.Stk(colorPreview, T.border, 1.2)

    local screenGui = card:FindFirstAncestorOfClass("ScreenGui")
    local modalOverlay = Library.New("Frame", {
        Position = UDim2.new(0, -200, 0, -200),
        Size = UDim2.new(1, 400, 1, 400),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Visible = false,
        ZIndex = 100,
        Parent = screenGui
    })

    local modalFrame = Library.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 340, 0, 280),
        BackgroundColor3 = Color3.fromRGB(8, 14, 26),
        ZIndex = 101,
        Parent = modalOverlay
    })
    Library.Cor(modalFrame, 20)

    local modalShadow = Library.Shadow(modalFrame, 0.5, 30)
    modalShadow.ZIndex = 100

    local modalStroke = Library.New("UIStroke", {
        Thickness = 2.2,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = modalFrame
    })
    local modalGradient = Library.New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
        }),
        Rotation = 225,
        Parent = modalStroke
    })
    
    task.spawn(function()
        while modalGradient and modalGradient.Parent do
            modalGradient.Rotation = (modalGradient.Rotation + 1.2) % 360
            task.wait(0.03)
        end
    end)

    Library.New("TextLabel", {
        Position = UDim2.new(0, 16, 0, 12),
        Size = UDim2.new(1, -32, 0, 24),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
        Parent = modalFrame
    })

    local svBox = Library.New("TextButton", {
        Position = UDim2.new(0, 16, 0, 44),
        Size = UDim2.new(0, 150, 0, 130),
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
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 104,
        Parent = svBox
    })
    Library.Cor(pickerCursor, 6)
    Library.Stk(pickerCursor, Color3.fromRGB(0, 0, 0), 1.5)

    local hueBar = Library.New("TextButton", {
        Position = UDim2.new(0, 174, 0, 44),
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
        Size = UDim2.new(0, 148, 0, 42),
        BackgroundColor3 = Color3.fromRGB(14, 25, 45),
        Text = "Cancel",
        TextColor3 = Color3.fromRGB(220, 230, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library.Cor(cancelBtn, 21)
    Library.Stk(cancelBtn, Color3.fromRGB(30, 100, 210), 1.8)

    local applyBtn = Library.New("TextButton", {
        Position = UDim2.new(0, 176, 0, 222),
        Size = UDim2.new(0, 148, 0, 42),
        BackgroundColor3 = Color3.fromRGB(24, 100, 230),
        Text = "Apply",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 102,
        Parent = modalFrame
    })
    Library.Cor(applyBtn, 21)
    Library.Stk(applyBtn, Color3.fromRGB(60, 140, 255), 1.8)

    local h, s, v = Color3.toHSV(savedColor)

    local function refreshUI()
        tempColor = Color3.fromHSV(h, s, v)
        svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    end

    colorPreview.MouseButton1Click:Connect(function()
        tempColor = savedColor
        h, s, v = Color3.toHSV(savedColor)
        pickerCursor.Position = UDim2.fromScale(s, 1 - v)
        refreshUI()
        modalOverlay.Visible = true
    end)

    cancelBtn.MouseButton1Click:Connect(function()
        modalOverlay.Visible = false
    end)

    applyBtn.MouseButton1Click:Connect(function()
        savedColor = tempColor
        colorPreview.BackgroundColor3 = savedColor
        if cb then cb(savedColor) end
        modalOverlay.Visible = false
    end)

    local draggingSV, draggingHue = false, false

    svBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
        end
    end)

    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = false
            draggingHue = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
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
    end)
end

return ColorPickerModule
