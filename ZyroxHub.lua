local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/leeh10/LeeHubMax/refs/heads/main/LeehLib.lua"))()
-- NOTA: Asegúrate de que el link de abajo sea donde subas el Functions.lua
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/leeh10/LeeHubMax/refs/heads/main/Functions.lua"))()

local Win = Lib:Window({
    Title   = "ForceHub Max | V1.5",
    Creator = "ForceScript V1",
    Game    = "Duels: Murders Vs Sheriffs",
    Icon    = "rbxassetid://82180782246505",
})

-- === TABS ===
local tCombat  = Win:Tab({ Name = "Combat",  Icon = "rbxassetid://118115903634266" })
local tHitbox  = Win:Tab({ Name = "Hitbox",  Icon = "rbxassetid://77556334267498"  })
local tVisual  = Win:Tab({ Name = "Visual",  Icon = "rbxassetid://89399443859302"  })
local tPlayer  = Win:Tab({ Name = "Player",  Icon = "rbxassetid://84844770718081"  })
local tSettings = Win:Tab({ Name = "Settings", Icon = "rbxassetid://135494523653513" })

-- === COMBAT ===
local secAim = tCombat:Section("Silent Aim 360°")
secAim:Toggle({
    Name = "Activar Silent Aim",
    Default = false,
    Callback = function(v) Utils.S.saEn = v end
})
secAim:LineSlider({
    Name = "Predicción de Movimiento",
    Min = 0,
    Max = 200, 
    Default = 100,
    Callback = function(v)
        Utils.S.saPrediction = v
    end
})
secAim:Toggle({
    Name = "Wall Check",
    Default = false,
    Callback = function(v) Utils.S.wallCheck = v end
})
secAim:Toggle({
    Name = "Ocultar Círculo FOV",
    Default = false,
    Callback = function(v) Utils.S.hideFovCircle = v end
})
secAim:LineSlider({
    Name = "Radio FOV", Min = 30, Max = 800, Default = 150,
    Callback = function(v) Utils.S.saFOV = v end
})

local secAuto = tCombat:Section("Auto Combat")
secAuto:Toggle({
    Name = "Auto Shoot (Fuego Rápido)",
    Default = false,
    Callback = function(v) Utils.S.autoShoot = v end
})

-- === HITBOX ===
local secHb = tHitbox:Section("Hitbox Expander")
secHb:Toggle({
    Name = "Activar Hitbox",
    Default = false,
    Callback = function(v) Utils.S.hbEn = v end
})
secHb:Slider({
    Name = "Tamaño", Min = 2, Max = 50, Default = 10,
    Callback = function(v) Utils.S.hbSize = v end
})

-- === VISUAL ===
local secEsp = tVisual:Section("Visuales Pro")
secEsp:Toggle({
    Name = "ESP Brillo (Highlight)",
    Default = false,
    Callback = function(v) Utils.S.eP = v end
})
secEsp:Toggle({
    Name = "ESP Cajas",
    Default = false,
    Callback = function(v) Utils.S.espBoxes = v end
})
secEsp:Toggle({
    Name = "ESP Líneas",
    Default = false,
    Callback = function(v) Utils.S.espLines = v end
})

local secCol = tVisual:Section("Color de Visuales")
secCol:LineSlider({
    Name = "Rojo", Min = 0, Max = 255, Default = 255,
    Callback = function(v) Utils.S.espR = v Utils.S.espColor = Color3.fromRGB(Utils.S.espR, Utils.S.espG, Utils.S.espB) end
})
secCol:LineSlider({
    Name = "Verde", Min = 0, Max = 255, Default = 0,
    Callback = function(v) Utils.S.espG = v Utils.S.espColor = Color3.fromRGB(Utils.S.espR, Utils.S.espG, Utils.S.espB) end
})
secCol:LineSlider({
    Name = "Azul", Min = 0, Max = 255, Default = 0,
    Callback = function(v) Utils.S.espB = v Utils.S.espColor = Color3.fromRGB(Utils.S.espR, Utils.S.espG, Utils.S.espB) end
})

-- === PLAYER ===
local secMov = tPlayer:Section("Movimiento")
secMov:Toggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(v) Utils.S.spdEn = v end
})
secMov:Slider({
    Name = "Velocidad", Min = 16, Max = 300, Default = 100,
    Callback = function(v) Utils.S.spdVal = v end
})
secMov:Toggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v) Utils.S.ncEn = v end
})

local secLethal = tHitbox:Section("Acciones Letales")
secLethal:Toggle({
    Name = "Kill All (Masivo)",
    Default = false,
    Callback = function(v)
        Utils:SetKillAll(v)
    end
})

local secCam = tPlayer:Section("Cámara")
secCam:Toggle({
    Name = "FOV Personalizado",
    Default = false,
    Callback = function(v) Utils.S.fovEn = v end
})
secCam:Slider({
    Name = "Valor FOV", Min = 30, Max = 120, Default = 70,
    Callback = function(v) Utils.S.fovVal = v end
})


local secUI = tSettings:Section("Interfaz")

secUI:LineSlider({
    Name     = "Tamaño del Menú",
    Min      = 540, 
    Max      = 900, 
    Default  = 600,
    Callback = function(v)
        -- Usamos pcall para intentar cambiar el tamaño sin que el script se muera
        pcall(function()
            -- Primero intentamos el método oficial
            Win:SetSize(v, math.floor(v * 0.53))
            
            -- Si el método oficial no hace nada, forzamos el MainFrame
            local core = game:GetService("CoreGui")
            local mainFrame = core:FindFirstChild("LeehHub") or core:FindFirstChild("LeehLib")
            if mainFrame and mainFrame:FindFirstChild("Main") then
                mainFrame.Main.Size = UDim2.new(0, v, 0, math.floor(v * 0.53))
            end
        end)
    end,
})
