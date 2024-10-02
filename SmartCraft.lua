require "WakuTurtle"

local buildMode     = tonumber(arg[1])
local repeatModeX   = tonumber(arg[2])
local repeatModeY   = tonumber(arg[3])
local length = tonumber(arg[4])
local weight = tonumber(arg[5])
local height = tonumber(arg[6])
local xShift = tonumber(arg[7]) or 0    -- 右移格數，調整挖掘的起始位置。挖掘很大的空間時，方便同時放出多個小烏龜一起作業，避免互相干擾
local yShift = tonumber(arg[8]) or 0    -- 垂直移動格數，調整挖掘的上下起始位置。理由同上



local builder = WakuTurtle:new("Ant", turtle, buildMode, repeatModeX, repeatModeY, length, weight, height, xShift, yShift)
-- 移動到初始位置再開始作業
builder:gotoStartPos()

local hgt = 0
local dir = DIR.EAST -- 建築的主要方向，先由左向右，整個平面完成後再從右向左，持續反覆
local facing = builder.facing       -- 暫存小烏龜原本的朝向
local nextActionOnDir = function () -- 依據建築的主要方向，再往前挖掘一格
    builder:faceTo(dir)
    builder:digAuto(POS.FWD, 1)
end

while hgt < builder:getHeight() do

    local wgt = 0
    -- 持續來回挖掘或填補平面的方塊，直到寬度到達 Weight
    while wgt < builder:getWeight() do
        -- 確認眼前的方塊，根據建築藍圖是否應該保留
        while builder:isReserveSpace() do
            wgt = wgt + 1
            if  wgt == builder:getWeight() then goto continue end
            -- 眼前的方塊必須保留，所以跳過，繼續往前一格
            nextActionOnDir()
        end

        -- 眼前整排可以挖掘或填補，先面向原本的朝向，然後開始進行
        builder:faceTo(facing)
        if builder._build_mode == BUILD_MODE.DIG then
            builder:digAuto(POS.FWD, builder:getLength() + 1)
            -- 記錄目前座標，這是確保可以回到原點的位置
            builder:saveCurrentPos()
        else
            builder:placeAuto(POS.FWD, builder:getLength())
        end

        -- 進行一排後，下次行動方向要反轉
        facing = DIR.getRevDir(facing)
        wgt = wgt + 1
        if wgt == builder:getWeight() then break end
        nextActionOnDir()
    end

    ::continue::

    -- 往上挖掘一格，準備建築下一個平面
    hgt = hgt + 1
    if hgt < builder:getHeight() then
        builder:dig(POS.UP)
        dir = DIR.getRevDir(dir)
    end
end


if builder._build_mode == BUILD_MODE.DIG then
    -- 先回到上次的位置，確保中間不會遇到任何阻擋，再回到起始位置
    builder:backToLastPos()
elseif builder._build_mode == BUILD_MODE.FILL and builder.facing == DIR.SOUTH then
    builder:dig(POS.UP)
    builder:digAuto(POS.FWD, builder:getLength() + 1)
end


builder:backToStartPoint()
