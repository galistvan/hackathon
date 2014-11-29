require 'AI.enemyInSight'
require 'Shooter.shoot'

function makeDecision(marine, nearestEnemy, nearestWeapon)
  local action = {}
  if(marine ~= nil) then
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
          local movePath = determineAttackPath(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
		  if #movePath == 0 then
                action[1]="moveandaim"
                action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
                action[3]="ready"
                action[4]=finalMovePath
		  else
          local finalMovePath = reformMovePath(movePath, marine, nearestEnemy)
            local finalDestination = finalMovePath[#finalMovePath]
            if(Game.Map:cell_has_los(finalDestination.X, finalDestination.Y, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y, "ObstaclesAndEntities")) then
              if(lengthOfArray(finalMovePath) <= 0 and Game.Map:entity_has_los(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)) then
                action[1]="movetokill"
                action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
                action[3]="advance"
                action[4]=finalMovePath
              else
                action[1]="moveandaim"
                action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
                action[3]="ready"
                action[4]=finalMovePath
              end
            else
              action[1]="moveandaim"
              action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
              action[3]="ready"
              action[4]=finalMovePath
            end
			end
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
            action[4]=reformMovePath(movePath, marine, nearestEnemy)
          end
        end
      else
        if(getEffectiveRange(marine) > enemyInSight(marine, nearestEnemy)) then
          if(enemyInSight(marine, nearestEnemy) < 3 and enemyInSight(marine, nearestEnemy) > -1 ) then
            local movePath = determineRetreatPath(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
            if(#movePath == 0 and enemyInSight(marine, nearestEnemy) == -1) then
              action[1]="pickUpWeapon"
              action[2]="";
              action[3]="sprint"
            else
              action[1]="backandkill"
              action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
              action[3]="advance"
              action[4]=reformMovePath(movePath, marine, nearestEnemy)
            end
          else
            action[1]="attack"
            action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
            action[3]="unload"
          end
        else
          local movePath = determineAttackPath(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
          if(#movePath == 0 and enemyInSight(marine, nearestEnemy) == -1) then
            action[1]="pickUpWeapon"
            action[2]="";
            action[3]="sprint"
          elseif(enemyInSight(marine, nearestEnemy) > 0) then
            action[1]="attack"
            action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
            action[3]="unload"
          elseif(Game.Map:cell_has_los(movePath[marine.MovePoints].X, movePath[marine.MovePoints].Y, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y, "ObstaclesAndEntities")) then
            local finalMovePath = reformMovePath(movePath, marine, nearestEnemy)
            local finalDestination = finalMovePath[#finalMovePath]
            if(Game.Map:cell_has_los(finalDestination.X, finalDestination.Y, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y, "ObstaclesAndEntities")) then
              if(lengthOfArray(finalMovePath) <= 0 and Game.Map:entity_has_los(marine, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)) then
                action[1]="movetokill"
                action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
                action[3]="advance"
                action[4]=finalMovePath
              else
                action[1]="moveandaim"
                action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
                action[3]="ready"
                action[4]=finalMovePath
              end
            else
              action[1]="moveandaim"
              action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
              action[3]="ready"
              action[4]=finalMovePath
            end
          else
            action[1]="move"
            action[2]={nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y}
            action[3]="sprint"
            action[4]=reformMovePath(movePath, marine, nearestEnemy)
          end


        end
      end
    end
  end
  return action
end

function lengthOfArray(t)
  if (t == nil) then
	return 0
  end
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
  local p1 = getFirstNItemsFromList(marine.MovePoints, correctPath)
  local p2 = checkLastPointAvailable(marine, p1)
  return getFirstNItemsFromList(marine.MovePoints, p2)
end

function checkIfMovingOnceEnablesLos(marine, enemy)
  local attackPath = Game.Map:get_attack_path(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
  if(lengthOfArray(attackPath) <= 4) then return true end
  return Game.Map:cell_has_los(attackPath[4].X, attackPath[4].Y, enemy.Bounds.X, enemy.Bounds.Y, "ObstaclesAndEntities")
end

function checkLastPointAvailable(marine, movePath)
	if movePath == nil then
		return {}
	end
	
	if #movePath == 0 then
		return {}
	end
	
	local pathLength = #movePath
	print("MOVEPATH 1.X :"..movePath[1].X)
	print("MOVEPATH length :"..pathLength)
	for k,v in pairs(Game.Map:get_entities("marine")) do
		if v.Bounds.X == movePath[pathLength].X and  v.Bounds.Y == movePath[pathLength].Y then
	--		local vane = Game.Map:get_move_path(marine.Id,movePath[#movePath].X,movePath[#movePath].Y)
			--if #vane <=0 then
				table.remove(movePath,pathLength)
				print("Removed : "..#movePath)
			end
		end		
	--end
	return movePath
end


function reformMovePath(movePath, marine, enemy)
	
	local myLength = #movePath
	print(" BEFORE : ".. myLength)
	
	if myLength == 0 then 
		return movePath
	end
	
	if myLength  > 2 and Game.Map:cell_has_los(movePath[myLength -2].X, movePath[myLength-2].Y, enemy.Bounds.X, enemy.Bounds.Y, "ObstaclesAndEntities") then
		table.remove(movePath,#movePath)
		table.remove(movePath,#movePath)
		return movePath
	end
	
	if myLength  > 1 and Game.Map:cell_has_los(movePath[myLength -1].X, movePath[myLength-1].Y, enemy.Bounds.X, enemy.Bounds.Y, "ObstaclesAndEntities") then
		table.remove(movePath,length)
		return movePath
	end
	
	print(" AFTER : "..#movePath)
 
  return movePath
end
