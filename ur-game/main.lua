
require 'help'
require 'colors'
require 'drawing'
local Game = require 'game'
local Spot = require 'spot'
local class = require 'class'


local game
local hover_spot
local hover_spot_num
local total_roll_num = 0


-- love framework functionality

function love.load()
  -- called exactly once at the beginning of the game
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end

  love.graphics.setLineWidth(2)

  love.window.setTitle('Royal Game of Ur')

  math.randomseed( os.time() )

  game = Game:new()

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
    if game.spaces_to_move == 0 or #game.movable_spots == 0 then
      game:setNextPlayer()
    elseif not game:movePieceOnSpot(hover_spot) then
      -- some sort of error
    else
      hover_spot_num = nil
      set_hover_spot(-1)
    end
  end

}


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
  if game:isStart() then

  elseif game:isRolling() then
    if key == 'return' then
      game:roll()
      total_roll_num = total_roll_num + 1
      if #game.movable_spots > 0 then
        set_hover_spot(1)
      end
    end
  elseif game:isMoving() then
    switch(key, keyMap)
  end

end


-- function love.update(dt)

-- end


function love.draw()
  drawGame(game, hover_spot)
end

