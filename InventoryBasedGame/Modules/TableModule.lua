local table = {}

function table.insert(table1, index, value)
    table1[index] = value

    return table1
end

function table.add(table1, value)
    table1[#table1+1] = value

    return table1
end

function table.remove(table1, index)
    if table1[index] ~= nil then
        table1[index] = nil
    end

    return table1
end

function table.find(table1, object)
    for i,v in pairs(table1) do
        if object == v then 
            return i
        end
    end

    return -1
end

return table