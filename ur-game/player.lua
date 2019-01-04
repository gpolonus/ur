

require 'colors'
require 'help'
local class = require 'class'
local Piece = require 'piece'


local Player = class(function(p, num, spots)
  p.num = num
  p.spots = spots
  p.pieces = mapRepeat(7, function(i)
    local piece = Piece:new(p, spots[1])
    piece.spot.piece = piece
    return piece
  end)
  p.color = num == 1 and red or cyan

  return p
end)


function Player:resetPieces()
  local pieceAtHome = find(self.pieces, equalsAtIndex(self.spots[1], 'spot'))
  if not self.spots[1].piece and pieceAtHome then
    self.spots[1].piece = pieceAtHome
  end

  forEach(self.pieces, function(piece)
    piece.dest_spot = nil
  end)
end


return Player

