function markFlyingPos(sid, pos)
	if not isCreature(sid) then return end
	setPlayerStorageValue(sid, 33145, pos.x)
	setPlayerStorageValue(sid, 33146, pos.y)
	setPlayerStorageValue(sid, 33147, pos.z)
end

function getFlyingMarkedPos(sid)
	if not isCreature(sid) then return end
	local xx = getPlayerStorageValue(sid, 33145)
	local yy = getPlayerStorageValue(sid, 33146)
	local zz = getPlayerStorageValue(sid, 33147)
	return {x = xx, y = yy, z = zz, stackpos = 0}
end

function doRemoveFlyRide(cid)
	if isPlayer(cid) then
		doGoPokemon(cid)
		local pk = getCreatureSummons(cid)[1]
		doPlayerSay(cid, ""..getCreatureName(pk)..", let me get down!", 20)
		doCreatureSetLookDir(pk, getCreatureLookDir(cid))
		doTeleportThing(pk, getThingPos(cid), false)
		doRegainSpeed(cid)
		doRemoveCondition(cid, CONDITION_OUTFIT)
		setPlayerStorageValue(cid, 13241, -1)
		setPlayerStorageValue(cid, 13242, -1)
	end
end

function isFlying(cid)
	if isPlayer(cid) then
		if getPlayerStorageValue(cid, 13241) >= 1 then
			return true
		end
	end
	return false
end

function isRiding(cid)
	if isPlayer(cid) then
		if getPlayerStorageValue(cid, 13242) >= 1 then
			return true
		end
	end
	return false
end

function isSurfing(cid)
	if isPlayer(cid) then
		if getPlayerStorageValue(cid, 63215) >= 1 then
			return true
		end
	end
	return false
end

function doFly(cid)
	if isPlayer(cid) then
		local pokemon = getCreatureSummons(cid)[1]
		local pokename = getCreatureName(pokemon)
		if hasSkill("fly", pokename) then
			if #getCreatureSummons(cid) > 1 then
				return doPlayerSendCancel(cid, "You can't do it right now!")
			end
			local steps = creatureGoToPos(pokemon, getCreaturePosition(cid), 800-getCreatureSpeed(pokemon))
			addEvent(function()
				if getDistanceBetween(getCreaturePosition(pokemon), getCreaturePosition(cid)) <= 1 then
					local pokess = flys[pokename]
					doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", getCreatureHealth(pokemon))
					doPlayerSay(cid, ""..pokename..", "..msg["fly"][math.random(1, #msg["fly"])].."", 20)
					doPlayerSendTextMessage(cid, 27, "Type \"up\" or \"h1\" to fly/levitate higher and \"down\" or \"h2\" to fly/levitate lower.")
					doChangeSpeed(cid, pokess.speed + getCreatureSpeed(cid))
					addon = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "addon")
					if addon and PokeAddons[pokename][addon].fly then
						doSetCreatureOutfit(cid, {lookType = PokeAddons[pokename][addon].fly}, -1)
					else
						doSetCreatureOutfit(cid, {lookType = pokess.looktype}, -1)
					end
					setPlayerStorageValue(cid, 13241, 1)
					doRemoveCreature(pokemon)
				end
			end, steps*(800-getCreatureSpeed(pokemon)))
		end
	end
end 

function doRide(cid)
	if isPlayer(cid) then
		local pokemon = getCreatureSummons(cid)[1]
		local pokename = getCreatureName(pokemon)
		if hasSkill("ride", pokename) then
			if #getCreatureSummons(cid) > 1 then
				return doPlayerSendCancel(cid, "You can't do it right now!")
			end
			local steps = creatureGoToPos(pokemon, getCreaturePosition(cid), 800-getCreatureSpeed(pokemon))
			addEvent(function()
				if getDistanceBetween(getCreaturePosition(pokemon), getCreaturePosition(cid)) <= 1 then
					local pokes = rides[pokename]
					doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", getCreatureHealth(pokemon))
					doPlayerSay(cid, ""..pokename..", "..msg["ride"][math.random(1, #msg["ride"])].."", 20)
					doChangeSpeed(cid, pokes.speed + getCreatureSpeed(cid))
					addon = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "addon")
					if addon and PokeAddons[pokename][addon].ride then
						doSetCreatureOutfit(cid, {lookType = PokeAddons[pokename][addon].ride}, -1)
					else
						doSetCreatureOutfit(cid, {lookType = pokes.looktype}, -1)
					end
					setPlayerStorageValue(cid, 13242, 1)
					doRemoveCreature(pokemon)
				end
			end, steps*(800-getCreatureSpeed(pokemon)))
		end
	end
end