failmsgs = {
	"Sorry, you didn't catch that pokemon.",
	"Sorry, your pokeball broke.",
	"Sorry, the pokemon escaped.",
}

-- Catch System Start

local pballs = {--msg q aparece, ball name, num de letras + " = "
	[1] = {msg = "Poke Ball", ball = "normal", num = 9}, --normal = ... 9 letras
	[2] = {msg = "Great Ball", ball = "great", num = 8}, --great = ... 8 letras
	[3] = {msg = "Super Ball", ball = "super", num = 8},
	[4] = {msg = "Ultra Ball", ball = "ultra", num = 8}, --edited brokes count system
	[5] = {msg = "Saffari Ball", ball = "saffari", num = 10},
}
 
function CW_Caught(cid, pokeName)
	local name = doCorrectPokemonName(pokeName)
    local str = poke_catch[name].stoCatch
    doPlayerSendCancel(cid, "%#CatcherWindow@"..getItemInfo(poke_special[name].fotopoke).clientId.."@"..name.."@"..poke_catch[name].exp.."@"..getPlayerStorageValue(cid, str))
    setPlayerStorageValue(cid, str, "normal = 0, great = 0, super = 0, ultra = 0, saffari = 0")
    return true
end

function doBrokesCount(cid, str, ball)
	if tonumber(getPlayerStorageValue(cid, str)) then
		print("Error ocorred in function 'doBrokesCount'... storage "..str.." is a number value")
		print("Storage will be changed to the correct table...")
		doPlayerSendTextMessage(cid, 27, "A error ocorred... Warning sent to Game Masters!")
		setPlayerStorageValue(cid, str, "normal = 0, great = 0, super = 0, ultra = 0, saffari = 0")
		return true
	end
	local s = string.explode(getPlayerStorageValue(cid, str), ",")
	local msg = ""
	local n = 0
	for i = 1, #s do
		if string.find(tostring(s[i]), ball) then
			local d, e = s[i]:find(""..pballs[i].ball.." = (.-)")
			local st2 = string.sub(s[i], d + pballs[i].num, e +5)
			local num = tonumber(st2)+1
			
			if num == 0 and ball == pballs[i].ball then
				num = 1
			end
			if i == #s then
				msg = msg..""..ball.." = "..num
				n = n +1
			else
				msg = msg..""..ball.." = "..num..", "
				n = n +1
			end
		else
			if i == #s then
				msg = msg..s[i]
			else
				msg = msg..s[i]..", "
			end
		end
	end
	setPlayerStorageValue(cid, str, msg)
end

function doSendFailMessageBrokes(cid, name, str) --alterado v1.9 \/ TUDO!!
	if not isCreature(cid) then return false end
	local storage = getPlayerStorageValue(cid, str)
	
	local t = "normal = (.-), great = (.-), super = (.-), ultra = (.-), saffari = (.-);"
	local msg = {}
	table.insert(msg, "You have used ")
	
	for n, g, s, u in storage:gmatch(t) do
		if tonumber(n) and tonumber(n) > 0 then 
			table.insert(msg, tostring(n).." Poke ball".. (tonumber(n) > 1 and "s" or "")) 
		end
		if tonumber(g) and tonumber(g) > 0 then 
			table.insert(msg, (#msg > 1 and ", " or "").. tostring(g).." Great ball".. (tonumber(g) > 1 and "s" or "")) 
		end
		if tonumber(s) and tonumber(s) > 0 then 
			table.insert(msg, (#msg > 1 and ", " or "").. tostring(s).." Super ball".. (tonumber(s) > 1 and "s" or "")) 
		end
		if tonumber(u) and tonumber(u) > 0 then 
			table.insert(msg, (#msg > 1 and ", " or "").. tostring(u).." Ultra ball".. (tonumber(u) > 1 and "s" or "")) 
		end
		if tonumber(s2) and tonumber(s2) > 0 then 
			table.insert(msg, (#msg > 1 and ", " or "").. tostring(s2).." Saffari ball".. (tonumber(s2) > 1 and "s" or "")) 
		end
	end
	if #msg == 1 then
		return doPlayerSendTextMessage(cid, 27, "You haven't wasted any ball thying to catch a "..name..".")
	end
	if string.sub(msg[#msg], 1, 1) == "," then
		msg[#msg] = " and".. string.sub(msg[#msg], 2, #msg[#msg])
	end
	table.insert(msg, " trying to catch a "..name..".")
	return doPlayerSendTextMessage(cid, 27, table.concat(msg))
end

function doSendPokeBall(cid, catchinfo, showmsg, fullmsg, balltype, typeee, level)
    local name = catchinfo.name
    local pos = catchinfo.topos
    local rate = catchinfo.rate
    local corpse = getTopCorpse(pos).uid
    local catch = catchinfo.catch
    local fail = catchinfo.fail
    local basechance = catchinfo.chance
    local gender = catchinfo.gender
    local level = catchinfo.level
    
    if not isCreature(cid) then
        doSendMagicEffect(pos, CONST_ME_POFF)
        return true
    end

    doItemSetAttribute(corpse, "catching", 1)
--------------------------------------------------------------------    
    local levelChance = level * 0.02
    local totalChance = math.ceil(basechance * (1.2 + levelChance))
    local thisChance = math.random(0, totalChance)
    local myChance = math.random(0, totalChance)
    local chance = (1 * rate + 1) / totalChance
    chance = doMathDecimal(chance * 100)
-------------------------------------------------------------------- 
    if #getCreatureSummons(cid) >= 1 then
    	doSendMagicEffect(getCreaturePosition(getCreatureSummons(cid)[1]), 89)
    end   
    if rate >= totalChance then 
        doRemoveItem(corpse, 1)
        doSendMagicEffect(pos, catch)
        addEvent(doCapturePokemon, 3500, cid, name, balltype, gender, typeee, level) 
        return true
    end

    if totalChance <= 1 then 
        totalChance = 1 
    end
    
    local myChances = {}
    local catchChances = {}
    
    for cC = 0, totalChance do
        table.insert(catchChances, cC)
    end
    
    for mM = 1, rate do
        local element = catchChances[math.random(1, #catchChances)]
        table.insert(myChances, element)
        catchChances = doRemoveElementFromTable(catchChances, element)
    end
    
    doRemoveItem(corpse, 1)
    
    local doCatch = false
    
    for check = 1, #myChances do
        if thisChance == myChances[check] then
            doCatch = true
        end
    end
    
    if doCatch then
        if #getCreatureName(cid) >= 1 then
        	doSendMagicEffect(getCreaturePosition(getCreatureSummons(cid)[1]), 89)
        end
        doSendMagicEffect(pos, catch)
        addEvent(doCapturePokemon, 3500, cid, name, balltype, gender, typeee, level) 
    else
        addEvent(function()
            doPlayerSendTextMessage(cid, 27, failmsgs[math.random(#failmsgs)])
	        doSendFailMessageBrokes(cid, name, poke_catch[name].stoCatch)
        end, 3000)
        doSendMagicEffect(pos, fail)
    end
end

function doCapturePokemon(cid, poke, balltype, gender, typeee, level) 
    if not isCreature(cid) then
        return true
    end
    doPlayerSendTextMessage(cid, 27, "Congratulations, you caught a "..poke.."!")
    doPlayerAddPokemon(cid, poke, balltype, gender, level)
    doAddCatchList(cid, poke)
    CW_Caught(cid, poke)
    local msg = "[Catch Channel] O Jogador [".. getCreatureName(cid) .."] Capturou um ["..poke.."]!"
    for _, oid in ipairs(getPlayersOnline()) do
        doPlayerSendChannelMessage(oid, "", msg, TALKTYPE_CHANNEL_W, 10)
    end
    if #getCreatureSummons(cid) >= 1 then
    	doSendMagicEffect(getCreaturePosition(getCreatureSummons(cid)[1]), 102)
    end
end

function doAddCatchList(cid, poke)
    if isPlayer(cid) then
        if poke_catch[poke].stoCatch == -1 then
            doPlayerAddExperience(cid, pokecatch[poke].exp)
            doPlayerSetSkillLevel(cid, 3, getPlayerAllCatch(cid)+1)
            doPlayerSendTextMessage(cid, 27, "You won ".. pokecatch[poke].exp.. " exp for caught ".. poke .."!")
        end
    end
end

function getPlayerAllCatch(cid)
    if isPlayer(cid) then
        return getPlayerSkillLevel(cid, 3)
    end
    return 0
end
