Class = {type='class'}

function Class:new(type,args)--[[
Used both for inheritance and instanciation
Returns args or {}, with metatable set to {__index = self} where self is the parent class e.g Parent:new()
    This makes it so when indexing the new table, if the table has no value, it will look in the parent table.
    This variable inheritance includes functions and therefore this Class:new() function.
]]
    local new = args or {}
    local metatable = {__index = self}
    if args~=nil and args.meta~=nil then --add more metatable values
      for k,v in pairs(args.meta) do metatable[k] = v end
    end
    setmetatable(new,metatable)
    new.type = type
    return new --WARNING: changing an inherited table by index alters it for parent and all children
end						--So be super carefull when having classes contain tables
function Class:obj(args)
  local new = args or {}
  local metatable = {__index = self}
  for k,v in pairs(getmetatable(self)) do
    if k~='__index' then metatable[k]=v end
  end
  setmetatable(new,metatable)
  new.new, new.obj = nil,nil --removes capapility to make new classes
  new.class = new.type --so type access does not use metatables thus can be serialised
  return new
end
