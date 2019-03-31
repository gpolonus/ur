

require 'help'
require 'colors'
local createButton = require 'ui-elements/button'


local spot_length
local start_spot_x
local start_spot_y
local start_button
local roll_button


function drawInit()
  spot_length = windowWidth / 10
  start_spot_x = spot_length
  start_spot_y = 100

  local button_w = 150
  local button_h = 50
  start_button = createButton(
    windowWidth / 2 - button_w / 2,
    windowHeight / 2 - button_h / 2,
    button_w,
    button_h,
    'START',
    25
  )

  roll_button = createButton(
    windowWidth / 2 - button_w / 2,
    start_spot_y + spot_length * 4.5,
    button_w,
    button_h,
    'ROLL',
    25
  )

  skip_button = createButton(
    windowWidth / 2 - button_w / 2 + spot_length * 3,
    spot_length * 4.5,
    button_w,
    button_h,
    'NEXT',
    25
  )

  return start_button, roll_button, skip_button
end

-- draw everything on the board
function drawGame(game, hover_spot)

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

  -- draw the need-to-roll title and button
  if game:isRolling() then
    drawNeedToRoll(game)
  end

  -- draw the rolling coins
  if game:isMoving() then
    drawRolling(game)
  end

end


local rolling_title_font = love.graphics.newFont(30)

function drawRollingTitle(game)
  love.graphics.setFont(rolling_title_font)
  love.graphics.setColor(white())
  local text
  if game.spaces_to_move == 0 then
    text = string.format("Player %s rolled nothing", game.active_player.num)
    skip_button:draw()
  else
    text = string.format("Player %s rolled a %d", game.active_player.num, game.spaces_to_move)
  end
  love.graphics.printf(text, 0, spot_length * 5, windowWidth, 'center')
end


function drawRolling(game)
  drawRollingTitle(game)
  forEach(game.rolls, function(roll, i)
    love.graphics.setColor(yellow())
    local x = start_spot_x + (spot_length * (i - 1) * 2) + spot_length
    local y = start_spot_y + spot_length * 5
    love.graphics.circle(
      'line',
      x,
      y,
      spot_length / 2
    )

    if roll == 1 then
      love.graphics.circle(
        'fill',
        x,
        y,
        spot_length / 2.5
      )

    end
  end)
end


function drawNeedToRollTitle(game)
  love.graphics.setFont(rolling_title_font)
  love.graphics.setColor(white())
  local text = string.format("Player %s is rolling", game.active_player.num)
  love.graphics.printf(text, 0, spot_length * 5, windowWidth, 'center')
end


function drawNeedToRoll(game)
  drawNeedToRollTitle(game)
  drawRollButton()
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
  local x = start_spot_x + spot_length * (col_num - 1)
  local y = start_spot_y + spot_length * (row_num - 1)
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


local title_font = love.graphics.newFont(50)

function drawTitle()
  love.graphics.setFont(title_font)
  love.graphics.setColor(white())
  love.graphics.printf('The Royal Game of Ur', 0, 0, windowWidth, 'center')
end


function drawWinner(playerNum)
  love.graphics.setFont(title_font)
  love.graphics.setColor(white())
  love.graphics.printf(
    string.format('The Winner is Player %d', playerNum),
    0,
    windowHeight / 3,
    windowWidth,
    'center'
  )
end


function mouseOnSpot(x, y, board)
  x = x - start_spot_x
  y = y - start_spot_y
  local row = math.floor(y / start_spot_y)
  local col = math.floor(x / start_spot_x) + 1
  return board.spots[row * 8 + col]
end


function drawStartButton()
  start_button:draw()
end


function drawRollButton()
  roll_button:draw()
end

