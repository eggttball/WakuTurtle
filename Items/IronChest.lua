IronChest = setmetatable({}, {__index = Chest})
IronChest.__index = IronChest

function IronChest:new()
    local instance = Chest.new(self)
    setmetatable(instance, IronChest)
    return instance
end

function IronChest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function IronChest:getName()
    return "ironchest:iron_chest"
end

function IronChest:getRowSize()
    return 9
end

function IronChest:getColSize()
    return 6
end