function hasAddon(ball)
	if isPokeball(ball.itemid) then
		if getItemAttribute(ball.uid, "addon") then
			return true
		end
	end
	return false
end

function onUse(cid, item, frompos, pokemon, topos)
	ball = getPlayerSlotItem(cid, 8)
	if isPokeball(ball.itemid) then
		if (not isSummon(pokemon.uid) or getCreatureSummons(cid)[1] ~= pokemon.uid) then
			doPlayerSendCancel(cid, "Você só pode usar isso em seu pokemon!")
			return true
		end
		if not hasAddon(ball) then
			pokename = getItemAttribute(ball.uid, "poke")
			addonName = ItemidToAddon[item.itemid]
			if addonName and PokeAddons[pokename] and PokeAddons[pokename][addonName] then
				doItemSetAttribute(ball.uid, "addon", addonName)
				doReloadPokemon(cid)
				doRemoveItem(item.uid, 1)
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você acaba de por o addon \""..addonName.."\" no "..pokename.."!")
			else
				doPlayerSendCancel(cid, "Este pokemon não usa esse addon!")
			end 
		else
			doPlayerSendCancel(cid, "Este pokemon já tem addon!")
		end		
	else
		doPlayerSendCancel(cid, "Você precisa usar em seu pokemon!")
	end
	return true
end