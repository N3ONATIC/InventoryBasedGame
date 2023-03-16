MiningScene = {}

local BlockModule = require'Modules/BlockModule'
local FontModule = require'Modules/FontModule'

local SceneRequest = nil

function MiningScene:RequestSceneChange()
    if SceneRequest then
        return SceneRequest
    end
end

function MiningScene:load()
    Background_Image = love.graphics.newImage("Assets/Sprites/inventory_background.png")
    ButtonImage = love.graphics.newImage("Assets/Sprites/side_button.png")

    Button = ButtonModule:CreateButton(ButtonImage, ScreenWidth / 2 + Background_Image:getWidth() * 1.8 / 1.7, ScreenHeight * 45 / 100, 0.65, 0.4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button))
    ButtonText = TextModule:CreateText(FontModule:getFont("VCR24"), Color.YELLOW, "Buy", Buttons[1].Position.X, Buttons[1].Position.Y, 1, 1, 0)
end

function MiningScene:draw()
    MouseX = love.mouse.getX()
    MouseY = love.mouse.getY()

    love.graphics.print(MouseX .. " : " .. MouseY, 0, 15)
    
    love.graphics.setColor(255,255,255, 1)
    love.graphics.draw(Background_Image, ScreenWidth / 2, ScreenHeight / 2, 0,4, 1.4, ImageModule:ReturnImageOriginX(Background_Image), ImageModule:ReturnImageOriginY(Background_Image))

    BlockModule:DrawBlocks(Background_Image, Button, ButtonText)
end

function MiningScene:keypressed()

end

function MiningScene:keyreleased()

end

function MiningScene:mousepressed()

end

function MiningScene:mousereleased()

end

function MiningScene:update()
    
end
return MiningScene