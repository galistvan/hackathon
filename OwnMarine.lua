require 'Shooter.shoot'

OwnMarine = class( "Marine" )

function OwnMarine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
    self.availableWeapons = {"w_hand"}
    self.availableItems = {}
    self.availableAmmo = {}
	Game.register_event_handler(self.HandleEvents, self)
end

function OwnMarine:get_marine()	
	local marine,err = Game.Map:get_entity(self.marine_id)
	if (marine == nil) then print (err) end
    return marine
end

function OwnMarine:select_mode()
-- return "advance"
 return "sprint"
-- return "guard"
-- return "ready"

end

function OwnMarine:provide_steps(prev)
	Commands = {}
	marine = self:get_marine()
	local marineX = getMarineCoordX(marine)
	local marineY = getMarineCoordY(marine)

	if (lengthOfArray(self.availableWeapons) <= 1) then -- find a weapon
		nearestWeapon = getNearestWeapon(marine)
		print("weapon: " .. nearestWeapon.Type .. ", (x: " .. nearestWeapon.Bounds.X, " y: " .. nearestWeapon.Bounds.Y .. ")")

		if (isStandAboveAWeapon(marine) and not self:isIHaveThatWeapon(nearestWeapon))then
			print("picking up")
			table.insert(Commands, { Command = "pickup" } )
		end
		weaponPath = Game.Map:get_move_path(marine.Id, nearestWeapon.Bounds.X, nearestWeapon.Bounds.Y)
		movePath = getFirstNItemsFromList(marine.MovePoints, weaponPath)
		print(lengthOfArray(movePath))
		print("insert command move")
		table.insert(Commands, { Command = "move", Path = movePath  } )
		print("inserted command move")

	else -- kill someone
		nearestEnemy = getNearestEnemy(marine)
		print("enemy: " .. nearestEnemy.Type .. ", (x: " .. nearestEnemy.Bounds.X, " y: " .. nearestEnemy.Bounds.Y .. ")")
		-- if return is not empty, has a {Command = "attack", Aimed="false", Target={ X = 1, Y = 4 }}
		-- auto equips weapons :)
		table.insert(Commands, equipWeapon(marine, marine.Bounds.X, marine.Bounds.Y, self.availableWeapons, self.availableAmmo))
		table.insert(Commands, shootWeapon(marine, marine.Bounds.X, marine.Bounds.Y))
	
		-- so, call this if we only moved once or call 2 times if we can.
	end
	table.insert(Commands, { Command = "done" } )
	printCommands(Commands)
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

function getFirstNItemsFromList(n, list)
	resultList = {}
	for i=1,n do 
		table.insert(resultList,list[i])
	end
	return resultList
end

function isStandAboveAWeapon(marine) 
	entities = Game.Map:entities_in(marine.Bounds.X, marine.Bounds.Y, 1, 1)
	print("weapon check")
	for _, v in pairs(entities) do
		if isWeapon(v) then
			print("weapon check end true")
			return true
		end
	end
	print("weapon check end")
	return false
end

function OwnMarine:HandleEvents(name, event) 
	if name == "EntityPickingUpItem" then
		print("received item" .. event.Item)
		print(tostring(name))
		print(tostring(event))
		table.insert(self.availableWeapons, event.Item)
	else 
		if name == "EntityLostItem" then
			print("lost item")
			print(tostring(name))
			print(tostring(event))
			table.remove(self.availableWeapons, event.Item)
		end
	end
end



function printCommands(commands) 
	for k, v in pairs( commands ) do
		print(k, v)
	end
end

