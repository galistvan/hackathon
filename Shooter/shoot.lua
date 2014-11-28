function shoot(marine, x, y, availableWeapons)
  command = {}
	valami = {}
	attackCommand = {Command = "attack", Aimed = false, Target =  {X = x, Y = y}}
	valami = equipWeapons(availableWeapons)
	command[1] = valami
	command[2] = attackCommand
	return command
	

end

function equipWeapons(availableWeapons)	
	listofWeapons = {"w_bfg", "w_plasma", "w_chaingun", "w_shotgun", "w_machinegun", "w_pistol", "w_chainsaw", "w_hand"}
	for k, v in ipairs(listofWeapons) do
		if inTable(availableWeapons, v)	then
			print ("Equipped weapon " .. v)
			return {Command = "select_weapon", Weapon = v}
		end
	end
end

function inTable(tbl, item)
    for k, value in ipairs(tbl) do
        if value == item then return value end
    end
    return false
end