

local class = require 'class'


local Piece = class(function(p, player, spot)
  p.player = player
  p.spot = spot
  p.dest_spot = nil
  p.finished = false

  return p
end)


-- TODO make this function a bit cleaner, ie more functional
function Piece:move()

  local dest_spot = self.dest_spot

  -- process taking the piece off the board
  if dest_spot == 'end' then
    self:moveOffBoard()
    return true
  end

  -- check if you can land on this spot just for good measure
  if not dest_spot:canLandOn(self.player) then
    return false
  end

  -- move the piece off of the spot it is on
  self.spot.piece = nil

  -- check if there is already a piece on this spot
  if dest_spot.piece then
    -- I shouldn't have a piece here
    if self.player.num == dest_spot.piece.player.num then
      return false
    end

    -- reset the piece that was on this spot to its first spot
    dest_spot.piece.spot = dest_spot.piece.player.spots[1]
  end

  -- put the piece down
  self.spot = dest_spot
  dest_spot.piece = self

  -- reset the piece properties
  self.dest_spot = nil

  self.player:resetPieces()

  return true
end


function Piece:moveOffBoard()
  self.spot.piece = nil
  self.spot = nil
  local player = self.player
  player.pieces = filter(player.pieces, notEquals(self))
end


return Piece

