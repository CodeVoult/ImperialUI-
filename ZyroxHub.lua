-- 1. Cargar tu librería desde GitHub
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeVoult/CodeVoult1.lib/refs/heads/main/Zyroxlib.lua?nocache=" .. tick()))()

-- 2. Crear la ventana principal usando 'Library'
local Window = Library:CreateWindow({
   Name = "Zyrox Hub",
   LoadingTitle = "Cargando Interfaz...",
   LoadingSubtitle = "por Zyrox",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ZyroxConfig",
      FileName = "Configuracion"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", 
      RememberJoins = true
   },
   KeySystem = false,
})

-- 3. Crear pestaña
local Tab = Window:CreateTab("Principal", 4483362458)

-- 4. Controles
local Section = Tab:CreateSection("Funciones Principales")

local Button = Tab:CreateButton({
   Name = "Ejecutar Acción",
   Callback = function()
       print("¡Botón presionado!")
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Activar Función",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       print("Estado actual:", Value)
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Velocidad",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Puntos",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
       print("Valor del Slider:", Value)
   end,
})

-- Notificación usando 'Library'
Library:Notify({
   Title = "Script Cargado",
   Content = "Zyroxlib cargada correctamente.",
   Duration = 5,
   Image = 4483362458,
})
