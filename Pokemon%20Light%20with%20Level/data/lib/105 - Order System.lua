function hasSkill(skillname, pokename) 
	if skillname == "light" then
		return poke_special[pokename].light
	elseif skillname == "blink" then
		return poke_special[pokename].blink
	elseif skillname == "rock smash" then
		return poke_special[pokename].rocksmash
	elseif skillname == "cut" then
		return poke_special[pokename].cut
	elseif skillname == "dig" then
		return poke_special[pokename].dig
	elseif skillname == "teleport" then
		return poke_special[pokename].teleport
	elseif skillname == "fly" and flys[pokename] then
		return true
	elseif skillname == "ride" and rides[pokename] then
		return true
	elseif skillname == "surf" and surfs[pokename] then
		return true
	end
	return false
end

function doReturnItemsWithDelay(toPosition, itemid, times)
	local function doReturnItem(itemposition,oldid)
		local pos = getThingfromPos(itemposition)
		doTransformItem(pos.uid,oldid)
		doSetItemText(pos.uid, getItemNameById(oldid))	
	end
	addEvent(doReturnItem, times * 1000,toPosition, itemid)
end

function doMoveCreatureTo(uid, position, delay) 
    if not isOnSameFloor(getCreaturePosition(uid), position) then -- Não sei se o getCreaturePathTo Funciona com floors diferentes...
        return isPlayer(uid) and doPlayerSendCancel(uid, "You are not in the same floor of destination.") or false
    end 
    local range = getDistanceBetween(getCreaturePosition(uid), position)*10 -- DIstance entre creature e end pos
    local path = getCreaturePathTo(uid, position, range) or {} -- Tabela com todas as direções
    for i = 1, #path do
        addEvent(function() -- Delay em cada passo
            if isCreature(uid) then -- Verifica se é criatura
                if getCreatureSpeed(uid) > 50 then
                    if isWalkable(position, true, false, false) then
                        local fromPos = fromPos or getCreaturePosition(uid) -- Define o frompos
                        dir = path[i] -- Define a direção
                        toPos = getPosByDir(fromPos, dir) -- define a proxima pos
                        toPos.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
                        doTeleportThing(uid, toPos)
                        fromPos = toPos
                    end
                end
            end
        end, delay * i)
    end
    return i
end

function doCut(cid, toPosition, itemEx)
	if isCreature(cid) then
		if  not (#getCreatureSummons(cid) >= 1) then
			return true
		end
		pokemon = getCreatureSummons(cid)[1]
		name = doCorrectString(getCreatureName(pokemon))
		nick = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nick") or name
		pos = getThingFromPos(toPosition)
		if isInArray(cuti, itemEx.itemid) then
			if hasSkill("cut", name) then
				doPlayerSay(cid, nick..", "..msg["cut"][math.random(1, #msg["cut"])], 20)
				doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "true")
				local steps = creatureGoToPos(pokemon, toPosition, 800-getCreatureSpeed(pokemon))
				addEvent(function()
					doFaceCreature(pokemon, toPosition)--minDistEff
					addEvent(function()
						if getDistanceBetween(getCreaturePosition(pokemon), toPosition) <= 1 then
							doSendMagicEffect(toPosition, SpecialAbility["cut"][name] and SpecialAbility["cut"][name].minDistEff or 142)
							local pos = getThingfromPos(toPosition)
							doCreatureSay(pokemon, "CUT!", TALKTYPE_MONSTER)--3
							doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "false")
							doTransformItem(pos.uid, 6216)
							doReturnItemsWithDelay(toPosition, itemEx.itemid, 15)
						end
					end, 150)
					doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "false")
				end, steps*(800-getCreatureSpeed(pokemon)))	
			else
				doPlayerSendCancel(cid, "Your pokemon can't use cut.")
			end
		end
	end
end

function doRockSmash(cid, toPosition, itemEx)
	if isCreature(cid) then
		if  not (#getCreatureSummons(cid) >= 1) then
			return true
		end
		pokemon = getCreatureSummons(cid)[1]
		name = doCorrectString(getCreatureName(pokemon))
		nick = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nick") or name
		pos = getThingFromPos(toPosition)
		if isInArray(rocksmashi, itemEx.itemid) then
			if hasSkill("rock smash", name) then
				doPlayerSay(cid, nick..", "..msg["rock smash"][math.random(1, #msg["rock smash"])], 20)
				doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "true")
				local steps = creatureGoToPos(pokemon, toPosition, 800-getCreatureSpeed(pokemon))
				addEvent(function()
					doFaceCreature(pokemon, toPosition)--minDistEff
					addEvent(function()
						if getDistanceBetween(getCreaturePosition(pokemon), toPosition) <= 1 then
							doSendMagicEffect(toPosition, SpecialAbility["rock smash"][name] and SpecialAbility["rock smash"][name].minDistEff or 142)
							local pos = getThingfromPos(toPosition)
							doCreatureSay(pokemon, "ROCK SMASH!", TALKTYPE_MONSTER)--3
							doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "false")
							doTransformItem(pos.uid, 6216)
							doReturnItemsWithDelay(toPosition, itemEx.itemid, 15)
						end
					end, 150)
					doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "block", "false")
				end, steps*(800-getCreatureSpeed(pokemon)))	
			else
				doPlayerSendCancel(cid, "Your pokemon can't use rock smash.")
			end
		end
	end
end