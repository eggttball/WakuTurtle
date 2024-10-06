DiamondChest = setmetatable({}, {__index = Chest})
DiamondChest.__index = DiamondChest

function DiamondChest:new()
    local instance = Chest.new(self)
    setmetatable(instance, DiamondChest)
    return instance
end

function DiamondChest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function DiamondChest:getName()
    return "ironchest:diamond_chest"
end

function DiamondChest:getRowSize()
    return 12
end

function DiamondChest:getColSize()
    return 9
end