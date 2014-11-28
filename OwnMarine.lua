require 'Shooter.shoot'

OwnMarine = class( "Marine" )
availableWeapons = {}
availableItems = {}

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
	marine = self:get_marine()
	--local marineX = getMarineCoordX(marine)
	--local marineY = getMarineCoordY(marine)
	print("marine x: " .. marine.Bounds.X .. ", y: " .. marine.Bounds.Y)
	--print (marineX-1)

	nearestWeapon = getNearestWeapon(marine)
	weaponPath = Game.Map:get_move_path(marine.Id, nearestWeapon.Bounds.X, nearestWeapon.Bounds.Y)
	movePath = getFirstNItemsFromList(marine.MovePoints, weaponPath)
	
	if isStandAboveAWeapon(marine) then
		print("standaboveWeapon")
		return {  Command = "pickup" } 
	end
	-- if return is not empty, has a {Command = "attack", Aimed="false", Target={ X = 1, Y = 4 }}
	-- auto equips weapons :)
	-- shoot(marine, x, y, availableWeapons)
	return { {Command = "move", Path =  movePath  }, {Command = "done"} }
	-- return {{Command = "done" }}
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

function getFirstNItemsFromList(n, list)
	resultList = {}
	for i=1,n do 
		table.insert(resultList,list[i])
	end
	return resultList
end

function isStandAboveAWeapon(marine) 
	entities = Game.Map:entities_in(marine.Bounds.X, marine.Bounds.Y, 1, 1)
	for _, v in pairs(entities) do
		if isWeapon(v) then
			return true
		end
	end
	return false
end