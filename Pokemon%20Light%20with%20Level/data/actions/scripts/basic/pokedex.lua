function onUse(cid, item, fromPos, itemEx, toPos)
	if isPokeball(itemEx.itemid) and getItemAttribute(itemEx.uid, "poke") then
		name = getItemAttribute(itemEx.uid, "poke")
		str = "Name: "..name.."\n"
		str = str.."Level: ".. getItemAttribute(itemEx.uid, "level").."\n"
		if getItemAttribute(itemEx.uid, "boost") and getItemAttribute(itemEx.uid, "boost") > 0 then
			str = str.."Boost: ".. getItemAttribute(itemEx.uid, "boost") .."\n"
		end
		str = str.."Max Hp: "..getItemAttribute(itemEx.uid, "maxhp").."\n"
		str = str.."Attack: "..getPokeballOffense(itemEx.uid).."\n"
		str = str.."Defense: "..getPokeballDefense(itemEx.uid).."\n"
		str = str.."Special Attack: "..getPokeballSpecialOffense(itemEx.uid).."\n"
		str = str.."Special Defense: "..getPokeballSpecialDefense(itemEx.uid).."\n"
		str = str.."\nMoves: \n"..table.concat(getPokemonMoves(cid, itemEx), "\n").."\n"
		rare = getItemAttribute(itemEx.uid, "rarecandy")
		if rare then
			str = str.."\nRare Candy used: "..rare
		end
		doShowTextDialog(cid, poke_special[name].fotopoke, str)
    elseif isCreature(itemEx.uid) and not isPlayer(itemEx.uid) then
        local pokemon = itemEx.uid
        local name = doCorrectString(getCreatureName(itemEx.uid))
        local newsto = poke_catch[name].stoCatch - 500
        if isSummon(pokemon) then
            if getPlayerLevel(cid) >= poke_status[name].level and getPlayerStorageValue(cid, newsto) <= 0 then
                doRegisterPokemonInPokedex(cid, name)
            elseif getPlayerLevel(cid) < poke_status[name].level and getPlayerStorageValue(cid, newsto) <= 0 then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You need to be at least level " .. name .. " to unlock this pokemon.")
            elseif getPlayerStorageValue(cid, newsto) >= 1 then
                doOpenPokedex(cid, name)
            end 
        elseif isMonster(pokemon) then
            if getPlayerStorageValue(cid, newsto) <= 0 then
                doRegisterPokemonInPokedex(cid, name)
            elseif getPlayerStorageValue(cid, newsto) >= 1 then
                doOpenPokedex(cid, name)
            end
        end
    elseif not isCreature(itemEx.uid) then
        local corpse = getTopCorpse(toPos)
        if corpse == null then
            return false
        end
        local name = getItemNameById(corpse.itemid)
        if name:find("fainted") then
            name = doCorrectPokemonName(name:gsub("fainted ", ""))
            local newsto = poke_catch[name].stoCatch - 500
            if getPlayerStorageValue(cid, newsto) < 1 then
                doRegisterPokemonInPokedex(cid, name)
            else
                doOpenPokedex(cid, name)
            end
        end
    end
    
    if isPlayer(itemEx.uid) then
        if getCreatureName(cid) == getCreatureName(itemEx.uid) then
            doPlayerSendTextMessage(cid, 18, "You have unlocked " .. getAllPokedex(cid) .. " pokemons already.")
        else
            doPlayerSendTextMessage(cid, 18, getPlayerName(itemEx.uid) .. " has unlocked " .. getAllPokedex(itemEx.uid) .. " pokemons already.")
        end
    end
    
    return true
end