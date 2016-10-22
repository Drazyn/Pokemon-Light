local ballcatch = {
	[7621] = {rate = 3, on = 193, off = 192, send = 56, balltype = "pokeball", typeee = "normal"}, -- Pokeball Catch
	[7625] = {rate = 6, on = 198, off = 197, send = 57, balltype = "greatball", typeee = "great"}, -- 7763
	[7763] = {rate = 7, on = 204, off = 203, send = 36, balltype = "safariball", typeee = "safari"},
	[7629] = {rate = 9, on = 202, off = 201, send = 55, balltype = "superball", typeee = "super"},
	[7632] = {rate = 12, on = 200, off = 199, send = 58, balltype = "ultraball", typeee = "ultra"},
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local pball = item.itemid
	local corpse = getTopCorpse(toPosition)
	local topos = toPosition
	
	if corpse == null then
		return false
	end

	if getItemAttribute(corpse.uid, "catching") == 1 then
		doPlayerSendCancel(cid, "You are not allowed to catch this pokemon.")
		return true
	end

	--[[if getItemAttribute(corpse.uid, "ownercorpse") ~= getCreatureName(cid) then
        doPlayerSendCancel(cid, "You're not the owner.")
        return true
    end]]

    local gender = getItemAttribute(corpse.uid, "gender")
	
	local name = string.lower(getItemNameById(corpse.itemid))
	name = string.gsub(name, "fainted ", "")
	name = string.gsub(name, "defeated ", "")
	name = doCorrectPokemonName(name)
	local tpoke = poke_catch[name]
	local typeee = ballcatch[item.itemid].typeee
	
	if not tpoke then 
		return false 
	end

  	local storage = poke_catch[name].stoCatch 
	if getPlayerStorageValue(cid, storage) == -1 or not string.find(getPlayerStorageValue(cid, storage), ";") then --alterado v1.9 
		setPlayerStorageValue(cid, storage, "normal = 0, great = 0, super = 0, ultra = 0, saffari = 0;") --alterado v1.9 
	end 
	
	local balltype = ballcatch[pball].balltype
	
	local catchinfo = {}
	catchinfo.rate = ballcatch[pball].rate
	catchinfo.catch = ballcatch[pball].on
	catchinfo.fail = ballcatch[pball].off 
	catchinfo.name = doCorrectPokemonName(name)
	catchinfo.topos = toPosition
	catchinfo.chance = tpoke.chance
	catchinfo.gender = gender
	catchinfo.level = getItemAttribute(corpse.uid, "level")
	
	doSendDistanceShoot(getCreaturePosition(cid), topos, ballcatch[pball].send)
	doRemoveItem(item.uid, 1)

	--[[local safari = false
	local safariSto = 98796
	local SafariOut = getCreaturePosition(cid)

	if getPlayerStorageValue(cid, safariSto) >= 1 and getPlayerItemCount(cid, 7763) <= 0 and safari then --alterado v1.9
		setPlayerStorageValue(cid, safariSto, -1) 
		setPlayerStorageValue(cid, 98797, -1) 
		doTeleportThing(cid, SafariOut, false)
		doSendMagicEffect(getThingPos(cid), 21)
		doPlayerSendTextMessage(cid, 27, "You spend all your saffari balls, good luck in the next time...")
	end]]

	local d = getDistanceBetween(getThingPos(cid), topos)
	doBrokesCount(cid, poke_catch[doCorrectPokemonName(name)].stoCatch, typeee)
	addEvent(function() -- Send Ball
		doSendPokeBall(cid, catchinfo, false, false, balltype, typeee, level)
	end, d * 70 + 100 - (d * 14))
	return true
end