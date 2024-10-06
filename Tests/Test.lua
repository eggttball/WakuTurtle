require "WakuTurtle"

builder = WakuTurtle:new("Ant", turtle, BUILD_MODE.FILL, REPEAT_MODE.MIRROR, REPEAT_MODE.REPEAT, 1, 24, 9, -11, 0)
builder:gotoStartPos()

step = 1
dir, facing = DIR.EAST, builder.facing
nextActionOnDir = function () builder:faceTo(dir) builder:digAuto(POS.FWD, 1) end

nextX, nextY, nextFacing = builder:getNextWorkingPos(dir)



if nextX > builder.pos.x then step = 1; dir = DIR.EAST; elseif nextX < builder.pos.x then step = -1; dir = DIR.WEST; end

for i = builder.pos.x, nextX - step, step do nextActionOnDir() end
for i = builder.pos.y, nextY - 1, 1 do builder:dig(POS.UP) end
dir = nextFacing; step = (dir == DIR.EAST) and 1 or -1

builder:faceTo(POS.getRevDir(facing)) builder:placeAuto(POS.FWD, builder:getLength())
facing = DIR.getRevDir(facing)

nextX, nextY, nextFacing = builder:getNextWorkingPos(dir, builder.pos.x + step, builder.pos.y)
if nextY == builder.pos.y then nextActionOnDir() elseif nextX > builder.pos.x then dir = DIR.EAST nextActionOnDir() elseif nextX < builder.pos.x then dir = DIR.WEST nextActionOnDir() end