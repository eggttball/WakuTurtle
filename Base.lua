DIR = {
    UP = 1,     -- 挖掘方向 1: 上, -1: 下
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


DIR.getRevDir = function(dir)
    return oppositeDir[dir]
end