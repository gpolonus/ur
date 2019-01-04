

local typeId = 0


function class(func)
  local obj = {}
  obj.__index = obj

  local tid = typeId
  typeId = typeId + 1

  function obj:tid()
    return tid
  end

  function obj:new(...)
    local o = {}
    o = func(o, ...)
    return setmetatable(o, self)
  end

  return obj
end


-- type metatable
local typeMetatable = {}
typeMetatable.__index = typeMetatable
typeMetatable.__call = function(self, val)
  if val == nil then
    return self.val
  elseif val:tid() == self:tid() then
    self.val = val
  else
    error('Variable of wrong type')
  end
end
function typeMetatable:reset()
  self.val = nil
end


function type(c)
  local t = {}
  function t:tid() return c:tid() end
  return setmetatable(t, typeMetatable)
end


return function()
  return class, type
end

