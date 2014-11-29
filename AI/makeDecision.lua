require 'AI.enemyInSight'
require 'Shooter.shoot'

function makeDecision(marine, nearestEnemy, nearestWeapon)
  local action = {}
  if(marine.Health-marine.Wounds<=2) then
    action[1]="heal"
    action[2]=""
    action[3]="sprint"
  else
    if ((lengthOfArray(marine.Inventory) <= 2 or (lengthOfArray(marine.Inventory) <= 3 and hasGrenade(marine))) or nearestEnemy == nil) then
      action[1]="pickUpWeapon"
      action[2]="";
      action[3]="sprint"
    elseif(enemyInSight(marine, nearestEnemy) <= 0) then
      if(checkIfMovingOnceEnablesLos(marine, nearestEnemy)) then
        action[1] = "movetokill"
        action[2] = {nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
        action[3] = "advance"
      else
        -- we can also wait and aim to have a better shot at it or dodge, depending on our health/his weapon
        action[1]="move"
        action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
        action[3]="sprint"
      end
    else
      if(getEffectiveRange(marine) > enemyInSight(marine, nearestEnemy)) then
        if(enemyInSight(marine, nearestEnemy) < 3) then
          action[1]="backandkill"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="advance"
        else
          action[1]="attack"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="unload"
        end
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

function checkIfMovingOnceEnablesLos(marine, enemy)
  local attackPath = Game.Map:get_attack_path(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
  if(lengthOfArray(attackPath) <= 4) then return true end
  return Game.Map:cell_has_los(attackPath[4].X, attackPath[4].Y, enemy.Bounds.X, enemy.Bounds.Y, "ObstaclesAndEntities")
end
