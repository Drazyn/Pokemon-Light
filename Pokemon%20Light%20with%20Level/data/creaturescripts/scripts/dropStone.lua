local config = {
    ids = {},                        --ID do item.
    drop_effect = 101                    --Efeito que aparecerá em cima da corpse (apenas para o dono da corpse). OPCIONAL! Se não quiser, coloque false.
}
 
function examine(cid, position, corpse_id, name)
    if not isPlayer(cid) then return true end
    local corpse = getTileItemById(position, corpse_id).uid
    
    if corpse <= 1 or not isContainer(corpse) then return true end
 
    for slot = 0, getContainerSize(corpse) - 1 do
        local item = getContainerItem(corpse, slot)
        if item.uid <= 1 then return true end
        
        if isInArray(config.ids, item.itemid) then
        	if item.type > 1 then
            	doPlayerSendTextMessage(cid, 17, "You have dropped ".. item.type .." ".. getItemNameById(item.itemid).. "s of ".. name .. "!")
            else
            	doPlayerSendTextMessage(cid, 17, "You have dropped 1 ".. getItemNameById(item.itemid).. " of ".. name .. "!")
            end
            doSendMagicEffect(position, 104, cid)
            if #getCreatureSummons(cid) >= 1 then
            	doSendMagicEffect(getCreaturePosition(getCreatureSummons(cid)[1]), 103, cid)
            end
        end
    end
end
 
function onKill(cid, target)
    if not isMonster(target) then return true end
    local monster_name = getCreatureName(target)
    
    local corpse_id = getMonsterInfo(monster_name).lookCorpse
    addEvent(examine, 5, cid, getThingPos(target), corpse_id, monster_name)
    return true
end 