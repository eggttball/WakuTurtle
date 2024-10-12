require "Base"
require "Items/Chest"

WakuTurtle = {
    _time_format = "%Y-%m-%d %H:%M:%S",
    _build_mode = BUILD_MODE.FILL,
    _repeat_mode_x = REPEAT_MODE.NO_REPEAT,
    _repeat_mode_y = REPEAT_MODE.NO_REPEAT,
    _start_x = 0,   -- Start Point
    _start_y = 0,
    _start_z = 0,
    _shift_x = 0,
    _shift_y = 0,
    _shift_z = 0,
    _blocks_to_dig = {  -- 限制可以挖掘的地形，避免不小心程式寫錯，挖到失控，把家給鏟了（為避免複雜，暫不使用這限制）
        "minecraft:stone",      -- 石頭
        "minecraft:cobblestone",-- 鵝卵石
        "minecraft:diorite",    -- 閃長岩
        "minecraft:andesite",   -- 安山岩
        "minecraft:granite",    -- 花崗岩
        "minecraft:gravel",     -- 礫石
        "minecraft:iron_ore",   -- 鐵礦
        "minecraft:coal_ore",   -- 煤礦
        "minecraft:gold_ore",   -- 金礦
        "minecraft:copper_ore", -- 銅礦
        "minecraft:lapis_ore",  -- 青金石礦
        "minecraft:dirt",       -- 泥土
        "minecraft:grass_block",-- 草地
        "minecraft:torch",      -- 火把
        "minecraft:wall_torch", -- 牆壁火把
        "minecraft:sand"        -- 沙子
    },
    _blocks_to_build = {    -- 可以客製化建築的方塊
        "minecraft:stone",      -- 石頭
        "minecraft:cobblestone",-- 鵝卵石
        "minecraft:diorite",    -- 閃長岩
        "minecraft:andesite",   -- 安山岩
        "minecraft:granite",    -- 花崗岩
        "minecraft:dirt",       -- 泥土
        "minecraft:grass_block",-- 草地
    },
    _blocks_falling = { -- 會下落的方塊，這類方塊失去支撐後會掉下來，擋到挖掘機器人的路
        "minecraft:gravel",
        "minecraft:sand"
    },
    _loc_torch = 0, -- 火把在儲存箱內的位置，1 ~ 16
    _loc_max = 16,  -- 儲存箱最大位置
    _chest_row_size = 4,
    _chest_col_size = 4,
    length = 1,     -- Default Size
    weight = 4,
    height = 4,
    chestPos = {    -- Chest Box Position
        x = 0,
        y = 0,
        z = 0
    },
    pos = {         -- Current Point
        x = 0,
        y = 0,
        z = 0
    },
    lastPos = {
        x = 0,
        y = 0,
        z = 0
    },
    facing = DIR.NORTH,
    lastFacing = DIR.NORTH,
    direction = POS.FWD
}

local reserveBlocks = {}

function WakuTurtle:getLength()
    return self.length
end

function WakuTurtle:getWeight()
    return self.weight
end

function WakuTurtle:getHeight()
    return self.height
end

function WakuTurtle:log()
    print("Current X:", self.pos.x, " Y:", self.pos.y, " Z:", self.pos.z, "Face:", self.facing)
end

function WakuTurtle:findTorch()
    local loc = 1
    while loc <= self._loc_max and self.turtle.select(loc) do
        if self.turtle.getItemCount(loc) > 0 then
            local items = self.turtle.getItemDetail()
            if items.name == "minecraft:torch" then
                self._loc_torch = loc
                break
            end
        end
        loc = loc + 1
    end
end

function WakuTurtle:new(name, turtle, buildMode, repeatModeX, repeatModeY, length, weight, height, xShift, yShift, zShift)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.name = name
    obj.turtle = turtle;
    obj._build_mode = buildMode or obj._build_mode
    obj._repeat_mode_x = repeatModeX or obj._repeat_mode_x
    obj._repeat_mode_y = repeatModeY or obj._repeat_mode_y
    obj.length = (length and length >= 1 and length) or obj.length
    obj.weight = (weight and weight >= 1 and weight) or obj.weight
    obj.height = (height and height >= 1 and height) or obj.height
    obj._shift_x = xShift
    obj._shift_y = yShift
    obj._shift_z = zShift

    -- Show initial status
    obj.createTime = os.date(self._time_format)
    print("Start time: " .. obj.createTime)
    print("Name:", obj.name)
    print("Digging (L x W x H):", obj.length, "x", obj.weight, "x", obj.height)

    --obj:findTorch()
    if turtle then
        obj:saveReserveBlocks()
    end
    obj:log()
    return obj
end


-- 移動到挖掘的起始位置
function WakuTurtle:gotoStartPos()
    -- 根據 _shift_x 數值，左右調整挖掘的起始位置
    self:digAuto(POS.RGT, self._shift_x, true)

    -- 根據 _shift_y 數值，上下調整挖掘的起始位置
    self:digAuto(POS.UP, self._shift_y)

    -- 根據 _shift_z 數值，前後調整挖掘的起始位置
    self:digAuto(POS.FWD, self._shift_z)
end


-- 儲存當下的座標與朝向，以便之後可以回來繼續工作
function WakuTurtle:saveCurrentPos()
    self.lastPos.x = self.pos.x
    self.lastPos.y = self.pos.y
    self.lastPos.z = self.pos.z
    self.lastFacing = self.facing
end


-- 朝著 pos 方向移動
function WakuTurtle:move(pos, distance)
    local result = false;
    distance = distance or 1
    if pos == POS.FWD then
        result = self.turtle.forward()
        if result then
            if self.facing == DIR.NORTH then
                self.pos.z = self.pos.z + 1
            elseif self.facing == DIR.SOUTH then
                self.pos.z = self.pos.z - 1
            elseif self.facing == DIR.WEST then
                self.pos.x = self.pos.x - 1
            elseif self.facing == DIR.EAST then
                self.pos.x = self.pos.x + 1
            end
        end
    elseif pos == POS.BCK then
        result = self.turtle.back()
        if result then
            if self.facing == DIR.NORTH then
                self.pos.z = self.pos.z - 1
            elseif self.facing == DIR.SOUTH then
                self.pos.z = self.pos.z + 1
            elseif self.facing == DIR.WEST then
                self.pos.x = self.pos.x + 1
            elseif self.facing == DIR.EAST then
                self.pos.x = self.pos.x - 1
            end
        end
    elseif pos == POS.UP then
        result = self.turtle.up()
        if result then self.pos.y = self.pos.y + 1 end
    elseif pos == POS.DWN then
        result = self.turtle.down()
        if result then self.pos.y = self.pos.y - 1 end
    end

    if distance > 1 then return self:move(pos, distance - 1) end

    return result
end


local function checkList(value, list)
    for _, v in ipairs(list) do
        if v == value then
            return true
        end
    end
    return false
end

-- 檢查方塊是否會掉落
function WakuTurtle:isFallingBlock(blockName)
    return checkList(blockName, self._blocks_falling)
end

-- 檢查方塊是否允許挖掘
function WakuTurtle:allowedToDig(blockName)
    return true
    -- return checkList(blockName, self._blocks_to_dig)
end

-- 確認建築藍圖，檢查前面的空間是否應該保留
-- 挖掘模式時，設計圖中有方塊 (1) 的地方必須保留（不能挖）
-- 填補模式時，設計圖中沒有方塊 (0) 的地方必須保留（不能填）
function WakuTurtle:isReserveSpace(posX, posY)
    local blockName = 0
    posX = posX or self.pos.x
    posY = posY or self.pos.y

    if self._repeat_mode_x == REPEAT_MODE.NO_REPEAT and (posX < self._shift_x or posX > (self._chest_row_size - 1) + self._shift_x) then
        blockName = 0
    elseif self._repeat_mode_y == REPEAT_MODE.NO_REPEAT and (posY < self._shift_y or posY > (self._chest_col_size - 1) + self._shift_y) then
        blockName = 0
    else
        local reviseX = ((posX % self._chest_row_size + 1 - self._shift_x) - 1) % self._chest_row_size + 1
        local reviseY = ((self._chest_col_size - posY % self._chest_col_size + self._shift_y) - 1) % self._chest_col_size + 1
        if self._repeat_mode_x == REPEAT_MODE.MIRROR and (math.floor((posX - self._shift_x) / self._chest_row_size)) % 2 == 1 then
            reviseX = self._chest_row_size + 1 - reviseX
        end

        if self._repeat_mode_y == REPEAT_MODE.MIRROR and (math.floor((posY - self._shift_y) / self._chest_col_size)) % 2 == 1 then
            reviseY = self._chest_col_size + 1 - reviseY
        end
        blockName = reserveBlocks[reviseY][reviseX]
    end

    if (self._build_mode == BUILD_MODE.DIG and blockName ~= 0) or
       (self._build_mode == BUILD_MODE.FILL and blockName == 0) then
        return true, nil
    else
        return false, blockName
    end
end


--[[
    取得下一個可以工作（挖掘或填補）的位置，回傳座標與朝向
    dir: 目前的主要朝向
    return: x, y, facing
  ]]
function WakuTurtle:getNextWorkingPos(dir, posX, posY)
    posX = posX or self.pos.x
    posY = posY or self.pos.y

    -- DIR.EAST
    local step = 1
    local final = self:getWeight() + self._shift_x - 1
    local facing = dir

    if facing == DIR.WEST then
        step = -1
        final = self._shift_x
    end

    local start = posX
    local changeFinal = function ()
        if final == self._shift_x then
            return self:getWeight() + self._shift_x - 1
        else
            return self._shift_x
        end
    end

    for y = posY, self:getHeight() + self._shift_y - 1, 1 do
        local x
        for x = start, final, step do
            if not self:isReserveSpace(x, y) then
                print("x: " .. x .. ", y: " .. y .. ", facing: " .. facing)
                return x, y, facing
            end
        end

        facing = DIR.getRevDir(facing)
        start = final
        final = changeFinal()
        step = step * -1
    end

    return nil, nil, nil
end


local function initReserveBlocks(rowSize, colSize)
    for i = 1, colSize do
        reserveBlocks[i] = {}
        for j = 1, rowSize do
            reserveBlocks[i][j] = 0
        end
    end
end


-- 把小烏龜的儲物箱當作藍圖，儲存需要保留方塊的位置
function WakuTurtle:saveReserveBlocks()
    local loc = 1
    local obj = self.turtle
    local ok, chest = self.turtle.inspectDown()

    if ok and string.find(chest.name, "chest") then
        chest = Chest:getInstance(chest.name)
        obj = peripheral.wrap("bottom")
        self._loc_max = obj.size()
        self._chest_row_size = chest:getRowSize()
        self._chest_col_size = obj.size() / chest:getRowSize()
        self.weight = (self.weight > 1 and self.weight) or self._chest_row_size
        self.height = (self.height > 1 and self.height) or self._chest_col_size
    end

    initReserveBlocks(self._chest_row_size, self._chest_col_size)

    while loc <= self._loc_max do
        local item = obj.getItemDetail(loc)
        if item then
            local x = (loc - 1) % self._chest_row_size
            local y = math.floor((self._loc_max - loc) / self._chest_row_size)
            reserveBlocks[self._chest_col_size - y][x + 1] = item.name
        end
        loc = loc + 1
    end
end


function WakuTurtle:assignReserveBlocks(newReserveBlocks)
    reserveBlocks = newReserveBlocks
end


-- 從小烏龜的儲物箱中尋找建築用的方塊
function WakuTurtle:findBuildingBlocks(blockName)
    local loc = 1
    while loc <= 16 and self.turtle.select(loc) do
        local item = self.turtle.getItemDetail(loc)
        if item and blockName and item.name == blockName then
            --local items = self.turtle.getItemDetail()
            --if checkList(items.name, self._blocks_to_build) then return loc end
            return loc
        end
        loc = loc + 1
    end

    return 0
end


-- 把已儲存的藍圖輸出到螢幕上，方便確認
function WakuTurtle:printReserveBlocks()
    for i = 1, #reserveBlocks do
        for j = 1, #reserveBlocks[i] do
            io.write(reserveBlocks[i][j], "\t")
        end
        print()
    end
end


function WakuTurtle:keepDigging()
    local result, exist, block = false, false, nil
    result = self.turtle.dig()
    exist, block = self.turtle.inspect()
    while exist and self:isFallingBlock(block.name) do
        result = self.turtle.dig()
        exist, block = self.turtle.inspect()
    end
    return result
end

-- 朝著 pos 方向挖掘，並移動一格
-- move == false 時只是挖掘而不移動
function WakuTurtle:dig(pos, move)
    pos = pos or POS.FWD
    if move == nil then move = true end

    local result = false
    local exist = false
    local block = nil

    if pos == POS.FWD then
        exist, block = self.turtle.inspect()
        if exist and self:allowedToDig(block.name) then result = self:keepDigging() end
    elseif pos == POS.UP then
        exist, block = self.turtle.inspectUp()
        if exist and self:allowedToDig(block.name) then result = self.turtle.digUp() end
    elseif pos == POS.DWN then
        exist, block = self.turtle.inspectDown()
        if exist and self:allowedToDig(block.name) then result = self.turtle.digDown() end
    end

    if move and (not exist or result) then self:move(pos) end

    return result
end


function WakuTurtle:turnLeft(times)
    times = times or 1
    local result = false
    while times > 0 do
        result = self.turtle.turnLeft();
        if self.facing == DIR.NORTH then
            self.facing = DIR.WEST
        elseif self.facing == DIR.WEST then
            self.facing = DIR.SOUTH
        elseif self.facing == DIR.SOUTH then
            self.facing = DIR.EAST
        elseif self.facing == DIR.EAST then
            self.facing = DIR.NORTH
        end
        times = times - 1
    end

    return result
end


function WakuTurtle:turnRight(times)
    times = times or 1
    local result = false
    while times > 0 do
        result = self.turtle.turnRight();
        if self.facing == DIR.NORTH then
            self.facing = DIR.EAST
        elseif self.facing == DIR.EAST then
            self.facing = DIR.SOUTH
        elseif self.facing == DIR.SOUTH then
            self.facing = DIR.WEST
        elseif self.facing == DIR.WEST then
            self.facing = DIR.NORTH
        end
        times = times - 1
    end

    return result
end


function WakuTurtle:turnBack()
    return self:turnLeft(2);
end


function WakuTurtle:faceTo(dir)
    if dir == self.facing then return end

    local diff = dir - self.facing
    if diff == 2 or diff == -6 then
        self:turnRight()
    elseif diff == -2 or diff == 6 then
        self:turnLeft()
    else
        self:turnLeft()
        self:turnLeft()
    end
end


-- 朝著 pos 方向挖掘一段距離
function WakuTurtle:digAuto(pos, distance, shift)
    if shift == nil then shift = false end
    if distance == 0 then return end

    if distance < 0 then
        pos = POS.getRevDir(pos)
        distance = math.abs(distance)
    end

    local d = 0
    if pos == POS.LFT then
        self:turnLeft()
        while d < distance do
            self:dig(POS.FWD)
            d = d + 1
        end
        -- shift to left
        if shift then self:turnRight() end

    elseif pos == POS.RGT then
        self:turnRight()
        while d < distance do
            self:dig(POS.FWD)
            d = d + 1
        end
        -- shift to right
        if shift then self:turnLeft() end

    else
        while d < distance do
            self:dig(pos)
            d = d + 1
        end
    end

end


function WakuTurtle:placeAuto(pos, distance)
    if distance == 0 then return false end

    local _, blockName = self:isReserveSpace(self.pos.x, self.pos.y)
    local buildingBlocksLoc = self:findBuildingBlocks(blockName)
    if buildingBlocksLoc == 0 then
        print("No building blocks found")
        return false
    end

    if distance < 0 then
        pos = POS.getRevDir(pos)
        distance = math.abs(distance)
    end

    local d = 0
    self:move(POS.BCK)
    while d < distance and buildingBlocksLoc > 0 do
        self:move(POS.BCK)
        self.turtle.select(buildingBlocksLoc)
        self.turtle.place()
        buildingBlocksLoc = self:findBuildingBlocks()
        d = d + 1
    end
end


-- 移動到座標 x, y, z
function WakuTurtle:gotoPos(x, y, z)
    while self.pos.z > z do
        self:faceTo(DIR.SOUTH)
        self:move(POS.FWD)
    end
    while self.pos.z < z do
        self:faceTo(DIR.NORTH)
        self:move(POS.FWD)
    end

    while self.pos.y > y do
        self:move(POS.DWN)
    end
    while self.pos.y < y do
        self:move(POS.UP)
    end

    while self.pos.x > x do
        self:faceTo(DIR.WEST)
        self:move(POS.FWD)
    end
    while self.pos.x < x do
        self:faceTo(DIR.EAST)
        self:move(POS.FWD)
    end
end


-- 回到初始位置 0, 0, 0
function WakuTurtle:backToStartPoint()
    self:saveCurrentPos()
    self:gotoPos(self._start_x, self._start_y, self._start_z)
    self:faceTo(DIR.NORTH)
end

-- 回到儲物箱位置的上方
function WakuTurtle:backToChest()
    self:saveCurrentPos()
    self:gotoPos(self._start_x, self._start_y, self._start_z)
    self:dropAllItems()
    self:faceTo(DIR.NORTH)
end

-- 回到上次暫存的位置
function WakuTurtle:backToLastPos()
    self:gotoPos(self.lastPos.x, self.lastPos.y, self.lastPos.z)
end

-- 把攜帶的全部物品放入儲物箱
function WakuTurtle:dropAllItems()
    local ok, block = self.turtle.inspectDown()
    if not ok or block.name ~= "minecraft:chest" then
        print("No chest found")
        return
    end

    local loc = 1
    while loc <= self._loc_max and self.turtle.select(loc) do
        if self.turtle.getItemCount(loc) > 0 then
            local items = self.turtle.getItemDetail()
            if items.name == "minecraft:torch" then
                loc = loc + 1
                goto continue
            end

            ok = self.turtle.dropDown()
            if not ok then
                print("Chest is no space or full of " .. items.name)
            end
        end
        loc = loc + 1
        ::continue::
    end
end


function WakuTurtle:placeTorch()
    if self._loc_torch == 0 then
        print("No torch found")
        return
    end

    self.turtle.select(self._loc_torch)
    self:dig(POS.UP, false)
    self.turtle.placeUp()
end