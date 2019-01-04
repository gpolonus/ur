

require 'help'
require 'colors'


local spot_length = 50
local start_spot_x = 100
local start_spot_y = 100


-- draw everything on the board
function drawGame(game, typed_hover_spot)

  -- change the typed_hover_spot from a typed object to the object itself
  hover_spot = typed_hover_spot()

  drawBoard(game.board)

  -- draw the spot that is being hovered over
  if hover_spot then
    drawSpot(hover_spot, true)
  end

  -- draw all the current pieces of each player
  forEach(game.players, function(player)
    forEach(player.pieces, function(piece)
      drawPiece(piece)
    end)
  end)

  -- draw all the movable pieces
  forEach(game.movable_spots, function(spot)
    if spot.piece then
      drawPiece(spot.piece, true)
    end
  end)


  -- draw the rolling coins
  if game.status == game.STATUSES.MOVING then
    drawRolling(game)
  end

end


function drawRolling(game)
  forEach(game.rolls, function(roll, i)
    love.graphics.setColor(yellow())
    love.graphics.circle(
      'line',
      start_spot_x + (spot_length * i - 1) * 2 + spot_length,
      start_spot_y + spot_length * 4 + spot_length,
      spot_length / 2
    )

    if roll == 1 then
      love.graphics.circle(
        'fill',
        start_spot_x + (spot_length * i - 1) * 2 + spot_length,
        start_spot_y + spot_length * 4 + spot_length,
        spot_length / 2.5
      )

    end
  end)
end


function drawBoard(board)
  forEach(board.spots, function(spot)
    if spot and spot.num ~= 5 and spot.num ~= 21 then
      drawSpot(spot)
    end
  end)
end


function drawSpot(spot, hover)
  local x, y = getSpotCoords(spot)

  if hover then
    love.graphics.setColor(blue())
    love.graphics.rectangle('fill', x, y, spot_length, spot_length)
  end

  love.graphics.setColor(white())
  love.graphics.rectangle('line', x, y, spot_length, spot_length)

  if spot.special then
    love.graphics.setColor(green())
    love.graphics.circle('line', x + spot_length / 2, y + spot_length / 2, spot_length * 0.75)
  end

end


-- retrieve the coordinates of the spot of the player
function getSpotCoords(spot)
  local spot_num = spot.num
  if not spot_num then
    d = 0
  end
  local row_num = math.ceil(spot_num / 8)
  local col_num = (spot_num - 1) % 8 + 1
  local x = start_spot_x + spot_length * col_num
  local y = start_spot_y + spot_length * row_num
  return x, y
end


function drawPiece(piece, movable)
  local x, y = getSpotCoords(piece.spot)
  love.graphics.setColor(piece.player.color())
  love.graphics.circle('fill', x + spot_length / 2, y + spot_length / 2, spot_length / 3)

  if movable then
    love.graphics.setColor(magenta())
    love.graphics.circle('line', x + spot_length / 2, y + spot_length / 2, spot_length * 0.4)
  end
end

