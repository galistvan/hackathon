require 'AI.enemyInSight'
require 'Shooter.shoot'

function makeDecision(marine, nearestEnemy, nearestWeapon) 
  local action = {}
  if(marine.Health-marine.Wounds<=2) then
    action[1]="heal"
    action[2]=""
    action[3]="sprint"
  else
    if (lengthOfArray(marine.Inventory) <= 2 or nearestEnemy == nil) then
        action[1]="pickUpWeapon"
        action[2]="";
        action[3]="sprint"
      elseif(enemyInSight(marine, nearestEnemy) <= 0) then 
        -- check if 4 movement enables LOS
        -- if it does, move and shoot
        -- we can also wait and aim to have a better shot at it or dodge, depending on our health/his weapon
        action[1]="move"
        action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
        action[3]="sprint"
      else
        if(getEffectiveRange(marine) > enemyInSight(marine, nearestEnemy)) then  
          action[1]="attack"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="unload"
        else 
          action[1]="movetokill"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="advance"
        end
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