res = {}

local UserResolution = -1

-- Game resolutions
local Resolutions = {
    [1] = {1920, 1080},
    [2] = {1280, 720}
}

function GetResolution(width, height)
    for i,v in pairs(Resolutions) do
        if v[1] >= width and v[2] >= height then
            UserResolution = i
        end
    end
end

function GetResolutions()
    return Resolutions:clone()
end

function SetResolution(resolutionIndex)
    if Resolutions[resolutionIndex] ~= nil then
        UserResolution = resolutionIndex
    end
end




return res