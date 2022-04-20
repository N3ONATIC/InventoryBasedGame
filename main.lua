function LoadGlobalModuleScripts()
    ImageModule = require'Modules/ImageConversion'
    ItemModule = require'Modules/CustomItemModule'
    TimerModule = require'Modules/WaitModule'
    ButtonModule = require'Modules/CustomButtonModule'
    TextModule = require'Modules/CustomTextModule'
    Color = require'Modules/ColorModule'
end

function LoadGlobalVariables()
    ScreenWidth = love.graphics.getWidth()
    ScreenHeight = love.graphics.getHeight()

    Slot = love.graphics.newImage("Assets/Sprites/inventory_slot.png")
    DescriptionBackgroundImage = love.graphics.newImage("Assets/Sprites/inventory_background.png")
    Button = love.graphics.newImage("Assets/Sprites/side_button.png")
    Background_Image = love.graphics.newImage("Assets/Sprites/inventory_background.png")

    PlayerBalance = 0

    SlotSizeX = Slot:getWidth() * 2
    SlotSizeY = Slot:getHeight() * 2

    -- Slots
    ButtonHeld = -1
    ItemOn = -1
    CurrentIndex = 0

    -- Buttons
    ButtonOn = -1
    IsButtonHeld = -1

    IsDescriptionShown = false
    IsAnimatingDescription = false
    ObjectHeld = nil

    CurrentItemName = ""
    CurrentItemPrice = ""



    Texts = {}
    Buttons = {}
    Slots = {}

    _G.PlayerInventory = {} -- Inventory Contains CustomItems
end

function LoadTexts()
    PlayerBalanceText = love.graphics.newText(VCR24,  {{30 / 255,1 / 255, 30 / 255}, "Money: " .. PlayerBalance})
    ItemNameDescription = love.graphics.newText(VCR24,  {{1,1,1}, CurrentItemName})
    ItemCostDescription = love.graphics.newText(VCR22,  {{238 / 255,231 / 255,23 / 255}, "Sell Price: " .. CurrentItemPrice})
end

function LoadFiles()
    DocumentsDir = love.filesystem.getUserDirectory() .. "Documents"
    love.filesystem.setIdentity(DocumentsDir)
    if love.filesystem.getInfo(DocumentsDir .. "\\" .. 'InventoryGame') ~= nil then
        success = love.filesystem.createDirectory('InventoryGame')
    end
end

function LoadFonts()
    VCR24 = love.graphics.newFont("Assets/Fonts/VCR_OSD_MONO.ttf", 24)
    VCR22 = love.graphics.newFont("Assets/Fonts/VCR_OSD_MONO.ttf", 22)
end

function LoadSounds()
    S_Hover = love.audio.newSource("Assets/Sounds/hardclick1.wav", "static")
    S_Click = love.audio.newSource("Assets/Sounds/hardclick2.wav", "static")
    S_Sell = love.audio.newSource("Assets/Sounds/itemsellcoinssound.wav", "static")

    S_Hover:setVolume(0.2)
    S_Click:setVolume(0.5)
    S_Sell:setVolume(0.5)
end

function UpdateTexts()
    PlayerBalanceText:set({{ 238 / 255,231 / 255,23 / 255}, "Balance: " .. PlayerBalance .. "$"})
    ItemNameDescription:set({{1,1,1}, CurrentItemName})
    ItemCostDescription:set( {{238 / 255,231 / 255,23 / 255}, "Sell Price: " .. CurrentItemPrice})
end

function RunAnimation()
    if(CurrentIndex < 0.4) then
        CurrentIndex = CurrentIndex + (1 / love.timer.getFPS())
    else
        IsDescriptionShown = true
        CurrentIndex = 0.4
    end
end

function love.load()
    love.window.setFullscreen(true)
    LoadFonts()
    LoadSounds()
    LoadFiles()
    LoadGlobalModuleScripts()
    LoadGlobalVariables()
    LoadTexts()


    for i = 1, 5 do
        for j = 1, 4 do
            local fullTable = {}
            fullTable[1] = love.graphics.newImage("Assets/Sprites/inventory_slot.png")
            fullTable[2] = ScreenWidth / 1.975 - Background_Image:getWidth() + (Background_Image:getWidth() / 2.65 * j)
            fullTable[3] = ScreenHeight / 2.6 - Background_Image:getHeight() / 2.5 + (Background_Image:getWidth() / 2.5 * i)
            fullTable[4] = nil -- Is Hovered
            fullTable[5] = nil -- Is Item Added
            table.insert(Slots, #Slots+1,fullTable)
        end
    end

    MouseSpeed = 0
    LastMousePositionX = 0

    -- Add An Item
    Potion = ItemModule:CreateItem("Red Potion")
    Slots[1][5] = Potion
    Potion = ItemModule:CreateItem("Blue Potion")
    Slots[2][5] = Potion
    Potion = ItemModule:CreateItem("Green Potion")
    Slots[3][5] = Potion

    -- Add Buttons

    Buttons = {}
    Buttons[1] = ButtonModule:CreateButton(Button, ScreenWidth / 1.44, ScreenHeight / 1.5, 0.65, 0.4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button), 1)
    Buttons[2] = ButtonModule:CreateButton(Button, ScreenWidth / 1.44, ScreenHeight / 1.365, 0.65, 0.4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button), 2)
    -- Add Texts
    Texts[1] = TextModule:CreateText(VCR24, Color.YELLOW ,"Foraging", Buttons[1].Position.X, Buttons[1].Position.Y, 1, 1, 0)
    Texts[2] = TextModule:CreateText(VCR24, Color.YELLOW ,"Brewing", Buttons[2].Position.X, Buttons[2].Position.Y, 1, 1, 0)
end

function PrintValues()
    love.graphics.print(ButtonOn .. " : " .. IsButtonHeld)
    local j = 0
    for i,btn in pairs(Buttons) do
        j = i
        love.graphics.print("Button: " .. i .. " Left:" .. btn.Position.X - (btn.Size.X / 2) .. " Right: " .. btn.Position.X + (btn.Size.X / 2) .. " Top: " .. btn.Position.Y - (btn.Size.Y / 2) .. " Bottom: " .. btn.Position.Y + (btn.Size.Y / 2) , 0, 15 * i)
    end
    love.graphics.print(MouseX .. " : " .. MouseY, 0, (j+1) * 15)
end

function love.draw()
    -- Print Values For Test
    PrintValues()

    -- Draw Background
    love.graphics.setColor(255,255,255, 1)
    love.graphics.draw(Background_Image, ScreenWidth / 2, ScreenHeight / 2, 0,1.8, 1.4, ImageModule:ReturnImageOriginX(Background_Image), ImageModule:ReturnImageOriginY(Background_Image))

    -- Draw Buttons
    for i,v in pairs(Buttons) do
        if ButtonOn == i then
            love.graphics.setColor(255,255,255,0.8)
        else
            love.graphics.setColor(255,255,255,1)
        end
        love.graphics.draw(v.Object, v.Position.X, v.Position.Y, v.Orientation, v.Scale.X, v.Scale.Y, v.Origin.X, v.Origin.Y)
    end

    love.graphics.setColor(255,255,255,1)

    -- Draw Text
    love.graphics.draw(PlayerBalanceText, ScreenWidth / 2 - (Background_Image:getWidth()) + 35, ScreenHeight / 2 - (Background_Image:getHeight() / 1.5), 0, 1, 1)
    for _,v in pairs(Texts) do
        love.graphics.draw(v.Object, v.Position.X, v.Position.Y, v.Orientation, v.Scale.X, v.Scale.Y, v.Origin.X, v.Origin.Y)
    end

    -- Draw Slots
    for i=1,20 do
        if Slots[i][4] == true and ButtonHeld == -1 then
            love.graphics.setColor(255,255,255,0.85)
        else
            love.graphics.setColor(255,255,255, 1)
        end

        local OriginX = ImageModule:ReturnImageOriginX(Slots[i][1])
        local OriginY = ImageModule:ReturnImageOriginY(Slots[i][1])

        love.graphics.draw(Slots[i][1], Slots[i][2] , Slots[i][3], 0, 2, 2, OriginX, OriginY)

        -- Draw Items In Slots
        if (Slots[i][5] ~= nil) then
            local ItemOriginX = ImageModule:ReturnImageOriginX(Slots[i][5].Image)
            local ItemOriginY = ImageModule:ReturnImageOriginY(Slots[i][5].Image)
            love.graphics.draw(Slots[i][5].Image, Slots[i][2], Slots[i][3], 0, 1.2, 1.2, ItemOriginX, ItemOriginY)
        end
    end

    if ObjectHeld then
        local ItemOriginX = ImageModule:ReturnImageOriginX(ObjectHeld.Image)
        local ItemOriginY = ImageModule:ReturnImageOriginY(ObjectHeld.Image)
        love.graphics.draw(ObjectHeld.Image, love.mouse.getX(), love.mouse.getY(), math.rad(MouseSpeed * 2.5), 1.2, 1.2, ItemOriginX, ItemOriginY)
    end

    if ObjectHeld then
        love.mouse.setVisible(false)
    else
        love.mouse.setVisible(true)
    end

    if ItemOn ~= -1 then
        love.graphics.draw(DescriptionBackgroundImage, love.mouse.getX() + 20, love.mouse.getY() + 100, 0, 1, CurrentIndex)

        if IsDescriptionShown == false then
            RunAnimation()
        else
            pcall(function ()
                CurrentItemPrice = Slots[ItemOn][5].SellPrice
                CurrentItemName = Slots[ItemOn][5].Name
                love.graphics.draw(ItemNameDescription, love.mouse.getX() + 27.51, love.mouse.getY() + 110, 0, 1, 1)
                love.graphics.draw(ItemCostDescription, love.mouse.getX() + 30, love.mouse.getY() + 150, 0, 1, 1)
            end)
        end

    else
        if IsDescriptionShown == true then
            IsDescriptionShown = false
        end
        CurrentIndex = 0
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x,y,buttonPressed)
    if buttonPressed == 1 then
        for i=1,20 do
            if Slots[i][4] == true then
                (S_Click:clone()):play()

                if ObjectHeld == nil then
                    if Slots[i][5] ~= nil then
                        ObjectHeld = Slots[i][5]
                        Slots[i][5] = nil
                    end
                else
                    if Slots[i][5] == nil then
                        Slots[i][5] = ObjectHeld
                        ObjectHeld = nil
                    else
                        local temp = Slots[i][5]
                        Slots[i][5] = ObjectHeld
                        ObjectHeld = temp

                        temp = nil
                    end
                end

                ButtonHeld = i
            end
        end
    elseif buttonPressed == 2 then
        for i=1,20 do
            if Slots[i][4] == true then
                (S_Click:clone()):play()

                if Slots[i][5] ~= nil then
                    (S_Sell:clone()):play()

                    PlayerBalance = PlayerBalance + Slots[i][5].SellPrice
                    Slots[i][5] = nil
                end

                ButtonHeld = i
            end
        end
    end
    if ButtonOn ~= -1 then
        (S_Click:clone()):play()
        IsButtonHeld = buttonPressed
    end
end

function love.mousereleased(key)
    ButtonHeld = -1
    IsButtonHeld = -1
end

local function doButtonTextAnimation(Button, dt, isFrontWards)
    if not Button then return end
    if not dt then return end

    local text = Texts[Button.Text]
    if not text then return end

    if text.Orientation < 0 then
        text.Orientation = 0
    elseif text.Orientation <= 0.1 then
        if isFrontWards then
            if text.Orientation ~= 0.1 then
                text.Orientation = dt + text.Orientation
            end
        else
            if text.Orientation ~= 0 then
                text.Orientation = text.Orientation - dt
            end
        end
    else
        text.Orientation = 0.1
    end
end

local function slotUpdate(MouseX, MouseY)
    for i=1, #Slots do
        if Slots[i][2] - SlotSizeX/2 <= MouseX and Slots[i][2] + SlotSizeX/2 >= MouseX and Slots[i][3] + SlotSizeY/2 >= MouseY and
        Slots[i][3] - SlotSizeY/2 <= MouseY then
            -- Mouse is Hovering Over A Slot
            if Slots[i][4] == false then
                S_Hover:play()
            end
            Slots[i][4] = true
            if Slots[i][5] ~= nil then
                ItemOn = i
            end
            break
        else
            Slots[i][4] = false
            ItemOn = -1
        end
    end
end

local function buttonUpdate(MouseX, MouseY)
    for i,btn in pairs(Buttons) do
        if btn.Position.X - (btn.Size.X / 2) <= MouseX and btn.Position.X + (btn.Size.X / 2) >= MouseX and
        btn.Position.Y - (btn.Size.Y / 2) <= MouseY and btn.Position.Y + (btn.Size.Y / 2) >= MouseY then
            ButtonOn = i
            return
        end
    end
    ButtonOn = -1
end

local lastButton = -1

function love.update(dt)
    UpdateTexts()

    MouseX = love.mouse.getX()
    MouseY = love.mouse.getY()


    MouseSpeed = MouseX - LastMousePositionX

    if MouseSpeed > 20 then
        MouseSpeed = 20
    end

    LastMousePositionX = MouseX

    if Button ~= -1 and lastButton ~= ButtonOn then
        lastButton = ButtonOn
    end

    buttonUpdate(MouseX, MouseY)
    if ButtonOn ~= -1 then
        doButtonTextAnimation(Buttons[ButtonOn], dt, true)
    else
        for i=1, #Buttons do
            doButtonTextAnimation(Buttons[i], dt, false)
        end
    end
    
    slotUpdate(MouseX, MouseY)

    TimerModule:wait(1)
    collectgarbage()
end