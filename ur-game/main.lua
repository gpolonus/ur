
require 'help'
require 'colors'
require 'drawing'
local Game = require 'game'
local class = require 'class'
local drawer = require 'drawer/drawer'


local game
local hover_spot
local hover_spot_num
local total_roll_num = 0
local start_button
local roll_button
local skip_button

-- love framework functionality

function love.load()
  -- called exactly once at the beginning of the game
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end

  love.graphics.setLineWidth(2)

  love.window.setTitle('Royal Game of Ur')

  math.randomseed(os.time())

  windowWidth, windowHeight = love.graphics.getDimensions()

  start_button, roll_button, skip_button = drawInit()

  setInitialDraw()
end


local keyMap = {
  left = function()
    next_hover_spot(1)
  end,

  right = function()
    next_hover_spot(-1)
  end,

  down = function()
    next_hover_spot(-1)
  end,

  up = function()
    next_hover_spot(1)
  end,

  ['return'] = function()
    movePiece()
  end
}


function movePiece()
  if game.spaces_to_move == 0 or #game.movable_spots == 0 then
    game:setNextPlayer()
    return false
  elseif not game:movePieceOnSpot(hover_spot) then
    error('Piece was told to move but didn\'t. This shouldn\'t happen!')
    return false
  else
    resetHoverSpot()
    if game.winner then
      endGame()
    end
  end
end


function doRoll()
  game:roll()
  total_roll_num = total_roll_num + 1
  if #game.movable_spots > 0 then
    set_hover_spot(1)
  end
end


function resetHoverSpot()
  hover_spot_num = nil
  set_hover_spot(-1)
end


function startGame()
  game = Game:new()
  setGameDraw()
end


function endGame()
  setWinnerDraw(game.winner.num)
  game = nil
end


function next_hover_spot(op)
  if game.spaces_to_move > 0 and #game.movable_spots > 0 then
    num = ( hover_spot_num - 1 + op ) % #game.movable_spots + 1
    set_hover_spot(num)
  end
end


function set_hover_spot(num)
  if num < 1 then
    hover_spot = nil
  else
    hover_spot_num = num
    hover_spot = game.movable_spots[num]
  end
end


function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end

  -- analyze game status
  if game then
    if game:isStart() then
      -- who knows man
    elseif game:isRolling() then
      if key == 'return' then
        doRoll()
      end
    elseif game:isMoving() then
      switch(key, keyMap)
    end
  end

end


function love.mousereleased(x, y, button)
  if not game then
    if start_button:mouseOnButton(x, y) then
      startGame()
    end
  elseif game:isRolling() then
    if roll_button:mouseOnButton(x, y) then
      doRoll()
    end
  elseif game:isMoving() then
    if skip_button:mouseOnButton(x, y) then
      movePiece()
      return
    end

    local spot = mouseOnSpot(x, y, game.board)
    if spot then
      _, possible_spot_num = findValue(game.movable_spots, spot)
      if possible_spot_num then
        hover_spot_num = possible_spot_num
        hover_spot = spot
        movePiece()
      else
        resetHoverSpot()
      end
    end
  end
end


-- Drawer Functions

function love.draw()
  drawer.draw()
end


function setInitialDraw()
  drawer.add('title', drawTitle)
  drawer.add('start_button', drawStartButton)
end


function setGameDraw()
  drawer.remove('start_button')
  drawer.remove('winner')
  drawer.add('game', function() drawGame(game, hover_spot) end)
end


function setWinnerDraw(winningPlayerNum)
  drawer.remove('game')
  drawer.add('winner', function() drawWinner(winningPlayerNum) end)
  start_button.text = 'RESTART'
  game = nil
  drawer.add('start_button', function() start_button:draw() end)
end

