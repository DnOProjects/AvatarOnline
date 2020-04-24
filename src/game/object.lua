local Object = Class:new({
  pos=Vec(),
  hitR=0 --radius in px. when drawn without any scaling for the hitcircle (hitbox but circular)
})

--blank functions to be overridden
function Object:getDrawData() return {} end
function Object:onCreate() end
function Object:onTouches(object) end
function Object:onLeaves(object) end

function Object:getClientData()
  local data = self:getDrawData()
  data.trash = self.trash --include trash
  return data
end
function Object:touching(object) return self.pos..object.pos < (object.hitR+self.hitR) end
function Object:updateTouches()
  if not self.currentlyTouching then self.currentlyTouching = {} end --creates table if doesnt exist
  for i, object in ipairs(Objects) do --Add touching objects
      if self:touching(object) and (not utils.inList(object.id,self.currentlyTouching)) then
        table.insert(self.currentlyTouching,object.id)
        self:onTouches(object)
      end
  end
  for i=#self.currentlyTouching,1,-1 do --Remove touching objects
    local object = Objects[self.currentlyTouching[i]]
    if not self:touching(object) then
      table.remove(self.currentlyTouching,i)
      self:onLeaves()
    end
  end
end

return Object
