require 'AI.enemyInSight'
require 'Shooter.shoot'

function makeDecision(marine, nearestEnemy, nearestWeapon)
  local action = {}
  if(marine.Health-marine.Wounds<=2) then
    action[1]="heal"
    action[2]=""
    action[3]="sprint"
  else
    if ((lengthOfArray(marine.Inventory) <= 2 or nearestEnemy == nil) or marine.shouldGoForWeapons) then
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
        local movePath = determineAttackPath(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
        if(movePath == -1) then
          print("Marine: " .. marine.Id .. " has No route to enemy, Going for weapon!", "target", nearestEnemy.Id)
          action[1]="pickUpWeapon"
          action[2]="";
          action[3]="sprint"
        else
          action[1]="move"
          action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
          action[3]="sprint"
          action[4]=movePath
        end
      end
    else
      if(getEffectiveRange(marine) > enemyInSight(marine, nearestEnemy)) then
        if(enemyInSight(marine, nearestEnemy) < 3) then
          local movePath = determineRetreatPath(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
          if(#movePath == 0 and enemyInSight(marine, nearestEnemy) == -1) then
            action[1]="pickUpWeapon"
            action[2]="";
            action[3]="sprint"
          else
            action[1]="backandkill"
            action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
            action[3]="advance"
            action[4]=movePath
          end
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

function determineRetreatPath(marine, x, y)
  -- get a position where you still have LOS and is further away
  local retreatXDirection = marine.Bounds.X - x;
  local retreatYDirection = marine.Bounds.Y - y;
  if(retreatXDirection <= 0) then
    retreatXCoords = {marine.Bounds.X -2, marine.Bounds.X -3, marine.Bounds.X -4}
  else
    retreatXCoords = {marine.Bounds.X +2, marine.Bounds.X +3, marine.Bounds.X +4}
  end
  if(retreatYDirection <= 0) then
    retreatYCoords = {marine.Bounds.Y -2, marine.Bounds.Y -3, marine.Bounds.Y -4}
  else
    retreatYCoords = {marine.Bounds.Y +2, marine.Bounds.Y +3, marine.Bounds.Y +4}
  end
  for kx,vx in ipairs(retreatXCoords) do
    for ky,vy in ipairs(retreatYCoords) do
      movePath = Game.Map:get_move_path(marine.Id, vx, vy)
      LOS = Game.Map:cell_has_los(vx, vy, x, y, "ObstaclesAndEntities")
      if(#movePath > 0 and LOS) then
        return movePath
      end
    end
  end
  return {}
end

function determineAttackPath(marine, x, y)
  local currentPath = Game.Map:get_attack_path(marine.Id, x, y)
  if(#currentPath <= 0) then
    return -1
  end
  local lastStep = currentPath[#currentPath-1]
  local correctPath = Game.Map:get_move_path(marine.Id, lastStep.X, lastStep.Y)
  return getFirstNItemsFromList(marine.MovePoints, correctPath)
end

function checkIfMovingOnceEnablesLos(marine, enemy)
  local attackPath = Game.Map:get_attack_path(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
  if(lengthOfArray(attackPath) <= 4) then return true end
  return Game.Map:cell_has_los(attackPath[4].X, attackPath[4].Y, enemy.Bounds.X, enemy.Bounds.Y, "ObstaclesAndEntities")
end
