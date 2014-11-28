require 'Shooter.shoot'
OwnMarine = class( "Marine" )
availableWeapons = {"w_hand"}
availableItems = {}
availableAmmo = {}

function OwnMarine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
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
  Command = {}
	marine = self:get_marine()
	local marineX = getMarineCoordX(marine)
	local marineY = getMarineCoordY(marine)

	nearestWeapon = getNearestWeapon(marine)
	nearestEnemy = getNearestEnemy(marine)
	print("weapon: " .. nearestWeapon.Type .. ", (x: " .. nearestWeapon.Bounds.X, " y: " .. nearestWeapon.Bounds.Y .. ")")
	print("enemy: " .. nearestEnemy.Type .. ", (x: " .. nearestEnemy.Bounds.X, " y: " .. nearestEnemy.Bounds.Y .. ")")

	-- if return is not empty, has a {Command = "attack", Aimed="false", Target={ X = 1, Y = 4 }}
	-- auto equips weapons :)
	table.insert(Command, equipWeapon(marine, marine.Bounds.X, marine.Bounds.Y, availableWeapons, availableAmmo))
	table.insert(Command, shootWeapon(marine, marine.Bounds.X, marine.Bounds.Y))
	
	-- so, call this if we only moved once or call 2 times if we can.
	
	
	
	return Command
end

function OwnMarine:on_aiming(attack) end
function OwnMarine:on_dodging(attack) end
function OwnMarine:on_knockback(attack, entity) end

function getMarineCoordX(marine)
	return marine.Bounds.X
end
function getMarineCoordY(marine)
	return marine.Bounds.Y
end