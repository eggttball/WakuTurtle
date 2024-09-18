require "WakuTurtle"

local length = tonumber(arg[1])
local weight = tonumber(arg[2])
local height = tonumber(arg[3])
local horizontal = tonumber(arg[4]) or 0 -- 水平線位置

local builder = WakuTurtle:new("Ant", turtle, length, weight, height)
builder:log()

-- 初始位置必須是在儲物箱正上方
-- 接著往前一格，再移動到最右邊開始作業
builder:dig()
builder:moveToRightMost(math.floor(builder:getWeight() / 2))

-- 若水平線位置為負數，則從下方開始挖
if horizontal < 0 then
    builder:digAuto(DIR.DWN, math.abs(horizontal))
end

local len = 0
local direction = DIR.UP
while len < builder:getLength() do

    if len % 4 == 1 and direction == DIR.DWN then
        builder:dig(DIR.UP, false)
        builder:placeTorch()
    end

    -- 往上挖掘一排高的方塊
    local wgt = 1
    builder:digAuto(direction, builder:getHeight() - 1)
    direction = direction * -1

    -- 接下來往下挖掘一排、再往上挖掘一排，持續上下交替直到寬度到達 Weight
    while wgt < builder:getWeight() do
        builder:turnLeft()
        builder:dig()
        builder:turnRight()
        builder:digAuto(direction, builder:getHeight() - 1)
        direction = direction * -1
        wgt = wgt + 1
    end

    -- 往前挖掘一格後再回到最右邊初始位置
    len = len + 1
    if len < builder:getLength() then
        builder:dig()

        if len % 4 == 1 and direction == DIR.DWN then
            builder:dig(DIR.UP, false)
            builder:placeTorch()
        end

        builder:moveToRightMost(builder:getWeight() - 1)
    end
end


-- 紀錄工作結束後最後位置
builder:log()
builder:backToChest()
--builder:backToWork()