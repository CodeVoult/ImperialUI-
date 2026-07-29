local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeVoult/CodeVoult1.lib/refs/heads/main/Zyroxlib.lua"))()

-- TABLA TEMPORAL PARA PRUEBAS (Sustituye a Functions.lua de momento)
local Utils = {
    S = {},
    SetKillAll = function(self, val)
        print("Kill All:", val)
    end
}

-- === TABS CON ÍCONOS ===
local tCombat   = Win:AddTab({ Title = "Combat",   Icon = "rbxassetid://118115903634266" })
local tHitbox   = Win:AddTab({ Title = "Hitbox",   Icon = "rbxassetid://77556334267498"  })
local tVisual   = Win:AddTab({ Title = "Visual",   Icon = "rbxassetid://89399443859302"  })
local tPlayer   = Win:AddTab({ Title = "Player",   Icon = "rbxassetid://84844770718081"  })
local tSettings = Win:AddTab({ Title = "Settings", Icon = "rbxassetid://135494523653513" })

-- === COMBAT ===
tCombat:AddToggle({
    Title = "Activar Silent Aim",
    Default = false,
    Callback = function(v) Utils.S.saEn = v end
})
tCombat:AddSlider({
    Title = "Predicción de Movimiento",
    Min = 0, Max = 200, Default = 100,
    Callback = function(v) Utils.S.saPrediction = v end
})
tCombat:AddToggle({
    Title = "Wall Check",
    Default = false,
    Callback = function(v) Utils.S.wallCheck = v end
})
tCombat:AddToggle({
    Title = "Ocultar Círculo FOV",
    Default = false,
    Callback = function(v) Utils.S.hideFovCircle = v end
})
tCombat:AddSlider({
    Title = "Radio FOV", Min = 30, Max = 800, Default = 150,
    Callback = function(v) Utils.S.saFOV = v end
})
tCombat:AddToggle({
    Title = "Auto Shoot (Fuego Rápido)",
    Default = false,
    Callback = function(v) Utils.S.autoShoot = v end
})

-- === HITBOX ===
tHitbox:AddToggle({
    Title = "Activar Hitbox",
    Default = false,
    Callback = function(v) Utils.S.hbEn = v end
})
tHitbox:AddSlider({
    Title = "Tamaño", Min = 2, Max = 50, Default = 10,
    Callback = function(v) Utils.S.hbSize = v end
})
tHitbox:AddToggle({
    Title = "Kill All (Masivo)",
    Default = false,
    Callback = function(v) Utils:SetKillAll(v) end
})

-- === VISUAL ===
tVisual:AddToggle({
    Title = "ESP Brillo (Highlight)",
    Default = false,
    Callback = function(v) Utils.S.eP = v end
})
tVisual:AddToggle({
    Title = "ESP Cajas",
    Default = false,
    Callback = function(v) Utils.S.espBoxes = v end
})
tVisual:AddToggle({
    Title = "ESP Líneas",
    Default = false,
    Callback = function(v) Utils.S.espLines = v end
})
tVisual:AddSlider({
    Title = "Rojo", Min = 0, Max = 255, Default = 255,
    Callback = function(v) Utils.S.espR = v Utils.S.espColor = Color3.fromRGB(Utils.S.espR, Utils.S.espG, Utils.S.espB) end
})
tVisual:AddSlider({
    Title = "Verde", Min = 0, Max = 255, Default = 0,
    Callback = function(v) Utils.S.espG = v Utils.S.espColor = Color3.fromRGB(Utils.S.espR, Utils.S.espG, Utils.S.espB) end
})
tVisual:AddSlider({
    Title = "Azul", Min = 0, Max = 255, Default = 0,
    Callback = function(v) Utils.S.espB = v Utils.S.espColor = Color3.fromRGB(Utils.S.espR, Utils.S.espG, Utils.S.espB) end
})

-- === PLAYER ===
tPlayer:AddToggle({
    Title = "Speed Hack",
    Default = false,
    Callback = function(v) Utils.S.spdEn = v end
})
tPlayer:AddSlider({
    Title = "Velocidad", Min = 16, Max = 300, Default = 100,
    Callback = function(v) Utils.S.spdVal = v end
})
tPlayer:AddToggle({
    Title = "Noclip",
    Default = false,
    Callback = function(v) Utils.S.ncEn = v end
})
tPlayer:AddToggle({
    Title = "FOV Personalizado",
    Default = false,
    Callback = function(v) Utils.S.fovEn = v end
})
tPlayer:AddSlider({
    Title = "Valor FOV", Min = 30, Max = 120, Default = 70,
    Callback = function(v) Utils.S.fovVal = v end
})

-- === SETTINGS ===
tSettings:AddSlider({
    Title    = "Tamaño del Menú",
    Min      = 540, 
    Max      = 900, 
    Default  = 580,
    Callback = function(v)
        pcall(function()
            Win:SetSize(v, math.floor(v * 0.53))
        end)
    end,
})
