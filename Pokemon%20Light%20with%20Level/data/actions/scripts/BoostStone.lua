function onUse(cid, item, frompos, pokeball, topos)
	if isPokeball(pokeball.itemid) then
		if #getCreatureSummons(cid) <= 0 then
			if not getItemAttribute(pokeball.uid, "boost") then
				doItemSetAttribute(pokeball.uid, "boost", 0)
			end
			local oldBoost = getItemAttribute(pokeball.uid, "boost")
			if oldBoost < BoostLimit then
				doItemSetAttribute(pokeball.uid, "boost", oldBoost+1)
				local newBoost = getItemAttribute(pokeball.uid, "boost")
				if newBoost ~= 1 then
					doPlayerSendTextMessage(cid, 27, "Parabéns! Você upou o boost do seu pokemon de "..oldBoost.." para "..newBoost.."!" )
				else
					doPlayerSendTextMessage(cid, 27, "Parabéns! Você acabou de adicionar o primeiro boost ao seu pokemon!")
				end
				doPlayerRemoveItem(cid, item.itemid, 1)
				doSendMagicEffect(getThingPosition(cid), 103, cid)
			else
				doPlayerSendCancel(cid, "Este pokemon já chegou no boost máximo ("..BoostLimit..")!")
			end
		else
			doPlayerSendCancel(cid, "Você precisa chamar seu pokemon para dentro da ball para executar essa ação!")
		end
	else
		doPlayerSendCancel(cid, "Você só pode usar isso em pokeball!")
	end
	return true
end