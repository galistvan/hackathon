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
	goodMovePath = checkLastPointAvailableMed(marine, movePath)
    return { Command = "move", Path = goodMovePath  }
	
end


function getFirstNItemsFromList(n, list)
  resultList = {}
  for i=1,n do 
    table.insert(resultList,list[i])
  end
  return resultList
end

function checkLastPointAvailableMed(marine, movePath)
	if movePath == nil then
		return {}
	end
	
	if #movePath == 0 then
		return {}
	end
	
	local pathLength = #movePath
	print("MOVEPATH 1.X :"..movePath[1].X)
	print("MOVEPATH length :"..pathLength)
	for k,v in pairs(Game.Map:get_entities("marine")) do
		if v.Bounds.X == movePath[pathLength].X and  v.Bounds.Y == movePath[pathLength].Y then
	--		local vane = Game.Map:get_move_path(marine.Id,movePath[#movePath].X,movePath[#movePath].Y)
			--if #vane <=0 then
				table.remove(movePath,pathLength)
				print("Removed : "..#movePath)
			end
		end		
	--end
	return movePath
end