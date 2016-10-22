pokeballs_CATCH = { -- Catch para ON
	[7621] = 7622, --POKEBALL ON
	[7625] = 7626, --GREATBALL ON
	[7629] = 7630, --SUPERBALL ON
	[7632] = 7633, --ULTRABALL ON
	[7763] = 7764
}

pokeballs_ON = { -- USE para ON
	[7623] = 7622, -- poke
	[7627] = 7626, -- great
	[7631] = 7630, -- super
	[7634] = 7633, -- ultra
	[7765] = 7764 -- Safari
}

pokeballs_USE = { -- ON para USE
	[7622] = 7623,
	[7626] = 7627,
	[7630] = 7631,
	[7633] = 7634,
	[7764] = 7765
}

pokeballs_OFF = { -- ON para OFF
	[7623] = 7624,
	[7627] = 7628,
	[7631] = 7631,
	[7634] = 7635,
	[7765] = 7766
}

pokeballs_OFF_ON = { -- OFF para ON
	[7624] = 7622,
	[7628] = 7626,
	[7631] = 7630,
	[7635] = 7633,
	[7766] = 7764
}

pokeballs_EFFECT = {
	[7622] = 188, -- on
	[7623] = 188, -- Off
	[7626] = 189, -- 
	[7627] = 189,
	[7630] = 190,
	[7631] = 190,
	[7633] = 191,
	[7634] = 191,
	[7764] = 195,
	[7765] = 195,
}

pokeballs_TYPE = {
	["pokeball"] = 7622,
	["greatball"] = 7626,
	["superball"] = 7630,
	["ultraball"] = 7633,
	["safariball"] = 7764
}

pokeballs_TYPE_BLOCK = {
	["pokeball"] = 14552, -- 14552;14553;14554;14555;14551
	["greatball"] = 14553,
	["superball"] = 14554,
	["ultraball"] = 14555,
	["safariball"] = 14551
}

pokeballs_block = { -- Catch para ON
	[14552] = 7622, --POKEBALL ON
	[14553] = 7626, --GREATBALL ON
	[14554] = 7630, --SUPERBALL ON
	[14555] = 7633, --ULTRABALL ON
	[14551] = 7764 -- Safari
}

back_messages = {"Muito bom, ",	 "Foi impecável, ",	"Volte, ", "Chega, ", "Grande, "} -- back
go_messages = {"Hora do duelo, ", "Vai, ",	"Faça seu trabalho, ", "Prepare-se, ", "Chegou sua hora, "} -- go

function doTransportBallToDepot(ball)
	itemss = doCreateItemEx(pokeballs_TYPE_BLOCK[getPokeballType(ball.itemid)]-1, 1)
	doCopyStatusBall(cid, ball, itemss)
	doPlayerSendMailByName(getCreatureName(cid), itemss, 1)
	doRemoveItem(ball.uid)
end

function doCopyStatusBall(cid, oldid, newid)
	if isPlayer(cid) then
		oldStatus1 = getAllPokeballStatus(oldid)[1]
		oldStatus2 = getAllPokeballStatus(oldid)[2]
		for i=1, #oldStatus1 do			
			if string.find(oldStatus2[i], "cd:") then
				if getCD(oldid, oldStatus1[i], 1000) > 0 then
					setCD(newid, oldStatus1[i], getCD(oldid, oldStatus1[i], 1000))
				end
			else
				doItemSetAttribute(newid, oldStatus1[i], oldStatus2[i])
			end
		end
	end
end

function doReturnPokemon(cid, all)
    if isPlayer(cid) then
        local itemid = getPlayerSlotItem(cid, 8).itemid
        if isPokeball(itemid) then
            if #getCreatureSummons(cid) >= 1 then
                local pokemon = getCreatureSummons(cid)[1]
                if all then
                	local nick = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nick") or getCreatureName(pokemon)
                	local msg_back = back_messages[math.random(#back_messages)]
					doReloadPokeballStatus(getPlayerSlotItem(cid, 8).uid)
                    doTransformItem(getPlayerSlotItem(cid, 8).uid, pokeballs_ON[itemid])
                    doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", getCreatureHealth(pokemon))
                    doCreatureSay(cid, msg_back..""..nick.."!", TALKTYPE_ORANGE_1)
                    showPokeballEffect(getCreaturePosition(pokemon), itemid)
                end
                doRemoveCreature(pokemon)
                return true
            end
        end
    end
end

function doGoPokemon(cid, all)
    if isPlayer(cid) then
        if isPokeball(getPlayerSlotItem(cid, 8).itemid) then
            if isPokeballOff(getPlayerSlotItem(cid, 8).itemid) then
                doPlayerSendCancel(cid, "This pokemon has fainted!")
                return true
            end
            local pokename = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke")
            local maxHp = getPokeballMaxHealth(getPlayerSlotItem(cid, 8).uid)
            local Hp = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "hp")
            local SpeedP = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "speed")
            local gender = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "gender")
            local msg_back = back_messages[math.random(#back_messages)]
            local msg_go = go_messages[math.random(#go_messages)]
            local level = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "level")
			local addon = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "addon")

            if not gender == 3 or not gender == 4 then
            	gender = 5
            end	

            if #getCreatureSummons(cid) > 1 then
                doPlayerSendCancel(cid, "You is using a ".. pokename .."!")
                return true
            end
            
            if isInArray(not_ussable, pokename) then
                doPlayerSendCancel(cid, "You can't use this pokemon!")
                return true
            end
            
            if getPlayerLevel(cid) < poke_status[pokename].level then
                doPlayerSendCancel(cid, "Missing ".. poke_status[pokename].level - getPlayerLevel(cid).. " level(s) to you use "..pokename.."!")
                return true
            end
            local nick = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nick") or pokename
			if all and all ~= true and all ~= false then
				pos = all
			else
				pos = getThingPos(cid)
			end
            local pokemon = doCreateMonsterNick(cid, pokename, nick.." [".. level .."]", pos or getThingPos(cid), true)
            if #getCreatureSummons(cid) >= 1 then
            	local pokemon = getCreatureSummons(cid)[1]
				if isGhostByName(pokename) then
					setPokemonGhost(pokemon)
				end
				doReloadPokeballStatus(getPlayerSlotItem(cid, 8).uid)
				setCreatureLevel(pokemon, level)
	            setCreatureMaxHealth(pokemon, maxHp)
	            doCreatureSetSkullType(pokemon, gender)
	            doCreatureAddHealth(pokemon, maxHp)
	            doCreatureAddHealth(pokemon, Hp-maxHp)
	            doChangeSpeed(pokemon, SpeedP)
	            adjustStatus(pokemon, getPlayerSlotItem(cid, 8).uid)
	            onPokeHealthChange(cid)
				if addon then
					doSetCreatureOutfit(pokemon, {lookType = PokeAddons[pokename][addon].looktype}, -1)
				end
				if all == true then
	                doCreatureSay(cid, msg_go..""..nick.."!", TALKTYPE_ORANGE_1)
	                showPokeballEffect(getCreaturePosition(getCreatureSummons(cid)[1]), getPlayerSlotItem(cid, 8).itemid)
	                doTransformItem(getPlayerSlotItem(cid, 8).uid, pokeballs_USE[getPlayerSlotItem(cid, 8).itemid])
	            end
        	end
        end
    end
end

function doPlayerAddPokemon(cid, poke, ball, gender, level, boost) -- 998537 - 734
	local mail = false
	if not ball then
		ball = "pokeball"
	end	
	local genders = {
		["male"] = 4,
		["female"] = 3,
		[1] = 4,
		[0] = 3,
		[4] = 4,
		[3] = 3,
	}
	if not boost then
		boost = 0
	end
	if not genders[gender] then
		GENDER = getRandomGenderByName(poke)
	else
		GENDER = genders[gender]
	end
	if not level then
		level = math.random(0, PokemonMaxLevel)
	else
		level = tonumber(level)
		if level >= 100 then
			level = tonumber(100)
		end
	end
	if poke then
		if #getPlayerPokeballs(cid) >= 6 or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then
        	item = doCreateItemEx(pokeballs_TYPE_BLOCK[ball]-1, 1)
        	mail = true
		else
			item = addItemInFreeBag(getPlayerSlotItem(cid, 3).uid, balltypeToItem(ball), 1)
		end
		if poke == "Ditto" then
			doItemSetAttribute(item, "ehditto", 1)
		end
		doItemSetAttribute(item, "poke", poke) -- Nome do Pokemon
		doItemSetAttribute(item, "speed", poke_status[poke].speed + 150) -- Speed Pokémon
		doItemSetAttribute(item, "ball", ball)
		doItemSetAttribute(item, "gender", GENDER) -- 15232
		doItemSetAttribute(item, "level", level)
		doItemSetAttribute(item, "boost", boost)
		doItemSetAttribute(item, "maxhp", getPokeballMaxHealth(item))
		doItemSetAttribute(item, "hp", getPokeballMaxHealth(item))
		doItemSetAttribute(item, "attack", getStatusFormula(poke_status[name].attack, level, 0))
		doItemSetAttribute(item, "defense",  getStatusFormula(poke_status[name].defense, level, 0))
		doItemSetAttribute(item, "spattack",  getStatusFormula(poke_status[name].sp_attack, level, 0))
		doItemSetAttribute(item, "spdefense",  getStatusFormula(poke_status[name].sp_defense, level, 0))
		doItemSetAttribute(item, "addtm", 0)
		doItemSetAttribute(item, "totaltm", 0)
		if mail then
			doPlayerSendMailByName(getCreatureName(cid), item, 1, cid) -- pokeballs_ON
			doPlayerSendTextMessage(cid, 27, "Since you are already holding six pokemons, this pokeball has been sent to your depot.") 
		end
	end
end

function isPokeballBlock(itemid)
	if pokeballs_block[itemid] then
		return true
	end
	return false
end

function balltypeToItem(name)
	if pokeballs_TYPE[name] then
		return pokeballs_TYPE[name]
	end
	return 7622
end

function isPokeballOn(itemid)
	if pokeballs_USE[itemid] then
		return true
	end
	return false 
end

function isPokeballUse(itemid)
	if pokeballs_ON[itemid] then
		return true
	end
	return false 
end

function isPokeballOff(itemid)
	if pokeballs_OFF_ON[itemid] then
		return true
	end
	return false 
end

function getPokeballsInContainer(container)
	local pokeballs = {}
	if isContainer(container) and getContainerSize(container) > 0 then
		for slot=0, (getContainerSize(container)-1) do
			local item = getContainerItem(container, slot)
			if isContainer(item.uid) then
				local itemsbag = getPokeballsInContainer(item.uid)
				for i, pokeball in pairs(itemsbag) do
					table.insert(pokeballs, pokeball)
				end
			else
				if isPokeball(item.itemid) then
					table.insert(pokeballs, item)
				end
			end
		end
	end
	return pokeballs
end

function doCureBallStatus(ball)
	if isPokeball(ball.itemid) then
		doItemSetAttribute(ball.uid, "hp", getPokeballMaxHealth(ball.uid))
		doTransformItem(ball.uid, pokeballs_TYPE[getPokeballType(ball.itemid)])
		for i = 1, 13 do
			setCD(ball.uid, "cm_move"..i, 0)
		end
		setCD(ball.uid, "control", 0)
		setCD(ball.uid, "blink", 0)
		onPokeHealthChange(cid)
	end
end

function getPlayerPokeballs(cid)
	local pokeballs = {}
	for slot = CONST_SLOT_FIRST, CONST_SLOT_LAST do
		local item = getPlayerSlotItem(cid, slot)
		if isContainer(item.uid) then
			local pokeballsEx = getPokeballsInContainer(item.uid)
			for i, pokeball in pairs(pokeballsEx) do
				table.insert(pokeballs, pokeball) 
			end
		end
		
		if isPokeball(item.itemid) then
			table.insert(pokeballs, item)
		end
	end
	return pokeballs
end

function isPokeball(itemid)
	if isPokeballOn(itemid) then
		return true
	end
	if isPokeballUse(itemid) then
		return true
	end
	if isPokeballOff(itemid) then
		return true
	end
	if isPokeballBlock(itemid) then
		return true
	end
	return false
end

function showPokeballEffect(pos, itemid)
	if isPokeball(itemid) then
		if pokeballs_EFFECT[itemid] then
			doSendMagicEffect(pos, pokeballs_EFFECT[itemid])
			return true
		end
	end
end

function getPokeballType(item)
	if isPokeball(item) then
		if isInArray({7621, 7622, 7623, 7624}, item) then -- 
			balltype = "pokeball"
		elseif isInArray({7625, 7626, 7627, 7628}, item) then
			balltype = "greatball"
		elseif isInArray({7629, 7630, 7631, 7636}, item) then
			balltype = "superball"
		elseif isInArray({7632, 7633, 7634, 7635}, item) then
			balltype = "ultraball"
		elseif isInArray({7763, 7764, 7765, 7766}, item) then
			balltype = "safariball"
		end
		return balltype
	end
	return "pokeball"
end