function getDittoSlots(item)
    if not item or item < 1 then
        return false
    elseif not getItemAttribute(item, "ehditto") and getItemAttribute(item, "poke") ~= "Ditto" then
        return false
    end
    local slots = {}
    for i = 1, maxSlots do
        local attr = getItemAttribute(item, "memory"..i)
        if attr then
            slots[i] = attr
        end
    end
    return slots
end
function hasDittoSavedPokemon(item, name)
    if not item or item < 1 then
        return false
    elseif not getItemAttribute(item, "ehditto") and getItemAttribute(item, "poke") ~= "Ditto" then
        return false
    end
    local check
    for i = 1, maxSlots do
        local attr = getItemAttribute(item, "memory"..i)
        if attr and attr == name then
            check = true
            break
        end
    end
    return check
end

function isDittoBall(cid)
	if isPlayer(cid) then
		if getItemAttribute(getPlayerSlotItem(cid, 8).uid, "ehditto") then
			return true
		end
	end
	return false
end

function doDittoTransform(cid, pokemon) -- Editado por Drazyn1291 (Gabriel Lucena)
    if isPlayer(cid) then
        local ditto = getCreatureSummons(cid)[1]
        local oldpos = getThingPos(ditto)
        local oldlod = getCreatureLookDir(ditto)
        local pokemon = doCorrectPokemonName(pokemon)
        if isDittoBall(cid) then
            doSendMagicEffect(getCreaturePosition(ditto), 184)
            doTransformItem(getPlayerSlotItem(cid, 7).uid, poke_special[pokemon].fotopoke)
            doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "poke", pokemon)
            doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "ehditto", 2)
            doCreatureSay(cid, "Ditto, transform into a "..pokemon.."!", TALKTYPE_MONSTER)
            doCreatureSay(ditto, "TRANSFORM!", TALKTYPE_MONSTER)
            doRemoveCreature(ditto)
			doGoPokemon(cid, oldpos)
            local pokemons = getCreatureSummons(cid)[1]
            if #getCreatureSummons(cid) >= 1 then
	            doCreatureSetLookDir(pokemons, oldlod)
            end
        end
    end
end

function doDittoRevert(cid) -- Editado por Drazyn1291 (Gabriel Lucena)
	if isPlayer(cid) then
		if isDittoBall(cid) then
			local ditto = getCreatureSummons(cid)[1]
			local pos = getCreaturePosition(ditto)
			local oldpos = getThingPos(ditto)
			local oldlod = getCreatureLookDir(ditto)
			doSendMagicEffect(getCreaturePosition(ditto), 184)
			doTransformItem(getPlayerSlotItem(cid, 7).uid, poke_special["Ditto"].fotopoke)
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "poke", "Ditto")
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "ehditto", 1)
			doCreatureSay(cid, "Ditto, untransfrom!", TALKTYPE_MONSTER)
			doCreatureSay(ditto, "TRANSFORM!", TALKTYPE_MONSTER)
			doRemoveCreature(ditto)
			doGoPokemon(cid)
			local pk = getCreatureSummons(cid)[1]
			doTeleportThing(pk, oldpos, true, false)
			doCreatureSetLookDir(pk, oldlod)
		end
	end
end