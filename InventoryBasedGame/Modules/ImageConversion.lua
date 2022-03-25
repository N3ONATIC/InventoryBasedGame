image = {}

    function image:GetImageCenter(ImageArgument)
        if ImageArgument == nil then
            return nil
        end
    end

    function image:ReturnImageOriginX(ImageArgument)
        if ImageArgument == nil then return nil end

        return ImageArgument:getWidth() / 2
    end

    function image:ReturnImageOriginY(ImageArgument)
        if ImageArgument == nil then return nil end
        
        return ImageArgument:getHeight() / 2
    end

return image