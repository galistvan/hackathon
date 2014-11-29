require 'AI.enemyInSight'
require 'Shooter.shoot'

function makeDecision(marine, nearestEnemy, nearestWeapon) 
  local action = {}
    if (lengthOfArray(marine.Inventory) <= 2) then
        action[1]="pickUpWeapon"
        action[2]="";
        action[3]="sprint"
      elseif(enemyInSight(marine, nearestEnemy, nearestWeapon) <= 0) then 
        action[1]="move"
        action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
        action[3]="advance"
      else
        if(getMaximumRange(marine) > enemyInSight(marine, nearestEnemy, nearestWeapon)) then  
          action[1]="attack"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="unload"
        else 
          action[1]="move"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="advance"
        end
      end
  return action
end

function lengthOfArray(t)
  count = 0
  for k,v in pairs(t) do
      count = count + 1
  end
  return count 
end