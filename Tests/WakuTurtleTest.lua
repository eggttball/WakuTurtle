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


os.exit(luaunit.LuaUnit.run())
