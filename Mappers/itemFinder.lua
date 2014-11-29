

function hasInvisibilityInInventory(marineEntity)
  return marineEntity.Inventory["i_invisibility"] == nil
end

function getPathDistanceToInvisibility(marineEntity)
  local gameEntities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
  local invisibility = nil
  local pathToInvisibility = nil
  for _, v in pairs(gameEntities) do
    if (v.Type == "i_invisibility") then
      invisibility = v
    end
  end
  if invisibility == nil then
    return -1
  else
    pathToInvisibility = Game.Map:get_move_path(marineEntity.Id, invisibility.Bounds.X, invisibility.Bounds.Y)
    if #pathToInvisibility == 0 and not weAreOnTheInvisibility(marineEntity) then
      return -1
    else
      return #pathToInvisibility
    end
  end
end

function weAreOnTheInvisibility(marineEntity)
  local gameEntities = Game.Map:entities_in(marineEntity.Bounds.X, marineEntity.Bounds.Y, 1, 1)
  for _, v in pairs(gameEntities) do
    if (v.Type == "i_invisibility") then
      return true
    end
  end
end

function getPathInvisibility(marineEntity)
  local gameEntities = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
  for _, v in pairs(gameEntities) do
    if (v.Type == "i_invisibility") then
      return  Game.Map:get_move_path(marineEntity.Id, v.Bounds.X, v.Bounds.Y)
    end
  end
end
