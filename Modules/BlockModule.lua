local module = {}

local TextModule = require'Modules/CustomTextModule'

local unlockedTillBlock = 1

local ScreenWidth = love.graphics.getWidth()
local ScreenHeight = love.graphics.getHeight()

local orderedBlocks = {
    [1] = {love.graphics.newImage("Assets/Sprites/Blocks/Sand.png"), "Sand"},
    [2] = {love.graphics.newImage("Assets/Sprites/Blocks/Wood.png"), "Wood"},
}

function module:DrawBlocks(Background_Image, Button, ButtonText)
    ScreenWidth = love.graphics.getWidth()
    ScreenHeight = love.graphics.getHeight()
    
    for i = 1, unlockedTillBlock + 1 do
        if i <= 8 and orderedBlocks[i] then
            if i <= unlockedTillBlock then
                love.graphics.print(tostring(ScreenWidth) .. " - " .. tostring(ScreenHeight), 0 ,30)
                love.graphics.draw(orderedBlocks[i][1], ScreenWidth / 2 - Background_Image:getWidth() * 4 / 2 + Background_Image:getWidth() * 4 * (20*i) / 100, ScreenHeight / 2 - Background_Image:getHeight() / 2 + Background_Image:getHeight() * 20 / 100, 0, 1*4, 1*4, ImageModule:ReturnImageOriginX(orderedBlocks[i][1]), ImageModule:ReturnImageOriginY(orderedBlocks[i][1]))
            elseif unlockedTillBlock + 1 == i then
                ButtonText = TextModule:SetObjectNewText(ButtonText, "Buy " .. orderedBlocks[i][2])
                
                Button.Position.X = ScreenWidth / 2 - Background_Image:getWidth() * 4 / 2 + Background_Image:getWidth() * 4 * (20*i) / 100
                Button.Position.Y = ScreenHeight / 2 - Background_Image:getHeight() / 2 + Background_Image:getHeight() * 20 / 100

                ButtonText.Position.X = Button.Position.X
                ButtonText.Position.Y = Button.Position.Y

                love.graphics.draw(Button.Object, Button.Position.X, Button.Position.Y, Button.Orientation, Button.Scale.X, Button.Scale.Y, Button.Origin.X, Button.Origin.Y)
                love.graphics.draw(ButtonText.Object, ButtonText.Position.X, ButtonText.Position.Y, ButtonText.Orientation, ButtonText.Scale.X, ButtonText.Scale.Y, ButtonText.Origin.X, ButtonText.Origin.Y)
            end
        end
    end
end

return module