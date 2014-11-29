function equipWeapon(marine, x, y, availableWeapons)
  Command = {}
  equipWeaponsCommand = equipWeapons(marine, x, y, availableWeapons)
	table.insert(Command, equipWeaponsCommand)
	return Command
	

end

function shootWeapon(marine, x, y)
  attackCommand = {Command = "attack", Aimed = false, Target = { X = x, Y = y } }
  return attackCommand
end

function equipWeapons(marine, x, y, availableWeapons)	
  local Command = {}
	listofWeapons = {"w_bfg", "w_plasma", "w_chaingun", "w_shotgun", "w_machinegun", "w_pistol", "w_chainsaw", "w_hand"}
	for k, v in ipairs(listofWeapons) do
		if inTable(marine.Inventory, v)	then
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

function getMaximumRange(marine, availableWeapons)
  maxRange = 1
  for k,v in ipairs(marine.Inventory) do
    currentRange = returnWeaponRange(v, marine)
    if currentRange > maxRange then
      maxRange = currentRange
    end
  end
  return maxRange
end

-- fix for csapattiszt
function returnWeaponRange(weapon, marine)
  if(weapon == "grenade") then
    return 6+marine.Accuracy
  elseif(weapon == "w_bfg") then
    return 15+marine.Accuracy
  elseif(weapon == "w_plasma") then
    return 10+marine.Accuracy
  elseif(weapon == "w_chaingun") then
    return 9
  elseif(weapon == "w_shotgun") then
    return 4
  elseif(weapon == "w_machinegun") then
    return 8+marine.Accuracy
  elseif(weapon == "w_pistol") then
    return 7+marine.Accuracy
  else
    return 1
  end

end