
local class = require 'class'


-- 1  2  3  4  5  6  7  8
-- 9  10 11 12 13 14 15 16
-- 17 18 19 20 21 22 23 24

-- * 3 2 1      *(12/16) 13/15
-- 5 6 7 * 9 10 11       14
-- * 3 2 1      *(12/16) 13/15


local special_spots = repeatValue(24, false)
special_spots[1] = true
special_spots[17] = true
special_spots[12] = true
special_spots[7] = true
special_spots[23] = true


local Spot = class(function (s, num)
  -- number of the location on the board
  s.num = num
  s.piece = nil
  s.special = special_spots[num]
  return s
end)


Spot.players_spot_map = {
  { 5, 4, 3, 2, 1, 9, 10, 11, 12, 13, 14, 15, 23, 24, 16, 8, 7 },
  { 21, 20, 19, 18, 17, 9, 10, 11, 12, 13, 14, 15, 7, 8, 16, 24, 23 }
}


function Spot:getPlayerSpotNum(player_num)
  local _, player_spot_num = findValue(self.players_spot_map[player_num], self.num)
  return player_spot_num
end


-- cases:
-- no one - true
-- my piece - false
-- his piece on special spot - false
-- his piece not on special spot - true
function Spot:canLandOn(moving_player)
  if self.piece then
    if
      self.piece.player.num == moving_player.num or
      (self.piece.player.num ~= moving_player.num and self.special)
    then
      return false
    else
      return true
    end
  else
    return true
  end
end


return Spot


