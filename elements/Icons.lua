-- Local, vector-style icons never depend on image permissions or HTTP.
local Icons = {}
local paths = {
    home = {{3,10,12,3},{12,3,21,10},{6,9,6,21},{6,21,18,21},{18,21,18,9},{10,21,10,14},{10,14,14,14},{14,14,14,21}},
    combat = {{5,3,20,18},{4,17,8,21},{6,19,11,14},{19,3,4,18},{16,14,21,19}},
    hitbox = {{4,4,20,4},{20,4,20,20},{20,20,4,20},{4,20,4,4},{8,8,16,8},{16,8,16,16},{16,16,8,16},{8,16,8,8}},
    eye = {{2,12,7,7},{7,7,17,7},{17,7,22,12},{22,12,17,17},{17,17,7,17},{7,17,2,12},{10,10,14,10},{14,10,14,14},{14,14,10,14},{10,14,10,10}},
    leaf = {{4,20,19,5},{5,17,5,9},{5,9,11,4},{11,4,21,3},{21,3,20,13},{20,13,15,18},{15,18,7,18}},
    user = {{9,3,15,3},{15,3,16,8},{16,8,12,11},{12,11,8,8},{8,8,9,3},{4,21,5,16},{5,16,9,14},{9,14,15,14},{15,14,19,16},{19,16,20,21},{20,21,4,21}},
    sparkles = {{12,2,15,9},{15,9,22,12},{22,12,15,15},{15,15,12,22},{12,22,9,15},{9,15,2,12},{2,12,9,9},{9,9,12,2}},
    camera = {{3,7,8,7},{8,7,9,4},{9,4,15,4},{15,4,16,7},{16,7,21,7},{21,7,21,20},{21,20,3,20},{3,20,3,7},{9,10,15,10},{15,10,16,14},{16,14,12,17},{12,17,8,14},{8,14,9,10}},
    settings = {{3,6,21,6},{3,12,21,12},{3,18,21,18},{8,3,8,9},{16,9,16,15},{10,15,10,21}},
    menu = {{4,6,20,6},{4,12,20,12},{4,18,20,18}},
}

function Icons.Resolve(value)
    if value == nil or value == "" then return "builtin", "home" end
    local text = tostring(value)
    if paths[text:lower()] then return "builtin", text:lower() end
    local id = text:match("^rbxassetid://(%d+)$") or text:match("^(%d+)$")
        or text:match("^https?://www%.roblox%.com/asset/%?id=(%d+)$")
    if id and tonumber(id) > 0 then return "asset", "rbxassetid://" .. id end
    if text:match("^rbxasset://") then return "asset", text end
    return nil, "Unknown icon: " .. text
end

function Icons.Draw(library, image, name)
    local frame = library.New("Frame", {
        Name = "VectorIcon", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, ZIndex = image.ZIndex, Parent = image,
    })
    for _, p in ipairs(paths[name] or paths.home) do
        local dx, dy = p[3] - p[1], p[4] - p[2]
        local line = library.New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((p[1] + p[3]) / 48, (p[2] + p[4]) / 48),
            Size = UDim2.new(math.sqrt(dx * dx + dy * dy) / 24, 0, 0, 1.6),
            Rotation = math.deg(math.atan2(dy, dx)),
            BorderSizePixel = 0, ZIndex = image.ZIndex, Parent = frame,
        })
        library.Cor(line, 2)
        line.BackgroundColor3 = image.ImageColor3
        local connection = image:GetPropertyChangedSignal("ImageColor3"):Connect(function()
            line.BackgroundColor3 = image.ImageColor3
        end)
        local destroying
        destroying = frame.Destroying:Connect(function()
            connection:Disconnect()
            destroying:Disconnect()
        end)
    end
    return frame
end

function Icons.Set(library, image, value, fallback)
    local old = image:FindFirstChild("VectorIcon")
    if old then old:Destroy() end
    image.Image = ""
    local kind, result = Icons.Resolve(value)
    if kind == "builtin" then return Icons.Draw(library, image, result) end
    if not kind then
        warn("[ImperialUI] " .. result .. "; using " .. (fallback or "home"))
        return Icons.Draw(library, image, fallback or "home")
    end
    image.Image = result
    -- Keep a useful icon visible until Roblox confirms that the image loaded.
    local placeholder = Icons.Draw(library, image, fallback or "home")
    task.spawn(function()
        local ok, err = pcall(function()
            game:GetService("ContentProvider"):PreloadAsync({result})
        end)
        if not image.Parent or image.Image ~= result or not placeholder.Parent then return end
        if ok and image.IsLoaded then
            placeholder:Destroy()
        else
            image.Image = ""
            warn("[ImperialUI] Image unavailable (" .. result .. "): " .. tostring(err or "check asset permissions"))
        end
    end)
    return placeholder
end

return Icons