function makeDecision(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) 
  local action = {}
    if (lengthOfArray(availableWeapons) <= 1) then
        action[1]="pickUpWeapon"
        action[2]="";
        action[3]="sprint"
      elseif(enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) < 0) then 
        action[1]="move"
        action[2]={nearestEnemy.X, nearestEnemy.Y}
        action[3]="advance"
      else
        if(getMaximumRange(marine, availableWeapons, availableAmmo) - enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) > 3) then  
          action[1]="attack"
          action[2]={nearestEnemy.X, nearestEnemy.Y}
          action[3]="guard"
        else
         print("Should move towards and KEEL")
        end
      end
  return action
end