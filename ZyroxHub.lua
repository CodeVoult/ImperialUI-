local Library = loadstring(game:HttpGet("TU_LINK?v=" .. math.random(1,999999)))()

local Window = Library:CreateWindow('Zyrox Hub VIP <font color="#FFD700">v1.2</font>')

-- Tabs con iconos
local MainTab     = Window:CreateTab("Main", "rbxassetid://129659183898289")
local CombatTab   = Window:CreateTab("Combat", "rbxassetid://139144481094772")
local HitboxTab   = Window:CreateTab("Hitbox", "rbxassetid://92387641579827")
local VisualTab   = Window:CreateTab("Visual", "rbxassetid://128792349513965")
local FarmTab     = Window:CreateTab("Farm", "rbxassetid://139145941679098")
local AvatarTab   = Window:CreateTab("Avatar", "rbxassetid://109575005864749")
local AnimsTab    = Window:CreateTab("Animaciones", "rbxassetid://103266505441539")
local CameraTab   = Window:CreateTab("Camera", "rbxassetid://80826768886976")
local SettingsTab = Window:CreateTab("Settings", "rbxassetid://92718502822243")

-- Ejemplo de sección
local SilentSec = CombatTab:CreateSection("Silent Aim")

SilentSec:AddToggle("Activar Silent Aim", false, function(v)
    print("Silent Aim:", v)
end)

SilentSec:AddDropdown("Punto Objetivo", {"Cabeza", "Torso", "Pies"}, 1, function(opt)
    print(opt)
end)

SilentSec:AddSlider("Radio FOV", 30, 800, 120, function(v)
    print(v)
end)

local EspSec = VisualTab:CreateSection("Opciones ESP")
EspSec:AddColorPicker("Color de Resaltado", Color3.fromRGB(0, 166, 255), function(color)
    print(color)
end)
