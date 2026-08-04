local TweenService = game:GetService("TweenService")
local T = require(script.Parent.Parent.T)

local Button = {}

function Button.Create(row, lbl, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = lbl
    btn.TextColor3 = Color3.fromRGB(240, 245, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.ZIndex = 6
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(row, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundColor3 = T.border
        })
        tween:Play()
        task.delay(0.1, function()
            local tween = TweenService:Create(row, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = T.panel2
            })
            tween:Play()
        end)
        cb()
    end)
end

return Button
