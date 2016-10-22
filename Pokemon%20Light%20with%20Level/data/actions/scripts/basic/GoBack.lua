function onUse(cid, item, fromPosition, itemEx, toPosition)

	if #getCreatureSummons(cid) <= 0 then
	    if isPokeballBlock(item.itemid) then
			doTransformItem(item.uid, pokeballs_block[item.itemid])
			doPlayerSendCancel(cid, "[Ball-Desbloqueado] Balls Desbloqueado com Sucesso!")
			doSendMagicEffect(getThingPos(cid), 29)
			doSendAnimatedText(getCreaturePosition(cid),"Unlock",math.random(1,255)) 
		    return false
		 end
    end

	if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_FEET).uid then
		doPlayerSendCancel(cid, "You must put your pokeball in the correct place!")
	    return true
	end

	if isPokeballUse(item.itemid) then
		if getItemAttribute(item.uid, "block") == "true" then
			doPlayerSendCancel(cid, "You cannot back your pokemon now!")
			return true
		end
		doReturnPokemon(cid, true)
		doItemSetAttribute(item.uid, "block", "false")
		return true
	elseif isPokeballOn(item.itemid) then
		if #getCreatureSummons(cid) < 1 then
			if getItemAttribute(item.uid, "poke") then
				doGoPokemon(cid, true)
			end
		end
		return true
	elseif isPokeballOff(item.itemid) then
		doPlayerSendCancel(cid, "This pokemon has fainted!")
		return true
	end
	
	return true
end