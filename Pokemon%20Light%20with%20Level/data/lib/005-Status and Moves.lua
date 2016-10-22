conds = {
    ["Slow"] = 3890,
    ["Confusion"] = 3891, 
    ["Burn"] = 3892,
    ["Poison"] = 3893,
    ["Fear"] = 3894,
    ["Stun"] = 3895,
    ["Paralyze"] = 3896,
    ["Leech"] = 3897,
    ["Buff1"] = 3898,
    ["Buff2"] = 3899,
    ["Buff3"] = 3900,
    ["Miss"] = 32659, 
    ["Silence"] = 32698, 
    ["Sleep"] = 98271,
}

local roardirections = {
    [NORTH] = {SOUTH},
    [SOUTH] = {NORTH},
    [WEST] = {EAST}, --edited sistema de roar
[EAST] = {WEST}}

Buffs = {
    [1] = {"Buff1", 3898},
    [2] = {"Buff2", 3899},
    [3] = {"Buff3", 3900},
}

function doRaiseStatus(cid, off, def, agi, time) 
    if not isCreature(cid) then return true end
    local A = getOffense(cid)
    local B = getDefense(cid)
    
    if off > 0 then
        setPlayerStorageValue(cid, 1001, A * off)
    end
    if def > 0 then
        setPlayerStorageValue(cid, 1002, B * def)
    end
    if agi > 0 then
        doChangeSpeed(cid, getCreatureSpeed(cid)+agi)
    end
    
    local D = getOffense(cid)
    local E = getDefense(cid)
    local G = D - A
    local H = E - B
    
    addEvent(function()
        doReduceStatus(cid, G, H, 1)
    end, time*1000)
end

function doReduceStatus(cid, off, def, agi) --reduz os status
    if not isCreature(cid) then return true end
    local A = getOffense(cid)
    local B = getDefense(cid)
    
    if off > 0 then
        setPlayerStorageValue(cid, 1001, A - off)
    end
    if def > 0 then
        setPlayerStorageValue(cid, 1002, B - def)
    end
    if agi > 0 then
      doRegainSpeed(cid)
    end
end

function doPushCreature(uid,direction,distance,time)
    if isCreature(uid) == TRUE then
        local rand = (2*math.random(0,1))-1
        local rand2 = math.random(-1,0)
        if direction == 0 then
            signal = {0,rand,-rand,rand,-rand,0,-1,-1,-1,0,0,0}
        elseif direction == 1 then
            signal = {1,1,1,0,0,0,0,rand,-rand,rand,-rand,0}
        elseif direction == 2 then
            signal = {0,rand,-rand,rand,-rand,0,1,1,1,0,0,0}
            
        elseif direction == 3 then
            
            signal = {-1,-1,-1,0,0,0,0,rand,-rand,rand,-rand,0}
            
        elseif direction == 4 then
            
            signal = {-1,rand2,(-rand2)-1,0,1,rand2+1,rand2,0}
            
        elseif direction == 5 then
            
            signal = {1,-rand2,-((-rand2)-1),0,1,rand2+1,rand2,0}
            
        elseif direction == 6 then
            
            signal = {-1,rand2,(-rand2)-1,0,-1,(-rand2)-1,rand2,0}
            
        else
            
            signal = {1,-rand2,-((-rand2)-1),0,-1,(-rand2)-1,rand2,0}
            
        end
        
        local pos = getThingPos(uid)
        
        nsig = #signal
        
        nvar = 0
        
        
        
        repeat
            
            nvar = nvar+1
            
            newpos = {x=pos.x+(signal[nvar]),y=pos.y+(signal[(nsig/2)+nvar]),z=pos.z}
            
            newtile = {x=newpos.x,y=newpos.y,z=newpos.z,stackpos=0}
            
        until getTileThingByPos(newtile).uid ~= 0 and hasProperty(getTileThingByPos(newtile).uid,3) == FALSE and canWalkOnPos(newtile, true, false, true, true, false) and queryTileAddThing(uid,newpos) == 1 or nvar == (nsig/2)
        --alterado v2.5
        
        
        if distance == nil or distance == 1 then
            
            doTeleportThing(uid,newpos,TRUE) 
            
        else
            
            distance = distance-1
            
            doTeleportThing(uid,newpos,TRUE)
            
            if time ~= nil then
                
                addEvent(doPushCreature,time,uid,direction,distance,time)
                
            else
                
                addEvent(doPushCreature,500,uid,direction,distance,500)
                
            end 
            
        end
        
    end 
    
end


function isBurning(cid)
    if not isCreature(cid) then return false end
    if getPlayerStorageValue(cid, conds["Burn"]) >= 0 then return true end
    return false
end

function isPoisoned(cid)
    if not isCreature(cid) then return false end
    if getPlayerStorageValue(cid, conds["Poison"]) >= 0 then return true end
    return false
end

function isSilence(cid)
    if not isCreature(cid) then return false end
    if getPlayerStorageValue(cid, conds["Silence"]) >= 0 then return true end
    return false
end

function isParalyze(cid) 
    if not isCreature(cid) then return false end
    if getPlayerStorageValue(cid, conds["Paralyze"]) >= 0 then return true end
    return false
end

function isWithFear(cid)
    if not isCreature(cid) then return false end
    if getPlayerStorageValue(cid, conds["Fear"]) >= 0 then return true end
    return false
end 

function isPosEqual(pos1, pos2)
    if pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z then
        return true
    end 
    return false
end

function getRecorderCreature(pos, cid)
    local ret = 0
    if cid and isPosEqual(getThingPos(cid), pos) then --alterado v1.9
        return cid
    end
    local s = {}
    s.x = pos.x
    s.y = pos.y
    s.z = pos.z
    for a = 0, 255 do
        s.stackpos = a
        local b = getTileThingByPos(s).uid
        if b > 1 and isCreature(b) and getCreatureOutfit(b).lookType ~= 814 then
            ret = b
        end
    end
    return ret
end

function getThingFromPosWithProtect(pos) --Pega uma creatura numa posiçao com proteçoes
    if hasTile(pos) then
        if isCreature(getRecorderCreature(pos)) then
            return getRecorderCreature(pos)
        else
            pos.stackpos = 253
            pid = getThingfromPos(pos).uid
        end
    else
        pid = getThingfromPos({x=1,y=1,z=10,stackpos=253}).uid
    end
    return pid
end

function doCondition2(ret)
    --
    function doMiss2(cid, cd, eff, check, spell)
        local stg = conds["Miss"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, 21100) >= 1 and getPlayerStorageValue(cid, stg) <= -1 then return true end --alterado v1.6 reflect
        if not canDoMiss(cid, spell) then return true end
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end 
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "miss", a)
            doItemSetAttribute(item.uid, "missEff", eff)
            doItemSetAttribute(item.uid, "missSpell", spell)
        end
        
        if a <= -1 then 
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        doSendMagicEffect(getThingPos(cid), eff)
        addEvent(doMiss2, 1000, cid, -1, eff, a, spell) 
    end 
    
    function doSilence2(cid, cd, eff, check)
        local stg = conds["Silence"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "silence", a)
            doItemSetAttribute(item.uid, "silenceEff", eff)
        end
        
        if a <= -1 then 
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        doSendMagicEffect(getThingPos(cid), eff)
        addEvent(doSilence2, 1000, cid, -1, eff, a) 
    end 
    
    function doSlow2(cid, cd, eff, check, first)
        local stg = conds["Slow"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "slow", a)
            doItemSetAttribute(item.uid, "slowEff", eff)
        end
        
        if a <= -1 then 
            doRemoveCondition(cid, CONDITION_PARALYZE)
            if not isSleep(cid) and not isParalyze(cid) then
                addEvent(doRegainSpeed, 50, cid) --alterado
            end
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        if first then
            doAddCondition(cid, paralizeArea2) 
        end 
        
        doSendMagicEffect(getThingPos(cid), eff)
        addEvent(doSlow2, 1000, cid, -1, eff, a) 
    end 
    
    function doConfusion2(cid, cd, check)
        local stg = conds["Confusion"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "confuse", a)
        end
        
        if a <= -1 then 
            if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
                doRemoveCondition(cid, CONDITION_PARALYZE)
                addEvent(doAddCondition, 10, cid, paralizeArea2) 
            end
            if not isSleep(cid) and not isParalyze(cid) then
                doRegainSpeed(cid) --alterado 
            end
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        if math.random(1, 6) >= 4 then
            doSendMagicEffect(getThingPos(cid), 31)
        end
        
        local isTarget = isSummon(cid) and getCreatureTarget(getCreatureMaster(cid)) or getCreatureTarget(cid)
        if isCreature(isTarget) and not isSleep(cid) and not isParalyze(cid) and getPlayerStorageValue(cid, 654878) <= 0 then --alterado v1.6
            doChangeSpeed(cid, -getCreatureSpeed(cid))
            doChangeSpeed(cid, 100)
            doPushCreature(cid, math.random(0, 3), 1, 0) --alterado v1.6
            doChangeSpeed(cid, -100)
        end
        
        local pos = getThingPos(cid)
        addEvent(doSendMagicEffect, math.random(0, 450), pos, 31)
        
        addEvent(doConfusion2, 1000, cid, -1, a) 
    end 
    
    function doBurn2(cid, cd, check, damage)
        local stg = conds["Burn"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "burn", a)
            doItemSetAttribute(item.uid, "burndmg", damage)
        end
        
        if a <= -1 then 
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        doCreatureAddHealth(cid, -damage, 15, COLOR_BURN) 
        addEvent(doBurn2, 3500, cid, -1, a, damage) 
    end 
    
    function doPoison2(cid, cd, check, damage)
        local stg = conds["Poison"]
        if not isCreature(cid) then return true end --is creature?
        ----------
        if isSummon(cid) or ehMonstro(cid) and poke_status[getCreatureName(cid)] then --alterado v1.6
            local type = poke_status[getCreatureName(cid)].type1
            local type2 = poke_status[getCreatureName(cid)].type2
            if isInArray({"poison", "steel"}, type) or isInArray({"poison", "steel"}, type2) then
                return true
            end
        end
        ---------
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "poison", a)
            doItemSetAttribute(item.uid, "poisondmg", damage)
        end
        
        if a <= -1 or getCreatureHealth(cid) == 1 then 
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        local dano = getCreatureHealth(cid)-damage <= 0 and getCreatureHealth(cid)-1 or damage 
        doCreatureAddHealth(cid, -dano, 8, COLOR_GRASS) 
        
        addEvent(doPoison2, 1500, cid, -1, a, damage) 
    end 
    
    function doFear2(cid, cd, check, skill)
        local stg = conds["Fear"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "fear", a)
            doItemSetAttribute(item.uid, "fearSkill", skill)
        end
        
        if a <= -1 then 
            if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
                doRemoveCondition(cid, CONDITION_PARALYZE)
                addEvent(doAddCondition, 10, cid, paralizeArea2) 
            end
            if not isSleep(cid) and not isParalyze(cid) then
                doRegainSpeed(cid) --alterado 
            end
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        if skill == "Roar" then
            eff = 244
        else --edited Roar
            eff = 139
        end
        
        if math.random(1, 6) >= 4 then
            doSendMagicEffect(getThingPos(cid), eff)
        end
        
        local isTarget = isSummon(cid) and getCreatureTarget(getCreatureMaster(cid)) or getCreatureTarget(cid)
        if isCreature(isTarget) and not isSleep(cid) and not isParalyze(cid) and getPlayerStorageValue(cid, 654878) <= 0 then --alterado v1.6
            local dir = getCreatureDirectionToTarget(cid, isTarget)
            doChangeSpeed(cid, -getCreatureSpeed(cid))
            doChangeSpeed(cid, 100)
            doPushCreature(cid, roardirections[dir][1], 1, 0) --alterado v1.6
            doChangeSpeed(cid, -100)
        end
        
        local pos = getThingPos(cid)
        addEvent(doSendMagicEffect, math.random(0, 450), pos, eff)
        
        addEvent(doFear2, 1000, cid, -1, a, skill) 
    end 
    
    function doStun2(cid, cd, eff, check, spell)
        local stg = conds["Stun"]
        if not isCreature(cid) then return true end --is creature?
        if not canDoMiss(cid, spell) then return true end
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "stun", a)
            doItemSetAttribute(item.uid, "stunEff", eff)
            doItemSetAttribute(item.uid, "stunSpell", spell)
        end
        
        if a <= -1 then
            doRemoveCondition(cid, CONDITION_PARALYZE)
            if not isSleep(cid) and not isParalyze(cid) then
                addEvent(doRegainSpeed, 50, cid) --alterado 
            end
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        if getCreatureCondition(cid, CONDITION_PARALYZE) == false then
            doAddCondition(cid, paralizeArea2)
        end 
        doSendMagicEffect(getThingPos(cid), eff)
        addEvent(doStun2, 1000, cid, -1, eff, a, spell) 
    end 
    
    function doParalyze2(cid, cd, eff, check, first)
        local stg = conds["Paralyze"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "paralyze", a)
            doItemSetAttribute(item.uid, "paralyzeEff", eff)
        end
        
        if a <= -1 then 
            if isPlayer(cid) then
                if not isSleep(cid) then --alterado
                    mayNotMove(cid, false)
                end
            else
                if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
                    doRemoveCondition(cid, CONDITION_PARALYZE)
                    addEvent(doAddCondition, 10, cid, paralizeArea2) 
                end
                if not isSleep(cid) then
                    doRegainSpeed(cid) --alterado
                end
            end 
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        if isPlayer(cid) then
            mayNotMove(cid, true)
        else --alterado v1.6
            doChangeSpeed(cid, -2000)
        end 
        doSendMagicEffect(getThingPos(cid), eff)
        addEvent(doParalyze2, 1000, cid, -1, eff, a, false) 
    end 
    
    function doSleep2(cid, cd, check, first) 
        local stg = conds["Sleep"]
        if not isCreature(cid) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not isSleep(cid) then
            doSleep(cid)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "sleep", a)
        end
        addEvent(doSleep2, 1000, cid, -1, a, false)
    end 
    
    function doLeech2(cid, attacker, cd, check, damage)
        local stg = conds["Leech"]
        if not isCreature(cid) then return true end --is creature?
        if attacker ~= 0 and not isCreature(attacker) then return true end --is creature?
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
            setPlayerStorageValue(cid, stg, cd) --allterado v1.8
            return true 
        end
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, "leech", a)
            doItemSetAttribute(item.uid, "leechdmg", damage)
        end
        
        if a <= -1 then 
            setPlayerStorageValue(cid, stg, -1)
            return true 
        end
        
        local life = getCreatureHealth(cid)
        ------
        doCreatureAddHealth(cid, -damage)
        doSendAnimatedText(getThingPos(cid), "-"..damage.."", 144)
        doSendMagicEffect(getThingPos(cid), 45)
        ------
        local newlife = life - getCreatureHealth(cid)
        if newlife >= 1 and attacker ~= 0 then
            doSendMagicEffect(getThingPos(attacker), 14)
            doCreatureAddHealth(attacker, newlife)
            doSendAnimatedText(getThingPos(attacker), "+"..newlife.."", 32)
        end 
        addEvent(doLeech2, 2000, cid, attacker, -1, a, damage) 
    end 
    
    function doBuff2(cid, cd, eff, check, buff, first, attr)
        if not isCreature(cid) then return true end --is creature?
        ---------------------
        local atributo = attr and attr or ""
        if first and atributo == "" then
            for i = 1, 3 do 
                if getPlayerStorageValue(cid, Buffs[i][2]) <= 0 then
                    atributo = Buffs[i][1]
                    break
                end
            end
        end
        if atributo == "" then return true end
        if ehMonstro(cid) then atributo = "Buff1" end
        ----------------------
        local stg = conds[atributo]
        
        if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then return true end --n usar 2x
        
        if not check and getPlayerStorageValue(cid, stg) >= 1 then
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
        else
            setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
        end
        
        local a = getPlayerStorageValue(cid, stg)
        
        if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doItemSetAttribute(item.uid, atributo, a)
            doItemSetAttribute(item.uid, atributo.."eff", eff)
            doItemSetAttribute(item.uid, atributo.."skill", buff)
        end
        
        if a <= -1 then --alterado v1.6
            if isInArray({"Future Sight", "Camouflage", "Acid Armor", "Iron Defense", "Minimize", "Bug Fighter", "Ancient Fury"}, buff) then
                if isDittoBall(getCreatureMaster(cid)) then
                    if isSummon(cid) then
                        local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
                        doSetCreatureOutfit(cid, {lookType = getItemAttribute(item.uid, "transOutfit")}, -1) --alterado v1.6.1
                    end 
                elseif not isSleep(cid) then
                    doRemoveCondition(cid, CONDITION_OUTFIT)
                end
                setPlayerStorageValue(cid, 9658783, -1)
                setPlayerStorageValue(cid, 625877, -1) --alterado v1.6 
            end 
            if isInArray({"Strafe", "Agility", "Ancient Fury", "War Dog", "Fighter Spirit", "Furious Legs", "Ultimate Champion", "Bug Fighter"}, buff) then
                setPlayerStorageValue(cid, 374896, -1) --alterado v1.6
            end 
            setPlayerStorageValue(cid, stg, -1) 
            return true 
        end
        
        doSendMagicEffect(getThingPos(cid), eff)
        
        if first then
            if buff == "Strafe" or buff == "Agility" then
                setPlayerStorageValue(cid, 374896, 1) --velo atk --alterado v1.6
                doRaiseStatus(cid, 0, 0, 100, a)
            elseif buff == "Tailwind" then
                doRaiseStatus(cid, 0, 0, 200, a)
            elseif buff == "Rage" then
                doRaiseStatus(cid, 2, 0, 0, a)
            elseif buff == "Harden" then
                doRaiseStatus(cid, 0, 2, 0, a)
            elseif buff == "Calm Mind" then
                doRaiseStatus(cid, 0, 2, 0, a)
            elseif buff == "Ancient Fury" then
                doSetCreatureOutfit(cid, {lookType = outFurys[getCreatureName(cid)].outFury}, a*1000)
                setPlayerStorageValue(cid, 374896, 1) --velo atk
                if getCreatureName(cid) == "Shiny Charizard" then 
                    doRaiseStatus(cid, 2, 0, 0, a) --atk melee --alterado v1.6
                else
                    doRaiseStatus(cid, 0, 2, 0, a) --def
                end 
                setPlayerStorageValue(cid, 625877, outFurys[getCreatureName(cid)].outFury) --alterado v1.6
            elseif buff == "War Dog" then
                doRaiseStatus(cid, 1.5, 1.5, 0, a)
                setPlayerStorageValue(cid, 374896, 1) --velo atk
            elseif buff == "Rest" then
                doSleep2(cid, cd, getPlayerStorageValue(cid, conds["Sleep"]), true) 
                doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
            elseif isInArray({"Fighter Spirit", "Furious Legs", "Ultimate Champion"}, buff) then
                doRaiseStatus(cid, 1.5, 0, 0, a) --atk melee --alterado v1.6
                setPlayerStorageValue(cid, 374896, 1) --velo atk 
                addEvent(setPlayerStorageValue, a*1000, cid, 465987, -1) 
            elseif isInArray({"Future Sight", "Camouflage", "Acid Armor", "Iron Defense", "Minimize"}, buff) then
                doSetCreatureOutfit(cid, {lookType = outImune[buff]}, -1)
                setPlayerStorageValue(cid, 9658783, 1) 
                setPlayerStorageValue(cid, 625877, outImune[buff]) --alterado v1.6 
            elseif buff == "Bug Fighter" then
                setPlayerStorageValue(cid, 374896, 1) --velo atk --alterado v1.6
                doRaiseStatus(cid, 1.5, 1.5, 100, a)
                doSetCreatureOutfit(cid, {lookType = 1448}, a*1000)
                setPlayerStorageValue(cid, 625877, 1448) --alterado v1.6
            end 
        end 
        addEvent(doBuff2, 1000, cid, -1, eff, a, buff, false, atributo) 
    end
    
    if ret.buff and ret.buff ~= "" then
        doBuff2(ret.id, ret.cd, ret.eff, ret.check, ret.buff, ret.first, (ret.attr and ret.attr or false))
    end
    
    if ret.cond and ret.cond == "Miss" then
        doMiss2(ret.id, ret.cd, ret.eff, ret.check, ret.spell)
    elseif ret.cond and ret.cond == "Silence" then
        doSilence2(ret.id, ret.cd, ret.eff, ret.check)
    elseif ret.cond and ret.cond == "Slow" then
        doSlow2(ret.id, ret.cd, ret.eff, ret.check, ret.first)
    elseif ret.cond and ret.cond == "Confusion" then
        doConfusion2(ret.id, ret.cd, ret.check)
        doConfusion(ret.id)
    elseif ret.cond and ret.cond == "Burn" then
        doBurn2(ret.id, ret.cd, ret.check, ret.damage)
    elseif ret.cond and ret.cond == "Poison" then
        doPoison2(ret.id, ret.cd, ret.check, ret.damage)
    elseif ret.cond and ret.cond == "Fear" then
        doFear2(ret.id, ret.cd, ret.check, ret.skill)
    elseif ret.cond and ret.cond == "Stun" then
        doStun2(ret.id, ret.cd, ret.eff, ret.check, ret.spell)
    elseif ret.cond and ret.cond == "Paralyze" then
        doParalyze2(ret.id, ret.cd, ret.eff, ret.check, ret.first)
    elseif ret.cond and ret.cond == "Sleep" then
        doSleep(ret.id)
    elseif ret.cond and ret.cond == "Leech" then
        doLeech2(ret.id, ret.attacker, ret.cd, ret.check, ret.damage)
    end
end

-- Confusion

tonto = createConditionObject(CONDITION_DRUNK)
setConditionParam(tonto, CONDITION_PARAM_TICKS, 5000)

function isConfusion(cid)
    if not isCreature(cid) then 
        return false 
    end
    if getPlayerStorageValue(cid, 1995) >= 1 then 
        return true 
    end
    return false
end

function doConfusion(cid)
    if not isCreature(cid) then 
        return true 
    end
    doSendMagicEffect(getCreaturePosition(cid), 31)
    
    local function sleepxxxx(params)
        if isMonster(cid) then
            if params and params == true then
                setPlayerStorageValue(cid, 1995, 0)
            end
            doSendMagicEffect(getCreaturePosition(cid), 31)
        else
            return true
        end
    end
    setPlayerStorageValue(cid, 1995, 1)
    addEvent(sleepxxxx, 100, false)
    addEvent(sleepxxxx, 2000, false)
    addEvent(sleepxxxx, 3000, false)
    addEvent(sleepxxxx, 4000, true)
    
    if (hasCondition(cid, CONDITION_DRUNK)) then
        doRemoveCondition(cid, CONDITION_DRUNK)
    end 
    
    doAddCondition(cid , tonto) 
end

-- Sleep

sleep = createConditionObject(CONDITION_PARALYZE) -- Condition1
setConditionParam(sleep, CONDITION_PARAM_TICKS, 5*1000)
setConditionFormula(sleep, -1.7, 0, -1.8, 0)

paralizeArea2 = createConditionObject(CONDITION_PARALYZE) -- Condition2
setConditionParam(paralizeArea2, CONDITION_PARAM_TICKS, 50000)
setConditionFormula(paralizeArea2, -0.63, -0.63, -0.63, -0.63)

sleepp = createConditionObject(CONDITION_PARALYZE) -- Condition3
setConditionParam(sleepp, CONDITION_PARAM_TICKS, 4500)
setConditionFormula(sleepp, -1.7, 0, -1.8, 0)

function isSleep(cid)
    if not isCreature(cid) then return false end
    if getPlayerStorageValue(cid, 1996) >= 1 then 
        return true 
    end
    return false
end

function doSleepOutfit(pid) 
    if isPlayer(pid) then 
        return true 
    end
    if isSleep(pid) then 
        return true 
    end
    local Info = getMonsterInfo(getCreatureName(pid)).lookCorpse 
    local look = getCreatureOutfit(pid) 
    if Info ~= 0 and look.lookType ~= 0 then
        doSetCreatureOutfit(pid, {lookType = 0, lookTypeEx = getMonsterInfo(getCreatureName(pid)).lookCorpse}, 4000) 
    end
end

function doSleep(cid)
    -- Deletando condições antigas
    if (hasCondition(cid, CONDITION_PARALYZE)) then
        doRemoveCondition(cid, CONDITION_PARALYZE)
    end
    
    if (hasCondition(cid, CONDITION_HASTE)) then
        doRemoveCondition(cid, CONDITION_HASTE)
    end
    
    -- Status sleep
    
    doAddCondition(cid , sleepp)
    doSleepOutfit(cid)
    doSendAnimatedText(getCreaturePosition(cid), "Sleep", 154)
    addEvent(function()
        if isMonster(cid) then
            if not (hasCondition(cid, CONDITION_PARALYZE)) then
                if isSummon(cid) or isMonster(cid) then
                    doRegainSpeed(cid)
                end
                setPlayerStorageValue(cid, 1996, 0)
            end
        else
            return true
        end
    end, 5500)
    
    setPlayerStorageValue(cid, 1996, 1)
    
    if isSummon(cid) or isMonster(cid) then
        doChangeSpeed(cid, -getCreatureSpeed(cid))
    end
    
    for i = 1, 4 do
        if isMonster(cid) then
            addEvent(doSendMagicEffect, i*1000, getCreaturePosition(cid), 32)
        end
    end
end

-------THUNDER WAVE
thunderwavecondition = createConditionObject(CONDITION_PARALYZE)
setConditionParam(thunderwavecondition, CONDITION_PARAM_TICKS, 9000)
setConditionFormula(thunderwavecondition, -0.75, -0.75, -0.75, -0.75)

------SLEEP POWNDER
sleepcondition = createConditionObject(CONDITION_PARALYZE)
setConditionParam(sleepcondition, CONDITION_PARAM_TICKS, 10000) -- 5 segundos
setConditionParam(sleepcondition, CONDITION_PARAM_SPEED, -200) -- paralizado
setConditionFormula(sleepcondition, -0.9, 0, -0.9, 0)

------GHOST
condition_ghost = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(condition_ghost, CONDITION_PARAM_TICKS, 7000) 

------CONDITION
condition = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(condition, CONDITION_PARAM_TICKS, 5000)

------OUTRAS
boostcondition = createConditionObject(CONDITION_INFIGHT)
setConditionParam(boostcondition, CONDITION_PARAM_TICKS, 3 * 1000)

fightcondition = createConditionObject(CONDITION_INFIGHT)
setConditionParam(fightcondition, CONDITION_PARAM_TICKS, 18 * 1000)

playerexhaust = createConditionObject(CONDITION_EXHAUST)
setConditionParam(playerexhaust, CONDITION_PARAM_TICKS, 250)

permanentinvisible = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(permanentinvisible, CONDITION_PARAM_TICKS, -1)

function stopNow(cid, time) --function q faz o poke/player ficar imovel por um tempo
    if not isCreature(cid) or not tonumber(time) or isSleep(cid) then 
        return true 
    end
    
    mayNotMove(cid, true)
    if isCreature(cid) then
        addEvent(mayNotMove, time, cid, false)
    end
end


function doCreatureAddCondition(cid, condition)
    if not isCreature(cid) then return true end
    doAddCondition(cid, condition)
end

function doCreatureRemoveCondition(cid, condition)
    if not isCreature(cid) then return true end
    doRemoveCondition(cid, condition)
end

function doAppear(cid) --Faz um poke q tava invisivel voltar a ser visivel...
    if not isCreature(cid) then 
        return true 
    end
    doRemoveCondition(cid, CONDITION_INVISIBLE)
    doRemoveCondition(cid, CONDITION_OUTFIT)
    doCreatureSetHideHealth(cid, false)
end

function doDisapear(cid) --Faz um pokemon ficar invisivel
    if not isCreature(cid) then return true end
    doCreatureAddCondition(cid, CONDITION_INVISIBLE)
    doCreatureSetHideHealth(cid, true)
    doSetCreatureOutfit(cid, {lookType = 34125}, -1)
end

-- Conditions /\ /\ /\ /\
-- Observações
-- Funções para modificar monstros, spells e tudo mais!
-- by PDA, Drazyn1291 e outras pessoas

function getMasterTarget(cid) -- Retorna o target do player
    if isCreature(cid) and getPlayerStorageValue(cid, 21101) ~= -1 then
        return getPlayerStorageValue(cid, 21101) --alterado v1.6
    end
    if isSummon(cid) then
        return getCreatureTarget(getCreatureMaster(cid))
    else
        return getCreatureTarget(cid)
    end
end

function doBodyPush(cid, target, go, pos) -- Pelo oq entendi, puxa o target até o cid
    if not isCreature(cid) or not isCreature(target) then
        doRegainSpeed(cid)
        doRegainSpeed(target)
        return true
    end
    if go then
        local a = getThingPos(cid)
        doChangeSpeed(cid, -getCreatureSpeed(cid))
        if not isPlayer(target) then
            doChangeSpeed(target, -getCreatureSpeed(target))
        end
        doChangeSpeed(cid, 800)
        doTeleportThing(cid, getThingPos(target))
        doChangeSpeed(cid, -800)
        addEvent(doBodyPush, 350, cid, target, false, a)
    else
        doChangeSpeed(cid, 800)
        doTeleportThing(cid, pos)
        doRegainSpeed(cid)
        doRegainSpeed(target)
    end
end

function doRegainSpeed(cid) -- Retorna a speed padrão do monstro, summon ou player!
    if not isCreature(cid) then return true end
    local speed = 150
    if isMonster(cid) then
        speed = speed + poke_status[doCorrectString(getCreatureName(cid))].speed
    elseif isPlayer(cid) then
        speed = 200 + (getPlayerLevel(cid)*2) 
    end
    
    if speed > 1500 then
        speed = 1500
    end
    
    doChangeSpeed(cid, -getCreatureSpeed(cid))
    if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
        doRemoveCondition(cid, CONDITION_PARALYZE)
        addEvent(doAddCondition, 10, cid, paralizeArea2) 
    end
    
    doChangeSpeed(cid, speed)
    return speed
end

function doSendMoveEffect(cid, target, effect) -- Envia um efeito de distância para um monstro
    if not isCreature(cid) or not isCreature(target) then return true end
    doSendDistanceShoot(getThingPos(cid), getThingPos(target), effect)
    return true
end

function doFaceOpposite(cid) -- Vira a criatura a direção oposta, por exemplo, sul vai para norte, norte para sul
    local a = getCreatureLookDir(cid)
    doCreatureSetLookDir(cid, getFaceOpposite(a))
end

function doFaceRandom(cid) -- Muda a direção da creature pra qual quer uma aleatória
    local a = getCreatureLookDir(cid)
    local d = {
        [NORTH] = {SOUTH, WEST, EAST},
        [SOUTH] = {NORTH, WEST, EAST},
        [WEST] = {SOUTH, NORTH, EAST},
    [EAST] = {SOUTH, WEST, NORTH}}
    doChangeSpeed(cid, 1)
    doCreatureSetLookDir(cid, d[a][math.random(1, 3)])
    doChangeSpeed(cid, -1)
end

function getFaceOpposite(dir) -- retorna a posição oposta da direção indicada
    local d = {
        [NORTH] = SOUTH,
        [SOUTH] = NORTH,
        [EAST] = WEST,
        [WEST] = EAST,
        [NORTHEAST] = SOUTHWEST,
        [NORTHWEST] = SOUTHEAST,
        [SOUTHEAST] = NORTHWEST,
        [SOUTHWEST] = NORTHEAST
    }
    return d[dir]
end

function doFaceCreature(sid, pos) -- Muda a direção da criatura para a direção de acordo com a pos indicada
    if not isCreature(sid) then return true end
    if getThingPos(sid).x == pos.x and getThingPos(sid).y == pos.y then return true end
    local ret = 0
    
    local ld = getCreatureLookDir(sid)
    local dir = getDirectionTo(getThingPos(sid), pos)
    local al = {
        [NORTHEAST] = {NORTH, EAST},
        [NORTHWEST] = {NORTH, WEST},
        [SOUTHEAST] = {SOUTH, EAST},
    [SOUTHWEST] = {SOUTH, WEST}}
    
    if dir >= 4 and isInArray(al[dir], ld) then return true end
    
    doChangeSpeed(sid, 1)
    if dir == 4 then
        ret = math.random(2, 3)
    elseif dir == 5 then
        ret = math.random(1, 2)
    elseif dir == 6 then
        local dirs = {0, 3}
        ret = dirs[math.random(1, 2)]
    elseif dir == 7 then
        ret = math.random(0, 1)
    else
        ret = getDirectionTo(getThingPos(sid), pos)
    end
    doCreatureSetLookDir(sid, ret)
    doChangeSpeed(sid, -1)
    return true
end

function getCreatureDirectionToTarget(cid, target) -- Muda a direção de cid para a direção para o target
    if not isCreature(cid) then 
        return true 
    end
    if not isCreature(target) then
        return getCreatureLookDir(cid) 
    end
    local dirs = {
        [NORTHEAST] = {NORTH, EAST},
        [SOUTHEAST] = {SOUTH, EAST},
        [NORTHWEST] = {NORTH, WEST},
        [SOUTHWEST] = {SOUTH, WEST}
    }
    local x = getDirectionTo(getThingPos(cid), getThingPos(target), false)
    if x <= 3 then return x
    else
        local xdistance = math.abs(getThingPos(cid).x - getThingPos(target).x)
        local ydistance = math.abs(getThingPos(cid).y - getThingPos(target).y)
        if xdistance > ydistance then
            return dirs[x][2]
        elseif ydistance > xdistance then
            return dirs[x][1]
        elseif isInArray(dirs[x], getCreatureLookDir(cid)) then
            return getCreatureLookDir(cid)
        else
            return dirs[x][math.random(1, 2)]
        end
    end
end

-- Movements Effects

function markPosEff(sid, pos)
    if not isCreature(sid) then return end
    setPlayerStorageValue(sid, 26547, pos.x)
    setPlayerStorageValue(sid, 26548, pos.y)
    setPlayerStorageValue(sid, 26549, pos.z)
end

function getMarkedPosEff(sid)
    if not isCreature(sid) then return end
    local xx = getPlayerStorageValue(sid, 26547)
    local yy = getPlayerStorageValue(sid, 26548)
    local zz = getPlayerStorageValue(sid, 26549)
    return {x = xx, y = yy, z = zz}
end

function sendMoveEffect(cid, effect, pos)
    if isCreature(cid) then
        if pos then --Functions pro sistema de sair efeito quando magmar/jynx andam e fly porygon
            doSendMagicEffect(pos, effect)
        else
            doSendMagicEffect(getThingPos(cid), effect)
        end
    end
end

function sendAuraEffect(cid, eff) -- Para pokemons com Aura
    ----------------
    if isPlayer(cid) and (getPlayerStorageValue(cid, 17000) <= 0 and getPlayerStorageValue(cid, 17001) <= 0 and getPlayerStorageValue(cid, 63215) <= 0) then
        setPlayerStorageValue(cid, 42368, -1)
        return true
    end
    ---------------- 
    if isCreature(cid) and getCreatureOutfit(cid).lookType ~= 2 then 
        setPlayerStorageValue(cid, 42368, 1)
        doSendMagicEffect(getThingPos(cid), eff)
    end
    ----------------
    if isCreature(cid) then
        addEvent(sendAuraEffect, 3000, cid, eff)
    end
end


function sendMovementEffect(cid, eff, pos) -- Vai ficar mandando um efeito aonde a criatura está
    if isPlayer(cid) then
        if getCreatureOutfit(cid).lookType ~= 667 and getCreatureOutfit(cid).lookType ~= 999 then
            return true
        end
    end
    if isCreature(cid) then
        local nPos = getMarkedPosEff(cid)
        
        if pos.x ~= nPos.x or pos.y ~= nPos.y then
            sendMoveEffect(cid, eff, nPos)
            markPosEff(cid, getThingPos(cid))
        end
        addEvent(sendMovementEffect, 100, cid, eff, getThingPos(cid)) 
    end
end

--------------------------------------------------------------------------------
paralizeArea = createConditionObject(CONDITION_PARALYZE)
setConditionParam(paralizeArea, CONDITION_PARAM_TICKS, 50000) --alterado v1.4
setConditionFormula(paralizeArea, -0.75, -0.75, -0.75, -0.75)
---------------------------------------------------------------------------------
function hasWithReflect(target) --verifica se o poke target esta com reflect...
    if not isCreature(target) then return true end
    if getPlayerStorageValue(target, 21099) >= 1 then
        return true
    end
    return false
end
--------------------------------------------------------------------------------
function sendEffWithProtect(cid, pos, eff) --Manda algum magic effect com proteçoes 
    if not isCreature(cid) then return true end
    if isSleep(cid) then return true end
    local checkpos = pos
    checkpos.stackpos = 0
    if not hasTile(checkpos) then
        return true
    end
    if not canWalkOnPos(pos, false, true, false, true, false) then
        return true
    end
    
    doSendMagicEffect(pos, eff)
end
---------------------------------------------------------------------------------
function doDanoWithProtect(cid, element, pos, area, min, max, eff) --Da dano com proteçoes
    if not isCreature(cid) then 
        return true 
    end
    if isSleep(cid) then 
        return true 
    end
    doAreaCombatHealth(cid, element, pos, area, min, max, eff)
end

function notHasMimicWall(cid, pos) --Verifica se tem mimic wall na pos
    if not hasTile(pos) then return true end
    
    local p = getThingPos(cid)
    local tileP = getTileThingByPos({x=p.x,y=p.y,z=p.z,stackpos=0}).actionid
    local tile = getTileThingByPos(pos).actionid
    if tileP == 88070 and tile == 88071 then
        return false
    elseif tileP == 88071 and tile == 88070 then
        return false
    elseif tile == 88072 then
        return false
    end
    
    return true
end
---------------------------------------------------------------------------------
function sendMoveBack(cid, pos, eff, min, max) --Manda o Atk do farfetchd de volta...
    local m = #pos+1
    for i = 1, #pos do
        if not isCreature(cid) then return true end
        if isSleep(cid) then return true end
        ---
        m = m-1
        thing = {x=pos[m].x,y=pos[m].y,z=pos[m].z,stackpos=253}
        local pid = getThingFromPosWithProtect(thing)
        addEvent(doMoveDano, i*200, cid, pid, "Stick Throw", FLYINGDAMAGE, min/4, max/4, 0, 0) 
        addEvent(sendEffWithProtect, i*200, cid, pos[m], eff) --alterado v1.3
        -- 
    end
end 
---------------------------------------------------------------------------------
function upEffect(cid, effDis)
    pos = getThingPos(cid)
	if pos then
		frompos = {x = pos.x+1, y = pos.y, z = pos.z}
		frompos.x = pos.x - math.random(4, 7) --alterado v1.4
		frompos.y = pos.y - math.random(5, 8)
		doSendDistanceShoot(getThingPos(cid), frompos, effDis)
	end
end
---------------------------------------------------------------------------------
function fall(cid, master, element, effDis, effArea) --Function pra jogar efeitos pra cima e cair depois... tpw falling rocks e blizzard
    if isCreature(cid) then
        if isSleep(cid) then 
            return true 
        end
        pos = getThingPos(cid)
        pos.x = pos.x + math.random(-4,4)
        pos.y = pos.y + math.random(-4,4)
        if isMonster(cid) or isPlayer(cid) then
            frompos = {x = pos.x+1, y = pos.y, z = pos.z}
        elseif isSummon(cid) then
            frompos = getThingPos(master)
        end
        frompos.x = pos.x - 7
        frompos.y = pos.y - 6
        if effDis ~= -1 then --alterado v1.4
            doSendDistanceShoot(frompos, pos, effDis)
        end
        doAreaCombatHealth(cid, element, pos, 0, 0, 0, effArea)
    end
end
---------------------------------------------------------------------------------
function doMissSyst(target, rounds, effect, check, condution) --Sistem de 'MISS'
    if not isCreature(target) then return true end
    if getPlayerStorageValue(target, 21099) >= 1 then return true end --reflect
    
    if check and check ~= getPlayerStorageValue(target, 32659) then return true end
    
    if not check and getPlayerStorageValue(target, 32659) >= 1 then
        setPlayerStorageValue(target, 32659, getPlayerStorageValue(target, 32659) + rounds - 1)
    else
        setPlayerStorageValue(target, 32659, getPlayerStorageValue(target, 32659) + rounds)
    end
    
    local a = getPlayerStorageValue(target, 32659)
    --alterado!!
    if isSummon(target) then
        local item = getPlayerSlotItem(getCreatureMaster(target), 8)
        doItemSetAttribute(item.uid, "missSyst", a)
        doItemSetAttribute(item.uid, "missEff", effect)
        doItemSetAttribute(item.uid, "missCond", condution)
    end
    
    if a <= -1 then 
        doRemoveCondition(target, CONDITION_PARALYZE)
        addEvent(doRegainSpeed, 50, target)
        setPlayerStorageValue(target, 32659, -1) --alterado v1.4
        return true 
    end
    
    if condution == 1 and getCreatureCondition(target, CONDITION_PARALYZE) == false and rounds ~= -1 then
        doAddCondition(target, paralizeArea) --alterado v1.4
    end
    doSendMagicEffect(getThingPos(target), effect)
    
    addEvent(doMissSyst, 1000, target, -1, effect, a, condution)
end
---------------------------------------------------------------------------------
function canDoMiss(cid, nameAtk) --Verifica se pode da o efeito de 'MISS' no pokemon alvo
    local atkTerra = {"Sand Attack", "Mud Shot", "Mud Bomb", "Sludge", "Sludge Rain", "Stomp", "Crusher Stomp", "Mud Slap", "Muddy Water"} --alterado v1.3
    local atkElectric = {"Electric Storm", "Thunder Wave", "Thunder"}
    if not isCreature(cid) then return false end
    if isPlayer(cid) then return true end
    if not poke_status[getCreatureName(cid)] then return true end
    
    if isInArray(atkTerra, nameAtk) then
        if (poke_status[getCreatureName(cid)].type1 == "flying") or (poke_status[getCreatureName(cid)].type2 == "flying") then
            return false 
        end
    elseif isInArray(atkElectric, nameAtk) then
        if (poke_status[getCreatureName(cid)].type1 == "ground") or (poke_status[getCreatureName(cid)].type2 == "ground") then
            return false 
        end
    end
    
    return true
end
---------------------------------------------------------------------------------
function doMoveInAreaWithMiss(cid, area, eff, cd, nameAtk, cond, element, min, max) --Da um atk q deixa os pokes alvos com efeito de 'MISS'
    if not isCreature(cid) then return true end
    if nameAtk and nameAtk == "Mud Bomb" then
        pos = getPosfromArea(getMasterTarget(cid), area)
    else
        pos = getPosfromArea(cid, area) 
    end
    n = 0
    eff2 = eff
    
    while n < #pos do
        if not isCreature(cid) then return true end
        if isSleep(cid) then return true end
        if getPlayerStorageValue(cid, 3894) >= 1 then return true end
        
        n = n+1
        thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
        
        local pid = getThingFromPosWithProtect(thing)
        
        if nameAtk == "Sand Attack" then
            addEvent(sendEffWithProtect, n*200, cid, pos[n], eff)
            eff2 = 34
        elseif nameAtk == "Thunder Wave" then
            sendEffWithProtect(cid, pos[n], eff)
        elseif nameAtk == "Poison Gas" then
            sendEffWithProtect(cid, pos[n], eff)
            eff2 = 34
        elseif nameAtk == "Thunder" then
            sendEffWithProtect(cid, pos[n], eff)
        elseif nameAtk == "Hyper Voice" then
            sendEffWithProtect(cid, pos[n], eff)
        elseif nameAtk == "Mud Bomb" then
            sendEffWithProtect(cid, pos[n], eff)
            eff2 = 34
        elseif nameAtk == "Aurora Beam" then
            eff2 = 43 --alterado v1.4
        elseif nameAtk == "SmokeScreen" then --alterado v1.4
            sendEffWithProtect(cid, pos[n], eff)
        elseif nameAtk == "Stomp" or nameAtk == "Crusher Stomp" then
            sendEffWithProtect(cid, pos[n], 118)
        elseif nameAtk == "Icy Wind" then
            sendEffWithProtect(cid, pos[n], 17)
        elseif nameAtk == "Muddy Water" or nameAtk == "Venom Motion" then
            eff2 = 34
            local arr = {
                [1] = 0, [2] = 0, [3] = 0, [4] = 200, [5] = 200, [6] = 200, [7] = 400, [8] = 400, [9] = 400, [10] = 600, [11] = 600,
                [12] = 600, [13] = 800, [14] = 800, [15] = 800
            }
            
            local time = {0, 200, 400, 600, 800}
            
            addEvent(sendEffWithProtect, arr[n], cid, pos[n], eff)
            addEvent(doMoveDano, arr[n], cid, pid, nameAtk, element, min, max, 0, cd, eff2, cond)
            
        elseif nameAtk == "Squisky Licking" or nameAtk == "Lick" then
            eff2 = 2
            sendEffWithProtect(cid, pos[n], eff)
        elseif nameAtk == "Stun Spore" then
            eff2 = 2
            sendEffWithProtect(cid, pos[n], eff)
        elseif nameAtk == "Cotton Spore" then --alterado v1.4
            eff2 = 2
            sendEffWithProtect(cid, pos[n], eff)
        end 
        
        if nameAtk ~= "Muddy Water" and nameAtk ~= "Venom Motion" then
            doMoveDano(cid, pid, nameAtk, element, min, max, 0, cd, eff2, cond)
        end
    end
end 
---------------------------------------------------------------------------------
function doMoveInArea(cid, rounds, eff, area, min, max, element, spell) --Da um atk 'normal' e tb pode da um atk q deixa os pokes alvos com efeito de 'Confuso'
    if not isCreature(cid) then return true end
    local skills = {"Skull Bash", "Gust", "Ground Chop", "Water Pulse", "Stick Throw", "Overheat", "Toxic", "Take Down"}
    --alterado v1.4
    local pos = getPosfromArea(cid, area)
    local n = 0
    local l = 0
    
    while n < #pos do
        if not isCreature(cid) then return true end 
        if isSleep(cid) then return true end
        
        n = n+1
        if notHasMimicWall(cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=0}) then
            thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
            
            local pid = getThingFromPosWithProtect(thing)
            
            if spell and isInArray(skills, spell) then
                if spell == "Stick Throw" then
                    addEvent(sendEffWithProtect, l*300, cid, pos[n], eff)
                    addEvent(sendMoveBack, 1200, cid, pos, eff, min, max)
                    addEvent(doMoveDano, l*300, cid, pid, spell, element, min, max, rounds, 0) 
                else
                    addEvent(sendEffWithProtect, l*200, cid, pos[n], eff)
                    addEvent(doMoveDano, l*200, cid, pid, spell, element, min, max, rounds, 0) 
                end
            elseif spell and spell == "Epicenter" then
                local random = math.random(50, 500) 
                addEvent(sendEffWithProtect, random, cid, pos[n], eff)
                addEvent(doDanoWithProtect, random, cid, GROUNDDAMAGE, pos[n], crusher, -min, -max, 255)
            elseif spell and spell == "Shadowave" then
                posi = {x=pos[n].x, y=pos[n].y+1, z=pos[n].z}
                sendEffWithProtect(cid, posi, eff) --alterado v1.4
                doMoveDano(cid, pid, spell, element, min, max, rounds, 0) 
            elseif spell and spell == "Surf" then
                addEvent(sendEffWithProtect, math.random(50, 500), cid, pos[n], eff) --alterado v1.4
            else
                sendEffWithProtect(cid, pos[n], eff)
                doMoveDano(cid, pid, spell, element, min, max, rounds, 0) 
            end
            l = l+1
        end
    end 
end 
---------------------------------------------------------------------------------
function doMoveInAreaMulti(cid, effDis, effMagic, areaEff, areaDano, element, min, max)
    if not isCreature(cid) then return true end --Da um atk com efeito tpw Multi-Kick e Bullet Seed
    local pos = getPosfromArea(cid, areaEff)
    local pos2 = getPosfromArea(cid, areaDano)
    local n = 0
    
    while n < #pos2 do
        if not isCreature(cid) then return true end
        if isSleep(cid) then return true end
        if getPlayerStorageValue(cid, 3894) >= 1 then return true end
        
        n = n+1
        thing = {x=pos2[n].x,y=pos2[n].y,z=pos2[n].z,stackpos=253}
        if n < #pos then
            addEvent(sendDistanceShootWithProtect, n*50, cid, getThingPos(cid), pos[n], effDis) --39
            addEvent(sendEffWithProtect, n*50, cid, pos[n], effMagic) -- 112
        end 
        local pid = getThingFromPosWithProtect(thing)
        if isCreature(pid) then
            doMoveDano(cid, pid, "", element, min, max, 0, 0)
        end
    end 
end 

function doSilenceInArea(cid, area, cd, eff)
    if not isCreature(cid) then return true end
    local pos = getPosfromArea(cid, area)
    local n = 0
    --alterado v1.4
    while n < #pos do
        if not isCreature(cid) then return true end
        if isSleep(cid) then return true end
        if getPlayerStorageValue(cid, 3894) >= 1 then return true end
        n = n+1
        thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
        local pid = getThingFromPosWithProtect(thing)
        
        if isCreature(pid) then 
            if isSummon(cid) and (isMonster(pid) or (isSummon(pid) and canAttackOther(cid, pid) == true) or (isPlayer(pid) and canAttackOther(cid, pid) == true and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
                doSilence(pid, cd, eff, getPlayerStorageValue(pid, 32698))
            elseif isMonster(cid) and (isSummon(pid) or (isPlayer(pid) and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
                doSilence(pid, cd, eff, getPlayerStorageValue(pid, 32698))
            elseif isPlayer(cid) and ehMonstro(pid) and pid ~= cid then
                doSilence(pid, cd, eff, getPlayerStorageValue(pid, 32698))
            end
        end
    end
end
---------------------------------------------------------------------------------
function doMoveDano(cid, pid, nameAtk, element, min, max, rounds, cd, eff2, cond) --Function pra da dano nas spells
    if isCreature(pid) and isCreature(cid) then
        local str = getPlayerStorageValue(pid, 21099)
        if isSleep(cid) then return true end
        if getPlayerStorageValue(cid, 3894) >= 1 then return true end
        if isSummon(cid) and (isMonster(pid) or isSummon(pid) or isPlayer(pid)) and pid ~= cid then 
            if isSummon(pid) then
                if rounds ~= 0 and str <= 0 and canAttackOther(cid, pid) == true then
                    addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891), cid)
                end
                if cd ~= 0 and canDoMiss(pid, nameAtk) and canAttackOther(cid, pid) == true then
                    doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
                end
                doTargetCombatHealth(cid, pid, element, -min, -max, 255)
            elseif isMonster(pid) then
                if rounds ~= 0 and str <= 0 then
                    addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
                end
                if cd ~= 0 and canDoMiss(pid, nameAtk) then
                    doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
                end
                doTargetCombatHealth(cid, pid, element, -min, -max, 255)
            elseif isPlayer(pid) and #getCreatureSummons(pid) <= 0 then
                if canAttackOther(cid, pid) == false then return true end --edited
                if rounds ~= 0 and str <= 0 and canAttackOther(cid, pid) == true then
                    addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891), cid)
                end
                if cd ~= 0 and canAttackOther(cid, pid) == true then
                    doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
                end
                doTargetCombatHealth(cid, pid, element, -min, -max, 255)
            end
        elseif isMonster(cid) and (isSummon(pid) or isPlayer(pid)) and pid ~= cid then
            if isPlayer(pid) and #getCreatureSummons(pid) <= 0 then
                if rounds ~= 0 and str <= 0 then
                    addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
                end
                if cd ~= 0 then
                    doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
                end
                doTargetCombatHealth(cid, pid, element, -min, -max, 255) 
            elseif isSummon(pid) then
                if rounds ~= 0 and str <= 0 then
                    addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
                end
                if cd ~= 0 and canDoMiss(pid, nameAtk) then
                    doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
                end
                doTargetCombatHealth(cid, pid, element, -min, -max, 255) 
            end 
        elseif isPlayer(cid) and isMonster(pid) then
            if rounds ~= 0 and str <= 0 then
                addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
            end
            if cd ~= 0 and canDoMiss(pid, nameAtk) then
                doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
            end
            doTargetCombatHealth(cid, pid, element, -min, -max, 255) 
        end
    end 
end

function doMoveInArea2(cid, eff, area, element, min, max, spell, ret)
    if not isCreature(cid) then return true end
    
    local pos = getPosfromArea(cid, area) --alterado v1.8
    setPlayerStorageValue(cid, 21101, -1) 
    
    local skills = {"Skull Bash", "Gust", "Water Pulse", "Stick Throw", "Overheat", "Toxic", "Take Down", "Gyro Ball"} --alterado v1.7
    local n = 0 
    local l = 0
    
    while n < #pos do
        if not isCreature(cid) then return true end 
        if isSleep(cid) then return true end 
        
        n = n+1
        thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
        local pid = getThingFromPosWithProtect(thing)
        ----
        if pid ~= cid then
            if spell and isInArray(skills, spell) then
                if spell == "Stick Throw" then
                    addEvent(sendEffWithProtect, l*300, cid, pos[n], eff)
                    addEvent(sendMoveBack, 1200, cid, pos, eff, min, max)
                    addEvent(doMoveDano2, l*300, cid, pid, element, min, max, ret, spell) --alterado v1.6 
                elseif spell and spell == "Gyro Ball" then --alterado v1.7
                    pos[n].x = pos[n].x+1
                    addEvent(sendEffWithProtect, l*200, cid, pos[n], eff)
                    addEvent(doMoveDano2, l*200, cid, pid, element, min, max, ret, spell) 
                else
                    addEvent(sendEffWithProtect, l*200, cid, pos[n], eff)
                    addEvent(doMoveDano2, l*200, cid, pid, element, min, max, ret, spell) --alterado v1.6 
                end
            elseif spell and spell == "Epicenter" then
                local random = math.random(50, 500) 
                addEvent(sendEffWithProtect, random, cid, pos[n], eff)
                addEvent(doDanoWithProtect, random, cid, GROUNDDAMAGE, pos[n], crusher, -min, -max, 255)
            elseif spell and spell == "Shadowave" then
                posi = {x=pos[n].x, y=pos[n].y+1, z=pos[n].z}
                sendEffWithProtect(cid, posi, eff)
                doMoveDano2(cid, pid, element, min, max, ret, spell) --alterado v1.6 
            elseif spell and spell == "Surf" then
                addEvent(sendEffWithProtect, math.random(50, 500), cid, pos[n], eff)
                addEvent(doMoveDano2, 400, cid, pid, element, min, max, ret, spell) --alterado v1.6 
            elseif spell and spell == "Sand Attack" then
                addEvent(sendEffWithProtect, n*200, cid, pos[n], eff)
                addEvent(doMoveDano2, n*200, cid, pid, element, min, max, ret, spell) --alterado v1.6 
            elseif spell and (spell == "Muddy Water" or spell == "Venom Motion") then
                local arr = {
                    [1] = 0, [2] = 0, [3] = 0, [4] = 200, [5] = 200, [6] = 200, [7] = 400, [8] = 400, [9] = 400, [10] = 600, [11] = 600,
                    [12] = 600, [13] = 800, [14] = 800, [15] = 800
                }
                
                local time = {0, 200, 400, 600, 800}
                
                addEvent(sendEffWithProtect, arr[n], cid, pos[n], eff)
                addEvent(doMoveDano2, arr[n], cid, pid, element, min, max, ret, spell)
            elseif spell and (spell == "Inferno" or spell == "Fissure" or spell == "Volcano Burst") then --alterado v1.8
                addEvent(sendEffWithProtect, math.random(0, 500), cid, pos[n], eff)
                addEvent(doMoveDano2, math.random(0, 500), cid, pid, element, min, max, ret, spell) 
            else
                sendEffWithProtect(cid, pos[n], eff)
                doMoveDano2(cid, pid, element, min, max, ret, spell) 
            end
        end
        l = l+1
    end
end

function doMoveDano2(cid, pid, element, min, max, ret, spell)
    if isCreature(pid) and isCreature(cid) and cid ~= pid then
        if isNpcSummon(pid) and getCreatureTarget(pid) ~= cid then
            return true --alterado v1.6
        end
        if ehNPC(pid) then return true end
        ---
        local canAtk = true --alterado v1.6
        if getPlayerStorageValue(pid, 21099) >= 1 then
            doSendMagicEffect(getThingPosWithDebug(pid), 135)
            doSendAnimatedText(getThingPosWithDebug(pid), "REFLECT", COLOR_GRASS)
            addEvent(docastspell, 100, pid, spell)
            if getCreatureName(pid) == "Wobbuffet" then
                doRemoveCondition(pid, CONDITION_OUTFIT) 
            end
            canAtk = false
            setPlayerStorageValue(pid, 21099, -1)
            setPlayerStorageValue(pid, 21100, 1)
            setPlayerStorageValue(pid, 21101, cid)
            setPlayerStorageValue(pid, 21103, getTableMove(cid, getPlayerStorageValue(cid, 21102)).f)
        end
        --- 
        if isSleep(cid) then return true end
        if isSummon(cid) and (ehMonstro(pid) or (isSummon(pid) and canAttackOther(cid, pid) == true) or (isPlayer(pid) and canAttackOther(cid, pid) == true and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
            if canAtk then --alterado v1.6
                if ret and ret.cond then
                    ret.id = pid
                    ret.check = getPlayerStorageValue(pid, conds[ret.cond])
                    doCondition2(ret)
                end
                if spell == "Selfdestruct" then
                    if getPlayerStorageValue(pid, 9658783) <= 0 then
                        doSendAnimatedText(getThingPosWithDebug(pid), "-"..max.."", COLOR_NORMAL)
                        doCreatureAddHealth(pid, -max) --alterado v1.6
                    end
                else
                    doTargetCombatHealth(cid, pid, element, -(math.abs(min)), -(math.abs(max)), 255)
                end
            end
        elseif ehMonstro(cid) and (isSummon(pid) or (isPlayer(pid) and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
            if canAtk then --alterado v1.6
                if ret and ret.cond then
                    ret.id = pid
                    ret.check = getPlayerStorageValue(pid, conds[ret.cond])
                    doCondition2(ret)
                end
                if spell == "Selfdestruct" then
                    if getPlayerStorageValue(pid, 9658783) <= 0 then
                        doSendAnimatedText(getThingPosWithDebug(pid), "-"..max.."", COLOR_NORMAL)
                        doCreatureAddHealth(pid, -max) --alterado v1.6
                    end
                else
                    doTargetCombatHealth(cid, pid, element, -(math.abs(min)), -(math.abs(max)), 255)
                end
            end
        elseif isPlayer(cid) and ehMonstro(pid) and pid ~= cid then
            if canAtk then --alterado v1.6
                if ret and ret.cond then
                    ret.id = pid
                    ret.check = getPlayerStorageValue(pid, conds[ret.cond])
                    doCondition2(ret)
                end
                if spell == "Selfdestruct" then
                    if getPlayerStorageValue(pid, 9658783) <= 0 then
                        doSendAnimatedText(getThingPosWithDebug(pid), "-"..max.."", COLOR_NORMAL)
                        doCreatureAddHealth(pid, -max) --alterado v1.6
                    end
                else
                    doTargetCombatHealth(cid, pid, element, -(math.abs(min)), -(math.abs(max)), 255)
                end
            end
        end
    end
end

function getThingPosWithDebug(what)
    if not isCreature(what) or getCreatureHealth(what) <= 0 then
        return {x = 1, y = 1, z = 10}
    end
    return getThingPos(what)
end

function doDanoWithProtectWithDelay(cid, target, element, min, max, eff, area)
    const_distance_delay = 56
    if not isCreature(cid) then return true end
    if isSleep(cid) then return true end
    if target ~= 0 and isCreature(target) and not area then
        delay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) * const_distance_delay
        addEvent(doDanoWithProtect, delay, cid, element, getThingPosWithDebug(target), 0, min, max, eff)
        return true
    end
    addEvent(doDanoWithProtect, 200, cid, element, getThingPosWithDebug(target), area, min, max, eff)
end 

function sendDistanceShootWithProtect(cid, frompos, topos, eff) --Manda um efeito de distancia com proteçoes
    if not isCreature(cid) then return true end
    if isSleep(cid) then return true end
    doSendDistanceShoot(frompos, topos, eff)
end

function doDoubleHit(cid, pid, valor, races) --alterado v1.6
    if isCreature(cid) and isCreature(pid) then
        if getPlayerStorageValue(cid, 374896) >= 1 then
            if getMasterTarget(cid) == pid then
                if isInArray({"Kadabra", "Alakazam", "Mew", "Shiny Abra", "Shiny Alakazam"}, getCreatureName(pid)) then
                    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(pid), 39)
                end
                if isSummon(cid) then
                    doTargetCombatHealth(getCreatureMaster(cid), pid, PHYSICALDAMAGE, -math.abs(valor), -math.abs(valor), 255)
                else
                    doCreatureAddHealth(pid, -math.abs(valor), 3, races[getMonsterInfo(getCreatureName(pid)).race].cor)
                end
            end
        end
    end
end

function doDanoInTarget(cid, target, combat, min, max, eff) --alterado v1.7
    if not isCreature(cid) or not isCreature(target) then return true end
    if isSleep(cid) then return true end
    doTargetCombatHealth(cid, target, combat, -math.abs(min), -math.abs(max), eff)
end 

function doDanoInTargetWithDelay(cid, target, combat, min, max, eff) --alterado v1.7
    const_distance_delay = 56
    if not isCreature(cid) or not isCreature(target) then return true end
    if isSleep(cid) then return true end
    local delay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) * const_distance_delay
    addEvent(doDanoInTarget, delay, cid, target, combat, min, max, eff)
end