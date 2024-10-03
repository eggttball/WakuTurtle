-- 建築模式
BUILD_MODE = {
    DIG = 0,
    FILL = 1
}

-- 重複模式
REPEAT_MODE = {
    NO_REPEAT = 0,  -- 超過布局範圍不重複
    REPEAT    = 1,
    MIRROR    = 2
}


DIR = {
    NORTH = 2,
    EAST  = 4,
    SOUTH = 6,
    WEST  = 8
}

-- 相對方位（除了 UP、DWN 是絕對方位之外，其他都是相對）
POS = {
    UP = 1,
    DWN = -1,
    FWD = 2,    -- 正面朝向 2: 前, 4: 右, 6: 後, 8: 左
    RGT = 4,
    BCK = 6,
    LFT = 8
}


local oppositeDir = {
    [DIR.NORTH] = DIR.SOUTH,
    [DIR.SOUTH] = DIR.NORTH,
    [DIR.WEST] = DIR.EAST,
    [DIR.EAST] = DIR.WEST
}


local oppositePos = {
    [POS.UP] = POS.DWN,
    [POS.DWN] = POS.UP,
    [POS.FWD] = POS.BCK,
    [POS.BCK] = POS.FWD,
    [POS.LFT] = POS.RGT,
    [POS.RGT] = POS.LFT
}


DIR.getRevDir = function(dir)
    return oppositeDir[dir]
end


POS.getRevDir = function(pos)
    return oppositePos[pos]
end