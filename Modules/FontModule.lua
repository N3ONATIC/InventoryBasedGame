local module = {}

local fonts = {
    ["VCR22"] = love.graphics.newFont("Assets/Fonts/VCR_OSD_MONO.ttf", 22),
    ["VCR24"] = love.graphics.newFont("Assets/Fonts/VCR_OSD_MONO.ttf", 24)
}

function module:getFont(FontName)
    return fonts[FontName] 
end

return module