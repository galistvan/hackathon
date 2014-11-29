function enemyInSight(marine, nearestEnemy, nearestWeapon)
	if (not Game.Map:entity_has_los(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)) then
		return -1
	end
	attack_path = Game.Map:get_attack_path(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
	i = #attack_path
	return i
end

