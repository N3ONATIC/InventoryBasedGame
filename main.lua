function LoadGlobalModuleScripts()
    ImageModule = require'Modules/ImageConversion'
    ItemModule = require'Modules/CustomItemModule'
    TimerModule = require'Modules/WaitModule'
end

function Load_Game_Background()
    Background_Image = love.graphics.newImage("Assets/inventory_background.png")
end

function LoadGlobalVariables()
    ScreenWidth = love.graphics.getWidth()
    ScreenHeight = love.graphics.getHeight()

    Slot = love.graphics.newImage("Assets/inventory_slot.png")
    descriptionBackgroundImage = love.graphics.newImage("Assets/inventory_background.png")

    SlotSizeX = Slot:getWidth() * 2
    SlotSizeY = Slot:getHeight() * 2

    ButtonHeld = -1
    ItemOn = -1
    CurrentIndex = 0

    IsDescriptionShown = false
    IsAnimatingDescription = false
    ThreadsAreRunning = 0
    ObjectHeld = nil

    CurrentItemName = ""
    CurrentItemPrice = ""

    Slots = {}

    _G.PlayerInventory = {} -- Inventory Contains CustomItems
end

function LoadFonts()
    VCR24 = love.graphics.newFont("Assets/Fonts/VCR_OSD_MONO.ttf", 24)
    VCR22 = love.graphics.newFont("Assets/Fonts/VCR_OSD_MONO.ttf", 22)
end

function UpdateTexts()
    ItemNameDescription = love.graphics.newText(VCR24,  {{1,1,1}, CurrentItemName})
    ItemCostDescription = love.graphics.newText(VCR22,  {{238 / 255,231 / 255,23 / 255}, "Sell Price: " .. CurrentItemPrice})
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
    Load_Game_Background()
    LoadGlobalModuleScripts()
    LoadGlobalVariables()

    LoadFonts()

    for i = 1, 5 do
        for j = 1, 4 do
            local fullTable = {}
            fullTable[1] = love.graphics.newImage("Assets/inventory_slot.png")
            fullTable[2] = ScreenWidth / 1.975 - Background_Image:getWidth() + (100 * j)
            fullTable[3] = ScreenHeight / 2.6 - Background_Image:getHeight() / 2 + (100 * i)
            fullTable[4] = nil -- Is Hovered
            fullTable[5] = nil -- Is Item Added
            table.insert(Slots, #Slots+1,fullTable)
        end
    end

    MouseSpeed = 0
    LastMousePositionX = 0
    
    -- Mouse Icon ImageDatas
    MouseIcon1 = love.image.newImageData("Assets/Crosshair/crosshair1.png")
    MouseIcon2 = love.image.newImageData("Assets/Crosshair/crosshair2.png")


    -- Add An Item
    Potion = ItemModule:CreateItem("Red Potion")
    Slots[1][5] = Potion
    Potion = ItemModule:CreateItem("Blue Potion")
    Slots[2][5] = Potion
    Potion = ItemModule:CreateItem("Green Potion")
    Slots[3][5] = Potion
end

function PrintValues()
    love.graphics.print(tostring(MouseSpeed))
    love.graphics.print(tostring(ItemOn) .. " " .. tostring(IsDescriptionShown) .. " " ..  tostring(CurrentIndex), 0, 15)
    if Slots ~= nil and ItemOn ~= -1 and Slots[ItemOn] ~= nil and Slots[ItemOn][5] ~= nil then
        love.graphics.print(tostring(Slots[ItemOn][5].Name), 0, 30)
    end
end

function love.draw()
    -- Print Values For Test
    PrintValues()
    -- Draw Background
    love.graphics.setColor(255,255,255)
    love.graphics.draw(Background_Image, ScreenWidth / 2, ScreenHeight / 2, 0,1.8, 1.4, ImageModule:ReturnImageOriginX(Background_Image), ImageModule:ReturnImageOriginY(Background_Image))

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
        love.graphics.draw(descriptionBackgroundImage, love.mouse.getX() + 20, love.mouse.getY() + 100, 0, 1, CurrentIndex)

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
    --[[
    for i=1,20 do
        love.graphics.print(tostring(Slots[i][1]) .. " " .. Slots[i][2] .. " " .. Slots[i][3] .. " " .. tostring(Slots[i][4]), 0, (i-1)*15 .. " " .. Slots[i][5].Name)
    end
    ]]
    
    
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousereleased(key)
    ButtonHeld = -1
end

function love.mousepressed()
    for i=1,20 do
        if Slots[i][4] == true then
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
end



function love.update()
    UpdateTexts()

    --love.timer.sleep(1/69)
    local MouseX = love.mouse.getX()
    local MouseY = love.mouse.getY()


    MouseSpeed = MouseX - LastMousePositionX 

    if MouseSpeed > 20 then
        MouseSpeed = 20
    end

    LastMousePositionX = MouseX

    for i=1, #Slots do
        if Slots[i][2] - SlotSizeX/2 <= MouseX and Slots[i][2] + SlotSizeX/2 >= MouseX and Slots[i][3] + SlotSizeY/2 >= MouseY and
        Slots[i][3] - SlotSizeY/2 <= MouseY then
            -- Mouse is Hovering Over A Slot
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