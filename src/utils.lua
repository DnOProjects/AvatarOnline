local utils = {}

function utils.inBounds(point, rect)
    if (point[1] > rect[1] and point[1] < rect[1] + rect[3] and point[2] > rect[2] and point[2] < rect[2] + rect[4]) then
        return true
    end
    return false
end

function utils.print(x,title,indent)
  local indent,title = indent or '',title or 'Variable'
  if type(x)=="table" then
    if x.getText then print(indent..title..': '..x:getText())
    else
      print(indent..title..': ')
      for k,v in pairs(x) do utils.print(v,k,indent..'  ') end
    end
  else print(indent..title..': '..tostring(x)) end
end

function utils.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function utils.inList(var, list)
    for i=1,#list do
        if var == list[i] then
            return true
        end
    end
    return false
end

function utils.copy(x)
    local copy
    if type(x) == 'table' then --if table
        copy = {}
        for k, v in next, x, nil do
            copy[utils.copy(k)] = utils.copy(v)
        end
        setmetatable(copy, utils.copy(getmetatable(x)))
    else -- number, string, boolean, etc
        copy = x
    end
    return copy
end

function utils.degreesToRadians(degrees)
    return degrees * (math.pi/180)
end

return utils
