local icons = {
    ["combat"] = "rbxassetid://1234567890",
    ["combate"] = "rbxassetid://1234567890",
    ["settings"] = "rbxassetid://1111111111",
    ["ajustes"] = "rbxassetid://1111111111",
}

-- Función para buscar el icono
local function getIcon(tabName)
    if not tabName then return "rbxassetid://6031094670" end -- Icono por defecto si el nombre viene vacío
    
    local key = string.lower(tabName)
    -- Busca en tu tabla; si no lo encuentra, usa el ID por defecto
    return icons[key] or "rbxassetid://6031094670" 
end

-- Ejemplo de cómo se usaría al crear una Tab:
function ZyroxLib:CreateTab(name)
    local tabIcon = getIcon(name)
    
    -- Aquí creas tu UI usando tabIcon como el ImageId
    print("Creando Tab:", name, "| Icono asignado:", tabIcon)
end
