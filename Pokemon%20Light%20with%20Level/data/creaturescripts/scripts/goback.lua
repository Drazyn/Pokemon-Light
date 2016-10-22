local deathtexts = {"Oh no! POKENAME, come back!", "Come back, POKENAME!", "That's enough, POKENAME!", "You did well, POKENAME!",
"You need to rest, POKENAME!", "Nice job, POKENAME!", "POKENAME, you are too hurt!"}

function onDeath(cid, corpse, deathList)
	if isSummon(cid) then
		local owner = getCreatureMaster(cid)
		if isPlayer(owner) then
			local pos = getCreaturePosition(cid)
			local pokeball = getPlayerSlotItem(owner, 8)
			local say = deathtexts[math.random(#deathtexts)]
			say = string.gsub(say, "POKENAME", getCreatureName(cid))

			doTransformItem(pokeball.uid, pokeballs_OFF[pokeball.itemid])
			doItemSetAttribute(pokeball.uid, "hp", 0)
			showPokeballEffect(pos, pokeball.itemid)
			doPlayerSendTextMessage(owner, 22, "Your pokemon fainted.")
			doCreatureSay(owner, say, TALKTYPE_SAY)
			onPokeHealthChange(owner)
		return false
		end
	end
	return true
end