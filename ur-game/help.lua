

function map(array, func)
  local new_array = {}
  for i,v in pairs(array) do
    new_array[i] = func(v, i)
  end
  return new_array
end


function forEach(array, func)
  for i,v in pairs(array) do
    func(v, i)
  end
end


function mapEntries(obj, func)
  local new_object = {}
  for i,v in ipairs(obj) do
    new_object[i] = func(v, i)
  end
  return new_object
end


local identity = function (v) return v end


function extend(dest, source)
  -- map old stuff on
  local new_array = copy(dest)

  -- map new stuff on
  map(source, function(v, i)
    new_array[i] = v;
  end)

  return new_array
end


function copy(array)
  return map(array, identity)
end


function mapRepeat(times, func)
  local new_array = {}
  for i = 1, times do
    new_array[i] = func(i)
  end
  return new_array
end


function repeatValue(times, value)
  local new_array = {}
  for i = 1, times do
    new_array[i] = value
  end
  return new_array
end


function find(array, func)
  for i,v in pairs(array) do
    if func(v, i, array) then
      return v, i
    end
  end
  return false
end


function findValue(array, value)
  for i,v in pairs(array) do
    if v == value then
      return v, i
    end
  end
  return false
end


function filter(array, func, indicies)
  if not func then
    func = identity
  end
  local new_array = {}
  for i,v in pairs(array) do
    if func(v, i) then
      if indicies then
        new_array[#new_array + 1] = i
      else
        new_array[#new_array + 1] = v
      end
    end
  end
  return new_array
end


function reduce(array, func, start)
  local ac
  if start then
    ac = start
    for i,v in pairs(array) do
      ac = func(ac, v, i)
    end
  else
    ac = array[1]
    for i = 2, #array do
      ac = func(ac, array[i], i)
    end
  end

  return ac
end


function some(array, func)
  for i,v in pairs(array) do
    if func(ac, v, i) then
      return true
    end
  end
  return false
end


function every(array, func)
  for i,v in pairs(array) do
    if not func(v, i) then
      return false
    end
  end
  return true
end


function equals(value)
  return function(v)
    return v == value
  end
end


function notEquals(value)
  return function(v)
    return v ~= value
  end
end


function equalsAtIndex(value, index)
  return function(v)
    return v[index] == value
  end
end


function switch(value, options)
  local func = options[value]
  if not func then
    if options.default then
      return options.default(value)
    else
      return nil
    end
  else
    return func(value)
  end
end


function enum(keywords)
  local i = 1
  return reduce(keywords, function(ac, next)
    ac[next] = i
    i = i + 1
    return ac
  end, {})
end


function add(a, b) return a + b end
function sum(nums)
  return reduce(rolls, add)
end

