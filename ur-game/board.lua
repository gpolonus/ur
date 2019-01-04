

local class = require 'class'
local Spot = require 'spot'
require 'help'


local valid_spots = {
  true, true, true, true, true, false, true, true,
  true, true, true, true, true,  true,  true, true,
  true, true, true, true, true, false, true, true
}


local Board = class(function(b)
  b.spots = mapRepeat(30, function(i)
    if valid_spots[i] then
      return Spot:new(i)
    end
  end)

  return b
end)


function Board:getPlayerSpots(player_num)
  return map(Spot.players_spot_map[player_num], function(spot_num)
    return self.spots[spot_num]
  end)
end


function Board:makePiecesMovable(player, roll_number)
  return filter(map(player.spots, function(spot)
    if spot.piece and spot.piece.player == player then
      local piece = spot.piece
      local player_spot_num = spot:getPlayerSpotNum(player.num)
      local dest_player_spot_num = player_spot_num + roll_number

      -- if the destination spot is 1 outside of the landable spots,
      -- then this piece can exit the board
      if dest_player_spot_num == #player.spots + 1 then
        piece.dest_spot = 'end'
        return spot
      end

      -- process piece destination normally
      local dest_spot_num = Spot.players_spot_map[player.num][dest_player_spot_num]
      if dest_spot_num then
        local dest_spot = self.spots[dest_spot_num]
        if dest_spot:canLandOn(player) then
          piece.dest_spot = dest_spot
          return spot
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end))
end


return Board

