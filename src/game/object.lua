local Object = Class:new({
  pos=Vec(),
  hitR=0 --radius in px. when drawn without any scaling for the hitcircle (hitbox but circular)
})

--blank functions to be overridden
function Object:getDrawData() return {} end
  function Object:onCreate() end


function Object:getClientData()
  local data = self:getDrawData()
  data.trash = self.trash --include trash
  return data
end

return Object
