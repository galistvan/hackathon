require 'Shooter.shoot'
require 'AI.makeDecision'
require 'Mappers.weaponsearch'
require 'Actions.Health'

OwnMarine = class( "Marine" )
ownMarines= {}

function OwnMarine:initialize(player_index, marine_id, instance_index)
  self.player_index = player_index
  self.marine_id = marine_id
  self.instance_index = instance_index
  self.actionMode = "advance"
  self.nearestEnemy = ""
  self.nearestWeapon = ""
  self.shouldGoForWeapons = false
  self.isSniper= false
  self.isFrontGuard= false
  self.isGroundAssault = false
  self.removedWeapons = {}
  table.insert(ownMarines,marine_id)
end

function OwnMarine:get_marine()
  local marine,err = Game.Map:get_entity(self.marine_id)
  if (marine == nil) then print (err) end
  return marine
end

function OwnMarine:select_mode()

  local marine = self:get_marine()
  self.nearestEnemy = getNearestEnemy(marine,ownMarines)
  self.nearestWeapon = getNearestWeapon(marine)

  self:setAuras(marine)
	
  local whatTodo = makeDecision(marine, self.nearestEnemy, self.nearestWeapon)
  
  -- return "sprint"
  -- return "guard"
  -- return "ready"
  print("marine", marine.Id, "set mode to", tostring(whatTodo[3]))
  return whatTodo[3]

end

function OwnMarine:provide_steps(prev)
  if (prev) then return nil end
  local Commands = {}
  local marine = self:get_marine()
  local whatTodo = makeDecision(marine, self.nearestEnemy, self.nearestWeapon)
  marine.removedWeapons = {}
  


  if whatTodo[1] == "pickUpWeapon" then
    print("Marine: " .. marine.Id .. " is Going for weapon!")
    table.insert(Commands, doWeaponPickUp(self, marine, self.nearestWeapon))
    table.insert(Commands, {Command = "pickup"})
  elseif whatTodo[1] == "heal" then
    print("Going for medkit!")
    table.insert(Commands, getHealth(marine))
  elseif whatTodo[1] == "attack" then
    print("Marine: " .. marine.Id .. " is Attacking!!", "target", self.nearestEnemy.Id)
    table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
    table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
    table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
    table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
  	if(marine.isGroundAssault) then
      table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
      table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
  	end
  elseif whatTodo[1] == "move" then
    print("Marine: " .. marine.Id .. " is moving towards enemy!", "target", self.nearestEnemy.Id)
      table.insert(Commands, {Command = "move", Path = whatTodo[4] })
  elseif whatTodo[1] == "backandkill" then
    print("Marine: " .. marine.Id .. " is retreating and shooting ", "target", self.nearestEnemy.Id)
      table.insert(Commands, {Command = "move", Path = whatTodo[4] })
      table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
      table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
  elseif whatTodo[1] == "movetokill" then
    print("Marine: " .. marine.Id .. " is moving towards and shooting ", "target", self.nearestEnemy.Id)
      table.insert(Commands, {Command = "move", Path = whatTodo[4] })
      table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
      table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
      if(marine.isFrontGuard) then
        table.insert(Commands, equipWeapons(marine, whatTodo[2][1], whatTodo[2][2]))
        table.insert(Commands, shootWeapon(marine, whatTodo[2][1], whatTodo[2][2]))
      end
  elseif whatTodo[1] == "moveandaim" then
    print("Marine: " .. marine.Id .. " is moving towards and shooting ", "target", self.nearestEnemy.Id)
      table.insert(Commands, {Command = "move", Path = whatTodo[4] })
  end
  table.insert(Commands, { Command = "done" })
  print("Move points :"..marine.MovePoints)
  print("Attack points :"..marine.AttackPoints)
  printCommands(Commands)
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

function printTable(table)
  for k, v in pairs( table ) do
    print("KEY", k,"VALUE", v)
  end
end

function printCommands(table)
  for k, v in pairs( table ) do
    print("KEY", k,"COMMAND", v.Command)
	if v.Command == "move" then
		printPath(v.Path)
	end
  end
end

function printPath(path)
if path ~= nil then
for k, v in pairs( path ) do
    print("KEY", k,"X", v.X,"Y",v.Y)
  end
  end
end

function OwnMarine:setAuras(myMarine)
	auras = myMarine.Auras
	for k,v in pairs(auras) do
	 if v.Type == "aura_groundassault" then
		self.isGroundAssault = true
	 end
	 
	 if v.Type == "aura_sniper" then
		self.isSniper = true
	 end
	 
	 if v.Type == "aura_frontguard" then
		self.isFrontGuard = true
	 end
	
	end
end
