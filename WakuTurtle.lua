require "Base"

WakuTurtle = {
    _time_format = "%Y-%m-%d %H:%M:%S",
    _start_x = 0,   -- Start Point
    _start_y = 0,
    _start_z = 0,
    _blocks_to_dig = {  -- 限制可以挖掘的地形，避免不小心程式寫錯，挖到失控，把家給鏟了
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
    _blocks_falling = { -- 會下落的方塊，這類方塊失去支撐後會掉下來，擋到挖掘機器人的路
        "minecraft:gravel",
        "minecraft:sand"
    },
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
    facing = DIR.FWD,
    lastFacing = DIR.FWD,
    direction = DIR.FWD
}

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

function WakuTurtle:new(name, turtle, length, weight, height)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.name = name
    obj.turtle = turtle;
    obj.length = (length and length >= 1 and length) or 1
    obj.weight = (weight and weight >= 1 and weight) or 1
    obj.height = (height and height >= 1 and height) or 1

    -- Show initial status
    obj.createTime = os.date(self._time_format)
    print("Start time: " .. obj.createTime)
    print("Name:", obj.name)
    print("Digging (L x W x H):", obj.length, "x", obj.weight, "x", obj.height)
    return obj
end


-- 儲存當下的座標與朝向，以便之後可以回來繼續工作
function WakuTurtle:saveCurrentPos()
    self.lastPos.x = self.pos.x
    self.lastPos.y = self.pos.y
    self.lastPos.z = self.pos.z
    self.lastFacing = self.facing
end


-- 朝著 dir 方向移動一格
function WakuTurtle:move(dir)
    local result = false;
    if dir == DIR.FWD then
        result = self.turtle.forward()
        if result then
            if self.facing == DIR.FWD then
                self.pos.z = self.pos.z + 1
            elseif self.facing == DIR.BCK then
                self.pos.z = self.pos.z - 1
            elseif self.facing == DIR.LFT then
                self.pos.x = self.pos.x - 1
            elseif self.facing == DIR.RGT then
                self.pos.x = self.pos.x + 1
            end
        end
    elseif dir == DIR.BCK then
        result = self.turtle.back()
        if result then
            if self.facing == DIR.FWD then
                self.pos.z = self.pos.z - 1
            elseif self.facing == DIR.BCK then
                self.pos.z = self.pos.z + 1
            elseif self.facing == DIR.LFT then
                self.pos.x = self.pos.x + 1
            elseif self.facing == DIR.RGT then
                self.pos.x = self.pos.x - 1
            end
        end
    elseif dir == DIR.UP then
        result = self.turtle.up()
        if result then self.pos.y = self.pos.y + 1 end
    elseif dir == DIR.DWN then
        result = self.turtle.down()
        if result then self.pos.y = self.pos.y - 1 end
    end

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
    return checkList(blockName, self._blocks_to_dig)
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

-- 朝著 dir 方向挖掘，並移動一格
-- move == false 時只是挖掘而不移動
function WakuTurtle:dig(dir, move)
    dir = dir or DIR.FWD
    move = move or true

    local result = false
    local exist = false
    local block = nil

    if dir == DIR.FWD then
        exist, block = self.turtle.inspect()
        if exist and self:allowedToDig(block.name) then result = self:keepDigging() end
    elseif dir == DIR.UP then
        exist, block = self.turtle.inspectUp()
        if exist and self:allowedToDig(block.name) then result = self.turtle.digUp() end
    elseif dir == DIR.DWN then
        exist, block = self.turtle.inspectDown()
        if exist and self:allowedToDig(block.name) then result = self.turtle.digDown() end
    end

    if move and (not exist or result) then self:move(dir) end

    return result
end


function WakuTurtle:turnLeft()
    local result = self.turtle.turnLeft();
    if self.facing == DIR.FWD then
        self.facing = DIR.LFT
    elseif self.facing == DIR.LFT then
        self.facing = DIR.BCK
    elseif self.facing == DIR.BCK then
        self.facing = DIR.RGT
    elseif self.facing == DIR.RGT then
        self.facing = DIR.FWD
    end

    return result
end


function WakuTurtle:turnRight()
    local result = self.turtle.turnRight();
    if self.facing == DIR.FWD then
        self.facing = DIR.RGT
    elseif self.facing == DIR.RGT then
        self.facing = DIR.BCK
    elseif self.facing == DIR.BCK then
        self.facing = DIR.LFT
    elseif self.facing == DIR.LFT then
        self.facing = DIR.FWD
    end

    return result
end


-- 固定每次都回到最右邊開始新一輪的挖掘
function WakuTurtle:moveToRightMost(distance, forceDig)
    self:turnRight()
    local moving = true
    local pos = 1
    local dig = forceDig or false
    while moving and pos < distance do
        local inspect = self.turtle.inspect()
        if inspect and dig then
            self:keepDigging()
        end
        moving = self:move(DIR.FWD)
        pos = pos + 1
    end
    self:turnLeft()
end


-- 朝著 dir 方向挖掘一段距離
function WakuTurtle:digAuto(dir, distance)
    local pos = 1
    local moving = true
    while moving and pos < distance do
        local digging, block = self:dig(dir)
        pos = pos + 1
    end
end


-- 移動到座標 x, y, z
function WakuTurtle:goToPos(x, y, z)
    if self.pos.x > x then
        self:turnLeft()
        while self.pos.x > x do
            self:move(DIR.FWD)
        end
        self:turnRight()
    elseif self.pos.x < x then
        self:turnRight()
        while self.pos.x < x do
            self:move(DIR.FWD)
        end
        self:turnLeft()
    end

    while self.pos.y > y do
        self:move(DIR.DWN)
    end
    while self.pos.y < y do
        self:move(DIR.UP)
    end

    while self.pos.z > z do
        self:move(DIR.BCK)
    end
    while self.pos.z < z do
        self:move(DIR.FWD)
    end
end


-- 回到初始位置 0, 0, 0
function WakuTurtle:backToStartPoint()
    self:saveCurrentPos()
    self:goToPos(self._start_x, self._start_y, self._start_z)
end

-- 回到儲物箱位置的上方
function WakuTurtle:backToChest()
    self:saveCurrentPos()
    self:goToPos(self._start_x, self._start_y, self._start_z)
    self:dropAllItems()
end

-- 回到之前暫停工作的地方
function WakuTurtle:backToWork()
    self:goToPos(self.lastPos.x, self.lastPos.y, self.lastPos.z)
    while self.facing ~= self.lastFacing do
        self:turnRight()
    end
end

-- 把攜帶的全部物品放入儲物箱
function WakuTurtle:dropAllItems()
    local ok, block = self.turtle.inspectDown()
    if not ok or block.name ~= "minecraft:chest" then
        print("No chest found")
        return
    end

    local loc = 1
    while loc <= 16 and self.turtle.select(loc) do
        if self.turtle.getItemCount(loc) > 0 then
            ok = self.turtle.dropDown()
            if not ok then
                local items = self.turtle.getItemDetail()
                print("Chest is no space or full of " .. items.name)
            end
        end
        loc = loc + 1
    end
end