res = {}

local UserResolution = -1

-- Game resolutions
local Resolutions = {
    [1] = {1920, 1080},
    [2] = {1280, 720}
}

function res:GetResolutionIndex(width, height)
    for i,v in pairs(Resolutions) do
        if v[1] >= width and v[2] >= height then
            UserResolution = i
        end
    end
end

function GetResolutions()
    return Resolutions:clone()
end

function res:SetResolution(resolutionIndex)
    if Resolutions[resolutionIndex] ~= nil then
        UserResolution = resolutionIndex
        love.window.setMode(Resolutions[resolutionIndex][1], Resolutions[resolutionIndex][2], {resizable=false,vsync=false})
    end
end




return res