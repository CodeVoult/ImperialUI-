local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeVoult/ImperialUI-/refs/heads/main/src/Library.lua?v=" .. math.random(1,999999)))()


local Window = Library:CreateWindow('Zyrox Hub VIP <font color="#FFD700">v1.2</font>', WebhookURL)

-- ============================================================
--   TAB COMBAT
-- ============================================================
local CombatTab = Window:CreateTab("Combat")

-- ============================================================
--   COMBAT SECTION
-- ============================================================
local SilentSec = CombatTab:CreateSection("Silent Aim")

SilentSec:AddToggle("Activar Silent Aim", false, function(v)
    getgenv().SilentAim.Enabled = v
end)

SilentSec:AddDropdown("Punto Objetivo", {"Cabeza", "Torso", "Pies"}, 1, function(choice)
    if choice == "Cabeza" then
        getgenv().SilentAim.Part = "Head"
    elseif choice == "Torso" then
        getgenv().SilentAim.Part = "HumanoidRootPart"
    else
        getgenv().SilentAim.Part = "Legs"
    end
end)

SilentSec:AddSlider("Radio de FOV", 30, 800, 120, function(v)
    getgenv().SilentAim.FOV = v
end)

SilentSec:AddSlider("Disimulo / Smoothness", 10, 100, 50, function(v)
    getgenv().SilentAim.Smoothness = v
end)

SilentSec:AddSlider("Fuerza Predicción", 0, 200, 100, function(v)
    getgenv().SilentAim.Prediction = v
end)

SilentSec:AddSlider("Rango de Distancia", 50, 1000, 500, function(v)
    getgenv().SilentAim.DistMax = v
end)

local AutoShootSec = CombatTab:CreateSection("Auto Shoot (En mantenimiento)")

AutoShootSec:AddToggle("Auto Shoot", false, function(v)
    getgenv().S.autoShoot = v
end)

AutoShootSec:AddSlider("Rango de Disparo", 10, 1000, 250, function(v)
    getgenv().S.shootDist = v
end)
