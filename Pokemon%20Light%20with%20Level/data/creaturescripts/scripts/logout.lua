local config =
{
	lerIP = true,
	storage = 201507080001
}

function onLogout(cid)
	local timeNow = os.time()
	local totalTime = getPlayerLastLoginSaved(cid) + LogOutDelay

	if totalTime >= timeNow then
		if not config.lerIP or getPlayerStorageValue(cid, config.storage) == getPlayerIp(cid) then
			doPlayerSendTextMessage(cid, 19, "[PokeLight] Aguarde ".. totalTime - timeNow .." segundo(s) Para Poder Deslogar!.")
			return false
		end
	end
	doPlayerSave(cid, true)
	setPlayerStorageValue(cid, config.storage, getPlayerIp(cid))
	setPlayerStorageValue(cid, 3123, -1)
	local pokeball = getPlayerSlotItem(cid, CONST_SLOT_FEET)
	local pokemon = getCreatureSummons(cid)[1]

	if #getCreatureSummons(cid) >= 1 then
		if isPokeballUse(pokeball.itemid) then
			doTransformItem(pokeball.uid, pokeballs_ON[pokeball.itemid])
		    doItemSetAttribute(pokeball.uid, "hp", getCreatureHealth(pokemon))
			showPokeballEffect(getCreaturePosition(pokemon), pokeball.itemid)
			doRemoveCreature(pokemon)
			return true	
		end
	end
	if isFlying(cid) or isRiding(cid) then
		markFlyingPos(cid, getThingPos(cid))
	end
	doPlayerSave(cid, true)
	return true
end