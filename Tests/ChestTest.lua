local luaunit = require('luaunit')
package.path = package.path .. ";../?.lua"
require "Items/Chest"
require "Items/CopperChest"
require "Items/IronChest"
require "Items/GoldChest"
require "Items/DiamondChest"
require "Items/ObsidianChest"
require "Items/CrystalChest"

TestChest = {}


function TestChest:testChest()
    local chest = Chest:getInstance(Chest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 27)
    luaunit.assertEquals(chest:getRowSize(), 9)
    luaunit.assertEquals(chest:getColSize(), 3)
    luaunit.assertEquals(chest:getName(), "minecraft:chest")
end


function TestChest:testCopperChest()
    local chest = Chest:getInstance(CopperChest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 45)
    luaunit.assertEquals(chest:getRowSize(), 9)
    luaunit.assertEquals(chest:getColSize(), 5)
    luaunit.assertEquals(chest:getName(), "ironchest:copper_chest")
end


function TestChest:testIronChest()
    local chest = Chest:getInstance(IronChest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 54)
    luaunit.assertEquals(chest:getRowSize(), 9)
    luaunit.assertEquals(chest:getColSize(), 6)
    luaunit.assertEquals(chest:getName(), "ironchest:iron_chest")
end


function TestChest:testGoldChest()
    local chest = Chest:getInstance(GoldChest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 81)
    luaunit.assertEquals(chest:getRowSize(), 9)
    luaunit.assertEquals(chest:getColSize(), 9)
    luaunit.assertEquals(chest:getName(), "ironchest:gold_chest")
end


function TestChest:testDiamondChest()
    local chest = Chest:getInstance(DiamondChest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 108)
    luaunit.assertEquals(chest:getRowSize(), 12)
    luaunit.assertEquals(chest:getColSize(), 9)
    luaunit.assertEquals(chest:getName(), "ironchest:diamond_chest")
end


function TestChest:testObsidianChest()
    local chest = Chest:getInstance(ObsidianChest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 108)
    luaunit.assertEquals(chest:getRowSize(), 12)
    luaunit.assertEquals(chest:getColSize(), 9)
    luaunit.assertEquals(chest:getName(), "ironchest:obsidian_chest")
end


function TestChest:testCrystalChestSize()
    local chest = Chest:getInstance(CrystalChest:getName())
    luaunit.assertEquals(chest:getTotalSize(), 108)
    luaunit.assertEquals(chest:getRowSize(), 12)
    luaunit.assertEquals(chest:getColSize(), 9)
    luaunit.assertEquals(chest:getName(), "ironchest:crystal_chest")
end


os.exit(luaunit.LuaUnit.run())