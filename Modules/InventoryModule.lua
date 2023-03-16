local module = {}

local MouseModule = require'Modules/ControlModules/MouseModule'

local Slots = {}

local HasLoaded = false

function module:LoadFirstTime()
    for i = 1, 5 do
        for j = 1, 4 do
            local fullTable = {}
            fullTable.Image = love.graphics.newImage("Assets/Sprites/inventory_slot.png")
            fullTable.Position = {}
            fullTable.Position.X = ScreenWidth / 1.975 - Background_Image:getWidth() + (Background_Image:getWidth() / 2.65 * j)
            fullTable.Position.Y = ScreenHeight / 2.6 - Background_Image:getHeight() / 2.5 + (Background_Image:getWidth() / 2.5 * i)
            fullTable.IsHovered = nil
            fullTable.Item = nil
            table.insert(Slots, #Slots+1,fullTable)
        end
    end
    HasLoaded = true
end

function module:AddItem(Item)
    for _,Slot in pairs(Slots) do
        if Slot.Item == nil then
            Slot.Item = Item
            return true
        end
    end
    return false
end

function module:DrawSlots()
    if not HasLoaded then return end
    for _,Slot in pairs(Slots) do
        if Slot.IsHovered == true and ButtonHeld == -1 then
            love.graphics.setColor(255,255,255,0.85)
        else
            love.graphics.setColor(255,255,255, 1)
        end

        local OriginX = ImageModule:ReturnImageOriginX(Slot.Image)
        local OriginY = ImageModule:ReturnImageOriginY(Slot.Image)

        love.graphics.draw(Slot.Image, Slot.Position.X , Slot.Position.Y, 0, 2, 2, OriginX, OriginY)

        -- Draw Items In Slots
        if (Slot.Item ~= nil) then
            local ItemOriginX = ImageModule:ReturnImageOriginX(Slot.Item.Image)
            local ItemOriginY = ImageModule:ReturnImageOriginY(Slot.Item.Image)
            love.graphics.draw(Slot.Item.Image, Slot.Position.X, Slot.Position.Y, 0, 1.2, 1.2, ItemOriginX, ItemOriginY)
        end
    end
end

function module:SlotUpdate()
    if not HasLoaded then return -1 end
    for i,Slot in pairs(Slots) do
        local suc, err = pcall(function ()
            if Slot.Position.X - Slot.Image.getWidth() / 2 <= MouseModule:getX() and 
                Slot.Position.X + Slot.Image.getWidth() / 2 >= MouseModule:getX() and 
                Slot.Position.Y + Slot.Image.getHeight() / 2 >= MouseModule:getY() and 
                Slot.Position.Y - Slot.Image.getHeight() / 2 <= MouseModule:getY() then
                -- Mouse is Hovering Over A Slot
                if Slot.IsHovered == false then
                    S_Hover:play()
                end
                Slots[i].IsHovered = true
                if Slot.Item ~= nil then
                    return i
                end
            else
                Slots[i].IsHovered = true
            end
            debug.(i)
        end)
        if not suc then
            
        end
    end
    return -1
end

function module:CheckForAnyMouse1ButtonClick()
    for i,Slot in pairs(Slots) do
        if Slot.IsHovered == true then
            (S_Click:clone()):play()

            if ObjectHeld == nil then
                if Slot.Item ~= nil then
                    ObjectHeld = Slot.Item
                    Slot.Item = nil
                end
            else
                if Slot.Item == nil then
                    Slot.Item = ObjectHeld
                    ObjectHeld = nil
                else
                    local temp = Slots.Item
                    Slots.Item = ObjectHeld
                    ObjectHeld = temp

                    temp = nil
                end
            end

            return i
        end
    end
    return -1
end

function module:CheckForAnyMouse2ButtonClick(S_Click, S_Sell)
    for i,Slot in pairs(Slots) do
        if Slot.IsHovered == true then
            (S_Click:clone()):play()
            if Slots.Item ~= nil then
                (S_Sell:clone()):play()
                PlayerBalance = PlayerBalance + Slot.Item.SellPrice
                Slots.Item = nil
            end
            return i
        end
    end
end

function module:GetSlotByIndex(Index)
    return Slots[Index]
end

return module