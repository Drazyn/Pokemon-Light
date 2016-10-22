local combats = { 
	[PSYCHICDAMAGE] = {cor = COLOR_PSYCHIC, type = "psychic"},
	[GRASSDAMAGE] = {cor = COLOR_GRASS, type = "grass"},
	[POISONEDDAMAGE] = {cor = COLOR_GRASS, type = "poison"},
	[FIREDAMAGE] = {cor = COLOR_FIRE2, type = "fire"}, 
	[BURNEDDAMAGE] = {cor = COLOR_BURN, type = "fire"},
	[WATERDAMAGE] = {cor = COLOR_WATER, type = "water"},
	[ICEDAMAGE] = {cor = COLOR_ICE, type = "ice"},
	[NORMALDAMAGE] = {cor = COLOR_NORMAL, type = "normal"},
	[FLYDAMAGE] = {cor = COLOR_FLYING, type = "flying"}, 
	[GHOSTDAMAGE] = {cor = COLOR_GHOST, type = "ghost"},
	[GROUNDDAMAGE] = {cor = COLOR_GROUND, type = "ground"},
	[ELECTRICDAMAGE] = {cor = COLOR_ELECTRIC, type = "eletric"},
	[ROCKDAMAGE] = {cor = COLOR_ROCK, type = "rock"},
	[BUGDAMAGE] = {cor = COLOR_BUG, type = "bug"},
	[FIGHTDAMAGE] = {cor = COLOR_FIGHTING, type = "fight"},
	[DRAGONDAMAGE] = {cor = COLOR_DRAGON, type = "dragon"},
	[POISONDAMAGE] = {cor = COLOR_POISON, type = "poison"},
	[DARKDAMAGE] = {cor = COLOR_DARK, type = "dark"}, 
	[STEELDAMAGE] = {cor = COLOR_STEEL, type = "steel"},
	[MIRACLEDAMAGE] = {cor = COLOR_PSYCHIC, type = "ghost"}, 
	[DARK_EYEDAMAGE] = {cor = COLOR_GHOST, type = "dark"},
	[SEED_BOMBDAMAGE] = {cor = COLOR_GRASS, type = "grass"},
	[SACREDDAMAGE] = {cor = COLOR_FIRE2, type = "none"}, 
	[MUDBOMBDAMAGE] = {cor = COLOR_GROUND, type = "none"}, --alterado v1.9
}

local races = {
	[4] = {cor = COLOR_FIRE2},
	[6] = {cor = COLOR_WATER},
	[7] = {cor = COLOR_NORMAL},
	[8] = {cor = COLOR_FIRE2},
	[9] = {cor = COLOR_FIGHTING},
	[10] = {cor = COLOR_FLYING},
	[11] = {cor = COLOR_GRASS},
	[12] = {cor = COLOR_POISON},
	[13] = {cor = COLOR_ELECTRIC},
	[14] = {cor = COLOR_GROUND},
	[15] = {cor = COLOR_PSYCHIC},
	[16] = {cor = COLOR_ROCK},
	[17] = {cor = COLOR_ICE},
	[18] = {cor = COLOR_BUG},
	[19] = {cor = COLOR_DRAGON},
	[20] = {cor = COLOR_GHOST},
	[21] = {cor = COLOR_STEEL},
	[22] = {cor = COLOR_DARK},
	[1] = {cor = 180},
	[2] = {cor = 180},
	[3] = {cor = 180},
	[5] = {cor = 180},
}

local fixdmgs = {PSYCHICDAMAGE, COMBAT_PHYSICALDAMAGE, GRASSDAMAGE, FIREDAMAGE, WATERDAMAGE, ICEDAMAGE, NORMALDAMAGE, GHOSTDAMAGE}

local function doPlayerSendDamageText(cid, text)
	if not isCreature(cid) then return true end
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, text)
end

function onCombat(cid, target)
	if isPlayer(target) and #getCreatureSummons(target) >= 1 then
		return false
	end
	return true
end

function onStatsChange(cid, attacker, type, combat, value)
	local damageCombat = combat
	valor = value
	
	if isSummon(attacker) then -- Summon não pode atacar master
		if cid == getCreatureMaster(attacker) then
			return false
		end
	end
	
	if not isCreature(attacker) then -- Caso use algo tipo de dano, sem "master" atacante 
		if not isInArray(fixdamages, combat) and combats[combat] then
			doSendAnimatedText(getThingPos(cid), -value, combats[combat].cor)
		end
		return true
	end
	
	if isSummon(cid) and type == STATSCHANGE_HEALTHLOSS then -- Caso esteja healando, e leve dano o potion heal para de curar
		if getPlayerStorageValue(cid, 173) >= 1 then
			if combat ~= BURNEDDAMAGE and combat ~= POISONEDDAMAGE then
				setPlayerStorageValue(cid, 173, -1) 
				doSendAnimatedText(getThingPos(cid), "Lost Heal", 144)
			end
		end
	end
	
	if isPlayer(attacker) then
		
		local valor = value
		if valor > getCreatureHealth(cid) then
			valor = getCreatureHealth(cid)
		end
		
		if combat == COMBAT_PHYSICALDAMAGE then
			return false
		end
		
		if combat == PHYSICALDAMAGE then
			doSendMagicEffect(getThingPos(cid), 3)
			doSendAnimatedText(getThingPos(cid), valor, races[getMonsterInfo(getCreatureName(cid)).race].cor)
		end
		
		if combats[damageCombat] and not isInArray(fixdmgs, damageCombat) then
			doSendAnimatedText(getThingPos(cid), valor, combats[combat].cor)
		end
		
		if #getCreatureSummons(attacker) >= 1 and not isInArray({POISONEDDAMAGE, BURNEDDAMAGE}, combat) then
			doPlayerSendTextMessage(attacker, MESSAGE_STATUS_DEFAULT, "Your "..getCreatureName(getCreatureSummons(attacker)[1]).." dealt "..valor.." damage to "..getCreatureName(cid)..".")
		end
		
		return true
	end
	
	if isPlayer(cid) and #getCreatureSummons(cid) <= 0 and type == STATSCHANGE_HEALTHLOSS then
		if isSummon(attacker) or isPlayer(attacker) then
			return canAttackOther(cid, attacker)
		end
		
		local valor = 0
		if combat == COMBAT_PHYSICALDAMAGE then
			valor = math.random(getOffense(attacker), getOffense(attacker)+30)
		else
			valor = math.random(getSpecialAttack(attacker), getSpecialAttack(attacker)+30)
		end
		valor = valor * 0.32
		valor = valor * math.random(83, 117) / 100
		
		if valor >= getCreatureHealth(cid) then
			valor = getCreatureHealth(cid)
		end
		
		valor = math.floor(valor)
		
		
		if getPlayerStorageValue(cid, 98796) >= 1 then -- Safari
			setPlayerStorageValue(cid, 98796, -1) 
			setPlayerStorageValue(cid, 98797, -1) --alterado v1.8
			doTeleportThing(cid, SafariOut, false)
			doSendMagicEffect(getThingPos(cid), 21)
			doPlayerSendTextMessage(cid, 27, "You die in the saffari... Best luck in the next time!")
			return false --alterado v1.8
		end
		if not isPlayer(cid) then
			doCreatureAddHealth(cid, -valor, 3, 180)
			addEvent(sendPlayerDmgMsg, 5, cid, "You lost "..valor.." hitpoints due to an attack from "..getCreatureName(attacker)..".")
		end
		return false
	end
	
	if not isSummon(cid) and not isSummon(attacker) then 
		return false 
	end
	
	if getCreatureCondition(cid, CONDITION_INVISIBLE) then
		return false
	end
	
	if combat == COMBAT_PHYSICALDAMAGE then 
		attr = getDefense(cid) - getOffense(attacker)
		if attr < 0 then
			attr = attr * -1
			nval = mathpercent(valor, attr)
			valor = math.ceil(valor+nval)
		else
			nval = mathpercent(valor, attr)
			valor = valor-nval	
		end
	else
		attr = getSpecialDefense(cid) - getSpecialAttack(attacker)
		if attr < 0 then
			attr = attr * -1
			nval = mathpercent(valor, attr)
			valor = math.ceil(valor+nval)
		else
			nval = mathpercent(valor, attr)
			valor = valor-nval	
		end
	end
	
	if getPokemonGenderName(attacker) == "male" then -- Gender (Attack extra)
		valor = valor + (mathpercent(valor, 10)) -- 10% a mais de dano
	elseif getPokemonGenderName(attacker) == "genderless" then
		valor = valor + (mathpercent(valor, 5)) -- 5% a mais de dano
	end
	
	if getPlayerStorageValue(cid, 21099) >= 1 and combat ~= COMBAT_PHYSICALDAMAGE then
		local spell = getPlayerStorageValue(attacker, 21102)
		if not isInArray({"Team Claw", "Team Slice"}, spell) then
			doSendMagicEffect(getThingPosWithDebug(cid), 135)
			doSendAnimatedText(getThingPosWithDebug(cid), "REFLECT", COLOR_GRASS)
			damage = getPokemonDamageBySpell(attacker, spell)
			addEvent(doPokemonUseSpell, 100, cid, spell, damage.min, damage.max)
			if getCreatureName(cid) == "Wobbuffet" then
				doRemoveCondition(cid, CONDITION_OUTFIT) 
			end
			setPlayerStorageValue(cid, 21099, -1) 
			return false
		end
	end
	
	local attackername = doCorrectString(getCreatureName(attacker))
	local defensename = doCorrectString(getCreatureName(cid))
	local multiplier = 1
	
	if combat ~= COMBAT_PHYSICALDAMAGE then -- Vantagem, desvantagem, imunidade
		if combats[combat].type == poke_status[defensename].type1 or combats[combat].type == poke_status[defensename].type2 then
			multiplier = 1
		elseif isInArray(getPokemonDisadvantage(defensename), combats[combat].type) then
			multiplier = 2
			msg = "2x"
		elseif isInArray(getPokemonAdvantage(defensename), combats[combat].type) then
			multiplier = 0.5
			msg = "0.5x"
		elseif isInArray(getPokemonImunity(defensename), combats[combat].type) then
			valor = 0
			msg = "0x"
			multiplier = 0
		end
		valor = valor * multiplier
	end
	
	if isSummon(cid) and isSummon(attacker) then
		if getCreatureMaster(cid) == getCreatureMaster(attacker) then
			return false
		end
		if canAttackOther(cid, attacker) == false then
			return false
		end
	end
	
	if msg and multiplier ~= 1 then
		doSendAnimatedText(getCreaturePosition(cid), msg, 171)
	end
	
	if multiplier == 0 then
		return false
	end

	local master = getCreatureMaster(attacker)
	if isPlayer(master) then
		if isDittoBall(master) then
			valor = valor * 0.75
		end
	end
	
	if isSummon(attacker) then
		if multiplier ~= 0 then
			if combat == COMBAT_PHYSICALDAMAGE then
				doTargetCombatHealth(getCreatureMaster(attacker), cid, PHYSICALDAMAGE, -valor, -valor, 255)
				addEvent(doDoubleHit, 1000, attacker, cid, valor, races) 
			else
				doTargetCombatHealth(getCreatureMaster(attacker), cid, damageCombat, -valor, -valor, 255)
			end
		end
	else
		if multiplier ~= 0 then
			if combat ~= COMBAT_PHYSICALDAMAGE then
				doCreatureAddHealth(cid, -valor, 3, combats[damageCombat].cor) 
			else
				doCreatureAddHealth(cid, -valor, 3, races[getMonsterInfo(getCreatureName(cid)).race].cor)
				addEvent(function()
					doDoubleHit(attacker, cid, valor, races)
				end, 1000) 
			end
		end
		
		if isSummon(cid) then
			addEvent(doPlayerSendDamageText, 5, getCreatureMaster(cid), "Your "..getCreatureName(cid).." lost "..valor.." hitpoints due to an attack from "..getCreatureName(cid)..".")
		end 
	end
	
	--[[
	if passivesChances["PassiveName"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["PassiveName"][getCreatureName(cid)] then
		docastspell(cid, "Counter Helix")
	end
	]]
	
	return true
end