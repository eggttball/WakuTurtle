require "WakuTurtle"

Length = 3
Weight = 10
Height = 3

local builder = WakuTurtle:new("Ant", turtle, Length, Weight, Height, 1, 0, -4)
builder:log()

-- 移動到最右邊作為初始位置
builder:moveToRightMost(Weight)

local len = 0
local direction = DIR.UP
while len < builder:getLength() do
    -- 往上挖掘一排高的方塊
    local wgt = 1
    builder:digAuto(direction, builder:getHeight())
    direction = direction * -1

    -- 接下來往下挖掘一排、再往上挖掘一排，持續上下交替直到寬度到達 Weight
    while wgt < builder:getWeight() do
        builder:turnLeft()
        builder:dig()
        builder:turnRight()
        builder:digAuto(direction, builder:getHeight())
        direction = direction * -1
        wgt = wgt + 1
    end

    -- 往前挖掘一格後再回到最右邊初始位置
    len = len + 1
    if len < builder:getLength() then
        builder:dig()
        builder:moveToRightMost(builder:getWeight(), true)
    end
end


-- 紀錄工作結束後最後位置
builder:log()
builder:backToChest()
builder:backToWork()