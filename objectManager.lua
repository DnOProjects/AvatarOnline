local objMan = {}

local objects = "unbound"

function objMan.bind(objectContainer) objects = objectContainer end --sets objects to refer to a table
function objMan.unbind() objects =  "unbound" end --clears reference for safety
function objMan.addObject(object)
  object.id = #objects+1 --Defaults to expanding the list
  for i=1,#objects do --Search for removed (trash) objects to overwrite
    if objects[i].trash then
      object.id = i
      break
    end
  end
  objects[object.id] = object
end
function objMan.removeObject(id) objects[id].trash = true end
function objMan.clearTrash()
  for i=#objects,1,-1 do
    if objects[i].trash then table.remove(objects,i)
    else break end
  end
end

return objMan
