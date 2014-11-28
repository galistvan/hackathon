function shoot(marine, x, y, availableWeapons)
	return {equipWeapons(availableWeapons), {Command = "attack", Aimed = false, Traget =  {X = x, Y = y}}}
	

end

function equipWeapons(availableWeapons)	
	listofWeapons = {"w_bfg", "w_plasma", "w_chaingun", "w_shotgun", "w_machinegun", "w_pistol", "w_chainsaw", "w_hand"}
	for i = 8, 1 do
		if inTable(availableWeapons, listofWeapons[i])	then
			print ("Equipped weapon" .. listofWeapons[i])
			return {Command = "select_weapon", Weapon = listofWeapons[i]}
		end
	end
end

function inTable(tbl, item)
    for value in tbl do
        if value == item then return key end
    end
    return false
end