local objMan = {}

function objMan.addObject(object,append) --append is an optional arguement, preventing the overwriting of trash objects
  object.id = #Objects+1 --Defaults to expanding the list
  if not append then
    for i=1,#Objects do --Search for removed (trash) objects to overwrite
      if Objects[i].trash then
        object.id = i
        break
      end
    end
  end
  Objects[object.id] = object
end
function objMan.removeObject(id) Objects[id].trash = true end
function objMan.clearTrash()
  for i=#Objects,1,-1 do
    if Objects[i].trash then table.remove(Objects,i)
    else break end
  end
end

return objMan
