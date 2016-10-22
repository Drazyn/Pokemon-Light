function getPlayerAccoutStorageValue(cid, key)
	return getAccountStorageValue(getPlayerAccountId(cid), key)
end

function setPlayerAccoutStorageValue(cid, key, value)
	return setAccountStorageValue(getPlayerAccountId(cid), key, value)
end

function getPlayersInArea(fromPos, toPos) -- function by amoeba13
    playersInArea = {}
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            for z = fromPos.z, toPos.z do
                totalArea = {x=x, y=y, z=z}
                playerz = getTopCreature(totalArea)
                if isPlayer(playerz.uid) then
                    table.insert(playersInArea, playerz.uid)
                    
                end
            end
        end
    end
    return playersInArea
end

function doConcatTable(itemsss, sep1, sep2)
	str = ""
	for i = 1, #itemsss do
		if #itemsss > 1 then
			if i ~= #itemsss then
				if i ~= 1 then
					str = str..sep1..itemsss[i]
				else
					str = str..itemsss[i]
				end
			else
				str = str..sep2..itemsss[i]
			end
		else
			str = itemsss[i]
		end
	end
	return str
end

function getPlayerItems(cid, id) -- By OrochiElf
    local retItems = {}

    for slots = 1, 10 do
        local item = getPlayerSlotItem(cid, slots)
        if isContainer(item.uid) then
            for slotsBp = 0, getContainerSize(item.uid)-1 do
                local itemBp = getContainerItem(item.uid, slotsBp)
                if id ~= nil then
                    if itemBp.itemid == id then

                        table.insert(retItems, itemBp)
                    end
                else

                    table.insert(retItems, itemBp)
                end
            end
        end
        if id ~= nil then
            if item.itemid == id then

                table.insert(retItems, item)
            end
        else

            table.insert(retItems, item)
        end
    end
    return retItems
end

function getFreeHouses()
local towns = getTownList()
local houses = {}

	for i = 1, #towns do
	local list = getTownHouses(towns[i].id)
		for j = 1, #list do
			if list[j] then
				if getHouseOwner(list[j]) == 0 then
					table.insert(houses, list[j])
				end
			end
		end
	end
	if(#houses == 0) then
	return nil
	end
return houses
end

function getAccountStorageValue(accid, key)
	local value = db.getResult("SELECT `value` FROM `account_storage` WHERE `account_id` = " .. accid .. " and `key` = " .. key .. " LIMIT 1;")
	if(value:getID() ~= -1) then
		return value:getDataInt("value")
	else
		return -1
	end
	value:free()
end

function setAccountStorageValue(accid, key, value)
	local getvalue = db.getResult("SELECT `value` FROM `account_storage` WHERE `account_id` = " .. accid .. " and `key` = " .. key .. " LIMIT 1;")
	if(getvalue:getID() ~= -1) then
		db.executeQuery("UPDATE `account_storage` SET `value` = " .. accid .. " WHERE `key`=" .. key .. " LIMIT 1');")
		getvalue:free()
		return 1
	else
		db.executeQuery("INSERT INTO `account_storage` (`account_id`, `key`, `value`) VALUES (" .. accid .. ", " .. key .. ", '"..value.."');")
		return 1
	end
end

function getAllPokeballStatus(ball)
	ret, ret1 = {}, {}
	if isPokeball(getThing(ball).itemid) then
		for i=1, #PokeballAtributes do
			if getItemAttribute(ball, PokeballAtributes[i]) then
				table.insert(ret, i, PokeballAtributes[i])
				table.insert(ret1, i, getItemAttribute(ball, PokeballAtributes[i]))
			end
		end
		for i =1, maxSlots do -- Para saber todos os slots de memória caso ter algum
			local attr = getItemAttribute(ball, "memory"..i)
			if attr then
				table.insert(ret, i, "memory"..i)
				table.insert(ret1, i, attr)				
			end
		end
		for i =1, 13 do
			if getItemAttribute(ball, "move"..i) then
				table.insert(ret, i, "move"..i)
				table.insert(ret1, i, getItemAttribute(ball, "move"..i))				
			end	
		end
		for i=1, 13 do
			if getItemAttribute(ball, "cm_move"..i) then
				table.insert(ret, i, "cm_move"..i)
				table.insert(ret1, i, getItemAttribute(ball, "cm_move"..i))	
			end		
		end
	end
	return {ret, ret1}
end

function getStatusFormula(value, level, boost)
	if boost and tonumber(boost) > 0 and tonumber(boost) <= BoostLimit then
		val = mathpercent(value, PokeLevelExtraStatus)
		val1 = mathpercent(value, PercentBoostExtra)
		val = val*level
		val1 = val1*tonumber(boost)
		return math.ceil(value+val+val1)
	else
		val = mathpercent(value, PokeLevelExtraStatus)
		val = val*level
		return math.ceil(value+val)
	end
	return value
end

function getOffense(cid)
    if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1001))
end

function getDefense(cid)
    if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1002))
end

function getSpecialAttack(cid)
    if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1003))
end

function getSpecialDefense(cid)
    if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1004))
end

function adjustWildPoke(cid)
    name = doCorrectString(getCreatureName(cid))
    if isMonster(cid) and poke_status[name] then
		offense = getStatusFormula(poke_status[name].attack, getCreatureLevel(cid), 0)
		defense = getStatusFormula(poke_status[name].defense, getCreatureLevel(cid), 0)
		spAttack = getStatusFormula(poke_status[name].sp_attack, getCreatureLevel(cid), 0)
		spDefense = getStatusFormula(poke_status[name].sp_defense, getCreatureLevel(cid), 0)
        setPlayerStorageValue(cid, 1001, offense)
        setPlayerStorageValue(cid, 1002, defense)
        setPlayerStorageValue(cid, 1003, spAttack)
		setPlayerStorageValue(cid, 1004, spDefense)
        doRegainSpeed(cid)
    end
end

function doReloadPokemon(cid, poke)
	if isPlayer(cid) then
		local poke = getCreatureSummons(cid)[1]
		if poke then
			local oldPos = getCreaturePosition(poke)
			local oldDir = getCreatureLookDir(poke)
			doReturnPokemon(cid)
			doGoPokemon(cid, oldPos)
			doCreatureSetLookDir(getCreatureSummons(cid)[1], oldDir)
		end
	end
end

function doReloadPokeballStatus(ball)
	if isPokeball(getThing(ball).itemid) then
		name = getItemAttribute(ball, "poke")
		level = getItemAttribute(ball, "level")
		boost = getItemAttribute(ball, "boost") or 0
		doItemSetAttribute(ball, "attack", getStatusFormula(poke_status[name].attack, level, boost))
		doItemSetAttribute(ball, "defense",  getStatusFormula(poke_status[name].defense, level, boost))
		doItemSetAttribute(ball, "spattack",  getStatusFormula(poke_status[name].sp_attack, level, boost))
		doItemSetAttribute(ball, "spdefense",  getStatusFormula(poke_status[name].sp_defense, level, boost))
	end
end

function getPokeballOffense(ball)
	boost = getItemAttribute(ball, "boost") or 0
	level = getItemAttribute(ball, "level") or 0
	if isPokeball(getThing(ball).itemid) then
		return getItemAttribute(ball, "attack") and getItemAttribute(ball, "attack") or getStatusFormula(poke_status[name].sp_defense, level, boost)
	end
end 

function getPokeballDefense(ball)
	boost = getItemAttribute(ball, "boost") or 0
	level = getItemAttribute(ball, "level") or 0
	if isPokeball(getThing(ball).itemid) then
		return getItemAttribute(ball, "defense") and getItemAttribute(ball, "defense") or getStatusFormula(poke_status[name].sp_defense, level, boost)
	end
end

function getPokeballSpecialOffense(ball)
	boost = getItemAttribute(ball, "boost") or 0
	level = getItemAttribute(ball, "level") or 0
	if isPokeball(getThing(ball).itemid) then
		return getItemAttribute(ball, "spattack") and getItemAttribute(ball, "spattack") or getStatusFormula(poke_status[name].sp_defense, level, boost)
	end
end  

function getPokeballSpecialDefense(ball)
	boost = getItemAttribute(ball, "boost") or 0
	level = getItemAttribute(ball, "level") or 0
	if isPokeball(getThing(ball).itemid) then
		return getItemAttribute(ball, "spdefense") and getItemAttribute(ball, "spdefense") or getStatusFormula(poke_status[name].sp_defense, level, boost)
	end
	return 0
end 

function adjustStatus(pk, item)

    if not isCreature(pk) then return true end
    name = doCorrectString(getCreatureName(pk))
	level = getCreatureLevel(pk)
	boost = getItemAttribute(item, "boost") or 0
	
	offense = getPokeballOffense(item)
	defense = getPokeballDefense(item)
	spAttack = getPokeballSpecialOffense(item)
	spDefense = getPokeballSpecialDefense(item)
    setPlayerStorageValue(pk, 1001, offense)
    setPlayerStorageValue(pk, 1002, defense)             
    setPlayerStorageValue(pk, 1003, spAttack)
	setPlayerStorageValue(pk, 1004, spDefense)
                                                                      
    doRegainSpeed(pk) 

    if isSummon(pk) and conditions then
        local burn = getItemAttribute(item, "burn")    -- setItemAttribute(item, "burn")
        if burn and burn >= 0 then
           local ret = {id = pk, cd = burn, check = false, damage = getItemAttribute(item, "burndmg"), cond = "Burn"}
           addEvent(doCondition2, 3500, ret)
        end

        local poison = getItemAttribute(item, "poison")
        if poison and poison >= 0 then
           local ret = {id = pk, cd = poison, check = false, damage = getItemAttribute(item, "poisondmg"), cond = "Poison"}
           addEvent(doCondition2, 1500, ret)
        end

        local confuse = getItemAttribute(item, "confuse")
        if confuse and confuse >= 0 then
           local ret = {id = pk, cd = confuse, check = false, cond = "Confusion"}
           addEvent(doCondition2, 1200, ret)                                                
        end

        local sleep = getItemAttribute(item, "sleep")
        if sleep and sleep >= 0 then
           local ret = {id = pk, cd = sleep, check = false, first = true, cond = "Sleep"}
           doCondition2(ret)
        end
        
        local miss = getItemAttribute(item, "miss")     
        if miss and miss >= 0 then      
          local ret = {id = pk, cd = miss, eff = getItemAttribute(item, "missEff"), check = false, spell = getItemAttribute(item, "missSpell"), cond = "Miss"}
          doCondition2(ret)
        end
        
        local fear = getItemAttribute(item, "fear")
        if fear and fear >= 0 then
           local ret = {id = pk, cd = fear, check = false, skill = getItemAttribute(item, "fearSkill"), cond = "Fear"}
           doCondition2(ret)
        end
        
        local silence = getItemAttribute(item, "silence")
        if silence and silence >= 0 then      
           local ret = {id = pk, cd = silence, eff = getItemAttribute(item, "silenceEff"), check = false, cond = "Silence"}
           doCondition2(ret)
        end                                     
        
        local stun = getItemAttribute(item, "stun")
        if stun and stun >= 0 then
           local ret = {id = pk, cd = stun, eff = getItemAttribute(item, "stunEff"), check = false, spell = getItemAttribute(item, "stunSpell"), cond = "Stun"}
           doCondition2(ret)
        end 
                                                       
        local paralyze = getItemAttribute(item, "paralyze")
        if paralyze and paralyze >= 0 then
           local ret = {id = pk, cd = paralyze, eff = getItemAttribute(item, "paralyzeEff"), check = false, first = true, cond = "Paralyze"}
           doCondition2(ret)
        end  
                                                     
        local slow = getItemAttribute(item, "slow")
        if slow and slow >= 0 then
           local ret = {id = pk, cd = slow, eff = getItemAttribute(item, "slowEff"), check = false, first = true, cond = "Slow"}
           doCondition2(ret)
        end                                              
        
        local leech = getItemAttribute(item, "leech")
        if leech and leech >= 0 then
           local ret = {id = pk, cd = leech, attacker = 0, check = false, damage = getItemAttribute(item, "leechdmg"), cond = "Leech"}
           doCondition2(ret)
        end                               
        
        for i = 1, 3 do
            local buff = getItemAttribute(item, "Buff"..i)
            if buff and buff >= 0 then
               local ret = {id = pk, cd = buff, eff = getItemAttribute(item, "Buff"..i.."eff"), check = false, 
               buff = getItemAttribute(item, "Buff"..i.."skill"), first = true, attr = "Buff"..i}
               doCondition2(ret)
            end
        end
               
    end
return true
end

function isStone(itemid)
	if isInArray(StoneTable, itemid) then
		return true
	end
	return false
end

function isWater(itemid)
	if isInArray(WATER, itemid) then
		return true
	end
	return false
end

function isGhostByName(name)
	name = doCorrectPokemonName(name)
	if isInArray(GhostPokemons, name) then
		return true
	end
	return false
end

function setPokemonGhost(cid)
	if isSummon(cid) then
		setPlayerStorageValue(cid, 5032, 1)
	end
end

ITEM_INVISIVEL = 1653

function jump(cid, rounds)
    doChangeSpeed(cid, -getCreatureSpeed(cid))
    doCreatureSetNoMove(cid, true)
    for i = 1, rounds do
        addEvent(function()
            if isCreature(cid) then
                local pos = getThingPos(cid)
                local item = doCreateItem(ITEM_INVISIVEL, 1, pos)
                addEvent(function()
                    local it = getTileItemById(pos, ITEM_INVISIVEL).uid
                    if it > 0 then
                        doRemoveItem(it)
                    end
                    if i == rounds then
                        doRegainSpeed(cid)
                        doCreatureSetNoMove(cid, false)
                    end
                end, rounds == 1 and 400 or (i + 2) * 150)
            end
        end, i * (rounds == 1 and 400 or 300))
    end
end
--[[Use jump(cid, 1) para um pulo de altura "1" (como o causado pelo Earthquake), e jump(cid, 2) para pulos como do Heavy Slam.
	Código do Heavy Slam:
		local config = {
			areas = {area1, area2}, --Áreas, em ordem de execução.
			effect = 160, --Efeito.
			combat = NORMALDAMAGE, --Elemento.
		}
		local function doPushCreature(target, cid)
			if target > 0 then
				if not isNpc(target) then
					local position = getThingPosition(cid)
					local fromPosition = getThingPosition(target)
					local x = ((fromPosition.x - position.x) < 0 and -1 or ((fromPosition.x - position.x) == 0 and 0 or 1))
					local y = ((fromPosition.y - position.y) < 0 and -1 or ((fromPosition.y - position.y) == 0 and 0 or 1))
					local toPosition = {x = fromPosition.x + x, y = fromPosition.y + y, z = fromPosition.z}
					if doTileQueryAdd(target, toPosition) == 1 and getTileInfo(toPosition).house == false then
						doTeleportThing(target, toPosition, true)
					end
				end
			end
		end
		jump(cid, 2)
		addEvent(function()
			for i = 0, #config.areas - 1 do
				addEvent(function()
					local pos = getPosfromArea(cid, config.areas[i + 1])
					doMoveInArea2(cid, config.effect, config.areas[i + 1], config.combat, min, max)
					for j = 1, #pos do
						local pid = getTopCreature(pos[j]).uid
						if ehMonstro(pid) then
							doPushCreature(pid, cid)
						elseif isSummon(pid) then
							local master = getCreatureMaster(pid)
							if isSummon(cid) then
								if getPlayerStorageValue(master, 52480) >= 1 and getPlayerStorageValue(master, 52481) >= 0 then
									local masterCid = getCreatureMaster(cid)
									if isDuelingAgainst(masterCid, master) then
										doPushCreature(pid, cid)
									end
								end
							else
								doPushCreature(pid, cid)
							end
						end
					end
				end, i * 230)
			end
		end, 650)
]]

function getPlayerLanguage(cid) -- By Acubens
    local Lang = db.getResult("SELECT `language` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid) .. " LIMIT 1")
    if Lang:getID() ~= LUA_ERROR then
        local langid = Lang:getDataInt("language")
        Lang:free()
        return langid
    end
    return LUA_ERROR
end

function doPlayerSetLanguage(cid, new) -- By Drazyn1291
    local acc = getPlayerAccountId(cid)
    if new == 1 then
        db.executeQuery("UPDATE `accounts` SET language = 1 WHERE `id` = " .. acc)
    else
        db.executeQuery("UPDATE `accounts` SET language = 0 WHERE `id` = " .. acc)
    end  
end

function onPokeHealthChange(cid, zerar)
    if not isCreature(cid) then 
        return true 
    end
    if zerar == true then 
        doPlayerSendCancel(cid, '#ph#,0,0') 
    end
    local ball = getPlayerSlotItem(cid, 8).uid
    if not ball or ball <= 1 or not poke_special[getItemAttribute(ball, 'poke')] then 
        return true 
    end

    local pokename = getItemAttribute(ball, 'poke')
    
    if #getCreatureSummons(cid) >= 1 then --alterado v1.6
        local pokemon = getCreatureSummons(cid)[1]
        doItemSetAttribute(ball, "hp", getCreatureHealth(pokemon))
    end
    maxHp = math.ceil(getPokeballMaxHealth(ball))
    doPlayerSendCancel(cid, "#ph#,"..getItemAttribute(ball, "hp")..","..maxHp)--opcode
end

function getTopCorpse(position) -- Retorna o Corpse que está em cima
    local pos = position
    for n = 1, 255 do
        pos.stackpos = n
        local item = getTileThingByPos(pos)
        if item.itemid >= 2 and (string.find(getItemNameById(item.itemid), "fainted ") or string.find(getItemNameById(item.itemid), "defeated ")) then
            return getTileThingByPos(pos)
        end
    end
    return nil
end

function doCorrectString(str)
    local name = str:explode(" ") --alterado v1.9
    local final = {}
    for _, s in ipairs(name) do
        table.insert(final, s:sub(1, 1):upper()..s:sub(2, #s):lower())
    end
    return table.concat(final, (name[2] and " " or ""))
end

doCorrectPokemonName = doCorrectString

function getPokemonLevel(cid)
    if isMonster(cid) then
        return getCreatureLevel(cid)
    end
    return 1
end

function hasSpaceInContainer(container) --alterado v1.6
    if not isContainer(container) then return false end
    if getContainerSize(container) < getContainerCap(container) then return true end
    
    for slot = 0, (getContainerSize(container)-1) do
        local item = getContainerItem(container, slot)
        if isContainer(item.uid) then
            if hasSpaceInContainer(item.uid) then
                return true
            end
        end
    end
    return false
end

function addItemInFreeBag(container, item, num)
    if not isContainer(container) then return false end 
    if not item then return false end
    if not num then num = 1 end --alterado v1.6.1
    if getContainerSize(container) < getContainerCap(container) then
        return doAddContainerItem(container, item, num)
    else
        for slot = 0, (getContainerSize(container)-1) do
            local container2 = getContainerItem(container, slot)
            if isContainer(container2.uid) and getContainerSize(container2.uid) < getContainerCap(container2.uid) then
                return doAddContainerItem(container2.uid, item, num)
            end
        end
    end
    return false
end

function isSummon(target)
    if isCreature(target) then
        if getCreatureMaster(target) and isPlayer(getCreatureMaster(target)) then
            if getCreatureMaster(target) ~= target then
                return true
            end
        end
    end
    return false
end

function doMathDecimal(number, casas)
    
    if math.floor(number) == number then return number end
    
    local c = casas and casas + 1 or 3
    
    for a = 0, 10 do
        if math.floor(number) < math.pow(10, a) then
            local str = string.sub(""..number.."", 1, a + c)
            return tonumber(str) 
        end
    end
    
    return number
end

function ehNPC(cid) -- Verifica se é NPC
    return isCreature(cid) and not isPlayer(cid) and not isSummon(cid) and not isMonster(cid)
end

function ehMonstro(cid) -- Verifica se é monstro
    return cid and cid >= AUTOID_MONSTERS and cid < AUTOID_NPCS
end

function hasTile(pos) --Verifica se tem TILE na pos
    pos.stackpos = 0
    if getTileThingByPos(pos).itemid >= 1 then
        return true
    end
    return false
end

function getTileThingWithProtect(pos) --Pega um TILE com proteçoes
    if hasTile(pos) then
        pos.stackpos = 0
        pid = getTileThingByPos(pos)
    else
        pid = getTileThingByPos({x=1,y=1,z=10,stackpos=0})
    end
    return pid
end

function isShiny(cid) 
    return isCreature(cid) and isShinyName(getCreatureName(cid)) --alterado v1.9
end

function isShinyName(name) 
    return tostring(name) and string.find(doCorrectString(name), "Shiny") --alterado v1.9
end

bpslot = CONST_SLOT_BACKPACK

function isNpcSummon(cid)
    return isNpc(getCreatureMaster(cid))
end

function doPlayerSendTextWindow(cid, p1, p2)
    if not isCreature(cid) then return true end
    local item = 460
    local text = ""
    if type(p1) == "string" then
        doShowTextDialog(cid, item, p1)
    else
        doShowTextDialog(cid, p1, p2)
    end
end

function doRemoveElementFromTable(t, e)
    local ret = {}
    for a = 1, #t do
        if t[a] ~= e then
            table.insert(ret, t[a])
        end
    end
    return ret
end

function setCD(item, tipo, tempo)
    
    if not tempo or not tonumber(tempo) then
        doItemEraseAttribute(item, tipo)
        return true
    end
    
    doItemSetAttribute(item, tipo, "cd:"..(tempo + os.time()).."")
    return tempo + os.time()
end

function getCD(item, tipo, limite)
    
    if not getItemAttribute(item, tipo) then
        return 0
    end
    
    local string = getItemAttribute(item, tipo):gsub("cd:", "")
    local number = tonumber(string) - os.time()
    
    if number <= 0 then
        return 0
    end
    
    if limite then
        if limite < number then
            return 0
        end
    end
    
    return number
end

function threeNumbers(number)
    if number <= 9 then
        return "00"..number..""
    elseif number <= 99 then
        return "0"..number..""
    end
    return ""..number..""
end

function doCreateTile(id,pos) -- By mock
    doAreaCombatHealth(0,0,pos,0,0,0,CONST_ME_NONE)
    doCreateItem(id,1,pos)
end

function canWalkOnPos(pos, creature, pz, water, sqm, proj)
    if not pos then return false end
    if not pos.x then return false end
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid <= 1 and sqm then return false end
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 919 then return false end
    if isInArray({4820, 4821, 4822, 4823, 4824, 4825}, getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid) and water then return false end
    if getTopCreature(pos).uid > 0 and creature then return false end
    if getTileInfo(pos).protection and pz then return false end
    local n = not proj and 3 or 2 --alterado v1.6
    for i = 0, 255 do
        pos.stackpos = i 
        local tile = getTileThingByPos(pos) 
        if tile.itemid ~= 0 and i ~= 253 and not isCreature(tile.uid) then --edited
            if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
                return false
            end
        end
    end 
    return true
end

function getFreeTile(pos, cid)
    if canWalkOnPos(pos, true, false, true, true, false) then
        return pos
    end
    local positions = {}
    for a = 0, 7 do
        if canWalkOnPos(getPosByDir(pos, a), true, false, true, true, false) then
            table.insert(positions, pos)
        end
    end
    if #positions >= 1 then
        if isCreature(cid) then
            local range = 1000
            local ret = getThingPos(cid)
            for b = 1, #positions do
                if getDistanceBetween(getThingPos(cid), positions[b]) < range then
                    ret = positions[b]
                    range = getDistanceBetween(getThingPos(cid), positions[b])
                end
            end
            return ret
        else
            return positions[math.random(#positions)]
        end
    end
    return getThingPos(cid)
end

function getItemsInContainerById(container, itemid) -- Function By Kydrai
    local items = {}
    if isContainer(container) and getContainerSize(container) > 0 then
        for slot=0, (getContainerSize(container)-1) do
            local item = getContainerItem(container, slot)
            if isContainer(item.uid) then
                local itemsbag = getItemsInContainerById(item.uid, itemid)
                for i=0, #itemsbag do
                    table.insert(items, itemsbag[i])
                end
            else
                if itemid == item.itemid then
                    table.insert(items, item.uid)
                end
            end
        end
    end
    return items
end

function doPlayerAddItemStacking(cid, itemid, quant) 
    local item = getItemsInContainerById(getPlayerSlotItem(cid, 3).uid, itemid)
    local piles = 0
    if #item > 0 then
        for i,x in pairs(item) do
            if getThing(x).type < 100 then
                local it = getThing(x)
                doTransformItem(it.uid, itemid, it.type+quant)
                if it.type+quant > 100 then
                    doPlayerAddItem(cid, itemid, it.type+quant-100)
                end
            else
                piles = piles+1
            end
            break
        end
    else
        return doPlayerAddItem(cid, itemid, quant)
    end
    if piles == #item then
        doPlayerAddItem(cid, itemid, quant)
    end
end

function getPokemonGender(cid) 
    if isMonster(cid) then
        if getCreatureSkullType(cid) == 4 then
            return 4
        elseif getCreatureSkullType(cid) == 3 then
            return 3
        end
        return 5
    end
end

function getPokemonGenderName(cid) 
    if isMonster(cid) then
        if getCreatureSkullType(cid) == 4 then
            return "male"
        elseif getCreatureSkullType(cid) == 3 then
            return "female"
		else
			return "genderless"
        end
        return 5
    end
end

function getPokeballGenderName(uid) 
	--if isPokeball(getThing(uid).itemid) then
		if getItemAttribute(uid, "gender") == 4 then
			return "male"
		elseif getItemAttribute(uid, "gender") == 3 then
			return "female"
		end
	--end
	return "genderless"
end

function getRandomGenderByName(name)
    local namer = doCorrectString(name)
    
    if not poke_status[namer] then 
        return 5
    end
    
    local rate = poke_status[namer].gender
    
    if rate == 0 then
        gender = 3 -- fêmea
    elseif rate == 1000 then
        gender = 4
    elseif rate == -1 then
        gender = 0
    elseif rate > 1000 then
        gender = 5
    elseif math.random(1, 1000) <= rate then
        gender = 4
    else
        gender = 3
    end
    return gender
end

function doSetRandomGender(cid)   
    if not isCreature(cid) then 
        return true 
    end 
    local name = getCreatureName(cid) 
    doCreatureSetSkullType(cid, getRandomGenderByName(name))
    doCreatureSetStorage(cid, 4321, gender)
end

function mathpercent(full, percent)
    Percent = percent/100
    total = full*Percent
    return total
end

function getMaxHealthByName(name, level, gender)
    name = doCorrectString(name)
    if poke_status[name] then
		if level and isNumber(level) then
			if level >= 100 then
				level = 100
			end
        end
        hp = poke_status[name].hp
        maxHp = (hp * 10) + (20*level)-20
		if gender then
			if gender == 3 then
				maxHp = maxHp + (mathpercent(maxHp, 10))
			elseif gender == 5 then
				maxHp = maxHp + (mathpercent(maxHp, 5))
			end
		end
    end
    return maxHp
end

function getPokeballMaxHealth(uid)
    if getItemAttribute(uid, "poke") then
        name = doCorrectString(getItemAttribute(uid, "poke"))
        level = getItemAttribute(uid, "level") or 1
        gender = getItemAttribute(uid, "gender")
		boost = getItemAttribute(uid, "boost")
		if boost and tonumber(boost) > 0 and tonumber(boost) <= BoostLimit then
			percent = mathpercent(getMaxHealthByName(name, level, gender), PercentBoostExtra)
			percent = percent*boost
			return getMaxHealthByName(name, level, gender)+percent
		else
			return getMaxHealthByName(name, level, gender)
		end
    end
end

function canAttackOther(cid, pid) --Function q verifica se um poke/player pode atacar outro poke/player
    
    if not isCreature(cid) or not isCreature(pid) then 
        return false 
    end
    
    if ehMonstro(cid) or ehMonstro(pid) then
        return true
    end
    
    if getTileInfo(getThingPos(cid)).pvp then
        return true
    end
    
    return false
end