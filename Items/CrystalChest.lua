CrystalChest = setmetatable({}, {__index = Chest})
CrystalChest.__index = CrystalChest

function CrystalChest:new()
    local instance = Chest.new(self)
    setmetatable(instance, CrystalChest)
    return instance
end

function CrystalChest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function CrystalChest:getName()
    return "ironchest:crystal_chest"
end

function CrystalChest:getRowSize()
    return 12
end

function CrystalChest:getColSize()
    return 9
end