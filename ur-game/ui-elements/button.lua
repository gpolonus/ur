

local createButton = function (x, y, width, height, text, font_size, color, bg_color)
  return {
    x = x,
    y = y,
    width = width,
    height = height,
    text = text,
    font_size = font_size,
    font = love.graphics.newFont(font_size),
    color = color and color or {1, 1, 1},
    bg_color = bg_color and bg_color or {0, 0, 0},
    draw = draw,
    mouseOnButton = mouseOnButton,
    drawHover = drawHover,
    drawRegular = drawRegular
  }
end


function draw(self, isHover)
  love.graphics.setFont(self.font)
  if(isHover) then
    drawHover(self)
  else
    drawRegular(self)
  end
end


function drawRegular(self)
  love.graphics.setColor(self.bg_color[1], self.bg_color[2], self.bg_color[3])
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(self.color[1], self.color[2], self.color[3])
  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  drawText(self)
end


function drawHover(self)
  love.graphics.setColor(self.color[1], self.color[2], self.color[3])
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(self.bg_color[1], self.bg_color[2], self.bg_color[3])
  drawText(self)
end


function drawText(self)
  love.graphics.printf(self.text, self.x, self.y + self.height / 2 - self.font_size / 2, self.width, 'center')
end


function mouseOnButton(self, x, y)
  return self.x <= x and x <= self.x + self.width and self.y <= y and y <= self.y + self.height
end

-- This is great for lines of slope not 0 and will be useful later
-- doesnt check for if it is on the line
-- 0 for incorrect
-- greater than 0 for correct
function onSideOfLine(m, b, side, x1, y1)
  -- m: slope
  -- b: y-intercept
  -- side: above or below the line
    -- (-1) for below
    -- 1 for above

  local val = m * x1 + b - y1
  return math.abs(val) + side * val
end


return createButton

