local _button = {}

function _button:CreateButton(Button, PositionX, PositionY, SizeX, SizeY, Rotation, OriginX, OriginY) -- Button Centered

    local buttontable = {}

    buttontable.Button = Button

    buttontable.Position = {}
    buttontable.Orientation = Rotation -- Degrees

    buttontable.Position.X = PositionX
    buttontable.Position.Y = PositionY

    buttontable.Size = {}

    buttontable.Size.X = SizeX
    buttontable.Size.Y = SizeY

    buttontable.Origin = {}
    buttontable.Origin.X = OriginX
    buttontable.Origin.Y = OriginY

    return buttontable
end

function _button:IsMouseOnButton(MouseX, MouseY, Button)
    
end

return _button