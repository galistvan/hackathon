--meg hianyzik, hogyha MedKit-en vagy MegaHealth-n all akkor felvegye es hasznalja

function getHealth(marine)
	medkit = Game.Map:get_entities("i_medkit")
	megahealth = Game.Map:get_entities("i_megahealth")
	env_health = Game.Map:get_entities("env_heal")
	minLength = 100
	minPath = nil
	
	print("MedKit count:"..#medkit)
	if #medkit > 0 then
		for k,v in ipairs(medkit) do
			pathToMedkit =  Game.Map:get_move_path(marine.Id, v.Bounds.X, v.Bounds.Y)
			i = #pathToMedkit
			print("pathToMedkit length :"..i) 
			if (minLength > i and i>0) then
				minLength = i
				minPath = pathToMedkit
			end
		end
	end

	print("Mega Health count:"..#megahealth)	
	if #megahealth > 0 then
		for k,v in ipairs(megahealth) do
			pathToMegaHealth =  Game.Map:get_move_path(marine.Id, v.Bounds.X, v.Bounds.Y)
			i = #pathToMegaHealth
			print("pathToMegaHealth length :"..i) 
			if (minLength > i and i>0) then
				minLength = i
				minPath = pathToMegaHealth
			end
		end
	end
	
	print("Env health count:"..#env_health)
	if #env_health > 0 then
		if minLength > 24 then
			for k,v in ipairs(env_health) do
				pathToEnvHealth = Game.Map:get_move_path(marine.Id, v.Bounds.X, v.Bounds.Y)
				i = # pathToEnvHealth
				print("pathToEnvHealth length :"..i) 
				if (minLength > i and i>0) then
					minLength = i
					minPath = pathToEnvHealth
				end
			end
		end
	end
	
	movePath = getFirstNItemsFromList(marine.MovePoints, minPath)
    return { Command = "move", Path = movePath  }
	
end


function getFirstNItemsFromList(n, list)
  resultList = {}
  for i=1,n do 
    table.insert(resultList,list[i])
  end
  return resultList
end