local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local T = require(script.Parent.Parent.T)

local ColorPicker = {}

function ColorPicker.Create(row, lbl, defaultColor, cb, card)
    local savedColor = defaultColor or Color3.fromRGB(255, 255, 255)
    local tempColor = savedColor

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = lbl
    label.TextColor3 = Color3.fromRGB(240, 245, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = row

    local colorPreview = Instance.new("TextButton")
    colorPreview.AnchorPoint = Vector2.new(1, 0.5)
    colorPreview.Position = UDim2.new(1, -10, 0.5, 0)
    colorPreview.Size = UDim2.new(0, 40, 0, 22)
    colorPreview.BackgroundColor3 = savedColor
    colorPreview.Text = ""
    colorPreview.ZIndex = 6
    colorPreview.Parent = row
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 11)
    previewCorner.Parent = colorPreview
    
    local previewStroke = Instance.new("UIStroke")
    previewStroke.Color = T.border
    previewStroke.Thickness = 1.2
    previewStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    previewStroke.Parent = colorPreview

    local screenGui = card:FindFirstAncestorOfClass("ScreenGui")
    local modalOverlay = Instance.new("Frame")
    modalOverlay.Position = UDim2.new(0, -200, 0, -200)
    modalOverlay.Size = UDim2.new(1, 400, 1, 400)
    modalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    modalOverlay.BackgroundTransparency = 0.5
    modalOverlay.Visible = false
    modalOverlay.ZIndex = 100
    modalOverlay.Parent = screenGui

    local modalFrame = Instance.new("Frame")
    modalFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    modalFrame.Position = UDim2.fromScale(0.5, 0.5)
    modalFrame.Size = UDim2.new(0, 340, 0, 280)
    modalFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 26)
    modalFrame.ZIndex = 101
    modalFrame.Parent = modalOverlay
    
    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, 20)
    modalCorner.Parent = modalFrame

    local modalStroke = Instance.new("UIStroke")
    modalStroke.Thickness = 2.2
    modalStroke.Color = Color3.fromRGB(255, 255, 255)
    modalStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    modalStroke.Parent = modalFrame
    
    local modalGradient = Instance.new("UIGradient")
    modalGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
    })
    modalGradient.Rotation = 225
    modalGradient.Parent = modalStroke
    
    task.spawn(function()
        while modalGradient and modalGradient.Parent do
            modalGradient.Rotation = (modalGradient.Rotation + 1.2) % 360
            task.wait(0.03)
        end
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Position = UDim2.new(0, 16, 0, 12)
    titleLabel.Size = UDim2.new(1, -32, 0, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = lbl
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 102
    titleLabel.Parent = modalFrame

    local svBox = Instance.new("TextButton")
    svBox.Position = UDim2.new(0, 16, 0, 44)
    svBox.Size = UDim2.new(0, 150, 0, 130)
    svBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    svBox.Text = ""
    svBox.AutoButtonColor = false
    svBox.ZIndex = 102
    svBox.Parent = modalFrame
    
    local svCorner = Instance.new("UICorner")
    svCorner.CornerRadius = UDim.new(0, 10)
    svCorner.Parent = svBox

    local svGradient = Instance.new("UIGradient")
    svGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    svGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    svGradient.Parent = svBox

    local blackOverlay = Instance.new("Frame")
    blackOverlay.Size = UDim2.fromScale(1, 1)
    blackOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blackOverlay.BackgroundTransparency = 1
    blackOverlay.ZIndex = 103
    blackOverlay.Parent = svBox
    
    local blackCorner = Instance.new("UICorner")
    blackCorner.CornerRadius = UDim.new(0, 10)
    blackCorner.Parent = blackOverlay

    local blackGradient = Instance.new("UIGradient")
    blackGradient.Color = ColorSequence.new(Color3.fromRGB(0,0,0))
    blackGradient.Rotation = 90
    blackGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    blackGradient.Parent = blackOverlay

    local pickerCursor = Instance.new("Frame")
    pickerCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    pickerCursor.Position = UDim2.fromScale(1, 0)
    pickerCursor.Size = UDim2.new(0, 12, 0, 12)
    pickerCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pickerCursor.ZIndex = 104
    pickerCursor.Parent = svBox
    
    local cursorCorner = Instance.new("UICorner")
    cursorCorner.CornerRadius = UDim.new(0, 6)
    cursorCorner.Parent = pickerCursor
    
    local cursorStroke = Instance.new("UIStroke")
    cursorStroke.Color = Color3.fromRGB(0, 0, 0)
    cursorStroke.Thickness = 1.5
    cursorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cursorStroke.Parent = pickerCursor

    local hueBar = Instance.new("TextButton")
    hueBar.Position = UDim2.new(0, 174, 0, 44)
    hueBar.Size = UDim2.new(0, 14, 0, 130)
    hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueBar.Text = ""
    hueBar.AutoButtonColor = false
    hueBar.ZIndex = 102
    hueBar.Parent = modalFrame
    
    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 7)
    hueCorner.Parent = hueBar

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Rotation = 90
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = hueBar

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Position = UDim2.new(0, 16, 0, 222)
    cancelBtn.Size = UDim2.new(0, 148, 0, 42)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(14, 25, 45)
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(220, 230, 255)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 14
    cancelBtn.ZIndex = 102
    cancelBtn.Parent = modalFrame
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 21)
    cancelCorner.Parent = cancelBtn
    
    local cancelStroke = Instance.new("UIStroke")
    cancelStroke.Color = Color3.fromRGB(30, 100, 210)
    cancelStroke.Thickness = 1.8
    cancelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cancelStroke.Parent = cancelBtn

    local applyBtn = Instance.new("TextButton")
    applyBtn.Position = UDim2.new(0, 176, 0, 222)
    applyBtn.Size = UDim2.new(0, 148, 0, 42)
    applyBtn.BackgroundColor3 = Color3.fromRGB(24, 100, 230)
    applyBtn.Text = "Apply"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 14
    applyBtn.ZIndex = 102
    applyBtn.Parent = modalFrame
    
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 21)
    applyCorner.Parent = applyBtn
    
    local applyStroke = Instance.new("UIStroke")
    applyStroke.Color = Color3.fromRGB(60, 140, 255)
    applyStroke.Thickness = 1.8
    applyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    applyStroke.Parent = applyBtn

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
        cb(savedColor)
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

return ColorPicker
