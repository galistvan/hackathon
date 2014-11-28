function makeDecision(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) 
  local action = {}
    if (lengthOfArray(availableWeapons) <= 1) then
        action[1]="pickUpWeapon"
        action[2]="";
      elseif(not enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon)) then 
        action[1]="move"
        action[2]=enemyCoordinates(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon)
      else
        action[1]="attack"
        action[2]=enemyCoordinates(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon)
      end
  return action
end