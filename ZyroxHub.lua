

-- Utils temporal para que cargue la UI sin necesitar Functions.lua todaví

-- Cargar la librería (si está local en el entorno o vía loadstring)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeVoult/CodeVoult1.lib/refs/heads/main/Zyroxlib.lua?v="))()

local Window = Library:CreateWindow('Zyrox Hub VIP <font color="#FFD700">v1.2</font>')

local CombatTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visuals")

local SilentSec = CombatTab:CreateSection("Silent Aim")

SilentSec:AddToggle("Activar Silent Aim", false, function(Value)
    print("Silent Aim:", Value)
end)

SilentSec:AddDropdown("Punto Objetivo", {"Cabeza", "Torso", "Pies"}, 1, function(Option)
    print("Objetivo seleccionado:", Option)
end)

SilentSec:AddSlider("Radio FOV", 30, 800, 120, function(Value)
    print("FOV:", Value)
end)

local EspSec = VisualTab:CreateSection("Opciones ESP")

EspSec:AddColorPicker("Color de Resaltado", Color3.fromRGB(0, 166, 255), function(Color)
    print("Nuevo color:", Color)
end)
