
require 'help'
require 'colors'
local class = require 'class'
local Player = require 'player'
local Board = require 'board'


local STATUSES = {
  START = 0,
  ROLLING = 1,
  MOVING = 2,
  FINISHED = 3
}


-- * 3 2 1      *(12/16) 13/15
-- 5 6 7 * 9 10 11       14
-- * 3 2 1      *(12/16) 13/15


local Game = class(function(g)
  g.board = Board:new()
  g.players = mapRepeat(2, function(player_num)
    return Player:new(player_num, g.board:getPlayerSpots(player_num))
  end)
  g.active_player = g.players[1]
  g.status = STATUSES.ROLLING
  g.movable_spots = {}
  g.winner = false
  return g
end)


Game.STATUSES = STATUSES


function Game:roll()
  if self.status == STATUSES.ROLLING then
    -- make the rolls
    local rolls = {
      math.random(0, 1),
      math.random(0, 1),
      math.random(0, 1),
      math.random(0, 1)
    }
    self.rolls = rolls
    self.spaces_to_move = reduce(rolls, function(ac, r) return ac + r end)
    self.movable_spots = self.board:makePiecesMovable(self.active_player, self.spaces_to_move)
    self.status = STATUSES.MOVING
  end
end


function Game:movePieceOnSpot(spot)
  if self.status == STATUSES.MOVING then
    local dest_spot = spot.piece.dest_spot
    local didMove = spot.piece:move(dest_spot)
    if didMove then
      self:endTurn(dest_spot)
    end
    return didMove
  end

  return false
end


function Game:endTurn(spot_moved_to)
  local winner = self:winCheck()
  if winner then
    return winner
  end

  if spot_moved_to.special then
    self:setRolling()
  else
    self:setNextPlayer()
  end

  return nil
end


function Game:winCheck()
  local winners = filter(self.players, function(player)
    return #player.pieces == 0
  end)
  if #winners == 1 then
    self.winner = winners[1]
    self.status = STATUSES.FINISHED
    return self.winner
  end
  return nil
end


function Game:getOtherPlayer()
  return self.players[3 - self.active_player.num]
end


function Game:setNextPlayer()
  self.active_player = self:getOtherPlayer()
  self:setRolling()
end


function Game:setRolling()
  self.status = STATUSES.ROLLING
  self.movable_spots = {}
end


function Game:isStart()
  return self.status == STATUSES.START
end
function Game:isRolling()
  return self.status == STATUSES.ROLLING
end
function Game:isMoving()
  return self.status == STATUSES.MOVING
end
function Game:isFinished()
  return self.status == STATUSES.FINISHED
end


return Game

