
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

function getNearestEnemy(marineEntity)
	gameEntities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
	nearestEnemy = nil
	shortestPath = -1
	enemies = {}
	for _, v in pairs(gameEntities) do
		if isEnemy(v) then
			--print("weapon found " .. tostring(v.Type))
			if nearestEnemy == nil then
				nearestEnemy = v
				print(tostring(marineEntity))
				print(tostring(v.Bounds.X))
				print(tostring(v.Bounds.Y))
				shortestPath = Game.Map:get_move_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
			else
		 		local currentPath = Game.Map:get_move_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
				--print (lengthOfArray(currentPath))
				if lengthOfArray(currentPath) < lengthOfArray(shortestPath) then
					nearestEnemy = v
					shortestPath = currentPath
				end
			end
		end
	end
	--print("marine: " .. marineEntity.Bounds.X, marineEntity.Bounds.Y)
	--print("weapon: " .. nearestWeapon.Bounds.X, nearestWeapon.Bounds.Y)
	--print("path = " .. lengthOfArray(shortestPath))
	return nearestEnemy
end

function isEnemy(entity)
	if	entity.Type == "marine"  then
	
			print(entity.id)
			return true
	else
			return false
	end
end

function lengthOfArray(t)
	count = 0
	for k,v in pairs(t) do
			count = count + 1
	end
	return count 
end