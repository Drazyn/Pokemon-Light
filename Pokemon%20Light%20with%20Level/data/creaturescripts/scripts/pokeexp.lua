function onDeath(cid, corpse, deathList)
	if isMonster(cid) and not isSummon(cid) then
		doItemSetAttribute(corpse.uid, "aid", 9282)
		name = doCorrectString(getCreatureName(cid))
		if poke_status[name] then
			doItemSetAttribute(corpse.uid, "gender", getCreatureStorage(cid, 4321))
			doItemSetAttribute(corpse.uid, "level", getCreatureLevel(cid))
			doItemSetAttribute(corpse.uid, "ownercorpse", getPlayerGUID(deathList[1]))
		end
	elseif isPlayer(cid) then
		if isPlayer(deathList[1]) then
			msg = getCreatureName(cid).." ["..getPlayerLevel(cid).."] morreu para "..getCreatureName(deathList[1]).." [".. getPlayerLevel(deathList[1]) .."]."
		else
			msg = getCreatureName(cid).." ["..getPlayerLevel(cid).."] morreu para "..getCreatureName(deathList[1]).."."
		end
		doPlayerSendChannelMessage(cid, "",msg, TALKTYPE_CHANNEL_W, 13)
	end
	return true
end