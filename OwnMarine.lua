require 'Shooter.shoot'
require 'AI.makeDecision'
require 'Mappers.weaponsearch'
require 'Actions.Health'

OwnMarine = class( "Marine" )

function OwnMarine:initialize(player_index, marine_id, instance_index)
  self.player_index = player_index
  self.marine_id = marine_id
  self.instance_index = instance_index
  self.actionMode = "advance"
  self.ownMarines= {}
  table.insert(self.ownMarines,marine_id)
end

function OwnMarine:get_marine()
  local marine,err = Game.Map:get_entity(self.marine_id)
  if (marine == nil) then print (err) end
  return marine
end

function OwnMarine:select_mode()

  local marine = self:get_marine()
  local nearestEnemy = getNearestEnemy(marine,self.ownMarines)
  local nearestWeapon = getNearestWeapon(marine)

  local whatTodo = makeDecision(marine, nearestEnemy, nearestWeapon)
  -- return "sprint"
  -- return "guard"
  -- return "ready"
  print("marine", marine.Id, "set mode to", tostring(whatTodo[3]))
  return whatTodo[3]

end

function OwnMarine:provide_steps(prev)
  local Commands = {}
  local marine = self:get_marine()
  local nearestEnemy = getNearestEnemy(marine,self.ownMarines)
  local nearestWeapon = getNearestWeapon(marine)

  local whatTodo = makeDecision(marine, nearestEnemy, nearestWeapon)

  if whatTodo[1] == "pickUpWeapon" then
    print("Going for weapon!")
    table.insert(Commands, doWeaponPickUp(self, marine, nearestWeapon))
    table.insert(Commands, {Command = "pickup"})
  elseif whatTodo[1] == "heal" then
    print("Going for medkit!")
    table.insert(Commands, getHealth(marine))
  elseif whatTodo[1] == "attack" then
    print("Attacking!!", "marine", marine.Id, "target", nearestEnemy.Id)
    table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
    table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
  elseif whatTodo[1] == "move" then
    print("moving towards enemy!", "marine", marine.Id, "target", nearestEnemy.Id)

    movePath = determineAttackPath(marine, whatTodo[2][1], whatTodo[2][2])
    if(movePath == -1) then
      print("No route to enemy, Going for weapon!", "marine", marine.Id, "target", nearestEnemy.Id)
      table.insert(Commands, doWeaponPickUp(self, marine, nearestWeapon))
    else
      table.insert(Commands, {Command = "move", Path = movePath })
    end
  elseif whatTodo[1] == "backandkill" then
    movePath = determineRetreatPath(marine, whatTodo[2][1], whatTodo[2][2])
    if(#movePath == 0 and enemyInSight(marine, nearestEnemy) == -1) then
      print("No route to enemy, Going for weapon!", "marine", marine.Id, "target", nearestEnemy.Id)
      table.insert(Commands, doWeaponPickUp(self, marine, nearestWeapon))
    else
      table.insert(Commands, {Command = "move", Path = movePath })
      table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
      table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
    end
  elseif whatTodo[1] == "movetokill" then
    movePath = determineAttackPath(marine, whatTodo[2][1], whatTodo[2][2])
    if(#movePath == 0 and enemyInSight(marine, nearestEnemy) == -1) then
      print("No route to enemy, Going for weapon!", "marine", marine.Id, "target", nearestEnemy.Id)
      table.insert(Commands, doWeaponPickUp(self, marine, nearestWeapon))
    elseif(enemyInSight(marine, nearestEnemy) > 0) then
      print("moving and shooting", "marine", marine.Id, "target", nearestEnemy.Id)
      table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
      table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
    else
      table.insert(Commands, {Command = "move", Path = movePath })
    end
  end
  table.insert(Commands, { Command = "done" })
  printCommands(Commands) 
  return Commands
end

function OwnMarine:on_aiming(attack)
  print("AIMING")
end
function OwnMarine:on_dodging(attack)
  print("DODGING")
end
function OwnMarine:on_knockback(attack, entity)
  print("KNOCKBACK")
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

function printTable(table) 
	for k, v in pairs( table ) do
		print("KEY", k,"VALUE", v)
	end
end

function printCommands(table) 
	for k, v in pairs( table ) do
		print("KEY", k,"COMMAND", v.Command)
	end
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
