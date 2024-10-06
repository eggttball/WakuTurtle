GoldChest = setmetatable({}, {__index = Chest})
GoldChest.__index = GoldChest

function GoldChest:new()
    local instance = Chest.new(self)
    setmetatable(instance, GoldChest)
    return instance
end

function GoldChest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function GoldChest:getName()
    return "ironchest:gold_chest"
end

function GoldChest:getRowSize()
    return 9
end

function GoldChest:getColSize()
    return 9
end