local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local T = require(script.Parent.Parent.T)

local Slider = {}

function Slider.Create(row, lbl, mn, mx, def, cb)
    local valInput = Instance.new("TextBox")
    valInput.Position = UDim2.new(0, 12, 0.5, -10)
    valInput.Size = UDim2.new(0, 35, 0, 20)
    valInput.BackgroundTransparency = 1
    valInput.Text = tostring(def)
    valInput.TextColor3 = T.border
    valInput.Font = Enum.Font.GothamBold
    valInput.TextSize = 12
    valInput.TextXAlignment = Enum.TextXAlignment.Center
    valInput.ClearTextOnFocus = false
    valInput.ZIndex = 8
    valInput.Parent = row

    local label = Instance.new("TextLabel")
    label.AnchorPoint = Vector2.new(1, 0.5)
    label.Position = UDim2.new(1, -12, 0.5, 0)
    label.Size = UDim2.new(0, 130, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = lbl
    label.TextColor3 = Color3.fromRGB(240, 245, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.ZIndex = 6
    label.Parent = row

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 52, 0.5, -2)
    track.Size = UDim2.new(1, -200, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(12, 22, 38)
    track.ZIndex = 6
    track.Parent = row
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(255, 255, 255)
    trackStroke.Thickness = 1.6
    trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke.Parent = track
    
    local trackGradient = Instance.new("UIGradient")
    trackGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 110, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 30, 80))
    })
    trackGradient.Rotation = 225
    trackGradient.Parent = trackStroke

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = T.border
    fill.Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)
    fill.ZIndex = 7
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    local thumb = Instance.new("TextButton")
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((def - mn) / (mx - mn), 0, 0.5, 0)
    thumb.Size = UDim2.new(0, 14, 0, 14)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.AutoButtonColor = false
    thumb.ZIndex = 8
    thumb.Parent = track
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 7)
    thumbCorner.Parent = thumb

    local function setVal(newVal)
        newVal = math.clamp(newVal, mn, mx)
        valInput.Text = tostring(newVal)
        local tt = (newVal - mn) / (mx - mn)
        local tween1 = TweenService:Create(fill, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(tt, 0, 1, 0)
        })
        tween1:Play()
        local tween2 = TweenService:Create(thumb, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(tt, 0, 0.5, 0)
        })
        tween2:Play()
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

    valInput.FocusLost:Connect(function()
        local num = tonumber(valInput.Text)
        if num then setVal(math.round(num)) end
    end)
end

return Slider
