local luaunit = require('luaunit')
package.path = package.path .. ";../?.lua"
require('WakuTurtle')
require "Base"


local reserveBlocks = {
    {1, 1, 1, 0},
    {0, 1, 0, 1},
    {0, 0, 0, 1},
    {1, 0, 0, 1}
}


TestWakuTurtle = {}

function TestWakuTurtle:testIsReserveSpace_DigMode_NoRepeat()
    local len, wgt, hgt = 2, 6, 6
    local shift_x, shift_y = -1, -2
    local name = "Dig with NO_REPEAT, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.DIG, REPEAT_MODE.NO_REPEAT, REPEAT_MODE.NO_REPEAT, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = -1   turtle.pos.y = -2
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 1    turtle.pos.y = 1
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 0    turtle.pos.y = -1
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 2    turtle.pos.y = -1
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = -1   turtle.pos.y = 0
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 3   turtle.pos.y = -2
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 0   turtle.pos.y = 2
    luaunit.assertFalse(turtle:isReserveSpace())
end


function TestWakuTurtle:testIsReserveSpace_DigMode_RepeatX()
    local len, wgt, hgt = 3, 7, 5
    local shift_x, shift_y = -2, -1
    local name = "Dig with REPEAT X, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.DIG, REPEAT_MODE.REPEAT, REPEAT_MODE.NO_REPEAT, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = 2   turtle.pos.y = -1
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 3   turtle.pos.y = 0
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 2
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = -2   turtle.pos.y = 3
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 1   turtle.pos.y = 3
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 3   turtle.pos.y = 3
    luaunit.assertFalse(turtle:isReserveSpace())
end


function TestWakuTurtle:testIsReserveSpace_DigMode_RepeatY()
    local len, wgt, hgt = 3, 7, 11
    local shift_x, shift_y = -2, -1
    local name = "Dig with REPEAT Y, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.DIG, REPEAT_MODE.NO_REPEAT, REPEAT_MODE.REPEAT, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = 2   turtle.pos.y = -1
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 2
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = -2   turtle.pos.y = 3
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 1   turtle.pos.y = 4
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = -1   turtle.pos.y = 9
    luaunit.assertTrue(turtle:isReserveSpace())
end


function TestWakuTurtle:testIsReserveSpace_FillMode_RepeatX()
    local len, wgt, hgt = 3, 7, 11
    local shift_x, shift_y = -2, -1
    local name = "Fill with REPEAT X, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.FILL, REPEAT_MODE.REPEAT, REPEAT_MODE.NO_REPEAT, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = 2   turtle.pos.y = -1
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 3   turtle.pos.y = 0
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 2
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 2
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = -1   turtle.pos.y = 5
    luaunit.assertTrue(turtle:isReserveSpace())
end


function TestWakuTurtle:testIsReserveSpace_DigMode_MirrorX()
    local len, wgt, hgt = 3, 20, 11
    local shift_x, shift_y = -2, -1
    local name = "Dig with MIRROR X, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.DIG, REPEAT_MODE.MIRROR, REPEAT_MODE.NO_REPEAT, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = 2   turtle.pos.y = 0
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 1
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 5   turtle.pos.y = 2
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 6   turtle.pos.y = -1
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 8   turtle.pos.y = 1
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 10   turtle.pos.y = 2
    luaunit.assertFalse(turtle:isReserveSpace())
end


function TestWakuTurtle:testIsReserveSpace_DigMode_MirrorY()
    local len, wgt, hgt = 3, 10, 20
    local shift_x, shift_y = -2, -1
    local name = "Dig with MIRROR Y, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.DIG, REPEAT_MODE.NO_REPEAT, REPEAT_MODE.MIRROR, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = -1   turtle.pos.y = 4
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 1   turtle.pos.y = 3
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 1   turtle.pos.y = 7
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = -1   turtle.pos.y = 11
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 0   turtle.pos.y = 17
    luaunit.assertFalse(turtle:isReserveSpace())
end


function TestWakuTurtle:testIsReserveSpace_DigMode_MirrorXY()
    local len, wgt, hgt = 3, 20, 20
    local shift_x, shift_y = -2, -1
    local name = "Fill with MIRROR X and Y, start at " .. shift_x .. ", " .. shift_y
    local turtle = WakuTurtle:new(name, nil, BUILD_MODE.FILL, REPEAT_MODE.MIRROR, REPEAT_MODE.MIRROR, len, wgt, hgt, shift_x, shift_y)
    turtle:assignReserveBlocks(reserveBlocks)
    turtle:printReserveBlocks()
    turtle.pos.x = 3   turtle.pos.y = 3
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 2   turtle.pos.y = 3
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 2   turtle.pos.y = 6
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 3
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 4   turtle.pos.y = 6
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 6   turtle.pos.y = 7
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 7   turtle.pos.y = 10
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 8   turtle.pos.y = 7
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 9   turtle.pos.y = 10
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 11   turtle.pos.y = 11
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 11   turtle.pos.y = 14
    luaunit.assertTrue(turtle:isReserveSpace())
    turtle.pos.x = 12   turtle.pos.y = 11
    luaunit.assertFalse(turtle:isReserveSpace())
    turtle.pos.x = 12   turtle.pos.y = 14
    luaunit.assertTrue(turtle:isReserveSpace())
end


os.exit(luaunit.LuaUnit.run())
