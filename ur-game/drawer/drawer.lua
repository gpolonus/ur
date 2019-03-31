

local call_draw_func = function(f) f.draw() end

local list = {}

local drawer = {

  draw = function()
    forEach(list, call_draw_func)
  end,

  add = function(name, func)
    list[#list + 1] = {
      name = name,
      draw = func
    }
  end,

  remove = function(name)
    list = filter(list, function(drawInfo)
      return drawInfo.name ~= name
    end)
  end
}


return drawer
