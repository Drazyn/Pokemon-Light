function doEvolvePokemon(cid, pokemon, name, stone1, stone2, pokelevel, minlevel)
	
	if not isCreature(cid) then 
		return true 
	end
	
	name = doCorrectString(name)
	
	if getPlayerLevel(cid) < minlevel then
		doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
		return true
	end
	pokename = doCorrectString(getCreatureName(pokemon.uid))
	if getCreatureLevel(pokemon.uid) < pokelevel then
		doPlayerSendCancel(cid, "Your ".. pokename .." don't have a level to evolve ("..pokelevel..").")
		return true
	end
	
	local owner = getCreatureMaster(pokemon.uid)
	local pokeball = getPlayerSlotItem(cid, 8)
	doItemSetAttribute(pokeball.uid, "poke", name)
	doItemSetAttribute(pokeball.uid, "hp", getPokeballMaxHealth(pokeball.uid))
	doItemSetAttribute(pokeball.uid, "maxhp", getPokeballMaxHealth(pokeball.uid))
	doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getCreatureName(pokemon.uid).." evolved into a "..name.."!")		
	
	doSendMagicEffect(getThingPos(pokemon.uid), 18)
	
	local oldpos = getThingPos(pokemon.uid)
	local oldlod = getCreatureLookDir(pokemon.uid)
	doReturnPokemon(cid)
	doPlayerRemoveItem(cid, stone1, 1)
	doPlayerRemoveItem(cid, stone2, 1)
	
	addEvent(function()
		doGoPokemon(cid, oldpos)
		local pk = getCreatureSummons(cid)[1]
		doCreatureSetLookDir(pk, oldlod)
		doTransformItem(getPlayerSlotItem(cid, 7).uid, poke_special[getItemAttribute(pokeball.uid, "poke")].fotopoke)
	end, 150)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	
	if not isSummon(itemEx.uid) then
		return false
	end

	local ball = getPlayerSlotItem(cid, 8)
	local evo = pokeevo[getCreatureName(itemEx.uid)]
	local OFF = true
	local pokemon = itemEx.uid
	local stone = item

	if #getCreatureSummons(cid) > 1 then
		return true
	end

	if getItemAttribute(getPlayerSlotItem(cid, 8).uid, "ehditto") then
		doPlayerSendCancel(cid, "You can't evolve ditto!")
		return true
	end

	if not isPlayer(getCreatureMaster(itemEx.uid)) or getCreatureMaster(itemEx.uid) ~= cid then
		doPlayerSendCancel(cid, "You can only use stones on pokemons you own.")
		return true
	end

	if getCreatureName(pokemon) == "Eevee" then
		if item.itemid == 7755 then
			if getPlayerItemCount(cid, 7755) >= 2 then
				doEvolvePokemon(cid, itemEx, "Jolteon", 7755, 7755, 40, 60)
			else
				doPlayerSendCancel(cid, "You need a two thunder stone")
			end
		elseif item.itemid == 7749 then
			if getPlayerItemCount(cid, 7749) >= 2 then
				doEvolvePokemon(cid, itemEx, "Flareon", 7749, 7749, 40, 60)
			else
				doPlayerSendCancel(cid, "You need a two fire stone")
			end
		elseif  item.itemid == 7757 then
			if getPlayerItemCount(cid, 7757) >= 2 then
				doEvolvePokemon(cid, itemEx, "Vaporeon", 7757, 7757, 40, 60)
			else
				doPlayerSendCancel(cid, "You need a two water stone")
			end
		else
			doPlayerSendCancel(cid, "You can't evolve this pokemon")
		end
		return true
	end
	
	if not evo then
		doPlayerSendCancel(cid, "This pokemon can't evolve.")
		return true
	end
	
	if evo.stoneid ~= item.itemid and evo.stoneid2 ~= item.itemid then 
		doPlayerSendCancel(cid, "This isn't the needed stone to evolve this pokemon.")
		return true
	end
	
	local count = pokeevo[getCreatureName(itemEx.uid)].count
	local stone1 = pokeevo[getCreatureName(itemEx.uid)].stoneid
	local stone2 = pokeevo[getCreatureName(itemEx.uid)].stoneid2
	local pokevo = pokeevo[getCreatureName(itemEx.uid)].evolution
	
	if stone2 > 1 and (getPlayerItemCount(cid, stone2) < count or getPlayerItemCount(cid, stone1) < count) then
		doPlayerSendCancel(cid, "You need at least one "..getItemNameById(stone1).." and one "..getItemNameById(stone2).." to evolve this pokemon!")
		return true
	end
	
	if getPlayerItemCount(cid, stone1) < count then
		local str = ""
		if count >= 2 then
			str = "s"
		end
		return doPlayerSendCancel(cid, "You need at least "..count.." "..getItemNameById(stone1)..""..str.." to evolve this pokemon!")
	end
	
	if count >= 2 then
		stone2 = stone1
	end

	local theevo = pokeevo[doCorrectString(getCreatureName(itemEx.uid))].evo
	pokename = doCorrectString(theevo)
	name2 = doCorrectString(getCreatureName(itemEx.uid))
	doEvolvePokemon(cid, itemEx, theevo, stone1, stone2, pokeevo[name2].level, poke_status[pokename].level)
	
	return true
end