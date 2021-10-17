-- From => http://lua-users.org/wiki/InheritanceTutorial

function Extend(baseClass)

  local newClass = {}
  local classMt  = { __index = newClass }

  function newClass:create()
    local newInst = {}
    setmetatable( newInst, classMt )
    return newInst
  end

  if nil ~= baseClass then
    setmetatable( newClass, { __index = baseClass } )
  end

  -- Implementation of additional OO properties starts here --

  -- Return the class object of the instance
  function newClass:class()
    return newClass
  end

  -- Return the super class object of the instance
  function newClass:superClass()
    return baseClass
  end

  -- Return true if the caller is an instance of theClass
  function newClass:isa(theClass)
    
    local b_isa = false

    local curClass = newClass

    while (nil ~= curClass) and (false == b_isa) do
      if curClass == theClass then
        b_isa = true
      else
        curClass = curClass:superClass()
      end
    end

    return b_isa

  end

  return newClass
end