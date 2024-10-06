require "Items/CopperChest"
require "Items/IronChest"
require "Items/GoldChest"
require "Items/DiamondChest"
require "Items/ObsidianChest"
require "Items/CrystalChest"

Chest = {}
Chest.__index = Chest

function Chest:new()
    local instance = setmetatable({}, self)
    instance.name = self:getName()
    return instance
end

function Chest:getName()
    return "minecraft:chest"
end

function Chest:getTotalSize()
    return self:getRowSize() * self:getColSize()
end

function Chest:getRowSize()
    return 9
end

function Chest:getColSize()
    return 3
end

function Chest:getInstance(name)
    if name == Chest:getName() then
        return Chest:new()
    elseif name == CopperChest:getName() then
        return CopperChest:new()
    elseif name == IronChest:getName() then
        return IronChest:new()
    elseif name == GoldChest:getName() then
        return GoldChest:new()
    elseif name == DiamondChest:getName() then
        return DiamondChest:new()
    elseif name == ObsidianChest:getName() then
        return ObsidianChest:new()
    elseif name == CrystalChest:getName() then
        return CrystalChest:new()
    else
        return Chest:new()
    end
end