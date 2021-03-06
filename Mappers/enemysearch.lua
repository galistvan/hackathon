
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


-- rewrite to calculate LOS rules please
function getNearestEnemy(marineEntity, ownMarines)
	gameEntities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
	nearestEnemy = nil
	shortestPath = -1
	enemies = {}
	for _, v in pairs(gameEntities) do
		if isEnemy(ownMarines,v,marineEntity) then
			if nearestEnemy == nil then
				nearestEnemy = v
				shortestPath = Game.Map:get_attack_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
			else
		 		local currentPath = Game.Map:get_attack_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
				if lengthOfArray(currentPath) < lengthOfArray(shortestPath) then
					nearestEnemy = v
					shortestPath = currentPath
				end
			end
		end
	end
	return nearestEnemy
end

function lengthOfArray(t)
	count = 0
	for k,v in pairs(t) do
			count = count + 1
	end
	return count 
end

function isEnemy(tbl, item, ownMarine)
	if item.Type ~= ownMarine.Type then
		return false
	end
	if item.Id == ownMarine.Id then
		return false
	end
	for i, v in pairs(tbl) do 
		if v == item.Id then 
			return false
		end
	end
    return true
end