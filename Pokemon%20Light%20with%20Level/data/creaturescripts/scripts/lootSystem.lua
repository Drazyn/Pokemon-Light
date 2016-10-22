function getCorpseItems(corpse)
	if corpse.uid > 0 and isContainer(corpse.uid) then
		items = {}
		for x = 1, getContainerSize(corpse.uid) do
			local itens = getContainerItem(corpse.uid, x)
			if itens and itens.uid > 0 and itens.itemid ~= 0 then
				table.insert(items, {i=itens.itemid, q=itens.type})
			end
		end
		return items
	end
end

function onKill(cid, target)
	if isMonster(target) then
		local pos = getCreaturePosition(target)
		local name = getCreatureName(target)
		local level = getCreatureLevel(target)
		local GlobalLoot = false
		addEvent(function()
			local corpse = getTopCorpse(pos)
			if corpse.uid > 0 and isContainer(corpse.uid) then
				items = getCorpseItems(corpse)
				if #items > 0 then
					itemsss = {}
					for i = 1, #items do
						quant = items[i].q
						if quant < 1 then
							quant = 1
						end
						if isInArray(RareLoots, items[i].i) then
							GlobalLoot = true
						end
						table.insert(itemsss, i, getItemNameById(items[i].i).." (".. quant ..")")
					end
					itemsname = doConcatTable(itemsss, ", ", " and ")
				else
					itemsname = "nothing"
				end
				msg = "Loot of "..name.." ("..level.."): "..itemsname.."."
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, msg)
				if GlobalLoot then
					doPlayerSendChannelMessage(cid, "GLOBAL", getCreatureName(cid).." killed "..name.." and won the following items: "..itemsname, TALKTYPE_CHANNEL_W, 12)
				else
					doPlayerSendChannelMessage(cid, "", msg, TALKTYPE_CHANNEL_O, 12)
				end
			end			
		end, 5)
	end
	return true
end