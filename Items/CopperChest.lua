CopperChest = setmetatable({}, {__index = Chest})
CopperChest.__index = CopperChest

function CopperChest:new()
    local instance = Chest.new(self)
    setmetatable(instance, CopperChest)
    return instance
end

function CopperChest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function CopperChest:getName()
    return "ironchest:copper_chest"
end

function CopperChest:getRowSize()
    return 9
end

function CopperChest:getColSize()
    return 5
end