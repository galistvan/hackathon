function equipWeapon(marine, x, y)
  Command = {}
  equipWeaponsCommand = equipWeapons(marine, x, y)
	table.insert(Command, equipWeaponsCommand)
	return Command
	

end

function shootWeapon(marine, x, y)
  attackCommand = {Command = "attack", Target = { X = x, Y = y } }
  return attackCommand
end

function equipWeapons(marine, x, y)	
  local Command = {}
	listofWeapons = {"w_bfg", "w_plasma", "w_grenade", "w_shotgun", "w_chaingun", "w_machinegun", "w_pistol", "w_chainsaw", "w_hand"}
	for k, v in pairs(listofWeapons) do
		if inTable(marine.Inventory, v)	then
		  if(v == "w_grenade" and getDistance(marine,x,y) > 2) then
        print ("SHOOT:Equipped weapon " .. v)
        return {Command = "select_weapon", Weapon = v}
		  else
		    if(getDistance(marine,x,y) < returnWeaponRange(weapon, marine)) then
  			  print ("SHOOT:Equipped weapon " .. v)
  			  return {Command = "select_weapon", Weapon = v}
			  else
          print ("SHOOT:Defaulting to pistol ")
          return {Command = "select_weapon", Weapon = "w_pistol"}
			  end
			end
		end
	end
end

function inTable(tbl, item)
    for k, value in pairs(tbl) do
        if k == item then return k end
    end
    return false
end

function getEffectiveRange(marine)
  maxRange = 1
  for k,v in pairs(marine.Inventory) do
    currentRange = returnWeaponRange(k, marine)
    if currentRange > maxRange then
      maxRange = currentRange
    end
  end
  return maxRange
end

function hasGrenade(marine)
return inTable(marine.Inventory, "w_grenade")
end

-- fix for csapattiszt
function returnWeaponRange(weapon, marine)
  if(weapon == "grenade") then
    return 6+marine.Accuracy-2
  elseif(weapon == "w_bfg") then
    return 15+marine.Accuracy-4
  elseif(weapon == "w_plasma") then
    return 10+marine.Accuracy-3
  elseif(weapon == "w_chaingun") then
    return 9-3
  elseif(weapon == "w_shotgun") then
    return 4-1
  elseif(weapon == "w_machinegun") then
    return 8+marine.Accuracy-3
  elseif(weapon == "w_pistol") then
    return 7+marine.Accuracy-2
  else
    return 1
  end

end


