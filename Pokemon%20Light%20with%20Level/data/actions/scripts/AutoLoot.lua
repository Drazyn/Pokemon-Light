function onUse(cid, item, frompos, item2, topos)
    if getItemAttribute(item.uid, "ownercorpse") ~= getPlayerGUID(cid) then
        doPlayerSendCancel(cid, "You're not the owner.")
        return true
    end
    if getPlayerStorageValue(cid, 4919) < 1 then
        return false
    else
        local items = {}
        for x=0, (getContainerSize(item.uid)) do
            local itens = getContainerItem(item.uid, 0)
            if itens and itens.uid > 0 and itens.itemid ~= 0 then
                table.insert(items, {i=itens.itemid, q=itens.type})
                doRemoveItem(itens.uid)
            end
        end
        for y=1, #items do
            doPlayerAddItemStacking(cid, items[y].i, items[y].q)
            doPlayerSendTextMessage(cid, 20, "Looted "..items[y].q.."x "..getItemNameById(items[y].i)..".")
        end
        if #items > 0 then
            return true
        else
            return false
        end
    end
end