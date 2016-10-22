function onDeath(cid, corpse, deathList)
	if isPlayer(cid) then
		msg = getCreatureName(cid)
		if isPlayer(deathList[1]) then
			msg = "O player "..getCreatureName(cid).." [level: "..getPlayerLevel(cid).."] morreu para o player "..getCreatureName(deathList[1]).." [level: ".. getPlayerLevel(deathList[1]) .."]."
		else
			msg = "O player "..getCreatureName(cid).." [level: "..getPlayerLevel(cid).."] morreu para o pokemon "..getCreatureName(deathList[1]).."."
		end
		for _, pid in ipairs(getPlayersOnline()) do
			doPlayerSendChannelMessage(pid, "", msg, TALKTYPE_CHANNEL_O, 13)
		end
	end
	return true
end