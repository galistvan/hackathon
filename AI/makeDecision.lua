require 'AI.enemyInSight'

function makeDecision(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) 
  local action = {}
    if (lengthOfArray(availableWeapons) <= 1) then
        action[1]="pickUpWeapon"
        action[2]="";
        action[3]="sprint"
          print("Going for weapon!")
      elseif(enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) <= 0) then 
        action[1]="move"
        action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
        action[3]="advance"
          print("moving towards enemy! Range: " .. enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) .. "Coords: " .. nearestEnemy.Bounds.X .. ":" .. nearestEnemy.Bounds.Y)
      else
        if(getMaximumRange(marine, availableWeapons, availableAmmo) > enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon)) then  
          action[1]="attack"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="guard"
          print("Attacking!! Range: " .. enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon) .. "WeaponRange: " .. getMaximumRange(marine, availableWeapons, availableAmmo))
        else 
          action[1]="move"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="advance"
          print("Should move towards and KEEL! Weapon range: " .. getMaximumRange(marine, availableWeapons, availableAmmo) .. " Enemy range: " .. enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon))
        end
      end
  return action
end