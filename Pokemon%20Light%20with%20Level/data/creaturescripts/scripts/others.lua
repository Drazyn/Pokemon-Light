local channels = {
    [5] = {txt = "(GC) Lembrete Rapido: Este canal e apenas para CONVERSAS CASUAIS e SOCIALIZACAO. Negociacoes e spam/flood sao proibidas neste canal, e respeito e educacao sao essenciais. Siga as regras para nao ser mutado"}, -- GameChat
    [6] = {txt = "(Trade) Lembrete Rapido: Este canal e apenas para TROCAS de itens relacionados ao jogo ou FORMACAO DE TIMES. Qualquer coisa alem disso pode ocasionar um mute ou banimento."}, -- Trade
    [9] = {txt = "(Help) Lembrete Rapido: Este canal e apenas para AJUDA. Faca sua pergunta educadamente, ou no caso se voce estiver respondendo, seja claro e objetivo. Spoils sao proibidos."}, -- Help
}

-- [ChannelID] = {txt = Texto que irá aparecer},

function onJoinChannel(cid, channelId, users)
    local t = channels[channelId]

    if t then
        addEvent(doPlayerSendChannelMessage, 150, cid, "", t.txt, TALKTYPE_CHANNEL_W, channelId)
    end
    return true
end

local function isInvited(houseId, playerName)
    if(string.find(string.lower(getHouseAccessList(houseId, 0x100)), playerName) or string.find(string.lower(getHouseAccessList(houseId, 0x101)), playerName)) then
        return true
    end

    return false
end

function onMoveItem(cid, item, fromPosition, toPosition, fromItem, toItem, fromGround, toGround, status)
	if isPokeballUse(item.itemid) then
		doPlayerSendCancel(cid, "Not is possible.")
		return false
	end
	position = toPosition
    if((getPlayerGroupId(cid) < 6) and (getTileInfo(position).house) and (getHouseOwner(getHouseFromPos(position)) ~= getPlayerGUID(cid)) and (not isInvited(getHouseFromPos(position), string.lower(getCreatureName(cid))))) then
        doPlayerSendCancel(cid, "You cannot throw there.")
    else
        return true
    end
	return true
end