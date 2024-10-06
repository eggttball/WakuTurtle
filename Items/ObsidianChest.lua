ObsidianChest = setmetatable({}, {__index = Chest})
ObsidianChest.__index = ObsidianChest

function ObsidianChest:new()
    local instance = Chest.new(self)
    setmetatable(instance, ObsidianChest)
    return instance
end

function ObsidianChest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function ObsidianChest:getName()
    return "ironchest:obsidian_chest"
end

function ObsidianChest:getRowSize()
    return 12
end

function ObsidianChest:getColSize()
    return 9
end