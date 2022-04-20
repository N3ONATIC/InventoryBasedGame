local _button = {}

function _button:CreateButton(Button, PositionX, PositionY, SizeX, SizeY, Rotation, OriginX, OriginY, TextIndex) -- Button Centered

    local buttontable = {}

    buttontable.Object = Button

    buttontable.Position = {}
    buttontable.Orientation = Rotation -- Degrees

    buttontable.Position.X = PositionX
    buttontable.Position.Y = PositionY

    buttontable.Scale = {}

    buttontable.Scale.X = SizeX
    buttontable.Scale.Y = SizeY

    buttontable.Size = {}

    buttontable.Size.X = buttontable.Object:getWidth() * buttontable.Scale.X
    buttontable.Size.Y = buttontable.Object:getHeight() * buttontable.Scale.Y


    buttontable.Origin = {}
    buttontable.Origin.X = OriginX
    buttontable.Origin.Y = OriginY

    buttontable.Text = TextIndex

    return buttontable
end

return _button