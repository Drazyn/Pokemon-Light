PokeballAtributes = {"block", "addon", "addtm", "totaltm", "poke", "level", "boost", "speed", "ball", "gender", "maxhp", "hp", "attack", "defense", "spattack", "spdefense", "ehditto", "rarecandy", "blink", "control", "light"}

-- Loot System
RareLoots = {2160}

-- Mimic Wall Time
MimicWallTime = 15 -- Tempo em segundos de duração do MimicWall

-- Rare Candy
MaxRareCandy = 5 -- Máximo de rare candy por pokemon
TimeToUseRareCandyAgain = 2*60*60 -- Tempo em segundos para usar rare candy denovo

--Boost
PercentBoostExtra = 0.5 -- Quanto porcento aumenta o status do pokemon
BoostLimit = 50 -- Limite de boost por pokemon

--Level
PokeLevelExtraStatus = 1 -- Porcentagem que aumenta offense, defense, special attack e special defense
PokemonMaxLevel = 100 -- Level máximo do pokemon

-- Others
PercentToCureOtherPokemons = 75 -- Porcentagem que vai diminuir quando player usar potion em pokemon de outros players
LogOutDelay = 5 -- Tempo para deslogar denovo ao logar
maxSlots = 3 -- Ditto Memory

--[[
    <movevent type="StepIn" itemid="460;12171-12173;4608-4625;4632-4643;4644-4663;4664-4666" event="script" value="fly.lua"/>
	<movevent type="StepOut" itemid="460;12171-12173;4608-4625;4632-4643;4644-4663;4664-4666" event="script" value="fly.lua"/>
]]
WATER = {4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619}
WATER_BORDERS = {4620, 4621, 4622, 4623, 4624, 4625,
         4632, 4633, 4634, 4635, 4636, 4637, 4638, 4639, 4640, 4641, 4642, 4643,
         4644, 4645, 4646, 4647, 4648, 4649, 4650, 4651, 4652, 4653, 4654, 4655, 4656, 4657, 4658, 4659, 4660, 4661, 4662, 4663,
         4664, 4665, 4666}
--WatersId = {11756, 4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}
StoneTable = {7744, 7745, 7746, 7747, 7748, 7749,7750, 7751, 7752, 7753, 7754, 7755, 7756, 7757}

GhostPokemons = {"Gengar", "Haunter", "Gastly"}
  
not_ussable = {"Articuno", "Moltres", "Zapdos", "Mew", "Mewtwo"} -- Pokemons que não podem ser usados! Nem capturados nem copiados!

-- Technical Machine
 
tmoves = {
    ["Quick Attack"] = {spell = "Quick Attack", minLv = 1, min = 10, max = 20, target = "yes",dista = 1 , cd = 7},
	["Hydropump"] = {spell = "Hydropump", minLv = 1, min = 10, max = 20, target = "no",dista = 1 , cd = 7},
	["Inferno"] = {spell = "Inferno", minLv = 1, min = 10, max = 20, target = "no",dista = 1 , cd = 7},
}

-- "Meio de transporte"
 
rides = { -- Pokémon que usam rides
    ["Venusaur"] = {looktype = 252, speed = 150},
    ["Rapidash"] = {looktype = 258, speed = 150},
    ["Doduo"] = {looktype = 262, speed = 150},
    ["Dodrio"] = {looktype = 261, speed = 150},
    ["Ninetales"] = {looktype = 276, speed = 150},
    ["Onix"] = {looktype = 278, speed = 150},
    ["Ponyta"] = {looktype = 282, speed = 150},
    ["Rhyhorn"] = {looktype = 284, speed = 150},
    ["Taurus"] = {looktype = 292, speed = 150},
   
}
 
flys = { -- Pokémon que usa Fly
    ["Charizard"] = {looktype = 255, speed = 300},
    ["Pidgeot"] = {looktype = 255, speed = 300},
    ["Fearow"] = {looktype = 265, speed = 300},
    ["Aerodactyl"] = {looktype = 259, speed = 300},
    ["Articuno"] = {looktype = 260, speed = 300},
    ["Dragonite"] = {looktype = 263, speed = 300},
    ["Mew"] = {looktype = 255, speed = 300},
    ["Mewtwo"] = {looktype = 273, speed = 300},
    ["Charizard"] = {looktype = 274, speed = 300},
    ["Moltres"] = {looktype = 275, speed = 300},
    ["Porygon"] = {looktype = 283, speed = 300},
    ["Zapdos"] = {looktype = 297, speed = 300},
    ["Gengar"] = {looktype = 301, speed = 300},
}

surfs = {
	["Charizard"] = {lookType = 301, speed = 300}
}

-- Evolution

pokeevo = {
    ["Bulbasaur"] = { evo = "Ivysaur", count = 1, stoneid = 7752, stoneid2 = 0, level = 16},
	["Ivysaur"] = { evo = "Venusaur", count = 2, stoneid = 7752, stoneid2 = 0, level = 16},
}

-- Order

rocksmashi = {1285} -- Items que o rock smash quebram
cuti = {2767, 2768, 3985} -- items que o cut corta
digi = {468, 481, 483} -- items que podem ser abertos pelo dig

msg = { -- Mensagens usadas no order
	["move"] = {"move!", "move there!", "go there!", "walk there!"},
	["fly"] = {"let's fly!", "let me get on you!"},
	["light"] = {"flash!", "light!", "flash this place!", "light up this place!"},
	["blink"] = {"teleport there!", "blink there!", "blink!", "teleport!"},
	["rock smash"] = {"break that rock!", "smash that rock!", "destroy that rock!", "smash it!", "break it!", "destroy it!"},
	["cut"] = {"cut that bush!", "cut it down!", "cut it off!", "cut off that bush!", "cut down that bush!", "cut that bush down!"},
	["dig"] = {"open that hole!", "dig that hole!", "open it!", "dig it!"},
	["ride"] = {"let me ride you!", "let's ride!", "let me mount you!", "let me get on you!"},
}

-- Addon

PokeAddons = {
	["Bulbasaur"] = {
		["Blue Cap"] = {looktype = 635},
	},
	["Dragonite"] = {
		["Red Scarf"] = {looktype = 636, fly = 637},
		["Blue Cap"] = {looktype = 635},
	}
}

ItemidToAddon = {
	[2457] = "Red Scarf",
}
