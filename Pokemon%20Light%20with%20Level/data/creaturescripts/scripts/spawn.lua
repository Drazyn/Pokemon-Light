local shinys = {"Bulbasaur"}

local function doShiny(cid)
	if isCreature(cid) then
		if isSummon(cid) then 
			return false 
		end
		
		if isInArray(shinys, getCreatureName(cid)) then
			chance = 1
		elseif isInArray(raros, getCreatureName(cid)) then
			chance = 0.2
		else
			return true
		end 

		if math.random(1, 1000) <= chance*10 then 
			doSendMagicEffect(getThingPos(cid), 18) 
			local name, pos = "Shiny ".. getCreatureName(cid), getThingPos(cid)
			doRemoveCreature(cid)
			local shi = doCreateMonster(name, pos, false)
		end

	else 
		return true
	end
end

function onSpawn(cid)
	if not isSummon(cid) then
		if isGhostByName(getCreatureName(cid)) then
			setPokemonGhost(cid)
		end
		doSetRandomGender(cid, true)
		hp = getMaxHealthByName(getCreatureName(cid), getCreatureLevel(cid), getCreatureSkullType(cid))
		setCreatureMaxHealth(cid, hp)
		doCreatureAddHealth(cid, hp)
		adjustWildPoke(cid)
		doCreatureSetStorage(cid, 51201, getThingPosition(cid).x)
		doCreatureSetStorage(cid, 51202, getThingPosition(cid).y)
		doCreatureSetStorage(cid, 51203, getThingPosition(cid).z)
	end
end