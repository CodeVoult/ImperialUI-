local TweenService = game:GetService("TweenService")
local T = require(script.Parent.Parent.T)

local Toggle = {}

function Toggle.Create(row, lbl, def, cb, library)
    local switchBg = Instance.new("Frame")
    switchBg.AnchorPoint = Vector2.new(1, 0.5)
    switchBg.Position = UDim2.new(1, -10, 0.5, 0)
    switchBg.Size = UDim2.new(0, 50, 0, 26)
    switchBg.BackgroundColor3 = T.switchOff
    switchBg.ZIndex = 6
    switchBg.Parent = row
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = switchBg
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = T.border
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = switchBg

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.ZIndex = 7
    knob.Parent = switchBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = knob

    local click = Instance.new("TextButton")
    click.Size = UDim2.fromScale(1, 1)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 9
    click.Parent = row

    click.MouseButton1Click:Connect(function()
        def = not def
        cb(def)
        library:Notify(lbl, def)
        local tween = TweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = def and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        })
        tween:Play()
    end)
end

return Toggle
