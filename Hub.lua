local LIBRARY_URL = "https://raw.githubusercontent.com/CodeVoult/ImperialUI-/refs/heads/main/src/Library.lua"
local requestOk, librarySource = pcall(function()
    return game:HttpGet(LIBRARY_URL .. "?v=" .. tostring(os.time()))
end)
assert(requestOk and type(librarySource) == "string" and #librarySource > 0,
    "[ImperialUI] No se pudo descargar src/Library.lua. Revisa la URL, el acceso a Internet y que los cambios estén en GitHub.")
local loadLibrary, compileError = loadstring(librarySource)
assert(loadLibrary, "[ImperialUI] No se pudo compilar la librería: " .. tostring(compileError))
local Library = loadLibrary()
assert(type(Library) == "table" and type(Library.CreateWindow) == "function",
    "[ImperialUI] La URL no devolvió una versión válida de src/Library.lua")

-- El título se mostrará sin HTML
local Window = Library:CreateWindow({Title = "Zyrox Hub VIP v1.4", Theme = "Midnight"})

-- Crear pestañas con iconos

-- ... etc.
-- ============================================================
--   TABS
-- ============================================================
local MainTab     = Window:CreateTab("Main", "home")
local CombatTab   = Window:CreateTab("Combat", "combat")
local HitboxTab   = Window:CreateTab("Hitbox", "hitbox")
local VisualTab   = Window:CreateTab("Visual", "eye")
local FarmTab     = Window:CreateTab("Farm", "leaf")
local AvatarTab   = Window:CreateTab("Avatar", "user")
local AnimsTab    = Window:CreateTab("Animaciones", "sparkles")
local CameraTab   = Window:CreateTab("Camera", "camera")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- ============================================================
--   COMBAT TAB
-- ============================================================
local SilentSec = CombatTab:CreateSection("Silent Aim")

SilentSec:AddToggle("Activar Silent Aim", false, function(v) end)

SilentSec:AddToggle("Solo con Armas", false, function(v) end)

SilentSec:AddToggle("Comprobar Paredes", false, function(v) end)

SilentSec:AddToggle("Ocultar Círculo de FOV", false, function(v) end)

SilentSec:AddDropdown("Punto Objetivo", {"Cabeza", "Torso", "Pies"}, 1, function(choice) end)

SilentSec:AddSlider("Radio de FOV", 30, 800, 120, function(v) end)

SilentSec:AddSlider("Disimulo / Smoothness", 10, 100, 50, function(v) end)

SilentSec:AddSlider("Fuerza Predicción", 0, 200, 100, function(v) end)

SilentSec:AddSlider("Rango de Distancia", 50, 1000, 500, function(v) end)

local AutoShootSec = CombatTab:CreateSection("Auto Shoot (En mantenimiento)")

AutoShootSec:AddToggle("Auto Shoot", false, function(v) end)

AutoShootSec:AddSlider("Rango de Disparo", 10, 1000, 250, function(v) end)

-- ============================================================
--   HITBOX TAB
-- ============================================================
local HitboxSec = HitboxTab:CreateSection("Hitbox Expander")

HitboxSec:AddToggle("Activar Hitbox", false, function(v) end)

HitboxSec:AddToggle("Ver Hitbox Visualmente", true, function(v) end)

HitboxSec:AddSlider("Tamaño de Hitbox", 2, 60, 10, function(v) end)

-- ============================================================
--   VISUAL TAB
-- ============================================================
local EspSec = VisualTab:CreateSection("Visualizadores ESP")

EspSec:AddToggle("Resaltado (Chasis Highlight)", false, function(v) end)

EspSec:AddToggle("Lineas", false, function(v) end)

EspSec:AddToggle("Cajas 2D (Boxes)", false, function(v) end)

EspSec:AddToggle("Esqueleto", false, function(v) end)

local ColorSec = VisualTab:CreateSection("Color del ESP")

ColorSec:AddColorPicker("Color de Resaltado", Color3.fromRGB(50, 255, 100), function(newColor) end)

-- ============================================================
--   FARM TAB
-- ============================================================
local FarmSec = FarmTab:CreateSection("Auto Farm Controller")

FarmSec:AddToggle("Habilitar Auto Farm", false, function(v) end)

-- ============================================================
--   AVATAR TAB
-- ============================================================
local AvatarSec = AvatarTab:CreateSection("Modificaciones Cosméticas")

AvatarSec:AddToggle("Headless Local", false, function(v) end)

AvatarSec:AddToggle("Korblox Pierna Izquierda", false, function(v) end)

-- ============================================================
--   ANIMACIONES TAB
-- ============================================================
local AnimsSec = AnimsTab:CreateSection("Animaciones By Zyrox")

-- ============================================================
--   CAMERA TAB
-- ============================================================
local FovSec = CameraTab:CreateSection("Field of View (FOV)")

FovSec:AddToggle("Habilitar Modificador FOV", false, function(v) end)

FovSec:AddSlider("Modificar FOV", 30, 120, 70, function(v) end)

local MoveSec = CameraTab:CreateSection("Desplazamiento")

MoveSec:AddToggle("Atravesar Paredes (Noclip)", false, function(v) end)

MoveSec:AddToggle("Aumentar Velocidad (Speed)", false, function(v) end)

MoveSec:AddSlider("Velocidad de Caminado", 16, 300, 200, function(v) end)

-- ============================================================
--   SETTINGS TAB
-- ============================================================
local SizeSec = SettingsTab:CreateSection("Dimensiones del Hub")

local ThemeSec = SettingsTab:CreateSection("Temas")
ThemeSec:AddDropdown("Apariencia", Window:GetThemes(), 1, function(themeName)
    Window:SetTheme(themeName)
end)

SizeSec:AddSlider("Ancho/Escala del Hub", 80, 150, 100, function(v)
    Window:SetScale(v / 100)
end)

local GhostSec = SettingsTab:CreateSection("Ajustes Visuales del Logo")

GhostSec:AddToggle("Modo Invisible (Esconder Logo)", false, function(v)
    Window:SetLogoVisible(not v)
end)

GhostSec:AddToggle("Bloquear Logo (Estatico)", false, function(v)
    Window:SetLogoLocked(v)
end)

local OptSec = SettingsTab:CreateSection("Optimizacion de Latencia")

OptSec:AddToggle("Optimizar FPS del Dispositivo", false, function(v) end)
