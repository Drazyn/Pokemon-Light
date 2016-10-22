function onLook(cid, thing, position, lookDistance)

    if getPlayerLanguage(cid) == 1 then
        if not isCreature(thing.uid) then
            local house = getHouseFromPos(position)
            if house then
                local article = thing.type > 1 and thing.type.." " or getItemArticleById(thing.itemid)..(getItemArticleById(thing.itemid) == "" and "" or " ")
                local plural = getItemPluralNameById(thing.itemid) == "" and getItemNameById(thing.itemid).."s" or getItemPluralNameById(thing.itemid)
                local desc = getItemSpecialDescription(thing.uid) == "" and "" or getItemSpecialDescription(thing.uid).." "
                local str = "You see "..(article)..""..(thing.type > 1 and plural or getItemNameById(thing.itemid))..".\nO nome dessa casa é '"..getHouseName(house).."'."
                if getHouseOwner(house) ~= 0 then
                    str = str.." ".. getPlayerNameByGUID( getHouseOwner(house) ).." é dono dessa casa."
                else
                    str = str.." Ninguém é dono dessa casa. \nEla custa "..getHousePrice(house).." dólares."
                end
                if getPlayerAccess(cid) > 2 then
                    str = str.."\nItemID: ["..(thing.itemid).."]"
                    if thing.actionid > 0 then
                        str = str..", ActionID: ["..(thing.actionid).."]"
                    end
                    if thing.uid < 65536 then
                        str = str..", UniqueID: ["..(thing.uid).."]"
                    end
                    str = str..".\nPosition: [X: "..(getThingPos(thing.uid).x).."] [Y: "..(getThingPos(thing.uid).y).."] [Z: "..(getThingPos(thing.uid).z).."]."
                end
                return doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, str) and false
            end
        end
    end

    local str = {}
    
    if not isCreature(thing.uid) then
        local iname = getItemInfo(thing.itemid)
        if isPokeball(thing.itemid) and getItemAttribute(thing.uid, "poke") then -- Caso for pokeball
            local pokename = getItemAttribute(thing.uid, "poke")
            onPokeHealthChange(cid)
            table.insert(str, "You see "..iname.article.." "..iname.name..".") 
                
            if getItemAttribute(thing.uid, "ehditto") == 2 then
                table.insert(str, "\nIt contains "..getArticle(pokename).." "..pokename..". (Ditto) \n")
            else
				table.insert(str, "\nIt contains "..getArticle(pokename).." "..pokename..".\n")
            end
 			if getItemAttribute(thing.uid, "addon") then
				table.insert(str, "Addon: "..getItemAttribute(thing.uid, "addon")..".\n")
			end	           
            local level = getItemAttribute(thing.uid, "level")
            table.insert(str, "Level: "..level..".\n")
            if getItemAttribute(thing.uid, "nick") then -- Nick System
                table.insert(str, "Nick: "..getItemAttribute(thing.uid, "nick")..".\n")
            end
			if getItemAttribute(thing.uid, "boost") and getItemAttribute(thing.uid, "boost") > 0 then
				table.insert(str, "Boost: "..getItemAttribute(thing.uid, "boost")..".\n")
			end		
            table.insert(str, "It is ".. getPokeballGenderName(thing.uid) ..".\n")
			if pokesPrice[pokename] then
				table.insert(str, "Price: $"..pokesPrice[pokename].price..".")
			else
				table.insert(str, "Price: unsellable.")
			end 
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
            return false     
        elseif string.find(iname.name, "fainted") or string.find(iname.name, "defeated") then -- Corpse Look
            
            table.insert(str, "You see a "..string.lower(iname.name)..". \n") 
            table.insert(str, "Level: "..getItemAttribute(thing.uid, "level").."\n")
			table.insert(str, "It is ".. getPokeballGenderName(thing.uid) ..".")
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
            return false
        else
			local article = thing.type > 1 and thing.type.." " or getItemArticleById(thing.itemid)..(getItemArticleById(thing.itemid) == "" and "" or " ")
			local plural = getItemPluralNameById(thing.itemid) == "" and getItemNameById(thing.itemid).."s" or getItemPluralNameById(thing.itemid)
			local desc = getItemInfo(thing.itemid).description
			local str = "You see "..(article)..""..(thing.type > 1 and plural or getItemNameById(thing.itemid))..".\n"..desc
			if getPlayerAccess(cid) > 2 then
				str = str.."\nItemID: ["..(thing.itemid).."]"
				if thing.actionid > 0 then
					str = str..", ActionID: ["..(thing.actionid).."]"
				end
				if thing.uid < 65536 then
					str = str..", UniqueID: ["..(thing.uid).."]"
				end
				str = str..".\nPosition: [X: "..(getThingPos(thing.uid).x).."] [Y: "..(getThingPos(thing.uid).y).."] [Z: "..(getThingPos(thing.uid).z).."]."
				str = str.."\nClientID: ["..getItemInfo(thing.itemid).clientId.."]."
			end
			return doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, str) and false
        end
    end
    
    if not isPlayer(thing.uid) and not isMonster(thing.uid) then --outros npcs
        table.insert(str, "You see "..getCreatureName(thing.uid)..".")
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
        return false
    end
    
    if not isSummon(thing.uid) and isMonster(thing.uid) then --monstros
        
        table.insert(str, "You see a Wild "..string.lower(getCreatureName(thing.uid))..".\n")
        table.insert(str, "Life: ["..getCreatureHealth(thing.uid).." / "..getCreatureMaxHealth(thing.uid).."].\n")
        table.insert(str, "Level: ".. getCreatureLevel(thing.uid).." \n")
        table.insert(str, "It is ".. getPokemonGenderName(thing.uid) ..".")
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
        return false
        
    elseif isSummon(thing.uid) and not isPlayer(thing.uid) then --summons
        
        if getCreatureMaster(thing.uid) == cid then
            local myball = getPlayerSlotItem(cid, 8).uid
            table.insert(str, "You see your "..string.lower(getCreatureName(thing.uid))..".")
            table.insert(str, "\nHit points: ["..getCreatureHealth(thing.uid).."/"..getCreatureMaxHealth(thing.uid).."].")
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
        else
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You see a "..string.lower(getCreatureName(thing.uid))..".\nIt belongs to "..getCreatureName(getCreatureMaster(thing.uid))..".")
        end
        return false
    end
    return true
end