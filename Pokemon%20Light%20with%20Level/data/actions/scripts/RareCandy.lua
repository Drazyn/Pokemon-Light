function onUse(cid, item, frompos, itemEx, topos)
	if isSummon(itemEx.uid) and (getCreatureSummons(cid) and getCreatureSummons(cid)[1] == itemEx.uid) then
		local ball = getPlayerSlotItem(cid, 8)
		if not getItemAttribute(ball.uid, "rarecandy") then
			doItemSetAttribute(ball.uid, "rarecandy", 0)
		end
		if getItemAttribute(ball.uid, "rarecandy") < MaxRareCandy then
			if getPlayerStorageValue(cid, 21341) - os.time() < 1 then
				if getCreatureLevel(itemEx.uid) < 100 then
					local nlvl = getCreatureLevel(itemEx.uid)+1
					doItemSetAttribute(ball.uid, "level", nlvl)
					doCreatureSay(getCreatureSummons(cid)[1], "LEVEL UP!", 20)
					doReloadPokemon(cid, getCreatureSummons(cid)[1])
					setPlayerStorageValue(cid, 21341, 5 + os.time())
					doItemSetAttribute(ball.uid, "rarecandy", getItemAttribute(ball.uid, "rarecandy")+1)
					doPlayerSendTextMessage(cid, 20, "Você upou o "..getCreatureName(getCreatureSummons(cid)[1]).." do level "..nlvl-1 .." para o level "..nlvl.."!")
					doRemoveItem(item.uid, 1)
				else
					doPlayerSendCancel(cid, "Seu pokemon já está no level máximo ("..PokemonMaxLevel..")!")
				end
			else
				doPlayerSendCancel(cid, "Você precisa esperar "..getPlayerStorageValue(cid, 21341)-os.time().." segundos para usar isso denovo!")
			end
		else
			doPlayerSendCancel(cid, "Você já atingiu o limite de rare candy neste pokemon ("..MaxRareCandy..")!")
		end
	else
		doPlayerSendCancel(cid, "Você só pode usar isso em seu pokemon!")
	end
	return true
end