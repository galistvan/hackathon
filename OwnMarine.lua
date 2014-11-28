require 'Shooter.shoot'
require 'AI.makeDecision'
require 'Mappers.weaponsearch'

OwnMarine = class( "Marine" )

function OwnMarine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
    self.availableWeapons = {"w_hand"}
    self.availableItems = {}
    self.availableAmmo = {}
end

function OwnMarine:get_marine()	
	local marine,err = Game.Map:get_entity(self.marine_id)
	if (marine == nil) then print (err) end
    return marine
end

function OwnMarine:select_mode()
 return "advance"
-- return "sprint"
-- return "guard"
-- return "ready"

end

function OwnMarine:provide_steps(prev)
	Commands = {}
	marine = self:get_marine()
	local marineX = getMarineCoordX(marine)
	local marineY = getMarineCoordY(marine)
  nearestEnemy = getNearestEnemy(marine)
  nearestWeapon = getNearestWeapon(marine)

  whatTodo = makeDecision(marine, self.availableWeapons, self.availabeItems, self.availableAmmo, nearestEnemy, nearestWeapon)


  if whatTodo == "pickUpWeapon" then
    table.insert(Commands, doWeaponPickUp(marine))
  elseif whatTodo == "attack" then
    table.insert(Commands, equipWeapon(marine, marine.Bounds.X, marine.Bounds.Y, self.availableWeapons, self.availableAmmo))
    table.insert(Commands, shootWeapon(marine, marine.Bounds.X, marine.Bounds.Y))
  end
	return Commands
end

function OwnMarine:on_aiming(attack) end
function OwnMarine:on_dodging(attack) end
function OwnMarine:on_knockback(attack, entity) end

function OwnMarine:isIHaveThatWeapon(nearestWeapon) 
	print("do have i that weapon?")
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

function OwnMarine:when_other_marine_pickingupitem(other, event, prev) 
	print("picking up item")
	print(tostring(other))
	print(tostring(event))
	print(tostring(prev))

	table.insert(availableWeapons, other)
end

function OwnMarine:when_other_marine_pickedupitem(other, event, prev) 
	print("picked up item")
	print(tostring(other))
	print(tostring(event))
	print(tostring(prev))

end