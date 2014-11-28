OwnMarine = class( "Marine" )

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
	print("x: " .. marine.Bounds.X .. ", y: " .. marine.Bounds.Y)
	
	return {  Command = "move", Path = { { X = 1, Y = 1 }, { X = 2, Y = 2}, { X = 3, Y = 2} } } 
end

function OwnMarine:on_aiming(attack) end
function OwnMarine:on_dodging(attack) end
function OwnMarine:on_knockback(attack, entity) end