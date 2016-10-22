function doHealOverTime(cid, div, turn, effect) --alterado v1.6 peguem o script todo!!
	if not isCreature(cid) then return true end
	
	if turn <= 0 or (getCreatureHealth(cid) == getCreatureMaxHealth(cid)) or getPlayerStorageValue(cid, 173) <= 0 then 
		setPlayerStorageValue(cid, 173, -1)
		return true 
	end
	
	local d = div / 10000
	local amount = math.floor(getCreatureMaxHealth(cid) * d)
	doCreatureAddHealth(cid, amount)
	if math.floor(turn/10) == turn/10 then
		doSendMagicEffect(getThingPos(cid), effect)
	end
	addEvent(doHealOverTime, 100, cid, div, turn - 1, effect)
end

local potions = {
	[2460] = {effect = 13, div = 30}, --small potion
	[2461] = {effect = 13, div = 60}, --great potion 
	[2459] = {effect = 12, div = 80}, --ultra potion
	[2458] = {effect = 14, div = 90}, --hyper potion12343
	[2457] = {effect = 14, div = 100}, -- Boost potion
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 2462 then
		if isSummon(itemEx.uid) and getCreatureMaster(itemEx.uid) == cid then
		    if (getCreatureCondition(itemEx.uid, CONDITION_PARALYZE) == true) then
			   doRemoveCondition(itemEx.uid, CONDITION_PARALYZE)
		    end    
		    doRegainSpeed(itemEx.uid)                                                             
			doSendMagicEffect(getCreaturePosition(itemEx.uid), 14)
			doRemoveItem(item.uid, 1)			
		else
			doPlayerSendCancel(cid, "You can only use potions on your own Pokemons!")	
		end
		return true
	end
	if potions[item.itemid] then
		if isSummon(itemEx.uid) then
			local summ = itemEx.uid
			if getCreatureHealth(summ) ~= getCreatureMaxHealth(summ) then
				if getPlayerStorageValue(summ, 173) < 1 then
					local a = potions[item.itemid]
					if getCreatureMaster(summ) ~= cid then
						times1 = mathpercent(a.div, PercentToCureOtherPokemons)
						times = 50
					else
						times = 100
						times1 = a.div
					end
					doCreatureSay(cid, getCreatureName(summ)..", take this potion!", 20)
					doSendMagicEffect(getCreaturePosition(summ), 30)
					setPlayerStorageValue(summ, 173, 1)
					doRemoveItem(item.uid, 1)
					doHealOverTime(summ, times1, times, a.effect)
				else
					doPlayerSendCancel(cid, "This pokemon is already under effects of potions.")
				end
			else
				doPlayerSendCancel(cid, "This pokemon is already at full health.")
			end
		else
			doPlayerSendCancel(cid, "You can use potions only in pokemons!")			
		end
		return true
	end
	if isPokeball(itemEx.itemid) then
		if item.itemid == 2456 then
			if #getCreatureSummons(cid) <= 0 then
				doRemoveItem(item.uid, 1)			
				doCureBallStatus(itemEx)
				doSendMagicEffect(getCreaturePosition(cid), 13)
			else
				doPlayerSendCancel(cid, "You need back your pokemon!")			
			end
		end
	else
		doPlayerSendCancel(cid, "It's not a pokeball.")
	end
	return true
end