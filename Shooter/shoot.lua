function equipWeapon(marine, x, y, availableWeapons)
  Command = {}
  equipWeaponsCommand = equipWeapons(availableWeapons)
	table.insert(Command, equipWeaponsCommand)
	return Command
	

end

function shootWeapon(marine, x, y)
  attackCommand = {Command = "attack", Aimed = false, Target = { X = x, Y = y } }
  return attackCommand
end

function equipWeapons(availableWeapons)	
  local Command = {}
	listofWeapons = {"w_bfg", "w_plasma", "w_chaingun", "w_shotgun", "w_machinegun", "w_pistol", "w_chainsaw", "w_hand"}
	for k, v in ipairs(listofWeapons) do
		if inTable(availableWeapons, v)	then
			print ("SHOOT:Equipped weapon " .. v)
			equipWeaponLocalCommand = {Command = "select_weapon", Weapon = v};
			return equipWeaponLocalCommand
		end
	end
end

function inTable(tbl, item)
    for k, value in ipairs(tbl) do
        if value == item then return value end
    end
    return false
end