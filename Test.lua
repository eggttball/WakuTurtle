require "WakuTurtle"

builder = WakuTurtle:new("Ant", turtle, BUILD_MODE.FILL, REPEAT_MODE.MIRROR, REPEAT_MODE.REPEAT, 1, 24, 9, -11, 0)
builder:gotoStartPos()

wgt, hgt, step = 0, 0, 0
dir, facing = DIR.EAST, builder.facing
nextActionOnDir = function () builder:faceTo(dir) builder:digAuto(POS.FWD, 1) end

nextX, nextY, nextFacing = builder:getNextWorkingPos(dir)



if nextX > builder.pos.x then step = 1 elseif nextX < builder.pos.x then step = -1 end
if nextX ~= builder.pos.x then if step < 0 then dir = DIR.WEST end for i = builder.pos.x, nextX - step, step do nextActionOnDir() end end

if nextY ~= builder.pos.y then for i = builder.pos.y, nextY - 1, 1 do hgt = hgt + 1 builder:dig(POS.UP) end end
dir = nextFacing

builder:faceTo(POS.getRevDir(facing)) builder:placeAuto(POS.FWD, builder:getLength())
wgt, facing = wgt + 1, DIR.getRevDir(facing)

nextX, nextY, nextFacing = builder:getNextWorkingPos(dir, builder.pos.x + step, builder.pos.y)
if nextY == builder.pos.y then nextActionOnDir() elseif nextX > builder.pos.x then dir = DIR.EAST nextActionOnDir() elseif nextX < builder.pos.x then dir = DIR.WEST nextActionOnDir() end