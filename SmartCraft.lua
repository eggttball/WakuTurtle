require "WakuTurtle"

local length = tonumber(arg[1])
local weight = tonumber(arg[2])
local height = tonumber(arg[3])
local xShift = tonumber(arg[4]) or 0    -- 右移格數，調整挖掘的起始位置。挖掘很大的空間時，方便同時放出多個小烏龜一起作業，避免互相干擾
local yShift = tonumber(arg[5]) or 0    -- 垂直移動格數，調整挖掘的上下起始位置。理由同上


local builder = WakuTurtle:new("Ant", turtle, length, weight, height)
builder:log()

-- 初始位置必須是在儲物箱正上方
-- 再移動到最右邊開始作業
builder:digAuto(DIR.RGT, math.floor(builder:getWeight() / 2) + xShift, true)

-- 根據 yShift 數值，上下調整挖掘的起始位置
builder:digAuto(DIR.UP, yShift)

local hgt = 0
while hgt < builder:getHeight() do

    local wgt = 0
    -- 接下來由右向左持續來回挖掘，直到寬度到達 Weight
    while wgt < builder:getWeight() do
        -- 往前挖掘一整排的方塊
        builder:digAuto(DIR.FWD, builder:getLength() + 1)
        wgt = wgt + 1
        if wgt == builder:getWeight() then break end
        if builder.facing == DIR.FWD then
            builder:digAuto(DIR.LFT, 1)
            builder:turnLeft()
        elseif builder.facing == DIR.BCK then
            builder:digAuto(DIR.RGT, 1)
            builder:turnRight()
        end
    end

    -- 往上挖掘一格後再回到最右邊位置
    hgt = hgt + 1
    if hgt < builder:getHeight() then
        builder:dig(DIR.UP)

        if builder.facing == DIR.FWD then
            builder:digAuto(DIR.RGT, builder:getWeight() - 1)
            builder:turnRight()
        elseif builder.facing == DIR.BCK then
            builder:digAuto(DIR.LFT, builder:getWeight() - 1)
            builder:turnLeft()
        end
    end
end


-- 紀錄工作結束後最後位置
builder:log()
builder:backToChest()
--builder:backToWork()