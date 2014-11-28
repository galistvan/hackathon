
function doWeaponPickUp(marine, marineEntity, nearestWeapon)
    if (isStandAboveAWeapon(marineEntity) and not marine:isIHaveThatWeapon(nearestWeapon))then
      return { Command = "pickup" }
    end
    weaponPath = Game.Map:get_move_path(marineEntity.Id, nearestWeapon.Bounds.X, nearestWeapon.Bounds.Y)
    movePath = getFirstNItemsFromList(marineEntity.MovePoints, weaponPath)
    print(lengthOfArray(movePath))
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

function getNearestWeapon(marineEntity)
	gameEntities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
	nearestWeapon = nil
	shortestPath = -1
	print("searching nearest weapon...")
	for _, v in pairs(gameEntities) do
		if isWeapon(v) then
			if nearestWeapon == nil then
				currentPath = Game.Map:get_move_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
				if lengthOfArray(currentPath) > 0 then
					nearestWeapon = v
					shortestPath = currentPath
				end 
			else
		 		local currentPath = Game.Map:get_move_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
				if lengthOfArray(currentPath) < lengthOfArray(shortestPath) and lengthOfArray(currentPath) > 0 then
					nearestWeapon = v
					shortestPath = currentPath
				end
			end
		end
	end
	print("nearest weapon: " .. nearestWeapon.Type .. " (X:".. nearestWeapon.Bounds.X  .. ",Y:"..  nearestWeapon.Bounds.Y .. "), path length:" .. lengthOfArray(shortestPath))
	return nearestWeapon
end

function isWeapon(entity)
	if	entity.Type == "w_chainsaw" or
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
  resultList = {}
  for i=1,n do 
    table.insert(resultList,list[i])
  end
  return resultList
end

function isStandAboveAWeapon(marine) 
  entities = Game.Map:entities_in(marine.Bounds.X, marine.Bounds.Y, 1, 1)
  for _, v in pairs(entities) do
    if isWeapon(v) then
      print("we are standing above weapon: " .. v.Type)
      return true
    end
  end
  return false
end
