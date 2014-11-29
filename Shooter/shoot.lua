function equipWeapon(marine, x, y)
  Command = {}
  equipWeaponsCommand = equipWeapons(marine, x, y)
	table.insert(Command, equipWeaponsCommand)
	return Command
	

end

function shootWeapon(marine, x, y)
  local canDoAimed = marine.CanDoAimed;
  print(marine.Id .. " Is going for an aimed shot!!!")
  attackCommand = {Command = "attack", Aimed= canDoAimed, Target = { X = x, Y = y } }
  if marine.AttackPoints <1 then 
  return {}
  end  
  return attackCommand
end

function equipWeapons(marine, x, y)	
  local Command = {}
	listofWeapons = {"w_bfg", "w_plasma", "w_grenade", "w_shotgun", "w_chaingun", "w_machinegun", "w_pistol", "w_chainsaw", "w_hand"}
	for k, v in pairs(listofWeapons) do
		if inTable(marine.Inventory, v) and not inTableB(marine.removedWeapons, v)	then
		  if(v == "w_grenade" and getDistance(marine,x,y) > 2) then
        print ("SHOOT:Equipped weapon " .. v)
        table.insert(marine.removedWeapons, v)
        return {Command = "select_weapon", Weapon = v}
		  else
		    print("Distance to enemy: " .. getDistance(marine,x,y) .. "Effective range for " .. v .. " is ".. returnWeaponRange(v, marine))
		    if(getDistance(marine,x,y) < returnWeaponRange(v, marine)) then
  			  print ("SHOOT:Equipped weapon " .. v)
          table.insert(marine.removedWeapons, v)
  			  return {Command = "select_weapon", Weapon = v}
			  else
          print ("SHOOT:Defaulting to pistol ")
          marine.shouldGoForWeapons = true
          table.insert(marine.removedWeapons, v)
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

function inTableB(tbl, item)
    for k, value in pairs(tbl) do
        if value == item then return k end
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
  if(marine.isSniper) then
    baseAccuracy = 3
  else
    baseAccuracy = 0
  end
  if(weapon == "w_grenade") then
    return 5+baseAccuracy-1
  elseif(weapon == "w_bfg") then
    return 15+baseAccuracy-2
  elseif(weapon == "w_plasma") then
    return 10+baseAccuracy-1
  elseif(weapon == "w_chaingun") then
    return 9+baseAccuracy-3
  elseif(weapon == "w_shotgun") then
    return 4+baseAccuracy-1
  elseif(weapon == "w_rocketlauncher") then
    return 10+baseAccuracy-3
  elseif(weapon == "w_machinegun") then
    return 8+baseAccuracy-1
  elseif(weapon == "w_pistol") then
    return 7+baseAccuracy-4
  else
    return 1
  end

end


