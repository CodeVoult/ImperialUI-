local LeehHub = {}
LeehHub.__index = LeehHub

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local T = {
    bg      = Color3.fromRGB(15, 15, 15),     
    panel   = Color3.fromRGB(22, 22, 22), 
    panel2  = Color3.fromRGB(28, 28, 28),  
    border  = Color3.fromRGB(45, 45, 45),  
    acc     = Color3.fromRGB(255, 255, 255), 
    text    = Color3.fromRGB(250, 250, 250),
    muted   = Color3.fromRGB(140, 140, 140),
    red     = Color3.fromRGB(200, 30, 30),
    green   = Color3.fromRGB(34, 197, 94),
    bgTrans = 0.05,
    tabSize = 140,
    iconSize = 18,
}

local function getIconId(icon)
    if not icon or icon == "" then return "" end
    if type(icon) == "number" or (type(icon) == "string" and tonumber(icon)) then
        return "rbxassetid://" .. tostring(icon)
    end
    return tostring(icon)
end

local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Cor(obj, r) New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = obj }) end
local function Stk(obj, col, th) New("UIStroke", { Color = col or T.border, Thickness = th or 1.2, Parent = obj }) end
local function List(obj, dir, pad)
    New("UIListLayout", {
        FillDirection = dir or Enum.FillDirection.Vertical,
        Padding       = UDim.new(0, pad or 8),
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Parent        = obj,
    })
end
local function Pad(obj, t, b, l, r)
    New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingRight  = UDim.new(0, r or 0),
        Parent        = obj,
    })
end
local function TW(obj, t, props)
    local anim = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    anim:Play()
    return anim
end

function LeehHub:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or cfg.Name or "LeehHub"
    local sub   = cfg.SubTitle or cfg.Creator or ""

    local GUI = New("ScreenGui", {  
        Name         = "LeehHub_UI",  
        ResetOnSpawn = false,  
        Parent       = (gethui and gethui()) or game:GetService("CoreGui"),  
    })  

    local winMain = New("Frame", {  
        Name                   = "Main",  
        AnchorPoint            = Vector2.new(0.5, 0.5),  
        Position               = UDim2.fromScale(0.5, 0.5),  
        Size                   = cfg.Size or UDim2.new(0, 560, 0, 320),  
        BackgroundColor3       = T.bg,  
        BackgroundTransparency = T.bgTrans,  
        Visible                = true,  
        Parent                 = GUI,  
    })  
    Cor(winMain, 10)  
    Stk(winMain, Color3.fromRGB(0,0,0), 2.5)  

    local titleBar = New("Frame", {  
        Size                   = UDim2.new(1, -12, 0, 38),  
        Position               = UDim2.new(0, 6, 0, 6),  
        BackgroundColor3       = T.panel,  
        BackgroundTransparency = 0.2,  
        Parent                 = winMain,  
    })  
    Cor(titleBar, 8)  
    Stk(titleBar, T.border, 1)

    New("TextLabel", {  
        Position               = UDim2.new(0, 12, 0, 0),  
        Size                   = UDim2.new(1, -24, 1, 0),  
        BackgroundTransparency = 1,  
        Text                   = sub ~= "" and (title .. " | " .. sub) or title,  
        TextColor3             = T.text,  
        Font                   = Enum.Font.GothamBold,  
        TextSize               = 13,  
        TextXAlignment         = Enum.TextXAlignment.Left,  
        Parent                 = titleBar,  
    })  

    local sidebar = New("ScrollingFrame", {  
        Position               = UDim2.new(0, 6, 0, 50),  
        Size                   = UDim2.new(0, T.tabSize, 1, -56),  
        BackgroundTransparency = 1,  
        ScrollBarThickness     = 0,  
        CanvasSize             = UDim2.new(0,0,0,0),  
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,  
        Parent                 = winMain,  
    })  
    List(sidebar, Enum.FillDirection.Vertical, 6)  
    Pad(sidebar, 2, 2, 2, 2)  

    local contentArea = New("Frame", {  
        Position               = UDim2.new(0, T.tabSize + 12, 0, 50),  
        Size                   = UDim2.new(1, -(T.tabSize + 18), 1, -56),  
        BackgroundTransparency = 1,  
        Parent                 = winMain,  
    })  

    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = i.Position; startPos = winMain.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            winMain.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)

    local pages = {}

    local function CreateTab(self, tabCfg)
        if type(tabCfg) == "string" then tabCfg = { Name = tabCfg } end
        tabCfg = tabCfg or {}
        local nm = tabCfg.Name or tabCfg.Title or "Tab"
        local iconAsset = getIconId(tabCfg.Icon)

        local page = New("ScrollingFrame", {  
            Size                   = UDim2.fromScale(1, 1),  
            BackgroundTransparency = 1,  
            Visible                = false,  
            ScrollBarThickness     = 2,  
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,  
            Parent                 = contentArea,  
        })  
        List(page, Enum.FillDirection.Vertical, 8)  
        Pad(page, 2, 6, 2, 6)  
        pages[nm] = page  

        local btn = New("TextButton", {  
            Size                   = UDim2.new(1, 0, 0, 34),  
            BackgroundColor3       = T.panel,  
            BackgroundTransparency = 0.5,
            Text                   = "",  
            Parent                 = sidebar,  
        })  
        Cor(btn, 6)  
        Stk(btn, T.border, 1)

        local hasIcon = iconAsset ~= ""

        local iconImg
        if hasIcon then
            iconImg = New("ImageLabel", {
                Size                   = UDim2.new(0, T.iconSize, 0, T.iconSize),
                Position               = UDim2.new(0, 8, 0.5, 0),
                AnchorPoint            = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image                  = iconAsset,
                ImageColor3            = T.muted,
                Parent                 = btn,
            })
        end

        local txtLabel = New("TextLabel", {
            Position               = UDim2.new(0, hasIcon and (T.iconSize + 14) or 10, 0, 0),
            Size                   = UDim2.new(1, -(hasIcon and (T.iconSize + 18) or 12), 1, 0),
            BackgroundTransparency = 1,
            Text                   = nm,
            TextColor3             = T.muted,
            Font                   = Enum.Font.GothamMedium,
            TextSize               = 12,
            TextXAlignment         = Enum.TextXAlignment.Left,
            Parent                 = btn,
        })

        btn.MouseButton1Click:Connect(function()  
            for name, pg in pairs(pages) do pg.Visible = (name == nm) end  
            for _, b in ipairs(sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    TW(b, 0.2, { BackgroundTransparency = 0.5 })
                    local lbl = b:FindFirstChildOfClass("TextLabel")
                    local img = b:FindFirstChildOfClass("ImageLabel")
                    if lbl then TW(lbl, 0.2, { TextColor3 = T.muted }) end
                    if img then TW(img, 0.2, { ImageColor3 = T.muted }) end
                end
            end
            TW(btn, 0.2, { BackgroundTransparency = 0 })
            TW(txtLabel, 0.2, { TextColor3 = T.text })
            if iconImg then TW(iconImg, 0.2, { ImageColor3 = T.text }) end
        end)  

        if #sidebar:GetChildren() == 2 then 
            page.Visible = true
            btn.BackgroundTransparency = 0
            txtLabel.TextColor3 = T.text
            if iconImg then iconImg.ImageColor3 = T.text end
        end

        local Tab = { Container = page }

        function Tab:AddToggle(idx, cfg)
            cfg = cfg or idx or {}
            local name = cfg.Name or cfg.Title or "Toggle"
            local def  = cfg.Default or false
            local cb   = cfg.Callback or function() end

            local row = New("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.panel2, Parent = page })
            Cor(row, 6); Stk(row, T.border, 1)

            New("TextLabel", {
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1, Text = name, TextColor3 = T.text,
                Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = row
            })

            local sw = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 36, 0, 18), BackgroundColor3 = def and T.green or T.red, Parent = row
            })
            Cor(sw, 10)

            local knob = New("Frame", {
                Size = UDim2.new(0, 12, 0, 12), Position = def and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = Color3.new(1,1,1), Parent = sw
            })
            Cor(knob, 10)

            local btnClick = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", Parent = row })
            btnClick.MouseButton1Click:Connect(function()
                def = not def
                TW(sw, 0.2, { BackgroundColor3 = def and T.green or T.red })
                TW(knob, 0.2, { Position = def and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6) })
                cb(def)
            end)
            return { OnChanged = function(self, fn) cb = fn end }
        end

        function Tab:AddSlider(idx, cfg)
            cfg = cfg or idx or {}
            local name = cfg.Name or cfg.Title or "Slider"
            local mn, mx = cfg.Min or 0, cfg.Max or 100
            local def = cfg.Default or mn
            local cb = cfg.Callback or function() end

            local row = New("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = T.panel2, Parent = page })
            Cor(row, 6); Stk(row, T.border, 1)

            New("TextLabel", {
                Position = UDim2.new(0, 10, 0, 4), Size = UDim2.new(1, -60, 0, 16),
                BackgroundTransparency = 1, Text = name, TextColor3 = T.text,
                Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = row
            })

            local valLbl = New("TextLabel", {
                Position = UDim2.new(1, -50, 0, 4), Size = UDim2.new(0, 40, 0, 16),
                BackgroundTransparency = 1, Text = tostring(def), TextColor3 = T.muted,
                Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = row
            })

            local track = New("Frame", { Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, 6), BackgroundColor3 = T.panel, Parent = row })
            Cor(track, 3)

            local fill = New("Frame", { Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0), BackgroundColor3 = T.acc, Parent = track })
            Cor(fill, 3)

            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local val = math.floor(mn + pos * (mx - mn))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valLbl.Text = tostring(val)
                cb(val)
            end

            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; update(i)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end
            end)
            UserInputService.InputEnded:Connect(function() dragging = false end)
            return { OnChanged = function(self, fn) cb = fn end }
        end

        Tab.Section = function(self, name) return Tab end
        Tab.Toggle = Tab.AddToggle
        Tab.Slider = Tab.AddSlider
        Tab.LineSlider = Tab.AddSlider

        return Tab
    end

    return {
        Tab = function(self, cfg) return CreateTab(self, cfg) end,
        AddTab = function(self, cfg) return CreateTab(self, cfg) end,
        SetSize = function(self, w, h) winMain.Size = UDim2.new(0, w, 0, h or math.floor(w * 0.53)) end
    }
end

LeehHub.Window = LeehHub.CreateWindow

return LeehHub
