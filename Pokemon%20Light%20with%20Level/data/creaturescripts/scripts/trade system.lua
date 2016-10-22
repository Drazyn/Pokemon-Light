function onTradeRequest(cid, target, item)
	
	if isPokeballUse(item.itemid) then
		doPlayerSendCancel(cid, "You can't trade this item.")
		return false
	end
	
	if isPokeball(item.itemid) then
		local name = getItemAttribute(item.uid, "poke") --alterado v1.8 \/
		local nick = getItemAttribute(item.uid, "nick") or ""
		local gender = getPokeballGenderName(item.uid)
		local boost = getItemAttribute(item.uid, "boost")
		
		local str = "Pokemon in trade: "
		str = str.."Name: "..name.." - Gender: "..gender.." - Level: "..getItemAttribute(item.uid, "level")
		if nick ~= "" then 
			str = str.." - Nick: "..nick.."" 
		end
		if boost and boost > 0 then
			str = str.." - Boost: "..boost..""
		end
		doPlayerSendTextMessage(target, 20, str)
	end
	--alterado v1.8 \/
	if isContainer(item.uid) then
		local itens = getPokeballsInContainer(item.uid)
		if #itens >= 1 then 
			for i = 1, #itens do
				if isPokeball(getThing(itens[i]).itemid) then
					local name = getItemAttribute(itens[i], "poke") 
					local nick = getItemAttribute(itens[i], "nick") or ""
					local gender = getPokeballGenderName(itens[i])
					local boost = getItemAttribute(itens[i], "boost")
					
					local str = "Pokemon in trade: "
					str = str.."Name: "..name.." Gender: "..gender
					if nick ~= "" then 
						str = str.." Nick: "..nick..""
					end
					if boost and boost > 0 then
						str = str.." Boost: "..boost..""
					end
					doPlayerSendTextMessage(target, 20, str)
				end
			end
		end 
	end
	
	
	return true
end

local function noCap(cid, sid)
	if isCreature(cid) then
		doPlayerSendCancel(cid, "You can't carry more than six pokemons, trade cancelled.")
	end
	if isCreature(sid) then
		doPlayerSendCancel(sid, "You can't carry more than six pokemons, trade cancelled.")
	end
end

function onTradeAccept(cid, target, item, targetItem)
	local cancel = false
	
	if #getPlayerPokeballs(cid) >= 6 or #getPlayerPokeballs(target) >= 6  then --alterado v1.6
		cancel = true
	end
	
	if #getPokeballsInContainer(item.uid) >= 6 or #getPokeballsInContainer(targetItem.uid) >= 6 then
		cancel = true
	end
	
	if cancel then
		addEvent(noCap, 20, cid, target)
		return false
	end
	
	return true
end