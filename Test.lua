require "WakuTurtle"

Length = 6
Weight = 6
Height = 6

local builder = WakuTurtle:new("Ant", turtle, Length, Weight, Height, -2, 0, -1)
builder:dig()