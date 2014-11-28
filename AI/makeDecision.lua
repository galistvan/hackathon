function makeDecision(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) 
  local action = ""
    if (lengthOfArray(availableWeapons) <= 1) then
        action="pickUpWeapon"
      else
        action="attack"
      end
  return action
end