function onPush(cid, target)
	if cid ~= target then
		if getPlayerStorageValue(target, 3123) ~= -1 then
			doPlayerSendCancel(cid, "Voc� n�o pode empurrar esse player!")
			return false
		end
	end
	return true
end

function onCombat(cid, target)
	if isPlayer(target) then
		if getPlayerStorageValue(target, 3123) ~= -1 then
			return false
		end
	end
	return true
end