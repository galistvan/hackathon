require 'Shooter.shoot'
require 'AI.makeDecision'
require 'Mappers.weaponsearch'

OwnMarine = class( "Marine" )
ownMarines= {}

function OwnMarine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
    self.availableWeapons = {"w_hand"}
    self.availableItems = {}
    self.availableAmmo = {}
	Game.register_event_handler(self.HandleEvents, self)
	table.insert(ownMarines,marine_id)
end

function OwnMarine:get_marine()	
	local marine,err = Game.Map:get_entity(self.marine_id)
	if (marine == nil) then print (err) end
    return marine
end

function OwnMarine:select_mode()
-- return "sprint"
-- return "guard"
-- return "ready"
return "advance"

end

function OwnMarine:provide_steps(prev)
	Commands = {}
	marine = self:get_marine()
	local marineX = getMarineCoordX(marine)
	local marineY = getMarineCoordY(marine)
	nearestEnemy = getNearestEnemy(marine,ownMarines)
	nearestWeapon = getNearestWeapon(marine)

  whatTodo = makeDecision(marine, self.availableWeapons, self.availabeItems, self.availableAmmo, nearestEnemy, nearestWeapon)

  if whatTodo[1] == "pickUpWeapon" then
    table.insert(Commands, doWeaponPickUp(self, marine, nearestWeapon))
  elseif whatTodo[1] == "attack" then
    table.insert(Commands, equipWeapon(marine, whatTodo[2][1], whatTodo[2][2], self.availableWeapons, self.availableAmmo))
    table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
  elseif whatTodo[1] == "move" then
    currentPath = Game.Map:get_move_path(self.marine_id, whatTodo[2][1], whatTodo[2][2])
	movePath = getFirstNItemsFromList(marine.MovePoints, currentPath)
    table.insert(Commands, {Command = "move", Path = movePath })
  end
      table.insert(Commands, { Command = "done" })
	return Commands
end

function OwnMarine:on_aiming(attack) end
function OwnMarine:on_dodging(attack) end
function OwnMarine:on_knockback(attack, entity) end

function OwnMarine:isIHaveThatWeapon(nearestWeapon) 
	for _,v in pairs(self.availableWeapons) do
	  if v == nearestWeapon then
		return true
	  end
	end
	return false
end

function getMarineCoordX(marine)
	return marine.Bounds.X
end
function getMarineCoordY(marine)
	return marine.Bounds.Y
end

function OwnMarine:HandleEvents(name, event) 
	if name == "EntityPickingUpItem" then
		print("picking up item: " .. event.Item)
		table.insert(self.availableWeapons, event.Item)
		print("currently available weapons: " )
		printTable(self.availableWeapons)
	else 
		if name == "EntityLostItem" then
			print("lost item: " .. event.Item)
			table.remove(self.availableWeapons, event.Item)
			print("currently available weapons: " )
			printTable(self.availableWeapons)
		end
	end

end

function printTable(table) 
	for k, v in pairs( table ) do
		print(k, v)
	end
end