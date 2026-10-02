-- Semantic palettes: every window receives its own mutable copy.
local Themes = {}
local rgb = Color3.fromRGB
local function palette(bg, panel, row, accent, text, muted, light)
    return {
        bg = rgb(bg[1], bg[2], bg[3]),
        panel = rgb(panel[1], panel[2], panel[3]),
        panel2 = rgb(row[1], row[2], row[3]),
        acc = rgb(accent[1], accent[2], accent[3]),
        border = light and rgb(211, 217, 230) or rgb(48, 55, 72),
        text = rgb(text[1], text[2], text[3]),
        muted = rgb(muted[1], muted[2], muted[3]),
        onAccent = rgb(255, 255, 255),
        red = light and rgb(195, 42, 64) or rgb(255, 107, 125),
        green = light and rgb(20, 132, 86) or rgb(71, 211, 151),
        sep = light and rgb(226, 230, 239) or rgb(38, 44, 59),
        switchOff = light and rgb(199, 207, 220) or rgb(52, 59, 76),
        bgTrans = 0, tabSize = 200,
    }
end

Themes.Palettes = {
    Midnight = palette({17, 20, 29}, {22, 26, 37}, {29, 34, 47}, {92, 113, 242}, {238, 241, 250}, {149, 160, 183}),
    Ocean = palette({12, 25, 35}, {16, 33, 44}, {22, 43, 56}, {12, 150, 200}, {232, 246, 253}, {137, 171, 188}),
    Amethyst = palette({25, 18, 35}, {34, 25, 46}, {44, 33, 58}, {151, 90, 224}, {247, 237, 255}, {181, 155, 204}),
    Forest = palette({15, 25, 23}, {21, 34, 30}, {28, 44, 39}, {27, 155, 106}, {234, 247, 240}, {146, 180, 162}),
    Rose = palette({30, 20, 26}, {40, 27, 35}, {53, 35, 45}, {204, 77, 122}, {255, 238, 245}, {192, 152, 171}),
    Light = palette({242, 244, 249}, {255, 255, 255}, {235, 239, 247}, {67, 87, 211}, {28, 34, 50}, {94, 106, 130}, true),
}
Themes.Names = {"Midnight", "Ocean", "Amethyst", "Forest", "Rose", "Light"}

function Themes.Get(name)
    local source = Themes.Palettes[name]
    assert(source, "ImperialUI: unknown theme '" .. tostring(name) .. "'")
    local result = {}
    for key, value in pairs(source) do result[key] = value end
    return result
end

return Themes