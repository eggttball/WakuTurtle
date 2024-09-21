require "WakuTurtle"

local length = tonumber(arg[1])
local weight = tonumber(arg[2])
local height = tonumber(arg[3])
local xShift = tonumber(arg[4]) or 0    -- 右移格數，調整挖掘的起始位置。挖掘很大的空間時，方便同時放出多個小烏龜一起作業，避免互相干擾
local yShift = tonumber(arg[5]) or 0    -- 垂直移動格數，調整挖掘的上下起始位置。理由同上


local builder = WakuTurtle:new("Ant", turtle, length, weight, height, xShift, yShift)
-- 移動到初始位置再開始作業
builder:gotoStartPos()

local hgt = 0
local dir = DIR.LFT -- 挖掘的主要方向，先由右向左，整個平面完成後再從左向右，持續反覆
while hgt < builder:getHeight() do

    local wgt = 0
    local facing = builder.facing   -- 暫存原本的挖掘方向

    -- 接下來由右向左持續來回挖掘，直到寬度到達 Weight
    while wgt < builder:getWeight() do
        -- 確認眼前的方塊，根據建築藍圖是否應該保留
        while builder:isReserveBlock() do
            wgt = wgt + 1
            if  wgt == builder:getWeight() then goto continue end
            -- 眼前的方塊必須保留，所以跳過，繼續往前一格
            builder:faceTo(dir)
            builder:digAuto(DIR.FWD, 1)
        end

        -- 眼前的方塊可以挖掉，先面向原本的挖掘方向
        builder:faceTo(facing)

        -- 往前挖掘一整排的方塊
        builder:digAuto(DIR.FWD, builder:getLength() + 1)
        -- 挖掉一排後，下次挖掘方向要反轉
        facing = DIR.getRevDir(facing)
        wgt = wgt + 1
        if wgt == builder:getWeight() then break end
        builder:faceTo(dir)
        builder:digAuto(DIR.FWD, 1)
    end

    ::continue::

    -- 往上挖掘一格後挖回來
    hgt = hgt + 1
    if hgt < builder:getHeight() then
        builder:dig(DIR.UP)
        dir = DIR.getRevDir(dir)
        builder:faceTo(facing)
    end
end


-- 紀錄工作結束後最後位置
builder:log()
builder:backToChest()
--builder:backToWork()