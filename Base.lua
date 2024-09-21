DIR = {
    UP = 1,     -- 挖掘方向 1: 上, -1: 下
    DWN = -1,
    FWD = 2,    -- 正面朝向 2: 前, 4: 右, 6: 後, 8: 左
    RGT = 4,
    BCK = 6,
    LFT = 8
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
    [DIR.UP] = DIR.DWN,
    [DIR.DWN] = DIR.UP,
    [DIR.FWD] = DIR.BCK,
    [DIR.BCK] = DIR.FWD,
    [DIR.LFT] = DIR.RGT,
    [DIR.RGT] = DIR.LFT
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