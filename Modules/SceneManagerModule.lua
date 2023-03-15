manager = {}

local Scene = nil

local AllScenes = {
    ["InventoryScene"] = require'Modules/GameModules/InventoryScene',
    ["MiningScene"] = require'Modules/GameModules/MiningScene',
}

function manager:getScene()
    return Scene
end

function manager:setScene(newSceneName)
    Scene = AllScenes[newSceneName]
end

return manager