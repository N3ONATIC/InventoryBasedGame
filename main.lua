local SceneManager = require('Modules/SceneManagerModule')
local SceneForChange = nil

function love.load()
    --// Set First Scene
    SceneManager:setScene('InventoryScene')

    SceneManager:getScene():load()
end

function love.draw()
    SceneManager:getScene():draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    SceneManager:getScene():keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x,y,buttonPressed)
    SceneManager:getScene():mousepressed(x,y,buttonPressed)
end

function love.mousereleased(key)
    SceneManager:getScene():mousereleased(key)
end

function love.update(dt)
    SceneManager:getScene():update()

    SceneForChange = SceneManager:getScene():RequestSceneChange()

    if SceneForChange ~= nil then
        SceneManager:setScene(SceneForChange)
        SceneForChange = nil
    end
    collectgarbage()
end