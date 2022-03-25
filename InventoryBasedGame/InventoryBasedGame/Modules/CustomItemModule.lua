customitem = {}

    -- Item Data
    local ItemsLocations = {
        ["Red Potion"] = "Assets/Items/red_pot.png",
        ["Blue Potion"] = "Assets/Items/blue_pot.png",
        ["Green Potion"] = "Assets/Items/green_pot.png",
    }

    local ItemSellPrice = {
        ["Red Potion"] = 115,
        ["Blue Potion"] = 150,
        ["Green Potion"] = 190,
    }

    local function GetItemImageByName(ItemName)
        if ItemsLocations[ItemName] ~= nil then
            return ItemsLocations[ItemName]
        else
            return nil
        end        
    end

    local function GetItemPrice(ItemName)
        if ItemSellPrice[ItemName] ~= nil then
            return ItemSellPrice[ItemName]
        else
            return nil
        end
    end

    function customitem:CreateItem(itemName)
        local item = {}
        item.Name = itemName
        item.Image = love.graphics.newImage(GetItemImageByName(itemName))
        item.SellPrice = GetItemPrice(itemName)
        return item
    end

    function customitem:GetItemImageByName(itemName)
        return GetItemImageByName(itemName)
    end

    function customitem:getPriceByName(itemName)
        return GetItemPrice(itemName)
    end

return customitem