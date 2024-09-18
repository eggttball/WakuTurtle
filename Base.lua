DIR = {
    UP = 1,     -- 挖掘方向 1: 上, -1: 下
    DWN = -1,
    FWD = 8,    -- 正面朝向 2: 後, 4: 左, 6: 右, 8: 前
    BCK = 2,
    LFT = 4,
    RGT = 6
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