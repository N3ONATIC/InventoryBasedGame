local _text = {}

function _text:CreateText(font, colorRGB, text, PositionX, PositionY, SizeX, SizeY, Rotation) -- Button Centered
    local texttable = {}

    texttable.Object = love.graphics.newText(font, {colorRGB, text})
    texttable.Text = text
    
    texttable.Font = font
    texttable.Color = colorRGB

    texttable.Position = {}
    
    texttable.Position.X = PositionX
    texttable.Position.Y = PositionY

    texttable.Orientation = Rotation -- Degrees
    
    texttable.Scale = {}

    texttable.Scale.X = SizeX
    texttable.Scale.Y = SizeY

    texttable.Size = {}

    texttable.Size.X = texttable.Object:getWidth()
    texttable.Size.Y = texttable.Object:getHeight()

    texttable.Origin = {}
    texttable.Origin.X = texttable.Size.X / 2
    texttable.Origin.Y = texttable.Size.Y / 2

    texttable.IsHovered = false
    
    return texttable
end

function _text:SetTextRotation(Object, RotationDegree)
    if not Object then return end
    
    Object.Orientation = RotationDegree
end

function _text:SetTextScale(Object, X, Y)
    Object.Size.X = X
    Object.Size.Y = Y
end

function _text:SetObjectNewText(Object, NewText)
    Object.Object = love.graphics.newText(Object.Font, {Object.Color, NewText})
    Object.Text = NewText

    Object.Size.X = Object.Object:getWidth()
    Object.Size.Y = Object.Object:getHeight()

    Object.Origin.X = Object.Size.X / 2;
    Object.Origin.Y = Object.Size.Y / 2;

    return Object
end

return _text