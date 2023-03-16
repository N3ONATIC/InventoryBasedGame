InventoryScene = {}

local SceneRequest = nil

function InventoryScene:RequestSceneChange()
    if SceneRequest then
        return SceneRequest
    else
        return nil
    end
end

function LoadGlobalModuleScripts()
    ImageModule = require'Modules/ImageConversion'
    ItemModule = require'Modules/CustomItemModule'
    TimerModule = require'Modules/WaitModule'
    ButtonModule = require'Modules/CustomButtonModule'
    TextModule = require'Modules/CustomTextModule'
    Color = require'Modules/ColorModule'
    FontModule = require'Modules/FontModule'
    InventoryModule = require'Modules/InventoryModule'
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
    IsButtonHeld = false
    ClickableButtonOn = nil

    IsDescriptionShown = false
    IsAnimatingDescription = false
    ObjectHeld = nil

    CurrentItemName = ""
    CurrentItemPrice = ""

    Texts = {}
    Buttons = {}

    _G.PlayerInventory = {} -- Inventory Contains CustomItems
end

function LoadTexts()
---@diagnostic disable-next-line: param-type-mismatch
    PlayerBalanceText = love.graphics.newText(FontModule:getFont("VCR22"),  {{30 / 255,1 / 255, 30 / 255}, "Money: " .. PlayerBalance})
---@diagnostic disable-next-line: param-type-mismatch
    ItemNameDescription = love.graphics.newText(FontModule:getFont("VCR24"),  {{1,1,1}, CurrentItemName})
---@diagnostic disable-next-line: param-type-mismatch
    ItemCostDescription = love.graphics.newText(FontModule:getFont("VCR22"),  {{238 / 255,231 / 255,23 / 255}, "Sell Price: " .. CurrentItemPrice})
end

function LoadFiles()
    DocumentsDir = love.filesystem.getUserDirectory() .. "Documents"
    love.filesystem.setIdentity(DocumentsDir)
    if love.filesystem.getInfo(DocumentsDir .. "\\" .. 'InventoryGame') ~= nil then
        success = love.filesystem.createDirectory('InventoryGame')
    end
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

function InventoryScene:load()
    love.window.setFullscreen(true)
    LoadSounds()
    LoadFiles()
    LoadGlobalModuleScripts()
    LoadGlobalVariables()
    LoadTexts()

    InventoryModule:LoadFirstTime()

    MouseSpeed = 0
    LastMousePositionX = 0

    -- Add An Item

    InventoryModule:AddItem(ItemModule:CreateItem("Red Potion"))
    InventoryModule:AddItem(ItemModule:CreateItem("Blue Potion"))
    InventoryModule:AddItem(ItemModule:CreateItem("Green Potion"))
    -- Add Buttons

    Buttons = {}
    Buttons[1] = ButtonModule:CreateButton(Button, ScreenWidth / 2 + Background_Image:getWidth() * 1.8 / 1.7, ScreenHeight * 45 / 100, 0.65, 0.4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button))
    Buttons[2] = ButtonModule:CreateButton(Button, ScreenWidth / 2 + Background_Image:getWidth() * 1.8 / 1.7, ScreenHeight * 50 / 100, 0.65, 0.4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button))
    Buttons[3] = ButtonModule:CreateButton(Button, ScreenWidth / 2 + Background_Image:getWidth() * 1.8 / 1.7, ScreenHeight * 55 / 100, .65, .4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button))
    Buttons[4] = ButtonModule:CreateButton(Button, ScreenWidth / 2 + Background_Image:getWidth() * 1.8 / 1.7, ScreenHeight * 60 / 100, .65, .4, 0, ImageModule:ReturnImageOriginX(Button), ImageModule:ReturnImageOriginY(Button))
    -- Add Texts
    Texts[1] = TextModule:CreateText(FontModule:getFont("VCR24"), Color.YELLOW, "Forging", Buttons[1].Position.X, Buttons[1].Position.Y, 1, 1, 0)
    Texts[2] = TextModule:CreateText(FontModule:getFont("VCR24"), Color.YELLOW, "Brewing", Buttons[2].Position.X, Buttons[2].Position.Y, 1, 1, 0)
    Texts[3] = TextModule:CreateText(FontModule:getFont("VCR24"), Color.YELLOW, "Mining", Buttons[3].Position.X, Buttons[3].Position.Y, 1, 1, 0)
    Texts[4] = TextModule:CreateText(FontModule:getFont("VCR24"), Color.YELLOW, "Smelting", Buttons[4].Position.X, Buttons[4].Position.Y, 1, 1, 0)
end

function PrintValues()
    love.graphics.print(ButtonOn .. " : " .. tostring(IsButtonHeld))
    local j = 0
    for i,btn in pairs(Buttons) do
        j = i
        love.graphics.print("Button: " .. i .. " Left:" .. btn.Position.X - (btn.Size.X / 2) .. " Right: " .. btn.Position.X + (btn.Size.X / 2) .. " Top: " .. btn.Position.Y - (btn.Size.Y / 2) .. " Bottom: " .. btn.Position.Y + (btn.Size.Y / 2) , 0, 15 * i)
    end
    love.graphics.print(MouseX .. " : " .. MouseY, 0, (j+1) * 15)
    love.graphics.print(tostring(Background_Image:getWidth()), 0, (j+2) * 15)
end

function InventoryScene:draw()
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
    
    InventoryModule:DrawSlots()

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
                SL = InventoryModule:GetSlotByIndex(ItemOn)
                CurrentItemPrice = SL.Item.SellPrice
                CurrentItemName = SL.Item.Name
                love.graphics.draw(ItemNameDescription, love.mouse.getX() + 27.51, love.mouse.getY() + 110, 0, 1, 1)
                love.graphics.draw(ItemCostDescription, love.mouse.getX() + 30, love.mouse.getY() + 150, 0, 1, 1)
            end)
        end
    else
        IsDescriptionShown = false
        CurrentIndex = 0
    end
end

function InventoryScene:keypressed(key, scancode, isrepeat)
    
end

function InventoryScene:mousepressed(x,y,buttonPressed)
    if buttonPressed == 1 then
        ButtonHeld = InventoryModule:CheckForAnyMouse1ButtonClick()
    elseif buttonPressed == 2 then
        --// Unfinished
        --// Last finishing onto implementing all slots in InventoryModule
        ButtonHeld = InventoryModule:CheckForAnyMouse2ButtonClick(S_Click,S_Sell)
    end
    if ButtonOn ~= -1 then
        (S_Click:clone()):play()
        IsButtonHeld = true
    end
end

function InventoryScene:mousereleased(key)
    ButtonHeld = -1
    IsButtonHeld = false
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

function InventoryScene:update(dt)
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
        if IsButtonHeld then
            if ButtonOn == 3 then
                SceneRequest = "MiningScene"
            end            
        end
    else
        for i=1, #Buttons do
            doButtonTextAnimation(Buttons[i], dt, false)
        end
    end
    
    ItemOn = InventoryModule:SlotUpdate()
end

return InventoryScene