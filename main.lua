local InventoryScene = require'Modules/GameModules/InventoryScene'

function love.load()
    InventoryScene:load()
end

function love.draw()
    InventoryScene:draw()
end

function love.keypressed(key, scancode, isrepeat)
    InventoryScene:keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x,y,buttonPressed)
    InventoryScene:mousepressed(x,y,buttonPressed)
end

function love.mousereleased(key)
    InventoryScene:mousereleased(key)
end

function love.update(dt)
    InventoryScene:update()
    collectgarbage()
end