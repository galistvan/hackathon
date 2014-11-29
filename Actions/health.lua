--meg hianyzik, hogyha MedKit-en vagy MegaHealth-n all akkor felvegye es hasznalja

function getHealth(marine)
	local medkit = Game.Map:get_entities("i_medkit")
	local megahealth = Game.Map:get_entities("i_megahealth")
	local env_health = Game.Map:get_entities("env_heal")
	local minLength = 100
	local minPath = nil
	
	-- Dani:: only go for heal if you have movePath
	
	if #medkit > 0 then
		for k,v in ipairs(medkit) do
			pathToMedkit =  Game.Map:get_move_path(marine.Id, v.Bounds.X, v.Bounds.Y)
			i = #pathToMedkit
			if (minLength > i and i>0) then
				minLength = i
				minPath = pathToMedkit
			end
		end
	end

	if #megahealth > 0 then
		for k,v in ipairs(megahealth) do
			pathToMegaHealth =  Game.Map:get_move_path(marine.Id, v.Bounds.X, v.Bounds.Y)
			i = #pathToMegaHealth
			if (minLength > i and i>0) then
				minLength = i
				minPath = pathToMegaHealth
			end
		end
	end
	
	if #env_health > 0 then
		if minLength > 24 then
			for k,v in ipairs(env_health) do
				pathToEnvHealth = Game.Map:get_move_path(marine.Id, v.Bounds.X, v.Bounds.Y)
				i = # pathToEnvHealth
				if (minLength > i and i>0) then
					minLength = i
					minPath = pathToEnvHealth
				end
			end
		end
	end
	
	movePath = getFirstNItemsFromList(marine.MovePoints, minPath)
  if(not Game.Map:get_move_path(marineEntity.Id, movePath[lengthOfArray(movePath)].X, movePath[lengthOfArray(movePath)].Y)) then
    table.remove(movePath, lengthOfArray(movePath))
  end
    return { Command = "move", Path = movePath  }
end

function getFirstNItemsFromList(n, list)
  resultList = {}
  for i=1,n do 
    table.insert(resultList,list[i])
  end
  return resultList
end

function lengthOfArray(t)
  count = 0
  for k,v in pairs(t) do
      count = count + 1
  end
  return count 
end