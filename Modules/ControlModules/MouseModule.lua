local module = {}

local MousePos = {}

function module:Update()
    MousePos.X = love.mouse.getX()
    MousePos.Y = love.mouse.getY()
end

function module:SetCursorVisible(IsVisible)
    love.mouse.setVisible(IsVisible)
end

function module:IsMouseOverObject(Object)
    if not Object then return end
end

function module:getX()
    return MousePos.X
end

function module:getY()
    return MousePos.Y
end

return module