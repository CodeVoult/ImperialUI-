local ButtonModule = {}

function ButtonModule.Add(Library, card, lbl, cb)
    local T = Library.T
    local row = Library.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.panel2,
        ZIndex = 5,
        Parent = card
    })
    Library.Cor(row, 20)
    Library.Stk(row, T.border, 1.5)

    local btn = Library.New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = Color3.fromRGB(240, 245, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        ZIndex = 6,
        Parent = row
    })

    btn.MouseButton1Click:Connect(function()
        Library.Tween(row, 0.1, { BackgroundColor3 = T.border })
        task.delay(0.1, function()
            Library.Tween(row, 0.2, { BackgroundColor3 = T.panel2 })
        end)
        if cb then cb() end
    end)
end

return ButtonModule
