local Object = Class:new({pos=Vec()})

function Object:getDrawData() return {} end --blank function to be overridden
function Object:getClientData()
  local data = self:getDrawData()
  data.trash = self.trash --include trash
  return data
end

return Object
