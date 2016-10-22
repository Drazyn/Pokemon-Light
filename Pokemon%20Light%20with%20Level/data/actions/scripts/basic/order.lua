function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (isFlying(cid) or isRiding(cid)) and itemEx.uid == cid then
		if isInArray({'460', '13058', '13059'}, getTileInfo(getThingPos(cid)).itemid) then
			doPlayerSendCancel(cid, "You can\'t go lower!")
		else 
			doRemoveFlyRide(cid)
		end
		return true
	end
	
	if #getCreatureSummons(cid) < 1 then
		doPlayerSendCancel(cid, "Você precisa de um pokemon para usar o order!")
		return true
	end

	local pokemon = getCreatureSummons(cid)[1]
	local ball = getPlayerSlotItem(cid, 8)
	local pokename = getCreatureName(pokemon) or getCreatureName(cid)
	local maxHp = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "maxhp")
	local Hp = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "hp")
	local nick = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nick") or pokename
	
	if itemEx.uid == cid and hasSkill("fly", pokename) and not isFlying(cid) then
		doFly(cid)
		return true
	end
	
	if itemEx.uid == cid and hasSkill("ride", pokename) and not isRiding(cid) then
		doRide(cid)
		return true
	end

	if isInArray(cuti, itemEx.itemid) then
		doCut(cid, toPosition, itemEx)
		return true
	elseif isInArray(rocksmashi, itemEx.itemid) then
		doRockSmash(cid, toPosition, itemEx)
		return true
	elseif isInArray(digi, itemEx.itemid) then
		if hasSkill("dig", pokename) then
			doPlayerSay(cid, ""..nick..", "..msg["dig"][math.random(1, #msg["dig"])].."", 20)
			doRegainSpeed(pokemon)
			doItemSetAttribute(ball.uid, "block", "true")
			local steps = creatureGoToPos(pokemon, toPosition, 800-getCreatureSpeed(pokemon))
			addEvent(function()
				doFaceCreature(pokemon, toPosition)
				addEvent(function()
					if getDistanceBetween(getCreaturePosition(pokemon), toPosition) <= 1 then
						local pos = getThingfromPos(toPosition)
						doCreatureSay(pokemon, "DIG!", TALKTYPE_MONSTER)
						doTransformItem(pos.uid, itemEx.itemid+1)
						doReturnItemsWithDelay(toPosition, itemEx.itemid, 15)
					end
					doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "false")
				end, 150)
			end, steps*(800-getCreatureSpeed(pokemon)))
		else
			doPlayerSendCancel(cid, "Your pokemon can't use dig.")
		end
		return true
	end
	
	if (pokename == "Ditto") then
		if isMonster(itemEx.uid) then
			name = doCorrectString(getCreatureName(itemEx.uid))
			if name == "Ditto" then
				doPlayerSendCancel(cid, "Your ditto can't transform into another ditto.")
				return true
			end
			if isInArray(not_ussable, name) then
				doPlayerSendCancel(cid, "Your ditto can't transform into this pokemon.")
				return true
			end
			if getPlayerLevel(cid) < poke_status[name].level then
				doPlayerSendCancel(cid, "You haven't level to transform into that pokemon.")
				return true
			end
			doDittoTransform(cid, name)
			return true
		end
	elseif getItemAttribute(getPlayerSlotItem(cid, 8).uid, "ehditto") == 2 and itemEx.uid == getCreatureSummons(cid)[1] then
		doDittoRevert(cid)
		return true
	end
	--------------- LIGHT SYSTEM --------------
	
	if isSummon(itemEx.uid) and getCreatureMaster(itemEx.uid) == cid then
		if hasSkill("light", pokename) then
			local cd = getCD(ball.uid, "light", 3000000)
			
			if cd > 0 then
				doPlayerSendCancel(cid, "You need wait "..getStringmytempo(cd).." to use flash again!")
				return true
			end
			
			doPlayerSay(cid, ""..nick..", "..msg["light"][math.random(1, #msg["light"])].."", 20)
			doCreatureSay(itemEx.uid, "FLASH!", TALKTYPE_MONSTER)
			doSendMagicEffect(getThingPos(itemEx.uid), 28)
			
			local size = 5
			size = size + math.random(1, 10)
			
			if size > 11 then
				size = 11
			end
			
			local condition = createConditionObject(CONDITION_LIGHT)
			setConditionParam(condition, CONDITION_PARAM_LIGHT_LEVEL, size)
			setConditionParam(condition, CONDITION_PARAM_LIGHT_COLOR, 215)
			setConditionParam(condition, CONDITION_PARAM_TICKS, 600*1000)
			
			doAddCondition(itemEx.uid, condition)
			local delay = 30
			if delay > 0 then
				setCD(ball.uid, "light", delay)
			end
			return true
		else
			doPlayerSendCancel(cid, "Your pokemon can't use light.")
		end
	end
	
	-------------- BLINK SYSTEM ----------------------------
	local cd = getCD(ball.uid, "blink", 30)
	if not isCreature(itemEx.uid) then
		if hasSkill("blink", pokename) then
			if isWalkable(toPosition, true) then
				if cd > 0 then
					doPlayerSendCancel(cid, "You need wait "..getStringmytempo(cd).." to use blink again!")
						doPlayerSay(cid, ""..nick..", "..msg["move"][math.random(1, #msg["move"])].."", 20)
						creatureGoToPos(pokemon, toPosition, 300)
					return true
				end
				doTeleportThing(pokemon, toPosition, false)
				doSendMagicEffect(toPosition, 134)
				doCreatureSetNoMove(pokemon, true)
				doCreatureSay(pokemon, "BLINK!", TALKTYPE_MONSTER)
				setCD(ball.uid, "blink", 30)
				doPlayerSay(cid, ""..pokename..", "..msg["blink"][math.random(1, #msg["blink"])].."", 20)
			else
				doPlayerSendCancel(cid, "Destination is not reachable.")
				return true
			end
		end
	end
	-------------- MOVE SYSTEM -----------------------------
	if itemEx.uid ~= cid then
		if getCreatureSpeed(pokemon) > 50 then
			if isWalkable(toPosition, true) then
				doPlayerSay(cid, ""..nick..", "..msg["move"][math.random(1, #msg["move"])].."", 20)
				doMoveCreatureTo(pokemon, toPosition, 800-getCreatureSpeed(pokemon))
			else
				doPlayerSendCancel(cid, "Destination is not reachable.")
			end
		end
	end
	
	return true
end