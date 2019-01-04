

function class(func)
  local obj = {}
  obj.__index = obj

  function obj:new(...)
    local o = {}
    o = func(o, ...)
    return setmetatable(o, self)
  end

  return obj
end


return class

