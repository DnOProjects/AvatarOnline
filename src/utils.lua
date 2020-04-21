local utils = {}

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

function utils.round(x, dp)
  local mult = 10^(dp or 0)
  return math.floor(x * mult + 0.5) / mult
end

return utils
