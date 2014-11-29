require 'Shooter.shoot'
require 'AI.makeDecision'
require 'Mappers.weaponsearch'

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
  elseif whatTodo[1] == "attack" then
    print("Attacking!!")
    table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
    table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
  elseif whatTodo[1] == "move" then
    print("moving towards enemy!")

    movePath = determineAttackPath(marine, whatTodo[2][1], whatTodo[2][2])
    table.insert(Commands, {Command = "move", Path = movePath })
  elseif whatTodo[1] == "movetokill" then
    -- 1 movement 1 shoot
  end
  table.insert(Commands, { Command = "done" })
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

function determineAttackPath(marine, x, y)
  local currentPath = Game.Map:get_attack_path(marine.Id, x, y)
  local lastStep = currentPath[#currentPath-1]
  local correctPath = Game.Map:get_move_path(marine.Id, lastStep.X, lastStep.Y)
  return getFirstNItemsFromList(marine.MovePoints, correctPath)
end
