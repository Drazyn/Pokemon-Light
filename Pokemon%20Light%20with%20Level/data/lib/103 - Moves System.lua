poketypes = {
	["none"] = {
		van = {},
		des = {},
		imu = {},
	},	
	
	["normal"] = {
		van = {},
		des = {"rock", "steel"},
		imu = {"ghost"},
	},
	
	["fight"] = {
		van = {"normal", "rock", "steel", "ice"},
		des = {"flying", "poison", "bug", "psychic", "fairy"},
		imu = {"ghost"},
	},
	
	["flying"] = {
		van = {"fight", "bug", "grass", },
		des = {"rock", "eletric"},
		imu = {},
	},
	
	["fairy"] = {
		van = {"fight", "dragon", "dark"},
		des = {"poison", "steel", "fire"},
		imu = {},
	},
	
	["dark"] = {
		van = {"ghost", "psychic"},
		des = {"fight", "dark", "fairy"},
		imu = {},
	},
	
	["dragon"] = {
		van = {"dragon"},
		des = {"steel"},
		imu = {"fairy"},
	},
	
	["ice"] = {
		van = {"flying", "ground", "grass", "dragon"},
		des = {"steel", "fire", "water", "ice"},
		imu = {},
	},
	
	["psychic"] = {
		van = {"fight", "poison"},
		des = {"steel", "psychic"},
		imu = {"dark"},
	},
	
	["eletric"] = {
		van = {"flying", "water"},
		des = {"grass", "eletric"},
		imu = {"ground"},
	},
	
	["grass"] = {
		van = {"ground", "rock", "water"},
		des = {"flying", "poison", "bug", "steel", "fire", "grass", "dragon"},
		imu = {},
	},
	
	["water"] = {
		van = {"ground", "rock", "fire"},
		des = {"water", "grass"},
		imu = {},
	},
	
	["fire"] = {
		van = {"bug", "steel", "grass", "ice"},
		des = {"rock", "fire", "water", "dragon"},
		imu = {},
	},
	
	["steel"] = {
		van = {"rock", "ice", "fairy"},
		des = {"steel", "fire", "water", "eletric"},
		imu = {},
	},
	
	["ghost"] = {
		van = {"ghost", "psychic"},
		des = {"dark"},
		imu = {"normal"},
	},
	
	["bug"] = {
		van = {"grass", "psychic", "dark"},
		des = {"fight", "flying", "poison", "ghost", "steel", "fire", "fairy"},
		imu = {},
	},
	
	["rock"] = {
		van = {"flying", "bug", "fire", "ice"},
		des = {"fight", "ground", "steel", "water"},
		imu = {},
	},
	
	["ground"] = {
		van = {"poison", "rock", "steel", "fire", "eletric"},
		des = {"bug", "grass", "water"},
		imu = {"flying"},
	},
	
	["poison"] = {
		van = {"grass", "fairy"},
		des = {"poison", "ground", "rock"},
		imu = {"steel"},
	}
}


function getPokemonAdvantage(pokename)
	pokename = doCorrectPokemonName(pokename)
	local stats = {}
	if poke_status[pokename] then
		local type1 = poke_status[pokename].type1
		local type2 = poke_status[pokename].type2
		for i = 1, #poketypes[type1].van do
			table.insert(stats, i, poketypes[type1].van[i])
		end
		for i = 1, #poketypes[type2].van do
			table.insert(stats, i, poketypes[type2].van[i])
		end
	end
	return stats
end

function getPokemonDisadvantage(pokename)
	pokename = doCorrectPokemonName(pokename)
	local stats = {}
	if poke_status[pokename] then
		local type1 = poke_status[pokename].type1
		local type2 = poke_status[pokename].type2
		for i = 1, #poketypes[type1].des do
			table.insert(stats, i, poketypes[type1].des[i])
		end
		for i = 1, #poketypes[type2].des do
			table.insert(stats, i, poketypes[type2].des[i])
		end
	end
	return stats
end

function getPokemonImunity(pokename)
	pokename = doCorrectPokemonName(pokename)
	local stats = {}
	if poke_status[pokename] then
		local type1 = poke_status[pokename].type1
		local type2 = poke_status[pokename].type2
		for i = 1, #poketypes[type1].imu do
			table.insert(stats, i, poketypes[type1].imu[i])
		end
		for i = 1, #poketypes[type2].imu do
			table.insert(stats, i, poketypes[type2].imu[i])
		end
	end
	return stats
end

function getPokemonDamageBySpell(cid, magia)
	name = getCreatureName(cid)
	if PokeMoves[name] then
		if isSummon(cid) then
			plevel = getPlayerLevel(getCreatureMaster(cid))
			pokelevel = getPokemonLevel(cid)
		elseif isMonster(cid) and not isSummon(cid) then
			plevel = getPokemonLevel(cid)
			pokelevel = getPokemonLevel(cid)
		elseif isPlayer(cid) then
			plevel = getPlayerLevel(cid)
			pokelevel = getPokemonLevel(getCreatureSummons(cid)[1])
		end
		for i=1, #PokeMoves[name] do
			local table = PokeMoves[name][i]
			if table.spell == magia then
				n1 = math.ceil((table.min + plevel / 4))
				n2 = math.ceil((table.max + plevel / 4))
				minn = math.ceil((n1 + (pokelevel / 2) + plevel/5))
				maxx = math.ceil((n2 + (pokelevel / 2) + plevel/5))
				return {min = minn, max = maxx}				
			end
		end
	end
	return {min = 0, max = 0}
end

function getPokemonDamageByTable(cid, table)
	name = getCreatureName(cid)
	if isSummon(cid) then
		plevel = getPlayerLevel(getCreatureMaster(cid))
		pokelevel = getPokemonLevel(cid)
	elseif isMonster(cid) and not isSummon(cid) then
		plevel = getPokemonLevel(cid)
		pokelevel = getPokemonLevel(cid)
	elseif isPlayer(cid) then
		plevel = getPlayerLevel(cid)
		pokelevel = getPokemonLevel(getCreatureSummons(cid)[1])
	end
	n1 = (table.min + plevel / 5)
	n2 = (table.max + plevel / 5)
	minn = (n1 + ((pokelevel) / 3) + plevel/2)
	maxx = (n2 + ((pokelevel) / 3) + plevel/2)
	return {min = minn, max = maxx}				
end

function setPokemonMove(uid, slot, newmove) -- Muda o move do pokémon
	if tmoves[newmove] then
		local move = "move".. tostring(slot)
		doItemSetAttribute(uid, move, tostring(newmove))
		return true
	end
	return false
end

function getPokemonMoves(cid, ball)
	local str = {}
	if isPlayer(cid) then
		if not ball then
			ball = getPlayerSlotItem(cid, 8)
		end 
		if isPokeball(ball.itemid) then
			local pokename = getItemAttribute(ball.uid, "poke")
			if PokeMoves[pokename] then
				for i = 1, 13 do
					local word = "move"..i
					SpellName = "nothing"
					if getItemAttribute(ball.uid, word) then
						SpellName = getItemAttribute(ball.uid, word)
					elseif PokeMoves[pokename][i] then
						SpellName = PokeMoves[pokename][i]
					end
					if SpellName ~= "nothing" then
						table.insert(str, i, SpellName.spell or SpellName)					
					end
				end	
			end
		end
	end
	return str
end

local function getSubName(cid, target)
	if not isCreature(cid) then 
		return "" 
	end
	if hasWithReflect(cid) and isCreature(target) then
		return getCreatureName(target)
	else --alterado v1.6.1
		return getCreatureName(cid)
	end
end

function doPokemonUseSpell(cid, spell, min, max)
	local SPELL_OUT = true
	local master = getCreatureMaster(cid)
	local target = 0
	if isCreature(getMasterTarget(master)) then
		target = getMasterTarget(master)
	end
	
	
	--	local pos = getThingPosWithDebug(target) -- Pos configurada no mesmo sqm do target (x+1 y+1 z) (SQMpos):
	--	{x = pos.x + 1, y = pos.y + 1, z = pos.z}, -- Efeito sai EXATAMENTE no SQM do target ao invéz de sair um pouco em cima e na esquerda(/\<) (SQMpos)
	
	---------------GHOST DAMAGE-----------------------
	ghostDmg = GHOSTDAMAGE
	psyDmg = PSYCHICDAMAGE
	
	if getPlayerStorageValue(cid, 999457) >= 1 then --alterado v1.6
		psyDmg = MIRACLEDAMAGE 
		ghostDmg = DARK_EYEDAMAGE
		addEvent(setPlayerStorageValue, 50, cid, 999457, -1)
	end
	--------------------REFLECT----------------------
	setPlayerStorageValue(cid, 21100, -1) --alterado v1.6
	if not isInArray({"Psybeam", "Sand Attack", "Flamethrower", "Heal Bell"}, spell) then --alterado v1.8
		setPlayerStorageValue(cid, 21101, -1)
	end
	setPlayerStorageValue(cid, 21102, spell)
	---------------------------------------------------
	if spell == "Reflect" or spell == "Mimic" or spell == "Magic Coat" then
		
		if spell == "Magic Coat" then
			eff = 11
		else
			eff = 135
		end
		
		doSendMagicEffect(getThingPosWithDebug(cid), eff)
		setPlayerStorageValue(cid, 21099, 1) 	
	--elseif spell == "Mega Evolve" then -- Mega Evolução
		
	elseif spell == "Quick Attack" then
		doSendMagicEffect(getThingPosWithDebug(cid), 31) --31
		local x = getClosestFreeTile(cid, getThingPosWithDebug(target))
		doTeleportThing(cid, x, false)
		doFaceCreature(cid, getThingPosWithDebug(cid))
		doCombatAreaHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 3) -- 3
	elseif spell == "Ember" then
		local SQMpos = getThingPosWithDebug(target)
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
		doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max) --alterado v2.7 -- eff=300 retira e coloca como sendMagicEffect p/ usar SQMpos:
		doSendMagicEffect({x = SQMpos.x + 1, y = SQMpos.y + 1, z = SQMpos.z}, 300) -- "SQMpos" demonstração.
	elseif spell == "Headbutt" then 
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 3)
		doSendMagicEffect(getThingPosWithDebug(target), 3)
		
	elseif spell == "Fire Fang" then
		local pos = getThingPosWithDebug(target) -- "SQMpos" -> -- {x = pos.x + 1, y = pos.y + 1, z = pos.z}
		doSendMagicEffect(getThingPosWithDebug(target), 146) 	
		doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max) --5	
		addEvent(doSendMagicEffect, 140, {x = pos.x + 1, y = pos.y + 1, z = pos.z}, 301)	-- Add efeito extra do PxG. ("SQMpos")
	elseif spell == "Razor Leaf" then 
		local eff = 8
		local function throw(cid, target)
			if not isCreature(cid) or not isCreature(target) then return false end
			doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), eff)
			doDanoInTargetWithDelay(cid, target, GRASSDAMAGE, min, max, 245) --alterado v1.7
		end
		addEvent(throw, 0, cid, target)
		addEvent(throw, 100, cid, target) --alterado v1.7	
	elseif spell == "Magical Leaf" then 
		local eff = 21
		local function throw(cid, target)
			if not isCreature(cid) or not isCreature(target) then return false end
			doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), eff)
			doDanoInTargetWithDelay(cid, target, GRASSDAMAGE, min, max, 245) --alterado v1.7
		end
		addEvent(throw, 0, cid, target)
		addEvent(throw, 100, cid, target) --alterado v1.7	
	elseif spell == "Body Slam" then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 118)
	elseif spell == "Scratch" then
		doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 142) 
	elseif spell == "Iron Head" then
		doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 77)	
	elseif spell == "Fireball" then
		local pos = getThingPosWithDebug(target)
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
		addEvent(doDanoWithProtect, 200, cid, FIREDAMAGE, getThingPosWithDebug(target), waba, min, max, 6)	
		--	doSendMagicEffect(getThingPosWithDebug(target), 300)
		--doSendMagicEffect({x = pos.x + 1, y = pos.y + 1, z = pos.z}, 300)
		
	elseif spell == "Leaf Storm" then -- or tonumber(spell) == 73 then
		
		addEvent(doDanoWithProtect, 150, cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)
		
		local pos = getThingPosWithDebug(cid)
		
		local function doSendLeafStorm(cid, pos) --alterado!!
			if not isCreature(cid) then return true end
			doSendDistanceShoot(getThingPosWithDebug(cid), pos, 8)
		end
		
		for a = 1, 100 do
			local lugar = {x = pos.x + math.random(-6, 6), y = pos.y + math.random(-5, 5), z = pos.z}
			addEvent(doSendLeafStorm, a * 2, cid, lugar)
		end
		
	elseif spell == "Fire Blast" then
		
		local p = getThingPosWithDebug(cid)
		local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		
		function sendAtk(cid, area, eff)
			if isCreature(cid) then
				if not isSightClear(p, area, false) then return true end 
				doAreaCombatHealth(cid, FIREDAMAGE, area, 0, 0, 0, eff)
				doAreaCombatHealth(cid, FIREDAMAGE, area, whirl3, -min, -max, 35)
			end
		end
		
		for a = 0, 4 do
			
			local t = {
				[0] = {60, {x=p.x, y=p.y-(a+1), z=p.z}}, --alterado v1.4
				[1] = {61, {x=p.x+(a+1), y=p.y, z=p.z}},
				[2] = {62, {x=p.x, y=p.y+(a+1), z=p.z}},
				[3] = {63, {x=p.x-(a+1), y=p.y, z=p.z}}
			} 
			addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
		end	
	elseif spell == "Dragon Claw" then
		
		doDanoWithProtect(cid, DRAGONDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 141)	
		
	elseif spell == "Magma Storm" then
		
		local eff = {6, 35, 35, 6}
		local area = {flames1, flames2, flames3, flames4}
		
		addEvent(doMoveInArea2, 2*450, cid, 2, flames0, FIREDAMAGE, min, max, spell)
		for i = 0, 3 do
			addEvent(doMoveInArea2, i*450, cid, eff[i+1], area[i+1], FIREDAMAGE, min, max, spell)
		end	
	elseif spell == "Bubbles" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
		doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 68) --alterado v1.7	
	elseif spell == "Clamp" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
		doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 53) --alterado v1.7	
	elseif spell == "Waterball" then
		local pos = getThingPosWithDebug(target)
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
		doDanoWithProtectWithDelay(cid, target, WATERDAMAGE, min, max, 68, waba)
		doSendMagicEffect(pos, 53) 
	elseif spell == "Aqua Tail" then
		
		local function rebackSpd(cid, sss)
			if not isCreature(cid) then return true end
			doChangeSpeed(cid, sss)
			setPlayerStorageValue(cid, 446, -1)
		end
		
		local x = getCreatureSpeed(cid)
		doFaceOpposite(cid)
		doChangeSpeed(cid, -x)
		addEvent(rebackSpd, 400, cid, x)
		setPlayerStorageValue(cid, 446, 1)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 68)
		
	elseif spell == "Hydro Cannon" then
		
		local p = getThingPosWithDebug(cid)
		local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		
		function sendAtk(cid, area, eff)
			if isCreature(cid) then
				if not isSightClear(p, area, false) then return true end
				doAreaCombatHealth(cid, WATERDAMAGE, area, 0, 0, 0, eff)
				doAreaCombatHealth(cid, WATERDAMAGE, area, whirl3, -min, -max, 68)
			end
		end
		
		for a = 0, 4 do
			
			local t = { --alterado v1.4
				[0] = {64, {x=p.x, y=p.y-(a+1), z=p.z}},
				[1] = {65, {x=p.x+(a+1), y=p.y, z=p.z}},
				[2] = {66, {x=p.x, y=p.y+(a+1), z=p.z}},
				[3] = {67, {x=p.x-(a+1), y=p.y, z=p.z}}
			} 
			
			addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
		end
	elseif spell == "Magma Storm" then
		
		local eff = {6, 35, 35, 6}
		local area = {flames1, flames2, flames3, flames4}
		
		addEvent(doMoveInArea2, 2*450, cid, 2, flames0, FIREDAMAGE, min, max, spell)
		for i = 0, 3 do
			addEvent(doMoveInArea2, i*450, cid, eff[i+1], area[i+1], FIREDAMAGE, min, max, spell)
		end
	elseif spell == "Flamethrower" then
		
		local flamepos = getThingPosWithDebug(cid)
		local effect = 255
		local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		
		if a == 0 then
			flamepos.x = flamepos.x+1
			flamepos.y = flamepos.y-1
			effect = 106
		elseif a == 1 then
			flamepos.x = flamepos.x+3
			flamepos.y = flamepos.y+1
			effect = 109
		elseif a == 2 then
			flamepos.x = flamepos.x+1
			flamepos.y = flamepos.y+3
			effect = 107
		elseif a == 3 then
			flamepos.x = flamepos.x-1
			flamepos.y = flamepos.y+1
			effect = 108
		end
		
		doMoveInArea2(cid, 0, flamek, FIREDAMAGE, min, max, spell)
		doSendMagicEffect(flamepos, effect) 
		
	elseif spell == "Raging Blast" then
		
		--cid, effDist, effDano, areaEff, areaDano, element, min, max
		doMoveInAreaMulti(cid, 3, 6, bullet, bulletDano, FIREDAMAGE, min, max) 
		
	elseif spell == "Wing Attack" or spell == "Steel Wing" then
		
		local effectpos = getThingPosWithDebug(cid)
		local effect = 255
		local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		
		if a == 0 then
			effect = spell == "Steel Wing" and 251 or 128
			effectpos.x = effectpos.x + 1
			effectpos.y = effectpos.y - 1 --alterado v1.4
		elseif a == 1 then
			effectpos.x = effectpos.x + 2
			effectpos.y = effectpos.y + 1
			effect = spell == "Steel Wing" and 253 or 129
		elseif a == 2 then
			effectpos.x = effectpos.x + 1
			effectpos.y = effectpos.y + 2
			effect = spell == "Steel Wing" and 252 or 131
		elseif a == 3 then
			effectpos.x = effectpos.x - 1
			effectpos.y = effectpos.y + 1
			effect = spell == "Steel Wing" and 254 or 130
		end
		
		doSendMagicEffect(effectpos, effect)
		doMoveInArea2(cid, 0, wingatk, FLYINGDAMAGE, min, max, spell)
		
	elseif spell == "Water Gun" then
		
		local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		local p = getThingPosWithDebug(cid)
		local t = {
			[0] = {69, {x=p.x, y=p.y-1, z=p.z}},
			[1] = {70, {x=p.x+6, y=p.y, z=p.z}}, --alterado v1.8
			[2] = {71, {x=p.x, y=p.y+6, z=p.z}},
			[3] = {72, {x=p.x-1, y=p.y, z=p.z}},
		}
		
		doMoveInArea2(cid, 0, triplo6, WATERDAMAGE, min, max, spell)
		doSendMagicEffect(t[a][2], t[a][1])	
		
	elseif spell == "Bubble Blast" then
		
		--cid, effDist, effDano, areaEff, areaDano, element, min, max
		doMoveInAreaMulti(cid, 2, 68, bullet, bulletDano, WATERDAMAGE, min, max)	
		
	elseif spell == "Skull Bash" then
		local ret = {}
		ret.id = 0
		ret.cd = 9 --alterado v1.6
		ret.eff = 118
		ret.check = 0
		ret.first = true
		ret.cond = "Paralyze"
		
		doMoveInArea2(cid, 118, reto5, NORMALDAMAGE, min, max, spell, ret) 	
		
		
		
	elseif spell == "Bug Bite" then
		
		doSendMagicEffect(getThingPosWithDebug(target), 244)
		doDanoInTargetWithDelay(cid, target, BUGDAMAGE, min, max, 8) --alterado v1.7
		
	elseif spell == "Whirlwind" then
		
		area = {SL1, SL2, SL3, SL4}
		
		for i = 0, 3 do
			addEvent(doMoveInArea2, i*300, cid, 42, area[i+1], FLYINGDAMAGE, min, max, spell)
		end
		
	elseif spell == "Razor Wind" then
		
		area = {SL1, SL2, SL3, SL4}
		
		for i = 0, 3 do
			addEvent(doMoveInArea2, i*300, cid, 131, area[i+1], NORMALDAMAGE, min, max, spell)
		end
		
	elseif spell == "Psybeam" then
		
		local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		local t = {
			[0] = 58, --alterado v1.6
			[1] = 56,
			[2] = 58,
			[3] = 56,
		}
		
		doMoveInArea2(cid, t[a], reto4, psyDmg, min, max, spell) --alterado v1.4	
		
	elseif spell == "Horn Attack" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
		doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3) --alterado v1.7
		
	elseif spell == "Poison Sting" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
		doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 8) --alterado v1.7
		
	elseif spell == "Pin Missile" then
		
		doMoveInAreaMulti(cid, 13, 7, bullet, bulletDano, BUGDAMAGE, min, max)	
		
	elseif spell == "Gust" then
		
		doMoveInArea2(cid, 42, reto5, FLYINGDAMAGE, min, max, spell) 
		
	elseif spell == "Drill Peck" then
		
		doDanoWithProtect(cid, FLYINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 148)
		
	elseif spell == "Bite" or tonumber(spell) == 5 then
		
		doDanoWithProtect(cid, DARKDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 146)
		
	elseif spell == "Super Fang" then
		
		doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 244)
		
	elseif spell == "Poison Fang" then
		
		doSendMagicEffect(getThingPosWithDebug(target), 244)
		doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 114) --alterado v1.7
		
	elseif spell == "Sting Gun" then
		
		local function doGun(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end --alterado v1.7
			doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 13)
			doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 8) --alterado v1.7
		end
		
		setPlayerStorageValue(cid, 3644587, 1)
		addEvent(setPlayerStorageValue, 200, cid, 3644587, 1)
		for i = 0, 2 do
			addEvent(doGun, i*100, cid, target)
		end 
		
	elseif spell == "Acid" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 14)
		doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 20) 
		
	elseif spell == "Iron Tail" then
		
		local function rebackSpd(cid, sss)
			if not isCreature(cid) then return true end
			doChangeSpeed(cid, sss)
			setPlayerStorageValue(cid, 446, -1)
		end
		
		local x = getCreatureSpeed(cid)
		doFaceOpposite(cid)
		doChangeSpeed(cid, -x)
		addEvent(rebackSpd, 400, cid, x)
		setPlayerStorageValue(cid, 446, 1)
		doDanoWithProtect(cid, STEELDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 160)
		
	elseif spell == "Thunder Shock" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 40)
		doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48) --alterado v1.7
		
	elseif spell == "Thunder Bolt" then
		local pos = getThingPosWithDebug(target)
		--alterado v1.7
		local function doThunderFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
			local pos = getThingPosWithDebug(target)
			local ry = math.abs(frompos.y - pos.y)
			doSendDistanceShoot(frompos, getThingPosWithDebug(target), 41)
			addEvent(doDanoInTarget, ry * 11, cid, target, ELECTRICDAMAGE, min, max) --48
		addEvent(doSendMagicEffect, ry * 11, {x = pos.x + 1, y = pos.y, z = pos.z}, 303) -- 48	-- Posição (referencia p/ tempo do dano ry * 11, e posição)
		
		end
		
		--addEvent(doSendMagicEffect, 53, {x = pos.x + 1, y = pos.y, z = pos.z}, 303) -- 48 -- tempo=53(addEvent)
		
		local function doThunderUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
			local pos = getThingPosWithDebug(target)
			local mps = getThingPosWithDebug(cid)
			local xrg = math.floor((pos.x - mps.x) / 2)
			local topos = mps
			topos.x = topos.x + xrg
			local rd = 7
			topos.y = topos.y - rd
			doSendDistanceShoot(getThingPosWithDebug(cid), topos, 41)
			addEvent(doThunderFall, rd * 49, cid, topos, target)
		end		
		
		setPlayerStorageValue(cid, 3644587, 1)
		addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
		for thnds = 1, 2 do
			addEvent(doThunderUp, thnds * 155, cid, target)
		end
		
		
	elseif spell == "Thunder Wave" then --Não causa dano(?) Efeito do atk pela metade (outra metade ta no ret)	
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.check = 0
		ret.eff = 48
		ret.spell = spell
		ret.cond = "Stun"
		
		doMoveInArea2(cid, 48, db1, ELECTRICDAMAGE, min, max, spell, ret) --alterado v1.8
		
	elseif spell == "Thunder" then --NÃO CAUSA DANO Efeito do atk pela metade (outra metade ta no ret)	
		local pos = getThingPosWithDebug(cid)
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.check = 0
		ret.eff = 48
		ret.spell = spell
		ret.cond = "Stun"
		
		addEvent(doSendMagicEffect, 40, {x = pos.x + 1, y = pos.y, z = pos.z}, 304)
		doMoveInArea2(cid, 48, thunderr, ELECTRICDAMAGE, min, max, spell, ret)
		
		
	elseif spell == "Web Shot" then -- taca o effect somente, pois só pariliza e não ta funfando ainda os ret's
		
		local ret = {}
		ret.id = target
		ret.cd = 9
		ret.eff = 26
		ret.check = 0
		ret.spell = spell
		ret.cond = "Paralyze"
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
		addEvent(doMoveDano2, 100, cid, target, BUGDAMAGE, -min, -max, ret, spell)
		
	elseif spell == "Mega Kick" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
		doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 113) --alterado v1.7
		
	elseif spell == "Thunder Punch" then -- Colocar effect do soco
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
		doSendMagicEffect(getThingPosWithDebug(target), 112)
		doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48) --alterado v1.7
		
	elseif spell == "Electric Storm" then -- dano em 1 parte
		
		local master = isSummon(cid) and getCreatureMaster(cid) or cid
		
		local function doFall(cid)
			for rocks = 1, 42 do
				addEvent(fall, rocks*35, cid, master, ELECTRICDAMAGE, 41, 303) -- 41, 48
			end
		end
		
		for up = 1, 10 do
			addEvent(upEffect, up*75, cid, 41)
			
		end
		addEvent(doFall, 450, cid)
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.check = 0
		ret.eff = 48 --48
		ret.spell = spell
		ret.cond = "Stun"
		
		
		addEvent(doMoveInArea2, 1400, cid, 0, BigArea2, ELECTRICDAMAGE, min, max, spell, ret)
		
		-- ||\ Spells que não funcionam: /||
	elseif spell == "Fear" or spell == "Roar" then 
		
		local ret = {}
		ret.id = 0
		ret.cd = 5
		ret.check = 0
		ret.skill = spell
		ret.cond = "Fear"
		
		doMoveInArea2(cid, 0, confusion, DARKDAMAGE, 0, 0, spell, ret)
		
	elseif spell == "Tornado" then
		
		local pos = getThingPosWithDebug(cid)
		
		local function doSendTornado(cid, pos)
			if not isCreature(cid) then return true end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			doSendDistanceShoot(getThingPosWithDebug(cid), pos, 22)
			doSendMagicEffect(pos, 42)
		end
		
		for b = 1, 3 do
			for a = 1, 20 do
				local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
				addEvent(doSendTornado, a * 75, cid, lugar)
			end
		end
		doDanoWithProtect(cid, FLYINGDAMAGE, pos, waterarea, -min, -max, 0)
		
		
		-- (rever spell abaixo) 
	elseif spell == "Strafe" or spell == "Agility" then 
		
		local ret = {}
		ret.id = cid
		ret.cd = 15
		ret.eff = 14
		ret.check = 0
		ret.buff = spell
		ret.first = true
		
		doCondition2(ret)
		
	elseif spell == "Sand Attack" then
		
		local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		local t = {
			[0] = 120,
			[1] = 121,
			[2] = 122,
			[3] = 119,
		}
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.eff = 34
		ret.check = 0
		ret.spell = spell
		ret.cond = "Miss"
		
		doCreatureSetLookDir(cid, a) --sera? '-'
		stopNow(cid, 1000) 
		doMoveInArea2(cid, t[a], reto5, GROUNDDAMAGE, 0, 0, spell, ret) 
		
	elseif spell == "Confusion" or spell == "Night Shade" then
		
		local pos = getThingPosWithDebug(cid)
		
		local rounds = math.random(4, 7) --rever area...
		rounds = rounds + math.floor(getPokemonLevel(cid) / 35)
		
		if spell == "Confusion" then
			dano = psyDmg --alterado v1.4
		else
			dano = ghostDmg
		end
		
		local ret = {}
		ret.id = 0
		ret.check = 0
		ret.cd = rounds
		ret.cond = "Confusion"
		
		
		if spell == "Confusion" then
		doMoveInArea2(cid, 156, selfArea1, dano, min, max, spell, ret)
		else
		addEvent(doSendMagicEffect, 1, {x = pos.x + 1, y = pos.y + 1, z = pos.z}, 312)
		 addEvent(doMoveInArea2, 110, cid, 136, selfArea1, dano, min, max, spell, ret)
		end
		
		
	elseif spell == "Super Sonic" then
		
		local rounds = math.random(4, 7)
		rounds = rounds + math.floor(getPokemonLevel(cid) / 35)
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 32)
		local ret = {}
		ret.id = target
		ret.cd = rounds
		ret.check = getPlayerStorageValue(target, conds["Confusion"])
		ret.cond = "Confusion"
		
		addEvent(doMoveDano2, 100, cid, target, NORMALDAMAGE, 0, 0, ret, spell)
		
		
		--(rever spell abaixo) 
	elseif spell == "Giga Impact" then -- não funfa e da erro na distro doMoveDano2
		
		local tempo = 3 --Tempo, em segundos.
		local a = {}
		local ret1 = {}
		ret1.id = 0
		ret1.cd = 5
		ret1.eff = 0
		ret1.check = 0
		ret1.first = true
		ret1.cond = "Slow"
		local ret2 = {}
		ret2.id = 0
		ret2.cd = 5 
		ret2.eff = 0
		ret2.check = 0
		ret2.first = true
		ret2.cond = "Miss"
		a.speed = getCreatureSpeed(cid)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, a.speed*2)
		addEvent(function()
			if not isCreature(cid) then return true end
			doRegainSpeed(cid)
			doMoveInArea2(cid, 118, confusion, NORMALDAMAGE, min, max, spell, ret1)
			doMoveInArea2(cid, 118, confusion, NORMALDAMAGE, 0, 0, spell, ret2)
		end, tempo*1000)
		
	elseif spell == "String Shot" then
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
		
		local ret = {}
		ret.id = target
		ret.cd = 6
		ret.eff = 137
		ret.check = getPlayerStorageValue(target, conds["Stun"])
		ret.spell = spell
		ret.cond = "Stun"
		
		addEvent(doMoveDano2, 100, cid, target, BUGDAMAGE, 0, 0, ret, spell)
		
		
		
	elseif spell == "Hydropump" then -- add jump no user da spell
		
		local pos = getThingPosWithDebug(cid)
		
		local function doSendBubble(cid, pos)
			if not isCreature(cid) then return true end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			
			doSendDistanceShoot(getThingPosWithDebug(cid), pos, 2)
			doSendMagicEffect(pos, 53)
		end
		--alterado!!
		for a = 1, 20 do
			local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
			addEvent(doSendBubble, a * 25, cid, lugar)
		end
		addEvent(doDanoWithProtect, 150, cid, WATERDAMAGE, pos, waterarea, -min, -max, 0)	
		
		
		
		--(rever spell(s) abaixo) Aparentemente funcional, testar dps com 2 chars ou colocar spells nos pokes selvagens e testar
	elseif spell == "Harden" or spell == "Calm Mind" or spell == "Defense Curl" or spell == "Charm" then	
		--alterado v1.4
		if spell == "Calm Mind" then
			eff = 133
		elseif spell == "Charm" then
			eff = 147 --efeito n eh esse.. e n sei se eh soh bonus de def, ou sp.def tb.. ;x
		else 
			eff = 144
		end
		
		local ret = {}
		ret.id = cid
		ret.cd = 8
		ret.eff = eff
		ret.check = 0
		ret.buff = spell
		ret.first = true
		
		doCondition2(ret) 
		
		
		
		--(rever spell(s) abaixo)	Não funfa, da erro.
	elseif spell == "Leech Seed" then
		
		local ret = {}
		ret.id = target
		ret.attacker = cid
		ret.cd = 5
		ret.check = getPlayerStorageValue(target, conds["Leech"])
		ret.damage = isSummon(cid) and getPlayerLevel(getCreatureMaster(cid)) or getPokemonLevel(cid)
		ret.cond = "Leech"
		
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 1)
		addEvent(doMoveDano2, 1000, cid, target, GRASSDAMAGE, 0, 0, ret, spell) 
		
		--(rever spell(s) abaixo)	O effect fica no lugar fixo mesmo se o poke andar, não notei diferença de def extra e não sei o q faz
	elseif spell == "Protection" then
		
		local pos = getPosfromArea(cid, heal)
		local n = 0
		
		while n < #pos do
			n = n+1
			thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
			local pid = getThingFromPosWithProtect(thing)
			local pospid = getThingPosWithDebug(pid)
			local poscid = getThingPosWithDebug(cid)
			
			doSendMagicEffect(pos[n], 12)
			for i = 0, 9 do
				if isCreature(pid) then
					if isSummon(cid) and (isSummon(pid) or isPlayer(pid)) then
						if canAttackOther(cid, pid) == false then
							doCreatureSetNoMove(pid, true)
							doCreatureSetNoMove(cid, true)
							setPlayerStorageValue(pid, 9658783, 1)
							setPlayerStorageValue(cid, 9658783, 1)
							addEvent(doSendMagicEffect, i*800, pospid, 117)
							addEvent(doSendMagicEffect, i*800, poscid, 117)
							addEvent(setPlayerStorageValue, 8000, pid, 9658783, -1)
							addEvent(setPlayerStorageValue, 8000, cid, 9658783, -1)
							addEvent(doCreatureSetNoMove, 8000, pid, false)
							addEvent(doCreatureSetNoMove, 8000, cid, false)
						end
					elseif ehMonstro(cid) and ehMonstro(pid) then
						doCreatureSetNoMove(pid, true)
						doCreatureSetNoMove(cid, true)
						setPlayerStorageValue(pid, 9658783, 1)
						setPlayerStorageValue(cid, 9658783, 1)
						addEvent(doSendMagicEffect, i*800, pospid, 117)
						addEvent(doSendMagicEffect, i*800, poscid, 117)
						addEvent(setPlayerStorageValue, 8000, pid, 9658783, -1)
						addEvent(setPlayerStorageValue, 8000, cid, 9658783, -1)
						addEvent(doCreatureSetNoMove, 8000, pid, false)
						addEvent(doCreatureSetNoMove, 8000, cid, false)
					end
				end
			end
		end
		
		
	elseif spell == "Stun Spore" then
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.eff = 0
		ret.check = 0
		ret.spell = spell
		ret.cond = "Stun"
		
		doMoveInArea2(cid, 85, confusion, GRASSDAMAGE, 0, 0, spell, ret)
		-- (rever) Pokemon dorme, não se mexe, porém se estiver no range ele ataca mesmo dormindo.
	elseif spell == "Sleep Powder" then
		
		local ret = {}
		ret.id = 0
		ret.cd = math.random(6, 9)
		ret.check = 0
		ret.first = true --alterado v1.6
		ret.cond = "Sleep"
		
		doMoveInArea2(cid, 27, confusion, NORMALDAMAGE, 0, 0, spell, ret)
		
		
	elseif spell == "Poison Powder" then 
		
		local ret = {}
		ret.id = 0
		ret.cd = math.random(6, 15) --alterado v1.6
		ret.check = 0
		local lvl = isSummon(cid) and getPlayerLevel(getCreatureMaster(cid)) or getPokemonLevel(cid)
		ret.damage = math.floor((getPokemonLevel(cid)+lvl * 3)/2)
		ret.cond = "Poison" 
		
		doMoveInArea2(cid, 84, confusion, NORMALDAMAGE, 0, 0, spell, ret)
		
		
	elseif spell == "Rage" then
		
		local ret = {}
		ret.id = cid
		ret.cd = 15
		ret.eff = 13
		ret.check = 0
		ret.buff = spell
		ret.first = true
		
		doCondition2(ret)
	
	elseif spell == "Mimic Wall" then

	local p = getThingPosWithDebug(cid)
	local dirr = getCreatureLookDir(cid)

	if dirr == 0 or dirr == 2 then
		item = 15525
	else
		item = 15524
	end

	local wall = {
		[0] = {{x = p.x, y = p.y-1, z = p.z}, {x = p.x+1, y = p.y-1, z = p.z}, {x = p.x-1, y = p.y-1, z = p.z}},
		[2] = {{x = p.x, y = p.y+1, z = p.z}, {x = p.x+1, y = p.y+1, z = p.z}, {x = p.x-1, y = p.y+1, z = p.z}},
		[1] = {{x = p.x+1, y = p.y, z = p.z}, {x = p.x+1, y = p.y+1, z = p.z}, {x = p.x+1, y = p.y-1, z = p.z}},
		[3] = {{x = p.x-1, y = p.y, z = p.z}, {x = p.x-1, y = p.y+1, z = p.z}, {x = p.x-1, y = p.y-1, z = p.z}},
	} 


	for i = 1, 3 do
		if wall[dirr] then
			local t = wall[dirr]
			if hasTile(t[i]) and isWalkable(t[i], true, true, false) then
				local itemuid = doCreateItem(item, 1, t[i])
				local pos = getThingPosition(itemuid)
				local cPos = getThingPos(cid)
				doItemSetAttribute(getTileThingWithProtect({x=t[i].x,y=t[i].y,z=t[i].z,stackpos=0}).uid, "aid", 88072)
				doItemSetAttribute(getTileThingWithProtect(cPos).uid, "aid", 88072)
				addEvent(function()
					doItemEraseAttribute(getTileThingWithProtect({x=t[i].x,y=t[i].y,z=t[i].z,stackpos=0}).uid, "aid")
					doItemEraseAttribute(getTileThingWithProtect(cPos).uid, "aid")
					doRemoveThing(getThingFromPos(pos).uid)
				end, MimicWallTime*1000)
			end
		end
	end
		
	elseif spell == "Solar Beam" then
		
		local function useSolarBeam(cid)
			if not isCreature(cid) then
				return true
			end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
				return true
			end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
				return true
			end
			local effect1 = 255
			local effect2 = 255
			local effect3 = 255
			local effect4 = 255
			local effect5 = 255
			local area = {}
			local pos1 = getThingPosWithDebug(cid)
			local pos2 = getThingPosWithDebug(cid)
			local pos3 = getThingPosWithDebug(cid)
			local pos4 = getThingPosWithDebug(cid)
			local pos5 = getThingPosWithDebug(cid)
			if getCreatureLookDir(cid) == 1 then
				effect1 = 4
				effect2 = 10
				effect3 = 10
				effect4 = 10
				effect5 = 0
				pos1.x = pos1.x + 2
				pos1.y = pos1.y + 1
				pos2.x = pos2.x + 3
				pos2.y = pos2.y + 1
				pos3.x = pos3.x + 4
				pos3.y = pos3.y + 1
				pos4.x = pos4.x + 5
				pos4.y = pos4.y + 1
				pos5.x = pos5.x + 6
				pos5.y = pos5.y + 1
				area = solare
			elseif getCreatureLookDir(cid) == 0 then
				effect1 = 36
				effect2 = 37
				effect3 = 37
				effect4 = 38
				pos1.x = pos1.x + 1
				pos1.y = pos1.y - 1
				pos2.x = pos2.x + 1
				pos2.y = pos2.y - 3
				pos3.x = pos3.x + 1
				pos3.y = pos3.y - 4
				pos4.x = pos4.x + 1
				pos4.y = pos4.y - 5
				area = solarn
			elseif getCreatureLookDir(cid) == 2 then
				effect1 = 46
				effect2 = 50
				effect3 = 50
				effect4 = 59
				pos1.x = pos1.x + 1
				pos1.y = pos1.y + 2
				pos2.x = pos2.x + 1
				pos2.y = pos2.y + 3
				pos3.x = pos3.x + 1
				pos3.y = pos3.y + 4
				pos4.x = pos4.x + 1
				pos4.y = pos4.y + 5
				area = solars
			elseif getCreatureLookDir(cid) == 3 then
				effect1 = 115
				effect2 = 162
				effect3 = 162
				effect4 = 162
				effect5 = 163
				pos1.x = pos1.x - 1
				pos1.y = pos1.y + 1
				pos2.x = pos2.x - 3
				pos2.y = pos2.y + 1
				pos3.x = pos3.x - 4
				pos3.y = pos3.y + 1
				pos4.x = pos4.x - 5
				pos4.y = pos4.y + 1
				pos5.x = pos5.x - 6
				pos5.y = pos5.y + 1
				area = solarw
			end
			
			if effect1 ~= 255 then
				doSendMagicEffect(pos1, effect1)
			end
			if effect2 ~= 255 then
				doSendMagicEffect(pos2, effect2)
			end
			if effect3 ~= 255 then
				doSendMagicEffect(pos3, effect3)
			end
			if effect4 ~= 255 then
				doSendMagicEffect(pos4, effect4)
			end
			if effect5 ~= 255 then
				doSendMagicEffect(pos5, effect5)
			end
			
			doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), area, -min, -max, 255)	
			doRegainSpeed(cid)
			setPlayerStorageValue(cid, 3644587, -1)
		end
		
		local function ChargingBeam(cid)
			if not isCreature(cid) then
				return true
			end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
				return true
			end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
				return true
			end
			local tab = {}
			
			for x = -2, 2 do
				for y = -2, 2 do
					local pos = getThingPosWithDebug(cid)
					pos.x = pos.x + x
					pos.y = pos.y + y
					if pos.x ~= getThingPosWithDebug(cid).x and pos.y ~= getThingPosWithDebug(cid).y then
						table.insert(tab, pos)
					end
				end
			end
			doSendDistanceShoot(tab[math.random(#tab)], getThingPosWithDebug(cid), 37)
		end
		
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		setPlayerStorageValue(cid, 3644587, 1) --alterado v1.6 n sei pq mas tava dando debug o.O
		
		doSendMagicEffect(getThingPosWithDebug(cid), 132) 
		addEvent(useSolarBeam, 650, cid)		
		
		--(rever spell abaixo)	"dano = whipn", whipe, whips e whipw // local dano = {}
	elseif spell == "Vine Whip" then -- ñ funfa, Sem erro na distro, nada acontece.
		
		local area = getThingPosWithDebug(cid)
		local dano = {}
		local effect = 255
		
		if mydir == 0 then
			area.x = area.x + 1
			area.y = area.y - 1
			dano = whipn
			effect = 80
		elseif mydir == 1 then
			area.x = area.x + 2
			area.y = area.y + 1
			dano = whipe
			effect = 83
		elseif mydir == 2 then
			area.x = area.x + 1
			area.y = area.y + 2		
			dano = whips
			effect = 81
		elseif mydir == 3 then
			area.x = area.x - 1
			area.y = area.y + 1
			dano = whipw
			effect = 82
		end
		
		doSendMagicEffect(area, effect)
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), dano, -min, -max, 255)			
	elseif spell == "Fury Cutter" or spell == "Red Fury" then
		
		local effectpos = getThingPosWithDebug(cid)
		local effect = 255
		local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		
		if a == 0 then
			if getSubName(cid, target) == "Squirtle" then --alterado v1.6.1
				effect = 236
			else
				effect = 128
			end
			effectpos.x = effectpos.x + 1
			effectpos.y = effectpos.y - 1
		elseif a == 1 then
			effectpos.x = effectpos.x + 2
			effectpos.y = effectpos.y + 1
			if getSubName(cid, target) == "Squirtle" then --alterado v1.6.1
				effect = 232
			else
				effect = 129
			end
		elseif a == 2 then
			effectpos.x = effectpos.x + 1
			effectpos.y = effectpos.y + 2
			if getSubName(cid, target) == "Squirtle" then --alterado v1.6.1
				effect = 233
			else
				effect = 131
			end
		elseif a == 3 then
			effectpos.x = effectpos.x - 1
			effectpos.y = effectpos.y + 1
			if getSubName(cid, target) == "Squirtle" then --alterado v1.6.1
				effect = 224
			else
				effect = 130
			end
		end
		local function doFury(cid, effect)
			if not isCreature(cid) then return true end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			doSendMagicEffect(effectpos, effect)
			doMoveInArea2(cid, -1, wingatk, BUGDAMAGE, min, max, spell)
		end 
		
		addEvent(doFury, 0, cid, effect)
		addEvent(doFury, 350, cid, effect)		
		
		
	elseif spell == "Web Rain" then 
		
		local master = isSummon(cid) and getCreatureMaster(cid) or cid
		
		local function doFall(cid)
			for rocks = 1, 42 do
				addEvent(fall, rocks*35, cid, master, BUGDAMAGE, 23)
			end
		end
		
		for up = 1, 10 do
			addEvent(upEffect, up*75, cid, 23)
		end
		addEvent(doFall, 450, cid)
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.check = 0
		ret.eff = 26
		ret.spell = spell
		ret.cond = "Silence"
		
		addEvent(doMoveInArea2, 1400, cid, 0, BigArea2, BUGDAMAGE, min, max, spell, ret)
		
		
	elseif spell == "Spider Web" then
		
		local ret = {}
		ret.id = 0
		ret.cd = 9
		ret.check = 0
		ret.eff = 26
		ret.cond = "Silence"
		
		doMoveInAreaMulti(cid, 23, 26, multi, multiDano, BUGDAMAGE, min, max)
		doMoveInArea2(cid, 0, multiDano, BUGDAMAGE, 0, 0, spell, ret)		
		
	elseif spell == "Mud Shot" or spell == "Mud Slap" then
		
		if isCreature(target) then --alterado v1.8
			local contudion = spell == "Mud Shot" and "Miss" or "Stun" 
			local ret = {}
			ret.id = target
			ret.cd = 9
			ret.eff = 316 -- 34
			ret.check = getPlayerStorageValue(target, conds[contudion])
			ret.spell = spell
			ret.cond = contudion
			
			doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 6)
			addEvent(doMoveDano2, 100, cid, target, GROUNDDAMAGE, -min, -max, ret, spell)
		end
		
elseif spell == "Psychic" then
local pos = getThingPosWithDebug(cid)

		
        addEvent(doSendMagicEffect, 1, {x = pos.x + 1, y = pos.y + 1, z = pos.z}, 311) 
		
--	doDanoWithProtect(cid, psyDmg, getThingPosWithDebug(cid), selfArea2, min, max, 133)     
   addEvent(doDanoWithProtect, 110, cid, psyDmg, getThingPosWithDebug(cid), selfArea2, min, max, 133)     
	
		
elseif spell == "Inferno" or spell == "Fissure" then
    
local pos = getThingPosWithDebug(cid)

atk = {
["Inferno"] = {383, FIREDAMAGE},  -- 101   --export estragou o effect, concertar
["Fissure"] = {278, GROUNDDAMAGE},
--["Sky Attack"] = {307, FLYINGDAMAGE}
}

doMoveInArea2(cid, atk[spell][1], inferno1, atk[spell][2], 0, 0, spell)
addEvent(doDanoWithProtect, math.random(100, 400), cid, atk[spell][2], pos, inferno2, -min, -max, 0)
		
elseif spell == "Psy Impact" or spell== "Sky Attack" or spell == "Heart Stamp" then  --Não sei se Heart Stamp faz algo além de dar dano

local master = getCreatureMaster(cid) or 0
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 0
ret.check = 0
ret.spell = spell
ret.cond = "Miss"
 
if spell == "Psy Impact" then
			dano = psyDmg --alterado v1.4
			eff = 291
		elseif spell == "Sky Attack" then
			dano = FLYINGDAMAGE
			eff = 307
		else
            dano = NORMALDAMAGE
            eff = 442		
		end
		
	


 
for rocks = 1, 42 do
    addEvent(fall, rocks*35, cid, master, dano, -1, eff) 
end

addEvent(doMoveInArea2, 500, cid, 0, BigArea2, dano, min, max, spell, ret) 		
	

elseif spell == "SmokeScreen" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 34 --34
ret.check = 0
ret.spell = spell
ret.cond = "Miss"

local function smoke(cid)
if not isCreature(cid) then return true end
if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return false end
if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
   doMoveInArea2(cid, 34, confusion, NORMALDAMAGE, 0, 0, spell, ret) --34
end

setPlayerStorageValue(cid, 3644587, 1)
addEvent(setPlayerStorageValue, 1000, cid, 3644587, -1) 
for i = 0, 2 do
    addEvent(smoke, i*500, cid)                               
end

--elseif spell == "Eruption" or spell == "Elecball" then
elseif spell == "Elecball" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 14
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
    
pos = getThingPosWithDebug(cid)
    pos.x = pos.x+1
    pos.y = pos.y+1
    
atk = {
["Elecball"] = {171, ELECTRICDAMAGE},
--["Eruption"] = {241, FIREDAMAGE}
}

stopNow(cid, 1000)
doSendMagicEffect(pos, atk[spell][1])
doMoveInArea2(cid, 0, bombWee1, atk[spell][2], min, max, spell) 


elseif spell == "Eruption" then 
		
		local pos = getThingPosWithDebug(cid)
		
		posOk = getThingPosWithDebug(cid)
    posOk.x = pos.x+1
    posOk.y = pos.y+1
		
		local function doSendBubble(cid, pos)
			if not isCreature(cid) then return true end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			
		--	addEvent(doSendDistanceShoot, 700, getThingPosWithDebug(cid), pos, 58)
		--	addEvent(doSendMagicEffect, 700, pos, 319)
			
			addEvent(doSendDistanceShoot, 250, getThingPosWithDebug(cid), pos, 3)
			addEvent(doSendMagicEffect, 250, pos, 15)--53
		end
		--alterado!!
		stopNow(cid, 1000)
		doSendMagicEffect(posOk, 241)
		doMoveInArea2(cid, 0, bombWee1, FIREDAMAGE, min+mathpercent(min, 20), max+mathpercent(min, 20), spell)  
		for a = 2, 20 do
			local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
			addEvent(doSendBubble, a * 30, cid, lugar)
		end
		addEvent(doDanoWithProtect, 150, cid, FIREDAMAGE, pos, waterarea, -min, -max, 0)	      

elseif spell == "Lava Plume" then 

doMoveInArea2(cid, 5, crossplume, FIREDAMAGE, -min, -max, spell)

-- Fazer Flame Circle (parecido com flame wheel, usar silver gale de base)
elseif spell == "Electro Field" or spell == "Petal Tornado" or spell == "Waterfall" or spell == "Flame Wheel" then  --alterado v1.8

local p = getThingPos(cid)
local pos1 = {
[1] = {{x = p.x, y = p.y+4, z = p.z}, {x = p.x+1, y = p.y+4, z = p.z}, {x = p.x+2, y = p.y+3, z = p.z}, {x = p.x+3, y = p.y+2, z = p.z}, {x = p.x+4, y = p.y+1, z = p.z}, {x = p.x+4, y = p.y, z = p.z}},
[2] = {{x = p.x, y = p.y+3, z = p.z}, {x = p.x+1, y = p.y+3, z = p.z}, {x = p.x+2, y = p.y+2, z = p.z}, {x = p.x+3, y = p.y+1, z = p.z}, {x = p.x+3, y = p.y, z = p.z}},
[3] = {{x = p.x, y = p.y+2, z = p.z}, {x = p.x+1, y = p.y+2, z = p.z}, {x = p.x+2, y = p.y+1, z = p.z}, {x = p.x+2, y = p.y, z = p.z}},
[4] = {{x = p.x, y = p.y+1, z = p.z}, {x = p.x+1, y = p.y+1, z = p.z}, {x = p.x+1, y = p.y, z = p.z}},
}

local pos2 = {
[1] = {{x = p.x, y = p.y-4, z = p.z}, {x = p.x-1, y = p.y-4, z = p.z}, {x = p.x-2, y = p.y-3, z = p.z}, {x = p.x-3, y = p.y-2, z = p.z}, {x = p.x-4, y = p.y-1, z = p.z}, {x = p.x-4, y = p.y, z = p.z}},
[2] = {{x = p.x, y = p.y-3, z = p.z}, {x = p.x-1, y = p.y-3, z = p.z}, {x = p.x-2, y = p.y-2, z = p.z}, {x = p.x-3, y = p.y-1, z = p.z}, {x = p.x-3, y = p.y, z = p.z}},
[3] = {{x = p.x, y = p.y-2, z = p.z}, {x = p.x-1, y = p.y-2, z = p.z}, {x = p.x-2, y = p.y-1, z = p.z}, {x = p.x-2, y = p.y, z = p.z}},
[4] = {{x = p.x, y = p.y-1, z = p.z}, {x = p.x-1, y = p.y-1, z = p.z}, {x = p.x-1, y = p.y, z = p.z}},
}

local pos3 = {
[1] = {{x = p.x+4, y = p.y, z = p.z}, {x = p.x+4, y = p.y-1, z = p.z}, {x = p.x+3, y = p.y-2, z = p.z}, {x = p.x+2, y = p.y-3, z = p.z}, {x = p.x+1, y = p.y-4, z = p.z}, {x = p.x, y = p.y-4, z = p.z}},
[2] = {{x = p.x+3, y = p.y, z = p.z}, {x = p.x+3, y = p.y-1, z = p.z}, {x = p.x+2, y = p.y-2, z = p.z}, {x = p.x+1, y = p.y-3, z = p.z}, {x = p.x, y = p.y-3, z = p.z}},
[3] = {{x = p.x+2, y = p.y, z = p.z}, {x = p.x+2, y = p.y-1, z = p.z}, {x = p.x+1, y = p.y-2, z = p.z}, {x = p.x, y = p.y-2, z = p.z}},
[4] = {{x = p.x+1, y = p.y, z = p.z}, {x = p.x+1, y = p.y-1, z = p.z}, {x = p.x, y = p.y-1, z = p.z}},
}

local pos4 = {
[1] = {{x = p.x-4, y = p.y, z = p.z}, {x = p.x-4, y = p.y+1, z = p.z}, {x = p.x-3, y = p.y+2, z = p.z}, {x = p.x-2, y = p.y+3, z = p.z}, {x = p.x-1, y = p.y+4, z = p.z}, {x = p.x, y = p.y+4, z = p.z}},
[2] = {{x = p.x-3, y = p.y, z = p.z}, {x = p.x-3, y = p.y+1, z = p.z}, {x = p.x-2, y = p.y+2, z = p.z}, {x = p.x-1, y = p.y+3, z = p.z}, {x = p.x, y = p.y+3, z = p.z}},
[3] = {{x = p.x-2, y = p.y, z = p.z}, {x = p.x-2, y = p.y+1, z = p.z}, {x = p.x-1, y = p.y+2, z = p.z}, {x = p.x, y = p.y+2, z = p.z}},
[4] = {{x = p.x-1, y = p.y, z = p.z}, {x = p.x-1, y = p.y+1, z = p.z}, {x = p.x, y = p.y+1, z = p.z}},
}

local atk = {
--[atk] = {distance, eff, damage}
["Electro Field"] = {41, 207, ELECTRICDAMAGE},
["Petal Tornado"] = {14, 54, GRASSDAMAGE}, 

["Flame Wheel"] = {-1, 6, FIREDAMAGE},     --alterado v1.9
["Waterfall"] = {-1, 155, WATERDAMAGE},
}

local function sendDist(cid, posi1, posi2, eff, delay)
if posi1 and posi2 and isCreature(cid) then
   addEvent(sendDistanceShootWithProtect, delay, cid, posi1, posi2, eff)   --alterado v1.6
end
end
                                                               
local function sendDano(cid, pos, eff, delay, min, max)
if pos and isCreature(cid) then
   addEvent(doDanoWithProtect, delay, cid, atk[spell][3], pos, 0, -min, -max, eff)  --alterado v1.6
end
end

local function doTornado(cid)
if isCreature(cid) then
for j = 1, 4 do
   for i = 1, 6 do                                                  --41/207  -- 14/54
       addEvent(sendDist, 350, cid, pos1[j][i], pos1[j][i+1], atk[spell][1], i*330)
       addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i*300, min, max)
       addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i*310, 0, 0)
       ---
       addEvent(sendDist, 350, cid, pos2[j][i], pos2[j][i+1], atk[spell][1], i*330)
       addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i*300, min, max)
       addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i*310, 0, 0)
       ----
       addEvent(sendDist, 800, cid, pos3[j][i], pos3[j][i+1], atk[spell][1], i*330)
       addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i*300, min, max)
       addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i*310, 0, 0)
       ---
       addEvent(sendDist, 800, cid, pos4[j][i], pos4[j][i+1], atk[spell][1], i*330)
       addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i*300, min, max)
       addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i*310, 0, 0)
   end
end
end
end

if spell == "Electro Field" then
   addEvent(doMoveInArea2, 1000, cid, 0, electro, ELECTRICDAMAGE, 0, 0, spell, ret)
end

if spell == "Waterfall" then
   addEvent(doMoveInArea2, 1000, cid, 0, electro, WATERDAMAGE, 0, 0, spell, ret)
end

if spell == "Flame Wheel" then   --alterado v1.8
   doTornado(cid)
else
    for b = 0, 2 do
        addEvent(doTornado, b*1500, cid)
    end
end

elseif spell == "Astonish" then
    local pos = getThingPosWithDebug(cid)       
		pos.x = pos.x+1
		pos.y = pos.y+1
		
	doDanoWithProtect(cid, GHOSTDAMAGE, pos, selfArea2, min, max, 313) 


elseif spell == "Frenzy Plant" then 
		
		local pos = getThingPosWithDebug(cid)
		
	doSendMagicEffect(pos, 318)		

		posOk = getThingPosWithDebug(cid)
    posOk.x = pos.x+1
    posOk.y = pos.y+1
		
		local function doSendBubble(cid, pos)
			if not isCreature(cid) then return true end
			if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
			
			addEvent(doSendDistanceShoot, 700, getThingPosWithDebug(cid), pos, 58)
			addEvent(doSendMagicEffect, 700, pos, 319)
		end
		--alterado!!
		for a = 1, 20 do
			local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
			addEvent(doSendBubble, a * 25, cid, lugar) --a * 25
		--	addEvent(doSendMagicEffect, a * 25, cid, lugar, 319)
		
		--	addEvent(doDanoWithProtect, 150, cid, FIREDAMAGE, pos, lugar, -min, -max, 319)
			
		end
	
		addEvent(doDanoWithProtect, 650, cid, GRASSDAMAGE, pos, waterarea, -min, -max)	

		
		
	
	elseif spell == "Shadow Sphere" then
		local pos = getThingPosWithDebug(target)
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 17)
		addEvent(doDanoWithProtect, 200, cid, GHOSTDAMAGE, getThingPosWithDebug(target), waba, min, max, 0)	
		addEvent(doSendMagicEffect, 195, {x = pos.x + 2, y = pos.y + 2, z = pos.z}, 320)
		

    elseif spell == "Ice Ball" then -- Pxg só falta trocar effect explode e por p/ congelar, fazer missile(bola) e criar outra q congela
		local pos = getThingPosWithDebug(target)
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 28)
		addEvent(doDanoInTargetWithDelay, 200, cid, pos, ICEDAMAGE, min, max)
		addEvent(doDanoInTargetWithDelay, 200, cid, pos, ICEDAMAGE, min, max)
		--addEvent(doDanoWithProtect, 200, cid, ICEDAMAGEDAMAGE, getThingPosWithDebug(target), waba, min, max, 0)	
		addEvent(doSendMagicEffect, 199, {x = pos.x + 1, y = pos.y + 1, z = pos.z}, 440)	
      
	
	elseif spell == "Wood Hammer" then
		local pos = getThingPosWithDebug(target)
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
		addEvent(doDanoInTargetWithDelay, 100, cid, pos, GRASSDAMAGE, min, max)
	--	addEvent(doDanoWithProtect, 190, cid, GRASSDAMAGE, getThingPosWithDebug(target), waba, min, max, 0)	
		  addEvent(doSendMagicEffect, 75, pos, 437)
		  
	
	elseif spell == "Lighting Horn" then -- Deixei com dano em area, não tenho ctz 
		local pos = getThingPosWithDebug(target)
		addEvent(doDanoWithProtect, 200, cid, ELECTRICDAMAGE, getThingPosWithDebug(target), waba, min, max, 0)	
		addEvent(doSendMagicEffect, 199, {x = pos.x + 1, y = pos.y + 1, z = pos.z}, 438)	
		
		
	elseif spell == "Incinerate" then
		local pos = getThingPosWithDebug(target)
		addEvent(doDanoInTargetWithDelay, 50, cid, pos, FIREDAMAGE, min, max)
	--	addEvent(doDanoWithProtect, 200, cid, FIREDAMAGE, getThingPosWithDebug(target), waba, min, max, 0)	
		addEvent(doSendMagicEffect, 20, {x = pos.x + 1, y = pos.y + 1, z = pos.z}, 439)	

	
	elseif spell == "Icy Wind" then  -- effect "menor" difernete do effect do pxG ficou melhor :D      

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 43
ret.check = 0
ret.first = true
ret.cond = "Slow"
	
  doMoveInArea2(cid, 441, db1, ICEDAMAGE, min, max, spell, ret)	--440
	

    
elseif spell == "Earthquake" then

local eff = getSubName(cid, target) == "Shiny Onix" and 175 or 118  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return false end
if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
   doMoveInArea2(cid, eff, confusion, GROUNDDAMAGE, min, max, spell)
end

times = {0, 500, 1000, 1500, 2300, 2800, 3300, 3800, 4600, 5100, 5600, 6100, 6900, 7400, 7900, 8400, 9200, 10000}

setPlayerStorageValue(cid, 3644587, 1)
addEvent(setPlayerStorageValue, 10000, cid, 3644587, -1)
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

	


elseif spell == "Smog" then -- Causa Slow e Poison, porém poison ainda não funciona(ret) e não sei por 2 debuff(ret)

local eff = 316  
 
local function doQuake(cid)
if not isCreature(cid) then return false end
if isSleep(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return false end
if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 316
ret.check = 0
ret.first = true
ret.cond = "Slow"

   doMoveInArea2(cid, eff, selfArea1, POISONDAMAGE, min, max, spell, ret)
end

times = {0, 500, 1000, 1500, 2300, 2800, 3300, 3800, 4600, 5100, 5600, 6100, 6900, 7400, 7900, 8200, 9000, 9800}

setPlayerStorageValue(cid, 3644587, 1)
addEvent(setPlayerStorageValue, 10000, cid, 3644587, -1)
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end


elseif spell == "Tailwind" then

local ret = {}
		ret.id = cid
		ret.cd = 15
		ret.eff = 14
		ret.check = 0
		ret.buff = spell
		ret.first = true
		
		doCondition2(ret)
		--	
	else
		SPELL_OUT = false
		print("a spell "..spell.." nao existe!")
	end
	
	if SPELL_OUT then
		doCreatureSay(cid, ""..string.upper(spell).."!", TALKTYPE_MONSTER)
	end
	return true
end