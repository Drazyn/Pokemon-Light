function getPokemonMinLevelByName(name)
	name = doCorrectPokemonName(name)
	return getMonsterInfo(name).levelMin or 0
end

function getCreatureEvolutionName(name)
	name = doCorrectPokemonName(name)
	if name == "Eevee" then
		return "Vaporeon, Flareon and Jolteon"
	elseif pokeevo[name] then
		return pokeevo[name].evo.." (level "..poke_status[name].level..")"
	end
	return "none"
end

function getPokemonMovesByName(name)
	local str = {}
	local name = doCorrectPokemonName(name)
	if PokeMoves[name] then
		for i = 1, 13 do
			if PokeMoves[name][i] then
				table.insert(str, PokeMoves[name][i].spell.." - Level: "..PokeMoves[name][i].minLv.." - Cooldown: "..PokeMoves[name][i].cd.." seconds")	
			end
			if i == 13 and #str >= 1 then
				return str
			end
		end	
	end
	return {"none"}
end

function getPokemonAbilitys(name)
	name = doCorrectPokemonName(name)
	special = poke_special[name]
	str = {}
	if special then
		if special.light then
			table.insert(str, "Light (Ability to clear the place)")
		end
		if special.blink then
			table.insert(str, "Blink (Ability to teleport distance Short)")
		end
		if special.rocksmash then
			table.insert(str, "Rock Smash (Ability to break stones)")
		end
		if special.cut then
			table.insert(str, "Cut (Ability to cut bushes)")
		end
		if special.dig then
			table.insert(str, "Dig (Ability to open a hole in the ground)")
		end
		if isGhostByName(name) then
			table.insert(str, "Ghost (Ability to pass through walls)")
		end
		if rides[name] then
			table.insert(str, "Ride (Ability to ride your pokemon)")
		end
		if flys[name] then
			table.insert(str, "Fly (Ability for fly in what place want)")
		end
		if surfs[name] then
			table.insert(str, "Surf (Ability for surf in the water)")
		end
		if name == "Ditto" then
			table.insert(str, "Transform (Ability copy others pokemon)")
		end
		if #str > 0 then
			return str
		end
	end
	return {"none"}
end

function getPokemonInfoByName(name)
	name = doCorrectPokemonName(name)
	pstatus = poke_status[name]
	if pstatus then
		pokedex = {}
		table.insert(pokedex, "Name: "..name.."\n")
		type1 = pstatus.type1
		type2 = pstatus.type2
		if type2 ~= "none" then
			table.insert(pokedex, "Type: "..type1.."/"..type2.."\n")
		else
			table.insert(pokedex, "Type: "..type1.."\n")
		end
		table.insert(pokedex, "\nRequired level: "..pstatus.level.."\n")
		table.insert(pokedex, "Required pokemon level: "..getPokemonMinLevelByName(name).."\n")
		table.insert(pokedex, "\nEvolutions: "..getCreatureEvolutionName(name).."\n")
		table.insert(pokedex, "\nMoves:\n"..table.concat(getPokemonMovesByName(name), "\n").."\n")
		table.insert(pokedex, "Ability:\n"..table.concat(getPokemonAbilitys(name), "\n"))
		return table.concat(pokedex)
	end
end

function doOpenPokedex(cid, name)
	name = doCorrectPokemonName(name)
	doShowTextDialog(cid, poke_special[name].fotopoke, getPokemonInfoByName(name))
end

function doRegisterPokemonInPokedex(cid, name)
	if isPlayer(cid) then
		name = doCorrectPokemonName(name)
        local exp = poke_catch[name].dex_exp
        local newsto = poke_catch[name].stoCatch - 500
        if getPlayerStorageValue(cid, newsto) <= 0 then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have unlocked " .. name .. " in your pokedex!")
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have gained " .. exp .. " experience points.")
            doPlayerAddExperience(cid, exp)
            setPlayerStorageValue(cid, newsto, 1)
            doPlayerSetSkillLevel(cid, 6, getPlayerSkillLevel(cid, 6)+1)
        end
	end
end

function getAllPokedex(cid)
	if isPlayer(cid) then
		return getPlayerSkillLevel(cid, 6)
	end
	return 0
end