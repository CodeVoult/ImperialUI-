local Section = {}

function Section.Create(library, page)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.ZIndex = 5
    container.Parent = page
    
    local containerList = Instance.new("UIListLayout")
    containerList.FillDirection = Enum.FillDirection.Vertical
    containerList.Padding = UDim.new(0, 8)
    containerList.SortOrder = Enum.SortOrder.LayoutOrder
    containerList.Parent = container

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundTransparency = 1
    card.ZIndex = 5
    card.Parent = container
    
    local cardList = Instance.new("UIListLayout")
    cardList.FillDirection = Enum.FillDirection.Vertical
    cardList.Padding = UDim.new(0, 8)
    cardList.SortOrder = Enum.SortOrder.LayoutOrder
    cardList.Parent = card

    return { Card = card, Library = library }
end

return Section
