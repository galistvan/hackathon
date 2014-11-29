function enemyInSight(marine, availableWeapons, availableItems, availableAmmo, nearestEnemy, nearestWeapon)
  print("enemy is at : ")
  print(marine.Id,nearestEnemy.Bounds.X,nearestEnemy.Bounds.Y)
	if (not Game.Map:entity_has_los(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)) then
		return -1
	end
	attack_path = Game.Map:get_attack_path(marine.Id, nearestEnemy.Bounds.X, nearestEnemy.Bounds.Y)
	i = #attack_path
	print("Possible to attack, distance "..i)
	return i
end
