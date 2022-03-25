timeModule = {}

function timeModule:wait(seconds) -- Requires to be in thread
    local currentMilisPassed = 0
    while seconds > currentMilisPassed do
        currentMilisPassed = currentMilisPassed + love.timer.getDelta()
    end
end

return timeModule