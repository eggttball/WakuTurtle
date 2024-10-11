require "WakuTurtle"

local buildMode     = tonumber(arg[1])
local repeatModeX   = tonumber(arg[2])
local repeatModeY   = tonumber(arg[3])
local length = tonumber(arg[4])
local weight = tonumber(arg[5])
local height = tonumber(arg[6])
local xShift = tonumber(arg[7]) or 0    -- 右移格數，調整挖掘的起始位置。挖掘很大的空間時，方便同時放出多個小烏龜一起作業，避免互相干擾
local yShift = tonumber(arg[8]) or 0    -- 垂直移動格數，調整挖掘的上下起始位置。理由同上
local zShift = tonumber(arg[9]) or 0    -- 前後移動格數，調整挖掘的前後起始位置。理由同上


local builder = WakuTurtle:new("Ant", turtle, buildMode, repeatModeX, repeatModeY, length, weight, height, xShift, yShift, zShift)
builder:printReserveBlocks()
-- 移動到初始位置再開始作業
builder:gotoStartPos()

local dir = DIR.EAST -- 建築的主要方向，先由左向右，整個平面完成後再從右向左，持續反覆
local facing = builder.facing       -- 暫存小烏龜原本的朝向
local nextActionOnDir = function () -- 依據建築的主要方向，再往前挖掘一格
    builder:faceTo(dir)
    builder:digAuto(POS.FWD, 1)
end

local nextX, nextY, nextFacing = builder:getNextWorkingPos(dir)
local step = 1

-- 每次都判斷下一個工作位置，如果找不到，表示整個建築已經完成，可以準備收工回家了
while nextX and nextY do
    -- 移動到下一個工作地點
    if nextX > builder.pos.x then
        step = 1
        dir = DIR.EAST
    elseif nextX < builder.pos.x then
        step = -1
        dir = DIR.WEST
    end
    for i = builder.pos.x, nextX - step, step do
        nextActionOnDir()
    end
    for i = builder.pos.y, nextY - 1, 1 do
        builder:dig(POS.UP)
    end

    -- 開始下一輪的工作，先正確設定方向
    dir = nextFacing
    step = (dir == DIR.EAST) and 1 or -1

    -- 眼前整排可以挖掘或填補，先面向原本的朝向，然後開始進行
    if builder._build_mode == BUILD_MODE.DIG then
        builder:faceTo(facing)
        builder:digAuto(POS.FWD, builder:getLength() + 1)
        -- 記錄目前座標，這是確保可以回到原點的位置
        builder:saveCurrentPos()
    else
        builder:faceTo(POS.getRevDir(facing))
        builder:placeAuto(POS.FWD, builder:getLength())
    end

    -- 進行一排後，下次行動方向要反轉
    facing = DIR.getRevDir(facing)
    if (builder.pos.x == xShift and dir == DIR.WEST) or (builder.pos.x == xShift + weight - 1 and dir == DIR.EAST) then
        -- 如果已經到達最左或最右邊，就要往上一排移動
        nextX, nextY, nextFacing = builder:getNextWorkingPos(DIR.getRevDir(dir), builder.pos.x, builder.pos.y + 1)
    else
        -- 在目前的方向，往下一格開始探測工作地點
        nextX, nextY, nextFacing = builder:getNextWorkingPos(dir, builder.pos.x + step, builder.pos.y)
    end
end


if builder._build_mode == BUILD_MODE.DIG then
    -- 先回到上次的位置，確保中間不會遇到任何阻擋，再回到起始位置
    builder:backToLastPos()
elseif builder._build_mode == BUILD_MODE.FILL and builder.facing == DIR.SOUTH then
    while builder.pos.y < builder:getHeight() + builder._shift_y do
        builder:dig(POS.UP)
    end
    builder:digAuto(POS.FWD, builder:getLength() + 1)
end


builder:backToStartPoint()
