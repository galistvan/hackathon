
function doWeaponPickUp(marine, marineEntity, nearestWeapon)
  if (isStandAboveAWeapon(marineEntity))then
   return { Command = "pickup" }
  end
  local weaponPath = Game.Map:get_move_path(marineEntity.Id, nearestWeapon.Bounds.X, nearestWeapon.Bounds.Y)
  local movePath = getFirstNItemsFromList(marineEntity.MovePoints, weaponPath)
  return { Command = "move", Path = movePath  }
end

function printAllEntities()
	local entities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
	for k, v in pairs(entities) do
		printEntity(v)
	end
end


function printEntity(entity)
	print("----")
	print("Id: " .. tostring(entity.Id))
	print("BlocksSight: " .. tostring(entity.BlocksSight))
	print("Type: " .. tostring(entity.Type))
	print("Bounds: X: " .. marine.Bounds.X .. ", Y: " .. marine.Bounds.Y .. ", Width: " .. marine.Bounds.Width .. ", Height: " .. marine.Bounds.Height )
	print("IsActive: " .. tostring(entity.IsActive))
	print("BlocksPath: " .. tostring(entity.BlocksPath))
end

function getAllUnOwnedWeapons(marineEntity)
  local gameEntities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
  local weapons = {}
  for _, v in pairs(gameEntities) do
    if isWeapon(v) and not isIHaveThatWeapon(v, marineEntity) then
      table.insert(weapons, v)
    end
  end
  return weapons
end

function getNearestWeapon(marineEntity)
  local weapons = getAllUnOwnedWeapons(marineEntity)
--  print(marineEntity.Id)
--  for _, v in pairs(weapons) do print(v.Type, v.Bounds.X, v.Bounds.Y) end
--  print("-----")
  local nearestWeapon = weapons[1]
  local shortestPath = Game.Map:get_move_path(marineEntity.Id, nearestWeapon.Bounds.X, nearestWeapon.Bounds.Y)
  local shortestDistance = #shortestPath
  for _, v in pairs(weapons) do
    local currentPath = Game.Map:get_move_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
    local baseDistance = #currentPath
    local weightedDistance = #currentPath - weaponUberness(v.Type)
    if weightedDistance < shortestDistance and lengthOfArray(currentPath) > 0 and not isIHaveThatWeapon(v, marineEntity) then
      nearestWeapon = v
      shortestDistance = weightedDistance
    end
  end
	return nearestWeapon
end

function isWeapon(entity)
	if	--entity.Type == "w_chainsaw" or
		entity.Type == "w_machinegun" or
		entity.Type == "w_shotgun" or
		entity.Type == "w_plasma" or
		entity.Type == "w_rocketlauncher" or
		entity.Type == "w_bfg" or
		entity.Type == "w_grenade" then
			return true
	else
			return false
	end
end

function getFirstNItemsFromList(n, list)
  local resultList = {}
  for i=1,n do 
    table.insert(resultList,list[i])
  end
  return resultList
end

function isStandAboveAWeapon(marine) 
  local entities = Game.Map:entities_in(marine.Bounds.X, marine.Bounds.Y, 1, 1)
  for _, v in pairs(entities) do
    if isWeapon(v) then
      return true
    end
  end
  return false
end

function isIHaveThatWeapon(nearestWeapon, marineEntity) 
  for k,v in pairs(marineEntity.Inventory) do
    if k == nearestWeapon.Type then
      return true
    end
  end
  return false
end


function lengthOfArray(t)
  count = 0
  for k,v in pairs(t) do
      count = count + 1
  end
  return count 
end

function weaponUberness(weapon)
  if(weapon == "grenade") then
    return 2
  elseif(weapon == "w_bfg") then
    return 14
  elseif(weapon == "w_plasma") then
    return 12
  elseif(weapon == "w_rocketlauncher") then
    return 10
  elseif(weapon == "w_chaingun") then
    return 4
  elseif(weapon == "w_shotgun") then
    return 3
  elseif(weapon == "w_machinegun") then
    return 5
  elseif(weapon == "w_pistol") then
    return 1
  else
    return 1
  end
end